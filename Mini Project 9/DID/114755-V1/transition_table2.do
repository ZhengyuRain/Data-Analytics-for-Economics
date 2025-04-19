* generate a table of "transitions" for the cardholders
clear
pro drop _all
set mem 2g
set more off

global bigdatadir /data/gsb/SBC
global datadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/data
global logdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/logs
global tmpdir /tmp

* set required number of transactions pre and post
global ntx = 13
 
* read in the cardholder data
use $bigdatadir/CardholderData/cardholder_data_nyc

* drop bookkeeping transactions
drop if prod_num > 999000000

* drop if negative price
drop if nds_amt<0

* drop if zero quantity
drop if nds_qty==0

* drop if large quantities
sort id txdate txid
egen hiq = sum(nds_qty>4), by(id txdate txid)
keep if hiq==0
drop hiq

* drop if no food or beverage items
egen anycals = sum((type==1)|(type==2)|(type==3)), by(id txdate txid)
drop if anycals==0

* dummies for cities
gen ny = (zone==16)
gen bos = (zone==15)
gen phl = (zone==51)

* limit to customers with enough pre and post transactions
gen period = (txdate>=d(01apr2008))
egen npre = sum(ny*(type==1)*(period==0)), by(id)
egen npost = sum(ny*(type==1)*(period==1)), by(id)
keep if npre>=$ntx
save $tmpdir/tmptr, replace

* first look at new yorkers
egen everny = max(ny), by(id)
keep if everny

* find favorite drink, pre and post
egen npurch = count(_n), by(id prod_num period)
gen tmp = -npurch
sort id period type tmp
qui by id period: gen tmp2 = prod_num*(_n==1)
egen prefav = max(tmp2*(period==0)), by(id)
egen postfav = max(tmp2*(period==1)), by(id)
drop tmp tmp2

* only need one observation per customer now
sort id
qui by id: keep if _n==1
keep id npre npost prefav postfav
save $tmpdir/tmp1, replace

* merge in size and calorie info
* need to get drink categories
* need to "look up" calories of postfav if it were same size as prefav
use $datadir/working/calories, clear
keep if zone==16
gen predrink = 1 if hotcoffee
replace predrink = 2 if hottea
replace predrink = 3 if latte
replace predrink = 4 if mocha
replace predrink = 5 if cappuccino
replace predrink = 6 if frap
replace predrink = 7 if fraplight
replace predrink = 8 if iced
replace predrink = 9 if predrink==. & regexm(item_description,"AMERICANO")
replace predrink = 10 if predrink==. & regexm(item_description,"MACCHIATO")
replace predrink = 11 if predrink==. & regexm(item_description,"MISTO")
replace predrink = 12 if predrink==. & regexm(item_description,"HOT.*CHOC")
replace predrink = 12 if predrink==. & regexm(item_description,"COCOA")
replace predrink = 6 if predrink==. & regexm(item_description,"FRAPP")
replace predrink = 7 if (predrink==6|predrink==.) & regexm(item_description,"FRAPP LT")
replace predrink = 2 if predrink==. & regexm(item_description,"CHAI TEA")
replace predrink = 8 if predrink==. & regexm(item_description,"ICE")
gen presize = 1 if short
replace presize = 2 if tall
replace presize = 3 if grande
replace presize = 4 if venti
la def drinks 1 "Brewed Coffee"
la def drinks 2 "Hot Tea", add
la def drinks 3 "Latte", add
la def drinks 4 "Mocha", add
la def drinks 5 "Cappuccino", add
la def drinks 6 "Frappuccino", add
la def drinks 7 "Frapp. Light", add
la def drinks 8 "Iced Coffees", add
la def drinks 9 "Americano", add
la def drinks 10 "Macchiato", add
la def drinks 11 "Misto", add
la def drinks 12 "Hot Cocoa", add
la val predrink drinks
la def sizes 1 "Short" 2 "Tall" 3 "Grande" 4 "Venti"
la val presize sizes
gen sfitem = substr(item_description,1,strpos(item_d,"SHORT")-1) if type==1 & presize==1
replace sfitem = substr(item_description,1,strpos(item_d,"TALL")-1) if type==1 & presize==2
replace sfitem = substr(item_description,1,strpos(item_d,"TL")-1) if type==1 & presize==2 & sfitem==""
replace sfitem = substr(item_description,1,strpos(item_d,"GRANDE")-1) if type==1 & presize==3 
replace sfitem = substr(item_description,1,strpos(item_d,"VENTI")-1) if type==1 & presize==4
replace sfitem = substr(item_description,1,strpos(item_d,"VT")-1) if type==1 & presize==4 & sfitem==""
replace sfitem = "COFFEE" if sfitem=="COFFEE DECAF"
replace sfitem = "COFFEE" if sfitem=="DRIP REFILL"
egen tmp1 = max(cal*(presize==1)), by(sfitem)
egen tmp2 = max(cal*(presize==2)), by(sfitem)
egen tmp3 = max(cal*(presize==3)), by(sfitem)
egen tmp4 = max(cal*(presize==4)), by(sfitem)
gen precal = tmp3 if tmp3>0
replace precal = tmp2*(16/12) if precal==. & tmp2>0
replace precal = tmp1*(16/8) if precal==. & tmp1>0
gen tmp5 = 24 if predrink==8
replace tmp5 = 20 if tmp5==.
replace precal = tmp4*(16/tmp5) if precal==. & tmp4>0
replace precal = 0 if precal==. & predrink==2
rename prod_num prefav
gen predesc = sfitem
keep prefav precal presize predrink predesc
sort prefav
save $tmpdir/tmppre, replace

use $datadir/working/calories, clear
keep if zone==16
gen postdrink = 1 if hotcoffee
replace postdrink = 2 if hottea
replace postdrink = 3 if latte
replace postdrink = 4 if mocha
replace postdrink = 5 if cappuccino
replace postdrink = 6 if frap
replace postdrink = 7 if fraplight
replace postdrink = 8 if iced
replace postdrink = 9 if postdrink==. & regexm(item_description,"AMERICANO")
replace postdrink = 10 if postdrink==. & regexm(item_description,"MACCHIATO")
replace postdrink = 11 if postdrink==. & regexm(item_description,"MISTO")
replace postdrink = 12 if postdrink==. & regexm(item_description,"HOT.*CHOC")
replace postdrink = 12 if postdrink==. & regexm(item_description,"COCOA")
replace postdrink = 6 if postdrink==. & regexm(item_description,"FRAPP")
replace postdrink = 7 if (postdrink==6|postdrink==.) & regexm(item_description,"FRAPP LT")
replace postdrink = 2 if postdrink==. & regexm(item_description,"CHAI TEA")
replace postdrink = 8 if postdrink==. & regexm(item_description,"ICE")
gen postsize = 1 if short
replace postsize = 2 if tall
replace postsize = 3 if grande
replace postsize = 4 if venti
la def drinks 1 "Brewed Coffee"
la def drinks 2 "Hot Tea", add
la def drinks 3 "Latte", add
la def drinks 4 "Mocha", add
la def drinks 5 "Cappuccino", add
la def drinks 6 "Frappuccino", add
la def drinks 7 "Frapp. Light", add
la def drinks 8 "Iced Coffees", add
la def drinks 9 "Americano", add
la def drinks 10 "Macchiato", add
la def drinks 11 "Misto", add
la def drinks 12 "Hot Cocoa", add
la val postdrink drinks
la def sizes 1 "Short" 2 "Tall" 3 "Grande" 4 "Venti"
la val postsize sizes
gen sfitem = substr(item_description,1,strpos(item_d,"SHORT")-1) if type==1 & postsize==1
replace sfitem = substr(item_description,1,strpos(item_d,"TALL")-1) if type==1 & postsize==2
replace sfitem = substr(item_description,1,strpos(item_d,"TL")-1) if type==1 & postsize==2 & sfitem==""
replace sfitem = substr(item_description,1,strpos(item_d,"GRANDE")-1) if type==1 & postsize==3 
replace sfitem = substr(item_description,1,strpos(item_d,"VENTI")-1) if type==1 & postsize==4
replace sfitem = substr(item_description,1,strpos(item_d,"VT")-1) if type==1 & postsize==4 & sfitem==""
replace sfitem = "COFFEE" if sfitem=="COFFEE DECAF"
replace sfitem = "COFFEE" if sfitem=="DRIP REFILL"
egen tmp1 = max(cal*(postsize==1)), by(sfitem)
egen tmp2 = max(cal*(postsize==2)), by(sfitem)
egen tmp3 = max(cal*(postsize==3)), by(sfitem)
egen tmp4 = max(cal*(postsize==4)), by(sfitem)
gen postcal = tmp3 if tmp3>0
replace postcal = tmp2*(16/12) if postcal==. & tmp2>0
replace postcal = tmp1*(16/8) if postcal==. & tmp1>0
gen tmp5 = 24 if postdrink==8
replace tmp5 = 20 if tmp5==.
replace postcal = tmp4*(16/tmp5) if postcal==. & tmp4>0
replace postcal = 0 if postcal==. & postdrink==2
rename prod_num postfav
gen postdesc = sfitem
keep postfav postcal postsize postdrink postdesc
sort postfav
save $tmpdir/tmppost, replace

use $tmpdir/tmp1, clear
sort prefav
merge prefav using $tmpdir/tmppre, update
keep if _merge==3
drop _merge

sort postfav
merge postfav using $tmpdir/tmppost, update
keep if _merge==3
drop _merge

* make the table
gen newsize = 1 if postsize<presize
replace newsize = 2 if postsize==presize
replace newsize = 3 if postsize>presize
la def newsizes 1 "smaller size" 2 "same size" 3 "larger size"
la val newsize newsizes
gen newdrink = 1 if postcal<precal & postfav~=prefav
replace newdrink = 2 if postdesc==predesc
replace newdrink = 3 if postcal>precal & postfav~=prefav
replace newdrink = 4 if postcal==precal & postdesc~=predesc
la def newdrinks 1 "lower-calorie drink" 2 "same drink" 3 "higher-calorie drink" 4 "diff. drink, same cals"
la val newdrink newdrinks

log using $logdir/transition_table2.log, text replace

* NYC
tab newdrink newsize, cell
tab newdrink newsize, nofreq cell

tab newdrink newsize if newdrink<4, cell
tab newdrink newsize if newdrink<4, nofreq cell

tab newdrink newsize if newdrink<4 & npre>=30 & npost>=30, cell

log off

gen c = 0
save $tmpdir/tmp9, replace


* now do it for Boston and Philadelphia
use $tmpdir/tmptr, clear
gen bp = bos|phl
egen everbp = max(bp), by(id)
keep if everbp

* find favorite drink, pre and post
egen npurch = count(_n), by(id prod_num period)
gen tmp = -npurch
sort id period type tmp
qui by id period: gen tmp2 = prod_num*(_n==1)
egen prefav = max(tmp2*(period==0)), by(id)
egen postfav = max(tmp2*(period==1)), by(id)
drop tmp tmp2

* only need one observation per customer now
sort id
qui by id: keep if _n==1
keep id npre npost prefav postfav
save $tmpdir/tmp1, replace

* merge in size and calorie info
* need to get drink categories
* need to "look up" calories of postfav if it were same size as prefav
use $datadir/working/calories, clear
keep if zone==15|zone==51
gen predrink = 1 if hotcoffee
replace predrink = 2 if hottea
replace predrink = 3 if latte
replace predrink = 4 if mocha
replace predrink = 5 if cappuccino
replace predrink = 6 if frap
replace predrink = 7 if fraplight
replace predrink = 8 if iced
replace predrink = 9 if predrink==. & regexm(item_description,"AMERICANO")
replace predrink = 10 if predrink==. & regexm(item_description,"MACCHIATO")
replace predrink = 11 if predrink==. & regexm(item_description,"MISTO")
replace predrink = 12 if predrink==. & regexm(item_description,"HOT.*CHOC")
replace predrink = 12 if predrink==. & regexm(item_description,"COCOA")
replace predrink = 6 if predrink==. & regexm(item_description,"FRAPP")
replace predrink = 7 if (predrink==6|predrink==.) & regexm(item_description,"FRAPP LT")
replace predrink = 2 if predrink==. & regexm(item_description,"CHAI TEA")
replace predrink = 8 if predrink==. & regexm(item_description,"ICE")
gen presize = 1 if short
replace presize = 2 if tall
replace presize = 3 if grande
replace presize = 4 if venti
la def drinks 1 "Brewed Coffee"
la def drinks 2 "Hot Tea", add
la def drinks 3 "Latte", add
la def drinks 4 "Mocha", add
la def drinks 5 "Cappuccino", add
la def drinks 6 "Frappuccino", add
la def drinks 7 "Frapp. Light", add
la def drinks 8 "Iced Coffees", add
la def drinks 9 "Americano", add
la def drinks 10 "Macchiato", add
la def drinks 11 "Misto", add
la def drinks 12 "Hot Cocoa", add
la val predrink drinks
la def sizes 1 "Short" 2 "Tall" 3 "Grande" 4 "Venti"
la val presize sizes
gen sfitem = substr(item_description,1,strpos(item_d,"SHORT")-1) if type==1 & presize==1
replace sfitem = substr(item_description,1,strpos(item_d,"TALL")-1) if type==1 & presize==2
replace sfitem = substr(item_description,1,strpos(item_d,"TL")-1) if type==1 & presize==2 & sfitem==""
replace sfitem = substr(item_description,1,strpos(item_d,"GRANDE")-1) if type==1 & presize==3 
replace sfitem = substr(item_description,1,strpos(item_d,"VENTI")-1) if type==1 & presize==4
replace sfitem = substr(item_description,1,strpos(item_d,"VT")-1) if type==1 & presize==4 & sfitem==""
replace sfitem = "COFFEE" if sfitem=="COFFEE DECAF"
replace sfitem = "COFFEE" if sfitem=="DRIP REFILL"
egen tmp1 = max(cal*(presize==1)), by(sfitem)
egen tmp2 = max(cal*(presize==2)), by(sfitem)
egen tmp3 = max(cal*(presize==3)), by(sfitem)
egen tmp4 = max(cal*(presize==4)), by(sfitem)
gen precal = tmp3 if tmp3>0
replace precal = tmp2*(16/12) if precal==. & tmp2>0
replace precal = tmp1*(16/8) if precal==. & tmp1>0
gen tmp5 = 24 if predrink==8
replace tmp5 = 20 if tmp5==.
replace precal = tmp4*(16/tmp5) if precal==. & tmp4>0
replace precal = 0 if precal==. & predrink==2
rename prod_num prefav
gen predesc = sfitem
keep prefav precal presize predrink predesc
sort prefav
save $tmpdir/tmppre, replace

use $datadir/working/calories, clear
keep if zone==15|zone==51
gen postdrink = 1 if hotcoffee
replace postdrink = 2 if hottea
replace postdrink = 3 if latte
replace postdrink = 4 if mocha
replace postdrink = 5 if cappuccino
replace postdrink = 6 if frap
replace postdrink = 7 if fraplight
replace postdrink = 8 if iced
replace postdrink = 9 if postdrink==. & regexm(item_description,"AMERICANO")
replace postdrink = 10 if postdrink==. & regexm(item_description,"MACCHIATO")
replace postdrink = 11 if postdrink==. & regexm(item_description,"MISTO")
replace postdrink = 12 if postdrink==. & regexm(item_description,"HOT.*CHOC")
replace postdrink = 12 if postdrink==. & regexm(item_description,"COCOA")
replace postdrink = 6 if postdrink==. & regexm(item_description,"FRAPP")
replace postdrink = 7 if (postdrink==6|postdrink==.) & regexm(item_description,"FRAPP LT")
replace postdrink = 2 if postdrink==. & regexm(item_description,"CHAI TEA")
replace postdrink = 8 if postdrink==. & regexm(item_description,"ICE")
gen postsize = 1 if short
replace postsize = 2 if tall
replace postsize = 3 if grande
replace postsize = 4 if venti
la def drinks 1 "Brewed Coffee"
la def drinks 2 "Hot Tea", add
la def drinks 3 "Latte", add
la def drinks 4 "Mocha", add
la def drinks 5 "Cappuccino", add
la def drinks 6 "Frappuccino", add
la def drinks 7 "Frapp. Light", add
la def drinks 8 "Iced Coffees", add
la def drinks 9 "Americano", add
la def drinks 10 "Macchiato", add
la def drinks 11 "Misto", add
la def drinks 12 "Hot Cocoa", add
la val postdrink drinks
la def sizes 1 "Short" 2 "Tall" 3 "Grande" 4 "Venti"
la val postsize sizes
gen sfitem = substr(item_description,1,strpos(item_d,"SHORT")-1) if type==1 & postsize==1
replace sfitem = substr(item_description,1,strpos(item_d,"TALL")-1) if type==1 & postsize==2
replace sfitem = substr(item_description,1,strpos(item_d,"TL")-1) if type==1 & postsize==2 & sfitem==""
replace sfitem = substr(item_description,1,strpos(item_d,"GRANDE")-1) if type==1 & postsize==3 
replace sfitem = substr(item_description,1,strpos(item_d,"VENTI")-1) if type==1 & postsize==4
replace sfitem = substr(item_description,1,strpos(item_d,"VT")-1) if type==1 & postsize==4 & sfitem==""
replace sfitem = "COFFEE" if sfitem=="COFFEE DECAF"
replace sfitem = "COFFEE" if sfitem=="DRIP REFILL"
egen tmp1 = max(cal*(postsize==1)), by(sfitem)
egen tmp2 = max(cal*(postsize==2)), by(sfitem)
egen tmp3 = max(cal*(postsize==3)), by(sfitem)
egen tmp4 = max(cal*(postsize==4)), by(sfitem)
gen postcal = tmp3 if tmp3>0
replace postcal = tmp2*(16/12) if postcal==. & tmp2>0
replace postcal = tmp1*(16/8) if postcal==. & tmp1>0
gen tmp5 = 24 if postdrink==8
replace tmp5 = 20 if tmp5==.
replace postcal = tmp4*(16/tmp5) if postcal==. & tmp4>0
replace postcal = 0 if postcal==. & postdrink==2
rename prod_num postfav
gen postdesc = sfitem
keep postfav postcal postsize postdrink postdesc
sort postfav
save $tmpdir/tmppost, replace

use $tmpdir/tmp1, clear
sort prefav
merge prefav using $tmpdir/tmppre, update
keep if _merge==3
drop _merge

sort postfav
merge postfav using $tmpdir/tmppost, update
keep if _merge==3
drop _merge

* make the table
gen newsize = 1 if postsize<presize
replace newsize = 2 if postsize==presize
replace newsize = 3 if postsize>presize
la def newsizes 1 "smaller size" 2 "same size" 3 "larger size"
la val newsize newsizes
gen newdrink = 1 if postcal<precal & postfav~=prefav
replace newdrink = 2 if postdesc==predesc
replace newdrink = 3 if postcal>precal & postfav~=prefav
replace newdrink = 4 if postcal==precal & postdesc~=predesc
la def newdrinks 1 "lower-calorie drink" 2 "same drink" 3 "higher-calorie drink" 4 "diff. drink, same cals"
la val newdrink newdrinks

log on

* BOS/PHL
tab newdrink newsize, cell
tab newdrink newsize, nofreq cell

tab newdrink newsize if newdrink<4, cell
tab newdrink newsize if newdrink<4, nofreq cell

tab newdrink newsize if newdrink<4 & npre>=30 & npost>=30, cell

log close

gen c = 1
append using $tmpdir/tmp9

gen cat = string(newdrink) + " / " + string(newsize) if newdrink<4
tab cat c if newdrink<4, chi2


