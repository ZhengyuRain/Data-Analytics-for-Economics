
*setup_prepost_quantiles.do

log using $logdir/$currentcity/setup_prepost_quantilesA, text replace


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



* Keep one obs per day
drop if (after_nyc==after_nyc[_n-1])




keep store zone dat txyear txmonth txday txweek txdow after*  calsper* 


save $bigdatadir/working/$currentcity/setup_prepost_quantilesA, replace


log close
