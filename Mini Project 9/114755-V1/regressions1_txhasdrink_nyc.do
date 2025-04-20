

* regressions1_txhasdrink_nyc.do

log using $logdir/regressions1_txhasdrink_nyc, text replace

clear
set more off
set mem 15g

use $bigdatadir/working/nyc/setup_daily_txhasdrink
ge ny=1
append using $bigdatadir/working/bos/setup_daily_txhasdrink
append using $bigdatadir/working/phi/setup_daily_txhasdrink
replace ny=0 if ny==.


* Explanatory vars:

ge law=ny*after_nyc

global demog "pop25* white* black* asian* hisp* age* male* female* avg* med*"
global business "n_* worker*"

ge temp2 = temp^2
ge precip2 = precip^2
global weather "temp temp2 precip precip2"

drop if holiday==1

* Regressions, single law dummy:


* Calories per item, by type:
ge calperitem=calsper1T/itemsper1T
ge calperitem_drinks=calsper1Tdrinks/itemsper1Tdrinks
ge calperitem_snacks=calsper1Tsnacks/itemsper1Tsnacks


xi: areg calperitem_drinks law i.txdow i.txweek $weather, absorb(store)
estimates store calperitem_drinks


* With Demog:

*xi: reg dollars i.zone*after  i.txweek i.txdow
*xi: reg txs i.zone*after n_* worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow
*xi: reg cals i.zone*after n_* worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow
*xi: reg items i.zone*after n_* worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow




* This calorie regression includes number of chain restaurants interacted with after variable and city
*ge n_chainrest_after=n_chainrest*after
*xi: reg logcals i.zone*after i.zone*n_chainrest i.zone*n_chainrest_after n_* n_chainrest_after worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow
  

log close


