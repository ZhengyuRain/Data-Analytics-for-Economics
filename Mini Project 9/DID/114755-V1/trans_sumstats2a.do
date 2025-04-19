
log using ../logs/trans_sumstats2a, text replace

* trans_sumstats2a.do

* Non-consumable and meal items have been removed!

set more off

clear
use /data/gsb/SBC/working/setup_sumstats2
*use ../data/working/setup_sumstats2


* already sorted: sort store txmonth txday txid txline


* zone=5 if city=="SAN FRANCISCO"
* zone=15 if city=="BOSTON"
* zone=16 if city=="NEW YORK"
* zone=51 if city=="PHILADELPHIA"
* zone=64 if city=="JERSEY CITY"

********** Nonmeal, consumable items and $ per transaction ************


************* Calories per item (weighted by occurance) *********
su cal, detail
hist cal if diff_tx, w(25) saving(../graphs/calsperitem,replace) 
graph export ../graphs/calsperitem.eps, logo(off) replace

************* Transaction-level tables *********************

bysort store txmonth txday txid: egen itemsper = count(txid)
label var itemsper "Consumable Items per Transaction"
tab itemsper if diff_tx
count if diff_tx & itemsper>15
hist itemsper if diff_tx & itemsper<=15, w(1) saving(../graphs/itemsper,replace) 
graph export ../graphs/itemsper.eps, logo(off) replace

bysort store txmonth txday txid: egen dollarsper = total(nds_amt)
label var dollarsper "Dollars on Consumables per Transaction"
ge dollarsround=round(dollarsper,1) 
su dollarsper if diff_tx, detail

count if diff_tx & dollarsper>=40
hist dollarsper if diff_tx & dollarsper<40, w(.5) saving(../graphs/dollarsper,replace) 
graph export ../graphs/dollarsper.eps, logo(off) replace


* Calorie Tables 
tabstat txcal if diff_tx==1, by(halfhour) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(txmonth) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(txdow) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(zone) stats(mean sd min p10 med p90 max)

sort zone
by zone: tabstat txcal if diff_tx==1, by(txmonth) stats(mean sd min p10 med p90 max)

* Calorie Histograms for all zones except new york

count if diff_tx & txcal>=2000
hist txcal if diff_tx & zone==5 & txcal<2000, w(25) saving(../graphs/SFcalhist,replace)
graph export ../graphs/SFcalhist.eps, logo(off) replace
hist txcal if diff_tx & zone==15 & txcal<2000, w(25) saving(../graphs/Bcalhist,replace)
graph export ../graphs/Bcalhist.eps, logo(off) replace
hist txcal if diff_tx & zone==51 & txcal<2000, w(25) saving(../graphs/Pcalhist,replace)
graph export ../graphs/Pcalhist.eps, logo(off) replace
hist txcal if diff_tx & zone==64 & txcal<2000, w(25) saving(../graphs/JCcalhist,replace)
graph export ../graphs/JCcalhist.eps, logo(off) replace

* New York Calorie Histograms

hist txcal if diff_tx & zone==16 & txcal<2000 & after==0, w(25) saving(../graphs/NYcalhistbefore,replace) 
graph export ../graphs/NYcalhistbefore.eps, logo(off) replace
hist txcal if diff_tx & zone==16 & txcal<2000 & after==1, w(25) saving(../graphs/NYcalhistafter,replace) 
graph export ../graphs/NYcalhistafter.eps, logo(off) replace

log close


