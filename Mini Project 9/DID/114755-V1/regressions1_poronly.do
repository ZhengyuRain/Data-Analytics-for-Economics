

* regressions1_sea.do

log using $logdir/regressions1_poronly, text replace

clear
set more off


use $bigdatadir/working/por/setup_daily
ge sea=1

* Replace week dummies to be same value for 2008/2009
replace txweek=1 if txweek==53
replace txweek=2 if txweek==54
replace txweek=3 if txweek==55
replace txweek=4 if txweek==56
replace txweek=5 if txweek==57
replace txweek=6 if txweek==58
replace txweek=7 if txweek==59
replace txweek=8 if txweek==60

* Explanatory vars:

ge law=sea*after_sea

global demog "pop25* white* black* asian* hisp* age* male* female* avg* med*"
global business "n_* worker*"

ge temp2 = temp^2
ge precip2 = precip^2
global weather "temp temp2 precip precip2"

drop if holiday==1

* Regressions, single law dummy:

xi: areg dollarsperday law i.txdow i.txweek $weather, absorb(store)
estimates store reg_dollars 
xi: areg txsperday law i.txdow i.txweek $weather, absorb(store)
estimates store reg_txs 
xi: areg calsper1P law i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1T 
xi: areg itemsper1P law i.txdow i.txweek $weather, absorb(store)
estimates store reg_items1T 
xi: areg dollarsper1P law i.txdow i.txweek $weather, absorb(store)
estimates store reg_dollars1T 

estimates table reg_dollars reg_txs reg_cals1T reg_items1T reg_dollars1T, b(%9.3f) star(.05 .01 .001) stats(N r2)

* With Demog:

*xi: reg dollars i.zone*after  i.txweek i.txdow
*xi: reg txs i.zone*after n_* worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow
*xi: reg cals i.zone*after n_* worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow
*xi: reg items i.zone*after n_* worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow


*describe

* This calorie regression includes number of chain restaurants interacted with after variable and city
*ge n_chainrest_after=n_chainrest*after
*xi: reg logcals i.zone*after i.zone*n_chainrest i.zone*n_chainrest_after n_* n_chainrest_after worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow
  

log close


