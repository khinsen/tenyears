/****************************************************************/
/*    NAME: kalsmooth.sas                                       */
/*   TITLE: Kalman smoother of CHD rates                        */
/*                                                              */
/*   PROCS: IML, GPLOT                                          */
/*    DATA: MONICA (data.all)                                   */
/*  AUTHOR: AGB                                                 */
/*                                                              */
/*  Removed reference to runit for weather analysis             */
/****************************************************************/

*libname alc 'C:\My Documents\Yingqin\Monica Yingqin\coronary';
libname data 'U:\SAS\data';
%include "U:\SAS\formats.sas";
options nodate mprint symbolgen notes;
footnote1 &sysdate., &systime.;

** Set up data;
* Special data set for weather analysis;
data work.weath;
   set data.summonth;
* Change Finnish centres, for weather analysis;
   if centre=20 and runit=2 then centre=20.2;
   if centre=20 and runit=3 then centre=20.3;
   if centre=20 and runit=6 then centre=20.6;
run;
data work.addtime;
   set work.weath;
   retain time 0;
   by centre; 
   if first.centre then time=0;
   time=time+1;
run;

** Dummy data sets;
* Create a data set of the residuals for all centres;
data work.allfilt;
   centre=0; /*runit=0;*/ data=0; yrmon=0; errs=0; trend=0; p2_5=0; p97_5=0; * changed for weather analysis;
run;
* Create a data set of the sigma estimates;
data work.allsig;
   centre=0; /*runit=0;*/ mean=0; std=0; diff=0;* changed for weather analysis;
run;

* Macro to run Kalman filter;
%macro kalfil(tauratio,run);
* Forward sweep of Kalman filter;
proc iml;
   use work.centre var {ratestd yrmon};
   read all;
   use work.sigma var {sigma};
   read all;
   n=nrow(ratestd);
   data={0}//ratestd;
   yyy={0}//yrmon;
   F={1,0};
   tau=sigma/&tauratio.;
   delta=1; G={1 1,0 1}; G[1,2]=delta;
   V=J(2,2,0); V[1,1]=(delta**3)/3; V[1,2]=(delta**2)/2; V[2,1]=(delta**2)/2; V[2,2]=delta;
   V=V*(tau**2);
   a_j=J(2,n+1,0);   p_j=J(2,n+1,0);
   e_j=J(1,n+1,0);   C_j=J(2,2,0);
   p_j[1,1]=data[+,1]/n; *<first obs=mean (p_0);
   C_j[1,1]=100; C_j[2,2]=100; * <- relaxed priors (C_0);
   Q_j=J(2,2,0); R_j=J(2,2,0);
   C_out=J((n+1)*4,1,0); R_out=J((n+1)*4,1,0);
   C_out[1,]=C_j[1,1];
   C_out[4,]=C_j[2,2];
   time=(0:n)`;
   do t=1 to n; *<- time 0 to n-1;
	  a_j[,t+1]=G*p_j[,t];
	  R_j=(G*C_j*G`)+V;
	  Q_j=(F`*R_j*F)+sigma;
      e_j[,t+1]=data[t+1,1]-(F`*a_j[,t+1]);
      p_j[,t+1]=a_j[,t+1]+(R_j*F*inv(Q_j)*e_j[,t+1]);
      C_j=R_j-(R_j*F*inv(Q_j)*F`*R_j`);
      C_out[(t*4)+1:((t+1)*4),]=shape(C_j,4,1);
      R_out[(t*4)+1:((t+1)*4),]=shape(R_j,4,1);
   end;
* Output data;
   toout=time||p_j`||a_j`||data||yyy;
   varnames={'time' 'p_j1' 'p_j2' 'a_j1' 'a_j2' 'data' 'yrmon'};
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
   use work.smoothf var {time p_j1 p_j2 a_j1 a_j2 data yrmon};
   read all;
   use work.fvar var {C_j_vec R_j_vec};
   read all;
   n=nrow(time)-1;
   p_j=p_j1`//p_j2`;
   a_j=a_j1`//a_j2`;
* DLM matrices;
   delta=1; G={1 1,0 1}; G[1,2]=delta;
   h_j=J(2,n+1,0); alpha_j=J(2,n+1,0);
   B_j=J(2,2,0); HH_j=J(2,2,0);
* Initial alpha sample;
   C_j=shape(C_j_vec[((n-1)*4)+1:(n*4),],2,2);
   alpha_j[1,n+1]=(normal(0)*sqrt(C_j[1,1]))+p_j[1,n+1];
   alpha_j[2,n+1]=(normal(0)*sqrt(C_j[2,2]))+p_j[2,n+1];
* Iterate backwards in time;
   do t=n to 1 by -1;
      C_j=shape(C_j_vec[((t-1)*4)+1:(t*4),],2,2);
      R_j=shape(R_j_vec[(t*4)+1:((t+1)*4),],2,2);
	  B_j=C_j*(G`)*inv(R_j);
	  HH_j=C_j-(B_j*R_j*(B_j`));
	  h_j[,t]=p_j[,t]+(B_j*(alpha_j[,t+1]-a_j[,t+1]));
* Sample alpha_j from a bivariate Normal;
* Sampling using Cholesky;
      normrnd=J(2,1,0);
      L=root(HH_j)`;
      do j=1 to 2;
	     normrnd[j,1]=normal(0);
	  end;
      do j=1 to 2;
         alpha_j[j,t]=(L[j,]*normrnd)+h_j[j,t];
	  end;
   end;
** Estimate sigma and tau;
* sigma;
   mse=J(n,1,0);
   do t=2 to n+1;
      mse[t-1,1]=(data[t,1]-alpha_j[1,t])**2;
   end;
   b=mse[+,]/2;
   a=n/2;
   toout=a||b;
   varnames={'a' 'b'};
   create work.siginfo from toout[colname=varnames];
   append from toout;
* Output data;
   toout=time||(alpha_j[1,]`)||(alpha_j[2,]`)||data||yrmon;
   varnames={'time' 'alpha_j' 'alpha_j2' 'data' 'yrmon'};
   create work.smoothb from toout[colname=varnames];
   append from toout;
quit;
* Update sigma from inverse gamma;
%ingamrnd(work.siginfo);
data work.sigma(drop=gamrnd);
   set work.gamup;
   sigma=sqrt(gamrnd);
   run=&run.;
run;
data work.smooth;
   set work.smoothb;
   if time>0;
   run=&run.;
run;
%mend kalfil;

* Macro to call Kalman filter repeatedly;
%macro runfil(cent,repunit,taurat);
* Get initial values for sigma;
data work.centre;
   set work.addtime;
   if centre=&cent.;* and runit=&repunit.; * Excluded runit to combine results for weather analysis;
   yrmon=yronset-1900+((mthonset-1)/12);
*   ratestd=log(ratestd); * Examine log rates;
run;
proc univariate data=work.centre noprint;
   var ratestd;
   output out=work.sigma std=sigma;
run;
data work.sigch;
   set work.sigma;
   run=0;
run;
data work.allsmooth;
   time=0; run=0; data=0; alpha_j=0; alpha_j2=0; yrmon=0;
run;
%do count=1 %to 500; *<-number of MCMC runs;
   %kalfil(&taurat.,&count.); *< tau ratio;
   proc append base=work.sigch data=work.sigma;
   run;
* Append smooth estimates;
   proc append base=work.allsmooth data=work.smooth;
   run;
%end;
* Output sigma information;
*%cntrname(&cent.,&repunit.);
title3 sigma mean and s.d.;
data work.burn;
   set work.sigch;
   if run>100; *burn-in;
   centre=&cent.;
*   runit=&repunit.;
run;
proc univariate data=work.burn noprint;
   by centre;* runit;* changed for weather analysis;
   var sigma;
   output out=work.sigstat std=std mean=mean;
run;
proc print data=work.sigstat noobs;
run;

** Plot;
data work.burnsm;
   set work.allsmooth;
   if run>100; *burn-in;
   centre=&cent.;
*   runit=&repunit.;* changed for weather analysis;
run;
* Get the MCMC based limits;
proc sort data=work.burnsm;
   by centre /*runit*/ yrmon;* changed for weather analysis;
proc univariate data=work.burnsm noprint;
   by centre /*runit*/ yrmon;* changed for weather analysis;
   var alpha_j;
   output out=work.smlimits pctlpre=p pctlpts=(2.5 97.5) mean=trend;
run;
* Calculate residuals for seasonal analysis;
data work.res;
   merge work.smlimits work.centre(keep=ratestd yrmon rename=(ratestd=data));
   by yrmon;
   errs=data-trend;
run;
goptions reset=all ftext=centx htext=3 gunit=pct colors=(black) border;
*filename graph1 "C:\temp\l&cent._&repunit..eps";
*goptions reset=all ftext=centx htext=3 gunit=pct colors=(black) border gunit=pct noborder
    gsfname=graph1 noprompt gsfmode=replace device=PSLEPSFC;
symbol1 i=join value=NONE color=black; 
symbol2 i=join value=NONE color=black line=2; 
symbol3 i=join value=NONE color=dagray; 
axis1 minor=NONE label=NONE;
axis2 minor=NONE label=NONE;
*%cntrname(&cent.,&repunit.);
proc gplot data=work.res;
   plot trend*yrmon=1 p2_5*yrmon=2 p97_5*yrmon=2 data*yrmon=3 / overlay haxis=axis1 vaxis=axis2 noframe;
run; quit;
* Append errors and trend;
proc append base=work.allfilt data=work.res;
run;
* Make overall file of sigma values; 
%mend runfil;
*%runfil(12,-99,200);

options nonotes nomprint nosymbolgen; *<-reduce output to log;
* Just call those centres needed by the weather analysis;
%runfil(10,-99,200); %runfil(11,-99,200); %runfil(12,-99,200); %runfil(15,-99,200); %runfil(17,-99,200); 
%runfil(18,-99,200); %runfil(20.2,-99,200); %runfil(20.3,-99,200); %runfil(20.6,-99,200);
%runfil(23,-99,200); %runfil(24,-99,200); %runfil(26,-99,200); %runfil(28,-99,200); 
%runfil(32,-99,200); %runfil(34,-99,200); %runfil(37,-99,200); %runfil(39,-99,200); 
%runfil(40,-99,200); %runfil(43,-99,200); 
%runfil(45,-99,200); %runfil(46,-99,200); %runfil(47,-99,200); %runfil(49,-99,200); %runfil(50,-99,200);
%runfil(54,-99,200); %runfil(55,-99,200); %runfil(57,-99,200); %runfil(60,-99,200);
*%callcent(runfil,200); *<- tau ratio;
*%callcenf(runfil,200); *<- tau ratio, women only;
options notes mprint;
* Remove dummy data;
data data.alltrendweather; * For ..\Weather\ analysis;
   set work.allfilt;
   if centre>0;
run;
proc sort data=data.alltrendweather;
   by centre yrmon;
run;
data work.allsig;
   set work.allsig;
   if centre>0;
run;

* Plot of noise variances against means;
proc univariate data=work.addtime noprint;
   by centre;* runit; * changed for weather analysis;
   var ratestd;
   output out=work.means mean=mean var=var std=std;
run;
data work.toplot;
   merge work.means work.allsig(rename=(mean=sigma) drop=std);
   by centre; * runit;* changed for weather analysis;
   sigma2=sigma**2;
   rootmean=sqrt(mean);
run;
goptions reset=all ftext=centxi htext=3 gunit=pct colors=(black) border;
filename graph1 "C:\My documents\Adrian\plots\sigmean_res.eps";
goptions reset=all ftext=centxi htext=3 gunit=pct colors=(black) border gunit=pct noborder
    gsfname=graph1 noprompt gsfmode=replace device=PSLEPSFC;
symbol1 i=NONE color=blue value=PLUS h=3;
symbol2 i=RQ0 line=2 color=black value=NONE width=1; * Line to show ideal Poisson distribution;
symbol3 i=RL0 line=2 color=red value=NONE width=1; * Regression Line;
axis1 label=('Mean') minor=NONE;
*axis2 label=(a=90 'Observed standard deviation') minor=NONE order=(0 to 20 by 5);
*axis2 label=(a=90 'Observed variance') minor=NONE order=(0 to 400 by 100);
*axis2 label=(a=90 'Estimated residual variance') minor=NONE order=(0 to 250 by 50);
axis2 label=(a=90 'Estimated residual standard deviation') minor=NONE order=(0 to 15 by 5);
proc gplot data=work.toplot;
   plot sigma*mean=1 rootmean*mean=2 sigma*mean=3 / overlay haxis=axis1 vaxis=axis2 noframe;
*   plot std*mean=1 rootmean*mean=2 std*mean=3 / overlay haxis=axis1 vaxis=axis2 noframe;
run; quit;
proc corr data=work.toplot;
   var sigma mean;
run; 

* Overall plot of all trends (split by trend direction);
*goptions reset=all ftext=centxi htext=3 gunit=pct colors=(black) border;
data work.up work.down;
   set work.alltime;
   length cid $ 7.;
   if centre>0;
   cid='a_'||trim(left(centre))||'_'||trim(left(runit));
   if diff<0 then output work.down;
   else if diff>0 then output work.up;
run;
proc transpose data=work.up out=work.uptran;
   by centre runit yrmon;
   var alpha_j;
   id cid;
run;
goptions reset=all ftext=centxi htext=3 gunit=pct colors=(black) border;
*filename graph1 "C:\My documents\Adrian\plots\koverup.eps";
*goptions reset=all ftext=centxi htext=3 gunit=pct colors=(black) border gunit=pct noborder
    gsfname=graph1 noprompt gsfmode=replace device=PSLEPSFC;
symbol1 i=join color=blue;
symbol2 i=join color=red;
* Macro variables for x-axis range;
proc means data=work.uptran min max noprint;
   var yrmon;
   output out=work.dates min=minyr max=maxyr;
run;
data _null_;
   set work.dates;
   maxmax=95;
   call symput('minyear',put(minyr,4.));
   call symput('maxyear',put(maxmax,4.));
run;
* Macro variables for y-axis range;
proc means data=work.yaxismax max noprint;
   var maxy;
   output out=rates max=max;
run;
data _null_;
   set work.rates;
   upper=10*ceil(max/10);*<- round up to nearest 10;
   call symput('maxyax',put(upper,4.));
run;
axis1 minor=NONE label=NONE order=(&minyear. to &maxyear.);
axis2 order=(0 to &maxyax. by 10) minor=NONE label=(angle=90 'Estimated CHD trend');
axis2 minor=NONE label=(angle=90 'Estimated CHD trend');
* Ignore missing errors in log;
proc gplot data=work.uptran;
   plot a_18_99*yrmon=2 a_23_99*yrmon=2 a_24_99*yrmon=2 a_26_99*yrmon=2 a_32_99*yrmon=2
        a_35_99*yrmon=2 a_36_99*yrmon=2 a_39_3*yrmon=2 a_45_1*yrmon=2 a_47_97*yrmon=2 
        a_47_98*yrmon=2 a_49_1*yrmon=2 a_55_1*yrmon=2 / overlay haxis=axis1 vaxis=axis2;
run; quit;
** Downward trend;
filename graph1 "C:\My documents\Adrian\plots\koverdown.eps";
proc transpose data=work.down out=work.downtran;
   by centre runit yrmon;
   var alpha_j;
   id cid;
run;
* Ignore missing errors in log;
proc gplot data=work.downtran;
   plot a_10_99*yrmon=1 a_11_99*yrmon=1 a_12_1*yrmon=1 a_15_1*yrmon=1  
        a_19_1*yrmon=1 a_20_2*yrmon=1 a_20_3*yrmon=1 a_20_6*yrmon=1 a_28_99*yrmon=1 a_33_1*yrmon=1
        a_34_1*yrmon=1 a_37_1*yrmon=1 a_40_1*yrmon=1 a_43_99*yrmon=1 a_46_97*yrmon=1 
        a_54_1*yrmon=1 a_59_1*yrmon=1 a_60_99*yrmon=1 / overlay haxis=axis1 vaxis=axis2; * Women;
*   plot a_10_99*yrmon=1 a_11_99*yrmon=1 a_12_1*yrmon=1 a_15_1*yrmon=1  
        a_18_99*yrmon=1 a_19_1*yrmon=1 a_20_2*yrmon=1 a_20_3*yrmon=1 a_20_6*yrmon=1 a_23_99*yrmon=1 a_24_99*yrmon=1
        a_26_99*yrmon=1 a_28_99*yrmon=1 a_33_1*yrmon=1 a_32_99*yrmon=1 a_34_1*yrmon=1 a_37_1*yrmon=1 
        a_40_1*yrmon=1 a_43_99*yrmon=1 a_46_97*yrmon=1 
        a_50_1*yrmon=1 a_54_1*yrmon=1 a_55_1*yrmon=1 
        a_57_1*yrmon=1 a_59_1*yrmon=1 a_60_99*yrmon=1 / overlay haxis=axis1 vaxis=axis2;
run; quit;

* Save as a permanent data set;
data data.temp; 
   set work.alltime; 
   if centre>0;
run;

/**
proc transpose data=work.down out=work.downtran;
   by centre runit yrmon;
   var alpha_j2;
   id cid;
run;
* Ignore missing errors in log;
goptions reset=all;
axis1 minor=NONE label=NONE order=(&minyear. to &maxyear.);
axis2 minor=NONE label=(angle=90 'Estimated CHD trend');
symbol1 i=sm20 color=blue; *<-smooth line;
proc gplot data=work.downtran;
   plot a_10_99*yrmon=1 a_11_99*yrmon=1 a_12_1*yrmon=1 a_12_2*yrmon=1 a_15_1*yrmon=1 a_17_1*yrmon=1 
        a_18_99*yrmon=1 a_19_1*yrmon=1 a_20_2*yrmon=1 a_20_3*yrmon=1 a_20_6*yrmon=1 a_23_99*yrmon=1 a_24_99*yrmon=1
        a_26_99*yrmon=1 a_28_99*yrmon=1 a_33_1*yrmon=1 a_32_99*yrmon=1 a_34_1*yrmon=1 a_37_1*yrmon=1 
        a_40_1*yrmon=1 a_43_99*yrmon=1 a_46_97*yrmon=1 
        a_47_97*yrmon=1 a_50_1*yrmon=1 a_54_1*yrmon=1 a_55_1*yrmon=1 
        a_57_1*yrmon=1 a_59_1*yrmon=1 a_60_99*yrmon=1 / overlay haxis=axis1 vaxis=axis2;
run; quit;
**/