
* drinktypes.do


clear
use ../data/working/calories

drop if short==.

sort prod_num
drop if prod_num==prod_num[_n-1]

keep prod_num frap* short tall grande venti iced hot* latte mocha cappuccino

sort prod_num
save ../data/working/drinktypedummies, replace


