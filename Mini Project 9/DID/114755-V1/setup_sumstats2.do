

* setup_sumstats2.do

log using $logdir/$currentcity/setup_sumstats2, text replace

* merges cal info, for all non-meal consumable transactions

set more off

clear
use $bigdatadir/working/$currentcity/setup_sumstats1

* DROP NON_CONSUMABLES
drop if type==0
* DROP MEAL ITEMS: CAL INFO INCOMPLETE
drop if type==5


* drop txnum* variables
drop txnum*



sort store txyear txmonth txday txid txline

* Re-Define different transaction indicator
drop diff_tx
ge diff_tx=(store~=store[_n-1]|txmonth~=txmonth[_n-1]|txday~=txday[_n-1]|txid~=txid[_n-1])


* DOES PER TX VARS FOR ALL TXS, NOT JUST SINGLE PERSON
* REMOVE MULTIPERSON IF DESIRED LATER

********* Generate transaction calorie var *******
drop txcal
bysort store txyear txmonth txday txid: egen txcal=total(cal)
label var txcal "Calories per Transaction"

********* Generate per tx vars **********
sort store txyear txmonth txday txid
bysort store txyear txmonth txday txid: egen itemsper = count(txid)
label var itemsper "Consumable Items per Transaction"

bysort store txyear txmonth txday txid: egen dollarsper = total(nds_amt)
label var dollarsper "Dollars on Consumables per Transaction"

************** Save setup_sumstats2 **********
compress

save $bigdatadir/working/$currentcity/setup_sumstats2, replace

log close

