
*demog_sba

clear
insheet using ../data/sourcebookamerica/demog.txt

rename zipcode zip

keep zip pop2007 whitepop2007 blackpop2007 asianpop2007 hisppop2007 age* males2007 females2007 avghhsize2007 medhhinc2007 
* can also keep house and car ownership data, emplyment by profession  


label var pop2007 "Population"
label var whitepop2007 "White"
label var blackpop2007 "Black"
label var asianpop2007 "Asian"
label var hisppop2007 "Hispanic"

label var age042007 "Age < 4"
label var age592007 "Age 5-9"
label var age10142007 "Age 10-14"
label var age15192007 "Age 15-19"
label var age20242007 "Age 20-24"
label var age25442007 "Age 25-44"
label var age45642007 "Age 45-64"
label var age65842007 "Age 65-84"
label var age852007 "Age > 85"
label var age182007 "Age > 18"

label var males2007 "Male"
label var females2007 "Female"
label var avghhsize2007 "Average Household Size"
label var medhhinc2007 "Median Household Income"

sort zip

save ../data/working/demog_sba, replace






