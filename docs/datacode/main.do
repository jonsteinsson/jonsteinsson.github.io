***Program to Replicate Tables 1 (partial) and Tables 2-5 (complete)
***Dahl and DellaVigna, "Does Movie Violence Increase Violent Crime?"
***Published in QJE, May 2009
***Requires datasets fulliblockday.dta, fulliblock.dta, and fulliblocktri.dta
***Uses add-on ado files outreg and ivreg2
***Creates ".log" files as well as ".out" tables 


*****Setup*****
clear all
set memory 2G
set matsize 600
set more off
capture log close

global data "~/docs/projects/movies/movies-watson-1-2011"
global out "~/docs/projects/movies/movies-watson-1-2011"
cd $data

*note: the program "dahlivreg" creates a table with regression results in files with the extension ".out"
*note: adding "first" at the end of this command will create an outreg table with the first stage estimates as well
*note: adding "showfirst" at the end of this command will show the first stage results in the log file
program define dahlivreg, byable(recall)
  version 8.0
  marksample touse
  local iblock=_byindex()
  if "`3'"!="showfirst" | "`iblock'"!="1" {
    ivreg $lhs ($rhs = $iv) $weather $holiday $date if wkd & `touse', cluster(wkdgroup)
  }
  if "`3'"=="showfirst" & "`iblock'"=="1" {
    ivreg $lhs ($rhs = $iv) $weather $holiday $date if wkd & `touse', first cluster(wkdgroup)
  }
  outreg $rhs using $out/`1', ctitle("`2'""`iblock'") se 3aster bdec(4) rdec(4) nocons append
  if "`3'"=="first" {
    quietly reg rjd810viol $iv $weather $holiday $date if wkd & `touse' & `iblock'==1, cluster(wkdgroup)
    outreg $iv using $out/`1'first, ctitle("`2'""810") se 3aster bdec(4) rdec(4) nocons append
    quietly reg rjd57viol $iv $weather $holiday $date if wkd & `touse' & `iblock'==1, cluster(wkdgroup)
    outreg $iv using $out/`1'first, ctitle("`2'""57") se 3aster bdec(4) rdec(4) nocons append
    quietly reg rjd04viol $iv $weather $holiday $date if wkd & `touse' & `iblock'==1, cluster(wkdgroup)
    outreg $iv using $out/`1'first, ctitle("`2'""04") se 3aster bdec(4) rdec(4) nocons append
  }
end

*note: program "fake" needed so that the outreg output is well-formatted
program define fake
  version 8.0
  reg `2' `3'
  outreg `3' using $out/`1', title("`1'") ctitle(fake) se 3aster bdec(4) rdec(4) nocons replace
  outreg `3' using $out/`1'first, title("`1'") ctitle(fake) se 3aster bdec(4) rdec(4) nocons replace
end


***** Table 1 -- Summary Stats *****

log using $out/table1, text replace
use $data/fulliblocktri, replace

*Assault data
tab iblock if wkd, sum(assault)
tab iblock if dow==5, sum(assault)
tab iblock if dow==6, sum(assault)
tab iblock if dow==0, sum(assault)
tab iblock if dow==1|dow==2|dow==3|dow==4, sum(assault)

*Movie audience (Theater)
tab iblock if wkd & iblock==3, sum(rjdtot)
tab iblock if dow==5 & iblock==3, sum(rjdtot)
tab iblock if dow==6 & iblock==3, sum(rjdtot)
tab iblock if dow==0 & iblock==3, sum(rjdtot)
tab iblock if (dow==1|dow==2|dow==3|dow==4) & iblock==3, sum(rjdtot)

*kids-in-mind.com ratings
sum rjdtot rjd810viol rjd57viol rjd04viol if iblock==3 & wkd

log close


***** Table 2 -- Daily *****

log using $out/table2, text replace
use $data/fulliblockday, replace
quietly fake table2 lnassault rjd810viol

global lhs "lnassault"
global rhs "rjd810viol rjd57viol rjd04viol"
global iv "rjd810viol rjd57viol rjd04viol"
global weather=""
global holiday=""
global date="yy*"
dahlivreg table2 yy*
testparm yy*

global date="dd* yy*"
dahlivreg table2 +dd*
testparm dd*

global date="dd* mm* yy*"
dahlivreg table2 +dd+mm*
testparm mm*
testparm dd*

global date="dd* mm* yy* nn*"
dahlivreg table2 dd+mm+nn*
testparm nn*

rename hhaudTV audTV
rename hhsuperbowl superbowl
global holiday="hh* hm* hp*"
dahlivreg table2 +hh*-tv-sb
testparm hh*
rename audTV hhaudTV
rename superbowl hhsuperbowl

global weather="maxa maxb maxc heatindexb heatindexc heatindexd mina minb minc wdspb wdspc anyrain anysnow"
dahlivreg table2 +weather*
testparm $weather hhaudTV hhsuperbowl

global iv "rh1d810viol rh1d57viol rh1d04viol"
dahlivreg table2 ivrh1

log close


***** Table 3 -- Baseline *****

log using $out/table3, text replace
use $data/fulliblock, replace
quietly fake table3 lnassault rjd810viol

global lhs "lnassault"
global rhs "rjd810viol rjd57viol rjd04viol"
global iv "rh1d810viol rh1d57viol rh1d04viol"
global weather="maxa maxb maxc heatindexb heatindexc heatindexd mina minb minc wdspb wdspc anyrain anysnow"
global holiday="hh* hm* hp*"
global date="dd* mm* yy* nn*"

bys iblock: ivreg $lhs ($rhs = $iv) $weather $holiday $date if wkd, cluster(wkdgroup)
bys iblock: dahlivreg table3 ivrh1 first

reg rjd810viol $iv $weather $holiday $date if wkd & iblock==3, cluster(wkdgroup)
testparm $iv
reg rjd57viol $iv $weather $holiday $date if wkd & iblock==3, cluster(wkdgroup)
testparm $iv
reg rjd04viol $iv $weather $holiday $date if wkd & iblock==3, cluster(wkdgroup)
testparm $iv

log close


***** Table 4 -- Medium Run *****

log using $out/table4, text replace
global lhs "lnassault"
global weather="maxa maxb maxc heatindexb heatindexc heatindexd mina minb minc wdspb wdspc anyrain anysnow"
global holiday="hh* hm* hp*"
global date="dd* mm* yy* nn*"

*Columns 1-2 -- Monday & Tuesday
use $data/fulliblocktri, replace
quietly fake table4 lnassault rjd810viol

keep if (dow==1|dow==2|dow==3|dow==4)
drop temp wkdgroup
gen temp=mdy if dow==1
replace temp=mdy-1 if dow==2
replace temp=mdy-2 if dow==3
replace temp=mdy-3 if dow==4
egen wkdgroup=group(temp)
drop temp
replace wkd=1

keep if (dow==1|dow==2) & (iblock==3|iblock==4)

label var rjd810violwkd rjd810violwkd
label var rjd57violwkd rjd57violwkd
label var rjd04violwkd rjd04violwkd
global rhs "rjd810violwkd rjd57violwkd rjd04violwkd"
global iv "rh1d810violwkd rh1d57violwkd rh1d04violwkd"
bys iblock: dahlivreg table4 mt-iv

*Columns 3-8 -- Lags
use $data/fulliblocktri, replace
gen wkdold=wkd
replace wkd=1 if dow==6|dow==0|dow==1
replace wkd=0 if dow==5
sort mdy
replace wkdgroup=wkdgroup[_n-1] if dow==1

global rhs "rjd810viol rjd57viol rjd04viol L7.rjd810viol L7.rjd57viol L7.rjd04viol"
global iv "rjd810viol rjd57viol rjd04viol L7.rjd810viol L7.rjd57viol L7.rjd04viol"
use $data/fulliblocktri, replace
keep if iblock==3
tsset mdy
dahlivreg table4 lags7
use $data/fulliblocktri, replace
keep if iblock==4
tsset mdy
dahlivreg table4 lags7 

global rhs "rjd810viol rjd57viol rjd04viol L14.rjd810viol L14.rjd57viol L14.rjd04viol"
global iv "rh1d810viol rh1d57viol rh1d04viol L14.rh1d810viol L14.rh1d57viol L14.rh1d04viol"
use $data/fulliblocktri, replace
keep if iblock==3
tsset mdy
dahlivreg table4 lags14-iv
use $data/fulliblocktri, replace
keep if iblock==4
tsset mdy
dahlivreg table4 lags14-iv

global rhs "rjd810viol rjd57viol rjd04viol L21.rjd810viol L21.rjd57viol L21.rjd04viol"
global iv "rh1d810viol rh1d57viol rh1d04viol L21.rh1d810viol L21.rh1d57viol L21.rh1d04viol"
use $data/fulliblocktri, replace
keep if iblock==3
tsset mdy
dahlivreg table4 lags21-iv
use $data/fulliblocktri, replace
keep if iblock==4
tsset mdy
dahlivreg table4 lags21-iv

log close


***** Table 5 -- Robustness *****

log using $out/table5, text replace 
global lhs "lnassault"
global weather="maxa maxb maxc heatindexb heatindexc heatindexd mina minb minc wdspb wdspc anyrain anysnow"
global holiday="hh* hm* hp*"
global date="dd* mm* yy* nn*"

use $data/fulliblocktri, replace
fake table5 lnassault rjd810viol

*Column 1
global rhs "rjd810viol rjd57viol rjd04viol"
global iv "rh1d810viol rh1d57viol rh1d04viol"
bys iblock: dahlivreg table5 ivrh1

*Column 2
global rhs "rjd810viol rjd57viol rjd04viol"
global iv "rh4d810viol rh4d57viol rh4d04viol rh1dtot"
bys iblock: dahlivreg table5 iv4+iv1dtot

*Column 3
global rhs "rjd810viol rjd57viol rjd04viol"
global iv "rh1d810viol rh1d57viol rh1d04viol"
gen oldwkd=wkd
replace wkd=1
sort mdy
replace wkdgroup=wkdgroup[_n-1] if dow==1
replace wkdgroup=wkdgroup[_n-2] if dow==2
replace wkdgroup=wkdgroup[_n-3] if dow==3
replace wkdgroup=wkdgroup[_n-4] if dow==4
bys iblock: dahlivreg table5 ivrh1+mtwt first

*Column 4
global rhs "rjd810viol rjd57viol rjd04viol"
global iv "rh1d810viol rh1d57viol rh1d04viol"
save temp, replace
use temp, replace
keep if iblock==2
tsset mdy, daily
ivreg2 $lhs ($rhs = $iv) $weather $holiday $date if wkd & iblock==2, bw(29) robust
outreg $rhs using $out/table5, ctitle("newey(28) 1") se 3aster bdec(4) rdec(4) nocons append
use temp, replace
keep if iblock==3
tsset mdy, daily
ivreg2 $lhs ($rhs = $iv) $weather $holiday $date if wkd & iblock==3, bw(29) robust
outreg $rhs using $out/table5, ctitle("newey(28) 2") se 3aster bdec(4) rdec(4) nocons append
use temp, replace
keep if iblock==4
tsset mdy, daily
ivreg2 $lhs ($rhs = $iv) $weather $holiday $date if wkd & iblock==4, bw(29) robust
outreg $rhs using $out/table5, ctitle("newey(28) 3") se 3aster bdec(4) rdec(4) nocons append
use temp, replace
replace wkd=oldwkd

*Column 5
global rhs "rjdmviolhigh rjdmviolmed rjdmviollow"
global iv "rh1dmviolhigh rh1dmviolmed rh1dmviollow"
bys iblock: dahlivreg table5 mpaa

*Column 6
global rhs "rjd810viol rjd57viol rjd04viol"
global iv "rh1d810viol rh1d57viol rh1d04viol"
global lhs "lnpersonal"
bys iblock: dahlivreg table5 allcrime

*Column 7
global lhs "lnassault"
global rhs "rjd810viol rjd57viol rjd04viol"
global iv "rjd810viol rjd57viol rjd04viol"
bys iblock: dahlivreg table5 ols

*Column 8
global rhs "rjd810viol rjd57viol rjd04viol"
poisson assault $rhs $date $weather $holiday if iblock==2 & wkd, robust cluster(wkdgroup)
outreg $rhs using $out/table5, ctitle("pois 1") se 3aster bdec(4) rdec(4) nocons append
poisson assault $rhs $date $weather $holiday if iblock==3 & wkd, robust cluster(wkdgroup)
outreg $rhs using $out/table5, ctitle("pois 2") se 3aster bdec(4) rdec(4) nocons append
poisson assault $rhs $date $weather $holiday if iblock==4 & wkd, robust cluster(wkdgroup)
outreg $rhs using $out/table5, ctitle("pois 3") se 3aster bdec(4) rdec(4) nocons append

log close


