
* dd_philly_dist

clear
insheet using ../data/working/philly_distvars.raw, delim(" ")

rename v1 store
rename v3 ddid
rename v5 dddist
rename v7 ddr1
rename v9 ddr2
rename v11 ddr3
rename v13 ddr4
rename v15 ddr5
rename v17 ddr6
rename v19 ddr7
rename v21 ddr8
rename v23 ddr9
rename v25 ddr10
rename v27 ddr11
rename v29 ddr12

drop v*

save ../data/working/dd_philly_dist, replace



