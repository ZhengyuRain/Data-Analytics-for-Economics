
* sdd_sumstats1



clear
set more off
set mem 15g

log using $logdir/sdd_sumstats1, text replace

* sdd_sumstats1.do
use $datadir/working/sdd

ge ny=zone==16

* Doesn't include days with none
bysort zone: tabstat quantity, by(milktype) stats(mean sd min p10 med p90 max)




sort zone store
ge temp=store~=store[_n-1]
by zone: egen nstores_zone=total(temp)
drop temp

sort ny store
ge temp=store~=store[_n-1]
by ny: egen nstores_ny=total(temp)
drop temp

sort zone txweek milktype
by zone txweek milktype: egen q_zwm = total(quantity/7/nstores_zone)
label var q_zwm "Average Daily Milk Volume by Type"

sort ny txweek milktype
bysort ny txweek milktype: egen q_nywm=total(quantity/7/nstores_ny)
label var q_nywm "Average Daily Milk Volume by Type"




**** Graphs ****

* Weekly milk use by type



tw line q_nywm txweek if ny==1 & milktype==1, ///
  xline(14.286) ///
  xlabel(5(5)35) ///
  title("Daily Milk Use per Week") ///
  ytitle("gallons") ///
  xtitle("week") || ///
line q_nywm txweek if ny==1 & milktype==2, || ///
line q_nywm txweek if ny==1 & milktype==3, || ///
line q_nywm txweek if ny==0 & milktype==1, || ///
line q_nywm txweek if ny==0 & milktype==2, || ///
line q_nywm txweek if ny==0 & milktype==3, ///
  legend(label(1 "New York: Whole") label(4 "Control: Whole") label(2 "New York: Two Percent") label(5 "Control: Two Percent") label(3 "New York: Skim") label(6 "Control: Skim") order(1 4 2 5 3 6)) ///
  ysize(6) xsize(7) ///
  saving($graphdir/milkusage, replace)

graph export $graphdir/milkusage.eps, logo(off) replace
!epstopdf $graphdir/milkusage.eps

* Do average daily milk consumption (need to account for zero order days)

sort zone txweek milktype
drop if txweek > 15 & ny==1
drop if zone==zone[_n-1] & txweek==txweek[_n-1] & milktype==milktype[_n-1]
 
sort zone milktype
bysort zone milktype: su q_zwm

sort ny txweek milktype
drop if txweek > 15 & ny==1
drop if ny==ny[_n-1] & txweek==txweek[_n-1] & milktype==milktype[_n-1]
 
sort ny milktype
bysort ny milktype: su q_nywm


log close
