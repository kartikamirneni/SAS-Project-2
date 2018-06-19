*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding graduates at CA public high schools

Dataset Name: grads1314, grads1415 created in external file
STAT6250-01_w18-team-3_project2_data_preparation.sas, which is assumed to be
in the same directory as this file

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic datasets cde_2014_analytic_file,
  cde_2014_analytic_file_sort_frpm, and cde_2014_analytic_file_sort_sat;
%include '.\STAT6250-01_w18-team-3_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Which racial group has the most drop-out students?'
;

title2
'Rationale: We can observe whether there is difference among different racial groups in terms of dropout rates.'
;

footnote1
"Hispanic has the highest number of drop-outs, followed by white. Although a ratio rate would be more sensible, however a minority with such high drop-outs that is higher than majority (white) indicates some issues."
;

*
Note: This compares the column "HISPANIC", "AM_IND", "ASIAN", "PAC_ISLD", 
"FILIPINO", "AFRICAN_AM", "WHITE", "TWO_MORE_RACES", "NOT_REPORTED" from 
grads1314 to the column of the same name from grads1415.


Methodology: Use PROC SQL to get the total drop-outs for each racial group.

Limitations: the size of population of a certain racial group matters, counting 
by ratio rate instead of number of drop-outs will be more reasonable.

Followup Steps: The datasets has no information on total number of students by 
race, we need do more research to find out each shcoool's demographics.
;

proc print
    data=by_race;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Does the total drop-outs consistent to the gradrates table? (If total drop-outs by race is equivalent to total drop-outs by grade to check data discrepancy.)'
;

title2
'Rationale: This can help detect if different datasets have data discrepancy in them, and we can also utilized it to find out which school has the highest discrepancy rate.'
;

footnote1
"As we can see, Los Angeles Unified Alternative Education has the highest discrepancy rate, and followed by Granada Hills Charter High."
;

*
Note: This compares the column "HISPANIC", "AM_IND", "ASIAN", "PAC_ISLD", 
"FILIPINO", "AFRICAN_AM", "WHITE", "TWO_MORE_RACES", "NOT_REPORTED" from 
grads1314 & grads1415 to the column "D9", "D10", "D11", "D12" from gradrates.

Methodology: Merge 13-14 year dataset to gradrates dataset and compare the total
drop-outs by race and the total drop-outs by grade, get the difference and sort
them from highest to lowest.

Limitations: We only see the data from the three datasets, there is not enough 
information.

Followup Steps: Need do more research on the data, to get more information to
ensure our data is correct.
;

proc print data=discrepancy1314(obs=10);
run;

proc print data=discrepancy1415(obs=10);
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What grade has the highest number of dropouts?'
;

title2
"Rationale: We will be able to observe which grade will most dropout students decide to forgo their education from the result."
;

footnote1
"12th Grade has suprisingly high drop-outs which is more than twice of 9th and 10th grade."
;

footnote2
"9th grade has more drop-outs than 10th grade, but not by a large amount of difference. Especially when there could be data entry error or some other anomaly exist. We can verify if the assumption hihger grade cause higher drop-outs is true by using statistical hypothesis testing."
;

footnote3
"My inference is as grade ranks hihger, the materials will get more difficult. People barely passed their class last year won't be able to pass this year.";
;

*
Note: This compares the column "D9", "D10", "D11", "D12" from gradrates.

Methodology: Use PROC SQL to get the total drop-outs for each grade. 

Limitations: There is no more information to investigate further for the reason 
why 12th grade has the most drop-outs.

Followup Steps: We should research for more data so that we can make a better 
inference.
;

proc print data=by_grade;
run;

title;
footnote;

