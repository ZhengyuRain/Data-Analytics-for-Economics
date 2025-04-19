
*setup_store1.do
* sets up store-level transaction variables
* DOES NOT INCLUDE MEAL ITEMS AND NON_CONSUMABALES

log using ../logs/setup_store1, text replace

set more off

************** Generate store level data *********

clear
use /data/gsb/SBC/working/setup_sumstats2
*use ../data/working/setup_sumstats2

keep store zone cal nds_amt rgstr_type_cd after

sort store
by store: egen strevenue=total(nds_amt)
by store: egen sttransactions=count(store)
by store: egen stcalories=total(cal)
by store: egen sthasregsisterD=max(rgstr_type_cd=="D")
by store: egen sthasregsisterN=max(rgstr_type_cd=="N")
by store: egen sthasregsisterR=max(rgstr_type_cd=="R")

by store: egen strevenue_before=total(nds_amt*(1-after))
by store: egen sttransactions_before=total((1-after))
by store: egen stcalories_before=total(cal*(1-after))

by store: egen strevenue_after=total(nds_amt*after)
by store: egen sttransactions_after=total(after)
by store: egen stcalories_after=total(cal*after)

drop if store==store[_n-1]

keep st* zone

compress

save ../data/working/setup_store1, replace

log close


