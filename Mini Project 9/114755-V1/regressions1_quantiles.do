global statadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/stata
cd $statadir
global datadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/data
global logdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/stata/logs
global tmpdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/tmp
global graphdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/graphs
global bigdatadir /data/gsb/SBC


* regressions1_quantiles.do


clear
set more off
set mem 15g

use /data/gsb/SBC/working/setup_daily_quantiles

sort store
merge store using ../data/working/storeinfo
drop if _merge==2
drop _merge

sort zone txmonth txday
merge zone txmonth txday using ../data/working/weather
tab _merge
drop if _merge==2
drop _merge


* Explanatory vars:

gen after = (txmonth>4) | (txmonth==4 & txday>15)
gen law = after*(zone==16)
gen txdow = dow(mdy(txmonth,txday,2008))
gen txweek = week(mdy(txmonth,txday,2008))

global demog "pop25* white* black* asian* hisp* age* male* female* avg* med*"

ge temp2 = temp^2
ge precip2 = precip^2
global weather "temp temp2 precip precip2"

global business "n_* worker*"

* Regressions, single law dummy:

xi: areg meancal law $weather i.txdow i.txweek, absorb(store)
estimates store mean
xi: areg p50cal law $weather i.txdow i.txweek, absorb(store)
estimates store median
xi: areg p90cal law $weather i.txdow i.txweek, absorb(store)
estimates store pctile90
xi: areg p95cal law $weather i.txdow i.txweek, absorb(store)
estimates store pctile95

log using ../logs/regressions1_quantiles, text replace
estimates table mean median pctile90 pctile95, b(%9.3f) star(.05 .01 .001) stats(N r2)
log close
