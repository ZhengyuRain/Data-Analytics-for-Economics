
*setup_storeweek2.do

log using ../logs/setup_storeweek2, text replace

* USES SINGLE PERSON TRANS.
* Non-consumable and meal items have been removed!

clear
use /data/gsb/SBC/working/setup_sumstats2
*use ../data/working/setup_sumstats2

set more off

* already sorted: sort store txmonth txday txid


* zone=5 if city=="SAN FRANCISCO"
* zone=15 if city=="BOSTON"
* zone=16 if city=="NEW YORK"
* zone=51 if city=="PHILADELPHIA"
* zone=64 if city=="JERSEY CITY"

*************** USE ONLY SINGLE PERSON TRANSACTIONS *********************
* Single person transactions only!
keep if multiplepeople==0


******* Generate store-week variables *****

* Keep Only one Obs per Txn
keep if diff_tx

sort store txweek
by store txweek: egen meantxcal=mean(txcal)
by store txweek: egen meanitemsper=mean(itemsper)
by store txweek: egen meandollarsper=mean(dollarsper)
by store txweek: egen meantxhasdrink=mean(txhasdrink)


sort store txweek
drop if store==store[_n-1] & txweek == txweek[_n-1]
drop diff_tx

sort store txweek
merge store txweek using ../data/working/setup_storeweek1
tab _merge
* SHOULD BE ALL 3s
keep if _merge==3
drop _merge

compress
sort store txweek

save ../data/working/setup_storeweek2, replace

log close



