
*setup_sumstats3
* Adds product types

log using $logdir/$currentcity/setup_sumstats3, text replace

clear
use $bigdatadir/working/$currentcity/setup_sumstats1

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

keep prod_num store zone dat txyear txmonth txday txweek txdow nds_amt nds_qty sub_dept_cd cal after* diff_tx multiplepeople type txhas* 

sort prod_num
merge prod_num using $datadir/working/drinktypedummies
tab _merge
drop _merge

sort store txyear txmonth txday

save $bigdatadir/working/$currentcity/setup_sumstats3, replace

log close
