
* setup_daily

clear


use $bigdatadir/working/$currentcity/setup_daily_txs_quantiles, replace


sort zone txyear txmonth txday
merge zone txyear txmonth txday using $datadir/working/weather
tab _merge
drop if _merge==2
drop _merge

sort store
merge store using $datadir/working/explvar
tab _merge
drop if _merge==2
drop _merge

sort txyear txmonth txday
merge txyear txmonth txday using ../data/working/holidays
tab _merge
drop if _merge==2
drop _merge
replace holiday=0 if holiday==.


save $bigdatadir/working/$currentcity/setup_daily_quantiles, replace
