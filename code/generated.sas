/****************************************************************/
/*    NAME: generated.sas                                       */
/*   TITLE: Create generated seasonal data, for use with        */
/*          twostage.sas and combined.sas                       */
/*    DATA: Generated                                           */
/*   PROCS: IML                                                 */
/*  AUTHOR: Adrian Barnett (a.barnett@sph.uq.edu.au)            */
/*                                                              */
/****************************************************************/

title "Generated seasonal data";
proc iml;
   n=120; *<-length;
   k=2; *<-number of seasonal components;
* Set up matrices and scalars;
   pi=arcos(0)*2;
   sigma=2.5;
   data=J(n,1,0);   trend=J(n,1,0);
   omega=J(k,1,0);   amp=J(k,1,0);   freq=J(k,1,0);   phase=J(k,1,0);
   amp[1,1]=1; freq[1,1]=12; phase[1,1]=0; * Annual;
   amp[2,1]=3; freq[2,1]=6; phase[2,1]=pi/4; * Bi-annual;
* Output key variables;
   do j=1 to k;
      omega[j,1]=2*pi/freq[j,1];
   end;
   seas=J(n,1,0);
   seasj=J(n,k,0);
   error=J(n,1,0);
* Create the time series composed of trend, seasonal components and normal iid noise;
   do time=1 to n;
      error[time,1]=normal(0)*(sigma); * <- Random noise;
	  do j=1 to k;
	     seasj[time,j]=amp[j,1]*cos((omega[j,1]*time)+phase[j,1]);
	  end;
*	  trend[time,1]=4+(time/100); *<-linear trend;
	  trend[time,1]=4+(time/100)+((-0.00001)*time**2)+((+0.000005)*time**3); *<-cubic trend;
	  seas[time,1]=seasj[time,]*J(k,1,1);
      data[time,1]=trend[time,1]+seas[time,1]+error[time,1];
   end;
   index=(1:n)`;
   dummy=J(n,1,1);
   toout=index||data||trend||seas||error||dummy;
   varnames={'time' 'var' 'trend' 'seas' 'error' 'dummy'};
   create work.datatorun from toout[colname=varnames];
   append from toout;
quit;
goptions reset=all ftext=centx htext=1.5;
symbol1 color=green i=join value=square height=0.5;
symbol2 color=blue i=join value=none;
symbol3 color=red i=join value=none;
legend1 label=none value=('Data' 'Trend' 'Seasonal') shape=symbol(4,0.5);
axis1 label=none minor=none;
title 'Generated data';
proc gplot data=work.datatorun;
   plot var*time=1 trend*time=2 seas*time=3 / overlay legend=legend1 noframe haxis=axis1 vaxis=axis1; 
run; quit;
