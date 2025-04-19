
*setup_weekly_txs.do

log using $logdir/$currentcity/setup_weekly_txs, text replace


clear
use $bigdatadir/working/$currentcity/setup_daily_txs

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

sort store txweek

* Revenue and transactions per week:

bysort store txweek: egen daysperweek = count(dollarsperday)
bysort store txweek: egen dollarsperweek = total(dollarsperday)
bysort store txweek: egen txsperweek = total(txsperday)
bysort store txweek: egen itemsperweek = total(itemsperday)

replace dollarsperitem=dollarsperweek/itemsperweek

**** Vars that total values over subset of items ***

* Calories and Items per Person (i.e. per tx using single person txs, consumables and non-meal only)


* Calories and Items per Transaction (consumables and non-meal only)

bysort store txweek: egen cal1T_weekly=total(calsper1T*tx1T_wcalitem)
bysort store txweek: egen items1T_weekly = total(itemsper1T*tx1T)
bysort store txweek: egen cal1Tdrinks_weekly=total(calsper1Tdrinks*tx1T)
bysort store txweek: egen items1Tdrink_weeklys = total(itemsper1Tdrinks*tx1T)
bysort store txweek: egen cal1Tsnacks_weekly=total(calsper1Tsnacks*tx1T)
bysort store txweek: egen items1Tsnacks_weekly = total(itemsper1Tsnacks*tx1T)
* include meal items for dollars per transaction
bysort store txweek: egen dollars1T_weekly = total(dollarsper1T*tx1T)


* Calories and Items per Transaction (consumables and non-meal only)

bysort store txweek: egen tx1T_weekly = total(tx1T)
bysort store txweek: egen tx1T_wcalitem_weekly = total(tx1T_wcalitem)
bysort store txweek: egen hasdrink1T_weekly = total(hasdrink1T)
bysort store txweek: egen hassnack1T_weekly = total(hassnack1T)
bysort store txweek: egen hasfood1T_weekly = total(hasfood1T)
bysort store txweek: egen hasdrinkandfood1T_weekly = total(hasdrinkandfood1T)
bysort store txweek: egen hashotcoffee1T_weekly = total(hashotcoffee1T)


***************************************************

* Keep one obs per store-week
drop if (store==store[_n-1] & txweek==txweek[_n-1])

* Drop if no transactions that day
drop if tx1T==0

*********************** DVs ****************************

* All transactions:

* average calories and items per tx
ge calsper1T_weekly=cal1T_weekly/tx1T_wcalitem_weekly
ge calsper1Tdrinks_weekly=cal1Tdrinks_weekly/tx1T_wcalitem_weekly
ge calsper1Tsnacks_weekly=cal1Tsnacks_weekly/tx1T_wcalitem_weekly

ge itemsper1T_weekly=items1T_weekly/tx1T_weekly
ge itemsper1Tdrinks_weekly=items1T_weekly/tx1T_weekly
ge itemsper1Tsnacks_weekly=items1T_weekly/tx1T_weekly

ge dollarsper1T_weekly=dollars1T_weekly/tx1T_weekly
ge foodattach1T_weekly=hasdrinkandfood1T_weekly/hasdrink1T_weekly

ge frachasdrink1T_weekly=hasdrink1T_weekly/tx1T_weekly
ge frachassnack1T_weekly=hasdrink1T_weekly/tx1T_weekly
ge frachashotcoffee_weekly=hashotcoffee1T_weekly/tx1T_weekly

ge frachascalitem=tx1T_wcalitem_weekly/tx1T_weekly



******************************************************

keep store zone dat txyear txmonth txday txweek txdow after* calsper* itemsper* txsper* dollarsper* foodattach* frachas*  


save $bigdatadir/working/$currentcity/setup_weekly_txs, replace




log close
