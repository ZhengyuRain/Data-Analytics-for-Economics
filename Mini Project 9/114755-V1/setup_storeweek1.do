
*setup_storeweek1.do
* sets up store-week revenue and transaction variables

log using ../logs/setup_storeweek1, text replace

set more off

************** Generate store level data *********

clear
use /data/gsb/SBC/working/setup_sumstats1
*use ../data/working/setup_sumstats1

*INCLUDES NON CONSUMABLES
*DOES AGGREAGTION BY STORE_WEEK

keep store zone cal nds_amt rgstr_type_cd after txweek txhasother multiplepeople diff_tx type


* Generate vars
sort store txweek
by store txweek: egen weeklystrevenue=total(nds_amt)
by store txweek: egen weeklysttransactions=total(diff_tx)

**************** Generate vars for consumables, non-meal (C) **************
* DROP NON_CONSUMABLES
drop if type==0
* DROP MEAL ITEMS: CAL INFO INCOMPLETE
drop if type==5

sort store txweek
by store txweek: egen weeklystrevenueC=total(nds_amt)
by store txweek: egen weeklysttransactionsC=total(diff_tx)

************* Generate vars for consumables, non-meal (C), single person (1P) **************
sort store txweek
by store txweek: egen weeklystrevenueC1P=total(nds_amt*(1-multiplepeople))
by store txweek: egen weeklysttransactionsC1P=total(diff_tx*(1-multiplepeople))


* Keep 1 obs per store=week

drop if store==store[_n-1] & txweek==txweek[_n-1]
drop diff_tx

keep st* txweek weekly* zone

compress

sort store txweek

save ../data/working/setup_storeweek1, replace

log close


