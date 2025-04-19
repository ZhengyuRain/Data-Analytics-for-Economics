* survey2.do, modified to give us estimation errors in percentage terms
clear
set mem 1g
set more off
pro drop _all

global datadir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/data/survey
global tmpdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/tmp
global logdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/logs
global graphdir /afs/ir.stanford.edu/data/gsb/asorensen/SBC/graphs

log using $logdir/survey3.log, text replace

use $datadir/CalorieDataFull

gen loc2 = "SF" if location=="SF Financial District"|location=="SF Pac Heights"
replace loc2 = "SEA" if loc2==""

* How innacurate were people before calorie posting?

* calculate estimation errors
pro def getdev
    qui gen `1'_dev = `1'_est - `2'
    qui gen `1'_pdev = (`1'_est - `2')/`2'
end

getdev frap 380
getdev latte 190
getdev muffin 410
getdev cookie 450
getdev food_cal actual_food
getdev bev_cal actual_bev

gen bev_over = bev_cal_dev>0
gen latte_over = latte_dev>0
gen muffin_under = muffin_dev<0
gen food_under = food_cal_dev<0

table loc2 post, c(p10 latte_dev p25 latte_dev p50 latte_dev p75 latte_dev p90 latte_dev)
table loc2 post, c(mean latte_dev mean latte_over)

table loc2 post, c(p10 bev_cal_dev p25 bev_cal_dev p50 bev_cal_dev p75 bev_cal_dev p90 bev_cal_dev)
table loc2 post, c(mean bev_cal_dev mean bev_over mean actual_bev)

table loc2 post, c(p10 bev_cal_pdev p25 bev_cal_pdev p50 bev_cal_pdev p75 bev_cal_pdev p90 bev_cal_pdev)
table loc2 post, c(mean bev_cal_pdev mean bev_over)

table loc2 post, c(p10 muffin_dev p25 muffin_dev p50 muffin_dev p75 muffin_dev p90 muffin_dev)
table loc2 post, c(mean muffin_dev mean muffin_under)

table loc2 post, c(p10 muffin_pdev p25 muffin_pdev p50 muffin_pdev p75 muffin_pdev p90 muffin_pdev)
table loc2 post, c(mean muffin_pdev mean muffin_under)

table loc2 post, c(p10 food_cal_dev p25 food_cal_dev p50 food_cal_dev p75 food_cal_dev p90 food_cal_dev)
table loc2 post, c(mean food_cal_dev mean food_under mean actual_food)

table loc2 post, c(p10 food_cal_pdev p25 food_cal_pdev p50 food_cal_pdev p75 food_cal_pdev p90 food_cal_pdev)
table loc2 post, c(mean food_cal_pdev mean food_under)

gen latte_within_50 = (abs(latte_dev)<40)
gen bev_within_50 = (abs(bev_cal_dev)<50) 

table loc2 post, c(mean latte_within_50 mean bev_within_50)


* Did calorie-posting make people care more about calories?

* answers to open-ended question
gen someresponse = (factor1~="")
gen allfactors = factor1+"/"+factor2+"/"+factor3+"/"+factor4

gen cal_men = regexm(lower(allfactors),"calorie")
replace cal_men = 1 if regexm(lower(allfactors),"health")
replace cal_men = 1 if regexm(lower(allfactors),"nutrition")

table loc2 post, c(mean cal_men)

* importance rankings
table loc2 post, c(mean taste mean price mean calories)
ttest taste if loc2=="SEA", by(post)
ttest price if loc2=="SEA", by(post)
ttest calories if loc2=="SEA", by(post)
ttest calories if loc2=="SF", by(post)

* percent reporting calories as at least as important as price or taste
gen calimpt = (calories>=taste) & (calories>=price)
table loc2 post, c(mean calimpt)
ttest calimpt if loc2=="SEA", by(post)
ttest calimpt if loc2=="SF", by(post)

* percent who read labels
gen readlabels = (read_labels=="yes")
table loc2 post, c(mean readlabels)



* Did people get more accurate?
* look at (a) purchased beverage, (b) all beverages, (c) all items
gen bev_acc = abs(bev_cal_dev)
gen nbev_est = (frap_est~=.) + (latte_est~=.) + (bev_cal_est~=.)
gen allbev_acc = sqrt(((frap_dev)^2 + ///
                       (latte_dev)^2 + ///
                       (bev_cal_dev)^2)/nbev_est)
gen n_est = (frap_est~=.)+(latte_est~=.)+(muffin_est~=.)+(cookie_est~=.) + ///
            (food_cal_est~=.)*(actual_food~=.) + ///
            (bev_cal_est~=.)*(actual_bev~=.)
gen all_acc = sqrt(((frap_dev*(frap_dev~=.))^2 + ///
                       (latte_dev*(latte_dev~=.))^2 + ///
                       (muffin_dev*(muffin_dev~=.))^2 + ///
                       (cookie_dev*(cookie_dev~=.))^2 + ///
                       (food_cal_dev*(food_cal_dev~=.))^2 + ///
                       (bev_cal_dev*(bev_cal_dev~=.))^2)/n_est)

* (a)
table loc2 post, c(mean bev_acc sd bev_acc)
table loc2 post, c(p10 bev_acc p25 bev_acc p50 bev_acc p75 bev_acc p90 bev_acc)

* (b)
table loc2 post, c(mean allbev_acc sd allbev_acc)
table loc2 post, c(p10 allbev_acc p25 allbev_acc p50 allbev_acc p75 allbev_acc p90 allbev_acc)

* (c)
table loc2 post, c(mean all_acc sd all_acc)
table loc2 post, c(p10 all_acc p25 all_acc p50 all_acc p75 all_acc p90 all_acc)

* draw distributions for purchased bev deviations
gen x = -300 in 1
replace x = x[_n-1] + 10 in 2/l
replace x = . if x>500
kdensity bev_cal_dev if loc2=="SEA" & post==0, at(x) gen(x1 ypre) bwidth(40) nograph
kdensity bev_cal_dev if loc2=="SEA" & post==1, at(x) gen(x2 ypost) bwidth(40) nograph
tw line ypre ypost x, lpattern(solid dash) ///
  xline(0, lpattern(dash) lwidth(vthin)) ///
  xtitle("Error in calorie estimate") ///
  ytitle("Density") ///
  xlabel(-200 0 200 400) ///
  ylabel(0) ///
  legend(lab(1 "Before calorie posting") lab(2 "After calorie posting")) ///
  saving($graphdir/bev_dev_dens.gph, replace)
graph export $graphdir/bev_dev_dens.eps, logo(off) replace
!epstopdf $graphdir/bev_dev_dens.eps

* for SF
drop x1 x2 ypre ypost
kdensity bev_cal_dev if loc2=="SF" & post==0, at(x) gen(x1 ypre) bwidth(40) nograph
kdensity bev_cal_dev if loc2=="SF" & post==1, at(x) gen(x2 ypost) bwidth(40) nograph
tw line ypre ypost x, lpattern(solid dash) ///
  xline(0, lpattern(dash) lwidth(vthin)) ///
  xtitle("Error in calorie estimate") ///
  ytitle("Density") ///
  xlabel(-200 0 200 400) ///
  ylabel(0) ///
  legend(lab(1 "Before calorie posting") lab(2 "After calorie posting")) ///
  title("San Francisco") ///
  saving($graphdir/bev_dev_dens_sf.gph, replace)
graph export $graphdir/bev_dev_dens_sf.eps, logo(off) replace
!epstopdf $graphdir/bev_dev_dens_sf.eps

* combine SEA and SF into one figure
drop x1 x2 ypre ypost
kdensity bev_cal_dev if loc2=="SEA" & post==0, at(x) gen(x1 ypre) bwidth(40) nograph
kdensity bev_cal_dev if loc2=="SEA" & post==1, at(x) gen(x2 ypost) bwidth(40) nograph
tw line ypre ypost x, lpattern(solid dash) ///
  xline(0, lpattern(dash) lwidth(vthin)) ///
  xtitle("Error in calorie estimate") ///
  ytitle("Density") ///
  xlabel(-200 0 200 400) ///
  ylabel(0) ///
  legend(lab(1 "Before calorie posting") lab(2 "After calorie posting")) ///
  legend(off) title("Seattle") ///
  saving($graphdir/bev_dev_dens_nolegend.gph, replace)

graph combine $graphdir/bev_dev_dens_nolegend.gph $graphdir/bev_dev_dens_sf.gph, col(1) ysize(10) xsize(7) saving($graphdir/beverage_errors.gph, replace)
graph export $graphdir/beverage_errors.eps, logo(off) replace
!epstopdf $graphdir/beverage_errors.eps

* for a can of coke
drop x1 x2 ypre ypost
gen coke_dev = coke_est - 155
kdensity coke_dev if loc2=="SF" & post==0, at(x) gen(x1 ypre) bwidth(40) nograph
kdensity coke_dev if loc2=="SF" & post==1, at(x) gen(x2 ypost) bwidth(40) nograph
tw line ypre ypost x, lpattern(solid dash) ///
  xline(0, lpattern(dash) lwidth(vthin)) ///
  xtitle("Error in calorie estimate") ///
  ytitle("Density") ///
  xlabel(-200 0 200 400) ///
  ylabel(0) ///
  legend(lab(1 "Before calorie posting") lab(2 "After calorie posting")) ///
  title("(SEA: Coke)") ///
  saving($graphdir/bev_dev_dens_coke.gph, replace)
graph export $graphdir/bev_dev_dens_coke.eps, logo(off) replace
!epstopdf $graphdir/bev_dev_dens_coke.eps

* simplest regressions
gen seattle = loc2=="SEA"
gen seapost = seattle*post
reg bev_acc seattle post seapost
reg allbev_acc seattle post seapost
reg all_acc seattle post seapost

* with covariates
gen female = (gender=="female")
gen bachelors = (education=="Bachelors")
gen graddeg = (education=="Graduate degree")
gen underweight = (bmi<18.5)
gen overweight = (bmi>=25 & bmi<30)
gen obese = (bmi>=30)
reg bev_acc seattle post seapost female bachelors graddeg underweight overweight obese
reg allbev_acc seattle post seapost female bachelors graddeg underweight overweight obese


* any heterogeneity in accuracy change?
table loc2 post if female==0, c(mean bev_acc sd bev_acc)
table loc2 post if female==1, c(mean bev_acc sd bev_acc)

table loc2 post if underweight, c(mean bev_acc sd bev_acc)
table loc2 post if underweight==0 & obese==0, c(mean bev_acc sd bev_acc)
table loc2 post if obese, c(mean bev_acc sd bev_acc)

table loc2 post if education=="High School", c(mean bev_acc sd bev_acc)
table loc2 post if education~="High School", c(mean bev_acc sd bev_acc)


table loc2 post if female==0, c(mean allbev_acc sd allbev_acc)
table loc2 post if female==1, c(mean allbev_acc sd allbev_acc)

table loc2 post if underweight, c(mean allbev_acc sd allbev_acc)
table loc2 post if underweight==0 & obese==0, c(mean allbev_acc sd allbev_acc)
table loc2 post if obese, c(mean allbev_acc sd allbev_acc)

table loc2 post if education=="High School", c(mean allbev_acc sd allbev_acc)
table loc2 post if education~="High School", c(mean allbev_acc sd allbev_acc)



*** do it all again without "ridiculous" surveys
*** ridiculous = below 2.5 pctile or above 97.5 pctile
use $datadir/CalorieDataFull, clear
drop if cal_per_day<=900 | cal_per_day>=3500

gen loc2 = "SF" if location=="SF Financial District"|location=="SF Pac Heights"
replace loc2 = "SEA" if loc2==""

* How innacurate were people before calorie posting?

* calculate estimation errors
getdev frap 380
getdev latte 190
getdev muffin 410
getdev cookie 450
getdev food_cal actual_food
getdev bev_cal actual_bev

gen bev_over = bev_cal_dev>0
gen latte_over = latte_dev>0
gen muffin_under = muffin_dev<0
gen food_under = food_cal_dev<0

table loc2 post, c(p10 latte_dev p25 latte_dev p50 latte_dev p75 latte_dev p90 latte_dev)
table loc2 post, c(mean latte_dev mean latte_over)

table loc2 post, c(p10 bev_cal_dev p25 bev_cal_dev p50 bev_cal_dev p75 bev_cal_dev p90 bev_cal_dev)
table loc2 post, c(mean bev_cal_dev mean bev_over)

table loc2 post, c(p10 muffin_dev p25 muffin_dev p50 muffin_dev p75 muffin_dev p90 muffin_dev)
table loc2 post, c(mean muffin_dev mean muffin_under)

table loc2 post, c(p10 food_cal_dev p25 food_cal_dev p50 food_cal_dev p75 food_cal_dev p90 food_cal_dev)
table loc2 post, c(mean food_cal_dev mean food_under)

gen latte_within_50 = (abs(latte_dev)<40)
gen bev_within_50 = (abs(bev_cal_dev)<50) 

table loc2 post, c(mean latte_within_50 mean bev_within_50)


* Did calorie-posting make people care more about calories?

* answers to open-ended question
gen someresponse = (factor1~="")
gen allfactors = factor1+"/"+factor2+"/"+factor3+"/"+factor4

gen cal_men = regexm(lower(allfactors),"calorie")
replace cal_men = 1 if regexm(lower(allfactors),"health")
replace cal_men = 1 if regexm(lower(allfactors),"nutrition")

table loc2 post, c(mean cal_men)

* importance rankings
table loc2 post, c(mean taste mean price mean calories)
ttest taste if loc2=="SEA", by(post)
ttest price if loc2=="SEA", by(post)
ttest calories if loc2=="SEA", by(post)
ttest calories if loc2=="SF", by(post)

* percent reporting calories as at least as important as price or taste
gen calimpt = (calories>=taste) & (calories>=price)
table loc2 post, c(mean calimpt)
ttest calimpt if loc2=="SEA", by(post)
ttest calimpt if loc2=="SF", by(post)

* percent who read labels
gen readlabels = (read_labels=="yes")
table loc2 post, c(mean readlabels)



* Did people get more accurate?
* look at (a) purchased beverage, (b) all beverages, (c) all items
gen bev_acc = abs(bev_cal_dev)
gen nbev_est = (frap_est~=.) + (latte_est~=.) + (bev_cal_est~=.)
gen allbev_acc = sqrt(((frap_dev)^2 + ///
                       (latte_dev)^2 + ///
                       (bev_cal_dev)^2)/nbev_est)
gen n_est = (frap_est~=.)+(latte_est~=.)+(muffin_est~=.)+(cookie_est~=.) + ///
            (food_cal_est~=.)*(actual_food~=.) + ///
            (bev_cal_est~=.)*(actual_bev~=.)
gen all_acc = sqrt(((frap_dev*(frap_dev~=.))^2 + ///
                       (latte_dev*(latte_dev~=.))^2 + ///
                       (muffin_dev*(muffin_dev~=.))^2 + ///
                       (cookie_dev*(cookie_dev~=.))^2 + ///
                       (food_cal_dev*(food_cal_dev~=.))^2 + ///
                       (bev_cal_dev*(bev_cal_dev~=.))^2)/n_est)

* (a)
table loc2 post, c(mean bev_acc sd bev_acc)
table loc2 post, c(p10 bev_acc p25 bev_acc p50 bev_acc p75 bev_acc p90 bev_acc)

* (b)
table loc2 post, c(mean allbev_acc sd allbev_acc)
table loc2 post, c(p10 allbev_acc p25 allbev_acc p50 allbev_acc p75 allbev_acc p90 allbev_acc)

* (c)
table loc2 post, c(mean all_acc sd all_acc)
table loc2 post, c(p10 all_acc p25 all_acc p50 all_acc p75 all_acc p90 all_acc)

* draw distributions for purchased bev deviations
gen x = -300 in 1
replace x = x[_n-1] + 10 in 2/l
replace x = . if x>500
kdensity bev_cal_dev if loc2=="SEA" & post==0, at(x) gen(x1 ypre) bwidth(40) nograph
kdensity bev_cal_dev if loc2=="SEA" & post==1, at(x) gen(x2 ypost) bwidth(40) nograph
tw line ypre ypost x, lpattern(solid dash) ///
  xline(0, lpattern(dash) lwidth(vthin)) ///
  xtitle("Error in calorie estimate") ///
  ytitle("Density") ///
  xlabel(-200 0 200 400) ///
  ylabel(0) ///
  legend(lab(1 "Before calorie posting") lab(2 "After calorie posting")) ///
  saving($graphdir/bev_dev_dens_2.gph, replace)
graph export $graphdir/bev_dev_dens_2.eps, logo(off) replace
!epstopdf $graphdir/bev_dev_dens_2.eps

* for SF
drop x1 x2 ypre ypost
kdensity bev_cal_dev if loc2=="SF" & post==0, at(x) gen(x1 ypre) bwidth(40) nograph
kdensity bev_cal_dev if loc2=="SF" & post==1, at(x) gen(x2 ypost) bwidth(40) nograph
tw line ypre ypost x, lpattern(solid dash) ///
  xline(0, lpattern(dash) lwidth(vthin)) ///
  xtitle("Error in calorie estimate") ///
  ytitle("Density") ///
  xlabel(-200 0 200 400) ///
  ylabel(0) ///
  legend(lab(1 "Before calorie posting") lab(2 "After calorie posting")) ///
  title("(SF)") ///
  saving($graphdir/bev_dev_dens_sf_2.gph, replace)
graph export $graphdir/bev_dev_dens_sf_2.eps, logo(off) replace
!epstopdf $graphdir/bev_dev_dens_sf_2.eps

* for a can of coke
drop x1 x2 ypre ypost
gen coke_dev = coke_est - 155
kdensity coke_dev if loc2=="SF" & post==0, at(x) gen(x1 ypre) bwidth(40) nograph
kdensity coke_dev if loc2=="SF" & post==1, at(x) gen(x2 ypost) bwidth(40) nograph
tw line ypre ypost x, lpattern(solid dash) ///
  xline(0, lpattern(dash) lwidth(vthin)) ///
  xtitle("Error in calorie estimate") ///
  ytitle("Density") ///
  xlabel(-200 0 200 400) ///
  ylabel(0) ///
  legend(lab(1 "Before calorie posting") lab(2 "After calorie posting")) ///
  title("(SEA: Coke)") ///
  saving($graphdir/bev_dev_dens_coke_2.gph, replace)
graph export $graphdir/bev_dev_dens_coke_2.eps, logo(off) replace
!epstopdf $graphdir/bev_dev_dens_coke_2.eps

* simplest regressions
gen seattle = loc2=="SEA"
gen seapost = seattle*post
reg bev_acc seattle post seapost
reg allbev_acc seattle post seapost
reg all_acc seattle post seapost

* with covariates
gen female = (gender=="female")
gen bachelors = (education=="Bachelors")
gen graddeg = (education=="Graduate degree")
gen underweight = (bmi<18.5)
gen overweight = (bmi>=25 & bmi<30)
gen obese = (bmi>=30)
reg bev_acc seattle post seapost female bachelors graddeg underweight overweight obese
reg allbev_acc seattle post seapost female bachelors graddeg underweight overweight obese


* any heterogeneity in accuracy change?
table loc2 post if female==0, c(mean bev_acc sd bev_acc)
table loc2 post if female==1, c(mean bev_acc sd bev_acc)

table loc2 post if underweight, c(mean bev_acc sd bev_acc)
table loc2 post if underweight==0 & obese==0, c(mean bev_acc sd bev_acc)
table loc2 post if obese, c(mean bev_acc sd bev_acc)

table loc2 post if education=="High School", c(mean bev_acc sd bev_acc)
table loc2 post if education~="High School", c(mean bev_acc sd bev_acc)


table loc2 post if female==0, c(mean allbev_acc sd allbev_acc)
table loc2 post if female==1, c(mean allbev_acc sd allbev_acc)

table loc2 post if underweight, c(mean allbev_acc sd allbev_acc)
table loc2 post if underweight==0 & obese==0, c(mean allbev_acc sd allbev_acc)
table loc2 post if obese, c(mean allbev_acc sd allbev_acc)

table loc2 post if education=="High School", c(mean allbev_acc sd allbev_acc)
table loc2 post if education~="High School", c(mean allbev_acc sd allbev_acc)




*** do it all again without "ridiculous" surveys
*** ridiculous = banana estimate is zero or 500+
use $datadir/CalorieDataFull, clear
drop if banana_est==0 | banana_est>500

gen loc2 = "SF" if location=="SF Financial District"|location=="SF Pac Heights"
replace loc2 = "SEA" if loc2==""

* How innacurate were people before calorie posting?

* calculate estimation errors
getdev frap 380
getdev latte 190
getdev muffin 410
getdev cookie 450
getdev food_cal actual_food
getdev bev_cal actual_bev

gen bev_over = bev_cal_dev>0
gen latte_over = latte_dev>0
gen muffin_under = muffin_dev<0
gen food_under = food_cal_dev<0

table loc2 post, c(p10 latte_dev p25 latte_dev p50 latte_dev p75 latte_dev p90 latte_dev)
table loc2 post, c(mean latte_dev mean latte_over)

table loc2 post, c(p10 bev_cal_dev p25 bev_cal_dev p50 bev_cal_dev p75 bev_cal_dev p90 bev_cal_dev)
table loc2 post, c(mean bev_cal_dev mean bev_over)

table loc2 post, c(p10 muffin_dev p25 muffin_dev p50 muffin_dev p75 muffin_dev p90 muffin_dev)
table loc2 post, c(mean muffin_dev mean muffin_under)

table loc2 post, c(p10 food_cal_dev p25 food_cal_dev p50 food_cal_dev p75 food_cal_dev p90 food_cal_dev)
table loc2 post, c(mean food_cal_dev mean food_under)

gen latte_within_50 = (abs(latte_dev)<40)
gen bev_within_50 = (abs(bev_cal_dev)<50) 

table loc2 post, c(mean latte_within_50 mean bev_within_50)


* Did calorie-posting make people care more about calories?

* answers to open-ended question
gen someresponse = (factor1~="")
gen allfactors = factor1+"/"+factor2+"/"+factor3+"/"+factor4

gen cal_men = regexm(lower(allfactors),"calorie")
replace cal_men = 1 if regexm(lower(allfactors),"health")
replace cal_men = 1 if regexm(lower(allfactors),"nutrition")

table loc2 post, c(mean cal_men)

* importance rankings
table loc2 post, c(mean taste mean price mean calories)
ttest taste if loc2=="SEA", by(post)
ttest price if loc2=="SEA", by(post)
ttest calories if loc2=="SEA", by(post)
ttest calories if loc2=="SF", by(post)

* percent reporting calories as at least as important as price or taste
gen calimpt = (calories>=taste) & (calories>=price)
table loc2 post, c(mean calimpt)
ttest calimpt if loc2=="SEA", by(post)
ttest calimpt if loc2=="SF", by(post)

* percent who read labels
gen readlabels = (read_labels=="yes")
table loc2 post, c(mean readlabels)



* Did people get more accurate?
* look at (a) purchased beverage, (b) all beverages, (c) all items
gen bev_acc = abs(bev_cal_dev)
gen nbev_est = (frap_est~=.) + (latte_est~=.) + (bev_cal_est~=.)
gen allbev_acc = sqrt(((frap_dev)^2 + ///
                       (latte_dev)^2 + ///
                       (bev_cal_dev)^2)/nbev_est)
gen n_est = (frap_est~=.)+(latte_est~=.)+(muffin_est~=.)+(cookie_est~=.) + ///
            (food_cal_est~=.)*(actual_food~=.) + ///
            (bev_cal_est~=.)*(actual_bev~=.)
gen all_acc = sqrt(((frap_dev*(frap_dev~=.))^2 + ///
                       (latte_dev*(latte_dev~=.))^2 + ///
                       (muffin_dev*(muffin_dev~=.))^2 + ///
                       (cookie_dev*(cookie_dev~=.))^2 + ///
                       (food_cal_dev*(food_cal_dev~=.))^2 + ///
                       (bev_cal_dev*(bev_cal_dev~=.))^2)/n_est)

* (a)
table loc2 post, c(mean bev_acc sd bev_acc)
table loc2 post, c(p10 bev_acc p25 bev_acc p50 bev_acc p75 bev_acc p90 bev_acc)

* (b)
table loc2 post, c(mean allbev_acc sd allbev_acc)
table loc2 post, c(p10 allbev_acc p25 allbev_acc p50 allbev_acc p75 allbev_acc p90 allbev_acc)

* (c)
table loc2 post, c(mean all_acc sd all_acc)
table loc2 post, c(p10 all_acc p25 all_acc p50 all_acc p75 all_acc p90 all_acc)

* draw distributions for purchased bev deviations
gen x = -300 in 1
replace x = x[_n-1] + 10 in 2/l
replace x = . if x>500
kdensity bev_cal_dev if loc2=="SEA" & post==0, at(x) gen(x1 ypre) bwidth(40) nograph
kdensity bev_cal_dev if loc2=="SEA" & post==1, at(x) gen(x2 ypost) bwidth(40) nograph
tw line ypre ypost x, lpattern(solid dash) ///
  xline(0, lpattern(dash) lwidth(vthin)) ///
  xtitle("Error in calorie estimate") ///
  ytitle("Density") ///
  xlabel(-200 0 200 400) ///
  ylabel(0) ///
  legend(lab(1 "Before calorie posting") lab(2 "After calorie posting")) ///
  saving($graphdir/bev_dev_dens_3.gph, replace)
graph export $graphdir/bev_dev_dens_3.eps, logo(off) replace
!epstopdf $graphdir/bev_dev_dens_3.eps

* for SF
drop x1 x2 ypre ypost
kdensity bev_cal_dev if loc2=="SF" & post==0, at(x) gen(x1 ypre) bwidth(40) nograph
kdensity bev_cal_dev if loc2=="SF" & post==1, at(x) gen(x2 ypost) bwidth(40) nograph
tw line ypre ypost x, lpattern(solid dash) ///
  xline(0, lpattern(dash) lwidth(vthin)) ///
  xtitle("Error in calorie estimate") ///
  ytitle("Density") ///
  xlabel(-200 0 200 400) ///
  ylabel(0) ///
  legend(lab(1 "Before calorie posting") lab(2 "After calorie posting")) ///
  title("(SF)") ///
  saving($graphdir/bev_dev_dens_sf_3.gph, replace)
graph export $graphdir/bev_dev_dens_sf_3.eps, logo(off) replace
!epstopdf $graphdir/bev_dev_dens_sf_3.eps

* for a can of coke
drop x1 x2 ypre ypost
gen coke_dev = coke_est - 155
kdensity coke_dev if loc2=="SF" & post==0, at(x) gen(x1 ypre) bwidth(40) nograph
kdensity coke_dev if loc2=="SF" & post==1, at(x) gen(x2 ypost) bwidth(40) nograph
tw line ypre ypost x, lpattern(solid dash) ///
  xline(0, lpattern(dash) lwidth(vthin)) ///
  xtitle("Error in calorie estimate") ///
  ytitle("Density") ///
  xlabel(-200 0 200 400) ///
  ylabel(0) ///
  legend(lab(1 "Before calorie posting") lab(2 "After calorie posting")) ///
  title("(SEA: Coke)") ///
  saving($graphdir/bev_dev_dens_coke_3.gph, replace)
graph export $graphdir/bev_dev_dens_coke_3.eps, logo(off) replace
!epstopdf $graphdir/bev_dev_dens_coke_3.eps

* simplest regressions
gen seattle = loc2=="SEA"
gen seapost = seattle*post
reg bev_acc seattle post seapost
reg allbev_acc seattle post seapost
reg all_acc seattle post seapost

* with covariates
gen female = (gender=="female")
gen bachelors = (education=="Bachelors")
gen graddeg = (education=="Graduate degree")
gen underweight = (bmi<18.5)
gen overweight = (bmi>=25 & bmi<30)
gen obese = (bmi>=30)
reg bev_acc seattle post seapost female bachelors graddeg underweight overweight obese
reg allbev_acc seattle post seapost female bachelors graddeg underweight overweight obese


* any heterogeneity in accuracy change?
table loc2 post if female==0, c(mean bev_acc sd bev_acc)
table loc2 post if female==1, c(mean bev_acc sd bev_acc)

table loc2 post if underweight, c(mean bev_acc sd bev_acc)
table loc2 post if underweight==0 & obese==0, c(mean bev_acc sd bev_acc)
table loc2 post if obese, c(mean bev_acc sd bev_acc)

table loc2 post if education=="High School", c(mean bev_acc sd bev_acc)
table loc2 post if education~="High School", c(mean bev_acc sd bev_acc)


table loc2 post if female==0, c(mean allbev_acc sd allbev_acc)
table loc2 post if female==1, c(mean allbev_acc sd allbev_acc)

table loc2 post if underweight, c(mean allbev_acc sd allbev_acc)
table loc2 post if underweight==0 & obese==0, c(mean allbev_acc sd allbev_acc)
table loc2 post if obese, c(mean allbev_acc sd allbev_acc)

table loc2 post if education=="High School", c(mean allbev_acc sd allbev_acc)
table loc2 post if education~="High School", c(mean allbev_acc sd allbev_acc)


log close
