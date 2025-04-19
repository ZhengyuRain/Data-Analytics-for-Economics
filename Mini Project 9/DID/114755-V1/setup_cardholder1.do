
*setup_cardholder1

* generate a table of "transitions" for the cardholders
clear
pro drop _all
set mem 10g
set more off

global bigdatadir /data/gsb/SBC
global datadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/data
global logdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/logs
global tmpdir /tmp

* set required number of transactions pre and post
global ntx = 10


* read in the cardholder data
use $bigdatadir/CardholderData/cardholder_data

* merge with store info
sort store
merge store using $bigdatadir/stores_to_cities
gen ny = (city==3)
gen bos = (city==1)
gen phl = (city==4)
keep if _merge==3
drop _merge
save $bigdatadir/working/tmpch, replace

use $bigdatadir/working/tmpch, clear
* merge in calorie info (need type)
gen zone = 15 if city==1
replace zone = 16 if city==3
replace zone = 51 if city==4
keep if city==1|city==3|city==4
sort prod_num zone
merge prod_num zone using $datadir/working/calories_sparse
drop if _merge==2
drop _merge


gen txyear = year(txdate)
gen txmonth = month(txdate)
gen txday = day(txdate)
ge txdow=dow(txdate)

ge txweek=week(txdate)
* Fix stata bug which maxes out week at 52
replace txweek =53 if txyear==2008 & txmonth==12 & txday>=30

* Balance Panel
drop if txyear==2008 & txmonth==1 & txday<=5
* already ends on a Saterday, Feb 2009

* Change week variable to count full weeks beginning on Sunday:

* 2008 begins on a Tuesday
replace txweek=txweek+1 if txdow==0 & txyear==2008
replace txweek=txweek+1 if txdow==1 & txyear==2008
replace txweek=txweek-1 if txyear==2008


* 2009 begins on a Thursday
replace txweek=txweek+1 if txdow==0 & txyear==2009
replace txweek=txweek+1 if txdow==1 & txyear==2009
replace txweek=txweek+1 if txdow==2 & txyear==2009
replace txweek=txweek+1 if txdow==3 & txyear==2009
replace txweek=txweek-1 if txyear==2009


replace txweek=52+txweek if txyear==2009


gen period = (txdate>=d(15apr2008))



******************************* ITEMS ****************

sort store txyear txmonth txday txid txline
bysort store txyear txmonth txday txid: egen txhasdrink = max(type==1)
bysort store txyear txmonth txday txid: egen txhassnack = max(type==2)
bysort store txyear txmonth txday txid: egen txhasmeal = max(type==5)
ge txhasfood=max(txhassnack,txhasmeal)
bysort store txyear txmonth txday txid: egen txhasextra = max(type==3)
bysort store txyear txmonth txday txid: egen txhaspkgdrink = max(type==4)
bysort store txyear txmonth txday txid: egen txhasother = max(type==0)

label var txhasdrink "Transaction has a Drink"
label var txhassnack "Transaction has a Snack"
label var txhasmeal "Transaction has a Meal Item"
label var txhasfood "Transaction has a Food Item"
label var txhasextra "Transaction has an Extra"
label var txhaspkgdrink "Transaction has a Packaged Drink"
label var txhasother "Transaction has a Non-Consumable Item"

bysort store txyear txmonth txday txid: egen txnumdrink = total((type==1)*nds_qty)
bysort store txyear txmonth txday txid: egen txnumsnack = total((type==2)*nds_qty)
bysort store txyear txmonth txday txid: egen txnummeal = total((type==5)*nds_qty)
bysort store txyear txmonth txday txid: egen txnumextra = total((type==3)*nds_qty)
bysort store txyear txmonth txday txid: egen txnumpkgdrink = total((type==4)*nds_qty)
bysort store txyear txmonth txday txid: egen txnumother = total((type==0)*nds_qty)

label var txnumdrink "Number of Drinks"
label var txnumsnack "Number of Snacks"
label var txnummeal "Number of Meal Items"
label var txnumextra "Number of Extras"
label var txnumpkgdrink "Number of Packaged Drinks"
label var txnumother "Number of Non-Consumable Items"



* collapse so an observation is a transaction
sort id txdate txid
egen txcal = sum(cal), by(id txdate txid)
egen bevcal = sum(cal*(type==1)), by(id txdate txid)
egen foodcal = sum(cal*(type==2)), by(id txdate txid)
qui by id txdate txid: keep if _n==1

* merge in weather data

sort zone txyear txmonth txday
merge zone txyear txmonth txday using $datadir/working/weather
drop if _merge==2
drop _merge


sort id txweek

save $bigdatadir/working/setup_cardholder1, replace

