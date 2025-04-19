
*setup_daily_txs.do

log using $logdir/$currentcity/setup_daily_txs, text replace


clear
use $bigdatadir/working/$currentcity/setup_sumstats1

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

keep store zone dat txyear txmonth txday txweek txdow nds_amt nds_qty cal after* diff_tx multiplepeople type txhas*


sort store txyear txmonth txday

* Revenue and transactions per Day:

bysort store txyear txmonth txday: egen dollarsperday = total(nds_amt)
bysort store txyear txmonth txday: egen txsperday = total(diff_tx)
bysort store txyear txmonth txday: egen itemsperday = total(nds_qty)

bysort store txyear txmonth txday: egen dollarsperday_drinks = total(nds_amt*min(1,(type==1)+(type==3)))
bysort store txyear txmonth txday: egen dollarsperday_snacks = total(nds_amt*(type==2))

ge dollarsperitem=dollarsperday/itemsperday

ge log_dollarsperday = log(dollarsperday)
ge log_txsperday= log(txsperday)
ge log_itemsperday= log(itemsperday)
ge log_dollarsperday_drinks= log(dollarsperday_drinks)
ge log_dollarsperday_snacks= log(dollarsperday_snacks)

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

*LOGS
bysort store txyear txmonth txday: egen log_cal1T=total(log(1+nds_qty*cal*min(1,(type==1)+(type==2)+(type==3))))
bysort store txyear txmonth txday: egen log_cal1Tdrinks=total(log(1+nds_qty*cal*min(1,(type==1)+(type==3))))
bysort store txyear txmonth txday: egen log_cal1Tsnacks=total(log(1+nds_qty*cal*(type==2)))
* if no items, value is '.'
bysort store txyear txmonth txday: egen log_items1T=total(log(nds_qty*min(1,(type==1)+(type==2)+(type==3))))
bysort store txyear txmonth txday: egen log_items1Tdrinks=total(log(nds_qty*min(1,(type==1)+(type==3))))
bysort store txyear txmonth txday: egen log_items1Tsnacks=total(log(nds_qty*(type==2)))

bysort store txyear txmonth txday: egen log_calperitem1T=total((log(1+nds_qty*cal*min(1,(type==1)+(type==2)+(type==3))))-(log(nds_qty*min(1,(type==1)+(type==2)+(type==3)))))
bysort store txyear txmonth txday: egen log_calperitem1Tdrinks=total((log(1+nds_qty*cal*min(1,(type==1)+(type==3))))-(log(nds_qty*min(1,(type==1)+(type==3)))))
bysort store txyear txmonth txday: egen log_calperitem1Tsnacks=total((log(1+nds_qty*cal*(type==2)))-(log(nds_qty*(type==2))))

***************** Keep only one observation per transaction! **************************
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

* LOGS
ge log_calsper1T=log_cal1T/hasdrinkorfood1T
ge log_calsper1Tdrinks=log_cal1Tdrinks/hasdrinkorfood1T
ge log_calsper1Tsnacks=log_cal1Tsnacks/hasdrinkorfood1T

ge log_calperitem=log_calperitem1T/hasdrinkorfood1T
ge log_calperitem_drinks=log_calperitem1Tdrinks/hasdrink1T
ge log_calperitem_snacks=log_calperitem1Tsnacks/hassnack1T

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

keep store zone dat txyear txmonth txday txweek txdow after* tx1* calsper* itemsper* txsper* dollarsper* foodattach* has* frachas* log*  


save $bigdatadir/working/$currentcity/setup_daily_txs, replace




log close
