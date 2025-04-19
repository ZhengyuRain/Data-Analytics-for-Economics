
clear
use ../data/working/calorieinfo

* Make list for text merge
sort name
drop if name==name[_n-1]
keep name
count
outsheet using ../data/working/productfile_calinfo.txt, replace noq non nol


