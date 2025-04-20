
clear

use $datadir/working/storeinfo_entirestate

sort store
merge store using $datadir/working/stores_intxs
tab _merge
keep if _merge==3
drop _merge


sort store
save $datadir/working/storeinfo, replace


keep store zone parttime
sort store

save $datadir/working/storezones, replace
