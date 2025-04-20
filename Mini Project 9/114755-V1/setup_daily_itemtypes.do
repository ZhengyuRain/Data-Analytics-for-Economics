
*setup_daily_itemtypes.do

log using $logdir/$currentcity/setup_daily_itemtypes, text replace


clear
use $bigdatadir/working/$currentcity/setup_sumstats3


sort store txyear txmonth txday

* Items by type per Day:

bysort store txyear txmonth txday: egen itemsperday = count(diff_tx)
bysort store txyear txmonth txday: egen itemsperday_short= total(short)
bysort store txyear txmonth txday: egen itemsperday_tall= total(tall)
bysort store txyear txmonth txday: egen itemsperday_grande= total(grande)
bysort store txyear txmonth txday: egen itemsperday_venti= total(venti)
bysort store txyear txmonth txday: egen itemsperday_iced= total(iced)
bysort store txyear txmonth txday: egen itemsperday_hotcoffee= total(hotcoffee)
bysort store txyear txmonth txday: egen itemsperday_hottea= total(hottea)
bysort store txyear txmonth txday: egen itemsperday_mocha= total(mocha)
bysort store txyear txmonth txday: egen itemsperday_latte= total(latte)
bysort store txyear txmonth txday: egen itemsperday_cappuccino= total(cappuccino)
bysort store txyear txmonth txday: egen itemsperday_frap= total(frap)
bysort store txyear txmonth txday: egen itemsperday_fraplight= total(fraplight)


* Food by subdept
bysort store txyear txmonth txday: egen itemsperday_scones = total(sub_dept_cd==10)
bysort store txyear txmonth txday: egen itemsperday_muffins = total(sub_dept_cd==20)
bysort store txyear txmonth txday: egen itemsperday_bagels = total(sub_dept_cd==30)
bysort store txyear txmonth txday: egen itemsperday_sweetrolls = total(sub_dept_cd==50)
bysort store txyear txmonth txday: egen itemsperday_cakes = total(sub_dept_cd==60|sub_dept_cd==70)
bysort store txyear txmonth txday: egen itemsperday_croissants = total(sub_dept_cd==80)


sort store txyear txmonth txday 

save $bigdatadir/working/$currentcity/setup_daily_itemtypes, replace

log close
