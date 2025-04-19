
*reshape drink calorie info, prepare to match with products 

* BEV INFO FROM SCRIPT DATA:

clear
insheet using ../data/nutrition/nutrition_beverage.csv

rename bevname name
replace name=upper(name)
rename calories cal

keep size milk name cal

sort size milk name
egen temp=group(size milk name)
drop if temp==temp[_n-1]
drop temp


save ../data/working/drinkdatascript, replace

* BEV INFO BY HAND, OCT 2008

clear
insheet using ../data/nutrition/nutrition_drinks.txt

drop v*
*remove vars not constant accross milk types oher than calories
keep size milk name cal

append using ../data/working/drinkdatascript

************************************************

drop if cal==.
ge milk_=.

* Set milk to default if N/A
replace milk_=2 if strpos(proper(milk),"N/A")~=0

replace milk_=1 if strpos(proper(milk),"Whole")~=0
replace milk_=2 if strpos(proper(milk),"Twoperc")~=0
replace milk_=2 if strpos(proper(milk),"2")~=0
replace milk_=3 if strpos(proper(milk),"Nonfat")~=0
replace milk_=4 if strpos(proper(milk),"Soy")~=0

replace milk_=1 if milk=="Whole"
replace milk_=2 if milk=="Twoperc"
replace milk_=3 if milk=="Nonfat"
replace milk_=4 if milk=="Soy"

replace size=subinstr(size,"®","",5)
ge size_=.
replace size_=1 if strpos(proper(size),"Venti")~=0
replace size_=2 if strpos(proper(size),"Grande")~=0
replace size_=3 if strpos(proper(size),"Tall")~=0
replace size_=4 if strpos(proper(size),"Solo")~=0
replace size_=5 if strpos(proper(size),"Doppio")~=0
replace size_=6 if strpos(proper(size),"Short")~=0

replace name=upper(name)
replace name=subinstr(name,"*"," ",5)
replace name=subinstr(name,","," ",5)
replace name=subinstr(name,"'"," ",5)
replace name=subinstr(name,"®"," ",5)
replace name=subinstr(name,"™"," ",5)
replace name=subinstr(name,"NO WHIP"," ",5)
replace name=subinstr(name,"-"," ",5)
replace name=subinstr(name,"-"," ",5)
replace name=subinstr(name,"è","E",5)
replace name=subinstr(name,"é","E",5)
replace name=subinstr(name,"OF THE WEEK","",5)
replace name=subinstr(name,"BREWED"," ",5)


replace name = itrim(trim(name))



sort size milk name
egen temp=group(size milk name)
drop if temp==temp[_n-1]
drop temp

drop if cal==.

sort name size_
egen temp=group(name size_)
sort temp milk_
drop if temp==temp[_n-1] & milk_==milk_[_n-1]
replace name=name+" "+size

drop size* milk


reshape wide cal, i(temp) j(milk_)


*cal1: whole 
*cal2: 2 percent 
*cal3: skim 
*cal4:  soy 



* set WHIP CREAM default to be yes for frap., hot choc.

ge defaultwhip=0
replace defaultwhip=1 if strpos(name,"HOT CHOCOLATE")~=0
replace defaultwhip=1 if strpos(name,"FRAPPUCCINO")~=0 & strpos(name,"LIGHT")==0 & strpos(name,"COFFEE FRAPPUCCINO")==0
replace defaultwhip=1 if strpos(name,"MOCHA")~=0
replace defaultwhip=1 if strpos(name,"PUMPKIN SPICE")~=0
replace defaultwhip=1 if strpos(name,"CINNAMON DOLCE")~=0
replace defaultwhip=1 if strpos(name,"CHOCOLATY CHIP")~=0
replace defaultwhip=1 if strpos(name,"WHITE CHOCOLATE")~=0
replace defaultwhip=1 if strpos(name,"PEPPERMINT")~=0
replace defaultwhip=1 if strpos(name,"CARAMEL APPLE SPICE")~=0
replace defaultwhip=1 if strpos(name,"GINGERBREAD")~=0

* SKINNY DRINKS NO WHIP BY DEFAULT
replace defaultwhip=0 if strpos(name,"SKINNY")~=0
replace defaultwhip=0 if strpos(name,"LIGHT")~=0

* DROP WHIP CREAM DRINK CAL DATA WITHOUT WHIP
drop if defaultwhip==1 & strpos(name,"WHIP")==0

* DROP "WHIP" FROM NAME OF DEFAULT WHIP DRINKS FOR MERGE
replace name=itrim(subinstr(name,"WHIP"," ",1)) if defaultwhip==1


save ../data/working/mostdrinks, replace

*create skinny file for iced drinks
keep if word(name,1)=="SKINNY"

* Iced drinks have 60% less volume from ice
replace name = "ICED "+name
replace cal1=cal1*.6 if defaultwhip==0
replace cal2=cal2*.6 if defaultwhip==0
replace cal3=cal3*.6 if defaultwhip==0
replace cal4=cal4*.6 if defaultwhip==0
replace cal1=(cal1-110)*.6+110 if defaultwhip==1
replace cal2=(cal2-110)*.6+110 if defaultwhip==1
replace cal3=(cal3-110)*.6+110 if defaultwhip==1
replace cal4=(cal4-110)*.6+110 if defaultwhip==1


*iced venti drinks 24 oz not 20 oz
replace cal1=cal1*24/20 if strpos(name,"VENTI")~=0
replace cal2=cal2*24/20 if strpos(name,"VENTI")~=0
replace cal3=cal3*24/20 if strpos(name,"VENTI")~=0
replace cal4=cal4*24/20 if strpos(name,"VENTI")~=0



append using ../data/working/mostdrinks

*can change default milk type here
*default order: twoperc,nonfat,whole,soy
ge cal=cal2 
replace cal=cal3 if cal==.
replace cal=cal1 if cal==.
replace cal=cal4 if cal==.

keep name cal*

ge type=1

sort name
drop if name==name[_n-1]



save ../data/working/drinkcalories, replace


