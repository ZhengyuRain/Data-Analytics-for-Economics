
*setup_daily_prep.do

log using $logdir/$currentcity/setup_daily_prep, text replace


clear
use $bigdatadir/working/$currentcity/setup_sumstats1

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

keep store zone dat txyear txmonth txday txweek txdow nds_amt cal after* diff_tx multiplepeople type


sort store txyear txmonth txday

* Revenue and transactions per Day:

bysort store txyear txmonth txday: egen dollarsperday = total(nds_amt)
bysort store txyear txmonth txday: egen txsperday = total(diff_tx)
bysort store txyear txmonth txday: egen itemsperday = count(diff_tx)

ge dollarsperitem=dollarsperday/itemsperday


* Calories and Items per Person (i.e. per tx using single person txs, consumables and non-meal only)

bysort store txyear txmonth txday: egen cal1P=total(cal*(1-multiplepeople)*(type~=0)*(type~=5))
bysort store txyear txmonth txday: egen items1P = total((1-multiplepeople)*(type~=0)*(type~=5))
bysort store txyear txmonth txday: egen dollars1P = total(nds_amt*(1-multiplepeople)*(type~=0)*(type~=5))
bysort store txyear txmonth txday: egen tx1P = total(diff_tx*(1-multiplepeople))

drop if (store==store[_n-1] & txyear==txyear[_n-1] & txmonth==txmonth[_n-1] & txday==txday[_n-1])


* average calories and items per one-person tx
ge calsper1P=cal1P/tx1P
ge itemsper1P=items1P/tx1P
ge dollarsper1P=dollars1P/tx1P

drop cal1P items1P tx1P 


save $bigdatadir/working/$currentcity/setup_daily_prep, replace




log close
