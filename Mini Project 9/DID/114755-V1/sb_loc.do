
*sb_loc

clear
insheet using ../data/geo/sb_stores_geo2.txt
save ../data/working/sb_stores_geo2, replace

clear
clear
insheet using ../data/geo/sb_stores_geo.txt
append using ../data/working/sb_stores_geo2

tab state

outsheet store bg_lat bg_long if trim(lower(state))=="ma" using ../data/working/sb_boston_loc.txt, noq nol non replace 
outsheet store bg_lat bg_long if trim(lower(state))=="ny" using ../data/working/sb_ny_loc.txt, noq nol non replace
outsheet store bg_lat bg_long if trim(lower(state))=="pa" using ../data/working/sb_philly_loc.txt, noq nol non replace
outsheet store bg_lat bg_long if trim(lower(state))=="ca" using ../data/working/sb_sf_loc.txt, noq nol non replace 

