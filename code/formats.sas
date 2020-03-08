* Formats and macros for MONICA;

%macro centname(i,j);
%if &i.=10 %then %let center= %str(Perth, Australia);
%else %if &i.=11 %then %let center= %str(Newcastle, Australia);
%else %if &i.=12 %then %let center= %str(Ghent/Charleroi, Belgium);
%else %if &i.=14 %then %let center= %str(Luxembourg, Belgium);
%else %if &i.=15 %then %let center= %str(Halifax, Canada);
%else %if &i.=17 %then %let center= %str(Beijing, China);
%else %if &i.=18 %then %let center= %str(Czech Republic);
%else %if &i.=19 %then %let center= %str(Glostrup);
%else %if &i.=20 %then %let center= %str(Finland);
%else %if &i.=23 %then %let center= %str(East Germany);
%else %if &i.=24 %then %let center= %str(Bremen, Germany);
%else %if &i.=26 %then %let center= %str(Augsburg, Germany);
%else %if &i.=28 %then %let center= %str(Iceland);
%else %if &i.=32 %then %let center= %str(Friuli, Italy);
%else %if &i.=33 %then %let center= %str(Auckland, New Zealand);
%else %if &i.=34 %then %let center= %str(Belfast, UK);
%else %if &i.=35 %then %let center= %str(Tarnobrzeg Voivodship, Poland);
%else %if &i.=36 %then %let center= %str(Warsaw, Poland);
%else %if &i.=37 %then %let center= %str(Glasgow, UK);
%else %if &i.=39 %then %let center= %str(Catalonia, Spain);
%else %if &i.=40 %then %let center= %str(Gothenburg, Sweden);
%else %if &i.=43 %then %let center= %str(Stanford, USA);
%else %if &i.=45 %then %let center= %str(Kaunas, Lithuania);
%else %if &i.=46 %then %let center= %str(Moscow, Russia);
%else %if &i.=47 %then %let center= %str(Novosibirsk, Russia);
%else %if &i.=49 %then %let center= %str(Novi Sad, Yugoslavia);
%else %if &i.=50 %then %let center= %str(Switzerland);
%else %if &i.=54 %then %let center= %str(Strasbourg, France);
%else %if &i.=55 %then %let center= %str(Toulouse, France);
%else %if &i.=57 %then %let center= %str(Area Brianza, Italy);
%else %if &i.=59 %then %let center= %str(Lille, France);
%else %if &i.=60 %then %let center= %str(Northern Sweden);
* Reporting unit;
%if &j.<99 %then %let rtitle=%str(Reporting unit &j.);
%if &j.=97 %then %let rtitle=%str(Control); 
%if &j.=98 %then %let rtitle=%str(Intervention); 
%if &j.=99 %then %let rtitle=%str(Combined reporting units); 
title1 height=3.5 justify=center "&center.";
title2 height=2.5 justify=center "&rtitle.";
%mend centname;

* Macro with centre name and unit on one row;
%macro cntrname(i,j);
%if &i.=10 %then %let center= %str(Perth, Australia);
%else %if &i.=11 %then %let center= %str(Newcastle, Australia);
%else %if (&i.=12 and &j.=1) %then %let center= %str(Ghent, Belgium);
%else %if (&i.=12 and &j.=2) %then %let center= %str(Charleroi, Belgium);
%else %if (&i.=14 and &j.=1) %then %let center= %str(Luxembourg);
%else %if &i.=15 %then %let center= %str(Halifax, Canada);
%else %if &i.=17 %then %let center= %str(Beijing, China);
%else %if &i.=18 %then %let center= %str(Czech Republic);
%else %if &i.=19 %then %let center= %str(Glostrup);
%else %if (&i.=20 and &j.=2) %then %let center= %str(North Karelia, Finland);
%else %if (&i.=20 and &j.=3) %then %let center= %str(Kuopio, Finland);
%else %if (&i.=20 and &j.=6) %then %let center= %str(Turku/Loimaa, Finland);
%else %if &i.=23 %then %let center= %str(East Germany);
%else %if &i.=24 %then %let center= %str(Bremen, Germany);
%else %if &i.=25 %then %let center= %str(Heidelberg, Germany);
%else %if &i.=26 %then %let center= %str(Augsburg, Germany);
%else %if &i.=28 %then %let center= %str(Iceland);
%else %if &i.=32 %then %let center= %str(Friuli, Italy);
%else %if &i.=33 %then %let center= %str(Auckland, New Zealand);
%else %if &i.=34 %then %let center= %str(Belfast, UK);
%else %if &i.=35 %then %let center= %str(Tarnobrzeg Voivodship, Poland);
%else %if &i.=36 %then %let center= %str(Warsaw, Poland);
%else %if &i.=37 %then %let center= %str(Glasgow, UK);
%else %if &i.=39 %then %let center= %str(Catalonia, Spain);
%else %if &i.=40 %then %let center= %str(Gothenburg, Sweden);
%else %if &i.=43 %then %let center= %str(Stanford, USA);
%else %if &i.=45 %then %let center= %str(Kaunas, Lithuania);
%else %if (&i.=46 and &j.=97) %then %let center= %str(Moscow Control, Russia); 
%else %if (&i.=46 and &j.=98) %then %let center= %str(Moscow Intervention, Russia); 
%else %if (&i.=47 and &j.=97) %then %let center= %str(Novosibirsk Control, Russia);
%else %if (&i.=47 and &j.=98) %then %let center= %str(Novosibirsk Intervention, Russia);
%else %if &i.=49 %then %let center= %str(Novi Sad, Yugoslavia);
%else %if (&i.=50 and &j.=1) %then %let center= %str(Vaud/Fribourg, Switzerland);
%else %if (&i.=50 and &j.=3) %then %let center= %str(Ticino, Switzerland);
%else %if &i.=54 %then %let center= %str(Strasbourg, France);
%else %if &i.=55 %then %let center= %str(Toulouse, France);
%else %if &i.=57 %then %let center= %str(Area Brianza, Italy);
%else %if &i.=59 %then %let center= %str(Lille, France);
%else %if &i.=60 %then %let center= %str(Northern Sweden);
title1 height=3.5 justify=center "&center.";
%mend cntrname;

proc format;
      value hot
   1='Hot'
   2='Z-Cold'
   3='Mixed'
;
value centre
10="Perth, Australia"
11="Newcastle, Australia"
12="Ghent, Belgium"
14="Luxembourg"
15="Halifax, Canada"
17="Beijing, China"
18="Czech Republic"
19="Glostrup"
20="Finland"
23="East Germany"
24="Bremen, Germany"
25="Heidelberg, Germany"
26="Augsburg, Germany"
27="Budapest, Hungary"
28="Iceland"
32="Friuli, Italy"
33="Auckland, New Zealand"
34="Belfast, UK"
35="Tarnobrzeg Voivodship, Poland"
36="Warsaw, Poland"
37="Glasgow, UK"
39="Catalonia, Spain"
40="Gothenburg, Sweden"
43="Stanford, USA"
45="Kaunas, Lithuania"
46="Moscow, Russia"
47="Novosibirsk, Russia"
49="Novi Sad, Yugoslavia"
50="Switzerland"
54="Strasbourg, France"
55="Toulouse, France"
57="Area Brianza, Italy"
59="Lille, France"
60="Northern Sweden"
;
   value monabbr
10.99="AUS-PER"
11.99="AUS-NEW"
12.01="BEL-GHE"
12.02="BEL-CHA"
14.01="BEL-LUX"
15.01="CAN-HAL"
17.01="CHN-BEI"
18.99="CZE-CZE"
19.01="DEN-GLO"
20.02="FIN-NKA"
20.03="FIN-KUO"
20.06="FIN-TUL"
23.99="GER-EGE"
24.99="GER-BRE"
25.99="GER-RHN"
26.99="GER-AUG"
28.99="ICE-ICE"
32.99="ITA-FRI"
33.01="NEZ-AUC"
34.01="UNK-BEL"
35.99="POL-TAR"
36.99="POL-WAR"
37.01="UNK-GLA"
39.03="SPA-CAT"
40.01="SWE-GOT"
43.99="USA-STA"
45.01="LTU-KAU"
46.97="RUS-MOC"
46.98="RUS-MOI"
47.97="RUS-NOC"
47.98="RUS-NOI"
49.01="YUG-NOS"
50.01="SWI-VAF"
50.03="SWI-TIC"
54.01="FRA-STR"
55.01="FRA-TOU"
57.01="ITA-BRI"
59.01="FRA-LIL"
60.99="SWE-NSW"
;
   value runit
   99="Combined units"
;
   value yesno
   1="Yes"
   0="No"
;
   value sex
   1="Male"
   2="Female"
;
   value agegrp
   1='35-39' 
   2='40-44' 
   3='45-49' 
   4='50-54'
   5='55-59' 
   6='60-64'
;
   value myday
   1='Sunday'
   2='Monday'
   3='Tuesday'
   4='Wednesday'
   5='Thursday'
   6='Friday'
   7='Saturday'
   9='Missing'
   .='Missing'
;
   value estst
   1 = '< 1 hour (known)' 
   2 = '1-23 hours 59 minutes (known)'
   3 = '> = 24 hours (known)'
   4 = 'not known, probably < 24 hours' 
   5 = 'not known, probably > = 24 hours' 
   8 = 'alive at 28 days' 
   9 = 'insufficient data'
;
   value mthonset
   1='January'
   2='February'
   3='March'
   4='April'
   5='May'
   6='June'
   7='July'
   8='August'
   9='September'
   10='October'
   11='November'
   12='December'
;
value MANAGE
1 = 'in hospital'
2 = 'in nursing home'
3 = 'at home by a doctor'
4 = 'medically unattended' 
5 = 'other medical consultation without bed rest, in hospital or at home' 
9 = 'insufficient data'
;
value SURVIV
1 = 'yes' 
2 = 'no'
9 = 'insufficient data'
;
value SYMPT
1 = 'typical'
2 = 'atypical'
3 = 'other'
4 = 'none'
5 = 'inadequately described'
9 = 'insufficient data'
;
value ECG
1 = 'definite'
2 = 'probable'
3 = 'ischaemic'
4 = 'other'
5 = 'uncodable'
9 = 'insufficient data'
;
value ENZ
1 = 'abnormal' 
2 = 'equivocal' 
3 = 'non-specific'
4 = 'normal'
5 = 'incomplete'
9 = 'insufficient data'
;
value NECSUM
1 = 'definite' 
2 = 'equivocal' 
4 = 'negative'
8 = 'alive at 28 days, or no necropsy performed'
9 = 'insufficient data'
;
value DIACAT
1 = 'definite' 
2 = 'possible'
3 = 'ischaemic cardiac arrest'
4 = 'none' 
9 = 'insufficient data' 
;
value IATRO
1 = 'yes'
2 = 'no' 
9 = 'insufficient data' 
;
value NUMECG
0 = 'none'
1 = 'one'
2 = 'two'
3 = 'three'
4 = '4 or more'
9 = 'insufficient data'
;
value PREMI
1 = 'yes, definite, previous record reviewed' 
2 = 'yes, possible, previous record reviewed'
3 = 'yes, previous record reviewed, not categorised'
4 = 'yes, from ECG'
5 = 'yes, undocumented'
6 = 'no, documented, complete medical records available' 
7 = 'no, undocumented'
9 = 'insufficient data'
;
value ESTST
1 = '< 1 hour (known)'
2 = '1-23 hours 59 minutes (known)'
3 = '> = 24 hours (known)' 
4 = 'not known, probably < 24 hours' 
5 = 'not known, probably > = 24 hours' 
8 = 'alive at 28 days' 
9 = 'insufficient data'
;
value NECP
1= 'yes, routine'
2= 'yes, medico-legal'
4= 'no'
8= 'alive at 28 days'
9= 'insufficient data'
;
value HISIHD
1 = 'yes'
2 = 'no'
8 = 'not relevant, alive at 28 days'
9 = 'insufficient data'
;
value ICDVER
1 = 'ICD-8'
2 = 'ICD-9'
3 = 'ICD-9CM'
;
value THROMBD
1= 'yes'
2= 'no'
7= 'acute coronary care data collected continuously'
8= 'not relevant (medically unattended death)'
9= 'insufficient data'
;
* from BADC weather (state of ground);
value whogrnd
10 ="ground dry (no cracks or appreciable amounst of dust/loose sand)"
11 ="ground moist"
12 ="ground wet (standing water in small or large pools on surface)"
13 ="flooded"
14 ="ground frozen"
15 ="glaze on ground"                                                         
16 ="loose dry dust or sand not covering ground completely"
17 ="thin cover of loose dry dust or sand covering ground completely"
18 ="mod/thick cover of loose dry dust/sand covering ground completely"
19 ="extremely dry with cracks"
20 ="ground predominantly covered by ice"
21 ="compact/wet snow (with or without ice) covering less than 1/2 the ground"
22 ="compact/wet snow (with or without ice) covering at least 1/2 the ground"
23 ="even layer of compact or wet snow covering ground completely"
24 ="uneven layer of compact or wet snow covering ground completely"
25 ="loose dry snow covering less than 1/2 the ground"
26 ="loose dry snow covering at least 1/2 the ground (not completely)"
27 ="even layer of loose dry snow covering ground completely"
28 ="uneven layer or loose dry snow covering ground completely"
29 ="snow covering ground completely; deep drifts"
;
* Formats for BADC weather data (Z in 02 for ordering in genmod);
   value whocode
   .="Missing"
  -99="Missing"
   00 ="Cloud development not observed or not observable"
01 ="Cloud generally dissolving or becoming less developed"
02 ="Z-State of sky on the whole unchanged"
03 ="Clouds generally forming or developing"
04 ="Visibility reduced by smoke, e.g. veldt or forest fires, industrial smoke or volcanic ashes"
05 ="Haze"
06 ="Widespread dust in suspension in the air, not raised by wind at or near the station at the time of observation"
07 ="Dust or sand raised by wind at or near the station at the time of observation, but not well-developed dust whirl(s) or sand whirl(s), and no duststorm or sandstorm seen; or, in the case of ships, blowing spray at the station"
08 ="Well developed dust or sand whirl(s) seen at or near the station during the preceding hour or at the time of observation, but no dust storm or sandstorm"
09 ="Duststorm or sandstorm within sight at the time of observation, or at the station during the preceding hour"
10 ="Mist"
11 ="Patches of shallow fog or ice fog at the station, whether on land or sea not deeper than about 2 metres on land or 10 metres at sea"
12 ="More or less continuous shallow fog or ice fog at the station, whether on land or sea, not deeper than about 2m/land or 10m/sea"
13 ="Lightning visible, or thunder heard"
14 ="Precipitation within sight, not reaching the ground or the surface of the sea"
15 ="Precipitation within sight, reaching the ground or the surface of the sea but distant, i.e. > 5 km from the station"
16 ="Precipitation within sight, reaching the ground or the surface of the sea, near to, but not at the station"
17 ="Thunderstorm, but no precipitation at the time of observation"
18 ="Squalls at or within sight of the station during the preceding hour or at the time of observation"
19 ="Funnel clouds at or within sight of the station during the preceding hour or at the time of observation"
20 ="Drizzle (not freezing) or snow grains, not falling as showers, during the preceding hour but not at the time of observation"
21 ="Rain (not freezing), not falling as showers, during the preceding hour but not at the time of observation"
22 ="Snow, not falling as showers, during the preceding hour but not at the time of observation"
23 ="Rain and snow or ice pellets, not falling as showers; during the preceding hour but not at the time of observation"
24 ="Freezing drizzle or freezing rain; during the preceding hour but not at the time of observation"
25 ="Shower(s) of rain during the preceding hour but not at the time of observation"
26 ="Shower(s) of snow, or of rain and snow during the preceding hour but not at the time of observation"
27 ="Shower(s) of hail, or of rain and hail during the preceding hour but not at the time of observation"
28 ="Fog or ice fog during the preceding hour but not at the time of observation"
29 ="Thunderstorm (with or without precipitation) during the preceding hour but not at the time of observation"
30 ="Slight or moderate duststorm or sandstorm -has decreased during the preceding hour"
31 ="Slight or moderate duststorm or sandstorm -no appreciable change during the receding hour"
32 ="Slight or moderate duststorm or sandstorm -has begun or has increased during the preceding hour"
33 ="Severe duststorm or sandstorm -has decreased during the preceding hour"
34 ="Severe duststorm or sandstorm -no appreciable change during the preceding hour"
35 ="Severe duststorm or sandstorm -has begun or has increased during the preceding hour"
36 ="Slight/moderate drifting snow -generally low (below eye level)"
37 ="Heavy drifting snow -generally low (below eye level)"
38 ="Slight/moderate blowing snow -generally high (above eye level)"
39 ="Heavy blowing snow -generally high (above eye level)"
40 ="Fog or ice fog at a a distance at the time of observation, but not at station during the preceding hour, the fog or ice fog extending to a level above that of  the observer"
41 ="Fog or ice fog in patches"
42 ="Fog/ice fog, sky visible, has become thinner during the preceding hour"
43 ="Fog/ice fog, sky invisible, has become thinner during the preceding hour"
44 ="Fog or ice fog, sky visible, no appreciable change during the past hour"
45 ="Fog or ice fog, sky invisible, no appreciable change during the preceding hour"
46 ="Fog or ice fog, sky visible, has begun or has become thicker during preceding hour"
47 ="Fog or ice fog, sky invisible, has begun or has become thicker during the preceding hour"
48 ="Fog, depositing rime, sky visible"
49 ="Fog, depositing rime, sky invisible"
50 ="Drizzle, not freezing, intermittent, slight at time of ob."
51 ="Drizzle, not freezing, continuous, slight at time of ob."
52 ="Drizzle, not freezing, intermittent, moderate at time of ob."
53 ="Drizzle, not freezing, continuous, moderate at time of ob."
54 ="Drizzle, not freezing, intermittent, heavy at time of ob."
55 ="Drizzle, not freezing, continuous, heavy at time of ob."
56 ="Drizzle, freezing, slight"
57 ="Drizzle, freezing, moderate or heavy (dense)"
58 ="Rain and drizzle, slight"
59 ="Rain and drizzle, moderate or heavy"
60 ="Rain, not freezing, intermittent, slight at time of ob."
61 ="Rain, not freezing, continuous, slight at time of ob."
62 ="Rain, not freezing, intermittent, moderate at time of ob."
63 ="Rain, not freezing, continuous, moderate at time of ob."
64 ="Rain, not freezing, intermittent, heavy at time of ob."
65 ="Rain, not freezing, continuous, heavy at time of ob."
66 ="Rain, freezing, slight"
67 ="Rain, freezing, moderate or heavy"
68 ="Rain or drizzle and snow, slight"
69 ="Rain or drizzle and snow, moderate or heavy"
70 ="Intermittent fall of snowflakes, slight at time of ob."
71 ="Continuous fall of snowflakes, slight at time of ob."
72 ="Intermittent fall of snowflakes, moderate at time of ob."
73 ="Continuous fall of snowflakes, moderate at time of ob."
74 ="Intermittent fall of snowflakes, heavy at time of ob."
75 ="Continuous fall of snowflakes, heavy at time of ob."
76 ="Diamond dust (with or without fog)"
77 ="Snow grains (with or without fog)"
78 ="Isolated star-like snow crystals (with or without fog)"
79 ="Ice pellets"
80 ="Rain shower(s), slight"
81 ="Rain shower(s), moderate or heavy"
82 ="Rain shower(s), violent"
83 ="Shower(s) of rain and snow, slight"
84 ="Shower(s) of rain and snow, moderate or heavy"
85 ="Snow shower(s), slight"
86 ="Snow shower(s), moderate or heavy"
87 ="Shower(s) of snow pellets or small hail, with or without rain or rain and snow mixed -slight"
88 ="Shower(s) of snow pellets or small hail, with or without rain or rain and snow mixed -moderate or heavy"
89 ="Shower(s) of hail, with or without rain or rain and snow mixed, not associated with thunder - slight"
90 ="Shower(s) of hail, with or without rain or rain and snow mixed, not associated with thunder - moderate or heavy"
91 ="Slight rain at time of observation -Thunderstorm during the preceding hour but not at time of observation"
92 ="Moderate or heavy rain at time of observation -Thunderstorm during the preceding hour but not at time of observation"
93 ="Slight snow, or rain and snow mixed or hail at time of observation - Thunderstorm during the preceding hour but not at time of observation"
94 ="Moderate or heavy snow, or rain and snow mixed or hail at time of observation -Thunderstorm during the preceding hour but not at time of observation"
95 ="Thunderstorm, slight or moderate, without hail, but with rain and/or snow at time of observation"
96 ="Thunderstorm, slight or moderate, with hail at time of ob."
97 ="Thunderstorm, heavy, without hail, but with rain and/or snow at time of observation"
98 ="Thunderstorm combined with dust/sandstorm at time of observation"
99 ="Thunderstorm, heavy with hail at time of observation"
;
value wholcld
   .="Missing"
0 ="no stratocumulus, stratus, cumulus or cumulonimbus"
1 ="cumulus with little vertical extent and seemingly flattened, or ragged cumulus, other than of bad weather, or both"
2 ="cumulus of moderate or strong vertical extent, generally with protuberances in the form of domes or towers, either accompanied or not by other cumulus or stratocumulus, all having bases at the same level"
3 ="cumulonimbus, the summits of which, at least partially, lack sharp outlines but are neither clearly fibrous (cirriform) nor in the form of an anvil; cumulus, stratocumulus or stratus may also be present"
4 ="stratocumulus formed by the spreading out of cumulus; cumulus may also be present"
5 ="stratocumulus not resulting from the spreading out of cumulus" 
6 ="stratus in a more or less continuous later, or in ragged shreds, or both but no stratus fractus of bad weather"
7 ="stratus fractus of bad weather or cumulus fractus of bad weather, or both (pannus), usually below altostratus or nimbostratus"
8 ="cumulus and stratocumulus other than that formed from the spreading out of cumulus; the base of the cumulus is at a different level from that of the stratocumulus"
9 ="cumulonimbus, the upper part of which is clearly fibrous (cirriform) often in the form of an anvil; either accompanied or not by cumulonimbus without anvil or fibrous upper part, by cumulus, stratocumulus, stratus or pannus"
;
* from acute coronary care form;
value timeac
1 = '0-5 minutes'
2 = '6-59 minutes' 
3 = '60-119 minutes' 
4 = '2 hours-3 hours 59 minutes' 
5 = '4 hours- 23 hours 59 minutes' 
6 = '>= 24 hours' 
7 = 'not known, but probably < 24 hours' 
8 = 'not relevant, no medical presence'
9 = 'insufficient data'
;
value initc
1 = 'bystander' 
2 = 'general practitioner' 
3 = 'mobile team, medical or paramedical' 
4 = 'hospital' 
5 = 'bystander and/or practitioner followed by mobile team' 
6 = 'routine ambulance' 
8 = 'not relevant' 
9 = 'insufficient data'
;
value carout
1 = 'yes' 
2 = 'no' 
8 = 'not relevant, onset in hospital' 
9 = 'insufficient data'
. = 'missing'
;
value resout
1 = 'yes' 
2 = 'no' 
8 = 'not relevant - no cardiac arrest outside hospital' 
9 = 'insufficient data'
;
value resarr
1 = 'yes' 
2 = 'no' 
8 = 'not relevant, no cardiac arrest outside hospital, or never taken to hospital' 
9 = 'insufficient data'
;
value carin
1 = 'yes' 
2 = 'no' 
8 = 'not relevant, not taken to hospital' 
9 = 'insufficient data'
;
value resin
1 = 'yes' 
2 = 'no' 
8 = 'not relevant, no cardiac arrest after arrival, or never in hospital' 
9 = 'insufficient data'
;
value sysbp
0 = 'no pressure' 
888 = 'not recorded' 
999 = 'insufficient data' 
;
value pulse
0 = 'no pulse' 
888 = 'not recorded' 
999 = 'insufficient data'
;
value ECGSTE
1 = 'yes' 
2 = 'no' 
8 = 'no ECG recorded, or all uncodable' 
9 = 'insufficient data'
;
value ECGSTD
1 = 'yes' 
2 = 'no' 
8 = 'no ECG recorded, or all uncodable' 
9 = 'insufficient data'
;
value ECGEVO
1 = 'yes'
2 = 'no' 
8 = 'no ECG recorded, or all uncodable' 
9 = 'insufficient data'
;
value ECGANT
1 = 'yes' 
2 = 'no' 
8 = 'no ECG recorded, or all uncodable'
9 = 'insufficient data'
;
value CPK
8888 = 'not relevant, not measured' 
9999 = 'insufficient data'
;
value AST
8888 = 'not relevant, not measured' 
9999 = 'insufficient data'
;
value HBD
8888 = 'not relevant, not measured' 
9999 = 'insufficient data'
;
value cunit
1 = 'yes' 
2 = 'no' 
8 = 'not relevant, sudden death' 
9 = 'insufficient data'
;
value cstay 
88 = 'not relevant' 
99 = 'insufficient data'
;
value yesnoid
1 = 'yes' 
2 = 'no' 
9 = 'insufficient data'
. = 'missing'
;
value hstay
28= 'more than 27 days'
88= 'not relevant (not admitted to hospital)'
99= 'insufficient data'
;
value yesnoidn
1 = 'yes' 
2 = 'no' 
8 = 'not relevant, medically unattended death' 
9 = 'insufficient data' 
;
value inod
1 = 'yes, route and class of drug not specified'
2 = 'no'
3 = 'oral digitalis glycoside only'
4 = 'intramuscular or intravenous digitalis glycoside, with or without oral digitalis glycoside' 
5 = 'oral non-digitalis inotropic drug' 
6 = 'intramuscular or intravenous non-digitalis inotropic drug, with or without oral non-digitalis glycoside'
7 = 'mixture of digitalis and non-digitalis inotropic drugs by different routes' 
8 = 'not relevant, medically unattended death'
9 = 'insufficient data'  
;
value nitrod
1 = 'yes, route not specified'
2 = 'no'
3 = 'oral or topical (transdermal application) only' 
4 = 'intravenous administration with or without oral or topical use'
8 = 'not relevant, medically unattended death' 
9 = 'insufficient data' 
;
value yesnoidd
1 = 'yes' 
2 = 'no' 
8 = 'not relevant because patient died'
9 = 'insufficient data' 
;
value plod 
1 = 'outside hospital' 
2 = 'in ambulance on way to hospital' 
3 = 'in hospital emergency room' 
4 = 'death occurred around time of arrival at hospital but place is not known' 
5 = 'death in coronary care unit' 
6 = 'death in hospital ward other than coronary care unit' 
7 = 'death in other or unspecified location in hospital' 
8 = 'not relevant, did not die' 
9 = 'insufficient data'
;
run;
 
data work.centname;
length centname $ 26.;
centre=10; centname='Perth, Australia'; output;
centre=11; centname='Newcastle, Australia'; output;
centre=12; centname='Belgium'; output;
centre=14; centname='Luxembourg'; output;
centre=15; centname='Halifax, Canada'; output;
centre=17; centname='Beijing, China'; output;
centre=18; centname='Czech Republic'; output;
centre=19; centname='Glostrup'; output;
centre=20; centname='Finland'; output;
centre=23; centname='East Germany'; output;
centre=24; centname='Bremen, Germany'; output;
centre=25; centname='Heidelberg, Germany'; output; 
centre=26; centname='Augsburg, Germany'; output;
centre=27; centname='Budapest, Hungary'; output;
centre=28; centname='Iceland'; output;
centre=32; centname='Friuli, Italy'; output;
centre=33; centname='Auckland, New Zealand'; output;
centre=34; centname='Belfast, UK'; output;
centre=35; centname='Tarnobrzeg Voivodship, Poland'; output;
centre=36; centname='Warsaw, Poland'; output;
centre=37; centname='Glasgow, UK'; output;
centre=39; centname='Catalonia, Spain'; output;
centre=40; centname='Gothenburg, Sweden'; output;
centre=43; centname='Stanford, USA'; output;
centre=45; centname='Kaunas, Lithuania'; output;
centre=46; centname='Moscow, Russia'; output;
centre=47; centname='Novosibirsk, Russia'; output;
centre=49; centname='Novi Sad, Yugoslavia'; output;
centre=50; centname='Switzerland'; output;
centre=54; centname='Strasbourg, France'; output;
centre=55; centname='Toulouse, France'; output;
centre=57; centname='Area Brianza, Italy'; output;
centre=59; centname='Lille, France'; output;
centre=60; centname='Northern Sweden'; output;
run;

* Data set of combined centre names and reporting units;
data work.centnmsh;
length centname $ 26.;
centre=57; runit=1; centname='Area Brianza'; monname='ITA-BRI'; shortname='AB'; output;
centre=33; runit=1; centname='Auckland'; monname='NEZ-AUC'; shortname='A'; output;
centre=26; runit=99; centname='Augsburg'; monname='GER-AUG'; shortname='Ag'; output;
centre=17; runit=1; centname='Beijing'; monname='CHN-BEI'; shortname='Be'; output;
centre=34; runit=1; centname='Belfast'; monname='UNK-BEL'; shortname='B'; output;
centre=24; runit=99; centname='Bremen'; monname='GER-BRE'; shortname='Br'; output;
centre=39; runit=3; centname='Catalonia'; monname='SPA-CAT'; shortname='Ca'; output;
centre=12; runit=2; centname='Charleroi'; monname='BEL-CHA'; shortname='C'; output;
centre=18; runit=99; centname='Czech Republic'; monname='CZE-CZE'; shortname='CR'; output;
centre=23; runit=99; centname='East Germany'; monname='GER-EGE'; shortname='E'; output;
centre=32; runit=99; centname='Friuli'; monname='ITA-FRI'; shortname='F'; output;
centre=12; runit=1; centname='Ghent'; monname='BEL-GHE'; shortname='Gh'; output;
centre=19; runit=1; centname='Glostrup'; monname='DEN-GLO'; shortname='Gl'; output;
centre=37; runit=1; centname='Glasgow'; monname='UNK-GLA'; shortname='G'; output;
centre=40; runit=1; centname='Gothenburg'; monname='SWE-GOT'; shortname='Go'; output;
centre=15; runit=1; centname='Halifax'; monname='CAN-HAL'; shortname='H'; output;
centre=25; runit=99; centname='Heidelberg'; monname='GER-RHN'; shortname='He'; output; 
centre=28; runit=99; centname='Iceland'; monname='ICE-ICE'; shortname='I'; output;
centre=20; runit=3; centname='Kuopio'; monname='FIN-KUO'; shortname='K'; output;
centre=45; runit=1; centname='Kaunas'; monname='LTU-KAU'; shortname='Ka'; output;
centre=59; runit=1; centname='Lille'; monname='FRA-LIL'; shortname='L'; output;
centre=14; runit=1; centname='Luxembourg'; monname='BEL-LUX'; shortname='Lu'; output; 
centre=46; runit=97; centname='Moscow Control'; monname='RUS-MOC'; shortname='MC'; output;
centre=46; runit=98; centname='Moscow Inter.'; monname='RUS-MOI'; shortname='MI'; output;
centre=11; runit=99; centname='Newcastle'; monname='AUS-NEW'; shortname='N'; output;
centre=47; runit=97; centname='Novosibirsk Control'; monname='RUS-NOC'; shortname='NC'; output;
centre=47; runit=98; centname='Novosibirsk Inter.'; monname='RUS-NOI'; shortname='NI'; output;
centre=20; runit=2; centname='North Karelia'; monname='FIN-NKA'; shortname='NK'; output;
centre=49; runit=1; centname='Novi Sad'; monname='YUG-NOS'; shortname='No'; output;
centre=60; runit=99; centname='N. Sweden'; monname='SWE-NSW'; shortname='NS'; output;
centre=10; runit=99; centname='Perth'; monname='AUS-PER'; shortname='P'; output;
centre=54; runit=1; centname='Strasbourg'; monname='FRA-STR'; shortname='S'; output;
centre=43; runit=99; centname='Stanford'; monname='USA-STA'; shortname='St'; output;
centre=50; runit=3; centname='Ticino'; monname='SWI-TIC'; shortname='T'; output;
centre=55; runit=1; centname='Toulouse'; monname='FRA-TOU'; shortname='To'; output;
centre=20; runit=6; centname='Turku/Loimaa'; monname='FIN-TUL'; shortname='TL'; output;
centre=35; runit=99; centname='Tarnobrzeg Voivodship'; monname='POL-TAR'; shortname='TV'; output;
centre=50; runit=1; centname='Vaud/Fribourg'; monname='SWI-VAF'; shortname='V'; output;
centre=36; runit=99; centname='Warsaw'; monname='POL-WAR'; shortname='W'; output;
run;
proc sort data=work.centnmsh;
   by centre runit;
run;

* Data set of latitudes;
data work.latitude;
length city $ 10.;
centre=10; runit=99; latitude=31+(57/60); longitude=(115+(51/60)); city='Perth'; output;
centre=11; runit=99; latitude=32+(56/60); longitude=(151+(46/60)); city='Newcastle'; output;
centre=12; runit=1; latitude=51+(3/60); longitude=(3+(43/60)); city='Ghent'; output;
centre=12; runit=2; latitude=50+(25/60); longitude=(4+(26/60)); city='Charleroi'; output;
centre=15; runit=1; latitude=44+(39/60); longitude=-(63+(36/60)); city='Halifax'; output;
centre=17; runit=1; latitude=39+(55/60); longitude=(116+(25/60)); city='Beijing'; output;
centre=18; runit=99; latitude=50+(5/60); longitude=(14+(26/60)); city='Prague'; output; *<-used Prague;
centre=19; runit=1; latitude=55+(40/60); longitude=(12+(24/60)); city='Glostrup'; output; *<-used Glostrup;
centre=20; runit=2; latitude=62+(36/60); longitude=(29+(46/60)); city='Joensuu'; output; *<- used Joensuu;
centre=20; runit=3; latitude=62+(54/60); longitude=(27+(41/60)); city='Kuopio'; output;
centre=20; runit=6; latitude=60+(27/60); longitude=(22+(17/60)); city='Turku'; output; *<-used Turku;
centre=23; runit=99; latitude=50+(50/60); longitude=(12+(55/60)); city='Chemnitz'; output; *<-used Chemnitz;
centre=24; runit=99; latitude=53+(4/60); longitude=(8+(49/60)); city='Bremen'; output;
centre=26; runit=99; latitude=48+(23/60); longitude=(10+(53/60)); city='Augsburg'; output;
centre=28; runit=99; latitude=64+(9/60); longitude=-(21+(51/60)); city='Reykjavik'; output;
centre=32; runit=99; latitude=46+(3/60); longitude=(13+(14/60)); city='Udine'; output; *<-used Udine;
centre=33; runit=1; latitude=36+(52/60); longitude=(174+(46/60)); city='Auckland'; output;
centre=34; runit=1; latitude=54+(36/60); longitude=-(5+(53/60)); city='Belfast'; output;
centre=35; runit=99; latitude=50+(35/60); longitude=(21+(41/60)); city='Tarnobrzeg'; output;
centre=36; runit=99; latitude=52+(15/60); longitude=(21); city='Warsaw'; output;
centre=37; runit=1; latitude=55+(53/60); longitude=-(4+(15/60)); city='Glasgow'; output;
centre=39; runit=3; latitude=41+(23/60); longitude=(2+(11/60)); city='Barcelona'; output; *<- used Barcelona ;
centre=40; runit=1; latitude=57+(43/60); longitude=(11+(58/60)); city='Gothenburg'; output;
centre=43; runit=99; latitude=37+(25/60); longitude=-(122+(10/60)); city='Stanford'; output; * California;
centre=45; runit=1; latitude=54+(54/60); longitude=(23+(54/60)); city='Kaunas'; output;
centre=46; runit=97; latitude=55+(45/60); longitude=(37+(35/60)); city='Moscow'; output;
centre=46; runit=98; latitude=55+(45/60); longitude=(37+(35/60)); city='Moscow'; output;
centre=47; runit=97; latitude=55+(02/60); longitude=(82+(55/60)); city='Novosibirsk'; output;
centre=47; runit=98; latitude=55+(02/60); longitude=(82+(55/60)); city='Novosibirsk'; output;
centre=49; runit=1; latitude=45+(15/60); longitude=(19+(50/60)); city='Novi Sad'; output;
centre=50; runit=1; latitude=46+(48/60); longitude=(7+(9/60)); city='Fribourg'; output; *<- used Fribourg ;
centre=50; runit=3; latitude=46+(31/60); longitude=(6+(38/60)); city='Lausanne'; output; *<- used Lausanne ;
centre=54; runit=1; latitude=48+(35/60); longitude=(7+(45/60)); city='Strasbourg'; output;
centre=55; runit=1; latitude=43+(36/60); longitude=(1+(26/60)); city='Toulouse'; output;
centre=57; runit=1; latitude=45+(28/60); longitude=(9+(12/60)); city='Milan'; output; *<- used Milan;
centre=59; runit=1; latitude=50+(34/60); longitude=3+(6/60); city='Lille'; output; 
centre=60; runit=99; latitude=65+(51/60); longitude=(23+(8/60)); city='Kalix'; output; *<- used Kalix;
run;

* Macro to call centres and reporting units;
%macro callcent(macname,cvar);
   %&macname(10,99,&cvar.);   %&macname(11,99,&cvar.);   %&macname(12,1,&cvar.);
   %&macname(12,2,&cvar.);   %&macname(15,1,&cvar.);   %&macname(17,1,&cvar.);
   %&macname(18,99,&cvar.);   %&macname(19,1,&cvar.);   %&macname(20,2,&cvar.);
   %&macname(20,3,&cvar.);   %&macname(20,6,&cvar.);   %&macname(23,99,&cvar.);
   %&macname(24,99,&cvar.);   %&macname(26,99,&cvar.);   %&macname(28,99,&cvar.);
   %&macname(32,99,&cvar.);   %&macname(33,1,&cvar.);   %&macname(34,1,&cvar.);
   %&macname(35,99,&cvar.);   %&macname(36,99,&cvar.);   %&macname(37,1,&cvar.);
   %&macname(39,3,&cvar.);   %&macname(40,1,&cvar.);   %&macname(43,99,&cvar.);
   %&macname(45,1,&cvar.);   %&macname(46,97,&cvar.);   %&macname(46,98,&cvar.);
   %&macname(47,97,&cvar.);   %&macname(47,98,&cvar.);   %&macname(49,1,&cvar.);
   %&macname(50,1,&cvar.);   %&macname(50,3,&cvar.);   %&macname(54,1,&cvar.);
   %&macname(55,1,&cvar.);   %&macname(57,1,&cvar.);   %&macname(59,1,&cvar.);
   %&macname(60,99,&cvar.);
%mend callcent;
* Add Heidelburg and Luxembourg;
%macro callcentplus(macname,cvar);
   %&macname(10,99,&cvar.);   %&macname(11,99,&cvar.);   %&macname(12,1,&cvar.);
   %&macname(12,2,&cvar.);   %&macname(14,1,&cvar.); %&macname(15,1,&cvar.);   %&macname(17,1,&cvar.);
   %&macname(18,99,&cvar.);   %&macname(19,1,&cvar.);   %&macname(20,2,&cvar.);
   %&macname(20,3,&cvar.);   %&macname(20,6,&cvar.);   %&macname(23,99,&cvar.);
   %&macname(24,99,&cvar.);   %&macname(25,99,&cvar.); %&macname(26,99,&cvar.);   %&macname(28,99,&cvar.);
   %&macname(32,99,&cvar.);   %&macname(33,1,&cvar.);   %&macname(34,1,&cvar.);
   %&macname(35,99,&cvar.);   %&macname(36,99,&cvar.);   %&macname(37,1,&cvar.);
   %&macname(39,3,&cvar.);   %&macname(40,1,&cvar.);   %&macname(43,99,&cvar.);
   %&macname(45,1,&cvar.);   %&macname(46,97,&cvar.);   %&macname(46,98,&cvar.);
   %&macname(47,97,&cvar.);   %&macname(47,98,&cvar.);   %&macname(49,1,&cvar.);
   %&macname(50,1,&cvar.);   %&macname(50,3,&cvar.);   %&macname(54,1,&cvar.);
   %&macname(55,1,&cvar.);   %&macname(57,1,&cvar.);   %&macname(59,1,&cvar.);
   %&macname(60,99,&cvar.);
%mend callcentplus;
%macro callcent2(macname,cvar,cvar2,cvar3,cvar4);
   %&macname(10,99,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(11,99,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(12,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(12,2,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(15,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(17,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(18,99,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(19,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(20,2,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(20,3,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(20,6,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(23,99,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(24,99,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(26,99,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(28,99,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(32,99,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(33,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(34,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(35,99,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(36,99,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(37,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(39,3,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(40,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(43,99,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(45,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(46,97,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(46,98,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(47,97,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(47,98,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(49,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(50,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(50,3,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(54,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(55,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(57,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(59,1,&cvar.,&cvar2.,&cvar3.,&cvar4.);
   %&macname(60,99,&cvar.,&cvar2.,&cvar3.,&cvar4.);
%mend callcent2;

* Macro to call centres and reporting units (women - excludes centre=50);
%macro callcenf(macname,cvar);
   %&macname(10,99,&cvar.);
   %&macname(11,99,&cvar.);
   %&macname(12,1,&cvar.);
   %&macname(12,2,&cvar.);
   %&macname(15,1,&cvar.);
   %&macname(17,1,&cvar.);
   %&macname(18,99,&cvar.);
   %&macname(19,1,&cvar.);
   %&macname(20,2,&cvar.);
   %&macname(20,3,&cvar.);
   %&macname(20,6,&cvar.);
   %&macname(23,99,&cvar.);
   %&macname(24,99,&cvar.);
   %&macname(26,99,&cvar.);
   %&macname(28,99,&cvar.);
   %&macname(32,99,&cvar.);
   %&macname(33,1,&cvar.);
   %&macname(34,1,&cvar.);
   %&macname(35,99,&cvar.);
   %&macname(36,99,&cvar.);
   %&macname(37,1,&cvar.);
   %&macname(39,3,&cvar.);
   %&macname(40,1,&cvar.);
   %&macname(43,99,&cvar.);
   %&macname(45,1,&cvar.);
   %&macname(46,97,&cvar.);
   %&macname(46,98,&cvar.);
   %&macname(47,97,&cvar.);
   %&macname(47,98,&cvar.);
   %&macname(49,1,&cvar.);
   %&macname(54,1,&cvar.);
   %&macname(55,1,&cvar.);
   %&macname(57,1,&cvar.);
   %&macname(59,1,&cvar.);
   %&macname(60,99,&cvar.);
%mend callcenf;

* Macro to create data sets from data.allevent;
%macro creatdat(sur,gender,agelim,hist1,hist2);
data work.cut(drop=sex surviv);
    set data.all;
    if event in (&sur.); * Died?;
    if sex in (&gender.);
    if premi in (&hist1.);
    if histihd in (&hist2.);
	if age>&agelim.;
    dummy=1;
run;
** Convert data to monthly rates;
proc means data=work.cut noprint;
   by centre runit yronset mthonset;
   var dummy;
   output out=work.monthly(drop=_TYPE_ _FREQ_) n=nevents;
run;
* Get the start and stop month and year for each reporting unit;
data work.max(rename=(mthonset=maxmt yronset=maxyr)) work.min(rename=(mthonset=minmt yronset=minyr));
   set work.cut(drop=age dateon yearb);
   by centre runit yronset mthonset;
   if first.runit then output work.min;
   if last.runit then output work.max;
run;
* Fill out;
data work.prefill;
   merge work.max work.min;
   by centre runit;
run;
data work.fill(drop=minmt maxmt minyr maxyr);
   set work.prefill;
   by centre runit;
   yronset=minyr;
   do mthonset=minmt to 12;
      nevents=0;
      output;
   end;   
   do yronset=minyr+1 to maxyr-1;
      do mthonset=1 to 12;
         nevents=0;
	     output;
      end;   
   end;   
   yronset=maxyr;
   do mthonset=1 to maxmt;
      nevents=0;
      output;
   end;   
run;
* Merge back with data;
data work.filled;
   merge work.fill work.monthly;
   by centre runit yronset mthonset;
run;
data work.addtime;
   set work.filled;
   by centre runit;
   retain time 0;
   if first.runit then time=0;
   time=time+1;
run;
%mend creatdat;


* Random number from inverse gamma distribution using rejection method;
* Input data set needs to have 'a' and 'b';
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

*** Get World Development Index data;
proc import datafile='U:\Sas\data\WDI.csv' out=work.WDIin DBMS=CSV REPLACE;
   getnames=yes; 
run;
/*
data work.toplot;
   set work.WDIin;
   if Series="SL.UEM.TOTL.ZS";
run;
goptions reset=all;
symbol1 color=blue i=join value=none;
symbol2 color=red i=join value=none;
symbol3 color=green i=join value=none;
symbol4 color=orange i=join value=none;
symbol5 color=blue i=join value=none line=2;
symbol6 color=orange i=join value=none line=2;
symbol7 color=green i=join value=none line=2;
symbol8 color=green i=join value=none line=3;
symbol9 color=orange i=join value=none line=3;
symbol10 color=black i=join value=none;
symbol11 color=black i=join value=none line=2;
symbol12 color=black i=join value=none line=3;
legend1 value=('AUS' 'BEL' 'CAN' 'CHN' 'FRA' 'GER' 'LTU' 'NZL' 'POL' 'UNK' 'USA' 'YUG');
axis1 minor=none label=('Year');
axis2 minor=none label=(a=90 'Unemployment, % total labour');
proc gplot data=work.toplot;
   plot AUS*year=1 BEL*year=2 CAN*year=7 CHN*year=3 FRA*year=4 GER*year=9 LTU*year=11 NZL*year=5 POL*year=10 UNK*year=6 USA*year=8 YUG*year=8 / overlay noframe legend=legend1 haxis=axis1 vaxis=axis2;
run; quit;
*/

** Get GDP data (from Table 1);
* Missing China, Czech, East Germany, Iceland, Lithuania, Russia;
proc import datafile='U:\Sas\data\GDP.xls' out=work.GDPin DBMS=EXCEL REPLACE;
   getnames=yes; 
run;
proc transpose data=work.GDPin out=work.GDPtran(drop=_LABEL_ rename=(_NAME_=country));
   id Category;
   var Belgium Denmark France Germany Italy Spain UnitedKingdom Finland Sweden Australia Canada NewZealand UnitedStates Poland Yugoslavia;
run;
* Add centre;
data work.GDP;
   set work.GDPtran;
   if country="Australia" then do; centre=10; runit=99; output; centre=11; runit=99; output; end;
   if country="Belgium" then do; centre=12; runit=1; output; centre=12; runit=2; output; end;
   if country="Canada" then do; centre=15; runit=1; output; end;
   if country="Denmark" then do; centre=19; runit=1; output; end;
   if country="Finland" then do; centre=20; runit=2; output; centre=20; runit=3; output;  centre=20; runit=6; output; end;
   if country="Germany" then do; centre=24; runit=99; output; centre=26; runit=99; output; end;
   if country="Italy" then do; centre=32; runit=99; output; centre=57; runit=1; output; end;
   if country="NewZealand" then do; centre=33; runit=1; output; end;
   if country="UnitedKingdom" then do; centre=34; runit=1; output; centre=37; runit=1; output; end;
   if country="Poland" then do; centre=35; runit=99; output; centre=36; runit=99; output; end;
   if country="Spain" then do; centre=39; runit=3; output; end;
   if country="Sweden" then do; centre=40; runit=1; output; centre=60; runit=99; output; end;
   if country="UnitedStates" then do; centre=43; runit=99; output; end;
   if country="Yugoslavia" then do; centre=49; runit=1; output; end;
   if country="Switzerland" then do; centre=50; runit=1; output; centre=50; runit=3; output; end;
   if country="France" then do; centre=54; runit=1; output; centre=55; runit=1; output;  centre=59; runit=1; output; end;
run; 
proc sort data=work.GDP;
   by centre runit;
run;

** Get GDP data (from Table 3);
proc import datafile='U:\Sas\data\GDPcapita.xls' out=work.GDPin DBMS=EXCEL REPLACE;
   getnames=yes; 
run;
proc transpose data=work.GDPin out=work.GDPtran(drop=_LABEL_ rename=(_NAME_=country));
   id Category;
   var Belgium Denmark France Germany Italy Spain UnitedKingdom Finland Sweden Australia Canada NewZealand UnitedStates Poland Yugoslavia;
run;
* Add centre;
data work.GDPcap;
   set work.GDPtran;
   if country="Australia" then do; centre=10; runit=99; output; centre=11; runit=99; output; end;
   if country="Belgium" then do; centre=12; runit=1; output; centre=12; runit=2; output; end;
   if country="Canada" then do; centre=15; runit=1; output; end;
   if country="Denmark" then do; centre=19; runit=1; output; end;
   if country="Finland" then do; centre=20; runit=2; output; centre=20; runit=3; output;  centre=20; runit=6; output; end;
   if country="Germany" then do; centre=24; runit=99; output; centre=26; runit=99; output; end;
   if country="Italy" then do; centre=32; runit=99; output; centre=57; runit=1; output; end;
   if country="NewZealand" then do; centre=33; runit=1; output; end;
   if country="UnitedKingdom" then do; centre=34; runit=1; output; centre=37; runit=1; output; end;
   if country="Poland" then do; centre=35; runit=99; output; centre=36; runit=99; output; end;
   if country="Spain" then do; centre=39; runit=3; output; end;
   if country="Sweden" then do; centre=40; runit=1; output; centre=60; runit=99; output; end;
   if country="UnitedStates" then do; centre=43; runit=99; output; end;
   if country="Yugoslavia" then do; centre=49; runit=1; output; end;
   if country="Switzerland" then do; centre=50; runit=1; output; centre=50; runit=3; output; end;
   if country="France" then do; centre=54; runit=1; output; centre=55; runit=1; output;  centre=59; runit=1; output; end;
run; 
proc sort data=work.GDPcap;
   by centre runit;
run;

* Data quality scores;
data work.qual;
   input centre runit cscore dscore;
   cards;
   10 99 1.1 1.0
   11 99 1.6 1.6
   12 1 0.8 2.0
   12 2 0.5 2.0
   15 1 1.8 2.0
   17 1 1.2 1.0
   18 99 1.8 1.0
   19 1 0.8 2.0
   20 2 1.8 2.0
   20 3 1.8 2.0
   20 6 1.8 2.0
   23 99 1.1 0.0
   24 99 1.4 0.5
   26 99 1.3 2.0
   28 99 1.8 1.7
   32 99 1.7 2.0
   33 1 1.5 2.0
   34 1 1.9 1.0
   35 99 0.9 1.0
   36 99 1.4 2.0
   37 1 1.9 2.0
   39 3 1.5 2.0
   40 1 1.4 2.0
   43 99 1.6 1.0
   45 1 1.7 1.0
   46 97 0.9 1.0
   46 98 0.9 1.0
   47 97 0.9 1.0
   47 98 1.1 1.0
   49 1 1.9 1.0
   50 1 0.9 2.0
   50 3 1.1 2.0
   54 1 1.7 1.0
   55 1 0.9 2.0
   57 1 1.7 2.0
   59 1 1.2 2.0
   60 99 1.9 2.0
;
run;
data work.quality;
   set work.qual;
   centrer=centre+(runit/100);
   tscore=cscore+dscore;
run;

* Get temperature data;
/* Temporary comments
proc import datafile='C:\My Documents\Yingqin\Monica Yingqin\weather\MONICA weather data.xls' out=work.weathm DBMS=EXCEL REPLACE;
   getnames=yes; 
run;
proc import datafile='C:\My Documents\Yingqin\Monica Yingqin\weather\Finland weather data.xls' out=work.weathf DBMS=EXCEL REPLACE;
   getnames=yes; 
run;
data work.weath;
   set work.weathm work.weathf;
run;
proc sort data=work.weath;
   by centre runit month;
run;
data work.weather(rename=(month=mthonset));
   set work.weath(drop=city country);
   if runit=. then delete;
   ave_c=(average-32)*(5/9); *<- conversion to celcius;
run;*/

** Average high temperatures from worldclimate.com;
* avehigh is the highest annual average temperature (any month);
* avelow is the lowest annual average temperature;
* annmax is the warmest average monthly maximum (some from BBC);
* annmin is the coldest average monthly minimum;
data work.weatherhighlow;
length city $ 11.;
centre=10; runit=99; avehigh=23.8; avelow=13.2; aveann=18.3; annmax=30.0; annmin=9.0; city='Perth'; output;
centre=11; runit=99; avehigh=22.3; avelow=12.4; aveann=17.9; annmax=25.5; annmin=8.3; city='Newcastle'; output;
centre=12; runit=1; avehigh=16.6; avelow=3.0; aveann=9.9; city='Oostende'; output;
centre=12; runit=2; avehigh=17.9; avelow=2.4; aveann=10.2; city='Charleroi'; output;
centre=15; runit=1; avehigh=18.1; avelow=-4.9; aveann=6.3; annmax=23.4; annmin=-9.6; city='Halifax'; output;
centre=17; runit=1; avehigh=26.0; avelow=-4.6; aveann=11.8; annmax=31.3; annmin=-9.6; city='Beijing'; output;
centre=18; runit=99; avehigh=19.3; avelow=-1.3; aveann=9.2; annmax=23; annmin=-5; city='Prague'; output; *<-used Prague;
centre=19; runit=1; avehigh=17.1; avelow=-0.4; aveann=7.8; annmax=22; annmin=-3; city='Copenhagen'; output; *<-used COPENHAGEN ;
centre=20; runit=2; avehigh=16.1; avelow=-12.0; aveann=2.4; city='Joensuu'; output; *<- used Joensuu;
centre=20; runit=3; avehigh=17.1; avelow=-12.2; aveann=3.1; city='Kuopio'; output;
centre=20; runit=6; avehigh=17.0; avelow=-6.2; aveann=4.7;  city='Turku'; output; *<-used Turku;
centre=23; runit=99; avehigh=18.4; avelow=0.1; aveann=9.1; city='Dresden'; output; *<-used Chemnitz;
centre=24; runit=99; avehigh=17.0; avelow=1.1; aveann=9.1; city='Bremen'; output;
centre=26; runit=99; avehigh=17.9; avelow=-1.3; aveann=8.5; city='Augsburg'; output;
centre=28; runit=99; avehigh=11.1; avelow=-0.3; aveann=4.6; annmax=14; annmin=-2; city='Reykjavik'; output;
centre=32; runit=99; avehigh=22.6; avelow=2.6; aveann=12.7; annmax=28.0; annmin=-0.1; city='Udine'; output; *<-used Udine;
centre=33; runit=1; avehigh=19.5; avelow=10.8; aveann=15.1; city='Auckland'; output;
centre=34; runit=1; avehigh=14.7; avelow=4.1; aveann=9.0; city='Belfast'; output;
centre=35; runit=99; avehigh=18.6; avelow=-6.1; aveann=7.4; city='Rzeszw'; output;
centre=36; runit=99; avehigh=18.2; avelow=-2.1; aveann=7.5; city='Warsaw'; output;
centre=37; runit=1; avehigh=14.6; avelow=3.5; aveann=8.5; city='Glasgow'; output;
centre=39; runit=3; avehigh=24.2; avelow=9.1; aveann=16.2; city='Barcelona'; output; *<- used Barcelona ;
centre=40; runit=1; avehigh=15.7; avelow=-2.7; aveann=7.3; city='Gothenburg'; output;
centre=43; runit=99; avehigh=18.2; avelow=9.6; aveann=14.6; city='Stanford'; output; * California, used Oakland;
centre=45; runit=1; avehigh=17.4; avelow=-5.2; aveann=6.5; city='Kaunas'; output;
centre=46; runit=97; avehigh=18.5; avelow=-10.3; aveann=4.2; annmax=23; annmin=-16; city='Moscow'; output;
centre=46; runit=98; avehigh=18.5; avelow=-10.3; aveann=4.2; city='Moscow'; output;
centre=47; runit=97; avehigh=19.0; avelow=-14.6; aveann=2.3; city='Novosibirsk'; output;
centre=47; runit=98; avehigh=19.0; avelow=-14.6; aveann=2.3; city='Novosibirsk'; output;
centre=49; runit=1; avehigh=21.5; avelow=0.5; aveann=11.5; city='Belgrade'; output;
centre=50; runit=1; avehigh=17.5; avelow=-0.7; aveann=8.6; city='Payerne'; output; *<- Vaud/Fribourg ;
centre=50; runit=3; avehigh=18.9; avelow=0.9; aveann=9.9; city='Aigle'; output; *<- Ticino (Lausanne);
centre=54; runit=1; avehigh=18.8; avelow=0.0; aveann=9.6; city='Strasbourg'; output; * worldclimate.com;
centre=55; runit=1; avehigh=21.1; avelow=4.6; aveann=12.5; city='Toulouse'; output;
centre=57; runit=1; avehigh=23.8; avelow=1.1; aveann=12.7; annmax=29; annmin=0; city='Milan'; output; *<- used Milan;
centre=59; runit=1; avehigh=17.5; avelow=2.0; aveann=9.6; city='Lille'; output; 
centre=60; runit=99; avehigh=15.1; avelow=-11.7; aveann=1.3; city='Lulea/Kallax'; output; *<- used Kalix;
run;