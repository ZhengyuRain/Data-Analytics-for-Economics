
* zipbyzone.do

clear

use $datadir/working/storeinfo

keep zip zone

sort zip 
drop if zip==zip[_n-1]

sort zip


save ../data/working/zipbyzone, replace
