

* regressions2_nyc.do

log using ../logs/regressions2_nyc, text replace

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


* Revenue:

preserve
xi: areg dollarsperday i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_dollars 

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
*first week dropped
gen wk = _n+1

tw line b1 wk, ///
  xline($policyline) ///
  xlabel(-0.7 "01jan2008" 12.286 "01apr2008" 51.57 "01jan2009") ///
  title("Daily Store Revenue") ///
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
  saving($graphdir/$currentcity/revenue_weekinter.gph, replace)

graph export $graphdir/$currentcity/revenue_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/revenue_weekinter.eps

restore


* Transactions:

preserve
xi: areg txsperday i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_txs

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
  title("Daily Store Transactions") ///
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
  saving($graphdir/$currentcity/txs_weekinter.gph, replace)

graph export $graphdir/$currentcity/txs_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/txs_weekinter.eps

restore


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
  saving($graphdir/$currentcity/cals1T_weekinter.gph, replace)

graph export $graphdir/$currentcity/cals1T_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1T_weekinter.eps

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
  saving($graphdir/$currentcity/cals1Tdrinks_weekinter.gph, replace)

graph export $graphdir/$currentcity/cals1Tdrinks_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1Tdrinks_weekinter.eps

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
  saving($graphdir/$currentcity/cals1Tsnacks_weekinter.gph, replace)

graph export $graphdir/$currentcity/cals1Tsnacks_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1Tsnacks_weekinter.eps

restore

* Items:

preserve
xi: areg itemsper1T i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_items1T 

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
  title("Items per Transaction") ///
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
  saving($graphdir/$currentcity/items1T_weekinter.gph, replace)

graph export $graphdir/$currentcity/items1T_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/items1T_weekinter.eps

restore


preserve
xi: areg itemsper1Tdrinks i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_items1Tdrinks

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
  title("Drink Items per Transaction") ///
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
  saving($graphdir/$currentcity/items1Tdrinks_weekinter.gph, replace)

graph export $graphdir/$currentcity/items1Tdrinks_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/items1Tdrinks_weekinter.eps

restore


preserve
xi: areg itemsper1Tsnacks i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_items1Tsnacks

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
  title("Food Items per Transaction") ///
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
  saving($graphdir/$currentcity/items1Tsnacks_weekinter.gph, replace)

graph export $graphdir/$currentcity/items1Tsnacks_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/items1Tsnacks_weekinter.eps

restore


preserve
xi: areg dollarsper1T i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_dollars1T
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
  title("Revenue per Transaction") ///
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
  saving($graphdir/$currentcity/dollars1T_weekinter.gph, replace)

graph export $graphdir/$currentcity/dollars1T_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/dollars1T_weekinter.eps

restore

estimates table reg_dollars reg_txs reg_cals1T reg_items1T reg_dollars1T, b(%9.3f) star(.05 .01 .001) stats(N r2)


preserve
xi: areg foodattach1T i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_dollars1T
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
  title("Food Attach Rate") ///
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
  saving($graphdir/$currentcity/foodattach1T_weekinter.gph, replace)

graph export $graphdir/$currentcity/foodattach1T_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/foodattach1T_weekinter.eps

restore





* Week coef

global coefrange "2/60"

* Revenue:

preserve
xi: areg dollarsperday i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_dollars 

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
*first week dropped
gen wk = _n+1

tw line b1 wk, ///
  xline($policyline) ///
  xlabel(-0.7 "01jan2008" 12.286 "01apr2008" 51.57 "01jan2009") ///
  title("Daily Store Revenue") ///
  ytitle("week coefficient") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/revenue_week.gph, replace)

graph export $graphdir/$currentcity/revenue_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/revenue_week.eps

restore


* Transactions:

preserve
xi: areg txsperday i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_txs

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
  title("Daily Store Transactions") ///
  ytitle("week coefficient") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/txs_week.gph, replace)

graph export $graphdir/$currentcity/txs_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/txs_week.eps

restore


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
  ytitle("week coefficient") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/cals1T_week.gph, replace)

graph export $graphdir/$currentcity/cals1T_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1T_week.eps

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
  ytitle("week coefficient") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/cals1Tdrinks_week.gph, replace)

graph export $graphdir/$currentcity/cals1Tdrinks_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1Tdrinks_week.eps

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
  ytitle("week coefficient") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/cals1Tsnacks_week.gph, replace)

graph export $graphdir/$currentcity/cals1Tsnacks_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1Tsnacks_week.eps

restore

* Items:

preserve
xi: areg itemsper1T i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_items1T 

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
  title("Items per Transaction") ///
  ytitle("week coefficient") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/items1T_week.gph, replace)

graph export $graphdir/$currentcity/items1T_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/items1T_week.eps

restore


preserve
xi: areg dollarsper1T i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_dollars1T
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
  title("Revenue per Transaction") ///
  ytitle("week coefficient") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/dollars1T_week.gph, replace)

graph export $graphdir/$currentcity/dollars1T_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/dollars1T_week.eps

restore

preserve
xi: areg itemsper1Tdrinks i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_items1Tdrinks

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
  title("Drink Items per Transaction") ///
  ytitle("week coefficient") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/items1Tdrinks_week.gph, replace)

graph export $graphdir/$currentcity/items1Tdrinks_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/items1Tdrinks_week.eps

restore


preserve
xi: areg itemsper1Tsnacks i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_items1Tsnacks

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
  title("Food Items per Transaction") ///
  ytitle("week coefficient") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/items1Tsnacks_week.gph, replace)

graph export $graphdir/$currentcity/items1Tsnacks_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/items1Tsnacks_week.eps

restore


preserve
xi: areg foodattach1T i.ny*i.txweek i.txdow $weather, absorb(store) vce(robust)
estimates store reg_dollars1T
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
  title("Food Attach Rate") ///
  ytitle("week coefficient") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/foodattach1T_week.gph, replace)

graph export $graphdir/$currentcity/foodattach1T_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/foodattach1T_week.eps

restore


*estimates table reg_dollars reg_txs reg_cals1T reg_items1T reg_dollars1T, b(%9.3f) star(.05 .01 .001) stats(N r2)



log close
