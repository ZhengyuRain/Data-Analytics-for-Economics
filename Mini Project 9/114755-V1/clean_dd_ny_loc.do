

* clean_dd_ny_loc

clear
insheet using ../data/geo/dd_ny_geo.txt


ge latitude=real(bg_lat) if v9==.
replace latitude=bg_long if v9~=.
ge longitude=bg_long if v9==.
replace longitude=v9 if v9~=.

drop v9 bg_lat bg_long phone

ge ddid=_n

count

outsheet ddid latitude longitude using ../data/working/dd_ny_loc.txt, noq nol non replace

