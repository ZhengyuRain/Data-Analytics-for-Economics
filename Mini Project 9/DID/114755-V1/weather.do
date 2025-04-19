
*weather.do

clear
infix stn 1-6 wban 8-12 str yearmoda 14-23 temp 27-30 visib 69-73 wdsp 79-83 maxtemp 104-108 mintemp 112-116 precip 119-123 using "C:\Documents and Settings\Bryan Bollinger\My Documents\research\sbc\data\weather\725033-94728-2008.op"
save ../data/working/weather_nyc_2008, replace
clear
infix stn 1-6 wban 8-12 str yearmoda 15-22 temp 27-30 visib 69-73 wdsp 79-83 maxtemp 104-108 mintemp 112-116 precip 119-123 using "C:\Documents and Settings\Bryan Bollinger\My Documents\research\sbc\data\weather\725033-94728-2009.op"
save ../data/working/weather_nyc_2009, replace
clear
infix stn 1-6 wban 8-12 str yearmoda 15-22 temp 27-30 visib 69-73 wdsp 79-83 maxtemp 104-108 mintemp 112-116 precip 119-123 using "C:\Documents and Settings\Bryan Bollinger\My Documents\research\sbc\data\weather\997286-99999-2008.op"
save ../data/working/weather_phi_2008, replace
clear
infix stn 1-6 wban 8-12 str yearmoda 15-22 temp 27-30 visib 69-73 wdsp 79-83 maxtemp 104-108 mintemp 112-116 precip 119-123 using "C:\Documents and Settings\Bryan Bollinger\My Documents\research\sbc\data\weather\997286-99999-2009.op"
save ../data/working/weather_phi_2009, replace
clear
infix stn 1-6 wban 8-12 str yearmoda 15-22 temp 27-30 visib 69-73 wdsp 79-83 maxtemp 104-108 mintemp 112-116 precip 119-123 using "C:\Documents and Settings\Bryan Bollinger\My Documents\research\sbc\data\weather\725090-14739-2008.op"
save ../data/working/weather_bos_2008, replace
clear
infix stn 1-6 wban 8-12 str yearmoda 15-22 temp 27-30 visib 69-73 wdsp 79-83 maxtemp 104-108 mintemp 112-116 precip 119-123 using "C:\Documents and Settings\Bryan Bollinger\My Documents\research\sbc\data\weather\725090-14739-2009.op"
save ../data/working/weather_bos_2009, replace

clear
infix stn 1-6 wban 8-12 str yearmoda 15-22 temp 27-30 visib 69-73 wdsp 79-83 maxtemp 104-108 mintemp 112-116 precip 119-123 using "C:\Documents and Settings\Bryan Bollinger\My Documents\research\sbc\data\weather\994014-99999-2008.op"
save ../data/working/weather_sea_2008, replace
clear
infix stn 1-6 wban 8-12 str yearmoda 15-22 temp 27-30 visib 69-73 wdsp 79-83 maxtemp 104-108 mintemp 112-116 precip 119-123 using "C:\Documents and Settings\Bryan Bollinger\My Documents\research\sbc\data\weather\994014-99999-2009.op"
save ../data/working/weather_sea_2009, replace
clear
infix stn 1-6 wban 8-12 str yearmoda 15-22 temp 27-30 visib 69-73 wdsp 79-83 maxtemp 104-108 mintemp 112-116 precip 119-123 using "C:\Documents and Settings\Bryan Bollinger\My Documents\research\sbc\data\weather\994016-99999-2008.op"
save ../data/working/weather_sfr_2008, replace
clear
infix stn 1-6 wban 8-12 str yearmoda 15-22 temp 27-30 visib 69-73 wdsp 79-83 maxtemp 104-108 mintemp 112-116 precip 119-123 using "C:\Documents and Settings\Bryan Bollinger\My Documents\research\sbc\data\weather\994016-99999-2009.op"
save ../data/working/weather_sfr_2009, replace
clear
infix stn 1-6 wban 8-12 str yearmoda 15-22 temp 27-30 visib 69-73 wdsp 79-83 maxtemp 104-108 mintemp 112-116 precip 119-123 using "C:\Documents and Settings\Bryan Bollinger\My Documents\research\sbc\data\weather\726980-24229-2008.op"
save ../data/working/weather_por_2008, replace
clear
infix stn 1-6 wban 8-12 str yearmoda 15-22 temp 27-30 visib 69-73 wdsp 79-83 maxtemp 104-108 mintemp 112-116 precip 119-123 using "C:\Documents and Settings\Bryan Bollinger\My Documents\research\sbc\data\weather\726980-24229-2009.op"
save ../data/working/weather_por_2009, replace

clear
use ../data/working/weather_nyc_2008
append using ../data/working/weather_nyc_2009
append using ../data/working/weather_phi_2008
append using ../data/working/weather_phi_2009
append using ../data/working/weather_bos_2008
append using ../data/working/weather_bos_2009
append using ../data/working/weather_sea_2008
append using ../data/working/weather_sea_2009
append using ../data/working/weather_sfr_2008
append using ../data/working/weather_sfr_2009
append using ../data/working/weather_por_2008
append using ../data/working/weather_por_2009


keep stn temp visib wdsp maxtemp mintemp precip yearmoda


replace precip=. if precip==999.9
replace wdsp=. if wdsp==999.9

label var temp "Mean Temperature (F)"
label var maxtemp "Max Temperature (F)"
label var mintemp "Min Temperature (F)"
label var visib "Visibility (miles)"
label var wdsp "Mean Wind Speed (knots)"
label var precip "Precipitation (in) "

ge zone =.
replace zone=5 if stn==994016
replace zone=15 if stn==725090
replace zone=16 if stn==725033
replace zone=51 if stn==997286
replace zone=11 if stn==726980
replace zone=24 if stn==994014

save ../data/working/weathertemp, replace

* Generate JC weather to be same as NY
keep if zone==16
replace zone=64

append using ../data/working/weathertemp

ge datestring=yearmoda
ge dat=mdy(real(substr(datestring,5,2)),real(substr(datestring,7,2)),real(substr(datestring,1,4))) 

ge txyear=year(dat)
ge txmonth=month(dat)
ge txday=day(dat)

keep zone dat txyear txmonth txday temp maxtemp mintemp visib wdsp precip

sort zone txyear txmonth txday

save ../data/working/weather, replace





