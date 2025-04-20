
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
bysort store txweek: egen itemsperweek = count(itemsperday)

replace dollarsperitem=dollarsperweek/itemsperweek

**** Vars that total values over subset of items ***

* Calories and Items per Person (i.e. per tx using single person txs, consumables and non-meal only)


bysort store txweek: egen cal1P_weekly=total(calsper1P*tx1P)
bysort store txweek: egen items1P_weekly = total(itemsper1P*tx1P)
bysort store txweek: egen cal1Pdrinks_weekly=total(calsper1Pdrinks*tx1P)
bysort store txweek: egen items1Pdrinks_weekly = total(itemsper1Pdrinks*tx1P)
bysort store txweek: egen cal1Psnacks_weekly=total(calsper1Psnacks*tx1P)
bysort store txweek: egen items1Psnacks_weekly = total(itemsper1Psnacks*tx1P)
* include meal items for dollars per transaction
bysort store txweek: egen dollars1P_weekly = total(dollarsper1P*tx1P)

* Calories and Items per Transaction (consumables and non-meal only)

bysort store txweek: egen cal1T_weekly=total(calsper1P*tx1T)
bysort store txweek: egen items1T_weekly = total(itemsper1P*tx1T)
bysort store txweek: egen cal1Tdrinks_weekly=total(calsper1Pdrinks*tx1T)
bysort store txweek: egen items1Tdrink_weeklys = total(itemsper1Pdrinks*tx1T)
bysort store txweek: egen cal1Tsnacks_weekly=total(calsper1Psnacks*tx1T)
bysort store txweek: egen items1Tsnacks_weekly = total(itemsper1Psnacks*tx1T)
* include meal items for dollars per transaction
bysort store txweek: egen dollars1T_weekly = total(dollarsper1P*tx1T)



* Calories and Items per Person (i.e. per tx using single person txs, consumables and non-meal only)


bysort store txweek: egen tx1P_weekly = total(tx1P)
bysort store txweek: egen hasdrink1P_weekly = total(hasdrink1P)
bysort store txweek: egen hassnack1P_weekly = total(hassnack1P)
bysort store txweek: egen hasfood1P_weekly = total(hasfood1P)
bysort store txweek: egen hasdrinkandfood1P_weekly = total(hasdrinkandfood1P)


* Calories and Items per Transaction (consumables and non-meal only)

bysort store txweek: egen tx1T_weekly = total(tx1T)
bysort store txweek: egen hasdrink1T_weekly = total(hasdrink1T)
bysort store txweek: egen hassnack1T_weekly = total(hassnack1T)
bysort store txweek: egen hasfood1T_weekly = total(hasfood1T)
bysort store txweek: egen hasdrinkandfood1T_weekly = total(hasdrinkandfood1T)


***************************************************

* Keep one obs per store-week
drop if (store==store[_n-1] & txweek==txweek[_n-1])

* Drop if no transactions that day
drop if tx1T==0

*********************** DVs ****************************

* 1-person transactions:

* average calories and items per one-person tx
ge calsper1P_weekly=cal1P_weekly/tx1P_weekly
ge calsper1Pdrinks_weekly=cal1Pdrinks_weekly/tx1P_weekly
ge calsper1Psnacks_weekly=cal1Psnacks_weekly/tx1P_weekly

ge itemsper1P_weekly=items1P_weekly/tx1P_weekly
ge itemsper1Pdrinks_weekly=items1P_weekly/tx1P_weekly
ge itemsper1Psnacks_weekly=items1P_weekly/tx1P_weekly

ge dollarsper1P_weekly=dollars1P_weekly/tx1P_weekly
ge foodattach1P_weekly=hasdrinkandfood1P_weekly/hasdrink1P_weekly

ge frachasdrink1P_weekly=hasdrink1P_weekly/tx1P_weekly
ge frachassnack1P_weekly=hasdrink1P_weekly/tx1P_weekly

* All transactions:

* average calories and items per tx
ge calsper1T_weekly=cal1T_weekly/tx1T_weekly
ge calsper1Tdrinks_weekly=cal1Tdrinks_weekly/tx1T_weekly
ge calsper1Tsnacks_weekly=cal1Tsnacks_weekly/tx1T_weekly

ge itemsper1T_weekly=items1T_weekly/tx1T_weekly
ge itemsper1Tdrinks_weekly=items1T_weekly/tx1T_weekly
ge itemsper1Tsnacks_weekly=items1T_weekly/tx1T_weekly

ge dollarsper1T_weekly=dollars1T_weekly/tx1T_weekly
ge foodattach1T_weekly=hasdrinkandfood1T_weekly/hasdrink1T_weekly

ge frachasdrink1T_weekly=hasdrink1T_weekly/tx1T_weekly
ge frachassnack1T_weekly=hasdrink1T_weekly/tx1T_weekly

******************************************************

keep store zone dat txyear txmonth txday txweek txdow after* calsper* itemsper* txsper* dollarsper* foodattach* frachas*  


save $bigdatadir/working/$currentcity/setup_weekly_txs, replace




log close
