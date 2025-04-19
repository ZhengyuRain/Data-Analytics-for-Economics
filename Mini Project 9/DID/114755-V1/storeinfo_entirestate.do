
*storeinfo_entirestate.do

* Uses entre state for NY, MA, PA, CA, JER, OR, WA

clear


insheet using $datadir/sb/calorie_stores_all.csv

*insheet using $datadir/sb/seattle_portland_store_info.csv
*save $datadir/working/$currentcity/seattle_portland_stores, replace
*clear
*insheet using $datadir/sb/phil_boston_newstores.txt
*save $datadir/working/phil_boston_newstores, replace
*clear
*insheet using $datadir/sb/storedata.txt
** Append Seattle and Portland
*append using $datadir/working/seattle_portland_stores
*append using $datadir/working/phil_boston_newstores



drop v*

rename store_num store
rename ops_store_nm storename
rename store_open_dt opened
rename loc_attr_1_descr locdesc
rename loc_attr_2_descr storedesc

rename mail_line_1_add address
rename mail_line_2_add city
rename st_cd state
rename dma_cd dma
rename retail_sq_ft_meas sqft
rename sm_cnty_nm county

replace county = "NEW YORK COUNTY" if county=="Manhattan"

ge zip=real(postal_cd)
* string zips in other countries
drop if zip==.
replace zip=floor(zip/10000) if zip>99999

* Drop Seatle's Best
drop if strpos(storename,"(SBC)")~=0

keep store storename opened locdesc storedesc address city state dma sqft zip county

drop if store==.

ge openedtemp=subinstr(opened,"/", " ",5)
ge openmonth=real(word(openedtemp,1))
ge openday=real(word(openedtemp,2))
ge openyear=real(word(openedtemp,3))



* Use states since boroughs listed, not cities"
ge zone=.
replace zone=5 if state=="CA"
replace zone=15 if state=="MA"
replace zone=16 if state=="NY"
replace zone=51 if state=="PA"
replace zone=64 if state=="NJ"
replace zone=11 if state=="OR"
replace zone=24 if state=="WA"



* Label Zones
label define zonelabel 5 "San Francisco" 11 "Portland" 15 "Boston" 16 "New York" 24 "Seattle" 51 "Philadelphia" 64 "Jersey City" 
label values zone zonelabel
label var zone "City"


****** Generate indicator for sote opening in data period *****
* (closing to be added later, data now has only active stores)

ge parttime=mdy(openmonth,openday,openyear)>mdy(1,1,2008)
replace parttime=0 if openyear==.

drop if zone==.

sort store
save $datadir/working/storeinfo_entirestate, replace


keep store zone parttime
sort store

save $datadir/working/storezones_entirestate, replace

