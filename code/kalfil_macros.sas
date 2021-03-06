/****************************************************************/
/*    NAME: kalfil_macros.sas                                   */
/*   TITLE: Kalman smoother of Time series data with seasonal   */
/*          effects uses AR type model                          */
/*    DATA: Example data generated in program                   */
/*   PROCS: IML, GPLOT, SPECTRA, UNIVARIATE                     */
/*  AUTHOR: Adrian Barnett (a.barnett@sph.uq.edu.au)            */
/*     REF: Barnett and Dobson, Stats in Medicine 2004          */ 
/*                                                              */
/****************************************************************/
* For your own data, start with k=0 and use bootstrap test to add seasonal components at the appropriate frequency;
* Use delta=1/12 if the data is monthly;
* The input data should be called 'work.datatorun' with time series variable 'var' and time 'time';

* Libnames and options;
%inc "&library.\ingamrnd.sas"; * Include the inverse gamma macro;
footnote1 &sysdate., &systime.;

* Macro to run Kalman filter (set with k<=5 seasonal components);
%macro kalfil(f_1,f_2,f_3,f_4,f_5,k,iter); *<-Seasonal components, k and iteration number;
* Forward sweep of Kalman filter;
proc iml;
   use work.datatorun var {var time};
   read all;
   use work.varthetaw var {vartheta %do index=1 %to &k.; w_&index. %end;}; * Read in (vartheta,w) estimates;
   read all;
   n=nrow(var);
   data={0}//var;
   mmm={0}//time;
   k=&k.; * Number of cyclic components;
   w=J(k,1,0); freq=J(k,1,0);
   pi=arcos(0)*2;
   f_j=&f_1.//&f_2.//&f_3.//&f_4.//&f_5.;
   %do index=1 %to &k.; w[&index.,1]=w_&index.; freq[&index.,1]=2*cos(2*pi/f_j[&index.]); %end;
* Seasonal matrix;
   F=repeat({1,0},k+1,1);
   G=J(2*(k+1),2*(k+1),0);
   V=J(2*(k+1),2*(k+1),0);
   delta=1/12; * <- 12 as data is monthly;
   G[1,1]=1; G[1,2]=delta; G[2,2]=1; * Trend; 
   V[1,1]=(delta**3)/3; V[1,2]=(delta**2)/2; V[2,1]=(delta**2)/2; V[2,2]=delta; * Trend variance;
   do index=1 to k;
      G[(2*index)+1,(2*index)+1]=freq[index,1]; 
      G[(2*index)+1,(2*index)+2]=-1; G[(2*index)+2,(2*index)+1]=1; * Seasonal component;
      V[(2*index)+1,(2*index)+1]=w[index,1]**2; * Seasonal variance#1 lambda in paper;
   end;
* Set up empty matrices;
   kk=2*(k+1);
   C_j=J(kk,kk,0);
   do index=1 to kk;
      C_j[index,index]=100; * Vague starting values;
   end;
   a_j=J(kk,n+1,0); p_j=J(kk,n+1,0);
   e_j=J(1,n+1,0); R_j=J(kk,kk,0);
   p_j[1,1]=data[+,1]/n; *<first obs=mean (p_0);
   C_out=J((n+1)*kk*kk,1,0); R_out=J((n+1)*kk*kk,1,0);
   C_out[1:kk*kk,]=shape(C_j,kk*kk,1);
   do t=1 to n; *<- time 0 to n-1;
	  a_j[,t+1]=G*p_j[,t];
	  R_j=(G*C_j*(G`))+V;
	  Q_j=((F`)*R_j*F)+(vartheta**2);
      e_j[,t+1]=data[t+1,1]-(F`*a_j[,t+1]);
      p_j[,t+1]=a_j[,t+1]+(R_j*F*inv(Q_j)*e_j[,t+1]);
      C_j=R_j-(R_j*F*inv(Q_j)*F`*R_j`);
      C_out[(t*kk*kk)+1:((t+1)*kk*kk),]=shape(C_j,kk*kk,1);
      R_out[(t*kk*kk)+1:((t+1)*kk*kk),]=shape(R_j,kk*kk,1);
   end;
* Output data;
   time=(0:n)`;
   toout=time||data||p_j`||a_j`;
   varnames={'time' 'data' %do index=1 %to ((&k.+1)*2); p_j&index. %end; %do index=1 %to ((&k.+1)*2); a_j&index. %end;};
   create work.smoothf from toout[colname=varnames];
   append from toout;
* Output variance matrices in vectors;
   varout=C_out||R_out;
   varnames={'C_j_vec' 'R_j_vec'};
   create work.fvar from varout[colname=varnames];
   append from varout;
quit;

* Backward sweep of Kalman filter;
proc iml;
   use work.smoothf var {time data %do index=1 %to ((&k.+1)*2); p_j&index. %end; %do index=1 %to ((&k.+1)*2); a_j&index. %end;};
   read all;
   use work.fvar var {C_j_vec R_j_vec};
   read all;
   n=nrow(time)-1;
   k=&k.; * Number of cyclic components;
   kk=2*(k+1);
   pi=arcos(0)*2;
   freq=J(k,1,0);
   f_j=&f_1.//&f_2.//&f_3.//&f_4.//&f_5.;
   %do index=1 %to &k.; freq[&index.,1]=2*cos(2*pi/f_j[&index.]); %end;
   p_j=J(kk,n+1,0);
   a_j=J(kk,n+1,0);
   %do index=1 %to 2*(&k.+1); p_j[&index.,1:n+1]=p_j&index.`; a_j[&index.,1:n+1]=a_j&index.`; %end;
* DLM matrices;
   h_j=J(kk,n+1,0); alpha_j=J(kk,n+1,0);
   B_j=J(kk,kk,0); HH_j=J(kk,kk,0);
   F=repeat({1,0},k+1,1);
* Seasonal matrix;
   G=J(2*(k+1),2*(k+1),0);
   delta=1/12;
   G[1,1]=1; G[1,2]=delta; G[2,2]=1; * Trend; 
   do index=1 to k;
      G[(2*index)+1,(2*index)+1]=freq[index,1]; 
      G[(2*index)+1,(2*index)+2]=-1; G[(2*index)+2,(2*index)+1]=1; * Seasonal component;
   end;
* Initial alpha sample;
   C_j=shape(C_j_vec[((n-1)*kk*kk)+1:(n*kk*kk),],kk,kk);
   alpha_out=J(n+1,k+1,0); * Alpha output (trend and seasonal);
   do index=1 to kk;
      alpha_j[index,n+1]=(normal(0)*sqrt(C_j[index,index]))+p_j[index,n+1];
      if mod(index+1,2)=0 then alpha_out[n+1,(index+1)/2]=alpha_j[index,n+1];
   end;
* Iterate backwards in time;
   do t=n to 1 by -1;
      C_j=shape(C_j_vec[((t-1)*kk*kk)+1:(t*kk*kk),],kk,kk);
      R_j=shape(R_j_vec[(t*kk*kk)+1:((t+1)*kk*kk),],kk,kk);
	  B_j=C_j*(G`)*inv(R_j);
	  HH_j=C_j-(B_j*R_j*(B_j`));
	  h_j[,t]=p_j[,t]+(B_j*(alpha_j[,t+1]-a_j[,t+1]));
* Sample alpha_j from a bivariate Normal. Sampling using Cholesky;
      normrnd=J(kk,1,0);
      HH_x=(round(HH_j*100)/100)+0.0001; * Small constant to remove negative variances;
      L=root(HH_x)`;
      do j=1 to kk;
	     normrnd[j,1]=normal(0);
	  end;
      do j=1 to kk;
         alpha_j[j,t]=(L[j,]*normrnd)+h_j[j,t];
		 if mod(j+1,2)=0 then alpha_out[t,(j+1)/2]=alpha_j[j,t];
	  end;
   end;
** Estimate vartheta and w(lambda);
   mse=J(n,1,0);
   alphamse=J(n-1,k,0);
   do t=2 to n+1; *<- 1 to n;
      mse[t-1,1]=(data[t,1]-(F`*alpha_j[,t]))**2;
	  if t>2 then do; * <- 2 to n;
         past=G*alpha_j[,t-1];
	     do index=1 to k;
            alphamse[t-2,index]=(alpha_j[(2*index)+1,t]-past[(2*index)+1,1])**2; 
         end;
      end;
   end;
   b=mse[+,]/2;
   a=(n/2)-1;
   toout=a||b;
   varnames={'a' 'b'};
   create work.vrtinfo from toout[colname=varnames];
   append from toout;
   b=alphamse[+,]/2;
   a=((n-1)/2)-1;
   toout=a||b;
   varnames={'a' %do index=1 %to &k.; b_&index. %end;};
   create work.winfo from toout[colname=varnames];
   append from toout;
* Output data;
   iter=J(n,1,&iter.);
   dummy=J(n,1,1);
   toout=time[2:n+1]||alpha_out[2:n+1,]||data[2:n+1]||iter||dummy; * Remove time 0;
   varnames={'time' 'alpha_j1' %do index=1 %to &k.; alpha&index. %end;  'data' 'iter' 'dummy'};
   create work.smoothb from toout[colname=varnames];
   append from toout;
quit;
* Update vartheta from inverse gamma (calls macro ingamrnd);
%ingamrnd(work.vrtinfo);
data work.vartheta(drop=gamrnd);
   set work.gamup;
   vartheta=sqrt(gamrnd);
run;
%do index=1 %to &k.; 
%ingamrnd(work.winfo(rename=(b_&index.=b)));
data work.w_&index.(drop=gamrnd);
   set work.gamup;
   w_&index.=sqrt(gamrnd);
run;
%end; 
data work.varthetaw;
   merge work.vartheta %do index=1 %to &k.; work.w_&index. %end; ;
   sigma=sqrt((vartheta**2)%do index=1 %to &k.;+(w_&index.**2)%end;);
   iter=&iter.;
run;
* Estimate the amplitude and phase using the periodogram;
* Use periodogram to estimate amplitude and phase;
data work.adddummy;
   set work.smoothb;
   dummy=1;
run;
proc spectra data=work.adddummy out=work.seasest p coef adjmean;
   by dummy;
   var alpha1--alpha&k.;
run;
%do index=1 %to &k.;
   data work.addpinf;
      merge work.seasest work.initial(keep=n dummy);
	  by dummy;
* Merge back in the period information;
      f_1=&f_1.; f_2=&f_2.; f_3=&f_3.; f_4=&f_4.; f_5=&f_5.;
      if (period>=2 and period<=24);
      diff=abs(period-f_&index.); * Get closest frequency to period;
   run;
* Find the closest matching frequency from the periodogram;
   proc sort data=work.addpinf out=work.sortd;
      by dummy diff;
   run;
   data work.ampest&index.(keep=f_&index. amp&index. phase&index.);
      set work.sortd;
      by dummy diff;
      if first.dummy;
      pi=arcos(0)*2;
      amp&index.=sqrt((cos_0&index.**2)+(sin_0&index.**2));
      if cos_0&index.>0 then
         phase&index.=atan((-sin_0&index./cos_0&index.));
      else if (cos_0&index.<0 and sin_0&index.>=0) then
         phase&index.=atan((-sin_0&index./cos_0&index.))+pi;
      else if (cos_0&index.<0 and sin_0&index.<0) then
         phase&index.=atan((-sin_0&index./cos_0&index.))-pi;
   run;
%end;
data work.ampests;
   merge %do index=1 %to &k.; work.ampest&index. %end;;
   iter=&iter.;
run;
%mend kalfil;

** Macro to call Kalman filter repeatedly;
%macro runfil(k,freq1,freq2,freq3,freq4,freq5,MCMC,burn);
* Get initial values for vartheta and w;
proc univariate data=work.datatorun noprint;
   by dummy;
   var var;
   output out=work.initial std=vartheta n=n; * Get initial estimate and n;
run;
data work.varthetaw;
   set work.initial(drop=dummy n);
   %do index=1 %to &k.;
      w_&index.=0.5; * Initial value for seasonal noise (fixed);
*   w_&index.=uniform(0)+0.75; * Initial value for seasonal noise (random);
   %end;
   iter=0;
run;
data work.varthetach;
   set work.varthetaw;
   sigma=0;
run;
data work.ampch; * <- Chain of amplitude estimates;
   %do index=1 %to &k.;
      amp&index.=0; phase&index.=0; f_&index.=0;
   %end;
   iter=0;
run;
data work.trendch; *<- chain of trend and seasonal estimates;
   iter=0; alpha_j1=0; %do index=1 %to &k.; alpha&index.=0; %end; time=0;
run;
* Call Kalman filter;
%do count=1 %to &MCMC.; *<-number of MCMC runs;
   %kalfil(&freq1.,&freq2.,&freq3.,&freq4.,&freq5.,&k.,&count.); 
   proc append base=work.varthetach data=work.varthetaw;
   run;
   proc append base=work.ampch data=work.ampests;
   run;
   proc append base=work.trendch data=work.smoothb(keep=iter alpha_j1 %do index=1 %to &k.; alpha&index. %end; time);
   run;
%end;
* Output sigma information;
data work.burn1;
   set work.varthetach;
   if iter>&burn.; *burn-in;
run;
* Output amplitude information;
data work.burn2;
   set work.ampch;
   if iter>&burn.; *burn-in;
run;
data work.burn;
   merge work.burn1 work.burn2;
   by iter;
run;
data work.burn3;
   set work.trendch;
   if iter>&burn.; *burn-in;
   dummy=1;
run;
** Output sigma and amplitude chains for convergence check using 'coda' in R;
* .out (output) file;
data work.out;
   set work.burn1(in=a keep=sigma iter rename=(sigma=chain)) work.burn2(in=b keep=amp1 iter rename=(amp1=chain));
   retain index 0;
   if a then do; var=1; label='sigma'; end;
   else if b then do; var=2; label='amp'; end;
   index=index+1;
run;
data _null_;
   set work.out;
   by index;
   file "c:\temp\rcoda.out";
   put iter chain;
run;
proc univariate data=work.out noprint;
   by var label;
   var index;
   output out=work.ind min=min max=max;
run;
* .ind (index) file;
data _null_;
   set work.ind;
   file "c:\temp\rcoda.ind";
   put @1 label @7 min @14 max; 
run;
** Plot variance chains;
goptions reset=all;
title "Overall variance MCMC chain";
axis1 order=(0 to &MCMC. by 50) minor=NONE label=NONE;
axis2 label=(a=90 'Variance chains') minor=NONE;
axis3 label=NONE minor=NONE;
symbol1 color=blue value=NONE i=join line=1 width=1;
legend1 value=('vartheta') label=NONE;
proc gplot data=work.varthetach;
   plot vartheta*iter=1 / noframe haxis=axis1 vaxis=axis2 legend=legend1;
run; quit;
goptions reset=all;
title "Seasonal variance MCMC chain(s)";
axis1 order=(0 to &MCMC. by 50) minor=NONE label=NONE;
axis2 label=(a=90 'Variance chain(s)') minor=NONE;
axis3 label=NONE minor=NONE;
symbol1 color=green value=NONE i=join line=1 width=1;
symbol2 color=red value=NONE i=join line=1 width=1;
symbol3 color=yellow value=NONE i=join line=1 width=1;
symbol4 color=orange value=NONE i=join line=1 width=1;
symbol5 color=violet value=NONE i=join line=1 width=1;
legend1 value=(%do index=1 %to &k.; "w_&index." %end;) label=NONE;
proc gplot data=work.varthetach; * Errors;
   plot %do index=1 %to &k.; w_&index.*iter=&index. %end; / overlay noframe haxis=axis1 vaxis=axis3 legend=legend1;
run; quit;
legend1 value=(%do index=1 %to &k.; "amp_&index." %end;) label=NONE;
title "Amplitude MCMC chain(s)";
proc gplot data=work.ampch; * Amplitudes;
   plot %do index=1 %to &k.; amp&index.*iter=&index. %end; / overlay noframe haxis=axis1 vaxis=axis3 legend=legend1;
run; quit;
goptions reset=all;
title "Phase(s)";
proc gchart data=work.burn2; * Phase (less burn in);
   vbar %do index=1 %to &k.; phase&index. %end; / noframe discrete;
   format %do index=1 %to &k.; phase&index. %end; 6.1;
run; quit;
* Sigma/vartheta/w stats;
proc univariate data=work.burn noprint; 
   var sigma;
   output out=work.sigstat mean=meansig std=stdsig;
run;
proc univariate data=work.burn noprint; 
   var vartheta;
   output out=work.vartstat mean=meanvart std=stdvart;
run;
%do index=1 %to &k.; 
* Lambda stats;
proc univariate data=work.burn noprint; 
   var w_&index.;
   output out=work.wstat&index. mean=meanw_&index. std=stdw_&index.;
run;
* Amplitude stats;
proc univariate data=work.burn noprint; 
   by f_&index.;
   var amp&index.;
   output out=work.ampstat&index. mean=amp&index. pctlpts=2.5,97.5 pctlpre=amp&index._;
run;
* Phase stats;
proc univariate data=work.burn noprint; 
   var phase&index.;
   output out=work.phasestat&index. median=phase&index.; *<- use median for phase;
run;
* seasonal (s_i);
proc univariate data=work.burn3 noprint; 
   by dummy;
   class time;
   var alpha&index.;
   output out=work.postseas&index. mean=meanseas&index. pctlpts=2.5,97.5 pctlpre=seas&index._;
run;
%end;
* Merge all hyperparameter estimates;
%do index=1 %to &k.;
data work.seasstat&index.(rename=(meanw_&index.=meanx stdw_&index.=stdx f_&index.=period amp&index.=amp amp&index._2_5=lower amp&index._97_5=upper phase&index.=phase));
   merge work.wstat&index. work.ampstat&index. work.phasestat&index.;
   name="Seas &index.   ";
run;
%end;
data work.toreport;
   set work.sigstat(in=a rename=(meansig=meanx stdsig=stdx)) work.vartstat(in=b rename=(meanvart=meanx stdvart=stdx))
       %do index=1 %to &k.; work.seasstat&index. %end;;
   if a then name='sigma   ';
   if b then name='vartheta';
run;
options linesize=110;
title Hyperparameter estimates;
footnote;
proc report data=work.toreport nowd split='!';
   column name period amp lower upper phase meanx stdx;
   define amp / 'Amplitude' f=6.1;
   define lower / 'Lower CI' f=6.1;
   define upper / 'Upper CI' f=6.1;
   define phase / 'Phase' f=6.2;
   define meanx / 'Std-Mean' f=6.1;
   define stdx / 'Std-Std' f=6.1;
run;
*** Plots ***;
** Plot of trend and seasonal components;
* Get mean estimates from MCMC iterations;
proc univariate data=work.burn3 noprint; 
   by dummy;
   class time;
   var alpha_j1;
   output out=work.postmean mean=postmean pctlpts=2.5,97.5 pctlpre=trend;
run;
* Rescale season for plot;
proc means data=work.postmean noprint;
   by dummy;
   var postmean;
   output out=work.meantrend(drop=_type_ _freq_) mean=mean_alpha1;
run;
data work.rescale;
   merge work.smoothb(keep=dummy data time) work.meantrend;
   by dummy;
run;
data work.posterior;
   merge work.rescale work.postmean %do index=1 %to &k.; work.postseas&index.%end;;
   by time;
   pred=postmean%do index=1 %to &k.;+meanseas&index.%end;; *<-Prediction;
   errs=data-pred; *<-residuals;
   %do index=1 %to &k.; meanseas&index.=meanseas&index.+mean_alpha1; %end; *<-Rescale for plot;
run;
* Calculate the maximum value for later y-axis range;
proc univariate data=work.posterior noprint;
   var pred;
   output out=work.ymax max=maxy;
run;
* Set second y-axis to same limits as first;
proc means data=work.posterior noprint;
   var data;
   output out=work.meany(drop=_type_ _freq_) max=max min=min;
run;
data _null_;
   set work.meany;
   miny=floor(floor(min)/10)*10; *<- Scaling may need to be changed depending on the problem;
   maxy=ceil(ceil(max)/10)*10;  *<- Scaling may need to be changed depending on the problem;
   call symput('miny',put(miny,4.));
   call symput('maxy',put(maxy,4.));
run;
goptions reset=all ftext=centx htext=3 gunit=pct colors=(black) border;
** Code to output graph to .eps file;
*filename graph1 "C:\My documents\Adrian\plots\xx&cent._&repunit..eps";
*goptions reset=all ftext=centx htext=3 gunit=pct colors=(black) gunit=pct noborder
    gsfname=graph1 noprompt gsfmode=replace device=PSLEPSF fontres=presentation dash;
** JPEG FORMAT;
*filename graph1 "C:\My documents\Adrian\plots\trend&cent._&repunit..jpg";
*goptions reset=all ftext=centx htext=3 gunit=pct colors=(black) gunit=pct noborder 
    gsfname=graph1 noprompt gsfmode=replace device=JPEG xpixels=600 ypixels=700 fontres=presentation dash;
symbol1 i=join value=NONE color=black; *<-decrease trend (usually red);
symbol2 i=join line=2 value=NONE color=black; *<-decrease trend (usually red);
symbol3 i=join value=NONE color=dagray; *<-data (dagray for B/W); 
*title; 
axis1 minor=NONE label=NONE;
axis2 minor=NONE label=(a=90 'Data') order=(&miny. to &maxy. by 10);
axis3 minor=NONE label=NONE major=NONE order=(&miny. to &maxy. by 10) value=NONE style=0;
legend1 label=NONE value=('Trend' 'Lower CI' 'Upper CI' 'Observed') position=(top right inside) across=1;
proc gplot data=work.posterior;
   plot postmean*time=1 trend2_5*time=2 trend97_5*time=2 data*time=3 / overlay haxis=axis1 vaxis=axis2 noframe legend=legend1;
run; quit;
*** Seasons;
goptions reset=all ftext=centx htext=3 gunit=pct colors=(black) border;
symbol1 i=join value=NONE line=1 width=1 color=black; *<-annual;
symbol2 i=join value=NONE line=1 width=1 color=blue; *<-second season;
symbol3 i=join value=NONE line=1 width=1 color=red; *<-third season;
symbol4 i=join value=NONE line=1 width=1 color=violet; *<-fourth season;
symbol5 i=join value=NONE line=1 width=1 color=orange; *<-fifth season;
symbol6 i=join value=NONE color=green; *<-data (dagray for B/W); 
*title; * No title for paper;
axis1 minor=NONE label=NONE;
axis2 minor=NONE label=(a=90 'Data') order=(&miny. to &maxy. by 10);
axis3 minor=NONE label=NONE major=NONE order=(&miny. to &maxy. by 10) value=NONE style=0;
legend1 label=NONE value=('Observed') position=(top left inside) across=1;
legend2 label=(justify=right 'Frequency(months)') value=("&freq1." "&freq2." "&freq3." "&freq4." "&freq5.") position=(top right inside) across=1 order=(1 to &k.);
proc gplot data=work.posterior;
   plot data*time=6 / overlay haxis=axis1 vaxis=axis2 noframe legend=legend1;
   plot2 %do index=1 %to &k.; meanseas&index.*time=&index. %end; / overlay haxis=axis1 vaxis=axis3 noframe legend=legend2; * Season#2 on separate axis;
run; quit;
* Plot predictions;
goptions reset=all ftext=centx;
axis1 minor=NONE label=NONE;
axis2 minor=NONE label=(a=90 'Data') order=(&miny. to &maxy. by 10);
legend1 mode=protect position=(top right inside) value=('Predicted' 'Observed') label=NONE across=1;
symbol1 color=blue line=1 width=1 i=join value=none;
symbol2 color=green line=1 width=1 i=join value=none;
proc gplot data=work.posterior;
   plot pred*time=1 data*time=2 / overlay haxis=axis1 vaxis=axis2 noframe legend=legend1;
run; quit;
* Test residuals and plot;
proc univariate data=work.posterior normal noprint;
   var errs;
   output out=work.ntest normal=normal probn=probn;
run;
data _null_;
   set work.ntest;
   call symput('shap',put(normal,5.3));
   call symput('shapp',put(probn,5.3));
run;
goptions reset=all;
title 'Residual histogram';
footnote Normal test=&shap., p=&shapp.;
axis1 minor=NONE label=('n');
axis2 label=NONE;
proc gchart data=work.posterior;
   vbar errs / noframe raxis=axis1 maxis=axis2;
run; quit;
footnote; * Clear footnote;
* Compare observed to generated;
data work.compare;
   merge work.datatorun work.posterior(keep=time postmean trend2_5 trend97_5 mean_alpha1 %do index=1 %to &k.;meanseas&index.%end;);
   by time;
   seasest=meanseas1-mean_alpha1%do index=2 %to &k.; +meanseas&index.-mean_alpha1 %end;;
run;
goptions reset=all;
symbol1 i=join line=1 width=1 color=green height=0.5 value=square; *<-data;
symbol2 i=join value=NONE line=1 width=1 color=black; *<-generated;
symbol3 i=join value=NONE line=1 width=1 color=blue; *<-estimated;
symbol4 i=join value=NONE line=2 width=1 color=blue; *<-estimated interval;
legend1 label=none value=('Data' 'Generated' 'Estimated' 'Limits' ' ') across=1 position=(top right inside) mode=protect  shape=symbol(4,0.5);
/*
title 'Generated compared to estimated trend';
axis1 label=none minor=none;
proc gplot data=work.compare;
   plot var*time=1 trend*time=2 postmean*time=3 trend2_5*time=4 trend97_5*time=4 / overlay noframe legend=legend1 haxis=axis1 vaxis=axis1;
run; quit;
title 'Generated compared to estimated seasonal component';
proc gplot data=work.compare;
   plot seas*time=2 seasest*time=3  / overlay noframe legend=legend1 haxis=axis1 vaxis=axis1;
run; quit;*/
title 'Seasonal estimate';
proc gplot data=work.compare;
   plot seasest*time=3  / overlay noframe nolegend haxis=axis1 vaxis=axis1;
run; quit;
%mend runfil;
