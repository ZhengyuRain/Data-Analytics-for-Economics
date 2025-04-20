

* regressions2_nyc.do

log using ../logs/regressions2_nyc, text replace

* ROBUSTNESS CHECK: DROP MANHATTEN


************** ADD LOGS *************


clear 
clear matrix
set more off
set mem 15g

set matsize 700

use $bigdatadir/working/nyc/setup_daily
ge ny=1
append using $bigdatadir/working/bos/setup_daily
append using $bigdatadir/working/phi/setup_daily
replace ny=0 if ny==.

global currentcity nyc

sort store
merge store using $datadir/working/storeinfo
tab _merge
keep if _merge~=2
drop _merge

tab county if ny==1
ge borough=0
* manhatten, bronx, brooklyn, queens, staten island
replace borough=1 if county=="NEW YORK COUNTY"
replace borough=2 if county=="BRONX COUNTY"
replace borough=3 if county=="KINGS COUNTY"
replace borough=4 if county=="QUEENS COUNTY"
replace borough=5 if county=="RICHMOND COUNTY"

* drop manahatten
drop if ny==1 & borough==1

* Explanatory vars:

global demog "pop25* white* black* asian* hisp* age* male* female* avg* med*"

ge temp2 = temp^2
ge precip2 = precip^2
global weather "temp temp2 precip precip2"

global business "n_* worker*"

* Regressions, interact ny with week

global nyc_adopt 14.42
global sea_adopt 52
*global xrange 0(5)60
global coefrangejanaug "35/67"

global coefrange "61/119"
*global policyline 14.42

global policyline "12.286, lpattern(dot)"

drop if holiday==1

* ADD LOGS

replace dollarsperday = log(dollarsperday)
replace txsperday = log(txsperday)
replace calsper1T = log(calsper1T)
replace calsper1Tdrinks = log(calsper1Tdrinks)
replace calsper1Tsnacks = log(calsper1Tsnacks)
replace itemsper1T = log(itemsper1T)
replace itemsper1Tdrinks = log(itemsper1Tdrinks)
replace itemsper1Tsnacks = log(itemsper1Tsnacks)


* Calories:

preserve
xi: areg calsper1T i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_cals1T 

mat b = get(_b)
mat b = b'
mat V = get(VCE)
mat dv = vecdiag(V)
mat dv = dv'
svmat b
svmat dv
keep in $coefrange
gen low = b1 - 1.96*sqrt(dv1)
gen hi = b1 + 1.96*sqrt(dv1)
gen wk = _n+1

tw line b1 wk, ///
  xline($policyline) ///
  xlabel(-0.7 "01jan2008" 12.286 "01apr2008" 51.57 "01jan2009") ///
  title("Calories per Transaction") ///
  ytitle("NY x week interaction") ///
  xtitle(" ") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/cals1T_weekinter_robust1, replace)

graph export $graphdir/$currentcity/cals1T_weekinter_robust1.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1T_weekinter_robust1.eps

restore

preserve
xi: areg calsper1Tdrinks i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_cals1Tdrinks 

mat b = get(_b)
mat b = b'
mat V = get(VCE)
mat dv = vecdiag(V)
mat dv = dv'
svmat b
svmat dv
keep in $coefrange
gen low = b1 - 1.96*sqrt(dv1)
gen hi = b1 + 1.96*sqrt(dv1)
gen wk = _n+1

tw line b1 wk, ///
  xline($policyline) ///
  xlabel(-0.7 "01jan2008" 12.286 "01apr2008" 51.57 "01jan2009") ///
  title("Drink Calories per Transaction") ///
  ytitle("NY x week interaction") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/cals1Tdrinks_weekinter_robust1, replace)

graph export $graphdir/$currentcity/cals1Tdrinks_weekinter_robust1.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1Tdrinks_weekinter_robust1.eps

restore

preserve
xi: areg calsper1Tsnacks i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_cals1Tsnacks 

mat b = get(_b)
mat b = b'
mat V = get(VCE)
mat dv = vecdiag(V)
mat dv = dv'
svmat b
svmat dv
keep in $coefrange
gen low = b1 - 1.96*sqrt(dv1)
gen hi = b1 + 1.96*sqrt(dv1)
gen wk = _n+1

tw line b1 wk, ///
  xline($policyline) ///
  xlabel(-0.7 "01jan2008" 12.286 "01apr2008" 51.57 "01jan2009") ///
  title("Food Calories per Transaction") ///
  ytitle("NY x week interaction") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/cals1Tsnacks_weekinter_robust1, replace)

graph export $graphdir/$currentcity/cals1Tsnacks_weekinter_robust1.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1Tsnacks_weekinter_robust1.eps

restore




log close
