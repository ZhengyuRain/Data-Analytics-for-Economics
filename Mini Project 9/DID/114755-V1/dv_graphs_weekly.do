


*dv_graphs_weekly.do

* sumstats graphs for ny and not ny

log using $logdir/dv_graphs_weekly, text replace

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

**** Graphs **** 

tw line dollarsperweek txweek if citygroups==1, ///
  xline($nyc_adopt) ///
  xline($sea_adopt) ///
  xlabel($xrange) ///
  title("Dollars Per Week") ///
  ytitle("dollars" ) ///
  xtitle("week") || ///
line dollarsperweek txweek if citygroups==2,   ///
  clcolor(red) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/dollarsperday_weekly, replace)
graph export $graphdir/dollarsperday_weekly.eps, logo(off) replace
!epstopdf $graphdir/dollarsperday_weekly.eps

tw line txsperweek txweek if citygroups==1, ///
  xline($nyc_adopt) ///
  xline($sea_adopt) ///
  xlabel($xrange) ///
  title("Transactions per Week") ///
  ytitle("transactions" ) ///
  xtitle("week") || ///
line txsperweek txweek if citygroups==2,   ///
  clcolor(red) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/txsperday_weekly, replace)
graph export $graphdir/txsperday_weekly.eps, logo(off) replace
!epstopdf $graphdir/txsperday_weekly.eps


tw line itemsperweek txweek if citygroups==1, ///
  xline($nyc_adopt) ///
  xline($sea_adopt) ///
  xlabel($xrange) ///
  title("Items per Week") ///
  ytitle("items" ) ///
  xtitle("week") || ///
line itemsperweek txweek if citygroups==2,   ///
  clcolor(red) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/itemsperday_weekly, replace)
graph export $graphdir/itemsperday_weekly.eps, logo(off) replace
!epstopdf $graphdir/itemsperday_weekly.eps

**************** CALS ****************

tw line calsper1T_weekly txweek if citygroups==1, ///
  xline($nyc_adopt) ///
  xline($sea_adopt) ///
  xlabel($xrange) ///
  title("Calories per Transaction") ///
  ytitle("calories" ) ///
  xtitle("week") || ///
line calsper1T_weekly txweek if citygroups==2,   ///
  clcolor(red) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/calsper1T_weekly, replace)
graph export $graphdir/calsper1T_weekly.eps, logo(off) replace
!epstopdf $graphdir/calsper1T_weekly.eps

tw line calsper1Tdrinks_weekly txweek if citygroups==1, ///
  xline($nyc_adopt) ///
  xline($sea_adopt) ///
  xlabel($xrange) ///
  title("Drink Calories per Transaction") ///
  ytitle("calories" ) ///
  xtitle("week") || ///
line calsper1Tdrinks_weekly txweek if citygroups==2,  || ///
line calsper1Tdrinks_weekly txweek if citygroups==3,  || ///
line calsper1Tdrinks_weekly txweek if citygroups==4,   ///
  clcolor(red) ///
  legend(off) ///
  ysize(6) xsize(7) ///
  saving($graphdir/calsper1Tdrinks_weekly.gph, replace)
graph export $graphdir/calsper1Tdrinks_weekly.eps, logo(off) replace
!epstopdf $graphdir/calsper1Tdrinks_weekly.eps

tw line calsper1Tsnacks_weekly txweek if citygroups==1, ///
  xline($nyc_adopt) ///
  xline($sea_adopt) ///
  xlabel($xrange) ///
  title("Snack Calories per Transaction") ///
  ytitle("calories" ) ///
  xtitle("week") || ///
line calsper1Tsnacks_weekly txweek if citygroups==2,   ///
  clcolor(red) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/calsper1Tsnacks_weekly.gph, replace)
graph export $graphdir/calsper1Tsnacks_weekly.eps, logo(off) replace
!epstopdf $graphdir/calsper1Tsnacks_weekly.eps

graph combine $graphdir/calsper1Tdrinks_weekly.gph $graphdir/calsper1Tsnacks_weekly.gph, cols(1) ysize(9) xsize(6.5) xcommon saving($graphdir/figure1.gph, replace)
graph export $graphdir/figure1.eps, logo(off) orientation(portrait) replace
!epstopdf $graphdir/figure1.eps

**************** ITEMS ****************

tw line itemsper1T_weekly txweek if citygroups==1, ///
  xline($nyc_adopt) ///
  xline($sea_adopt) ///
  xlabel($xrange) ///
  title("Items per Transaction") ///
  ytitle("items" ) ///
  xtitle("week") || ///
line itemsper1T_weekly txweek if citygroups==2,   ///
  clcolor(red) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/itemsper1T_weekly, replace)
graph export $graphdir/itemsper1T_weekly.eps, logo(off) replace
!epstopdf $graphdir/itemsper1T_weekly.eps

tw line itemsper1Tdrinks_weekly txweek if citygroups==1, ///
  xline($nyc_adopt) ///
  xline($sea_adopt) ///
  xlabel($xrange) ///
  title("Drink Items per Transaction") ///
  ytitle("items" ) ///
  xtitle("week") || ///
line itemsper1Tdrinks_weekly txweek if citygroups==2,   ///
  clcolor(red) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/itemsper1Tdrinks_weekly, replace)
graph export $graphdir/itemsper1Tdrinks_weekly.eps, logo(off) replace
!epstopdf $graphdir/itemsper1Tdrinks_weekly.eps

tw line itemsper1Tsnacks_weekly txweek if citygroups==1, ///
  xline($nyc_adopt) ///
  xline($sea_adopt) ///
  xlabel($xrange) ///
  title("Snack Items per Transaction") ///
  ytitle("items" ) ///
  xtitle("week") || ///
line itemsper1Tsnacks_weekly txweek if citygroups==2,   ///
  clcolor(red) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/itemsper1Tsnacks_weekly, replace)
graph export $graphdir/itemsper1Tsnacks_weekly.eps, logo(off) replace
!epstopdf $graphdir/itemsper1Tsnacks_weekly.eps


**************** OTHER DVS ****************

tw line dollarsper1T_weekly txweek if citygroups==1, ///
  xline($nyc_adopt) ///
  xline($sea_adopt) ///
  xlabel($xrange) ///
  title("Dollars per Transaction") ///
  ytitle("dollars" ) ///
  xtitle("week") || ///
line dollarsper1T_weekly txweek if citygroups==2,   ///
  clcolor(red) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/dollarsper1T_weekly, replace)
graph export $graphdir/dollarsper1T_weekly.eps, logo(off) replace
!epstopdf $graphdir/dollarsper1T_weekly.eps

tw line foodattach1T_weekly txweek if citygroups==1, ///
  xline($nyc_adopt) ///
  xline($sea_adopt) ///
  xlabel($xrange) ///
  title("Food Attach Rate") ///
  ytitle("fraction" ) ///
  xtitle("week") || ///
line foodattach1T_weekly txweek if citygroups==2,   ///
  clcolor(red) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/foodattach1T_weekly, replace)
graph export $graphdir/foodattach1T_weekly.eps, logo(off) replace
!epstopdf $graphdir/foodattach1T_weekly.eps

tw line frachasdrink1T_weekly txweek if citygroups==1, ///
  xline($nyc_adopt) ///
  xline($sea_adopt) ///
  xlabel($xrange) ///
  title("Fraction of Transactions with Drink") ///
  ytitle("fraction" ) ///
  xtitle("week") || ///
line frachasdrink1T_weekly txweek if citygroups==2,   ///
  clcolor(red) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/frachasdrink1T_weekly, replace)
graph export $graphdir/frachasdrink1T_weekly.eps, logo(off) replace
!epstopdf $graphdir/frachasdrink1T_weekly.eps

tw line frachassnack1T_weekly txweek if citygroups==1, ///
  xline($nyc_adopt) ///
  xline($sea_adopt) ///
  xlabel($xrange) ///
  title("Fraction of Transactions with Snack") ///
  ytitle("fraction" ) ///
  xtitle("week") || ///
line frachassnack1T_weekly txweek if citygroups==2,   ///
  clcolor(red) ///
  legend(label(1 "New York") label(2 "Boston & Philadelphia")) ///
  ysize(6) xsize(7) ///
  saving($graphdir/frachassnack1T_weekly, replace)
graph export $graphdir/frachassnack1T_weekly.eps, logo(off) replace
!epstopdf $graphdir/frachassnack1T_weekly.eps

***************************************************

log close


