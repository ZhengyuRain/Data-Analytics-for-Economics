
log using ../logs/trans_sumstats2a, text replace

* trans_sumstats2a.do

* Non-consumable and meal items have been removed!

clear
use /data/gsb/SBC/working/setup_sumstats2
*use ../data/working/setup_sumstats2


* already sorted: sort tx_st prod_num


* zone=5 if city=="SAN FRANCISCO"
* zone=15 if city=="BOSTON"
* zone=16 if city=="NEW YORK"
* zone=51 if city=="PHILADELPHIA"
* zone=64 if city=="JERSEY CITY"

********** Nonmeal, consumable items and $ per transaction ************

su multiplepeople

************* Calories per item (weighted by occurance) *********
su cal, detail
hist cal if diff_tx, saving(../graphs/calsperitem,replace) 
graph export ../graphs/calsperitem.eps, logo(off) replace

************* Transaction-level tables *********************

sort tx_st
by tx_st: egen itemsper = count(txid)
tab itemsper if diff_tx
hist itemsper if diff_tx, saving(../graphs/itemsper,replace) 
graph export ../graphs/itemsper.eps, logo(off) replace

by tx_st: egen dollarsper = total(nds_amt)
ge dollarsround=round(dollarsper,1) 
su dollarsper if diff_tx, detail
hist dollarsper if diff_tx, w(.5) saving(../graphs/dollarsper,replace) 
graph export ../graphs/dollarsper.eps, logo(off) replace

by tx_st: egen txcal=total(cal)

* Calorie Tables 
tabstat txcal if diff_tx==1, by(halfhour) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(txmonth) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(txday) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(zone) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(halfhour) stats(mean sd min p10 med p90 max)

sort zone
by zone: tabstat txcal if diff_tx==1, by(txmonth) stats(mean sd min p10 med p90 max)

* Calorie Histograms for all zones except new york

hist txcal if diff_tx & zone==5, start(0) w(50) saving(../graphs/SFcalhist,replace)
graph export ../graphs/SFcalhist.eps, logo(off) replace
hist txcal if diff_tx & zone==15, start(0) w(50) saving(../graphs/Bcalhist,replace)
graph export ../graphs/Bcalhist.eps, logo(off) replace
hist txcal if diff_tx & zone==51, start(0) w(50) saving(../graphs/Pcalhist,replace)
graph export ../graphs/Pcalhist.eps, logo(off) replace
hist txcal if diff_tx & zone==64, start(0) w(50) saving(../graphs/JCcalhist,replace)
graph export ../graphs/JCcalhist.eps, logo(off) replace

* New York Calorie Histograms

hist txcal if diff_tx & zone==16 & after==0, start(0) w(50) saving(../graphs/NYcalhistbefore,replace) 
graph export ../graphs/NYcalhistbefore.eps, logo(off) replace
hist txcal if diff_tx & zone==16 & after==1, start(0)  saving(../graphs/NYcalhistafter,replace) 
graph export ../graphs/NYcalhistafter.eps, logo(off) replace






*************** USE ONLY SINGLE PERSON TRANSACTIONS *********************

drop if multiplepeople==1
drop itemsper dollarsper dollarsround txcal 

************* Calories per item (weighted by occurance) *********
su cal, detail
hist cal if diff_tx, saving(../graphs/calsperitem_1person,replace) 
graph export ../graphs/calsperitem_1person.eps, logo(off) replace

************* Transaction-level tables *********************

sort tx_st
by tx_st: egen itemsper = count(txid)
tab itemsper if diff_tx
hist itemsper if diff_tx, saving(../graphs/itemsper_1person,replace) 
graph export ../graphs/itemsper_1person.eps, logo(off) replace

by tx_st: egen dollarsper = total(nds_amt)
ge dollarsround=round(dollarsper,1) 
su dollarsper if diff_tx, detail
hist dollarsper if diff_tx, w(.5) saving(../graphs/dollarsper_1person,replace) 
graph export ../graphs/dollarsper_1person.eps, logo(off) replace

by tx_st: egen txcal=total(cal)

* Calorie Tables (Single Person Transactions)
tabstat txcal if diff_tx==1, by(halfhour) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(txmonth) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(txday) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(zone) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(halfhour) stats(mean sd min p10 med p90 max)

sort zone
by zone: tabstat txcal if diff_tx==1, by(txmonth) stats(mean sd min p10 med p90 max)

* Calorie Histograms for all zones except new york

hist txcal if diff_tx & zone==5, start(0) w(50) saving(../graphs/SFcalhist_1person,replace)
graph export ../graphs/SFcalhist_1person.eps, logo(off) replace
hist txcal if diff_tx & zone==15, start(0) w(50) saving(../graphs/Bcalhist_1person,replace)
graph export ../graphs/Bcalhist_1person.eps, logo(off) replace
hist txcal if diff_tx & zone==51, start(0) w(50) saving(../graphs/Pcalhist_1person,replace)
graph export ../graphs/Pcalhist_1person.eps, logo(off) replace
hist txcal if diff_tx & zone==64, start(0) w(50) saving(../graphs/JCcalhist_1person,replace)
graph export ../graphs/JCcalhist_1person.eps, logo(off) replace

* New York Calorie Histograms, Single Person Transactions

hist txcal if diff_tx & zone==16 & after==0, start(0) w(50) saving(../graphs/NYcalhistbefore_1person,replace) 
graph export ../graphs/NYcalhistbefore_1person.eps, logo(off) replace
hist txcal if diff_tx & zone==16 & after==1, start(0) w(50) saving(../graphs/NYcalhistafter_1person,replace) 
graph export ../graphs/NYcalhistafter_1person.eps, logo(off) replace


log close


