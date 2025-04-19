
* dd_dist.do

clear

do dd_ny_dist
do dd_boston_dist
do dd_philly_dist

clear
use ../data/working/dd_ny_dist
append using ../data/working/dd_boston_dist
append using ../data/working/dd_philly_dist

sort store

save ../data/working/dd_dist, replace
