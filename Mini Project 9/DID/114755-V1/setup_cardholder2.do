

clear
use $bigdatadir/working/setup_cardholder1


* Drop if not in data enough

egen npre = sum(period==0), by(id)
egen npost = sum(period==1), by(id)
keep if npre>=$ntx & npost>=$ntx

* Other vars:

gen posted = ny*period

* Fill missing weather data for jan 22 2008 and aug 18 2008 with previous day
sort store txdate
replace temp=temp[_n-1] if temp==.
replace precip=precip[_n-1] if precip==.

gen temp2 = temp*temp
gen precip2 = precip*precip

*********** Aggregate visits if same day *************
count
count if id==id[_n-1] & txdate==txdate[_n-1]

sort id txdate
bysort id txdate: egen calday=total(txcal)

drop if id==id[_n-1] & txdate==txdate[_n-1]

save $bigdatadir/working/setup_cardholder2, replace

