
log using ../logs/stores_sumstats1, text replace

*stores_sumstats1.do

clear
use $datadir/working/storeinfo
sort store

*merge store using $datadir/working/setup_store1
*tab _merge
*keep if _merge==3
*drop _merge


*tab city, sort
tab zone,sort

*su strevenue, detail
*su sttransactions, detail
su sqft, detail

bysort zone: su sqft 


*ge revenue_perday=strevenue/(mdy(8,31,2008)-max(mdy(openmonth,openday,openyear),mdy(1,1,2008)))
*ge transactions_perday=sttransactions/(mdy(8,31,2008)-max(mdy(openmonth,openday,openyear),mdy(1,1,2008)))
*ge revenue_before_perday=strevenue_before/(mdy(4,15,2008)-max(mdy(openmonth,openday,openyear),mdy(1,1,2008)))
*ge transactions_before_perday=sttransactions_before/(mdy(4,15,2008)-max(mdy(openmonth,openday,openyear),mdy(1,1,2008)))
*ge revenue_after_perday=strevenue_after/(mdy(8,31,2008)-max(mdy(openmonth,openday,openyear),mdy(4,15,2008)))
*ge transactions_after_perday=sttransactions_after/(mdy(8,31,2008)-max(mdy(openmonth,openday,openyear),mdy(4,15,2008)))

* 


*table zone, c(mean revenue_perday mean revenue_before_perday mean revenue_after_perday)
*table zone, c(mean transactions_perday mean transactions_before_perday mean transactions_after_perday)

*table zone, c(mean sthasregsisterD mean sthasregsisterN mean sthasregsisterR)


log close
