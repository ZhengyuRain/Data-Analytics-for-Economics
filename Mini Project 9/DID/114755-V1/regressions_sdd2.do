
global statadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/stata
cd $statadir
global datadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/data
global logdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/stata/logs
global tmpdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/tmp
global graphdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/graphs
global bigdatadir /data/gsb/SBC


* regressions_sdd2.do

* USES PRODUCT TOTAL VARIABLES

log using ../logs/regressions_sdd2, text replace

clear
set more off
set mem 15g




use $bigdatadir/working/setup_daily

**** Merge sdd data ****

sort store txmonth txday
merge store txmonth txday using $datadir/working/sdd_reshaped
tab _merge
keep if _merge==3
drop _merge

**** Merge product count data ****

sort store txmonth txday
merge store txmonth txday using $bigdatadir/working/setup_daily_prodnum
tab _merge
keep if _merge==3
drop _merge



ge quantity=quantity1+quantity2+quantity3

*ge share1=quantity1/quantity
*ge share2=quantity2/quantity
*ge share3=quantity3/quantity

*ge sharevar1=-log(-log(share1))
*ge sharevar2=-log(-log(share2))
*ge sharevar3=-log(-log(share3))

* Explanatory vars:

ge law=ny*after

global demog "pop25* white* black* asian* hisp* age* male* female* avg* med*"

ge temp2 = temp^2
ge precip2 = precip^2
global weather "temp temp2 precip precip2"

global business "n_* worker*"

* Regressions, single law dummy:

xi: areg quantity law i.txdow $weather i.txweek prodnum*, absorb(store)
estimates store reg_quantity 

xi: areg quantity1 law i.txdow $weather i.txweek prodnum*, absorb(store)
estimates store reg_quantity1

xi: areg quantity2 law i.txdow $weather i.txweek prodnum*, absorb(store)
estimates store reg_quantity2

xi: areg quantity3 law i.txdow $weather i.txweek prodnum*, absorb(store)
estimates store reg_quantity3


estimates table reg_quantity reg_quantity1 reg_quantity2 reg_quantity3 , b(%9.3f) star(.05 .01 .001) stats(N r2)




* Graph Regression Results for ny-week interaction

global coefrange "35/67"


* quantity:

preserve
xi: areg quantity i.ny*i.txweek $weather i.txdow prodnum*, absorb(store)
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
  title("Total Milk Regression") ///
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
  saving($graphdir/quantity_meancoefs2, replace)

graph export $graphdir/quantity_meancoefs2.eps, logo(off) replace
!epstopdf $graphdir/quantity_meancoefs2.eps
restore




* quantity1:

preserve
xi: areg quantity1 i.ny*i.txweek $weather i.txdow prodnum*, absorb(store)
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
  title("Whole Milk Regression") ///
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
  saving($graphdir/quantity1_meancoefs2, replace)

graph export $graphdir/quantity1_meancoefs2.eps, logo(off) replace
!epstopdf $graphdir/quantity1_meancoefs2.eps
restore


* quantity2:

preserve
xi: areg quantity2 i.ny*i.txweek $weather i.txdow prodnum*, absorb(store)
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
  title("Two Percent Milk Regression") ///
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
  saving($graphdir/quantity2_meancoefs2, replace)

graph export $graphdir/quantity2_meancoefs2.eps, logo(off) replace
!epstopdf $graphdir/quantity2_meancoefs2.eps
restore


* quantity3:

preserve
xi: areg quantity3 i.ny*i.txweek $weather i.txdow prodnum*, absorb(store)
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
  title("Skim Milk Regression") ///
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
  saving($graphdir/quantity3_meancoefs2, replace)

graph export $graphdir/quantity3_meancoefs2.eps, logo(off) replace
!epstopdf $graphdir/quantity3_meancoefs2.eps
restore


log close


