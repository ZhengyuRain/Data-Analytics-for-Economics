
* explvar.do

clear

*do zipbyzone.do
*do demog_aff.do
*do demog_sba.do
*do busstats.do
*do weather.do
 
* demog_aff has data only for relevent zips

use ../data/working/demog_aff

sort zip
merge zip using ../data/working/demog_sba
tab _merge
*keep if _merge==3
drop _merge

sort zip
merge zip using ../data/working/busstats
tab _merge
*hopefully all 3s
drop _merge

sort zip
merge zip using ../data/working/zipbyzone
tab _merge
*hopefully all 3s
drop _merge


sort zip
save ../data/working/expl_vartemp, replace

************ ZIPS in Transactions ************
clear
use ../data/working/storeinfo

keep zip store
sort zip

merge zip using ../data/working/zips_intxs
tab _merge
keep if _merge==3
drop _merge

sort zip
merge zip using ../data/working/expl_vartemp
tab _merge
keep if _merge~=2
drop _merge

ge age2045=age20242007+age25442007
ge collegedegree=(pop25m*(pop25m_AssocDeg+pop25m_BachDeg+pop25m_MastDeg+pop25m_ProfDeg+pop25m_DocDeg)+pop25f*(pop25f_AssocDeg+pop25f_BachDeg+pop25f_MastDeg+pop25f_ProfDeg+pop25f_DocDeg))/(pop25m+pop25f)
ge rest_perperson=n_rest/pop2007
ge chainrest_perperson=n_chain/pop2007


sort store

save ../data/working/explvar, replace

* Weather saved separately, sorted by zone


