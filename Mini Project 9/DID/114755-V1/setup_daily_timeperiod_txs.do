
*  setup_daily_timeperiod_txs

clear
log using $logdir/$currentcity/setup_daily_timeperiod_txs, text replace


use $bigdatadir/working/$currentcity/setup_daily_hourly_txs

* Define timeperiod:
ge timeperiod=4
replace timeperiod=0 if txhour>=6 & txhour<10
replace timeperiod=1 if txhour>=10 & txhour<14
replace timeperiod=2 if txhour>=14 & txhour<17
replace timeperiod=3 if txhour>=17 & txhour<24

ge cals_hour=cal1T*hasdrinkorfood1T
ge cals_drinks_hour=cal1Tdrinks*hasdrinkorfood1T
ge cals_snacks_hour=cal1Tsnacks*hasdrinkorfood1T
ge items_hour=items1T*hasdrinkorfood1T
ge items_drinks_hour=items1Tdrinks*hasdrinkorfood1T
ge items_snacks_hour=items1Tsnacks*hasdrinkorfood1T

ge log_cals_hour=log_cal1T*hasdrinkorfood1T
ge log_cals_drinks_hour=log_cal1Tdrinks*hasdrinkorfood1T
ge log_cals_snacks_hour=log_cal1Tsnacks*hasdrinkorfood1T

bysort store txyear txmonth txday timeperiod: egen cals_timeperiod=total(cals_hour)
bysort store txyear txmonth txday timeperiod: egen cals_drinks_timeperiod=total(cals_drinks_hour)
bysort store txyear txmonth txday timeperiod: egen cals_snacks_timeperiod=total(cals_snacks_hour)
bysort store txyear txmonth txday timeperiod: egen items_timeperiod=total(items_hour)
bysort store txyear txmonth txday timeperiod: egen items_drinks_timeperiod=total(items_drinks_hour)
bysort store txyear txmonth txday timeperiod: egen items_snacks_timeperiod=total(items_snacks_hour)
bysort store txyear txmonth txday timeperiod: egen hasdrinkorfood_timeperiod=total(hasdrinkorfood)

bysort store txyear txmonth txday timeperiod: egen log_cals_timeperiod=total(log_cals_hour)
bysort store txyear txmonth txday timeperiod: egen log_cals_drinks_timeperiod=total(log_cals_drinks_hour)
bysort store txyear txmonth txday timeperiod: egen log_cals_snacks_timeperiod=total(log_cals_snacks_hour)

ge cals1T_timeperiod=cals_timeperiod/hasdrinkorfood_timeperiod
ge cals1T_drinks_timeperiod=cals_drinks_timeperiod/hasdrinkorfood_timeperiod
ge cals1T_snacks_timeperiod=cals_snacks_timeperiod/hasdrinkorfood_timeperiod
ge items1T_timeperiod=items_timeperiod/hasdrinkorfood_timeperiod
ge items1T_drinks_timeperiod=items_drinks_timeperiod/hasdrinkorfood_timeperiod
ge items1T_snacks_timeperiod=items_snacks_timeperiod/hasdrinkorfood_timeperiod

ge log_cals1T_timeperiod=log_cals_timeperiod/hasdrinkorfood_timeperiod
ge log_cals1T_drinks_timeperiod=log_cals_drinks_timeperiod/hasdrinkorfood_timeperiod
ge log_cals1T_snacks_timeperiod=log_cals_snacks_timeperiod/hasdrinkorfood_timeperiod

save $bigdatadir/working/$currentcity/setup_daily_timeperiod_txs, replace

log close
