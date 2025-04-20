
* regressions1_wdd.do




log using $logdir/regressions1_wexplvar, text replace

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

************* JUST DEMOG INTERACTION ***************

global lawvars "law law_chainrest law_inc law_educ law_age law_male"
* Regressions:

xi: areg log_dollarsperday $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_dollars 
xi: areg log_txsperday $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_txs 



xi: areg log_calsper1T $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1T 
xi: areg log_calsper1Tdrinks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1Tdrinks 
xi: areg log_calsper1Tsnacks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1Tsnacks 



*xi: areg log_calperitem $lawvars i.txdow i.txweek $weather, absorb(store)
*estimates store calperitem
*xi: areg log_calperitem_drinks $lawvars i.txdow i.txweek $weather, absorb(store)
*estimates store calperitem_drinks
*xi: areg log_calperitem_snacks $lawvars i.txdow i.txweek $weather, absorb(store)
*estimates store calperitem_snacks 

* Tables of Regression Results:

estimates table reg_dollars reg_txs , b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_dollars reg_txs , b(%9.3f) se(%9.3f) stats(N r2)

estimates table reg_cals1T reg_cals1Tdrinks reg_cals1Tsnacks, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_cals1T reg_cals1Tdrinks reg_cals1Tsnacks, b(%9.3f) se(%9.3f) stats(N r2)

*estimates table calperitem calperitem_drinks calperitem_snacks, b(%9.3f) star(.05 .01 .001) stats(N r2)
*estimates table calperitem calperitem_drinks calperitem_snacks, b(%9.3f) se(%9.3f) stats(N r2)

log close


