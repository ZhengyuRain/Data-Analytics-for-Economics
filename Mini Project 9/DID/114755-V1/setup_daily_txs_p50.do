
*setup_daily_txs_p50.do

log using $logdir/$currentcity/setup_daily_txs_p50, text replace


clear
use $bigdatadir/working/$currentcity/setup_sumstats1

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

keep store zone dat txyear txmonth txday txweek txdow tx* nds_amt nds_qty cal after* diff_tx multiplepeople type txhas*

keep if txhasdrinkorfood

sort store txyear txmonth txday

keep if diff_tx==1

**** Vars that total values over subset of items ***

* Items per Transaction

bysort store txyear txmonth txday: egen itemsper1T= pctile(txitems),p(50)
bysort store txyear txmonth txday: egen itemsper1Tdrinks= pctile(txitemsdrinks),p(50)
bysort store txyear txmonth txday: egen itemsper1Tsnacks = pctile(txitemssnacks),p(50)
***************************************************


*Cals per tx conditional on tx having some item with calorie info

drop if txhascalitem==0

bysort store txyear txmonth txday: egen calsper1T=pctile(txcal),p(50)
bysort store txyear txmonth txday: egen calsper1Tdrinks=pctile(txcaldrinks),p(50)
bysort store txyear txmonth txday: egen calsper1Tsnacks=pctile(txcalsnacks),p(50)

* LOGS:
bysort store txyear txmonth txday: egen log_calsper1T=pctile(log(1+txcal)),p(50)
bysort store txyear txmonth txday: egen log_calsper1Tdrinks=pctile(log(1+txcaldrinks)),p(50)
bysort store txyear txmonth txday: egen log_calsper1Tsnacks=pctile(log(1+txcalsnacks)),p(50)

* Keep one obs per day
drop if (store==store[_n-1] & txyear==txyear[_n-1] & txmonth==txmonth[_n-1] & txday==txday[_n-1])

* Drop if no transactions that day
bysort store txyear txmonth txday: egen tx1T = total(diff_tx)
drop if tx1T==0


keep store zone dat txyear txmonth txday txweek txdow after* tx1* calsper* itemsper* log*


save $bigdatadir/working/$currentcity/setup_daily_txs_p50, replace




log close
