
* demog_aff.do

clear
insheet using ../data/americanfactfinder/sbc_aff_demog1.txt, delimiter("|")



ge zip=real(v2)
drop if zip==.

* number of workers 16 and up
rename v5 workers
label var workers "Number of Workers"

ge workers_car = v6/workers
ge workers_caralone = v7/workers
ge workers_carpool = v8/workers
ge workers_pubtransit = v9/workers
ge workers_walk = v18/workers
ge workers_home = v20/workers

label var workers_car "Work by Car"
label var workers_caralone "Work by Car Alone"
label var workers_carpool "Work by Carpool"
label var workers_pubtransit "Work by Public Transit"
label var workers_walk "Work by Walking"
label var workers_home "Work at Home"

* travel time for those who don't work at home
ge workers_less15min = (v23+v24+v25)/workers
ge workers_15_29min = (v26+v27+v28)/workers
ge workers_30_44min = (v29+v30+v31)/workers
ge workers_45_59min = v32/workers
ge workers_60_89min = v33/workers
ge workers_more90min = v34/workers

label var workers_less15min "Travel Time < 15 min"
label var workers_15_29min "Travel Time 15-29 min"
label var workers_30_44min "Travel Time 30-44 min"
label var workers_45_59min "Travel Time 45-59 min"
label var workers_60_89min "Travel Time 60-89 min"
label var workers_more90min "Travel Time > 90 min"

drop workers_car workers

* pop over 25
rename v59 pop25
label var pop25 "Population over 25"

drop pop25

*male
rename v60 pop25m
ge pop25m_noschool = v61/pop25m
ge pop25m_noHS = (v62+v63+v64)/pop25m
ge pop25m_someHS=(v65+v66+v67+v68)/pop25m
ge pop25m_HSdip=v69/pop25m
ge pop25m_someC=(v70+v71)/pop25m
ge pop25m_AssocDeg=v72/pop25m
ge pop25m_BachDeg=v73/pop25m
ge pop25m_MastDeg=v74/pop25m
ge pop25m_ProfDeg=v75/pop25m
ge pop25m_DocDeg=v76/pop25m

label var pop25m "Male Pop over 25"
label var pop25m_noschool "Male Pop over 25 no School"
label var pop25m_noHS "Male Pop over 25 no HS"
label var pop25m_someHS "Male Pop over 25 some HS"
label var pop25m_HSdip "Male Pop over 25 HS diploma"
label var pop25m_someC "Male Pop over 25 some College"
label var pop25m_AssocDeg "Male Pop over 25 Associate Deg"
label var pop25m_BachDeg "Male Pop over 25 Bachelor Deg"
label var pop25m_MastDeg "Male Pop over 25 Masters Deg"
label var pop25m_ProfDeg "Male Pop over 25 Professional Deg"
label var pop25m_DocDeg "Male Pop over 25 Doctoral Deg"



*female
rename v77 pop25f
ge pop25f_noschool = v78/pop25f
ge pop25f_noHS = (v79+v80+v81)/pop25f
ge pop25f_someHS=(v82+v83+v84+v85)/pop25f
ge pop25f_HSdip=v86/pop25f
ge pop25f_someC=(v87+v88)/pop25f
ge pop25f_AssocDeg=v89/pop25f
ge pop25f_BachDeg=v90/pop25f
ge pop25f_MastDeg=v91/pop25f
ge pop25f_ProfDeg=v92/pop25f
ge pop25f_DocDeg=v93/pop25f

label var pop25f "Female Pop over 25"
label var pop25f_noschool "Female Pop over 25 no School"
label var pop25f_noHS "Female Pop over 25 no HS"
label var pop25f_someHS "Female Pop over 25 some HS"
label var pop25f_HSdip "Female Pop over 25 HS diploma"
label var pop25f_someC "Female Pop over 25 some College"
label var pop25f_AssocDeg "Female Pop over 25 Associate Deg"
label var pop25f_BachDeg "Female Pop over 25 Bachelor Deg"
label var pop25f_MastDeg "Female Pop over 25 Masters Deg"
label var pop25f_ProfDeg "Female Pop over 25 Professional Deg"
label var pop25f_DocDeg "Female Pop over 25 Doctoral Deg"



* male pop over 18 under 64
rename v96 pop18_64m
ge pop18_64m_armedforces = v97/pop18_64m
ge pop18_64m_veteran = v99/pop18_64m

label var pop18_64m "Male Pop 18-64"
label var pop18_64m_armedforces "Male Pop 18-64 in Armed Forces"
label var pop18_64m_veteran "Male Pop 18-64 Veterans"

drop pop18_64m

* male pop 65 or older
rename v101 pop65m
ge pop65m_armedforces = v102/pop65m
ge pop65m_veteran = v104/pop65m

label var pop65m "Male Pop > 65"
label var pop65m_armedforces "Male Pop > 65 in Armed Forces"
label var pop65m_veteran "Male Pop > 65 Veterans"

drop pop65m

* female pop over 18 under 64
rename v107 pop18_64f
ge pop18_64f_armedforces = v108/pop18_64f
ge pop18_64f_veteran = v110/pop18_64f

label var pop18_64f "Female Pop 18-64"
label var pop18_64f_armedforces "Female Pop 18-64 in Armed Forces"
label var pop18_64f_veteran "Female Pop 18-64 Veterans"

drop pop18_64f

* female pop 65 or older
rename v112 pop65f
ge pop65f_armedforces = v113/pop65f
ge pop65f_veteran = v115 /pop65f

label var pop65f "Female Pop > 65"
label var pop65f_armedforces "Female Pop > 65 in Armed Forces"
label var pop65f_veteran "Female Pop > 65 Veterans"

drop pop65f

* male civilian pop over 16 in workforce
ge pop16m=v121+v124
ge pop16m_workforce = v121/pop16m
ge pop16m_unemployed = v123/pop16m_workforce
ge pop16m_notinworkforce = v124/pop16m

label var pop16m_workforce "Male Pop over 16 in Workforce"
label var pop16m_unemployed "Male Pop over 16 Unemployed"
label var pop16m_notinworkforce "Male Pop over 16 not in Workforce"
label var pop16m "Male Pop over 16"

drop pop16m

* female civilian pop over 16 in workforce
ge pop16f=v128+v131
ge pop16f_workforce = v128/pop16f
ge pop16f_unemployed = v130/pop16f_workforce
ge pop16f_notinworkforce = v131/pop16f

label var pop16f_workforce "Female Pop over 16 in Workforce"
label var pop16f_unemployed "Female Pop over 16 Unemployed"
label var pop16f_notinworkforce "Female Pop over 16 not in Workforce"
label var pop16f "Female Pop over 16"

* civilian pop over 16
rename v132 pop16

drop pop16

* NOTE: Also have employment data by industry, sex

drop v*

sort zip
merge zip using ../data/working/zipbyzone
tab _merge
keep if _merge==3
drop _merge

sort zip

save ../data/working/demog_aff, replace


