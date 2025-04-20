
* sdd.do

* Setup starbucks dairy data

global statadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/stata
cd $statadir
global datadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/data
global logdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/logs
global tmpdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/tmp
global graphdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/graphs
global bigdatadir /data/gsb/SBC

clear
set more off
set mem 15g

clear
insheet using $datadir/sb/sdd_bst.txt
ge zone = 15
save $datadir/working/sdd_bst, replace

clear
insheet using $datadir/sb/sdd_phl.txt
ge zone = 51
save $datadir/working/sdd_phl, replace

clear
insheet using $datadir/sb/sdd_nyc1.txt
ge zone = 16
save $datadir/working/sdd_nyc1, replace

clear
insheet using $datadir/sb/sdd_nyc2.txt
ge zone = 16
save $datadir/working/sdd_nyc2, replace

clear
insheet using $datadir/sb/sdd_nyc3.txt
ge zone = 16
save $datadir/working/sdd_nyc3, replace

clear
use $datadir/working/sdd_bst
append using $datadir/working/sdd_phl
append using $datadir/working/sdd_nyc1
append using $datadir/working/sdd_nyc2
append using $datadir/working/sdd_nyc3


*ge txdat=date(invoicedate,"dmy",2008)
ge txdat= date(invoicedate,"DM20Y")
ge txyear=year(txdat)
ge txmonth=month(txdat)
ge txweek=week(txdat)
ge txday=day(txdat)
ge txdow=dow(txdat)

drop if txyear==2007
drop if txdat==.

* Balance Panel
drop if txmonth==1 & txday<=5
drop if txmonth==8 & txday==31

* change week variable to count full weeks beginning on Sunday:
* 2008 begins on a Tuesday
replace txweek=txweek+1 if txdow==0
replace txweek=txweek+1 if txdow==1
replace txweek=txweek-1

replace txweek=txweek-1 if txdow==0


rename storenumber store
label var store "store"

rename skunumber sku

label define skulabel 360464 "two percent" 118611 "non fat" 118609 "whole" 
label values sku skulabel
label var sku "sku"

ge milktype=0
replace milktype=1 if sku==118609 
replace milktype=2 if sku==360464 
replace milktype=3 if sku==118611 
* save 4 for soy
label define milktypelabel 1 "whole" 2 "two percent" 3 "non fat"  
label values milktype milktypelabel 
label var milktype "milk type"

count if milktype==0 & store~=.
* SHOULD BE ZERO
drop if milktype==0

*keep zone tx* store milktype quantity

rename quantity quantitytemp
sort store txmonth txday milktype

bysort store txmonth txday milktype: egen quantity=total(quantitytemp)
drop quantitytemp
drop if store==store[_n-1] & txmonth==txmonth[_n-1] & txday==txday[_n-1] & milktype==milktype[_n-1]
sort store txmonth txday milktype

save $datadir/working/sdd, replace

