*******************************************************************************;
**************** 80-character banner for column width reference ***************;
* (set window width to banner width to calibrate line length to 80 characters *;
*******************************************************************************;

* 
[Dataset 1 Name] Grads1314

[Experimental Unit Description] High Schools within California

[Number of Observations] 2495

[Number of Features] 15

[Data Source] http://dq.cde.ca.gov/dataquest/dlfile/dlfile.aspx?cLevel=School&cYear=2013-14&cCat=GradEth&cPage=filesgrad.asp
We followed the link for the California Department of Education datasets and 
found this one for California high school graduate information. After 
downloading the text file, the information was copied and pasted into Excel 
for visualization.

[Data Dictionary] http://www.cde.ca.gov/ds/sd/sd/fsgrad09.asp

[Unique ID Schema] CDS_CODE, a 14-digit primary key that is a unique ID for a 
school within California

--

[Dataset 2 Name] Grads1415

[Dataset Description] A dataset containing information for California high 
school graduates by racial/ethnic group and school for the school year 2014 – 
2015.

[Experimental Unit Description] High Schools within California

[Number of Observations] 2490

[Number of Features] 15

[Data Source] http://dq.cde.ca.gov/dataquest/dlfile/dlfile.aspx?cLevel=School&cYear=2014-15&cCat=GradEth&cPage=filesgrad.asp
We followed the link for the California Department of Education datasets and 
found this one for California high school graduate information. After 
downloading the text file, the information was copied and pasted into Excel 
for visualization.

[Data Dictionary] http://www.cde.ca.gov/ds/sd/sd/fsgrad09.asp

[Unique ID Schema] CDS_CODE, a 14-digit primary key that is a unique ID for 
a school within California

--

[Dataset 3 Name] GradRates

[Experimental Unit Description] High Schools within California

[Number of Observations] 7543

[Number of Features] 11

[Data Source] http://dq.cde.ca.gov/dataquest/dlfile/dlfile.aspx?cLevel=All&cYear=0910&cCat=NcesRate&cPage=filesncesrate
We followed the link for the California Department of Education datasets and 
found this one for California high school graduate rates. After 
downloading the text file, the information was copied and pasted into Excel 
for visualization.

[Data Dictionary] http://www.cde.ca.gov/ds/sd/sd/fsncesrate.asp

[Unique ID Schema] CDS_CODE, a 14-digit primary key that is a unique ID for a school within California.
;

* environmental setup;

* setup environmental parameters;
%let inputDataset1URL =
https://github.com/stat6250/team-3_project2/blob/master/data/Grads1314.xlsx?raw=true
;
%let inputDataset1Type = XLSX;
%let inputDataset1DSN = grads1314_raw;

%let inputDataset2URL =
https://github.com/stat6250/team-3_project2/blob/master/data/Grads1415.xlsx?raw=true
;
%let inputDataset2Type = XLSX;
%let inputDataset2DSN = grads1415_raw;

%let inputDataset3URL =
https://github.com/stat6250/team-3_project2/blob/master/data/GradRates.xlsx?raw=true
;
%let inputDataset3Type = XLSX;
%let inputDataset3DSN = gradrates_raw;


* load raw datasets over the wire, if they doesn't already exist;
%macro loadDataIfNotAlreadyAvailable(dsn,url,filetype);
    %put &=dsn;
    %put &=url;
    %put &=filetype;
    %if
        %sysfunc(exist(&dsn.)) = 0
    %then
        %do;
            %put Loading dataset &dsn. over the wire now...;
            filename tempfile "%sysfunc(getoption(work))/tempfile.xlsx";
            proc http
                method="get"
                url="&url."
                out=tempfile
                ;
            run;
            proc import
                file=tempfile
                out=&dsn.
                dbms=&filetype.;
            run;
            filename tempfile clear;
        %end;
    %else
        %do;
            %put Dataset &dsn. already exists. Please delete and try again.;
        %end;
%mend;
%loadDataIfNotAlreadyAvailable(
    &inputDataset1DSN.,
    &inputDataset1URL.,
    &inputDataset1Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset2DSN.,
    &inputDataset2URL.,
    &inputDataset2Type.
)
%loadDataIfNotAlreadyAvailable(
    &inputDataset3DSN.,
    &inputDataset3URL.,
    &inputDataset3Type.
)
;


* sort and check raw datasets for duplicates with respect to their unique ids,
  removing blank rows, if needed;
proc sort
        nodupkey
        data=grads1314_raw
        dupout=grads1314_raw_dups
        out=grads1314_raw_sorted(where=(not(missing(CDS_Code))))
    ;
    by
       CDS_Code
    ;
run;
proc sort
        nodupkey
        data=grads1415_raw
        dupout=grads1415_raw_dups
        out=grads1415_raw_sorted
    ;
    by
        CDS_Code
    ;
run;
proc sort
        nodupkey
        data=gradrates_raw
        dupout=gradrates_raw_dups
        out=gradrates_raw_sorted
    ;
    by
        CDS_CODE
    ;
run;


* Combine grads1314 & grads1415 vertically;
data grads1315;
    set grads1314_raw_sorted grads1415_raw_sorted;
    by CDS_Code;
run;

* Create a table of total counts of drop-outs for each racial group;
proc sql;
    create table by_race as
        select sum(hispanic) as hispanic_total,
               sum(am_ind) as am_ind_total,
               sum(asian) as asian_total,
               sum(pac_isld) as pac_isld_total,
               sum(filipino) as filipino_total,
               sum(african_am) as african_am_total,
               sum(white) as white_total,
               sum(two_more_races) as two_more_races_total,
               sum(not_reported) as not_reported_total      
        from grads1315;
quit;



* Merge two datasets, and get difference between two varaibles;
data consistency1314 (keep=CDS_Code school grade_total race_total discrepancy);
    length school $100. district $100.;
    merge grads1314_raw_sorted(in=c)
          gradrates_raw_sorted(in=s);
    by CDS_Code;
    grade_total = sum(D9, D10, D11, D12);
    race_total = sum(hispanic, am_ind, asian, pac_isld, filipino, african_am,
    white, two_more_races, not_reported);
    discrepancy = abs(grade_total - race_total);
    if c=1 and s=1;
run;

proc sort
    data=consistency1314
    out=discrepancy1314;
    by descending discrepancy;
run;


* Merge two datasets, and get difference between two varaibles;
data consistency1415 (keep=CDS_Code school grade_total race_total discrepancy);
    length school $100. district $100.;
    merge grads1415_raw_sorted(in=c)
          gradrates_raw_sorted(in=s);
    by CDS_Code;
    grade_total = sum(D9, D10, D11, D12);
    race_total = sum(hispanic, am_ind, asian, pac_isld, filipino, african_am,
    white, two_more_races, not_reported);
    discrepancy = abs(grade_total - race_total);
    if c=1 and s=1;
run;

proc sort
    data=consistency1415
    out=discrepancy1415;
    by descending discrepancy;
run;

* Use PROC SQL to create a table finding the drop-outs across different grades;
proc sql;
    create table by_grade as
        select sum(D9) as D9_total,
               sum(D10) as D10_total,
               sum(D11) as D11_total,
               sum(D12) as D12_total
        from gradrates_raw_sorted;
quit;

*combine datasets and use proc sql to calculate total number
of white students graduating in alameda county in each of
the 2 years;

data r1;
	merge grads1314_raw_sorted grads1415_raw_sorted;
	by YEAR;
run;
  
  
*set up for AG Question 03,we are using this dataset to
 arrange the value of droupout in descnding order;

; 
proc sort
       data = gradrates_raw_sorted
       out = min_Desc
   ;
   by
       descending  D9 D10 D11 D12
   ;
run;

 *set up for AG Question 01,we are using this dataset to
 highest number of graduates in school;

data M_T;
	merge grads1314_raw_sorted grads1415_raw_sorted;
	by YEAR;
run;

proc sort
       data = M_T
       out = mt12
   ;
   by
       descending  total
   ;
run;



