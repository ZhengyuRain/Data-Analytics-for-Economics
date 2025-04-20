

* regressions1_nyc.do

log using $logdir/regressions1_nyc_revenue, text replace

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

xi: areg dollarsperday $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_dollars 
xi: areg txsperday $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_txs 

xi: areg dollarsperday_drinks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_dollars_drinks 
xi: areg dollarsperday_snacks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_dollars_snacks

ge dollarspertx=dollarsperday/txsperday
drop dollarsperitem
ge dollarsperitem=dollarsperday/itemsperday

* Create same for drink and food specific $/item:
ge dollarsperitem_drinks=dollarsperday_drinks/(itemsper1Tdrinks*hasdrinkorfood1T)
ge dollarsperitem_snacks=dollarsperday_snacks/(itemsper1Tsnacks*hasdrinkorfood1T)


xi: areg dollarspertx $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_dollars_pertx
xi: areg dollarsperitem $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_dollars_peritem
xi: areg dollarsperitem_drinks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_dollars_peritem_drinks
xi: areg dollarsperitem_snacks $lawvars i.txdow i.txweek $weather, absorb(store)
estimates store reg_dollars_peritem_snacks


* Tables of Regression Results:

estimates table reg_txs reg_dollars reg_dollars_drinks reg_dollars_snacks, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_txs reg_dollars reg_dollars_drinks reg_dollars_snacks, b(%9.3f) se(%9.3f) stats(N r2)


estimates table reg_dollars_peritem reg_dollars_peritem_drinks reg_dollars_peritem_snacks, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_dollars_peritem reg_dollars_peritem_drinks reg_dollars_peritem_snacks, b(%9.3f) se(%9.3f) stats(N r2)

log close


