

*setup_store2.do


log using ../logs/setup_store2, text replace

clear
use  ../data/working/setup_storeweek2

sort store

* Vars for all items, all transactions
by store: egen averageweeklystrevenue=mean(weeklystrevenue)
by store: egen averageweeklysttransactions=mean(weeklysttransactions)

* Vars for non consumable non meal items, all transactions
by store: egen averageweeklystrevenueC=mean(weeklystrevenueC)
by store: egen averageweeklysttransactionsC=mean(weeklysttransactionsC)

* Vars for non consumable non meal items, single person transactions
by store: egen averagetxcal=mean(meantxcal)
by store: egen averageitemsper=mean(meanitemsper)
by store: egen averagedollarsper=mean(meandollarsper)

keep if store ~=store[_n-1]

sort store

merge store using ../data/working/storeinfo
tab _merge
keep if _merge ~=2
drop _merge

save ../data/working/setup_store2, replace

log close


