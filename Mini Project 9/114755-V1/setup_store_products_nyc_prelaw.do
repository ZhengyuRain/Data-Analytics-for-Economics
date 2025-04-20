
*setup_store_products_nyc_prelaw

do var_nyc


log using $logdir/$currentcity/setup_store_products_nyc_prelaw, text replace


clear
use $bigdatadir/working/$currentcity/setup_sumstats1

*PRE-LAW ONLY
drop if after_nyc==1

sort prod_num
merge prod_num using $datadir/working/drinktypedummies
tab _merge
drop _merge



sort store prod_num

egen num_prod=total(nds_qty)

egen num_drinks=total(type==1)
egen num_snacks=total(type==2)

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
egen num_hotcoffee= total(hotcoffee*nds_qty)
egen num_hottea= total(hottea*nds_qty)
egen num_mocha= total(mocha*nds_qty)
egen num_latte= total(latte*nds_qty)
egen num_cappuccino= total(cappuccino*nds_qty)
egen num_frapuccino= total(frap*nds_qty+fraplight*nds_qty)


* Fraction of each item type in ny

ge share_drinks=num_drinks/num_prod
ge share_snacks=num_snacks/num_prod

ge share_scones=num_scones/num_snacks
ge share_muffins=num_muffins/num_snacks
ge share_bagels=num_bagels/num_snacks
ge share_sweetrolls=num_sweetrolls/num_snacks
ge share_cakes=num_cakes/num_snacks
ge share_croissants=num_croissants/num_snacks

ge share_short=num_short/num_drinks
ge share_tall=num_tall/num_drinks
ge share_grande=num_grande/num_drinks
ge share_venti=num_venti/num_drinks
ge share_iced=num_iced/num_drinks
ge share_hotcoffee=num_hotcoffee/num_drinks
ge share_hottea=num_hottea/num_drinks
ge share_mocha=num_mocha/num_drinks
ge share_latte=num_latte/num_drinks
ge share_cappuccino=num_cappuccino/num_drinks
ge share_frapuccino=num_frapuccino/num_drinks

* One observation per store-prodnum:

sort store prod_num
drop if store==store[_n-1] & prod_num==prod_num[_n-1]

bysort store prod_num: egen items_all=count(prod_num)

bysort store : egen items_scones = total(sub_dept_cd==10)
bysort store : egen items_muffins = total(sub_dept_cd==20)
bysort store : egen items_bagels = total(sub_dept_cd==30)
bysort store : egen items_sweetrolls = total(sub_dept_cd==50)
bysort store : egen items_cakes = total(sub_dept_cd==60|sub_dept_cd==70)
bysort store : egen items_croissants = total(sub_dept_cd==80)

bysort store : egen items_short = total(short)
bysort store : egen items_tall = total(tall)
bysort store : egen items_grande= total(grande)
bysort store : egen items_venti= total(venti)
bysort store : egen items_iced= total(iced)
bysort store : egen items_mocha= total(mocha)
bysort store : egen items_latte= total(latte)
bysort store : egen items_cappuccino= total(cappuccino)
bysort store : egen items_frapuccino= total(frap*nds_qty+fraplight)

*keep store share_* items_*

su share_* items_*

save $bigdatadir/working/$currentcity/setup_store_products_nyc_prelaw, replace

log close

