
*setup_city_txs_ch.do

log using $logdir/setup_city_txs_ch, text replace


clear
use $bigdatadir/working/ch/setup_daily_txs
sort store txyear txmonth txday 





* FOR NY, USE ONLY PRE PERIOD:
drop if zone==16 & after_nyc==1

keep if zone==15 | zone==16 | zone==51

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

sort zone store txweek

ge tempvar=store~=store[_n-1] | txweek~=txweek[_n-1]

bysort zone: egen storeweeksperzone=total(tempvar)
drop tempvar

* Revenue and transactions per week:

bysort zone: egen daysperzone = count(dollarsperday)
bysort zone: egen dollarsperzone = total(dollarsperday)
bysort zone: egen txsperzone = total(txsperday)
bysort zone: egen itemsperzone = total(itemsperday)

ge dollarsperstoreweek=dollarsperzone/storeweeksperzone
ge txsperstoreweek=txsperzone/storeweeksperzone
ge itemsperstoreweek=itemsperzone/storeweeksperzone


replace dollarsperitem=dollarsperzone/itemsperzone

**** Vars that total values over subset of items ***

* Calories and Items per Transaction (consumables and non-meal only)

bysort zone: egen cal1T_zone=total(calsper1T*tx1T_wcalitem)
bysort zone: egen items1T_zone = total(itemsper1T*tx1T)
bysort zone: egen cal1Tdrinks_zone=total(calsper1Tdrinks*tx1T_wcalitem)
bysort zone: egen items1Tdrinks_zones = total(itemsper1Tdrinks*tx1T)
bysort zone: egen cal1Tsnacks_zone=total(calsper1Tsnacks*tx1T_wcalitem)
bysort zone: egen items1Tsnacks_zone = total(itemsper1Tsnacks*tx1T)
* include meal items for dollars per transaction
bysort zone: egen dollars1T_zone = total(dollarsper1T*tx1T)



* Calories and Items per Person (i.e. per tx using single person txs, consumables and non-meal only)



* Calories and Items per Transaction (consumables and non-meal only)

bysort zone: egen tx1T_zone = total(tx1T)
bysort zone: egen tx1T_wcalitem_zone = total(tx1T_wcalitem)
bysort zone: egen hasdrink1T_zone = total(hasdrink1T)
bysort zone: egen hassnack1T_zone = total(hassnack1T)
bysort zone: egen hasfood1T_zone = total(hasfood1T)
bysort zone: egen hasdrinkandfood1T_zone = total(hasdrinkandfood1T)
bysort zone: egen hashotcoffee1T_zone = total(hashotcoffee1T)


***************************************************

* Keep one obs per zone
drop if (zone==zone[_n-1])


*********************** DVs ****************************

* All transactions:

* average calories and items per tx
ge calsper1T_zone=cal1T_zone/tx1T_wcalitem_zone
ge calsper1Tdrinks_zone=cal1Tdrinks_zone/tx1T_wcalitem_zone
ge calsper1Tsnacks_zone=cal1Tsnacks_zone/tx1T_wcalitem_zone

ge itemsper1T_zone=items1T_zone/tx1T_zone
ge itemsper1Tdrinks_zone=items1Tdrinks_zone/tx1T_zone
ge itemsper1Tsnacks_zone=items1Tsnacks_zone/tx1T_zone

ge dollarsper1T_zone=dollars1T_zone/tx1T_zone
ge foodattach1T_zone=hasdrinkandfood1T_zone/hasdrink1T_zone

ge frachasdrink1T_zone=hasdrink1T_zone/tx1T_zone
ge frachassnack1T_zone=hassnack1T_zone/tx1T_zone
ge frachashotcoffee1T_zone=hashotcoffee1T_zone/tx1T_zone

ge frachascalitem=tx1T_wcalitem_zone/tx1T_zone


******************************************************

keep store zone dat txyear txmonth txday txweek txdow after* calsper* itemsper* txsper* dollarsper* foodattach* frachas*  



save $bigdatadir/working/ch/setup_city_txs, replace



log close
