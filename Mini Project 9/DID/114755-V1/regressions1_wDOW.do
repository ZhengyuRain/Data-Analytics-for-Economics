
* regressions1_nyc.do

*log using $logdir/regressions1_wDOW, text replace

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


global demog "pop25* white* black* asian* hisp* age* male* female* avg* med*"
global business "n_* worker*"

ge temp2 = temp^2
ge precip2 = precip^2
global weather "temp temp2 precip precip2"

drop if holiday==1

sort txyear txmonth txday
merge txyear txmonth txday using $datadir/working/dow
drop if _merge==2
drop _merge 

replace open=0 if open==.

ge lawopen=law*open/1000
ge nyopen=(zone==16)*open/1000
ge bosopen=(zone==15)*open/1000
ge phiopen=(zone==51)*open/1000

ge lawopenchange=law*open_change/1000
ge nyopenchange=(zone==16)*open_change/1000
ge bosopenchange=(zone==15)*open_change/1000
ge phiopenchange=(zone==51)*open_change/1000

egen maxtxdate=max(txdate)
ge lawdate=mdy($postingdate_nyc)
ge t1=(txdate-lawdate)/(maxtxdate-lawdate)
ge t2=((txdate-lawdate)/(maxtxdate-lawdate))^2

ge t1ny=ny*t1
ge t2ny=ny*t2
ge t1law=law*t1
ge t2law=law*t2

global lawvars "law t1law t2law"

*xi: areg calsper1T i.law*i.txdow i.txweek $weather, absorb(store), if txdow>0 & txdow<6
*xi: areg calsper1T i.law*i.txdow i.txweek $weather t1* t2*, absorb(store), if txdow>0 & txdow<6

*xi: areg calsper1T $lawvars i.law*i.txdow lawopen nyopen bosopen phiopen lawopenchange nyopenchange bosopenchange phiopenchange i.txweek $weather, absorb(store), if txdow>0 & txdow<6
xi: areg calsper1T $lawvars i.txweek $weather, absorb(store)




