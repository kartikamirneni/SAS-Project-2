*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding graduation numbers and rates for various California High
Schools.

Dataset Name: Graduates_analytic_file created in external file
STAT6250-02_w18-team-3_project2_data_preparation.sas, which is assumed to be
in the same directory as this file.

See included file for dataset properties
;

* environmental setup;

* set relative file import path to current directory (using standard SAS trick);
X "cd ""%substr(%sysget(SAS_EXECFILEPATH),1,%eval(%length(%sysget(SAS_EXECFILEPATH))-%length(%sysget(SAS_EXECFILENAME))))""";


* load external file that generates analytic dataset cde_2014_analytic_file;
%include '.\STAT6250-01_w18-team-3_project2_data_preparation.sas';


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What is the number of white students graduating in Alameda in each year?'
;

title2
'Rationale: This help identifies the progress of students in terms of education on a yearly basis.'
;

footnote1
"This gives us the difference in the number of white students graduating each year."
;

footnote2
"One can analyze the reason for the drop in the number of graduates in the following year and take measures to increase the number of graduates in the coming year."
;

*
Note: This adds the values in column "WHITE" from Grads1314 and Grads1415 
combined together in dataset r1.

Methodology: When combining the files Grads1314 and Grads1415 in data,
select the sum of white students graduated each year and group by Alameda
county and year.

Limitations: We don't really know if schools kept the same amount of students 
per year. It's possible that a school could have increased the number of
students it instructs which could increase the amount of graduates even if
it's at a lower rate.

Followup Steps: Possibly check if the total number of students increased for
the county in terms of total students enrolled.
;

proc sql;
	select county,year,sum(white)as Total_White_Students
	from r1 where county="Alameda" 
	group by county,year;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What is the number of hispanic students graduated in 2 years county wise?'
;

title2
'Rationale: This would generate a population estimate of graduating hispanic students depending on each county.'
;

footnote1
"We see there is randomness in the number of students in each county, there is no normal distribution of hispanic students county wise."
;

footnote2
"Based on this, one can conduct a study in discrepancy of population distribution and determine as to why some counties have higher hispanic students and some lower. Then, work on to increase number of students in counties where there is very low population."
;

*
Note: This adds the values in column "HISPANIC" from Grads1314 and Grads1415 
combined together in dataset r1.

Methodology: Use PROC SQL to find the sum of hispanic students of both years
using the combined dataset and then group by counties to get an estimate of
student distribution over different county.

Limitations: We can't find out percentage of hispanic students graduating 
with top scores.We can only assume they graduate without knowing their
scores.

Followup Steps: Check the counties with the highest number of student
graduation rates and check to see if they graduate with high percentage
or just graduate.
;

proc sql;
	select county,sum(hispanic) as Hispanic_stud_grad
	from r1 group by county;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: What is the number of schools in each year ?'
;

title2
'Rationale: Get a population estimate of graduating students in each county so as to acquire related resources.'
;

footnote1
"This helps to know that one needs more data as to know why the number of schools decreased in the following year."
;

footnote2
"More research on each school which is not in the following year is required to determine if it was closed down or why it was not included in the list."
;

footnote3
"Deep research could be done on the schools if they were closed so that it does not happen with other schools."
;

*
Note: This uses the column "SCHOOL" from Grads1314 and Grads1415 
and determines their sum independently to compare total number of schools.

Methodology: Use PROC SQL to print out the sum of the number of schools
per year in the 2 data files Grads1314 and Grads1415.

Limitations: Difficult to find which schools are not in the list.

Followup Steps: See which year has lower number of schools and focus
resources on the ones which might have been closed due to unfortunate
circumstances and try to open them up for education and take in students.
;

proc sql;
	select count(school) as Total_Schools_1314
	from grads1314_raw_sorted;
	select count(school) as Total_Schools_1415
	from grads1415_raw_sorted;
run;

title;
footnote;
