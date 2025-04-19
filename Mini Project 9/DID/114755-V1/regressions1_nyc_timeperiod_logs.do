

* regressions1_nyc.do

log using $logdir/regressions1_nyc_timeperiod_logs, text replace

clear
set more off
set mem 15g

use $bigdatadir/working/nyc/setup_daily_timeperiod_txs
ge ny=1
append using $bigdatadir/working/bos/setup_daily_timeperiod_txs
append using $bigdatadir/working/phi/setup_daily_timeperiod_txs
replace ny=0 if ny==.


* Explanatory vars:



global currentcity nyc

sort zone txyear txmonth txday
merge zone txyear txmonth txday using $datadir/working/weather
tab _merge
drop if _merge==2
drop _merge

sort txyear txmonth txday
merge txyear txmonth txday using ../data/working/holidays
tab _merge
drop if _merge==2
drop _merge
replace holiday=0 if holiday==.

drop if holiday


* Explanatory vars:

global demog "pop25* white* black* asian* hisp* age* male* female* avg* med*"

ge temp2 = temp^2
ge precip2 = precip^2
global weather "temp temp2 precip precip2"

global business "n_* worker*"


ge law=ny*after_nyc
global lawvars "i.law*i.timeperiod"

drop if holiday==1


replace calsper1T=log(calsper1T)
replace calsper1Tdrinks=log(calsper1Tdrinks)
replace calsper1Tsnacks=log(calsper1Tsnacks)
replace itemsper1T=log(itemsper1T)
replace itemsper1Tdrinks=log(itemsper1Tdrinks)
replace itemsper1Tsnacks=log(itemsper1Tsnacks)

* Regressions, single $lawvars dummy:



xi: areg calsper1T $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1T 
xi: areg calsper1Tdrinks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1Tdrinks 
xi: areg calsper1Tsnacks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1Tsnacks 
xi: areg itemsper1T $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_items1T 
xi: areg itemsper1Tdrinks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_items1Tdrinks 
xi: areg itemsper1Tsnacks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_items1Tsnacks 

* Tables of Regression Results:

estimates table reg_cals1T reg_cals1Tdrinks reg_cals1Tsnacks reg_items1T reg_items1Tdrinks reg_items1Tsnacks, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_cals1T reg_cals1Tdrinks reg_cals1Tsnacks reg_items1T reg_items1Tdrinks reg_items1Tsnacks, b(%9.3f) se(%9.3f) stats(N r2)


log close


