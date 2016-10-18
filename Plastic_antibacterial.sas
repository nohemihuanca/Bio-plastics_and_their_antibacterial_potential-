data G9;
 input pro$ plast$ eu count;
 /*
 A=Albumin
 B=Soy
 C=Zein
 D=Whey
 w=water
 g=glycerol
 n=natural rubber*/
datalines;
A w 1 46
A w 2 832
A w 3 616
A w 4 4
A g 1 14
A g 2 47
A g 3 2
A g 4 113
A n 1 44
A n 2 334
A n 3 6
A n 4 122
B w 1 35
B w 2 156
B w 3 894
B w 4 29
B g 1 5
B g 2 51
B g 3 160
B g 4 44
B n 1 284
B n 2 135
B n 3 222
B n 4 276
C w 1 12
C w 2 50
C w 3 229
C w 4 302
C g 1 74
C g 2 267
C g 3 52
C g 4 32
C n 1 98
C n 2 44
C n 3 21
C n 4 41
D w 1 17
D w 2 44
D w 3 127
D w 4 374
D g 1 319
D g 2 901
D g 3 168
D g 4 941
D n 1 29
D n 2 86
D n 3 11
D n 4 37
;
proc print;
run;
/* simple effects of plasticizer over protein */
proc glimmix data=Group_9_Data;
class pro plast;
model count=pro|plast/d=negbin;
nloptions maxiter=50; 
lsmeans pro*plast / ilink slicediff=pro plot=meanplot(sliceby=plast join ilink)cl;
ods output slicediffs=simple_effects_byplast;
run;
/* "slicediffs" are on the log scale, called "estimate" in the simple_effects data set */ 
/* convert logit to counts, ratio */
data data_scale_simple_effects_byplast;
 set simple_effects_byplast;
 ratio=exp(estimate);
 stderr_ratio=exp(estimate)*stderr; 
  /* you get the standard error using the "Delta Rule" */
 Lower_Ratio_ConfLimit=exp(lower);
 Upper_Ratio_ConfLimit=exp(upper);
proc print data=data_scale_simple_effects_byplast;
run;

/* simple effects of protein over plasticizer */
proc glimmix data=Group_9_Data;
class pro plast;
model count=pro|plast/d=negbin;
nloptions maxiter=50; 
lsmeans pro*plast / ilink slicediff=plast plot=meanplot(sliceby=pro join ilink)cl;
ods output slicediffs=simple_effects_bypro;
run;
/* convert logit to counts, ratio */
data data_scale_simple_effects_bypro;
 set simple_effects_bypro;
 ratio=exp(estimate);
 stderr_ratio=exp(estimate)*stderr; 
 Lower_Ratio_ConfLimit=exp(lower);
 Upper_Ratio_ConfLimit=exp(upper);
proc print data=data_scale_simple_effects_bypro;
run;
