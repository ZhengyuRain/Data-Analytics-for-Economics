

* regressions1_nyc.do

log using $logdir/regressions1_nyc_logs, text replace

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

xi: areg log_dollarsperday $lawvars i.txdow i.txweek $weather, absorb(store) vce(robust)
estimates store reg_dollars 
xi: areg log_txsperday $lawvars i.txdow i.txweek $weather, absorb(store) vce(robust)
estimates store reg_txs 


xi: areg log_calsper1T $lawvars i.txdow i.txweek $weather, absorb(store) vce(robust)
estimates store reg_cals1T 
xi: areg log_calsper1Tdrinks $lawvars i.txdow i.txweek $weather, absorb(store) vce(robust)
estimates store reg_cals1Tdrinks 
xi: areg log_calsper1Tsnacks $lawvars i.txdow i.txweek $weather, absorb(store) vce(robust)
estimates store reg_cals1Tsnacks 


xi: areg log_calperitem $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store calperitem
xi: areg log_calperitem_drinks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store calperitem_drinks
xi: areg log_calperitem_snacks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store calperitem_snacks 




* Tables of Regression Results:

estimates table reg_dollars reg_txs , b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_dollars reg_txs , b(%9.3f) se(%9.3f) stats(N r2)

estimates table reg_cals1T reg_cals1Tdrinks reg_cals1Tsnacks , b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_cals1T reg_cals1Tdrinks reg_cals1Tsnacks , b(%9.3f) se(%9.3f) stats(N r2)

estimates table calperitem calperitem_drinks calperitem_snacks, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table calperitem calperitem_drinks calperitem_snacks, b(%9.3f) se(%9.3f) stats(N r2)


log close


