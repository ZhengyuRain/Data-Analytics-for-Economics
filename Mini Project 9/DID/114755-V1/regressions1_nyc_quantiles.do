

* regressions1_nyc_quantiles.do

log using ../logs/regressions1_nyc_quantiles, text replace

clear
set more off
set mem 15g

use $bigdatadir/working/nyc/setup_daily_quantiles
ge ny=1
append using $bigdatadir/working/bos/setup_daily_quantiles
append using $bigdatadir/working/phi/setup_daily_quantiles
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

ge calvar=.

replace calvar = log(calsper1T_p10)
xi: areg calvar law i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1T_p10

replace calvar = log(calsper1T_p25)
xi: areg calvar law i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1T_p25

replace calvar = log(calsper1T_p50)
xi: areg calvar law i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1T_p50

replace calvar = log(calsper1T_p75)
xi: areg calvar law i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1T_p75

replace calvar = log(calsper1T_p90)
xi: areg calvar law i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1T_p90

replace calvar = log(calsper1T_p95)
xi: areg calvar law i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1T_p95

replace calvar = log(calsper1T_p99)
xi: areg calvar law i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1T_p99


su calsper1T

*estimates table reg_dollars reg_txs reg_cals1T reg_items1T reg_dollars1T, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_cals1T_p10 reg_cals1T_p25 reg_cals1T_p50 reg_cals1T_p75 reg_cals1T_p90 reg_cals1T_p95 reg_cals1T_p99, b(%9.3f) star(.05 .01 .001) stats(N r2)



log close


