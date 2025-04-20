* items per transaction regressions with customer fixed effects
clear
pro drop _all
set mem 2g
set more off

global bigdatadir /data/gsb/SBC/CardholderData
global datadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/data
global logdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/logs
global tmpdir /tmp

* set required number of transactions pre and post
global ntx = 13

* read in the cardholder data
use $bigdatadir/cardholder_data_nyc

* drop bookkeeping transactions
drop if prod_num > 999000000

* drop if negative price
drop if nds_amt<0

* drop if zero quantity
drop if nds_qty==0

* drop if large quantities
sort id txdate txid
egen hiq = sum(nds_qty>4), by(id txdate txid)
keep if hiq==0
drop hiq

* drop if no food or beverage items
egen anycals = sum((type==1)|(type==2)|(type==3)), by(id txdate txid)
drop if anycals==0

* collapse so an observation is a transaction
sort id txdate txid
egen txitems = count(_n), by(id txdate txid)
egen bevitems = sum((type==1)), by(id txdate txid)
egen fooditems = sum((type==2)), by(id txdate txid)
qui by id txdate txid: keep if _n==1

* merge in weather data
gen txyear = year(txdate)
gen txmonth = month(txdate)
gen txday = day(txdate)
sort zone txyear txmonth txday
merge zone txyear txmonth txday using $datadir/working/weather
drop if _merge==2

* limit to customers with enough pre and post transactions
gen period = (txdate>=d(01apr2008))
egen npre = sum(period==0), by(id)
keep if npre>=$ntx

* main regression
gen posted = (zone==16)*period
gen temp2 = temp*temp
gen precip2 = precip*precip
gen int txweek = int((txdate-d(01jan2008))/7)
gen int txdow = dow(txdate)

xi i.txdow i.txweek

log using $logdir/cardholder_regs_items.log, text replace
areg txitems posted temp temp2 precip precip2 _I*, absorb(id) vce(robust)
estimates store bev_food
areg bevitems posted temp temp2 precip precip2 _I*, absorb(id) vce(robust)
estimates store bev
areg fooditems posted temp temp2 precip precip2 _I*, absorb(id) vce(robust)
estimates store food

estimates table bev food bev_food, keep(posted) b(%9.3f) se(%9.3f) stats(N r2) title("Items per transaction regressions")

log close
