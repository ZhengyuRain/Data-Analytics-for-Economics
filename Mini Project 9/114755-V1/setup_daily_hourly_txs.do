

*setup_daily_hourly_txs.do

log using $logdir/$currentcity/setup_daily_hourly_txs, text replace


clear
set more off
set mem 15g


*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL
use $bigdatadir/working/$currentcity/setup_sumstats1

ge txhour=round(halfhour/2)


keep store zone dat txyear txmonth txday txweek txdow txhour nds_amt nds_qty cal after* diff_tx multiplepeople type txhas*

sort store txyear txmonth txday txhour


**** Vars that total values over subset of items ***



* Calories and Items per Transaction (food and drink only)

bysort store txyear txmonth txday txhour: egen cal1T=total(nds_qty*cal*min(1,(type==1)+(type==2)+(type==3)))
bysort store txyear txmonth txday txhour: egen items1T = total(nds_qty*min(1,(type==1)+(type==2)+(type==3)))
bysort store txyear txmonth txday txhour: egen cal1Tdrinks=total(nds_qty*cal*min(1,(type==1)+(type==3)))
bysort store txyear txmonth txday txhour: egen items1Tdrinks = total(nds_qty*(type==1))
bysort store txyear txmonth txday txhour: egen cal1Tsnacks=total(nds_qty*cal*(type==2))
bysort store txyear txmonth txday txhour: egen items1Tsnacks = total(nds_qty*(type==2))

bysort store txyear txmonth txday txhour: egen log_cal1T=total(log(1+nds_qty*cal*min(1,(type==1)+(type==2)+(type==3))))
bysort store txyear txmonth txday txhour: egen log_cal1Tdrinks=total(log(1+nds_qty*cal*min(1,(type==1)+(type==3))))
bysort store txyear txmonth txday txhour: egen log_cal1Tsnacks=total(log(1+nds_qty*cal*(type==2)))

keep if diff_tx==1
*** Vars that total values over subset of transactions ***
* Calories and Items per Person (i.e. per tx using single person txs, consumables and non-meal only)


* Calories and Items per Transaction (consumables and non-meal only)

bysort store txyear txmonth txday txhour: egen hasdrinkorfood1T = total(diff_tx*txhasdrinkorfood)

***************************************************

* Keep one obs per hour
drop if (store==store[_n-1] & txyear==txyear[_n-1] & txmonth==txmonth[_n-1] & txday==txday[_n-1] & txhour==txhour[_n-1])

*********************** DVs ****************************



* All transactions with drink or food:

* average calories and items per tx
ge calsper1T=cal1T/hasdrinkorfood1T 
ge calsper1Tdrinks=cal1Tdrinks/hasdrinkorfood1T 
ge calsper1Tsnacks=cal1Tsnacks/hasdrinkorfood1T 

ge itemsper1T=items1T/hasdrinkorfood1T 
ge itemsper1Tdrinks=items1Tdrinks/hasdrinkorfood1T 
ge itemsper1Tsnacks=items1Tsnacks/hasdrinkorfood1T 


save $bigdatadir/working/$currentcity/setup_daily_hourly_txs, replace




log close
