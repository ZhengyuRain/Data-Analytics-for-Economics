
*setup_prepost_quantiles.do

log using $logdir/$currentcity/setup_prepost_quantilesB, text replace


clear
use $bigdatadir/working/$currentcity/setup_sumstats1

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

keep store zone dat txyear txmonth txday txweek txdow diff_tx after* txcal* txhasdrinkorfood txhascalitem

keep if txhasdrinkorfood

sort store txyear txmonth txday

keep if diff_tx==1

*Cals per tx conditional on tx having some item with calorie info

drop if txhascalitem==0



bysort after_nyc: egen calsper1T_p87=pctile(txcal),p(87)
bysort after_nyc: egen calsper1Tdrinks_p87=pctile(txcaldrinks),p(87)
bysort after_nyc: egen calsper1Tsnacks_p87=pctile(txcalsnacks),p(87)

bysort after_nyc: egen calsper1T_p88=pctile(txcal),p(88)
bysort after_nyc: egen calsper1Tdrinks_p88=pctile(txcaldrinks),p(88)
bysort after_nyc: egen calsper1Tsnacks_p88=pctile(txcalsnacks),p(88)

bysort after_nyc: egen calsper1T_p89=pctile(txcal),p(89)
bysort after_nyc: egen calsper1Tdrinks_p89=pctile(txcaldrinks),p(89)
bysort after_nyc: egen calsper1Tsnacks_p89=pctile(txcalsnacks),p(89)

bysort after_nyc: egen calsper1T_p90=pctile(txcal),p(90)
bysort after_nyc: egen calsper1Tdrinks_p90=pctile(txcaldrinks),p(90)
bysort after_nyc: egen calsper1Tsnacks_p90=pctile(txcalsnacks),p(90)

bysort after_nyc: egen calsper1T_p91=pctile(txcal),p(91)
bysort after_nyc: egen calsper1Tdrinks_p91=pctile(txcaldrinks),p(91)
bysort after_nyc: egen calsper1Tsnacks_p91=pctile(txcalsnacks),p(91)

bysort after_nyc: egen calsper1T_p92=pctile(txcal),p(92)
bysort after_nyc: egen calsper1Tdrinks_p92=pctile(txcaldrinks),p(92)
bysort after_nyc: egen calsper1Tsnacks_p92=pctile(txcalsnacks),p(92)

bysort after_nyc: egen calsper1T_p93=pctile(txcal),p(93)
bysort after_nyc: egen calsper1Tdrinks_p93=pctile(txcaldrinks),p(93)
bysort after_nyc: egen calsper1Tsnacks_p93=pctile(txcalsnacks),p(93)

bysort after_nyc: egen calsper1T_p94=pctile(txcal),p(94)
bysort after_nyc: egen calsper1Tdrinks_p94=pctile(txcaldrinks),p(94)
bysort after_nyc: egen calsper1Tsnacks_p94=pctile(txcalsnacks),p(94)

bysort after_nyc: egen calsper1T_p95=pctile(txcal),p(95)
bysort after_nyc: egen calsper1Tdrinks_p95=pctile(txcaldrinks),p(95)
bysort after_nyc: egen calsper1Tsnacks_p95=pctile(txcalsnacks),p(95)

bysort after_nyc: egen calsper1T_p96=pctile(txcal),p(96)
bysort after_nyc: egen calsper1Tdrinks_p96=pctile(txcaldrinks),p(96)
bysort after_nyc: egen calsper1Tsnacks_p96=pctile(txcalsnacks),p(96)

bysort after_nyc: egen calsper1T_p97=pctile(txcal),p(97)
bysort after_nyc: egen calsper1Tdrinks_p97=pctile(txcaldrinks),p(97)
bysort after_nyc: egen calsper1Tsnacks_p97=pctile(txcalsnacks),p(97)

bysort after_nyc: egen calsper1T_p98=pctile(txcal),p(98)
bysort after_nyc: egen calsper1Tdrinks_p98=pctile(txcaldrinks),p(98)
bysort after_nyc: egen calsper1Tsnacks_p98=pctile(txcalsnacks),p(98)

bysort after_nyc: egen calsper1T_p99=pctile(txcal),p(99)
bysort after_nyc: egen calsper1Tdrinks_p99=pctile(txcaldrinks),p(99)
bysort after_nyc: egen calsper1Tsnacks_p99=pctile(txcalsnacks),p(99)

bysort after_nyc: egen calsper1T_p100=max(txcal)
bysort after_nyc: egen calsper1Tdrinks_p100=max(txcaldrinks)
bysort after_nyc: egen calsper1Tsnacks_p100=max(txcalsnacks)

* Keep one obs per day
drop if (after_nyc==after_nyc[_n-1])




keep store zone dat txyear txmonth txday txweek txdow after*  calsper* 


save $bigdatadir/working/$currentcity/setup_prepost_quantilesB, replace


log close
