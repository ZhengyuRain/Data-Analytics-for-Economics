* basic calorie regressions with customer fixed effects
clear
pro drop _all
set mem 9g
set more off

global bigdatadir /data/gsb/SBC/CardholderData
global datadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/data
global logdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/logs
global tmpdir /tmp

* set required number of transactions pre and post
* and cutoffs for commuters
global ntx = 13
global lo = 0.33
global hi = 0.67

/*
* read in the cardholder data
use $bigdatadir/cardholder_data, clear

* merge in store info
sort store
merge store using $datadir/working/storezones
drop if _merge==2
drop _merge

* drop people who never transacted in NYC or BOS or PHL
egen everin = max(zone==15|zone==16|zone==51), by(id)
drop if everin==0
drop everin

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

save /tmp/tmpcomm, replace

* merge in calorie info
* set zone=16 if missing; this just assigns NY calories to stores with no zone
gen ny = (zone==16)
replace zone=16 if zone==.
sort prod_num zone
merge prod_num zone using $datadir/working/calories_sparse
drop if _merge==2
drop _merge
replace zone=. if zone==16 & ny==0

* drop if no food or beverage items
egen anycals = sum((type==1)|(type==2)|(type==3)), by(id txdate txid)
drop if anycals==0

* calculate calories
sort id txdate txid
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
drop _merge

* use same sample as we use in main regressions
save /tmp/tmp1, replace
use $bigdatadir/cardholder_data_nyc, clear
drop if prod_num > 999000000
drop if nds_amt<0
drop if nds_qty==0
sort id txdate txid
egen hiq = sum(nds_qty>4), by(id txdate txid)
keep if hiq==0
drop hiq
egen anycals = sum((type==1)|(type==2)|(type==3)), by(id txdate txid)
drop if anycals==0
qui by id txdate txid: keep if _n==1
gen txyear = year(txdate)
gen txmonth = month(txdate)
gen txday = day(txdate)
sort zone txyear txmonth txday
merge zone txyear txmonth txday using $datadir/working/weather
drop if _merge==2
gen period = (txdate>=d(15apr2008))
egen npre = sum(period==0), by(id)
keep if npre>=$ntx
sort id
qui by id: keep if _n==1
keep id
sort id
save /tmp/tmpid, replace
*/
use /tmp/tmp1, clear
sort id
merge id using /tmp/tmpid
keep if _merge==3
drop _merge

* limit to customers with enough pre and post transactions
gen period = (txdate>=d(01apr2008))
egen npre = sum(period==0), by(id)
keep if npre>=$ntx

* identify cardholders' home cities
gen nbp = (zone==15|zone==16|zone==51)
egen nzone = count(_n), by(id zone)
replace nzone = -nzone
replace nbp = -nbp
sort id nbp nzone
qui by id: gen tmp=(_n==1)
egen homezone = max(zone*tmp), by(id)
drop tmp

* identify commuters
egen npost = sum(period==1), by(id)
egen pre_in = sum((period==0)*(zone==homezone)), by(id)
gen prefrac_in = pre_in/npre
egen post_in = sum((period==1)*(zone==homezone)), by(id)
gen postfrac_in = post_in/npost
gen commuter = (npre>=15 & npost>=15 & (prefrac_in>=$lo & prefrac_in<=$hi) & (postfrac_in>=$lo & postfrac_in<=$hi))

* generate interactions for commuters
gen byte nyc = (homezone==16)
gen byte incity = (zone==homezone)
gen byte postlaw = period
gen c_out = commuter*(incity==0)
gen c_out_ny = c_out*(homezone==16)
gen c_out_post = c_out*postlaw
gen c_out_post_ny = c_out_post*(homezone==16)

* main regression
gen byte posted = (zone==16)*period
gen byte posted_nc = posted*(commuter==0)
gen temp2 = temp*temp
gen precip2 = precip*precip
gen int txweek = int((txdate-d(01jan2008))/7)
gen int txdow = dow(txdate)
gen byte onebev = (nbev==1)
gen byte onefood = (nfood==1)

* time of day controls
gen txtod = 0 if (halfhour/2)>6 & (halfhour/2)<=10
replace txtod = 1 if (halfhour/2)>10 & (halfhour/2)<=14
replace txtod = 2 if (halfhour/2)>14 & (halfhour/2)<=18
replace txtod = 3 if (halfhour/2)>18 & (halfhour/2)<=22
replace txtod = 4 if txtod==.

xi i.txdow i.txweek i.txtod

gen logtxcal = log(1+txcal)
gen logbcal = log(1+bevcal)
gen logfcal = log(1+foodcal)

gen posted_c = posted*commuter
gen postlaw_c = postlaw*(incity==0)*(homezone==16)

* number of "exposures" to calorie info
sort id txdate
qui by id: gen nexp = sum(posted)

log using $logdir/cardholder_commuters_33_67.log, text replace

di $lo
di $hi

drop if homezone==.
egen ck = tag(id)
tab homezone commuter if ck, missing

table period incity if commuter & homezone==16, c(mean txcal median txcal count txcal)
table period incity if commuter & homezone~=16, c(mean txcal median txcal count txcal)

tab txdow incity if commuter, col nofreq

table homezone period, c(mean txcal)

gen nyc_out = (homezone==16)*(incity==0)*commuter
gen nyc_out_post = nyc_out*period
gen nyc_in_post = (homezone==16)*(incity==1)*commuter*period

gen nyc_out_post_x = nyc_out_post*nexp
gen nyc_out_exp0 = nyc_out_post*(nexp==0)
gen nyc_out_exp1 = nyc_out_post*(nexp>0 & nexp<4)
gen nyc_out_exp2 = nyc_out_post*(nexp>3)
gen nyc_out_exp12 = nyc_out_post*(nexp>0)


areg logtxcal nyc_in_post nyc_out_post nyc_out temp temp2 precip* _I* if commuter, absorb(id) vce(robust)

gen nyc_out_postA = nyc_out_post*(txdate<d(01jun2008))
gen nyc_out_postB = nyc_out_post*(txdate>=d(01jun2008))

areg logtxcal nyc_in_post nyc_out_postA nyc_out_postB nyc_out temp temp2 precip* _I* if commuter, absorb(id) vce(robust)

* main regression
areg logtxcal posted_nc nyc_in_post nyc_out_post nyc_out temp temp2 precip* _I*, absorb(id) vce(robust)

* in levels instead of logs
areg txcal posted_nc nyc_in_post nyc_out_post nyc_out temp temp2 precip* _I*, absorb(id) vce(robust)

* omit weekend transactions
areg logtxcal posted_nc nyc_in_post nyc_out_post nyc_out temp temp2 precip* _I* if txdow>0 & txdow<6, absorb(id) vce(robust)

* food calories
areg logfcal posted_nc nyc_in_post nyc_out_post nyc_out temp temp2 precip* _I*, absorb(id) vce(robust)

* food calories in levels
areg foodcal posted_nc nyc_in_post nyc_out_post nyc_out temp temp2 precip* _I*, absorb(id) vce(robust)

* interact with number of previous exposures
areg logtxcal posted_nc nyc_in_post nyc_out_post nyc_out_post_x nyc_out temp temp2 precip* _I*, absorb(id) vce(robust)
areg logtxcal posted_nc nyc_in_post nyc_out_exp0 nyc_out_exp1 nyc_out_exp2 nyc_out temp temp2 precip* _I*, absorb(id) vce(robust)
areg logtxcal posted_nc nyc_in_post nyc_out_exp0 nyc_out_exp12 nyc_out temp temp2 precip* _I*, absorb(id) vce(robust)

* without weekend transactions
gen weekday = (txdow>0 & txdow<6)
areg logtxcal posted_nc nyc_in_post nyc_out_post nyc_out temp temp2 precip* _I* if weekday, absorb(id) vce(robust)
areg logtxcal posted_nc nyc_in_post nyc_out_exp0 nyc_out_exp1 nyc_out_exp2 nyc_out temp temp2 precip* _I* if weekday, absorb(id) vce(robust)
areg logtxcal posted_nc nyc_in_post nyc_out_exp0 nyc_out_exp12 nyc_out temp temp2 precip* _I* if weekday, absorb(id) vce(robust)

log close
