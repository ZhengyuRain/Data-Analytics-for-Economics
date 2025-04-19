
*cals_to_transactionproducts.do
clear
use ../data/working/productfile_consumption_ids_calorienames_zones

merge name zone using ../data/working/calorieinfo_zones

tab _merge
*drop cal info not used
drop if _merge==2

ge producthassubstitute=(name~=item_description & _merge==3)


*_merge=1 should all be non-consumables
* CHECK THIS BY HAND!

drop if consume==0


drop _merge



* CHANGE TYPE FOR MEAL ITEMS IF NOT IN CALORIE INFO
ge name_padded=" "+name+" "
replace type=5 if type==. & strpos(name_padded," SAND ")~=0
replace type=5 if type==. & strpos(name_padded," SANDWICH ")~=0
replace type=5 if type==. & strpos(name_padded," SANDWHICH ")~=0
replace type=5 if type==. & strpos(name_padded," WRAP ")~=0
replace type=5 if type==. & strpos(name_padded," BREAKFAST ")~=0
replace type=5 if type==. & strpos(name_padded," SALAD ")~=0
replace type=5 if type==. & strpos(name_padded," BAGUETT")~=0
replace type=5 if type==. & strpos(name_padded," BAGUETTE")~=0
replace type=5 if type==. & strpos(name_padded," FRUIT BOWL ")~=0
replace type=5 if type==. & strpos(name_padded," BRUSCHETTA ")~=0
replace type=5 if type==. & strpos(name_padded," MIXED VEGGIES ")~=0
replace type=5 if type==. & strpos(name_padded," APPLE AND CHEDDAR ")~=0
replace type=5 if type==. & strpos(name_padded," PIADINI ")~=0
replace type=5 if type==. & strpos(name_padded," PROSCIUTTO ")~=0
replace type=5 if type==. & strpos(name_padded," LUNCH BOX ")~=0

drop name_padded

keep prod_num type producthas* zone item_description cal* zonematters frap* short tall grande venti iced hot* latte mocha cappuccino
*cal1: whole 
*cal2: 2 percent 
*cal3: skim 
*cal4: soy 

* FIX ZONES
replace zone =0 if zone ==.
sort prod_num zone
drop if zone==0 & item_description==item_description[_n+1]
replace zone=0 if (item_description~=item_description[_n-1] & item_description~=item_description[_n+1])
egen prod_zone=group(prod_num zone)

*Replace empty values for foods not present in some zones

replace type=type[_n-1] if type==. & prod_num==prod_num[_n-1]
replace zonematters=zonematters[_n-1] if zonematters==. & prod_num==prod_num[_n-1]
replace frap=frap[_n-1] if frap==. & prod_num==prod_num[_n-1]
replace fraplight=fraplight[_n-1] if fraplight==. & prod_num==prod_num[_n-1]
replace type=type[_n+1] if type==. & prod_num==prod_num[_n+1]
replace zonematters=zonematters[_n+1] if zonematters==. & prod_num==prod_num[_n+1]
replace frap=frap[_n+1] if frap==. & prod_num==prod_num[_n+1]
replace fraplight=fraplight[_n+1] if fraplight==. & prod_num==prod_num[_n+1]
replace type=type[_n-1] if type==. & prod_num==prod_num[_n-1]
replace zonematters=zonematters[_n-1] if zonematters==. & prod_num==prod_num[_n-1]
replace frap=frap[_n-1] if frap==. & prod_num==prod_num[_n-1]
replace fraplight=fraplight[_n-1] if fraplight==. & prod_num==prod_num[_n-1]
replace type=type[_n+1] if type==. & prod_num==prod_num[_n+1]
replace zonematters=zonematters[_n+1] if zonematters==. & prod_num==prod_num[_n+1]
replace frap=frap[_n+1] if frap==. & prod_num==prod_num[_n+1]
replace fraplight=fraplight[_n+1] if fraplight==. & prod_num==prod_num[_n+1]
replace type=type[_n-1] if type==. & prod_num==prod_num[_n-1]
replace zonematters=zonematters[_n-1] if zonematters==. & prod_num==prod_num[_n-1]
replace frap=frap[_n-1] if frap==. & prod_num==prod_num[_n-1]
replace fraplight=fraplight[_n-1] if fraplight==. & prod_num==prod_num[_n-1]
replace type=type[_n+1] if type==. & prod_num==prod_num[_n+1]
replace zonematters=zonematters[_n+1] if zonematters==. & prod_num==prod_num[_n+1]
replace frap=frap[_n+1] if frap==. & prod_num==prod_num[_n+1]
replace fraplight=fraplight[_n+1] if fraplight==. & prod_num==prod_num[_n+1]

***************** Save calorie File ***************************
sort prod_num zone

* Set cal1--cal4 values to . if not milk dependent
ge milkdoesntmatter=(cal1==cal2 & cal3==cal4 & cal1==cal3)
replace cal1=. if milkdoesntmatter
replace cal2=. if milkdoesntmatter
replace cal3=. if milkdoesntmatter
replace cal4=. if milkdoesntmatter
drop milkdoesntmatter

rename cal1 cal_whole
rename cal2 cal_2perc
rename cal3 cal_nonfat
rename cal4 cal_soy

replace zonematters=0 if zonematters==.

compress

save ../data/working/calories, replace

*************** Generate Sparse Cal File ************


*gen sparse cal file
sort prod_num zone
keep prod_num zone cal type 
save ../data/working/calories_sparse, replace

