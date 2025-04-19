
*setup_daily_itemtypes_nyc

clear
save $bigdatadir/working/nyc/setup_daily_itemtypes
append using $bigdatadir/working/bos/setup_daily_itemtypes
append using $bigdatadir/working/phi/setup_daily_itemtypes

sort store txyear txmonth txday 

save $bigdatadir/working/nyc/setup_daily_itemtypes_nyc, replace
