
log using ../logs/trans_sumstats3, text replace

* trans_sumstats3.do

* Calculates shares of items by month and zone

* Non-consumable and meal items have been removed!

set more off

clear
use /data/gsb/SBC/working/setup_sumstats2
*use ../data/working/setup_sumstats2

************** Shares of types of drink/food **********
keep txid prod_num txmonth zone sub_dept_cd type after
sort prod_num
_merge prod_num using ../data/working/drinktypedummies
tab _merge
drop _merge


* Shares

table txmonth zone, c(mean short)
table txmonth zone, c(mean tall)
table txmonth zone, c(mean grande)
table txmonth zone, c(mean venti)
table txmonth zone, c(mean iced)

table txmonth zone, c(mean frap)
table txmonth zone, c(mean fraplight)
table txmonth zone, c(mean hotcoffee)
table txmonth zone, c(mean hottea)
table txmonth zone, c(mean mocha)
table txmonth zone, c(mean latte)
table txmonth zone, c(mean cappuccino)

ge muffin=sub_dept_cd==20
ge bagel=sub_dept_cd==30
ge coffeecake=sub_dept_cd==60
ge croissant=sub_dept_cd==80

table txmonth zone, c(mean muffin)
table txmonth zone, c(mean bagel)
table txmonth zone, c(mean coffeecake)
table txmonth zone, c(mean croissant)

ge addwhip=(prod_num==109891)
table txmonth zone, c(mean addwhip)

ge drinkvar=0
replace drinkvar=1 if hotcoffee==1
replace drinkvar=2 if hottea==1
replace drinkvar=3 if latte==1
replace drinkvar=4 if mocha==1
replace drinkvar=5 if cappuccino==1
replace drinkvar=6 if frap==1
replace drinkvar=7 if fraplight==1

label define drinklabel 1 "Hot Coffee" 2 "Hot Tea" 3 "Latte" 4 "Mocha" 5 "Cappuccino" 6 "Frappuccino" 7 "Light Frappuccino" 0 "Other"
label values drinkvar drinklabel 
label var drinkvar "Drink Type"

ge sizevar=0
replace sizevar=1 if short==1
replace sizevar=2 if tall==1
replace sizevar=3 if grande==1
replace sizevar=4 if venti==1

label define sizelabel 1 "Short" 2 "Tall" 3 "Grande" 4 "Venti"
label values sizevar sizelabel 
label var sizevar "Size"

tab drinkvar sizevar if drinkvar>0 & sizevar>0 & zone==16 & after==0, freq
tab drinkvar sizevar if drinkvar>0 & sizevar>0 & zone==16 & after==1, freq


table drinkvar if type==1 & zone==16 & after==0, c(mean short mean tall mean grande mean venti)
table drinkvar if type==1 & zone==16 & after==1, c(mean short mean tall mean grande mean venti)


log close
