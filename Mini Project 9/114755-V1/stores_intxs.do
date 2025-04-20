
clear
do var_nyc
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo_entirestate
tab _merge
keep if _merge==3
drop _merge
keep store
sort store
drop if store==store[_n-1]
save $datadir/working/$currentcity/stores, replace

clear
do var_jer
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo_entirestate
tab _merge
keep if _merge==3
drop _merge
keep store
sort store
drop if store==store[_n-1]
save $datadir/working/$currentcity/stores, replace

clear
do var_bos
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo_entirestate
tab _merge
keep if _merge==3
drop _merge
keep store
sort store
drop if store==store[_n-1]
save $datadir/working/$currentcity/stores, replace

clear
do var_phi
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo_entirestate
tab _merge
keep if _merge==3
drop _merge
keep store
sort store
drop if store==store[_n-1]
save $datadir/working/$currentcity/stores, replace

clear
do var_sea
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo_entirestate
tab _merge
keep if _merge==3
drop _merge
keep store
sort store
drop if store==store[_n-1]
save $datadir/working/$currentcity/stores, replace

clear
do var_sfr
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo_entirestate
tab _merge
keep if _merge==3
drop _merge
keep store
sort store
drop if store==store[_n-1]
save $datadir/working/$currentcity/stores, replace

clear
do var_por
use $bigdatadir/working/$currentcity/setup_daily_txs
sort store
merge store using $datadir/working/storeinfo_entirestate
tab _merge
keep if _merge==3
drop _merge
keep store
sort store
drop if store==store[_n-1]
save $datadir/working/$currentcity/stores, replace

clear
use $datadir/working/nyc/stores
append using $datadir/working/jer/stores
append using $datadir/working/bos/stores
append using $datadir/working/phi/stores
append using $datadir/working/sea/stores
append using $datadir/working/sfr/stores
append using $datadir/working/por/stores

sort store
save $datadir/working/stores_intxs, replace



