/****************************************************************/
/*    NAME: kalperinon.sas                                      */
/*   TITLE: Remove trend from rates with Kalman filter then     */
/*          apply the periodogram with truncating or tapering   */
/*          (two-stage approach)                                */
/*                                                              */
/*   PROCS: GPLOT, SPECTRA, IML                                 */
/*    DATA: MONICA (data.malerate)                              */
/*  AUTHOR: AGB                                                 */
/*    DATE: 3/Feb/2020                                          */
/*    USES: kalsmooth.sas                                       */
/*                                                              */
/****************************************************************/

libname data "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files\data";
%let library=U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files; * Change this library to match your file structure. Make sure the three files called in the next three lines are put there;
%inc "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files\formats.sas"; * ;
%inc "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files\fkappas.sas"; * Include spectral test program;
%inc "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\updated_files\kalsmooth.sas"; * Macros to estimate smooth trend;
%inc "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files\ingamrnd.sas"; * Macros to estimate smooth trend;
options nodate mprint symbolgen notes;
footnote1 &sysdate., &systime.;

** Set up data;
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

* Fit non-linear trend using Kalman filter;
options nonotes nomprint nosymbolgen; *<-reduce output to log;
%runfil(cent=10, repunit=99, taurat=300); * smaller tau ratio gives more flexible trend;
options notes mprint symbolgen; *<-return output to log;


goptions reset=all;
%macro perisers(cent,repunit,var);
data work.centre;
   set work.res; * Use residuals from smooth above; 
   if centre=&cent. and runit in (&repunit.); 
run;
proc spectra data=work.centre out=work.peri p adjmean;
   by centre runit;
   var errs;
run;
* Get the variance for standardising;
proc univariate data=work.centre noprint;
   var errs;
   output out=work.errvar var=errvar;
run;
* Estimate the spectrum & standardise the periodogram;
proc iml;
   use work.peri var{centre runit period freq p_01};
   read all;
   use work.errvar var{errvar};
   read all;
   n=nrow(centre);
   pi=arcos(0)*2;
   s_01=J(n,1,0);
   h=4; * Bandwidth;
   p_01=p_01/2; * <- Correctly scale SAS periodogram;
   p_01=p_01/errvar; * Scale by error variance to give standard area across centres;
* Calculate weights;
   weight=J(1,h+h+1,0);
   do count=-h to h;
*      weight[1,count+h+1]=(h-abs(count))/h; * Triangular window;
      weight[1,count+h+1]=0.5*(1+cos(pi*count/h)); * Hanning window;
   end;
   sumw=weight*J(h+h+1,1,1);
* Mirror the data at the edges;
   head=J(h,1,0); tail=J(h,1,0);
   do count=0 to h-1;
      head[count+1,1]=p_01[h-count+1,1];
      tail[count+1,1]=p_01[n-count-1,1];
   end;
   pm_01=head//p_01//tail;
   do count=1 to n;
      s_01[count,1]=(weight*pm_01[h+count-h:h+count+h])/sumw;
   end;
* Output data;
   toout=centre||runit||period||freq||p_01||s_01;
   varnames={'centre' 'runit' 'period' 'freq' 'p_01' 's_01'};
   create work.spec from toout[colname=varnames];
   append from toout;
quit;
*goptions reset=all ftext=centxi htext=3 gunit=pct colors=(black) border;
filename graph1 "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\updated_files\plots\sp&cent._&repunit..eps";
goptions reset=all ftext=centxi htext=3 gunit=pct colors=(black) gunit=pct noborder
    gsfname=graph1 noprompt gsfmode=replace device=PSLEPSF fontres=presentation dash;
symbol1 i=join color=grey value=NONE line=1;
symbol2 i=join color=black value=NONE line=2 width=4;
*legend1 value=(f=greek 'I(w)' 's(w)') label=NONE position=(top right inside) across=1 mode=share;
* Axes for period;
axis1 minor=NONE label=('Period') major=(h=2.5) order=(2 to 24 by 2) value=(h=2.5); *<-period;
axis2 minor=NONE label=(a=90 'I(f)') major=(h=2.5) value=(h=2.5); *<I(w);
%cntrname(&cent.,&repunit.);
title; * No title for final output;
data work.chop;
   set work.spec;
   if freq>0;
run;
proc gplot data=work.chop;
*   plot p_01*period=1 s_01*period=2 / noframe overlay haxis=axis1 vaxis=axis2 href=12 legend=legend1;
   plot p_01*period=1 / noframe haxis=axis1 vaxis=axis2 href=12; * Just the periodogram;
run; quit;
* Append periodogram data;
proc append base=work.allperi data=work.chop;
run;
%mend perisers;
%perisers(10,99,errs);

* Set up dummy data;
goptions reset=all;
data work.allperi;
   centre=0; runit=0; freq=0; period=0; p_01=0; s_01=0;
run;
%callcent(perisers,errs);
*%callcenf(perisers,errs); *<-women, excludes Switzerland;
* Remove dummy data;
data work.allperi;
   set work.allperi;
   if centre~=0;
   if period>=2 and period<=24;
run;

* Table of significant frequencies;
%macro gettotab(cent,runit);
data work.centre;
   set data.malefilt;
   if centre=&cent. and runit=&runit.;
run;
* Test the residuals from the fit;
%fkappas(work.centre,errs);
data work.select(keep=period);
   set work.res;
*   if gprob<(0.05/12); * Bonferonni adjustment;
   if gprob<(0.05);
run;
data work.addinfo;
   set work.select;
   centre=&cent.; runit=&runit.; dummy=1;
run;
proc transpose data=work.addinfo out=work.oneline(drop=_name_);
   by centre runit;
   var dummy;
   id period;
run;
proc append base=work.totable data=work.oneline force;
run;
%mend gettotab;
data work.totable;
   centre=0; runit=0; _12=0; _44=0; _6=0; _2=0;
run;
* Macro to call centres and reporting units;
   %gettotab(10,99);
   %gettotab(11,99);
   %gettotab(12,1);
   %gettotab(12,2);
   %gettotab(15,1);
   %gettotab(17,1);
   %gettotab(18,99);
   %gettotab(19,1);
   %gettotab(20,2);
   %gettotab(20,3);
   %gettotab(20,6);
   %gettotab(23,99);
   %gettotab(24,99);
   %gettotab(26,99);
   %gettotab(28,99);
   %gettotab(32,99);
   %gettotab(33,1);
   %gettotab(34,1);
   %gettotab(35,99);
   %gettotab(36,99);
   %gettotab(37,1);
   %gettotab(39,3);
   %gettotab(40,1);
   %gettotab(43,99);
   %gettotab(45,1);
   %gettotab(46,97);
   %gettotab(46,98);
   %gettotab(49,1);
   %gettotab(50,1);
   %gettotab(50,3);
   %gettotab(54,1);
   %gettotab(55,1);
   %gettotab(57,1);
   %gettotab(59,1);
   %gettotab(60,99);
