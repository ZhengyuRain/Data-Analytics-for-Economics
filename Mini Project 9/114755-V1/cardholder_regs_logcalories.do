* basic calorie regressions with customer fixed effects
* (in logs)
clear
pro drop _all
set mem 9g
set more off

global add = 1

global bigdatadir /data/gsb/SBC/CardholderData
global datadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/data
global logdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/logs
global tmpdir /tmp

* set required number of transactions pre and post
global ntx = 13

* read in the NYC cardholder data
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

* calculate calories
egen txcal = sum(cal*nds_qty), by(id txdate txid)
egen bevcal = sum(cal*nds_qty*(type==1|type==3)), by(id txdate txid)
egen foodcal = sum(cal*nds_qty*(type==2)), by(id txdate txid)
egen byte nbev = sum((type==1)), by(id txdate txid)
egen byte nfood = sum((type==2)), by(id txdate txid)

* collapse so an observation is a transaction
qui by id txdate txid: keep if _n==1
gen bcalper = bevcal/nbev
gen fcalper = foodcal/nfood

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
gen byte onebev = (nbev==1)
gen byte onefood = (nfood==1)

xi i.txdow i.txweek

gen logtxcal = log($add+txcal)
gen logbevcal = log($add+bevcal)
gen logfoodcal = log($add+foodcal)
gen logbcalper = log($add+bcalper)
gen logfcalper = log($add+fcalper)

log using $logdir/cardholder_regs_logcalories.log, text replace
areg logtxcal posted temp temp2 precip precip2 _I*, absorb(id) vce(robust)
estimates store bev_food
areg logbevcal posted temp temp2 precip precip2 _I*, absorb(id) vce(robust)
estimates store bev
areg logfoodcal posted temp temp2 precip precip2 _I*, absorb(id) vce(robust)
estimates store food

areg logbcalper posted temp temp2 precip precip2 _I* if nbev>0, absorb(id) vce(robust)
estimates store bevperitem
areg logfcalper posted temp temp2 precip precip2 _I* if nfood>0, absorb(id) vce(robust)
estimates store foodperitem

estimates table bev food bev_food, keep(posted) b(%9.3f) se(%9.3f) stats(N r2) title("Cals/tx regressions, using cardholder data")

estimates table bevperitem foodperitem, keep(posted) b(%9.3f) se(%9.3f) stats(N r2) title("Calories per item purchased regressions, cardholder data")

log close
