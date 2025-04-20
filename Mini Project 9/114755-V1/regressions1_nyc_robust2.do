

* regressions1_nyc_robust2.do

* CHANGED TO DO LOGS!!!

* ROBUSTNESS CHECK: ADD DATE DUMMIES 

log using $logdir/regressions1_nyc_robust2, text replace

clear 
clear matrix
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

xi: areg dollarsperday $lawvars i.dat $weather, absorb(store) vce(robust)
estimates store reg_dollars 
xi: areg txsperday $lawvars i.dat $weather, absorb(store) vce(robust)
estimates store reg_txs 

ge dollarspertx=dollarsperday/txsperday
drop dollarsperitem
ge dollarsperitem=dollarsperday/itemsperday

* Calories per item, by type:
ge calperitem=calsper1T/itemsper1T
ge calperitem_drinks=calsper1Tdrinks/itemsper1Tdrinks
ge calperitem_snacks=calsper1Tsnacks/itemsper1Tsnacks

replace dollarspertx = log(dollarspertx)
replace dollarsperitem = log(dollarsperitem)
replace calsper1T = log(calsper1T)
replace calsper1Tdrinks = log(calsper1Tdrinks)
replace calsper1Tsnacks = log(calsper1Tsnacks)
replace itemsper1T = log(itemsper1T)
replace itemsper1Tdrinks = log(itemsper1Tdrinks)
replace itemsper1Tsnacks = log(itemsper1Tsnacks)
replace calperitem = log(calperitem)
replace calperitem_drinks = log(calperitem_drinks)
replace calperitem_snacks = log(calperitem_snacks)



xi: areg dollarspertx $lawvars i.dat $weather, absorb(store) vce(robust)
estimates store reg_dollars_pertx
xi: areg dollarsperitem $lawvars i.dat $weather, absorb(store) vce(robust)
estimates store reg_dollars_peritem



xi: areg calsper1T $lawvars i.dat $weather, absorb(store) vce(robust)
estimates store reg_cals1T 
xi: areg calsper1Tdrinks $lawvars i.dat $weather, absorb(store) vce(robust)
estimates store reg_cals1Tdrinks 
xi: areg calsper1Tsnacks $lawvars i.dat $weather, absorb(store) vce(robust)
estimates store reg_cals1Tsnacks 
xi: areg itemsper1T $lawvars i.dat $weather, absorb(store) vce(robust)
estimates store reg_items1T 
xi: areg itemsper1Tdrinks $lawvars i.dat $weather, absorb(store) vce(robust)
estimates store reg_items1Tdrinks 
xi: areg itemsper1Tsnacks $lawvars i.dat $weather, absorb(store) vce(robust)
estimates store reg_items1Tsnacks 




* Tables of Regression Results:

estimates table reg_dollars reg_txs reg_dollars_pertx reg_dollars_peritem, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_dollars reg_txs reg_dollars_pertx reg_dollars_peritem, b(%9.3f) se(%9.3f) stats(N r2)

estimates table reg_cals1T reg_cals1Tdrinks reg_cals1Tsnacks reg_items1T reg_items1Tdrinks reg_items1Tsnacks, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_cals1T reg_cals1Tdrinks reg_cals1Tsnacks reg_items1T reg_items1Tdrinks reg_items1Tsnacks, b(%9.3f) se(%9.3f) stats(N r2)


xi: areg calperitem $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store calperitem
xi: areg calperitem_drinks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store calperitem_drinks
xi: areg calperitem_snacks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store calperitem_snacks 

estimates table calperitem calperitem_drinks calperitem_snacks, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table calperitem calperitem_drinks calperitem_snacks, b(%9.3f) se(%9.3f) stats(N r2)


log close


