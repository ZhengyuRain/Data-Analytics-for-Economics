


* regressions1_nyc.do

* CHANGED TO DO LOGS!!!

log using $logdir/regressions_prepost, text replace

clear
set more off
set mem 15g

use $bigdatadir/working/nyc/setup_daily
ge ny=1
append using $bigdatadir/working/bos/setup_daily
append using $bigdatadir/working/phi/setup_daily
replace ny=0 if ny==.


* Explanatory vars:

ge law=ny*after_nyc
global lawvars "law"

global demog "pop25* white* black* asian* hisp* age* male* female* avg* med*"
global business "n_* worker*"

ge temp2 = temp^2
ge precip2 = precip^2
global weather "temp temp2 precip precip2"

drop if holiday==1

* Regressions, single $lawvars dummy:

ge calperday = calsper1T * txsperday 

ge log_calperday =log(calperday)

xi: areg log_calperday $lawvars i.txdow i.txweek $weather, absorb(store) vce(robust)
xi: areg calperday $lawvars i.txdow i.txweek $weather, absorb(store) vce(robust)

bysort store: egen days_pre=total(1-after_nyc)
bysort store: egen days_post=total(after_nyc)
bysort store: egen sum_calperday_pre=total(calperday * (1-after_nyc))
bysort store: egen sum_calperday_post=total(calperday * after_nyc)
bysort store: egen sum_calpertx_pre=total(calsper1T * (1-after_nyc))
bysort store: egen sum_calpertx_post=total(calsper1T * after_nyc)

sort store after_nyc
drop if store==store[_n-1] & after_nyc==after_nyc[_n-1]

ge calperday_pre = sum_calperday_pre/days_pre
ge calperday_post = sum_calperday_post/days_post 
ge calpertx_pre = sum_calpertx_pre/days_pre
ge calpertx_post = sum_calpertx_post/days_post

ge log_calperday_pre=log(calperday_pre)
ge log_calperday_post=log(calperday_post)
ge log_calpertx_pre=log(calpertx_pre)
ge log_calpertx_post=log(calpertx_post)

ge diff_calperday=calperday_post-calperday_pre
ge diff_calpertx=calpertx_post-calpertx_pre
ge diff_log_calperday=log_calperday_post-log_calperday_pre
ge diff_log_calpertx=log_calpertx_post-log_calpertx_pre

reg diff_calperday law
reg diff_log_calperday law
reg diff_calpertx law
reg diff_log_calpertx law

log close



