/****************************************************************/
/*    NAME: readform01.sas                                      */
/*   TITLE: Reads MONICA coronary event data                    */
/*                                                              */
/*   PROCS:                                                     */
/*    DATA: MONICA form01.txt from CD                           */
/*    DATE: 26th April 2002                                     */
/*  AUTHOR: AGB                                                 */
/*                                                              */
/****************************************************************/

* Cross-checked with CD - Distributions of the data of form 01 - Coronary events;

libname data "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files\data";
%include "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files\formats.sas";
options nodate mprint nosymbolgen font=swiss;
footnote1(&sysdate., &systime.);

* Just read in needed data for now (i.e. date/time centre gender survive history);
data work.read;
   infile "U:\Research\Projects\ihbi\aushsi\aushsi_barnetta\meta.research\reproducibility.challenge\original_files\data\form01.txt" missover; *<- read directly from CD 'The MONICA archive';
   input FORM 1-2 VERSN 3 CENTRE 4-5 RUNIT 6-7 SERIAL 8-14 DREG $ 15-22 SEX 23 MBIRTH $ 24-31 DONSET $ 32-39 MANAGE 40 
         SURVIV 41 SYMPT 42 ECG 43 ENZ 44 NECSUM 45 DIACAT 46 IATRO 47 NUMECG 48 CLIND1 $ 49-52 CLIND2 $ 53-56 CLIND3 $ 57-60
         PREMI 61 ESTST 70 NECP 77 HISTIHD 90 ICDVER 91;
/*         PREMI 61 DDEATH $ 62-69 ESTST 70 ACCST $ 71-76 NECP 77 NECD1 $ 78-81 NECD2 $ 82-85 NECD3 $ 86-89 HISTIHD 90;*/
/*		 ICDVER 91 THROMBD $ 92 OVERSION 93 OAGE 94-95 DAGE 96-97 OAGEG 98;*/
   label FORM='Form identification' VERSN='Form version' CENTRE='MONICA Collaborating Centre'
         RUNIT='MONICA Reporting Unit' SERIAL='Serial number' DREG ='Date of registration (day,month,year)' SEX='Sex'
         MBIRTH='Month and year of birth (99, month, year)' DONSET='Date of onset of event (day, month, year)'
         MANAGE ='Management' SURVIV='Survival at 28 days' SYMPT='Symptoms of a coronary event' ECG='ECG findings'
         ENZ='Serum enzymes' NECSUM='Necropsy findings summary' DIACAT ='Diagnostic category' IATRO='Possible iatrogenic event'
         NUMECG='Number of ECGs' CLIND1 ='Main clinical condition or underlying cause of death'
         CLIND2 ='Other clinical condition or other cause of death (if different from item 19)'
         CLIND3 ='Other clinical condition or other or secondary cause of death'
         PREMI ='Previous myocardial infarction event (optional codes use with caution)'
         DDEATH ='Date of death (day, month, year)' ESTST ='Apparent survival time in the event'
         ACCST='Accurate survival time in the event' NECP ='Necropsy performed'
		 NECD1 ='Direct cause of death' NECD2 ='Other disease or condition' NECD3 ='Other disease or condition'
         HISTIHD ='History of chronic ischaemic heart disease prior to present event'
         ICDVER ='Version of ICD used for diagnoses'; /*THROMBD='Thrombolytic therapy during episode'
         OVERSION='Original form version number' OAGE='Age of the person on the day of onset of the event'
         DAGE='Age of the person on the day of death' OAGEG='Age group of the person on the day of onset of the event';*/
run;

** Format dates and ages;
data work.dates(drop=birthday daybrth mthbrth monsetc yronsetc dreg dayd mond yeard);
   set work.read;
   length mthonset yronset 8.;
   dayonset=substr(donset,1,2);
   monsetc=substr(donset,3,2);
   yronsetc=substr(donset,5,4);
   daybrth=substr(mbirth,1,2);
   mthbrth=substr(mbirth,3,2);
   yearb=substr(mbirth,5,4);
** Assume mid-year dates for missing birthday data;
   if daybrth='99' and mthbrth='99' then do;
      daybrth='30';
	  mthbrth='06';
   end;
   else if daybrth='99' then daybrth='15'; 
   daymonth=dayonset+0; *<-day of month;
   if dayonset='99' and monsetc='99' then delete; *<- delete data with missing month (never happens!);
   else if dayonset='99' then do; daymonth=.; dayonset='15'; dayweek=9; end; *<-missing day of week data;
* Convert month and year to numeric variables;
    mthonset=monsetc+0;
	yronset=yronsetc+0;
* Calculate age;
	dateon=mdy(mthonset,dayonset,yronset);
	birthday=mdy(mthbrth,daybrth,yearb);
	age=floor((dateon - birthday)/365.25);
   if dayweek~=9 then dayweek=weekday(dateon); *<-get day of week;
* Date of registration;
   dayd=substr(dreg,1,2); mond=substr(dreg,3,2); yeard=substr(dreg,5,4);
   if dayd='99' or mond='99' or yeard='9999' then datereg=.;
   else datereg=mdy(mond,dayd,yeard);
run;

** Special complete data set for Newcastle (October 2003);
data data.new_coron;
   set work.dates;
   if centre=11;
   runit=99;
run;

** Combine some reporting units and restrict to appropriate years (add QA score also);
data work.comb;
   set work.dates;
* Perth;
    if centre=10 then runit=99;
    if centre=10 then do;
	   if yronset>=1984 and yronset<=1993; *<- data considered;
	   score=2; * QA score;
	   if yronset>=1988 and yronset<=1993 then score=1;
	end;
* Newcastle;
    if centre=11 then runit=99;
    if centre=11 then do;
	   if yronset>=1985 and yronset<=1993; *<- data considered;
	   score=2;
	end;
* Belgium - Charleroi/Ghent;
    if centre=12 then do;
	   if yronset>=1983 and yronset<=1992; *<- data considered;
	   score=2;
	end;
* Luxembourg - did not complete;
    if centre=14 then do;
	   if yronset>=1986 and yronset<=1991; *<- data considered;
	   score=1;
	   if yronset in (1986,1987) then score=2; 
	end;
* Halifax;
    if centre=15 then do;
	   if yronset>=1984 and yronset<=1993; *<- data considered;
	   score=2;
	end;
* Beijing;
    if centre=17 then do;
	   if yronset>=1984 and yronset<=1993; *<- data considered;
	   score=2;
	   if yronset in (1984,1985,1986,1993) then score=1; 
	end;
* Czech Republic;
    if centre=18 then runit=99;
    if centre=18 then do;
	   if yronset>=1984 and yronset<=1993; *<- data considered;
	   score=2;
	end;
* Denmark;
    if centre=19 then do;
	   if yronset>=1982 and yronset<=1991; *<- data considered;
	   score=2;
	end;
* Finland;
    if centre=20 then do;
	   if yronset>=1983 and yronset<=1992; *<- data considered;
	   score=2;
	end;
* East Germany;
    if centre=23 then runit=99;
    if centre=23 then do;
	   if yronset>=1984 and yronset<=1993; *<- data considered;
	   score=2;
	   if yronset=1984 then score=1; 
	end;
* Germany - Bremen;
    if centre=24 then runit=99;
    if centre=24 then do;
	   if yronset>=1985 and yronset<=1992; *<- data considered;
	   score=2;
	end;
* Germany - Heidelberg - did not complete;
    if centre=25 then runit=99;
    if centre=25 then do;
	   if yronset>=1984 and yronset<=1988; *<- data considered;
	   score=1;
	   if yronset in (1985,1987) then score=2; 
	end;
* Germany - Augsburg;
    if centre=26 then do;
	   if yronset>=1985 and yronset<=1994; *<- data considered;
	   score=2;
	   if runit=2 and yronset=1994 then score=1;
	end;
    if centre=26 then runit=99; * Combine rural and urban centres;
* Hungary - poor quality data;
    if centre=27 then delete;
* Iceland;
    if centre=28 then runit=99;
    if centre=28 then do;
	   if yronset>=1981 and yronset<=1994; *<- data considered;
	   score=2;
	end;
* Italy - Friuli;
    if centre=32 then runit=99;
    if centre=32 then do;
	   if yronset>=1984 and yronset<=1993; *<- data considered;
	   score=2;
	end;
* Auckland;
    if centre=33 then do;
	   if yronset>=1983 and yronset<=1992; *<- data considered;
	   score=2;
	   if yronset=1992 then score=1;
	end;
* Belfast;
    if centre=34 then do;
	   if yronset>=1983 and yronset<=1993; *<- data considered;
	   score=2;
	end;
* Poland - Tarnobrzeg Voivodship;
    if centre=35 then runit=99;
    if centre=35 then do;
	   if yronset>=1984 and yronset<=1993; *<- data considered;
	   score=1;
	end;
* Poland - Warsaw;
    if centre=36 then runit=99;
    if centre=36 then do;
	   if yronset>=1984 and yronset<=1994; *<- data considered;
	   score=2;
	end;
* Glasgow;
    if centre=37 then do;
	   if yronset>=1985 and yronset<=1994; *<- data considered;
	   score=2;
	   if yronset=1993 then score=1;
	end;
* Spain;
    if centre=39 then do;
	   if yronset>=1985 and yronset<=1994; *<- data considered;
	   score=2;
	end;
* Sweden - Gothenburg;
    if centre=40 then do; 
	   if yronset>=1984 and yronset<=1994; *<- data considered;
	   score=2;
    end;
* USA;
    if centre=43 then do;
	   if yronset>=1980 and yronset<=1992; *<- data considered;
	   score=2;
	end;
    if centre=43 then runit=99;
* Kaunas;
    if centre=45 then do;
	   if yronset>=1983 and yronset<=1992; *<- data considered;
	   score=2;
	end;
* Moscow;
    if centre=46 then do; 
	   if yronset>=1985 and yronset<=1993; *<- data considered;
	   score=1;
	end;
    if centre=46 and runit=1 then runit=97; *<-Control; 
    if centre=46 and runit in (2,3) then runit=98; *<-Intervention; 
* Novosibirsk;
    if centre=47 and runit=1 then do; *Octyabrsky;
	   if yronset>=1984 and yronset<=1993; *<- data considered;
       runit=98; *<-Intervention; 
	   score=1;
    end;
    if centre=47 and runit in (3,4) then do; *Kirowsky/Leninsky;
	   if yronset>=1984 and yronset<=1992; *<- data considered;
       runit=97; *<-Control;
	   score=1;
    end;
* Novi Sad;
    if centre=49 then do; 
	   if yronset>=1984 and yronset<=1995; *<- data considered;
	   score=2;
    end;
* Switzerland;
    if centre=50 then do; 
	   if yronset>=1985 and yronset<=1993; *<- data considered;
	   score=1;
    end;
* France - Strasbourg;
    if centre=54 then do; 
	   if yronset>=1985 and yronset<=1993; *<- data considered;
	   score=2;
    end;
* France - Toulouse;
    if centre=55 then do; 
	   if yronset>=1985 and yronset<=1993; *<- data considered;
	   score=1;
	   if yronset in (1985,1986) then score=2;
    end;
* Italy - Brianza;
    if centre=57 then do; 
	   if yronset>=1985 and yronset<=1994; *<- data considered;
	   score=2;
    end;
* France - Lille;
    if centre=59 then do; 
	   if yronset>=1985 and yronset<=1994; *<- data considered;
	   score=2;
    end;
* Sweden - North;
    if centre=60 then do; 
	   if yronset>=1985 and yronset<=1995; *<- data considered;
	   score=2;
    end;
    if centre=60 then runit=99;
run;

data data.allevent;
   set work.comb;
   drop versn form mbirth donset;
   label datereg='Registration date';
run;
proc sort data=data.allevent;
   by centre runit dateon;
run;

proc contents data=data.allevent; run;

