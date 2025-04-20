

*productfile_consumption.do

clear
insheet using ../data/sb/productfile.txt

replace item_description=" "+item_description+" "

drop if strpos(item_description," MUG "               )~=0
drop if strpos(item_description," CUP "               )~=0
drop if strpos(item_description," GLASS "             )~=0
drop if strpos(item_description," SAMPLER "           )~=0
drop if strpos(item_description," STACK "             )~=0
drop if strpos(item_description," GUM "               )~=0
drop if strpos(item_description," MINTS "             )~=0
drop if strpos(item_description," TUMBLER "           )~=0
drop if strpos(item_description," TMBLR "             )~=0
drop if strpos(item_description," TMBLER "            )~=0
drop if strpos(item_description," S/S "               )~=0
drop if strpos(item_description," HOL8 "              )~=0
drop if strpos(item_description," HOLO8 "             )~=0
drop if strpos(item_description," GAME "              )~=0
drop if strpos(item_description," TIN "               )~=0
drop if strpos(item_description," PLATE "             )~=0
drop if strpos(item_description," PLATES "            )~=0
drop if strpos(item_description," SNOWGLOBE "         )~=0
drop if strpos(item_description," GIFT "              )~=0
drop if strpos(item_description," MEDALLION "         )~=0
drop if strpos(item_description," CARD "              )~=0
drop if strpos(item_description," MACHINE "           )~=0
drop if strpos(item_description,"1/4LB"               )~=0
drop if strpos(item_description,"1/2LB"               )~=0
drop if strpos(item_description,"1LB"                 )~=0
drop if strpos(item_description," LB "                )~=0
drop if strpos(item_description," PAPER "             )~=0
drop if strpos(item_description," NP "                )~=0
drop if strpos(item_description," BEAKER "            )~=0
drop if strpos(item_description,"BX/"                 )~=0
drop if strpos(item_description,"/CS"                 )~=0
drop if strpos(item_description,"/IP"                 )~=0
drop if strpos(item_description,"SET/"                )~=0
drop if strpos(item_description," BOOK "              )~=0
drop if strpos(item_description," ACTIVITY "          )~=0
drop if strpos(item_description," THERMOMETER "       )~=0
drop if strpos(item_description," SAUCE "             )~=0
drop if strpos(item_description," NOTEPADS "          )~=0
drop if strpos(item_description," NOTEPAD "           )~=0
drop if strpos(item_description," SKETCH "            )~=0
drop if strpos(item_description," ARTIST "            )~=0
drop if strpos(item_description," NEWSPAPER "         )~=0
drop if strpos(item_description," PITCHER "           )~=0
drop if strpos(item_description," ORNAMENT "          )~=0
drop if strpos(item_description," GRINDER "           )~=0
drop if strpos(item_description," PRESS  "            )~=0
drop if strpos(item_description," BAG "               )~=0
drop if strpos(item_description," FILTER "            )~=0
drop if strpos(item_description," STOVETOP "          )~=0
drop if strpos(item_description," SPOONS "            )~=0
drop if strpos(item_description," KETTLE "            )~=0
drop if strpos(item_description," TIMER "             )~=0
drop if strpos(item_description," CRANIUM "           )~=0
drop if strpos(item_description," SINATRA "           )~=0
drop if strpos(item_description," INVITATION "        )~=0
drop if strpos(item_description," PUZZLE "            )~=0
drop if strpos(item_description," BARISTA  "          )~=0
drop if strpos(item_description," CD "                )~=0
drop if strpos(item_description,"*"                   )~=0
drop if strpos(item_description,"1QT"                 )~=0
drop if strpos(item_description,"12C"                 )~=0
drop if strpos(item_description," SCOOP "             )~=0
drop if strpos(item_description," MAKER "             )~=0
drop if strpos(item_description," ESPRESSO MAGNIFICA ")~=0
drop if strpos(item_description," SERVEWARE "         )~=0
drop if strpos(item_description," PERM "              )~=0
drop if strpos(item_description," MIX "              )~=0
drop if strpos(item_description," CAN "              )~=0
drop if strpos(item_description," BARISTA"              )~=0
drop if strpos(item_description," 96OZ"              )~=0

drop if item_description==""


replace item_description=subinstr(item_description,"BREWED MORNING PICK","COFFEE",5)
replace item_description=subinstr(item_description,"GENERIC"," ",5)
*replace item_description=subinstr(item_description,"ADD"," ",5)
*replace item_description=subinstr(item_description,"EXTRA"," ",5)
replace item_description=subinstr(item_description,"BREWED"," ",5)
replace item_description=subinstr(item_description,"COLD"," ",5)

replace item_description=subinstr(item_description," SH "," SHORT ",5)
replace item_description=subinstr(item_description," TL "," TALL ",5)
replace item_description=subinstr(item_description," GR "," GRANDE ",5)
replace item_description=subinstr(item_description," VT "," VENTI ",5)


replace item_description=trim(itrim(item_description))
save ../data/working/productfile_consumption_ids, replace

keep item_description
outsheet using ../data/working/productfile_consumption, replace noq nol non
