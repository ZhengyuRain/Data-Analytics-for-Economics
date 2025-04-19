
*setup_daily_txs_p50.do

log using $logdir/$currentcity/setup_daily_txs_quantilesB, text replace


clear
use $bigdatadir/working/$currentcity/setup_sumstats1

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

keep store zone dat txyear txmonth txday txweek txdow diff_tx after* txcal* txhasdrinkorfood txhascalitem

keep if txhasdrinkorfood

sort store txyear txmonth txday

keep if diff_tx==1

*Cals per tx conditional on tx having some item with calorie info

drop if txhascalitem==0



bysort store txyear txmonth txday: egen calsper1T_p87=pctile(txcal),p(87)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p87=pctile(txcaldrinks),p(87)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p87=pctile(txcalsnacks),p(87)

bysort store txyear txmonth txday: egen calsper1T_p88=pctile(txcal),p(88)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p88=pctile(txcaldrinks),p(88)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p88=pctile(txcalsnacks),p(88)

bysort store txyear txmonth txday: egen calsper1T_p89=pctile(txcal),p(89)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p89=pctile(txcaldrinks),p(89)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p89=pctile(txcalsnacks),p(89)

bysort store txyear txmonth txday: egen calsper1T_p90=pctile(txcal),p(90)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p90=pctile(txcaldrinks),p(90)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p90=pctile(txcalsnacks),p(90)

bysort store txyear txmonth txday: egen calsper1T_p91=pctile(txcal),p(91)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p91=pctile(txcaldrinks),p(91)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p91=pctile(txcalsnacks),p(91)

bysort store txyear txmonth txday: egen calsper1T_p92=pctile(txcal),p(92)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p92=pctile(txcaldrinks),p(92)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p92=pctile(txcalsnacks),p(92)

bysort store txyear txmonth txday: egen calsper1T_p93=pctile(txcal),p(93)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p93=pctile(txcaldrinks),p(93)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p93=pctile(txcalsnacks),p(93)

bysort store txyear txmonth txday: egen calsper1T_p94=pctile(txcal),p(94)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p94=pctile(txcaldrinks),p(94)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p94=pctile(txcalsnacks),p(94)

bysort store txyear txmonth txday: egen calsper1T_p95=pctile(txcal),p(95)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p95=pctile(txcaldrinks),p(95)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p95=pctile(txcalsnacks),p(95)

bysort store txyear txmonth txday: egen calsper1T_p96=pctile(txcal),p(96)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p96=pctile(txcaldrinks),p(96)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p96=pctile(txcalsnacks),p(96)

bysort store txyear txmonth txday: egen calsper1T_p97=pctile(txcal),p(97)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p97=pctile(txcaldrinks),p(97)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p97=pctile(txcalsnacks),p(97)

bysort store txyear txmonth txday: egen calsper1T_p98=pctile(txcal),p(98)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p98=pctile(txcaldrinks),p(98)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p98=pctile(txcalsnacks),p(98)

bysort store txyear txmonth txday: egen calsper1T_p99=pctile(txcal),p(99)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p99=pctile(txcaldrinks),p(99)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p99=pctile(txcalsnacks),p(99)

bysort store txyear txmonth txday: egen calsper1T_p100=max(txcal)
bysort store txyear txmonth txday: egen calsper1Tdrinks_p100=max(txcaldrinks)
bysort store txyear txmonth txday: egen calsper1Tsnacks_p100=max(txcalsnacks)

* Keep one obs per day
drop if (store==store[_n-1] & txyear==txyear[_n-1] & txmonth==txmonth[_n-1] & txday==txday[_n-1])

* Drop if no transactions that day
bysort store txyear txmonth txday: egen tx1T = total(diff_tx)
drop if tx1T==0


keep store zone dat txyear txmonth txday txweek txdow after* tx1* calsper* 


save $bigdatadir/working/$currentcity/setup_daily_txs_quantilesB, replace


log close
