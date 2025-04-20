
*setup_prepost_quantiles.do

log using $logdir/$currentcity/setup_prepost_quantiles, text replace


clear
use $bigdatadir/working/$currentcity/setup_sumstats1

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

keep store zone dat txyear txmonth txday txweek txdow diff_tx after* txcal* txhasdrinkorfood txhascalitem

keep if txhasdrinkorfood

sort store txyear txmonth txday

keep if diff_tx==1

*Cals per tx conditional on tx having some item with calorie info

drop if txhascalitem==0

bysort after_nyc: egen calsper1T_p70=pctile(txcal),p(70)
bysort after_nyc: egen calsper1Tdrinks_p70=pctile(txcaldrinks),p(70)
bysort after_nyc: egen calsper1Tsnacks_p70=pctile(txcalsnacks),p(70)

bysort after_nyc: egen calsper1T_p71=pctile(txcal),p(71)
bysort after_nyc: egen calsper1Tdrinks_p71=pctile(txcaldrinks),p(71)
bysort after_nyc: egen calsper1Tsnacks_p71=pctile(txcalsnacks),p(71)

bysort after_nyc: egen calsper1T_p72=pctile(txcal),p(72)
bysort after_nyc: egen calsper1Tdrinks_p72=pctile(txcaldrinks),p(72)
bysort after_nyc: egen calsper1Tsnacks_p72=pctile(txcalsnacks),p(72)

bysort after_nyc: egen calsper1T_p73=pctile(txcal),p(73)
bysort after_nyc: egen calsper1Tdrinks_p73=pctile(txcaldrinks),p(73)
bysort after_nyc: egen calsper1Tsnacks_p73=pctile(txcalsnacks),p(73)

bysort after_nyc: egen calsper1T_p74=pctile(txcal),p(74)
bysort after_nyc: egen calsper1Tdrinks_p74=pctile(txcaldrinks),p(74)
bysort after_nyc: egen calsper1Tsnacks_p74=pctile(txcalsnacks),p(74)

bysort after_nyc: egen calsper1T_p75=pctile(txcal),p(75)
bysort after_nyc: egen calsper1Tdrinks_p75=pctile(txcaldrinks),p(75)
bysort after_nyc: egen calsper1Tsnacks_p75=pctile(txcalsnacks),p(75)

bysort after_nyc: egen calsper1T_p76=pctile(txcal),p(76)
bysort after_nyc: egen calsper1Tdrinks_p76=pctile(txcaldrinks),p(76)
bysort after_nyc: egen calsper1Tsnacks_p76=pctile(txcalsnacks),p(76)

bysort after_nyc: egen calsper1T_p77=pctile(txcal),p(77)
bysort after_nyc: egen calsper1Tdrinks_p77=pctile(txcaldrinks),p(77)
bysort after_nyc: egen calsper1Tsnacks_p77=pctile(txcalsnacks),p(77)

bysort after_nyc: egen calsper1T_p78=pctile(txcal),p(78)
bysort after_nyc: egen calsper1Tdrinks_p78=pctile(txcaldrinks),p(78)
bysort after_nyc: egen calsper1Tsnacks_p78=pctile(txcalsnacks),p(78)

bysort after_nyc: egen calsper1T_p79=pctile(txcal),p(79)
bysort after_nyc: egen calsper1Tdrinks_p79=pctile(txcaldrinks),p(79)
bysort after_nyc: egen calsper1Tsnacks_p79=pctile(txcalsnacks),p(79)

bysort after_nyc: egen calsper1T_p80=pctile(txcal),p(80)
bysort after_nyc: egen calsper1Tdrinks_p80=pctile(txcaldrinks),p(80)
bysort after_nyc: egen calsper1Tsnacks_p80=pctile(txcalsnacks),p(80)

bysort after_nyc: egen calsper1T_p81=pctile(txcal),p(81)
bysort after_nyc: egen calsper1Tdrinks_p81=pctile(txcaldrinks),p(81)
bysort after_nyc: egen calsper1Tsnacks_p81=pctile(txcalsnacks),p(81)

bysort after_nyc: egen calsper1T_p82=pctile(txcal),p(82)
bysort after_nyc: egen calsper1Tdrinks_p82=pctile(txcaldrinks),p(82)
bysort after_nyc: egen calsper1Tsnacks_p82=pctile(txcalsnacks),p(82)

bysort after_nyc: egen calsper1T_p83=pctile(txcal),p(83)
bysort after_nyc: egen calsper1Tdrinks_p83=pctile(txcaldrinks),p(83)
bysort after_nyc: egen calsper1Tsnacks_p83=pctile(txcalsnacks),p(83)

bysort after_nyc: egen calsper1T_p84=pctile(txcal),p(84)
bysort after_nyc: egen calsper1Tdrinks_p84=pctile(txcaldrinks),p(84)
bysort after_nyc: egen calsper1Tsnacks_p84=pctile(txcalsnacks),p(84)

bysort after_nyc: egen calsper1T_p85=pctile(txcal),p(85)
bysort after_nyc: egen calsper1Tdrinks_p85=pctile(txcaldrinks),p(85)
bysort after_nyc: egen calsper1Tsnacks_p85=pctile(txcalsnacks),p(85)

bysort after_nyc: egen calsper1T_p86=pctile(txcal),p(86)
bysort after_nyc: egen calsper1Tdrinks_p86=pctile(txcaldrinks),p(86)
bysort after_nyc: egen calsper1Tsnacks_p86=pctile(txcalsnacks),p(86)

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


save $bigdatadir/working/$currentcity/setup_prepost_quantiles, replace


log close
