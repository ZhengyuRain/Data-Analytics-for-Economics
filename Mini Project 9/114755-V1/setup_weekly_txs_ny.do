
* setup_weekly_txs_ny.do
* totals over all new york stores for each week

log using $logdir/setup_weekly_txs_ny, text replace


clear
use $bigdatadir/working/nyc/setup_sumstats1

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

keep store zone dat txyear txmonth txday txweek txdow nds_amt cal after* diff_tx multiplepeople type txhas*


sort txweek

* Revenue and transactions per week:

bysort txweek: egen dollarsperweek = total(nds_amt)
bysort txweek: egen txsperweek = total(diff_tx)
bysort txweek: egen itemsperweek = count(diff_tx)

ge dollarsperitem=dollarsperweek/itemsperweek

**** Vars that total values over subset of items ***

* Calories and Items per Person (i.e. per tx using single person txs, consumables and non-meal only)

bysort txweek: egen cal1P=total(cal*(1-multiplepeople)*(type~=0)*(type~=5))
bysort txweek: egen items1P = total((1-multiplepeople)*(type~=0)*(type~=5))
bysort txweek: egen cal1Pdrinks=total(cal*(1-multiplepeople)*(type~=0)*(type==1))
bysort txweek: egen items1Pdrinks = total((1-multiplepeople)*(type~=0)*(type==1))
bysort txweek: egen cal1Psnacks=total(cal*(1-multiplepeople)*(type~=0)*(type==2))
bysort txweek: egen items1Psnacks = total((1-multiplepeople)*(type~=0)*(type==2))
* include meal items for dollars per transaction
bysort txweek: egen dollars1P = total(nds_amt*(1-multiplepeople)*(type~=0))


* Calories and Items per Transaction (consumables and non-meal only)

bysort txweek: egen cal1T=total(cal*(type~=0)*(type~=5))
bysort txweek: egen items1T = total((type~=0)*(type~=5))
bysort txweek: egen cal1Tdrinks=total(cal*(type~=0)*(type==1))
bysort txweek: egen items1Tdrinks = total((type~=0)*(type==1))
bysort txweek: egen cal1Tsnacks=total(cal*(type~=0)*(type==2))
bysort txweek: egen items1Tsnacks = total((type~=0)*(type==2))
* include meal items for dollars per transaction
bysort txweek: egen dollars1T = total(nds_amt*(type~=0))


keep if diff_tx==1
*** Vars that total values over subset of transactions ***
* Calories and Items per Person (i.e. per tx using single person txs, consumables and non-meal only)


bysort txweek: egen tx1P = total(diff_tx*(1-multiplepeople))
bysort txweek: egen hasdrink1P = total(diff_tx*(1-multiplepeople)*txhasdrink)
bysort txweek: egen hassnack1P = total(diff_tx*(1-multiplepeople)*txhassnack)
bysort txweek: egen hasfood1P = total(diff_tx*(1-multiplepeople)*max(txhassnack,txhasmeal))
bysort txweek: egen hasdrinkandfood1P = total(diff_tx*(1-multiplepeople)*min(txhasdrink,max(txhassnack,txhasmeal)))


* Calories and Items per Transaction (consumables and non-meal only)

bysort txweek: egen tx1T = total(diff_tx)
bysort txweek: egen hasdrink1T = total(diff_tx*txhasdrink)
bysort txweek: egen hassnack1T = total(diff_tx*txhassnack)
bysort txweek: egen hasfood1T = total(diff_tx*max(txhassnack,txhasmeal))
bysort txweek: egen hasdrinkandfood1T = total(diff_tx*min(txhasdrink,max(txhassnack,txhasmeal)))


***************************************************

* Keep one obs per city-week
drop if (txweek==txweek[_n-1])

* Drop if no transactions that day
drop if tx1T==0

*********************** DVs ****************************

* 1-person transactions:

* average calories and items per one-person tx
ge calsper1P=cal1P/tx1P
ge calsper1Pdrinks=cal1Pdrinks/tx1P
ge calsper1Psnacks=cal1Psnacks/tx1P

ge itemsper1P=items1P/tx1P
ge itemsper1Pdrinks=items1P/tx1P
ge itemsper1Psnacks=items1P/tx1P

ge dollarsper1P=dollars1P/tx1P
ge foodattach1P=hasdrinkandfood1P/hasdrink1P

ge frachasdrink1P=hasdrink1P/tx1P
ge frachassnack1P=hasdrink1P/tx1P

* All transactions:

* average calories and items per tx
ge calsper1T=cal1T/tx1T
ge calsper1Tdrinks=cal1Tdrinks/tx1T
ge calsper1Tsnacks=cal1Tsnacks/tx1T

ge itemsper1T=items1T/tx1T
ge itemsper1Tdrinks=items1T/tx1T
ge itemsper1Tsnacks=items1T/tx1T

ge dollarsper1T=dollars1T/tx1T
ge foodattach1T=hasdrinkandfood1T/hasdrink1T

ge frachasdrink1T=hasdrink1T/tx1T
ge frachassnack1T=hasdrink1T/tx1T

******************************************************

keep store zone dat txyear txmonth txday txweek txdow after* calsper* itemsper* txsper* dollarsper* foodattach* frachas*  


save $bigdatadir/working/$currentcity/setup_weekly_txs, replace




log close
