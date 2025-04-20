* basic calorie regressions with customer fixed effects
clear
pro drop _all
set mem 3g
set more off

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

gen byte female = (gender=="F") 
gen byte femposted = female*posted

gen byte hifreq = (npre>33)
gen byte hifreqposted = hifreq*posted

egen tmp = mean(txcal) if txdate<d(01apr2008), by(id)
egen meanprecal = min(tmp), by(id)
egen tmpi = tag(id)
egen tmp2 = median(meanprecal) if tmpi
egen medcal = min(tmp2)
drop tmp tmpi tmp2
gen calgrp0 = (meanprecal<=50)
gen calgrp1 = (meanprecal>50 & meanprecal<=150)
gen calgrp2 = (meanprecal>150 & meanprecal<=275)
gen calgrp3 = (meanprecal>275)

gen grp0 = (meanprecal<125)
gen grp1 = (meanprecal>=125 & meanprecal<250)
gen grp2 = (meanprecal>=250)

gen byte hical = meanprecal>medcal
gen byte hicalposted = hical*posted

gen byte grp1posted = calgrp1*posted
gen byte grp2posted = calgrp2*posted
gen byte grp3posted = calgrp3*posted

gen byte tg1posted = grp1*posted
gen byte tg2posted = grp2*posted

xi i.txdow i.txweek

replace txcal = log(1+txcal)

log using $logdir/cardholder_regs_calories_het_inlogs.log, text replace
areg txcal posted temp temp2 precip precip2 _I*, absorb(id) vce(robust)
estimates store main
areg txcal posted femposted temp temp2 precip precip2 _I*, absorb(id) vce(robust)
estimates store female
areg txcal posted hifreqposted temp temp2 precip precip2 _I*, absorb(id) vce(robust)
estimates store hifreq
areg txcal posted hicalposted temp temp2 precip precip2 _I*, absorb(id) vce(robust)
estimates store hical
areg txcal posted tg*posted temp temp2 precip precip2 _I*, absorb(id) vce(robust)
estimates store tgrpcal
areg txcal posted grp*posted temp temp2 precip precip2 _I*, absorb(id) vce(robust)
estimates store grpcal

estimates table main female hifreq hical tgrpcal grpcal, keep(posted femposted hifreqposted hicalposted tg1posted tg2posted grp1posted grp2posted grp3posted) b(%9.3f) se(%9.3f) stats(N r2) title("Cals/tx regressions, using cardholder data")

log close
