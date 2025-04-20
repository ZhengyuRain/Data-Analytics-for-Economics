
* regressions2_wdd

log using $logdir/regressions2_wdd, text replace

clear
set more off
set mem 15g

set matsize 700

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

*ge afterapril=mdy(txmonth,txday,2008)>mdy(4,30,2008)
*ge nyafterapril=ny*afterapril

*ge afterjune=mdy(txmonth,txday,2008)>mdy(6,30,2008)
*ge nyafterjune=ny*afterjune

*ge sblawdddist=law*dddist
*ge sblawddr2=law*ddr2

*ge afterapril_dddist=afterapril*dddist
*ge afterapril_ddr2=afterapril*ddr2

ge dd100m=dddist<.1
ge nydd100m=dd100m*ny

*ge nyafterapril_dd100m=dd100m*nyafterapril
*ge nyafterjune_dd100m=dd100m*nyafterjune

*global ddvars "sblaw_dd100m"


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



* Regressions, interact ny with week




global nyc_adopt 14.42
global sea_adopt 52
*global xrange 0(5)60
global coefrangejanaug "35/67"

global coefrange "61/119"
*global policyline 14.42

global policyline "14.286, lpattern(dot)"


* Revenue:

preserve
xi: areg dollarsperday  i.nydd100m*i.txweek i.ny*i.txweek  $weather i.txdow , absorb(store)
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
  xline($policyline ) ///
  xlabel(-0.7 "01jan2008" 14.286 "15apr2008" 51.57 "01jan2009") ///
  title("Daily Store Revenue") ///
  ytitle("NY x DD x week interaction") ///
  xtitle("date") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/dd/revenue_weekddinter_wdd, replace)

graph export $graphdir/dd/revenue_weekddinter_wdd.eps,logo(off) replace
!epstopdf $graphdir/dd/revenue_weekddinter_wdd.eps
restore


* Transactions:


preserve
xi: areg txsperday i.nydd100m*i.txweek i.ny*i.txweek  $weather i.txdow , absorb(store)
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
  xline($policyline ) ///
  xlabel(-0.7 "01jan2008" 14.286 "15apr2008" 51.57 "01jan2009") ///
  title("Daily Store Transactions") ///
  ytitle("NY x DD x week interaction") ///
  xtitle("date") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/dd/txs_weekddinter_wdd, replace)

graph export $graphdir/dd/txs_weekddinter_wdd.eps,logo(off) replace
!epstopdf $graphdir/dd/txs_weekddinter_wdd.eps
restore

* Calories:


preserve
xi: areg calsper1T i.nydd100m*i.txweek i.ny*i.txweek  $weather i.txdow , absorb(store)
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
  xline($policyline ) ///
  xlabel(-0.7 "01jan2008" 14.286 "15apr2008" 51.57 "01jan2009") ///
  title("Calories per Transaction") ///
  ytitle("NY x DD x week interaction") ///
  xtitle("date") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/dd/cals1T_weekddinter_wdd, replace)

graph export $graphdir/dd/cals1T_weekddinter_wdd.eps,logo(off) replace
!epstopdf $graphdir/dd/cals1T_weekddinter_wdd.eps
restore


preserve
xi: areg calsper1Tdrinks i.nydd100m*i.txweek i.ny*i.txweek  $weather i.txdow , absorb(store)
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
  xline($policyline ) ///
  xlabel(-0.7 "01jan2008" 14.286 "15apr2008" 51.57 "01jan2009") ///
  title("Drink Calories per Transaction") ///
  ytitle("NY x DD x week interaction") ///
  xtitle("date") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/dd/cals1Tdrinks_weekddinter_wdd, replace)

graph export $graphdir/dd/cals1Tdrinks_weekddinter_wdd.eps,logo(off) replace
!epstopdf $graphdir/dd/cals1Tdrinks_weekddinter_wdd.eps
restore


preserve
xi: areg calsper1Tsnacks i.nydd100m*i.txweek i.ny*i.txweek  $weather i.txdow , absorb(store)
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
  xline($policyline ) ///
  xlabel(-0.7 "01jan2008" 14.286 "15apr2008" 51.57 "01jan2009") ///
  title("Food Calories per Transaction") ///
  ytitle("NY x DD x week interaction") ///
  xtitle("date") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/dd/cals1Tsnacks_weekddinter_wdd, replace)

graph export $graphdir/dd/cals1Tsnacks_weekddinter_wdd.eps,logo(off) replace
!epstopdf $graphdir/dd/cals1Tsnacks_weekddinter_wdd.eps
restore

* Items Per Person:


preserve
xi: areg itemsper1T i.nydd100m*i.txweek i.ny*i.txweek  $weather i.txdow , absorb(store)
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
  xline($policyline ) ///
  xlabel(-0.7 "01jan2008" 14.286 "15apr2008" 51.57 "01jan2009") ///
  title("Items Per Transaction") ///
  ytitle("NY x DD x week interaction") ///
  xtitle("date") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/dd/items1T_weekddinter_wdd, replace)

graph export $graphdir/dd/items1T_weekddinter_wdd.eps,logo(off) replace
!epstopdf $graphdir/dd/items1T_weekddinter_wdd.eps
restore

preserve
xi: areg itemsper1Tdrinks i.nydd100m*i.txweek i.ny*i.txweek  $weather i.txdow , absorb(store)
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
  xline($policyline ) ///
  xlabel(-0.7 "01jan2008" 14.286 "15apr2008" 51.57 "01jan2009") ///
  title("Drink Items Per Transaction") ///
  ytitle("NY x DD x week interaction") ///
  xtitle("date") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/dd/items1Tdrinks_weekddinter_wdd, replace)

graph export $graphdir/dd/items1Tdrinks_weekddinter_wdd.eps,logo(off) replace
!epstopdf $graphdir/dd/items1Tdrinks_weekddinter_wdd.eps
restore

preserve
xi: areg itemsper1Tsnacks i.nydd100m*i.txweek i.ny*i.txweek  $weather i.txdow , absorb(store)
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
  xline($policyline ) ///
  xlabel(-0.7 "01jan2008" 14.286 "15apr2008" 51.57 "01jan2009") ///
  title("Food Items Per Transaction") ///
  ytitle("NY x DD x week interaction") ///
  xtitle("date") || ///
line low wk, ///
  clpattern(dash) ///
  clcolor(red) || ///
line hi wk, ///
  clpattern(dash) ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/dd/items1Tsnacks_weekddinter_wdd, replace)

graph export $graphdir/dd/items1Tsnacks_weekddinter_wdd.eps,logo(off) replace
!epstopdf $graphdir/dd/items1Tsnacks_weekddinter_wdd.eps
restore

global coefrange "2/60"

log close
