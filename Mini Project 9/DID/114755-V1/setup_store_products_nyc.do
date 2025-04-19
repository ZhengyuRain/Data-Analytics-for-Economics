
setup_store_products_nyc

do var_jer


log using $logdir/$currentcity/setup_store_products_nyc, text replace


clear
use $bigdatadir/working/jer/setup_sumstats1

sort store prod_num

bysort store prodnum: egen num_prod=total(nds_qty)

sort store sub

egen num_scones = total((sub_dept_cd==10)*nds_qty)
egen num_muffins = total((sub_dept_cd==20)*nds_qty)
egen num_bagels = total((sub_dept_cd==30)*nds_qty)
egen num_sweetrolls = total((sub_dept_cd==50)*nds_qty)
egen num_cakes = total((sub_dept_cd==60|sub_dept_cd==70)*nds_qty)
egen num_croissants = total((sub_dept_cd==80)*nds_qty)

egen num_short = total(short*nds_qty)
egen num_tall = total(tall*nds_qty)
egen num_grande= total(grande*nds_qty)
egen num_venti= total(venti*nds_qty)
egen num_iced= total(iced*nds_qty)
egen num_mocha= total(mocha*nds_qty)
egen num_latte= total(latte*nds_qty)
egen num_cappuccino= total(cappuccino*nds_qty)
egen num_frapuccino= total(frap*nds_qty+fraplight*nds_qty)


* Fraction of each item type in ny

ge share_scones=num_scones/num_prod
ge share_muffins=num_muffins/num_prod
ge share_bagels=num_bagels/num_prod
ge share_sweetrolls=num_sweetrolls/num_prod
ge share_cakes=num_cakes/num_prod
ge share_croissants=num_croissants/num_prod

ge share_short=num_short/num_prod
ge share_tall=num_tall/num_prod
ge share_grande=num_grande/num_prod
ge share_venti=num_venti/num_prod
ge share_iced=num_iced/num_prod
ge share_mocha=num_mocha/num_prod
ge share_latte=num_latte/num_prod
ge share_cappuccino=num_cappuccino/num_prod
ge share_frapuccino=num_frapuccino/num_prod

* One observation per store-prodnum:

sort store prod_num
drop if store==store[_n-1] & prodnum==prodnum[_n-1]

bysort store prodnum: egen prodcount=count(prodnum)

bysort store : egen items_scones = total((sub_dept_cd==10)
bysort store : egen items_muffins = total((sub_dept_cd==20))
bysort store : egen items_bagels = total((sub_dept_cd==30))
bysort store : egen items_sweetrolls = total((sub_dept_cd==50))
bysort store : egen items_cakes = total((sub_dept_cd==60|sub_dept_cd==70))
bysort store : egen items_croissants = total((sub_dept_cd==80))

bysort store : egen items_short = total(short)
bysort store : egen items_tall = total(tall)
bysort store : egen items_grande= total(grande)
bysort store : egen items_venti= total(venti)
bysort store : egen items_iced= total(iced)
bysort store : egen items_mocha= total(mocha)
bysort store : egen items_latte= total(latte)
bysort store : egen items_cappuccino= total(cappuccino)
bysort store : egen items_frapuccino= total(frap*nds_qty+fraplight)

keep store share_* items_*

su share_* items_*


