
* regressions1_wexplvar.do


log using $logdir/regressions1_wexplvar, text replace

* CHANGE TO LOGS !!!!! ***


clear
set more off
set mem 15g



use $bigdatadir/working/nyc/setup_daily
ge ny=1
append using $bigdatadir/working/bos/setup_daily
append using $bigdatadir/working/phi/setup_daily
replace ny=0 if ny==.

ge law=ny*after_nyc

* Explanatory vars:

sort store
merge store using $datadir/working/dd_dist
tab _merge
drop if _merge~=3
drop _merge


ge dd100m=dddist<.1
ge dd200m=dddist>=.1 & dddist<.2
ge dd300m=dddist>=.2 & dddist<.3
ge dd400m=dddist>=.3 & dddist<.4
ge dd500m=dddist>=.4 & dddist<.5
ge law_dd100m=dd100m*law
ge law_dd200m=dd200m*law
ge law_dd300m=dd300m*law
ge law_dd400m=dd400m*law
ge law_dd500m=dd500m*law

*ge nyafterapril_dd100m=dd100m*nyafterapril
*ge nyafterjune_dd100m=dd100m*nyafterjune

global ddvars "sblaw_dd100m"


sort txmonth txday
merge using $datadir/working/holidays
tab _merge
drop if _merge==2
drop _merge

global demog "pop25* white* black* asian* hisp* age* male* female* avg* med*"

ge temp2 = temp^2
ge precip2 = precip^2
global weather "temp temp2 precip precip2"

global business "n_* worker*"

drop if holiday==1

*rest_perperson chainrest_perperson medhhinc collegedegree age2045 males
ge law_rest=law*rest_perperson*1000
ge law_chainrest=law*chainrest_perperson*1000
ge law_inc=law*medhhinc/100000 
ge law_educ=law*collegedegree 
ge law_age=law*age2045 
ge law_male=law*males

ge dollarspertx=dollarsperday/txsperday
drop dollarsperitem
ge dollarsperitem=dollarsperday/itemsperday

* Calories per item, by type:
ge calperitem=calsper1T/itemsper1T
ge calperitem_drinks=calsper1Tdrinks/itemsper1Tdrinks
ge calperitem_snacks=calsper1Tsnacks/itemsper1Tsnacks

*********** WITH LOGS **********

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



************* JUST DEMOG INTERACTION ***************

global lawvars "law law_inc law_educ law_age law_male"
* Regressions:

xi: areg dollarsperday $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_dollars 
xi: areg txsperday $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_txs 

xi: areg dollarspertx $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_dollars_pertx
xi: areg dollarsperitem $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_dollars_peritem


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


xi: areg calperitem $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store calperitem
xi: areg calperitem_drinks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store calperitem_drinks
xi: areg calperitem_snacks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store calperitem_snacks 

* Tables of Regression Results:

estimates table reg_dollars reg_txs reg_dollars_pertx reg_dollars_peritem, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_dollars reg_txs reg_dollars_pertx reg_dollars_peritem, b(%9.3f) se(%9.3f) stats(N r2)

estimates table reg_cals1T reg_cals1Tdrinks reg_cals1Tsnacks reg_items1T reg_items1Tdrinks reg_items1Tsnacks, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_cals1T reg_cals1Tdrinks reg_cals1Tsnacks reg_items1T reg_items1Tdrinks reg_items1Tsnacks, b(%9.3f) se(%9.3f) stats(N r2)

estimates table calperitem calperitem_drinks calperitem_snacks, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table calperitem calperitem_drinks calperitem_snacks, b(%9.3f) se(%9.3f) stats(N r2)

log close


