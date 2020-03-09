/****************************************************************/
/*    NAME: rerun_MONICA_twostage_belfast.sas                   */
/*   TITLE: Computational replication of the MONICA seasonal    */
/*          analysis using the two-stage approach               */
/*    DATA: Belfast centre in MONICA data                       */
/*  AUTHOR: Adrian Barnett (a.barnett@qut.edu.au)               */
/*     REF: Barnett and Dobson, Stats in Medicine 2004          */ 
/*          DOI: 10.1002/sim.1927                               */
/****************************************************************/
* Start with k=0 and use bootstrap test to add seasonal components at the appropriate frequency;
* Use delta=1/12 as the data is monthly;
* The input data should be called 'work.datatorun' with time series variable 'var' and time 'time';

options nodate mprint symbolgen;
libname data "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files\data";
%let library=U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files; * Change this library to match your file structure. Make sure the three files called in the next three lines are put there;
%inc "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\updated_files\kalsmooth.sas"; * Macros to estimate smooth trend using Kalman filter;
%inc "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files\ingamrnd.sas"; * Macro for inverse gamma used by kalsmooth;
%inc "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\updated_files\bootstrap_periodogram_test.sas"; * macros to run seasonal test;

*** DATA ***;
* Combine fatal and non-fatal event rate for men;
proc summary data=data.malerate nway;
   class centre runit year mthonset;
   var ratestd; 
   output out=work.sumevent(drop=_type_ _freq_) sum=ratestd;
run;
data work.addtime(rename=(year=yronset)); * Add simple equally spaced time index;
   set work.sumevent;
   retain time 0;
   by centre runit;
   if first.runit then time=0;
   time=time+1;
run;
* data set for tapering;
data work.taper(drop=year mth);
   set work.addtime(keep=centre runit);
   by centre runit;
   retain time 0;
   if first.runit;
   time=0;
   do year=1 to 10;
      do mth=1 to 12;
	     time=time+1;
		 errs=0;
		 output;
	  end;
   end;
run;   

*** ANALYSIS ***;
* Fit non-linear trend using Kalman filter without season;
options nonotes nomprint nosymbolgen; *<-reduce output to log;
%runfil(cent=34, repunit=1, taurat=900); * smaller tau ratio gives more flexible trend;
options notes mprint symbolgen; *<-return output to log;
data work.posterior;
  set work.res;
  retain time 0;
  time = time + 1; * add back time;
  dummy=1;
run;
%boottest; * Test residuals;

*** FIGURES ***;
* Save figure 1 for paper;
filename graph1 "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\updated_files\plots\periodogram_twostage_belfast.eps";
goptions reset=all ftext=centx htext=3 gunit=pct colors=(black) gunit=pct noborder
    gsfname=graph1 noprompt gsfmode=replace device=PSLEPSF fontres=presentation dash;
symbol1 color=black value=NONE i=join line=2 width=4;
symbol2 color=black value=NONE i=join;
axis1 minor=NONE label=(h=3 ' ') order=(2 to 24 by 2); *<-period;
axis2 minor=NONE label=(h=3 a=90 ' '); *<-amplitude;
proc gplot data=work.actual;
   plot py*period=1 r*period=2 / overlay noframe haxis=axis1 vaxis=axis2;
* Subscripts;
   note m=(45,1.5)pct h=3 'Period (f' m=(-0.6,-.75) h=1.75 'j';
   note m=(62.0,1.5) h=3 ')';
   note m=(3,54.5)pct h=3 angle=90 '^';
   note m=(3.25,55) angle=90 h=3  'a';
   note m=(4,56.5) angle=90 h=1.75  'j';
run; quit;
filename graph1 "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\updated_files\plots\trend_twostage_belfast.eps";
goptions reset=all ftext=centx htext=3 gunit=pct colors=(black) gunit=pct noborder
    gsfname=graph1 noprompt gsfmode=replace device=PSLEPSF fontres=presentation dash;
symbol1 i=join value=NONE color=black; *<-decrease trend (usually red);
symbol2 i=join line=2 value=NONE color=black; *<-decrease trend (usually red);
symbol3 i=join value=NONE color=dagray; *<-data (dagray for B/W); 
axis1 minor=NONE label=('Year');
axis2 minor=NONE label=(a=90 'CHD Rate per 100,000') order=(30 to 100 by 10);
proc gplot data=work.posterior;
   plot trend*yrmon=1 p2_5*yrmon=2 p97_5*yrmon=2 data*yrmon=3 / overlay haxis=axis1 vaxis=axis2 noframe;
run; quit;
