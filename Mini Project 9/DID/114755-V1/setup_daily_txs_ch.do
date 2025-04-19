
*setup_daily_txs_ch.do

log using $logdir/setup_daily_txs_ch, text replace


clear
use $bigdatadir/working/ch/setup_sumstats1

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

keep store zone dat txyear txmonth txday txweek txdow nds_amt nds_qty cal after* diff_tx multiplepeople type txhas*


sort store txyear txmonth txday

* Revenue and transactions per Day:

bysort store txyear txmonth txday: egen dollarsperday = total(nds_amt)
bysort store txyear txmonth txday: egen txsperday = total(diff_tx)
bysort store txyear txmonth txday: egen itemsperday = total(nds_qty)



ge dollarsperitem=dollarsperday/itemsperday

**** Vars that total values over subset of items ***


* Calories and Items per Transaction (food and drink only)

bysort store txyear txmonth txday: egen cal1T=total(nds_qty*cal*min(1,(type==1)+(type==2)+(type==3)))
bysort store txyear txmonth txday: egen items1T = total(nds_qty*min(1,(type==1)+(type==2)+(type==3)))
bysort store txyear txmonth txday: egen cal1Tdrinks=total(nds_qty*cal*min(1,(type==1)+(type==3)))
bysort store txyear txmonth txday: egen items1Tdrinks = total(nds_qty*(type==1))
bysort store txyear txmonth txday: egen cal1Tsnacks=total(nds_qty*cal*(type==2))
bysort store txyear txmonth txday: egen items1Tsnacks = total(nds_qty*(type==2))
* include meal items for dollars per transaction
bysort store txyear txmonth txday: egen dollars1T = total(nds_amt*min(1,(type==1)+(type==2)+(type==3)))


keep if diff_tx==1
*** Vars that total values over subset of transactions ***
* Calories and Items per Person (i.e. per tx using single person txs, consumables and non-meal only)


* Calories and Items per Transaction (consumables and non-meal only)

bysort store txyear txmonth txday: egen tx1T = total(diff_tx)
bysort store txyear txmonth txday: egen hasdrink1T = total(diff_tx*txhasdrink)
bysort store txyear txmonth txday: egen hassnack1T = total(diff_tx*txhassnack)
bysort store txyear txmonth txday: egen hasfood1T = total(diff_tx*max(txhassnack,txhasmeal))
bysort store txyear txmonth txday: egen hasdrinkandfood1T = total(diff_tx*min(txhasdrink,max(txhassnack,txhasmeal)))
bysort store txyear txmonth txday: egen hasdrinkorfood1T = total(diff_tx*txhasdrinkorfood)
bysort store txyear txmonth txday: egen hashotcoffee1T = total(diff_tx*txhashotcoffee)

bysort store txyear txmonth txday: egen hascalitem1T = total(diff_tx*txhascalitem)
bysort store txyear txmonth txday: egen tx1T_wcalitem = total(diff_tx*txhascalitem)
***************************************************

* Keep one obs per day
drop if (store==store[_n-1] & txyear==txyear[_n-1] & txmonth==txmonth[_n-1] & txday==txday[_n-1])

* Drop if no transactions that day
drop if tx1T==0

*********************** DVs ****************************

* All transactions with drink or food:

* average calories and items per tx
ge calsper1T=cal1T/hasdrinkorfood1T 
ge calsper1Tdrinks=cal1Tdrinks/hasdrinkorfood1T 
ge calsper1Tsnacks=cal1Tsnacks/hasdrinkorfood1T 

ge itemsper1T=items1T/hasdrinkorfood1T 
ge itemsper1Tdrinks=items1Tdrinks/hasdrinkorfood1T 
ge itemsper1Tsnacks=items1Tsnacks/hasdrinkorfood1T 

ge dollarsper1T=dollars1T/hasdrinkorfood1T 
ge foodattach1T=hasdrinkandfood1T/hasdrink1T

* All transactions:

ge frachasdrink1T=hasdrink1T/tx1T
ge frachassnack1T=hassnack1T/tx1T
ge frachashotcoffee=hashotcoffee1T/tx1T

******************************************************

keep store zone dat txyear txmonth txday txweek txdow after* tx1* calsper* itemsper* txsper* dollarsper* foodattach* has* frachas*  


save $bigdatadir/working/ch/setup_daily_txs, replace




log close
