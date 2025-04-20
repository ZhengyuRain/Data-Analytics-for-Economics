

log using ../logs/sumstats_dddist, text replace

* sumstats_dddist

clear
use  ../data/working/dd_dist

label var ddid "nearest DD id"
label var dddist "distance to nearset DD"
label var ddr1 "DD within .25 km"
label var ddr2 "DD within .50 km"
label var ddr3 "DD within .75 km"
label var ddr4 "DD within 1.00 km"
label var ddr5 "DD within 1.25 km"
label var ddr6 "DD within 1.50 km"
label var ddr7 "DD within 1.75 km"
label var ddr8 "DD within 2.00 km"
label var ddr9 "DD within 2.25 km"
label var ddr10 "DD within 2.50 km"
label var ddr11 "DD within 2.75 km"
label var ddr12 "DD within 3.00 km"

sort store

merge store using ../data/working/storeinfo
tab _merge
keep if _merge==3
drop _merge

* Distance to nearest Dunkin Donuts
su dddist, detail

* Distances to nearest Dunkin Donuts by city
table zone, c(mean dddist sd dddist p10 dddist p50 dddist p90 dddist)

ge dd50m=dddist<.05
ge dd100m=dddist<.1
ge dd250m=dddist<.25
ge dd500m=dddist<.5
ge dd1000m=dddist<1

bysort zone: su dddist dd100m

* Distance Dummies for nearest Dunkin Donuts by city
table zone, c(mean dd50m mean dd100m mean dd250m mean dd500m mean dd1000m)

* Number of Dunkin Donuts within Radius
table zone, c(mean ddr1 mean ddr2 mean ddr4 mean ddr8 mean ddr12)

hist dddist if zone==16, w(.25) freq saving(../graphs/dddisthist_ny,replace) 
graph export ../graphs/dddisthist_ny.eps, logo(off) replace
!epstopdf ../graphs/dddisthist_ny.eps

hist dddist if zone==15, w(.25) freq saving(../graphs/dddisthist_boston,replace) 
graph export ../graphs/dddisthist_boston.eps, logo(off) replace
!epstopdf ../graphs/dddisthist_boston.eps

hist dddist if zone==51, w(.25) freq saving(../graphs/dddisthist_philly,replace) 
graph export ../graphs/dddisthist_philly.eps, logo(off) replace
!epstopdf ../graphs/dddisthist_philly.eps

log close


