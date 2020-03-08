/****************************************************************/
/*    NAME: export_to_csv.sas                                   */
/*   TITLE: Export the SAS data to csv files                    */
/*    DATE: 2020-01-31                                          */
/*  AUTHOR: Adrian Barnett (a.barnett@qut.edu.au)               */
/*                                                              */
/****************************************************************/

* Libnames and options;
libname data "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files\data";

proc export data=data.summonth dbms=CSV
  outfile="summonth.csv"
  replace;
run;
proc export data=data.all dbms=CSV
  outfile="all.csv"
  replace;
run;
proc export data=data.sumsex dbms=CSV
  outfile="sumsex.csv"
  replace;
run;
