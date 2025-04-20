
*foodcal_zoneinfo_allzones_nozoneids.do

clear

insheet using ../data/nutrition/nutrition_food_byzones_allzones_nozoneids.txt

keep name

ge weight=real(word(name,-16))
ge cal=real(word(name,-15))
ge calfat=real(word(name,-14))
ge fat=real(word(name,-13))
ge satfat=real(word(name,-12))
ge transfat=real(word(name,-11))
ge chol=real(word(name,-10))
ge sodium=real(word(name,-9))
ge carb=real(word(name,-8))
ge dietfib=real(word(name,-7))
ge sugar=real(word(name,-6))
ge protein=real(word(name,-5))
ge vita=real(word(name,-4))
ge vitc=real(word(name,-3))
ge calcium=real(word(name,-2))
ge iron=real(word(name,-1))

replace name=substr(name,1,strpos(name,string(weight))-2)

drop if cal==.
sort name
drop if name==name[_n-1]
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

drop foodtype withnuts

sort name 

save ../data/working/foodnutr_zoneinfo_allzones_nozoneids, replace
keep name cal
save ../data/working/foodcal_zoneinfo_allzones_nozoneids, replace

