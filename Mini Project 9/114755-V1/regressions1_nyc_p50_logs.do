

* regressions1_nyc_p50.do

log using ../logs/regressions1_nyc_p50_logs, text replace

clear
set more off
set mem 15g

use $bigdatadir/working/nyc/setup_daily_p50
ge ny=1
append using $bigdatadir/working/bos/setup_daily_p50
append using $bigdatadir/working/phi/setup_daily_p50
replace ny=0 if ny==.

* Explanatory vars:

ge law=ny*after_nyc

global demog "pop25* white* black* asian* hisp* age* male* female* avg* med*"
global business "n_* worker*"

ge temp2 = temp^2
ge precip2 = precip^2
global weather "temp temp2 precip precip2"

drop if holiday==1

* ADD 1 TO REMOVE ZEROS
replace calsper1T=log(calsper1T+1)
replace calsper1Tdrinks=log(calsper1Tdrinks+1)
replace calsper1Tsnacks=log(calsper1Tsnacks+1)
replace itemsper1T=log(itemsper1T+1)
replace itemsper1Tdrinks=log(itemsper1Tdrinks+1)
replace itemsper1Tsnacks=log(itemsper1Tsnacks+1)

* Regressions, single law dummy:


*xi: areg dollarsperday law i.txdow i.txweek $weather, absorb(store)
*estimates store reg_dollars 
*xi: areg txsperday law i.txdow i.txweek $weather, absorb(store)
*estimates store reg_txs 
xi: areg calsper1T law i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1T 
xi: areg calsper1Tdrinks law i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1Tdrinks 
xi: areg calsper1Tsnacks law i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1Tsnacks 
xi: areg itemsper1T law i.txdow i.txweek $weather, absorb(store)
estimates store reg_items1T 
xi: areg itemsper1Tdrinks law i.txdow i.txweek $weather, absorb(store)
estimates store reg_items1Tdrinks 
xi: areg itemsper1Tsnacks law i.txdow i.txweek $weather, absorb(store)
estimates store reg_items1Tsnacks 
*xi: areg dollarsper1T law i.txdow i.txweek $weather, absorb(store)
*estimates store reg_dollars1T 


*estimates table reg_dollars reg_txs reg_cals1T reg_items1T reg_dollars1T, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_cals1T reg_cals1Tdrinks reg_cals1Tsnacks reg_items1T reg_items1Tdrinks reg_items1Tsnacks, b(%9.3f) star(.05 .01 .001) stats(N r2)

* With Demog:

*xi: reg dollars i.zone*after  i.txweek i.txdow
*xi: reg txs i.zone*after n_* worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow
*xi: reg cals i.zone*after n_* worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow
*xi: reg items i.zone*after n_* worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow




* This calorie regression includes number of chain restaurants interacted with after variable and city
*ge n_chainrest_after=n_chainrest*after
*xi: reg logcals i.zone*after i.zone*n_chainrest i.zone*n_chainrest_after n_* n_chainrest_after worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow
  

log close


