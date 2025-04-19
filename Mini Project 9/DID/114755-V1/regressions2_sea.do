

* regressions2_nyc.do

log using $logdir/regressions2_sea, text replace

clear
set more off
set mem 15g


use $bigdatadir/working/sea/setup_daily
ge sea=1
append using $bigdatadir/working/sfr/setup_daily
append using $bigdatadir/working/por/setup_daily
replace sea=0 if sea==.

global currentcity sea

* Explanatory vars:

ge law=sea*after_sea

global demog "pop25* white* black* asian* hisp* age* male* female* avg* med*"

ge temp2 = temp^2
ge precip2 = precip^2
global weather "temp temp2 precip precip2"

global business "n_* worker*"

* Regressions, interact ny with week

global nyc_adopt 14.42
global sea_adopt 52
global xrange 0(5)60
global coefrange16week "18/33"

global coefrange "61/119"
global policyline 52

drop if holiday==1


* Revenue:

preserve
xi: areg dollarsperday i.sea*i.txweek i.txdow $weather, absorb(store)
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
  xlabel($xrange) ///
  title("Daily Store Revenue Regression") ///
  ytitle("SEA x week interaction") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/revenue_weekinter, replace)

graph export $graphdir/$currentcity/revenue_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/revenue_weekinter.eps

restore


* Transactions:

preserve
xi: areg txsperday i.sea*i.txweek i.txdow $weather, absorb(store)
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
  xlabel($xrange) ///
  title("Daily Store Transactions Regression") ///
  ytitle("SEA x week interaction") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/txs_weekinter, replace)

graph export $graphdir/$currentcity/txs_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/txs_weekinter.eps

restore


* Calories:

preserve
xi: areg calsper1P i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_cals1P 

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
  xlabel($xrange) ///
  title("Calories per Person Regression") ///
  ytitle("SEA x week interaction") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/cals1P_weekinter, replace)

graph export $graphdir/$currentcity/cals1P_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1P_weekinter.eps

restore

preserve
xi: areg calsper1Pdrinks i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_cals1Pdrinks 

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
  xlabel($xrange) ///
  title("Drink Calories per Person Regression") ///
  ytitle("SEA x week interaction") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/cals1Pdrinks_weekinter, replace)

graph export $graphdir/$currentcity/cals1Pdrinks_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1Pdrinks_weekinter.eps

restore

preserve
xi: areg calsper1Psnacks i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_cals1Psnacks 

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
  xlabel($xrange) ///
  title("Food Calories per Person Regression") ///
  ytitle("SEA x week interaction") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/cals1Psnacks_weekinter, replace)

graph export $graphdir/$currentcity/cals1Psnacks_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1Psnacks_weekinter.eps

restore

* Items:

preserve
xi: areg itemsper1P i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_items1P 

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
  xlabel($xrange) ///
  title("Items per Person Regression") ///
  ytitle("SEA x week interaction") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/items1P_weekinter, replace)

graph export $graphdir/$currentcity/items1P_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/items1P_weekinter.eps

restore


preserve
xi: areg itemsper1Pdrinks i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_items1Pdrinks

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
  xlabel($xrange) ///
  title("Drink Items per Person Regression") ///
  ytitle("SEA x week interaction") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/items1Pdrinks_weekinter, replace)

graph export $graphdir/$currentcity/items1Pdrinks_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/items1Pdrinks_weekinter.eps

restore


preserve
xi: areg itemsper1Psnacks i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_items1Psnacks

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
  xlabel($xrange) ///
  title("Food Items per Person Regression") ///
  ytitle("SEA x week interaction") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/items1Psnacks_weekinter, replace)

graph export $graphdir/$currentcity/items1Psnacks_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/items1Psnacks_weekinter.eps

restore


preserve
xi: areg dollarsper1P i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_dollars1P
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
  xlabel($xrange) ///
  title("Revenue per Person Regression") ///
  ytitle("SEA x week interaction") ///
  xtitle("week") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/$currentcity/dollars1P_weekinter, replace)

graph export $graphdir/$currentcity/dollars1P_weekinter.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/dollars1P_weekinter.eps

restore

estimates table reg_dollars reg_txs reg_cals1P reg_items1P reg_dollars1P, b(%9.3f) star(.05 .01 .001) stats(N r2)

* Week coef

global coefrange "2/60"

* Revenue:

preserve
xi: areg dollarsperday i.sea*i.txweek i.txdow $weather, absorb(store)
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
  xlabel($xrange) ///
  title("Daily Store Revenue Regression") ///
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
  saving($graphdir/$currentcity/revenue_week, replace)

graph export $graphdir/$currentcity/revenue_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/revenue_week.eps

restore


* Transactions:

preserve
xi: areg txsperday i.sea*i.txweek i.txdow $weather, absorb(store)
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
  xlabel($xrange) ///
  title("Daily Store Transactions Regression") ///
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
  saving($graphdir/$currentcity/txs_week, replace)

graph export $graphdir/$currentcity/txs_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/txs_week.eps

restore


* Calories:

preserve
xi: areg calsper1P i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_cals1P 

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
  xlabel($xrange) ///
  title("Calories per Person Regression") ///
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
  saving($graphdir/$currentcity/cals1P_week, replace)

graph export $graphdir/$currentcity/cals1P_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1P_week.eps

restore


preserve
xi: areg calsper1Pdrinks i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_cals1Pdrinks 

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
  xlabel($xrange) ///
  title("Drink Calories per Person Regression") ///
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
  saving($graphdir/$currentcity/cals1Pdrinks_week, replace)

graph export $graphdir/$currentcity/cals1Pdrinks_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1Pdrinks_week.eps

restore

preserve
xi: areg calsper1Psnacks i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_cals1Psnacks 

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
  xlabel($xrange) ///
  title("Food Calories per Person Regression") ///
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
  saving($graphdir/$currentcity/cals1Psnacks_week, replace)

graph export $graphdir/$currentcity/cals1Psnacks_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/cals1Psnacks_week.eps

restore

* Items:

preserve
xi: areg itemsper1P i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_items1P 

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
  xlabel($xrange) ///
  title("Items per Person Regression") ///
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
  saving($graphdir/$currentcity/items1P_week, replace)

graph export $graphdir/$currentcity/items1P_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/items1P_week.eps

restore


preserve
xi: areg dollarsper1P i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_dollars1P
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
  xlabel($xrange) ///
  title("Revenue per Person Regression") ///
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
  saving($graphdir/$currentcity/dollars1P_week, replace)

graph export $graphdir/$currentcity/dollars1P_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/dollars1P_week.eps

restore

preserve
xi: areg itemsper1Pdrinks i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_items1Pdrinks

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
  xlabel($xrange) ///
  title("Drink Items per Person Regression") ///
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
  saving($graphdir/$currentcity/items1Pdrinks_week, replace)

graph export $graphdir/$currentcity/items1Pdrinks_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/items1Pdrinks_week.eps

restore


preserve
xi: areg itemsper1Psnacks i.sea*i.txweek i.txdow $weather, absorb(store)
estimates store reg_items1Psnacks

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
  xlabel($xrange) ///
  title("Food Items per Person Regression") ///
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
  saving($graphdir/$currentcity/items1Psnacks_week, replace)

graph export $graphdir/$currentcity/items1Psnacks_week.eps, logo(off) replace
!epstopdf $graphdir/$currentcity/items1Psnacks_week.eps

restore

*estimates table reg_dollars reg_txs reg_cals1P reg_items1P reg_dollars1P, b(%9.3f) star(.05 .01 .001) stats(N r2)



log close


