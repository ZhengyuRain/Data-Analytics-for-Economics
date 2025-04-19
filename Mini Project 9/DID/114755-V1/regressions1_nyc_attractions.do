
clear
insheet using $datadir/other/nyattractionzips.txt
sort zip
save $datadir/working/nyattractionzips, replace
clear

* regressions1_nyc.do

log using $logdir/regressions1_nyc_attractions, text replace

clear
set more off
set mem 15g

use $bigdatadir/working/nyc/setup_daily
ge ny=1
append using $bigdatadir/working/bos/setup_daily
append using $bigdatadir/working/phi/setup_daily
replace ny=0 if ny==.

sort store
merge store using $datadir/working/storeinfo
tab _merge
keep if _merge~=2
drop _merge

sort zip
merge zip using $datadir/working/nyattractionzips
tab _merge
drop if _merge==2
ge touristzip=_merge==3
drop _merge



tab county if ny==1
ge borough=0
* manhatten, bronx, brooklyn, queens, staten island
replace borough=1 if county=="NEW YORK COUNTY"
replace borough=2 if county=="BRONX COUNTY"
replace borough=3 if county=="KINGS COUNTY"
replace borough=4 if county=="QUEENS COUNTY"
replace borough=5 if county=="RICHMOND COUNTY"


* Explanatory vars:

ge law=ny*after_nyc
ge lawtourist=law*touristzip

ge manhatten=law*(borough==1)
ge bronx=law*(borough==2)
ge brooklyn=law*(borough==3)
ge queens=law*(borough==4)
ge staten =law*(borough==5)
global laweffect "law lawtourist"

global demog "pop25* white* black* asian* hisp* age* male* female* avg* med*"
global business "n_* worker*"

ge temp2 = temp^2
ge precip2 = precip^2
global weather "temp temp2 precip precip2"

drop if holiday==1

* Regressions, single law dummy:

xi: areg calsper1T $laweffect i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1T 
xi: areg calsper1Tdrinks $laweffect i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1Tdrinks 
xi: areg calsper1Tsnacks $laweffect i.txdow i.txweek $weather, absorb(store)
estimates store reg_cals1Tsnacks 
xi: areg itemsper1T $laweffect i.txdow i.txweek $weather, absorb(store)
estimates store reg_items1T 
xi: areg itemsper1Tdrinks $laweffect i.txdow i.txweek $weather, absorb(store)
estimates store reg_items1Tdrinks 
xi: areg itemsper1Tsnacks $laweffect i.txdow i.txweek $weather, absorb(store)
estimates store reg_items1Tsnacks 

* Calories per item, by type:
ge calperitem=calsper1T/itemsper1T
ge calperitem_drinks=calsper1Tdrinks/itemsper1Tdrinks
ge calperitem_snacks=calsper1Tsnacks/itemsper1Tsnacks

* Tables of Regression Results:

estimates table reg_cals1T reg_cals1Tdrinks reg_cals1Tsnacks reg_items1T reg_items1Tdrinks reg_items1Tsnacks, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table reg_cals1T reg_cals1Tdrinks reg_cals1Tsnacks reg_items1T reg_items1Tdrinks reg_items1Tsnacks, b(%9.3f) se(%9.3f) stats(N r2)



xi: areg calperitem $laweffect i.txdow i.txweek $weather, absorb(store)
estimates store calperitem
xi: areg calperitem_drinks $laweffect i.txdow i.txweek $weather, absorb(store)
estimates store calperitem_drinks
xi: areg calperitem_snacks $laweffect i.txdow i.txweek $weather, absorb(store)
estimates store calperitem_snacks 

estimates table calperitem calperitem_drinks calperitem_snacks, b(%9.3f) star(.05 .01 .001) stats(N r2)
estimates table calperitem calperitem_drinks calperitem_snacks, b(%9.3f) se(%9.3f) stats(N r2)



log close


