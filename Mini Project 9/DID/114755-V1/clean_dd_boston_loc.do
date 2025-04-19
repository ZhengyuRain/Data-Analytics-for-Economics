
* clean_dd_boston_loc

clear
insheet using ../data/geo/dd_boston_geo.txt

rename bg_lat latitude 
rename bg_long longitude
rename establishment name
rename neighborhood city

ge ddid=_n

count

outsheet ddid latitude longitude using ../data/working/dd_boston_loc.txt, noq nol non replace
