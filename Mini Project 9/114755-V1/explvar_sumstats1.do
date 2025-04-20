
* explvar_sumstats1.do

set more off

log using $logdir/explvar_sumstats1, text replace



clear
use $datadir/working/explvar

sort zip
merge zip using $datadir/working/zips_intxs
keep if _merge==3
drop _merge

sort zip
keep if zip~=zip[_n-1]

* OPTIONAL:
keep if zone==15 | zone==16 | zone==51

* Sum stats over zip codes within city
sort zone


bysort zone: egen popcity=total(pop2007)

*describe
by zone: su rest_perperson chainrest_perperson popcity medhhinc collegedegree age2045 males [iweight=pop2007]

clear

use ../data/working/weather

drop if txyear==2009 & txmonth>2

* OPTIONAL:
keep if zone==15 | zone==16 | zone==51

* Sum stats over time within city
sort zone

ge precipdummy=precip>0 & precip~=.



*describe
by zone: su precipdummy maxtemp 

log close

