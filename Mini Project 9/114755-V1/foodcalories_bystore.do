
*foodcalories_bystore.do



clear

insheet using ../data/nutrition/nutrition_food.csv
rename foodname name 
rename calories cal
keep name cal store_id foodzone

replace name=upper(name)

replace name=subinstr(name,"*"," ",5)
replace name=subinstr(name,","," ",5)
replace name=subinstr(name,"'"," ",5)
replace name=subinstr(name,"®"," ",5)
replace name=subinstr(name,"(CANDY)"," ",5)
replace name=subinstr(name,"REDUCED-FAT","LOWFAT",5)
replace name=subinstr(name,"CONTAINS","WITH",5)
replace name=subinstr(name,"COTAINS","WITH",5)
ge withnuts=substr(name,strpos(name,"WITH")-1,.) if strpos(name,"WITH")~=0
replace name=substr(name,1,strpos(name,"WITH")-2) if withnuts~=""

ge foodtype=word(name, -1)
replace name=foodtype+" "+subinstr(name,foodtype,"",1)+" "+withnuts

replace name = itrim(trim(name))

sort name cal


drop foodtype withnuts
save ../data/working/foodcalories_bystoreid, replace
