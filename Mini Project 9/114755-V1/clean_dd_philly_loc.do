
* clean_dd_philly_loc

clear
insheet using ../data/geo/dd_philly_geo.txt, delim("|")

rename bg_lat latitude 
rename bg_long longitude

ge ddid=_n

count

outsheet ddid latitude longitude  using ../data/working/dd_philly_loc.txt, noq nol non replace
