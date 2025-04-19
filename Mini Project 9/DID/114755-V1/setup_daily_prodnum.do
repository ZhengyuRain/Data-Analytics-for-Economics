
*setup_daily_prodnum.do

log using ../logs/setup_daily_prodnum, text replace

global bigdatadir /data/gsb/SBC

clear
set more off
set mem 15g


use /data/gsb/SBC/working/setup_sumstats1
*use ../data/working/setup_sumstats1

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

keep if type==1

keep store txmonth txday prod_num

sort store txmonth txday prod_num

* Revenue and transactions per Day:

bysort store txmonth txday prod_num: egen prodnumperday = count(prod_num)

drop if store==store[_n-1] & txmonth==txmonth[_n-1] & txday==txday[_n-1] & prod_num==prod_num[_n-1]


reshape wide prodnumperday, i(store txmonth txday) j(prod_num)

sort store txmonth txday

save $bigdatadir/working/setup_daily_prodnum, replace

log close
