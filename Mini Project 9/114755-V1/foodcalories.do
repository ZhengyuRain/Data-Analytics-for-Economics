
*foodcalories.do

clear
use ../data/working/foodcalories_bystoreid
append using ../data/working/foodcal_zoneinfo

* assume calories by product and zone
sort name foodzone cal
egen name_zone=group(name foodzone)
drop if name_zone==name_zone[_n-1]

*returns number of food items that differ accross stores
sort name cal
count if name==name[_n-1] & cal~=cal[_n-1]
by name: egen maxcal=max(cal)
by name: egen mincal=min(cal)
ge zonematters=1 if maxcal~=mincal
*ge zonematters=1 if name==name[_n-1] | name==name[_n+1]
count if zonematters==1


*returns number of food items that differ accross stores within zone
*should be zero
sort name_zone cal
count if name_zone==name_zone[_n-1] & cal~=cal[_n-1]


drop store_id
replace foodzone=0 if zonematters~=1

append using ../data/working/foodcal_zoneinfo_allzones_nozoneids

replace foodzone =0 if foodzone==.

drop name_zone
sort name foodzone 
egen name_zone=group(name foodzone)
drop if name_zone==name_zone[_n-1]
drop if foodzone==0 & (name==name[_n-1] | name==name[_n+1])

ge type=2

save ../data/working/foodcalories, replace
