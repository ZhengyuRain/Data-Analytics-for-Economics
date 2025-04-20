
log using ../logs/trans_sumstats2b, text replace

* trans_sumstats2b.do

* Non-consumable and meal items have been removed!

clear
use /data/gsb/SBC/working/setup_sumstats2
*use ../data/working/setup_sumstats2

global graphdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/graphs


set more off

* already sorted: sort store txmonth txday txid


* zone=5 if city=="SAN FRANCISCO"
* zone=15 if city=="BOSTON"
* zone=16 if city=="NEW YORK"
* zone=51 if city=="PHILADELPHIA"
* zone=64 if city=="JERSEY CITY"

*************** USE ONLY SINGLE PERSON TRANSACTIONS *********************
* Single person transactions only!
keep if multiplepeople==0


************* Transaction-level tables *********************


tab itemsper if diff_tx
count if diff_tx & itemsper>15
hist itemsper if diff_tx & itemsper<=8 & itemsper>=0, start(0) w(1) saving(../graphs/itemsper_1person,replace) 
graph export ../graphs/itemsper_1person.eps, logo(off) replace
!epstopdf $graphdir/itemsper_1person.eps


su dollarsper if diff_tx, detail
count if diff_tx & dollarsper>=40
hist dollarsper if diff_tx & dollarsper<15 & dollarsper>=0, start(0) w(.5) saving(../graphs/dollarsper_1person,replace) 
graph export ../graphs/dollarsper_1person.eps, logo(off) replace
!epstopdf $graphdir/dollarsper_1person.eps


* Calorie Tables (Single Person Transactions)
tabstat txcal if diff_tx==1, by(halfhour) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(txmonth) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(txdow) stats(mean sd min p10 med p90 max)
tabstat txcal if diff_tx==1, by(zone) stats(mean sd min p10 med p90 max)

sort zone
by zone: tabstat txcal if diff_tx==1, by(txmonth) stats(mean sd min p10 med p90 max)

* Calorie Histograms for all zones except new york

*count if diff_tx & txcal>=2000
*hist txcal if diff_tx & zone==5 & txcal<2000 & txcal>=0, start(0) w(25) saving(../graphs/SFcalhist_1person,replace)
*graph export ../graphs/SFcalhist_1person.eps, logo(off) replace
*!epstopdf $graphdir/SFcalhist_1person.eps

*hist txcal if diff_tx & zone==15 & txcal<2000 & txcal>=0, start(0) w(25) saving(../graphs/Bcalhist_1person,replace)
*graph export ../graphs/Bcalhist_1person.eps, logo(off) replace
*!epstopdf $graphdir/Bcalhist_1person.eps

*hist txcal if diff_tx & zone==51 & txcal<2000 & txcal>=0, start(0) w(25) saving(../graphs/Pcalhist_1person,replace)
*graph export ../graphs/Pcalhist_1person.eps, logo(off) replace
*!epstopdf $graphdir/Pcalhist_1person.eps


* New York Calorie Histograms, Single Person Transactions

hist txcal if diff_tx & zone==16 & txcal<2000 & after==0 & txcal>=0, start(0) w(25) saving(../graphs/NYcalhistbefore_1person,replace) 
graph export ../graphs/NYcalhistbefore_1person.eps, logo(off) replace
!epstopdf $graphdir/NYcalhistbefore_1person.eps

hist txcal if diff_tx & zone==16 & txcal<2000 & after==1 & txcal>=0, start(0) w(25) saving(../graphs/NYcalhistafter_1person,replace) 
graph export ../graphs/NYcalhistafter_1person.eps, logo(off) replace
!epstopdf $graphdir/NYcalhistafter_1person.eps

* All Other City Calorie Histograms, Single Person Transactions

hist txcal if diff_tx & zone~=16 & txcal<2000 & after==0 & txcal>=0, start(0) w(25) saving(../graphs/notNYcalhistbefore_1person,replace) 
graph export ../graphs/notNYcalhistbefore_1person.eps, logo(off) replace
!epstopdf $graphdir/notNYcalhistbefore_1person.eps

hist txcal if diff_tx & zone~=16 & txcal<2000 & after==1 & txcal>=0, start(0) w(25) saving(../graphs/notNYcalhistafter_1person,replace) 
graph export ../graphs/notNYcalhistafter_1person.eps, logo(off) replace
!epstopdf $graphdir/notNYcalhistafter_1person.eps


log close


