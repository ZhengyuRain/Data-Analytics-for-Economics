

*setup_daily_txs_p50.do

log using $logdir/$currentcity/setup_daily_txs_quantiles, text replace


clear
use $bigdatadir/working/$currentcity/setup_sumstats1

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

keep store zone dat txyear txmonth txday txweek txdow tx* nds_amt nds_qty cal after* diff_tx multiplepeople type txhas*

keep if txhasdrinkorfood

sort store txyear txmonth txday

keep if diff_tx==1

**** Vars that total values over subset of items ***


*Cals per tx conditional on tx having some item with calorie info

drop if txhascalitem==0

bysort store txyear txmonth txday: egen calsper1T_p10=pctile(txcal),p(10)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p10=pctile(txcaldrinks),p(10)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p10=pctile(txcalsnacks),p(10)

bysort store txyear txmonth txday: egen calsper1T_p25=pctile(txcal),p(25)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p25=pctile(txcaldrinks),p(25)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p25=pctile(txcalsnacks),p(25)

bysort store txyear txmonth txday: egen calsper1T_p50=pctile(txcal),p(50)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p50=pctile(txcaldrinks),p(50)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p50=pctile(txcalsnacks),p(50)

bysort store txyear txmonth txday: egen calsper1T_p75=pctile(txcal),p(75)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p75=pctile(txcaldrinks),p(75)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p75=pctile(txcalsnacks),p(75)

bysort store txyear txmonth txday: egen calsper1T_p90=pctile(txcal),p(90)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p90=pctile(txcaldrinks),p(90)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p90=pctile(txcalsnacks),p(90)

bysort store txyear txmonth txday: egen calsper1T_p95=pctile(txcal),p(95)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p95=pctile(txcaldrinks),p(95)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p95=pctile(txcalsnacks),p(95)

bysort store txyear txmonth txday: egen calsper1T_p99=pctile(txcal),p(99)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p99=pctile(txcaldrinks),p(99)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p99=pctile(txcalsnacks),p(99)

* Keep one obs per day
drop if (store==store[_n-1] & txyear==txyear[_n-1] & txmonth==txmonth[_n-1] & txday==txday[_n-1])

* Drop if no transactions that day
bysort store txyear txmonth txday: egen tx1T = total(diff_tx)
drop if tx1T==0


keep store zone dat txyear txmonth txday txweek txdow after* calsper* 

save $bigdatadir/working/$currentcity/setup_daily_txs_quantiles, replace




log close
