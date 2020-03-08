/****************************************************************/
/*    NAME: example.sas                                         */
/*   TITLE: Runs an example seasonal analysis using generated   */
/*          data                                                */
/*  AUTHOR: Adrian Barnett (a.barnett@sph.uq.edu.au)            */
/*                                                              */
/****************************************************************/

* Libnames and options;
%let library=c:\web\lsu\adrian; * Change this library to match your file structure. Make sure the three files called in the next three lines are put there;
%include "&library.\generated.sas"; * Include program to generate the data;
%inc "&library.\ingamrnd.sas"; * Include the inverse gamma macro;
%include "&library.\combined.sas"; * Include program with the seasonal macros;
options nodate mprint symbolgen;
footnote1 &sysdate., &systime.;

*** Tips ***;
* Start with a small MCMC run (say mcmc=100 and burn=20) in case the program crashes;
* Start with a smooth value of 1, if the program crashes try other values, 
  if the trend line is too linear try smaller values, if the trend line is too curvy try larger values;

options nonotes nosymbolgen nomprint; /* Reduce the output to the log */
%runfil(dsetin=work.datatorun, /* input data set */
        dsetout=work.post, /* output data set */
              var=var,    /* variable name */
              k=1,     /* number of frequencies, k>1, default=1 */ 
              freq1=12,  /* First frequency, leave as 999 if unused */
              freq2=999, /* Second frequency, leave as 999 if unused */
              freq3=999, /* Third frequency, leave as 999 if unused */
              freq4=999, /* Fourth frequency, leave as 999 if unused */
              freq5=999, /* Fifth frequency, leave as 999 if unused */
              MCMC=100,  /* Number of MCMC iterations, default=1000 */
              burn=50,   /* Discarded burn-in of MCMC iterations, default=500 */
              delta=1/12, /* Gaps between observations, default=1/12 (i.e. monthly data) */
              smooth=1.2    /* Smoothing parameter for trend, smaller numbers = more linear trend, default=1 */
);
options notes symbolgen mprint; /* Restore the output to the log */

