


*cal_graphs_weekly.do

* sumstats graphs for ny and not ny

log using $logdir/cal_graphs_weekly, text replace

clear
use $bigdatadir/working/jer/setup_weekly_txs
ge citygroups=0
append using $bigdatadir/working/nyc/setup_weekly_txs
replace citygroups=1 if citygroups==.
append using $bigdatadir/working/bos/setup_weekly_txs
append using $bigdatadir/working/phi/setup_weekly_txs
replace citygroups=2 if citygroups==.
append using $bigdatadir/working/sea/setup_weekly_txs
replace citygroups=3 if citygroups==.
append using $bigdatadir/working/sfr/setup_weekly_txs
append using $bigdatadir/working/por/setup_weekly_txs
replace citygroups=4 if citygroups==.


label var citygroups "City Groupings"
label define citygroupslabel 1 "New York" 2 "New York Controls" 3 "Seattle" 4 "Seattle Controls"
label values citygroups citygroupslabel

*global nyc_adopt 17637
*global sea_adopt 17900
* Jan 5th 2008 to Feb 28th 2009
*global xrange 17536(7)17956

global nyc_adopt 12.286
global sea_adopt 52
global xrange 0(5)60

bysort txweek citygroups: egen calsper1T_weekly_citygroup=mean(calsper1T_weekly)
bysort txweek citygroups: egen calsper1Tdrinks_weekly_citygroup=mean(calsper1Tdrinks_weekly)
bysort txweek citygroups: egen calsper1Tsnacks_weekly_citygroup=mean(calsper1Tsnacks_weekly)

sort txweek citygroups
drop if txweek==txweek[_n-1] & citygroups==citygroups[_n-1]


**** Graphs **** 

**************** CALS ****************

tw line calsper1T_weekly_citygroup txweek if citygroups==1, ///
  xline($nyc_adopt,lpattern(shortdash)) ///
  xlabel(-0.7 "01jan2008" 12.286 "01apr2008" 51.57 "01jan2009") ///
  title("Calories per Transaction") ///
  ytitle("Calories per transaction")  ///
  xtitle(" ") || ///
line calsper1T_weekly_citygroup txweek if citygroups==2,   ///
  lpattern(dash) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/calsper1T_weekly, replace)
graph export $graphdir/calsper1T_weekly.eps, logo(off) replace
!epstopdf $graphdir/calsper1T_weekly.eps

tw line calsper1Tdrinks_weekly_citygroup txweek if citygroups==1, ///
  xline($nyc_adopt,lpattern(shortdash)) ///
  xlabel(-0.7 "01jan2008" 12.286 "01apr2008" 51.57 "01jan2009") ///
  title("Beverages") ///
  ytitle("Calories per transaction") ///
  xtitle(" ") || ///
line calsper1Tdrinks_weekly_citygroup txweek if citygroups==2,   ///
  lpattern(dash) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/calsper1Tdrinks_weekly.gph, replace)
graph export $graphdir/calsper1Tdrinks_weekly.eps, logo(off) replace
!epstopdf $graphdir/calsper1Tdrinks_weekly.eps

tw line calsper1Tsnacks_weekly_citygroup txweek if citygroups==1, ///
  xline($nyc_adopt,lpattern(shortdash)) ///
  xlabel(-0.7 "01jan2008" 12.286 "01apr2008" 51.57 "01jan2009") ///
  title("Food") ///
  ytitle("Calories per transaction") ///
  xtitle(" ") || ///
line calsper1Tsnacks_weekly_citygroup txweek if citygroups==2,   ///
  lpattern(dash) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/calsper1Tsnacks_weekly.gph, replace)
graph export $graphdir/calsper1Tsnacks_weekly.eps, logo(off) replace
!epstopdf $graphdir/calsper1Tsnacks_weekly.eps

graph combine $graphdir/calsper1Tdrinks_weekly.gph $graphdir/calsper1Tsnacks_weekly.gph, cols(1) ysize(9) xsize(6.5) xcommon saving($graphdir/figure1.gph, replace)
graph export $graphdir/figure1.eps, logo(off) orientation(portrait) replace
!epstopdf $graphdir/figure1.eps

***************************************************

log close


