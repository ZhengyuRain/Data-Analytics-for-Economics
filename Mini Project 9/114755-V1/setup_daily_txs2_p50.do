
*setup_daily_txs2_p90.do

log using $logdir/$currentcity/setup_daily_txs2_p90, text replace


clear
use $bigdatadir/working/$currentcity/setup_sumstats2

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

keep store zone dat txyear txmonth txday txweek txdow tx* nds_amt nds_qty cal after* diff_tx multiplepeople type txhas*


sort store txyear txmonth txday

keep if diff_tx==1

**** Vars that total values over subset of items ***

* Calories and Items per Transaction

bysort store txyear txmonth txday: egen calsper1T=pctile(txcal),p(50)
bysort store txyear txmonth txday: egen itemsper1Ts= pctile(txitems),p(50)
bysort store txyear txmonth txday: egen calsper1Tdrinks=pctile(txcaldrinks),p(50)
bysort store txyear txmonth txday: egen itemsper1Tdrinks= pctile(txitemsdrinks),p(50)
bysort store txyear txmonth txday: egen calsper1Tsnacks=pctile(txcalsnacks),p(50)
bysort store txyear txmonth txday: egen itemsper1Tsnacks = pctile(txitemssnacks),p(50)
***************************************************

drop if multiplepeople

bysort store txyear txmonth txday: egen calsper1P=pctile(txcal),p(50)
bysort store txyear txmonth txday: egen itemsper1Ps= pctile(txitems),p(50)
bysort store txyear txmonth txday: egen calsper1Pdrinks=pctile(txcaldrinks),p(50)
bysort store txyear txmonth txday: egen itemsper1Pdrinks= pctile(txitemsdrinks),p(50)
bysort store txyear txmonth txday: egen calsper1Psnacks=pctile(txcalsnacks),p(50)
bysort store txyear txmonth txday: egen itemsper1Psnacks = pctile(txitemssnacks),p(50)


* Keep one obs per day
drop if (store==store[_n-1] & txyear==txyear[_n-1] & txmonth==txmonth[_n-1] & txday==txday[_n-1])

* Drop if no transactions that day
bysort store txyear txmonth txday: egen tx1T = total(diff_tx)
drop if tx1T==0


keep store zone dat txyear txmonth txday txweek txdow after* tx1T calsper* itemsper* 


save $bigdatadir/working/$currentcity/setup_daily_txs2_p90, replace




log close
