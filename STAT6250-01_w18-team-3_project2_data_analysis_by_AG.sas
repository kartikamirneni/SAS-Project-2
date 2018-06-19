*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

*
This file uses the following analytic dataset to address several research
questions regarding graduation numbers and rates for various California High
Schools.

Dataset Name: Graduates_analytic_file created in external file
STAT6250-01_w18-team-3_project2_data_preparation.sas, which is assumed to be
in the same directory as this file

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
'Research Question: Which schools have the highest number of graduates in years 2013-14 and 2014-15?'
;

title2
'Rationale: This helps one to determine the schools having high graduation as they are an indicator of excellent resources.'
;

footnote1
'We have output for the the top 10 California High School for the 2013-14 and 2014-15 academic years.'
;

footnote2 
'This shows that all 10 schools have more than 1000 students graduating which depicts the efficiency of schools .'
; 

footnote3
'Los Angeles and Orange County has the highest number of graduates in both academic years starting from 894 and going up to 1070,The LA County and Orange County have the most graduated maybe due to the strong academic polices they have in place compared to other districts.'
;

*
Note: In the data mt12 which is a combination of grads1314_raw_sorted
and grads1415_raw_sorted we are taking the max of the column "TOTAL"
which is a represenation of total number graduates from each school . 

Methodology: In this Step we used proc sql to find the highest number of 
student graduates from top 10 schools.

Limitations: We are not sure of the criteria used to determine the 
top 10 schools have the highest number of graduates.

Followup Steps: We need more evidence in terms of resources available 
in the schools to find out how the schools are producing high
number of graduates.
;

proc print
        data = mt12 (obs=10) noobs label
    ;
    var
    	school
        county
	district
	year
   	total
    ;
    label
    	school='School'
     	county='County'
     	district='District'
	year='Year'
   	total='Total number of graduates'
    ;
    format
    	total comma12.
    ;
run;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: How many total districts are listed each Academic year 2013-2014 and 2014-2015 ?'
;

title2
'Rationale: If there is any difference, we can determine why there are less districts in a specific year.'
;

footnote1
'The total count of district listed Academic Year 2013-2014 was 2495 and in the Academic Year 2014-2015 the total count of District listed was 2490.'
;

footnote2
'In 2014-2015 Academic Year 5 Districts were off list from the total number of districts listed In the Academic Year 2013-2014  .'
;

footnote3
'This can happen maybe because the California State is big and maybe the districts merged toghther or were left out of the list because they were not deemed important.'
;

*
Note: This makes use of "district " column from the grads1314_raw_sorted
data set and grads1415_raw_sorted data set.

Methodology:  Use PROC Sql in "district" column to examine
the total number of districts in each academic year.

Limitations: It is hard to analyze data why there were less districts 
in the following year without some more columns in dataset pertaining
to details of district.

Followup Steps: We need to predict if the same trend will continue or
will the number of districts remain the same or will they increase.
;

proc sql;
	select year "Year", count(district) as Total_Districts 
	"Total Districts" format comma12.
	from grads1314_raw_sorted
	union
	select year, count(district) as Total_Districts
	from grads1415_raw_sorted
	;
	
   
quit;

title;
footnote;


*******************************************************************************;
* Research Question Analysis Starting Point;
*******************************************************************************;

title1
'Research Question: Which School has the highest number of students not reported in terms of race ?'
;

title2
'Rationale: this one will give the management an idea to work on finding the nationality of students.'
;

footnote1
'in the 2013-14 academic year Los Angeles United Alternative Education had 248 number of students not reported and in the 2014-15 academic year Muir charter had 56..'
;

footnote2
'This reveals that Los Angeles Unified Alternative Education has to be more hard working in finding out the nationality of students in order to be more diverse in their teaching and learn their culture to be more understanding their needs.'
;

footnote3
'The reason for this could be that some students donot want to disclose their race or they donnot identify with the races listed as options for them to chose from .'
;

*
Note: This lists the school which has the maximum number
of students whose race is not reported .

Methodology: Use proc Sql to list the school and the max 
function to select the school which has the maximum number
of students whose race is not reported from both years.

Limitations: There is not much to go on as to why there was such
high cases of not reported.One can launch an investgation into the school
and find out the reasons for the same


Followup Steps: We can further analyze the data as to why the school
missed so many students to catgorize into the race and personally
interview the students to determine their nationality.
;

proc sql;
	select year "Year", school "School", not_reported "Not reported"
	from grads1314_raw_sorted 
	where not_reported=(select max(not_reported)
	from grads1314_raw_sorted) union 
	select year, school, not_reported from grads1415_raw_sorted 
	where not_reported=(select max(not_reported)
	from grads1415_raw_sorted)
	;
		
quit;

title;
footnote;
