
log using ../logs/trans_sumstats1, text replace

* trans_sumstats1.do
* Creates tables of items by type, top ten lists, items and $ per transactions for ALL transactions
* run after setup_sumstats1.do

set more off

clear
use /data/gsb/SBC/working/setup_sumstats1
*use ../data/working/setup_sumstats1


keep txid txline store prod_num nds_amt type zone txdow txday txweek txmonth halfhour diff_tx txhas* txnum* multiplepeople after 

* Tabulate by txline
tab txline

**************** Tabulate by type ********************
* (1 drink, 2 food, 3 extra, 4 packaged drink, 5 meal, 0 other)
tab type

************** Fractions of transctions with each type **********
su txhas* if diff_tx
table zone if diff_tx, c(freq mean txhasdrink mean txhassnack mean txhasmeal mean txhasother)
table halfhour if diff_tx, c(freq mean txhasdrink mean txhassnack mean txhasmeal mean txhasother)
table txdow if diff_tx, c(freq mean txhasdrink mean txhassnack mean txhasmeal mean txhasother)
table txmonth if diff_tx, c(freq mean txhasdrink mean txhassnack mean txhasmeal mean txhasother)
table txweek if diff_tx & zone==16, c(freq mean txhasdrink mean txhassnack mean txhasmeal mean txhasother)
table txweek if diff_tx & zone~=16, c(freq mean txhasdrink mean txhassnack mean txhasmeal mean txhasother)

drop txhas*

*************** Tabulate number of each item per transaction ***********

tab txnumdrink if diff_tx
tab txnumsnack if diff_tx
tab txnummeal if diff_tx
tab txnumextra if diff_tx
tab txnumpkgdrink if diff_tx
tab txnumother if diff_tx

count if ~(txnumsnack<=6 & txnumdrink <=6) & diff_tx
tab txnumsnack txnumdrink if txnumsnack<=6 & txnumdrink <=6 & diff_tx

********** Items and $ per transaction, all items ************

bysort store txmonth txday txid: egen itemsper = count(txid)
tab itemsper if diff_tx
label var itemsper "Items per Transaction"
su itemsper if diff_tx, detail


bysort store txmonth txday txid: egen dollarsper = total(nds_amt)
label var dollarsper "Dollars per Transaction"
su dollarsper if diff_tx, detail

************ Other possible multiple people varibales *************
ge multiplepeople1=multiplepeople 
ge multiplepeople2=txnumdrink+txnumpkgdrink>=2 | txnummeal+txnumsnack>3
ge multiplepeople3= txnumdrink+txnumpkgdrink>=3 | txnummeal+txnumsnack>2
ge multiplepeople4=txnumdrink+txnumpkgdrink>=3 | txnummeal+txnumsnack>3

su multiplepeople* if diff_tx

*************** Items by number of occurances ******************

sort prod_num
tab1 prod_num, sort

* Items by rank by zone
bysort zone: tab1 prod_num, sort

* Top Drinks
sort prod_num
tab1 prod_num if type==1, sort

* Top Food
sort prod_num
tab1 prod_num if type==2 | type==5, sort

* Top Other
sort prod_num
tab1 prod_num if type==5, sort

* New York: Top Drinks Before & After
tab1 prod_num if type==1 & zone==16 & after==0, sort
tab1 prod_num if type==1 & zone==16 & after==1, sort

* New York: Top Snacks Before & After
tab1 prod_num if type==2 & zone==16 & after==0, sort
tab1 prod_num if type==2 & zone==16 & after==1, sort

log close
