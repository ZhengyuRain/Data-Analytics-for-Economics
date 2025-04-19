
* sb_stores

clear
use $datadir/working/storeinfo

sort zip
merge zip using $datadir/working/zips_intxs
tab _merge
keep if _merge==3
drop _merge

save $datadir/working/sb_stores1, replace

clear
insheet using $datadir/geo/sb_stores_geo.txt

sort store
merge store using $datadir/working/sb_stores1
keep if _merge==2

save $datadir/working/sb_stores2, replace
outsheet store storename address city state zip using $datadir/working/sb_stores2.txt, noq replace
