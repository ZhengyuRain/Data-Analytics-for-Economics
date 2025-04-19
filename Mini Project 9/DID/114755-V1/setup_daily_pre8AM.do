
*setup_daily.do

log using ../logs/setup_daily_pre8AM, text replace

global bigdatadir /data/gsb/SBC
set more off

clear
use /data/gsb/SBC/working/setup_sumstats1
*use ../data/working/setup_sumstats1

*USE SUMSTATS1 TO GET NON-CONSUMABLES AS WELL

keep store zone dat txmonth txday txweek txdow nds_amt cal after diff_tx multiplepeople type halfhour

* KEEP ONLY BEFORE 8AM
keep if halfhour<=16

* New York Dummy
ge ny=(zone==16)

sort store txmonth txday

* Revenue and transactions per Day:

bysort store txmonth txday: egen dollarsperday = total(nds_amt)
bysort store txmonth txday: egen txsperday = total(diff_tx)
bysort store txmonth txday: egen itemsperday = count(diff_tx)

ge dollarsperitem=dollarsperday/itemsperday

* Calories and Items per Person (i.e. per tx using single person txs, consumables and non-meal only)

bysort store txmonth txday: egen cal1P=total(cal*(1-multiplepeople)*(type~=0)*(type~=5))
bysort store txmonth txday: egen items1P = total((1-multiplepeople)*(type~=0)*(type~=5))
bysort store txmonth txday: egen dollars1P = total(nds_amt*(1-multiplepeople)*(type~=0)*(type~=5))
bysort store txmonth txday: egen tx1P = total(diff_tx*(1-multiplepeople))


drop if (store==store[_n-1] & txmonth==txmonth[_n-1] & txday==txday[_n-1])


* average calories and items per one-person tx
ge calsper1P=cal1P/tx1P
ge itemsper1P=items1P/tx1P
ge dollarsper1P=dollars1P/tx1P

drop cal1P items1P tx1P 

save $bigdatadir/working/setup_daily_temp_pre8AM, replace


sort zone txmonth txday
merge zone txmonth txday using ../data/working/weather

tab _merge
drop if _merge==2
drop _merge

sort store
merge store using ../data/working/explvar


tab _merge
drop if _merge==2
drop _merge


label var dollarsperday "Revenue per Store-Day"
label var txsperday "Transactions per Store-Day"
label var itemsperday "Items per Store-Day"
label var dollarsperitem "Revenue per Item"

label var itemsper1P "Consumable Items per Person"
label var calsper1P "Calories per Person"
label var dollarsper1P "Revenue per Person"



save $bigdatadir/working/setup_daily_pre8AM, replace

log close
