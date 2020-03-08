/****************************************************************/
/*    NAME: ingamrnd.sas                                        */
/*   TITLE: Macro to sample from the inverse gamma, used by     */
/*          twostage.sas and combined.sas                       */
/*    DATA: NONE                                                */
/*   PROCS: IML                                                 */
/*  AUTHOR: Adrian Barnett (a.barnett@sph.uq.edu.au)            */
/*                                                              */
/****************************************************************/

%macro ingamrnd(dataset);
data work.setup;
   set &dataset.;
   if a=1 then put 'a=1 for inverse gamma creates a problem!';
* Select rejection limits dependent on mean and variance;
   meanig=b/(a-1);
   varig=(b**2)/( ((a-1)**2)*(a-2) );
   lll=meanig-(5*sqrt(varig));
   lowerlim=max(lll,0.00001);
   upperlim=meanig+(5*sqrt(varig));
run;
* Create distribution function;
* On log scale, ignore constant - proportional to;
proc iml;
   use work.setup var {upperlim lowerlim a b meanig};
   read all;
   step_0=(upperlim-lowerlim)/1000;
   theta_0=J(1000,1,0);
   do count=0 to 999;
      theta_0[count+1,]=lowerlim+(upperlim*count/1000);
   end;
   pdist=-(a+1)*log(theta_0)-(b/theta_0);
   pp=exp(pdist);
   nn=nrow(pp);
   lowerlike=min(pp);
   upperlike=max(pp);
   accept=0;
   loop=0;
   do until(accept=1|loop>1000); * Used to be &loop<10000;
      loop=loop+1;
      ccc=uniform(0);
      rsel=floor(ccc*nn);
      ptheta_0=pp[rsel+1,];
      phi=(uniform(0)*(upperlike-lowerlike))+lowerlike; * Scale random number to limits of likelihood;
      if (ptheta_0>phi) then do;
         accept=1;
         p=theta_0[rsel+1,];
      end;
   end;
* If nothing selected then return mean (due to very small variance);
   if accept=0 then p=meanig;
* Output data;
   varnames={'gamrnd'};
   create work.gamup from p[colname=varnames];
   append from p;
quit;
%mend ingamrnd;
