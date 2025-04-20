
clear
do var_nyc
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo
tab _merge
keep if _merge==3
drop _merge
keep zip
sort zip
drop if zip==zip[_n-1]
save $datadir/working/$currentcity/zips, replace

clear
do var_jer
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo
tab _merge
keep if _merge==3
drop _merge
keep zip
sort zip
drop if zip==zip[_n-1]
save $datadir/working/$currentcity/zips, replace

clear
do var_bos
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo
tab _merge
keep if _merge==3
drop _merge
keep zip
sort zip
drop if zip==zip[_n-1]
save $datadir/working/$currentcity/zips, replace

clear
do var_phi
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo
tab _merge
keep if _merge==3
drop _merge
keep zip
sort zip
drop if zip==zip[_n-1]
save $datadir/working/$currentcity/zips, replace

clear
do var_sea
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo
tab _merge
keep if _merge==3
drop _merge
keep zip
sort zip
drop if zip==zip[_n-1]
save $datadir/working/$currentcity/zips, replace

clear
do var_sfr
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo
tab _merge
keep if _merge==3
drop _merge
keep zip
sort zip
drop if zip==zip[_n-1]
save $datadir/working/$currentcity/zips, replace

clear
do var_por
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo
tab _merge
keep if _merge==3
drop _merge
keep zip
sort zip
drop if zip==zip[_n-1]
save $datadir/working/$currentcity/zips, replace

clear
use $datadir/working/nyc/zips
append using $datadir/working/jer/zips
append using $datadir/working/bos/zips
append using $datadir/working/phi/zips
append using $datadir/working/sea/zips
append using $datadir/working/sfr/zips
append using $datadir/working/por/zips

sort zip
save $datadir/working/zips_intxs, replace



