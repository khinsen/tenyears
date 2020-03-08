/****************************************************************/
/*    NAME: rerun_MONICA_combined_warsaw.sas                     */
/*   TITLE: Computational replication of the MONICA seasonal    */
/*          analysis using the combined approach                */
/*    DATA: Warsaw centre in MONICA data                         */
/*  AUTHOR: Adrian Barnett (a.barnett@qut.edu.au)               */
/*     REF: Barnett and Dobson, Stats in Medicine 2004          */ 
/*          DOI: 10.1002/sim.1927                               */
/****************************************************************/

options nodate mprint symbolgen;
libname data "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files\data";
%let library=U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files; * Change this library to match your file structure. Make sure the three files called in the next three lines are put there;
%inc "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\updated_files\kalfil_macros.sas"; * macros to run kalman filter;
%inc "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\updated_files\bootstrap_periodogram_test.sas"; * macros to run seasonal test;

*** PREPARE DATA ***;
* Combine fatal and non-fatal event rate for men;
proc summary data=data.malerate nway;
   class centre runit year mthonset;
   var ratestd; 
   output out=work.sumevent(drop=_type_ _freq_) sum=ratestd;
run;
* One centre;
data work.datatorun;
   set work.sumevent(rename=(ratestd=var)); *rename for macro;
   if centre=36 then output work.datatorun; * select warsaw data; 
run;
data work.datatorun;
   set work.datatorun;
   retain dummy 1 time 0;
   time = time +1;
run;

*** ANALYSIS ***;
* Start with annual cycle;
options nonotes nomprint nosymbolgen; *<-reduce output to log;
%runfil(k=1, freq1=12, freq2=-99, freq3=-99, freq4=-99, freq5=-99, MCMC=5000, burn=500);
options notes mprint symbolgen; *<-restore output to log;

%boottest; * Test the residuals for remaining seasonal structure;

* Add a cycle of 6 based on the periodogram test (large spike);
options nonotes nomprint nosymbolgen; *<-reduce output to log;
%runfil(k=2, freq1=12, freq2=6, freq3=-99, freq4=-99, freq5=-99, MCMC=5000, burn=500);
options notes mprint symbolgen; *<-restore output to log;

%boottest; * Test the residuals for remaining seasonal structure;

* Add a cycle of 3.4 based on the periodogram test (large spike);
options nonotes nomprint nosymbolgen; *<-reduce output to log;
%runfil(k=3, freq1=12, freq2=6, freq3=3.4, freq4=-99, freq5=-99, MCMC=5000, burn=500);
options notes mprint symbolgen; *<-restore output to log;

%boottest; * Test the residuals for remaining seasonal structure;
* Small spike at 2.8;

*** PLOTS ***;
* a) Trend and CI;
filename graph1 "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\updated_files\plots\trend_combined_warsaw.eps";
goptions reset=all ftext=centx htext=3 gunit=pct colors=(black) gunit=pct noborder
    gsfname=graph1 noprompt gsfmode=replace device=PSLEPSF fontres=presentation dash;
symbol1 i=join value=NONE color=black; *<-decrease trend (usually red);
symbol2 i=join line=2 value=NONE color=black; *<-decrease trend (usually red);
symbol3 i=join value=NONE color=dagray; *<-data (dagray for B/W); 
*title; 
axis1 minor=NONE label=NONE;
axis2 minor=NONE label=(a=90 'Data') order=(20 to 80 by 10);
legend1 label=NONE value=('Trend' 'Lower CI' 'Upper CI' 'Observed') position=(top right inside) across=1;
proc gplot data=work.posterior;
   plot postmean*time=1 trend2_5*time=2 trend97_5*time=2 data*time=3 / overlay haxis=axis1 vaxis=axis2 noframe legend=legend1;
run; quit;
* b) Trend, 12-month season and observed data;
data work.posterior;
   set work.posterior;
   year = 84+ (time-1)/12; * add back year;
run;
filename graph1 "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\updated_files\plots\estimates_combined_warsaw.eps";
goptions reset=all ftext=centx htext=3 gunit=pct colors=(black) gunit=pct noborder
    gsfname=graph1 noprompt gsfmode=replace device=PSLEPSF fontres=presentation dash;
axis1 minor=NONE label=('Year');
axis2 minor=NONE label=(a=90 'CHD event rate per 100,000') order=(20 to 80 by 10);
symbol1 color=black line=1 width=3 i=join value=none;
symbol2 color=grey line=1 width=3 i=join value=none;
symbol3 color=black line=2 width=3 i=join value=none;
proc gplot data=work.posterior;
   plot postmean*year=1 data*year=2 meanseas1*year=3  / overlay haxis=axis1 vaxis=axis2 noframe nolegend;
run; quit;
