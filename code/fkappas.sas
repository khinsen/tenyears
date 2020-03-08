/**********************************************************************/
   /* Appendix 2: Calculating P-Values for Fisher's Kappa    */
   /*                from PROC SPECTRA Output                */
   /* Data from SAS/ETS Sample Library: SPECTRA1             */  
/**********************************************************************/
* From sas.com web site;

%macro fkappas(dataset,var);
proc spectra data=&dataset. p out=a whitetest;      
   var &var.;                                    
run;                                              
                                                  
data a;                                           
   set a;                                         
   retain n;                                      
   if period=. then delete;                       
   if period=2.0 then delete; * Why?;
   if _n_=2 then n=period;                        
run;                                              

proc means data=a sum noprint;                    
   var p_01;                                      
   id n;                                          
   output out=b sum=psum;                         
run;                                              

proc sort data=a;                                 
   by descending p_01;                            
run;

data c;                                          
   merge a b;                                    
   by n;                                         
   drop _type_ _freq_;                           
run;                                             

data work.res;                                     
   set c;                                        
   TOOBIG=1e50;    /* Machine upper limit on floating point  */    
   TOOSMALL=1e-50; /* Machine lower limit on floating point  */ 
   MAXFACT=41;     /* Maximum Factorial                      */          
   m=floor((n-1)/2);                             
   r=_n_;                                        
   if r>12 then delete;  /* Upper limit on r                 */  
   z=p_01/psum;                                  
   b=floor(1/z);                                 
   if b<(1/z) then a=b;                          
   else a=b-1;                                   
   gprob=0;                                      
   top=min(a,m);                                 
   do j=r to top;                                
      if j=r then do;  /* Initialize for first step          */      
         dflag=0;
                                
            /* Use GAMMA function rather than multiplication */ 
            /* if possible. */
  
		 if r<MAXFACT then do;
		    denom=gamma(r)*r;
			prob=m/denom;
			end;
		 else do;
		       /* dflag=1 implies that we must now keep      */
		       /* track of denominator.                      */
		   dflag=1;
		   denom1=max(r-1,1);
		   denom=r*denom1;
		   prob=m;
		 end;
	  nmult=m-1;
	  amult=1-r*z;
	  bot1=m-r;    /* Lower limit of mult.                   */
	  curexp=m-1;  /* Current exponent value                 */
	  
	  do while(nmult>bot1);

 
            bot2=TOOBIG/nmult;                   

               /* Loop until overflow avoided                */ 
            do while(prob>bot2);                 

                  /* If it is impossible to avoid overflow,  */ 
                  /* set prob to missing. Use -1 for now as  */ 
                  /* a flag, since comparisons using missing */ 
                  /* values can be risky.                    */ 
               if curexp=0 and dflag=0           
                  then prob=-1;

                  /* Instead of raising to a power, multiply */ 
                  /* one term at a time and anticipate using */ 
                  /* a multiplication or division to prevent */ 
                  /* overflow or underflow.                  */ 
               else if curexp>0 then do;         

                     /* Cannot overflow                      */         
                  prob=prob*amult;               
                  curexp=curexp-1;               
                  end;                           
               else if dflag=1 and               
                     prob>denom*TOOSMALL then do;

                     /* Cannot underflow                     */      
                  prob=prob/denom;               
                  if denom1>1 then               
                     denom1=denom1-1;            
                  if denom1=1 then dflag=0;      
                  denom=denom1;                  
                  end;                           
               end;                              
            if prob=-1 then do;  /* Failure                  */   
               prob=.;                           
               nmult=0;                          
               dflag=0;                          
               end;                              
            else do;                             

                  /* Cannot overflow                         */          
               prob=prob*nmult; 
               nmult=nmult-1;                   
               end;                             
            end;                                

            /* Now it is okay to exponentiate                */
         if curexp>0 then                       
         prob=prob*(amult**curexp);             
         if dflag=1 then do while(dflag=1);     
            prob=prob/denom;                    
            if denom1>1 then denom1=denom1-1;   
            if denom1=1 then dflag=0;           
            denom=denom1;                       
            end;                                
         sum=prob;                              
         end;                                   
      else do; /* Subsequent steps in sum for j>r using      */
               /* recursion. We are less careful because     */
               /* overflow is unlikely, and  underflow is    */
               /* well approximated by zero.                 */
         f1=(1-j*z)/(1-(j-1)*z);                
         f2=(j-1)*(m-j+1)/(j*(j-r));            
         prob=f2*(f1**(m-1));                   
         sum=-sum*prob;                         
         end;                                   
      gprob=gprob+sum;                          
      end;   /* End j loop                                   */                     

      /* Flag floating-point error                           */          
   if gprob>1 then gprob=2.0;

      /* Flag floating-point error                           */          
   if gprob<0 then gprob=-1.0;                 
   mz=z*m;

run;
* Output results;
title3 Fishers Kappa test of white noise;
proc print data=work.res noobs label;
   label gprob='P-value';
   var period r z mz gprob;              
run;
%mend fkappas;
