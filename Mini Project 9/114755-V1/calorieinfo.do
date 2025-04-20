
*calorieinfo.do



*calorie_productlist.do


clear

insheet using ../data/nutrition/extracalories.txt

ge type=3
save ../data/working/extracalories, replace

clear
insheet using ../data/nutrition/calories_onlinesupplement.txt, names

append using ../data/working/extracalories
append using ../data/working/drinkcalories
append using ../data/working/foodcalories

replace name=trim(itrim(upper(name)))

* Change food type for meal items
ge name_padded=" "+name+" "
replace type=5 if type==2 & strpos(name_padded," SANDWICH ")~=0
replace type=5 if type==2 & strpos(name_padded," SANDWHICH ")~=0
replace type=5 if type==2 & strpos(name_padded," WRAP ")~=0
replace type=5 if type==2 & strpos(name_padded," BREAKFAST ")~=0
replace type=5 if type==2 & strpos(name_padded," SALAD ")~=0
replace type=5 if type==2 & strpos(name_padded," BAGUETT ")~=0
replace type=5 if type==2 & strpos(name_padded," BAGUETTE ")~=0
replace type=5 if type==2 & strpos(name_padded," FRUIT BOWL ")~=0
replace type=5 if type==2 & strpos(name_padded," BRUSCHETTA ")~=0
replace type=5 if type==2 & strpos(name_padded," MIXED VEGGIES ")~=0
replace type=5 if type==2 & strpos(name_padded," APPLE AND CHEDDAR ")~=0

************* Add dummy vars ******************

*Add dummy for FRAPPUCCINO BLENDED COFFEE, FRAPPUCCINO LIGHT BLENDED COFFEE
ge frap=0
ge fraplight=0
replace frap=1 if strpos(name_padded," FRAPPUCCINO ")~=0 & strpos(name_padded," BLENDED COFFEE ")~=0 & strpos(name_padded," LIGHT ")==0
replace fraplight=1 if strpos(name_padded," FRAPPUCCINO ")~=0 & strpos(name_padded," BLENDED COFFEE ")~=0 & strpos(name_padded," LIGHT ")~=0

ge short=0
ge tall=0
ge grande=0
ge venti=0

replace short=1 if strpos(name_padded," SHORT ")~=0 & type==1
replace tall=1 if strpos(name_padded," TALL ")~=0 & type==1
replace grande=1 if strpos(name_padded," GRANDE ")~=0 & type==1
replace venti=1 if strpos(name_padded," VENTI ")~=0 & type==1


ge iced=0
replace iced=1 if strpos(name_padded," ICED ")~=0 & type==1

ge hotcoffee=0
replace hotcoffee=1 if strpos(name,"COFFEE")~=0 & wordcount(name)<=3 & type==1 & iced==0
*replace hotcoffee=1 if name_padded==" COFFEE DRIP " | name_padded==" COFFEE SHORT " | name_padded==" COFFEE SHORT " | name_padded==" COFFEE DECAF SHORT " | name_padded==" COFFEE TALL " | name_padded==" COFFEE DECAF TALL " | name_padded==" COFFEE GRANDE " | name_padded==" COFFEE DECAF GRANDE " | name_padded==" COFFEE VENTI " | name_padded==" COFFEE DECAF VENTI "
*replace hotcoffee=1 if name_padded==" 2.5 OZ COFFEE " | name_padded==" COFFEE 40Z "

ge hottea=0
replace hottea=1 if name_padded==" TEA SHORT " | name_padded==" TEA TALL " | name_padded==" TEA GRANDE " | name_padded==" TEA VENTI "

ge mocha=0
replace mocha=1 if strpos(name_padded," MOCHA ")~=0 & type==1

ge latte=0
replace latte=1 if strpos(name_padded," LATTE ")~=0 & type==1

ge cappuccino=0
replace cappuccino=1 if strpos(name_padded," CAPPUCCINO ")~=0 & type==1


drop name_padded



replace name=trim(itrim(upper(name)))

count if name ==""

*sort so non-zone info used after zone, and online data last
gsort -name_zone name -notes
drop if name_zone==name_zone[_n-1] & name==name[_n-1]
drop name_zone
count
count if type==.

rename foodzone zone
replace zone=0 if zone==.

sort name zone
save ../data/working/calorieinfo, replace



******************** Generate Calorie Info by Zones **************

clear
use ../data/working/calorieinfo
replace zone=5 if zone==0
keep if zone==5
save ../data/working/calorieinfo_zone5, replace
clear
use ../data/working/calorieinfo
replace zone=15 if zone==0
keep if zone==15
save ../data/working/calorieinfo_zone15, replace
clear
use ../data/working/calorieinfo
replace zone=16 if zone==0
keep if zone==16
save ../data/working/calorieinfo_zone16, replace
clear
use ../data/working/calorieinfo
replace zone=51 if zone==0
keep if zone==51
save ../data/working/calorieinfo_zone51, replace
clear
use ../data/working/calorieinfo
replace zone=64 if zone==0
keep if zone==64
save ../data/working/calorieinfo_zone64, replace
clear
use ../data/working/calorieinfo
replace zone=11 if zone==0
keep if zone==11
save ../data/working/calorieinfo_zone11, replace
clear
use ../data/working/calorieinfo
replace zone=24 if zone==0
keep if zone==24
save ../data/working/calorieinfo_zone24, replace



clear

use ../data/working/calorieinfo_zone5
append using ../data/working/calorieinfo_zone11
append using ../data/working/calorieinfo_zone15
append using ../data/working/calorieinfo_zone16
append using ../data/working/calorieinfo_zone24
append using ../data/working/calorieinfo_zone51
append using ../data/working/calorieinfo_zone64



sort name zone

save ../data/working/calorieinfo_zones, replace



