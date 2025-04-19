
* regressions1_pre8AM.do

* Does transaction-level regressions



global statadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/stata
cd $statadir
global datadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/data
global logdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/stata/logs
global tmpdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/tmp
global graphdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/graphs
global bigdatadir /data/gsb/SBC

log using ../logs/regressions1_pre8AM, text replace


clear
set more off
set mem 15g

use /data/gsb/SBC/working/setup_daily_pre8AM

sort zip
merge zip using ../data/working/zipbyzone_wcounty
tab _merge
drop _merge



* Explanatory vars:

sort txmonth txday
merge using ../data/working/events
tab _merge
drop if _merge==2
drop _merge

replace event_ny=0 if event_ny==.
replace event_us=0 if event_us==.

ge law=ny*after

global demog "pop25* white* black* asian* hisp* age* male* female* avg* med*"

ge temp2 = temp^2
ge precip2 = precip^2
global weather "temp temp2 precip precip2"

global business "n_* worker*"

ge nyevent=ny*event_ny

* Regressions, single law dummy:

xi: areg dollarsperday law i.txdow $weather i.txweek nyevent i.zone*event_us, absorb(store)
estimates store reg_dollars 
xi: areg txsperday law i.txdow $weather i.txweek nyevent i.zone*event_us, absorb(store)
estimates store reg_txs 
xi: areg calsper1P law i.txdow $weather i.txweek nyevent i.zone*event_us, absorb(store)
estimates store reg_cals1P 
xi: areg itemsper1P law i.txdow $weather i.txweek nyevent i.zone*event_us, absorb(store)
estimates store reg_items1P 
xi: areg dollarsper1P law i.txdow $weather i.txweek nyevent i.zone*event_us, absorb(store)
estimates store reg_dollars1P 

estimates table reg_dollars reg_txs reg_cals1P reg_items1P reg_dollars1P, b(%9.3f) star(.05 .01 .001) stats(N r2)

* Regressions, interact ny with week

xi: areg dollarsperday i.ny*i.txweek $weather i.txdow nyevent i.zone*event_us, absorb(store)
estimates store reg_dollars 
xi: areg txsperday i.ny*i.txweek $weather i.txdow nyevent i.zone*event_us, absorb(store)
estimates store reg_txs 
xi: areg calsper1P i.ny*i.txweek $weather i.txdow nyevent i.zone*event_us, absorb(store)
estimates store reg_cals1P 
xi: areg itemsper1P i.ny*i.txweek $weather i.txdow nyevent i.zone*event_us, absorb(store)
estimates store reg_items1P 
xi: areg dollarsper1P i.ny*i.txweek $weather i.txdow nyevent i.zone*event_us, absorb(store)
estimates store reg_dollars1P 

estimates table reg_dollars reg_txs reg_cals1P reg_items1P reg_dollars1P, b(%9.3f) star(.05 .01 .001) stats(N r2)

* Graph Regression Results for ny-week interaction

global coefrange "35/67"

* Revenue:

preserve
xi: areg dollarsperday i.ny*i.txweek $weather i.txdow nyevent i.zone*event_us, absorb(store)
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
  xline(14.286) ///
  xlabel(5(5)35) ///
  title("Daily Store Revenue Regression") ///
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
  saving($graphdir/revenue_meancoefs_pre8AM, replace)

graph export $graphdir/revenue_meancoefs_pre8AM.eps, logo(off) replace
!epstopdf $graphdir/revenue_meancoefs_pre8AM.eps

restore


* Transactions:

preserve
xi: areg txsperday i.ny*i.txweek $weather i.txdow nyevent i.zone*event_us, absorb(store)
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
  xline(14.286) ///
  xlabel(5(5)35) ///
  title("Daily Store Transactions Regression") ///
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
  saving($graphdir/txs_meancoefs_pre8AM, replace)

graph export $graphdir/txs_meancoefs_pre8AM.eps, logo(off) replace
!epstopdf $graphdir/txs_meancoefs_pre8AM.eps

restore


* Calories:

preserve
xi: areg calsper1P i.ny*i.txweek $weather i.txdow nyevent i.zone*event_us, absorb(store)
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
  xline(14.286) ///
  xlabel(5(5)35) ///
  title("Calories per Person Regression") ///
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
  saving($graphdir/cals1P_meancoefs_pre8AM, replace)

graph export $graphdir/cals1P_meancoefs_pre8AM.eps, logo(off) replace
!epstopdf $graphdir/cals1P_meancoefs_pre8AM.eps

restore


* Items:

preserve
xi: areg itemsper1P i.ny*i.txweek $weather i.txdow nyevent i.zone*event_us, absorb(store)
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
  xline(14.286) ///
  xlabel(5(5)35) ///
  title("Items per Person Regression") ///
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
  saving($graphdir/items1P_meancoefs_pre8AM, replace)

graph export $graphdir/items1P_meancoefs_pre8AM.eps, logo(off) replace
!epstopdf $graphdir/items1P_meancoefs_pre8AM.eps

restore


preserve
xi: areg dollarsper1P i.ny*i.txweek $weather i.txdow nyevent i.zone*event_us, absorb(store)
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
  xline(14.286) ///
  xlabel(5(5)35) ///
  title("Revenue per Person Regression") ///
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
  saving($graphdir/dollars1P_meancoefs_pre8AM, replace)

graph export $graphdir/dollars1P_meancoefs_pre8AM.eps, logo(off) replace
!epstopdf $graphdir/dollars1P_meancoefs_pre8AM.eps

restore




* With Demog:

*xi: reg dollars i.zone*after  i.txweek i.txdow
*xi: reg txs i.zone*after n_* worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow
*xi: reg cals i.zone*after n_* worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow
*xi: reg items i.zone*after n_* worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow


describe

* This calorie regression includes number of chain restaurants interacted with after variable and city
*ge n_chainrest_after=n_chainrest*after
*xi: reg logcals i.zone*after i.zone*n_chainrest i.zone*n_chainrest_after n_* n_chainrest_after worker* pop25* white* black* asian* hisp* age* male* female* avg* med* i.txweek i.txdow
  



log close
