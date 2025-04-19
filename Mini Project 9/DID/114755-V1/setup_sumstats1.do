


* setup_sumstats1.do
* Generates date vars, removes bookkeeping transactions, merges store zones

log using $logdir/$currentcity/setup_sumstats1, text replace

clear
cd $statadir


use $bigdatadir/$transactions

compress


******** CREATE TRANSACTION_STORE ID
sort store

merge store using $datadir/working/storezones_entirestate
tab _merge
drop if _merge~=3
drop _merge

* Keep specific city
keep if zone==$currentzone

sort prod_num zone
merge prod_num zone using $datadir/working/calories_sparse
tab _merge
drop if _merge==2
drop _merge



*ge dat=date(txdate,"dmy")
ge dat=txdate
ge txdow=dow(dat)
ge txmonth=month(dat)
ge txday=day(dat)
ge txweek=week(dat)
ge txyear=year(dat)


* Fix stata bug which maxes out week at 52
replace txweek =53 if txyear==2008 & txmonth==12 & txday>=30

* Balance Panel
drop if txyear==2008 & txmonth==1 & txday<=5
drop if txyear==2009 & txmonth>2

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


*********** Label Date Vars ************

label define monthlabel 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
label values txmonth monthlabel
label var txmonth "Month"

label define dowlabel 0 "Sun" 1 "Mon" 2 "Tue" 3 "Wed" 4 "Thu" 5 "Fri" 6 "Sat"
label values txdow dowlabel
label var txdow "Day of the Week"

label var txweek "Week Number"

label var txyear "Year"

count

* Drop if end of day transaction estimate
drop if prod_num>=999000000
* drop returns
* drop if negative price
drop if nds_amt<0
drop if nds_qty==0

sort store txyear txmonth txday txid txline

* Drop if quantity >=5
egen tempvar=sum(nds_qty>4), by(store txyear txmonth txday txid)
keep if tempvar==0
drop tempvar

count
************************************************************

* Define different transaction indicator

sort store txyear txmonth txday txid txline
ge diff_tx=(store~=store[_n-1]|txyear~=txyear[_n-1]|txmonth~=txmonth[_n-1]|txday~=txday[_n-1]|txid~=txid[_n-1])

su diff_tx txline
count if diff_tx==1 & txline~=1
count if txline==1 & diff_tx==0

************************************************************

sort store txyear txmonth txday txid txline
bysort store: egen lastdat=max(txdat)

* Store closed if stores have no observations after mid-feb
replace parttime=1 if lastdat<mdy(2,15,2009)

*drop stores that are not in complete time period

count if diff_tx & parttime

drop if parttime==1

count

**************** Type: ********************
* (1 drink, 2 food, 3 extra, 4 packaged drink, 5 meal, 0 other)
replace type=0 if type==.

* Label type variable

label define typelabel 1 "Drink" 2 "Snack" 3 "Extra" 4 "Bottled Drink" 5 "Meal" 0 "Other"
label values type typelabel
label var type "Item Type"

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

compress

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

ge multiplepeople= txnumdrink+txnumpkgdrink>=2 | txnummeal+txnumsnack>2
su multiplepeople
label var multiplepeople "Transaction is for Multiple People"

********* Generate after varible for policy change ********

ge after_nyc=(dat>=mdy($postingdate_nyc))
ge after_sea=(dat>=mdy($postingdate_sea))

compress

**************** Last Few Transaction level vars, only for drink and snack items, for percentile files: *********
bysort store txyear txmonth txday txid: egen txcal = total(nds_qty*cal*min(1,(type==1)+(type==2)+(type==3)))
bysort store txyear txmonth txday txid: egen txcaldrinks = total(nds_qty*cal*min(1,(type==1)+(type==3)))
bysort store txyear txmonth txday txid: egen txcalsnacks = total(nds_qty*cal*(type==2))

bysort store txyear txmonth txday txid: egen txitems = total(nds_qty*min(1,(type==1)+(type==2)+(type==3)))
bysort store txyear txmonth txday txid: egen txitemsdrinks = total(nds_qty*(type==1))
bysort store txyear txmonth txday txid: egen txitemssnacks = total(nds_qty*(type==2))


ge txhascalitem=min(1,txhasdrink+txhassnack+txhasextra+txhaspkgdrink)
ge txnumcalitem=txnumdrink+txnumsnack+txnumextra+txnumpkgdrink

ge txhasdrinkorfood=min(1,txhasdrink+txhassnack)
ge txnumdrinkorfood=txnumdrink+txnumsnack


ge txhashotcoffee=prod_num==       1 | prod_num==       2 | prod_num==       3 | prod_num==      76 | prod_num==  121617 | prod_num==  121618 | prod_num==  121965 | prod_num==  138663 | prod_num==  138664 | prod_num==  138665 | prod_num==  138666 |prod_num==  139877 |prod_num==  143104 |prod_num==  143105 |prod_num==  143106 |prod_num==  143107 |prod_num==  167244 |prod_num==  512752 |prod_num==  512754 |prod_num==  512760 |prod_num==  999001 |prod_num== 1007700 |prod_num== 1007701 |prod_num== 1057239 |prod_num== 1057241 |prod_num== 1057242 |prod_num== 1115793 |prod_num== 1115795 |prod_num== 1182079 |prod_num== 1182080 |prod_num== 1182081 |prod_num== 1182085 |prod_num== 1188691 |prod_num== 1188693 |prod_num== 1193028 |prod_num== 1197062 |prod_num== 1197063 |prod_num== 1206668 |prod_num==11214768 |prod_num==11214769 |prod_num==11237405 |prod_num==11237406 |prod_num==11237407 |prod_num==11237410 |prod_num==11237413 

****************** Save file ******************* 

replace type=0 if type==.
replace nds_qty=1 if nds_qty==.

su txhasdrinkorfood


compress

save $bigdatadir/working/$currentcity/setup_sumstats1, replace

log close
