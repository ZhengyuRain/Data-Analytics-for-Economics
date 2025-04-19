
*setup_daily_txs.do

log using $logdir/$currentcity/setup_daily_txs2, text replace


clear
use $bigdatadir/working/$currentcity/setup_sumstats2

*USE SUMSTATS2 

keep store zone dat txyear txmonth txday txweek txdow nds_amt nds_qty cal after* diff_tx multiplepeople type txhas*


sort store txyear txmonth txday

* Revenue and transactions per Day:

bysort store txyear txmonth txday: egen dollarsperday = total(nds_amt)
bysort store txyear txmonth txday: egen txsperday = total(diff_tx)
bysort store txyear txmonth txday: egen itemsperday = total(nds_qty)


ge dollarsperitem=dollarsperday/itemsperday

**** Vars that total values over subset of items ***

* Calories and Items per Person (i.e. per tx using single person txs, consumables and non-meal only)

bysort store txyear txmonth txday: egen cal1P=total(cal*(1-multiplepeople)*(type~=0)*(type~=5))
bysort store txyear txmonth txday: egen items1P = total(nds_qty*(1-multiplepeople)*(type~=0)*(type~=5))
bysort store txyear txmonth txday: egen cal1Pdrinks=total(cal*(1-multiplepeople)*(type~=0)*(type==1))
bysort store txyear txmonth txday: egen items1Pdrinks = total(nds_qty*(1-multiplepeople)*(type~=0)*(type==1))
bysort store txyear txmonth txday: egen cal1Psnacks=total(cal*(1-multiplepeople)*(type~=0)*(type==2))
bysort store txyear txmonth txday: egen items1Psnacks = total(nds_qty*(1-multiplepeople)*(type~=0)*(type==2))
* include meal items for dollars per transaction
bysort store txyear txmonth txday: egen dollars1P = total(nds_amt*(1-multiplepeople)*(type~=0))


* Calories and Items per Transaction (consumables and non-meal only)

bysort store txyear txmonth txday: egen cal1T=total(cal*(type~=0)*(type~=5))
bysort store txyear txmonth txday: egen items1T = total(nds_qty*(type~=0)*(type~=5))
bysort store txyear txmonth txday: egen cal1Tdrinks=total(cal*(type~=0)*(type==1))
bysort store txyear txmonth txday: egen items1Tdrinks = total(nds_qty*(type~=0)*(type==1))
bysort store txyear txmonth txday: egen cal1Tsnacks=total(cal*(type~=0)*(type==2))
bysort store txyear txmonth txday: egen items1Tsnacks = total(nds_qty*(type~=0)*(type==2))
* include meal items for dollars per transaction
bysort store txyear txmonth txday: egen dollars1T = total(nds_amt*(type~=0))


keep if diff_tx==1
*** Vars that total values over subset of transactions ***
* Calories and Items per Person (i.e. per tx using single person txs, consumables and non-meal only)


bysort store txyear txmonth txday: egen tx1P = total(diff_tx*(1-multiplepeople))
bysort store txyear txmonth txday: egen hasdrink1P = total(diff_tx*(1-multiplepeople)*txhasdrink)
bysort store txyear txmonth txday: egen hassnack1P = total(diff_tx*(1-multiplepeople)*txhassnack)
bysort store txyear txmonth txday: egen hasfood1P = total(diff_tx*(1-multiplepeople)*max(txhassnack,txhasmeal))
bysort store txyear txmonth txday: egen hasdrinkandfood1P = total(diff_tx*(1-multiplepeople)*min(txhasdrink,max(txhassnack,txhasmeal)))


* Calories and Items per Transaction (consumables and non-meal only)

bysort store txyear txmonth txday: egen tx1T = total(diff_tx)
bysort store txyear txmonth txday: egen hasdrink1T = total(diff_tx*txhasdrink)
bysort store txyear txmonth txday: egen hassnack1T = total(diff_tx*txhassnack)
bysort store txyear txmonth txday: egen hasfood1T = total(diff_tx*max(txhassnack,txhasmeal))
bysort store txyear txmonth txday: egen hasdrinkandfood1T = total(diff_tx*min(txhasdrink,max(txhassnack,txhasmeal)))


***************************************************

* Keep one obs per day
drop if (store==store[_n-1] & txyear==txyear[_n-1] & txmonth==txmonth[_n-1] & txday==txday[_n-1])

* Drop if no transactions that day
drop if tx1T==0

*********************** DVs ****************************

* 1-person transactions:

* average calories and items per one-person tx
ge calsper1P=cal1P/tx1P
ge calsper1Pdrinks=cal1Pdrinks/tx1P
ge calsper1Psnacks=cal1Psnacks/tx1P

ge itemsper1P=items1P/tx1P
ge itemsper1Pdrinks=items1Pdrinks/tx1P
ge itemsper1Psnacks=items1Psnacks/tx1P

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
ge itemsper1Tdrinks=items1Tdrinks/tx1T
ge itemsper1Tsnacks=items1Tsnacks/tx1T

ge dollarsper1T=dollars1T/tx1T
ge foodattach1T=hasdrinkandfood1T/hasdrink1T

ge frachasdrink1T=hasdrink1T/tx1T
ge frachassnack1T=hassnack1T/tx1T

******************************************************

keep store zone dat txyear txmonth txday txweek txdow after* tx1P tx1T calsper* itemsper* txsper* dollarsper* foodattach* has* frachas*  


save $bigdatadir/working/$currentcity/setup_daily_txs2, replace




log close
