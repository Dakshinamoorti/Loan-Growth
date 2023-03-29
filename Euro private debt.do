clear all

*log using "G:\My Drive\RM 2\New Do file and output\Extension.smcl", replace

import excel "/Users/Arun/Desktop/Research Methods/RM 2/IMF/European private.xls", sheet("PDL 1") first

*import excel "C:\Users\dvenkat4\Downloads\European private.xls", sheet("PDL 1") firstrow

ssc install drdid
ssc install csdid

*generating country group variable
egen ccode = group(Country)
tab Country, gen(ccode)

xtset ccode year

* generating loan growth
gen loangrowth =d.Loan/l.Loan

* generating values for gvar for never treated group
gen first_treat = .
replace first_treat= 1999 if Country=="Austria" 
replace first_treat= 1999 if Country=="Belgium" 
replace first_treat= 2002 if Country=="Finland" 
replace first_treat= 2002 if Country=="France" 
replace first_treat= 1999 if Country=="Germany" 
replace first_treat= 2002 if Country=="Greece" 
replace first_treat= 2002 if Country=="Ireland" 
replace first_treat= 2002 if Country=="Italy" 
replace first_treat= 1999 if Country=="Luxembourg" 
replace first_treat= 1999 if Country=="Netherlands" 
replace first_treat= 2002 if Country=="Portugal" 
replace first_treat= 2002 if Country=="Spain" 
replace first_treat= 2008 if Country=="Cyprus" 
replace first_treat= 2011 if Country=="Estonia" 
replace first_treat= 2014 if Country=="Latvia" 
replace first_treat= 2015 if Country=="Lithuania"
replace first_treat= 2008 if Country=="Malta" 
replace first_treat= 2009 if Country=="Slovak Rep" 
replace first_treat= 2007 if Country=="Slovenia" 

* replacing it to 0 for never treated group
replace first_treat = 0 if Country=="United Kingdom"
replace first_treat = 0 if Country=="Bulgaria"
replace first_treat = 0 if Country=="Croatia"
replace first_treat = 0 if Country=="Czech Rep"
replace first_treat = 0 if Country=="Hungary"
replace first_treat = 0 if Country=="Poland"
replace first_treat = 0 if Country=="Romania"
replace first_treat = 0 if Country=="Sweden"

* difference in difference fixed effects regression

xtset ccode year, yearly
csdid loangrowth, ivar (ccode) time (year) gvar (first_treat) notyet method(ipw)

* results for all tests
estat all

*checking the average effect after 5 years of Eurozone adoption
estat cevent, window(0 5)
*checking the average effect after 10 years of Eurozone adoption
estat cevent, window(0 10)
*checking the average effect after 15 years of Eurozone adoption
estat cevent, window(0 15)

estat event
* Event plot
csdid_plot, title("Difference in Difference Graph")

keep if year>=1980

xtset ccode year, yearly
csdid loangrowth, ivar (ccode) time (year) gvar (first_treat) notyet method(ipw)

* results for all tests
estat all

*checking the average effect after 5 years of Eurozone adoption
estat cevent, window(0 5)
*checking the average effect after 10 years of Eurozone adoption
estat cevent, window(0 10)
*checking the average effect after 15 years of Eurozone adoption
estat cevent, window(0 15)


estat event
* Event plot
csdid_plot, title("Difference in Difference graph")

* generating dummy variable for generating graphs
gen euro = 1
replace euro = 0 if Country=="United Kingdom"
replace euro = 0 if Country=="Bulgaria"
replace euro = 0 if Country=="Croatia"
replace euro = 0 if Country=="Czech Rep"
replace euro = 0 if Country=="Hungary"
replace euro = 0 if Country=="Poland"
replace euro = 0 if Country=="Romania"
replace euro = 0 if Country=="Sweden"

* twoway graph for Eurozone countries
xtline loangrowth if euro == 1, overlay t(year) i(Country) title(Loan Growth for Eurozone countries)

* twoway graph for Non-Eurozone countries
xtline loangrowth if euro == 0, overlay t(year) i(Country) title(Loan Growth for Non-Eurozone countries)

*generating post dummy variable for summary statistics
gen post =0
replace post = 1 if Country=="United Kingdom" & year>=1999
replace post = 1 if Country=="Bulgaria" & year>=1999
replace post = 1 if Country=="Croatia" & year>=1999
replace post = 1 if Country=="Czech Rep" & year>=1999
replace post = 1 if Country=="Hungary" & year>=1999
replace post = 1 if Country=="Poland" & year>=1999
replace post = 1 if Country=="Romania" & year>=1999
replace post = 1 if Country=="Sweden" & year>=1999

replace post = 1 if Country=="Austria" & year>=1999
replace post = 1 if Country=="Belgium" & year>=1999
replace post = 1 if Country=="Finland" & year>=2002
replace post = 1 if Country=="France" & year>=2002
replace post = 1 if Country=="Germany" & year>=1999
replace post = 1 if Country=="Greece" & year>=2002
replace post = 1 if Country=="Ireland" & year>=2002
replace post = 1 if Country=="Italy" & year>=2002
replace post = 1 if Country=="Luxembourg" & year>=1999
replace post = 1 if Country=="Netherlands" & year>=1999
replace post = 1 if Country=="Portugal" & year>=2002
replace post = 1 if Country=="Spain" & year>=2002
replace post = 1 if Country=="Cyprus" & year>=2008
replace post = 1 if Country=="Estonia" & year>=2011
replace post = 1 if Country=="Latvia" & year>=2014
replace post = 1 if Country=="Lithuania" & year>=2015
replace post = 1 if Country=="Malta" & year>=2008
replace post = 1 if Country=="Slovak Rep" & year>=2009
replace post = 1 if Country=="Slovenia" & year>=2007

*summary statistics for loangrowth
sort euro post
by euro post: eststo: estpost summarize loangrowth
esttab using Table1.doc, replace label main(mean) mtitle("Non-Euro Pre" "Non-Euro Post" "Euro Pre" "Euro Post")


*log close
