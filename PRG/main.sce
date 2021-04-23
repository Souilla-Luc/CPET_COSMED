
// Short description 
//  main : file to "run" in scilab (e.g., using F5)
//
// Calling Sequence
//  none : main is the entry point 
//
// Parameters
//  none
//
// Description
//  main is the file to run using the scilab interface 
//
// Repository GitHub page
// https://github.com/Souilla-Luc/CPET_Analysis
// Authors
//  Souilla Luc - Univ Montpellier - France
//  
// Versions
//  Version 1.0.0 -- L.Souilla -- May, 2021
//      with input (from DAT) and ouptut (to RES)

// The main script always contains two parts : 
//  1°) set up of working environement 
//  2°) computations (in the right setup)

// Two main objectives in this script:
// 1°) Report value of Cardiopulmonary in pre-filled medical report
// 2°)Paste values in Database file 
// This script is SPECIFIC to Excel(.xls) file generated by COSMED CPET software
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//**** FIRST : Initialize **** 

// -- Clear workspace
clear ;             // clear all variables
xdel(winsid());     // delete all graphic windows
// Template by D.Mottet available on https://github.com/DenisMot/ScilabDataAnalysisTemplate
PRG_PATH = get_absolute_file_path("main.sce");          
FullFileInitTRT = fullfile(PRG_PATH, "InitTRT.sce" );
exec(FullFileInitTRT);

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// **** SECOND : Do things ****

// Variables are in French
// Report medical have to be written in French as well, for patient and cardiologist comprehension

Name= uigetfile([""],DAT_PATH)
//Name= "P009";// Name of the file dragged in DAT File
Name_txt= Name+".txt"; // Medical report output of this script is "Name.txt"
Name_xls= Name; // should be an excel 2003 file, not xlsx. 
//Cosmed software will generate xlsx,read the document provided on my github page
Fullfname = fullfile(Name);
Sheets= readxls(Fullfname); 


//---|Read data from SHEET 1, which provide Informations and all data |---//
Data_sheet1= Sheets(1);
Str_info=string(Data_sheet1); //convert to strings 
Val_info=strtod(Str_info, "."); //convert to double 


//// Get basics oatients information by using "getInformation.sci" function 
Surname=(getInformation("Nom de famille",Str_info));
Forename=(getInformation("Prénom",Str_info));
TestDate=(getInformation("Date du test",Str_info));
DateOfBirth=(getInformation("Date Naissance",Str_info));
//using strtod to convert Weight,Height,Age as double
Weight=strtod(getInformation("Poids (kg)",Str_info)); 
Height=strtod(getInformation("Taille (cm)",Str_info));
Age=strtod(getInformation("Âge",Str_info));


//---Read data from SHEET 2, which provide results---//
//Sheet 2 display main results of CPET at Warm-up, VAT, Maximum, Cooldown
Data_sheet2 = Sheets(2); 
Str_res = string(Data_sheet2); // convert to string 
Val_res = strtod(Str_res, "."); // convert to double
Labels = Str_res(:,1) ; // Labels are the 1st column of Str_res file 

//    |                                                            |
//    | OBJECTIVE 1 : REPORT VALUE OF IN PRE-FILLED MEDICAL REPORT |
//    |                                                            |

// Create matrix of medical report which will be filled, and give to patient
Medical_report=[]; 

// Variable name of Medical report is written with :
// -  variables measured (first letter uppercase)
// -  then the time of Measure (first letter uppercase)
//for exemple: HrateVat = Heart rate at Ventilatory anaerobic threshold (VAT)
// The script below was logically construct in two steps: 
// 1- Get variables values by using function "GetValue.sci"
// 2- Paste variables values in Medical report using "string" function

//----------- INFORMATIONS ABOUT PATIENT -----------//

Medical_report(1,1)= "Medecin demandeur: ";
Medical_report(2,1)= "Motif de consultation: ";
Medical_report(3,1)= "Protocole de Recherche: ";
Medical_report(4,1)= "Activité physique : ";
Medical_report(5,1)= "Traitement : ";


//----------- SPIROMETRY VARIABLES -----------//


FvcMeas=getValue(Val_res,"CVF","Pré"); //Forced vital capacity
FvcTheo=getValue(Val_res,"CVF","% Préd."); // % of predicted Value

Fev1Meas=getValue(Val_res,"VEMS","Pré");//Forced Expiratory Volume 1sec (Fev1)
Fev1Theo=getValue(Val_res,"VEMS","% Préd.");// % of predicted Value
Fev1Fvc=round((Fev1Meas/FvcMeas)*100);

Medical_report(6,1)=""; // skip lines in file to improve readability
Medical_report(7,1)= "EFR PRE EFFORT :";
Medical_report(8,1)= "VEMS = "+(string(Fev1Meas))+"L soit "+ (string(Fev1Theo))+" % de la théorique";
Medical_report(9,1)= "VEMS/CV = "+(string(Fev1Fvc))+ " % CVF= "+ (string(FvcMeas)) +" L soit "+(string(FvcTheo))+" % de la théorique";

//----------- PROTOCOL INFORMATIONS -----------//

Vo2wattMeas=getValue(Val_res,"Pente VO2/Puiss.","Mesure");// Slope VO2/Watts

Protocol=getInformation("Protocole",Str_info);// Protocol (Watts E= Warm up, I=Incrementation) 
Medical_report(11,1)="PROTOCOLE"; 
Medical_report(12,1)= "Epreuve d''effort cardiorespiratoire de type triangulaire avec mesure de la VO2Max";
Medical_report(13,1)= "Protocole = "+ string(Protocol) + " et une pente VO2/W = " + string(Vo2wattMeas) ;

//----------- ASSESSMENT OF MAXIMAL EFFORT -----------//

VO2kgMax=getValue(Val_res,"VO2/kg","Max");// VO2 max (ml.min.kg)
VO2kgPred=getValue(Val_res,"VO2/kg","% Préd.");// VO2 max predicted (ml.min.kg)
Medical_report(15,1)= " - VO2 max = "+ string(VO2kgMax) + " ml/min/kg soit "+ string(VO2kgPred)+" % de la VO2 prédite"

HrateMax=getValue(Val_res,"FC","Max");// Maximal heart rate (beats/min)
HratePred= getValue(Val_res,"FC","% Préd."); // Maximal heart rate predicted (beats/min)
PowerMax=getValue(Val_res,"Power","Max"); // Maximal work rate (watts)

Medical_report(16,1)= " - Fc max = "+ string(HrateMax) + " bpm soit "+ string(HratePred)+" % de la FC prédite" +" et Puissance max =" + string(PowerMax)+ " watts ";

// Notes: Reliability of Respiratory exchange ratio in pediatric population is difficult
RerMax=getValue(Val_res,"QR","Max");//Maximun Respiratory Exchange ratio 
RerRep=getValue(Val_res,"QR","Repos");// Respiratory Exchange ratio at rest
Medical_report(17,1)= " - QR max  "+ string(RerMax)+ " et QR repos " + string(RerRep);

// Exhaustion, calculated by visual analogic scale (Borg scale)
Dyspnée=getValue(Val_res,"Dyspnée","Max");//Fatigue perception (0-Low  10- High)
Medical_report(18,1)= " - Dyspnée  perçue : "+ string(Dyspnée);

// We have to made specific treatment for RPM (pedalling frequency) variable 
[ilinPhase,icolPhase]=find(Str_info=="Phase"); 
ilinPhase= find(Str_info(:,icolPhase)=="EXERCISE"); // In phase column, select only Exercise Phase
[ilin_pedalage_exo,icol_pedalage_exo]=find(Str_info=="RPM");
Cyclingcadence=Val_info(ilinPhase,icol_pedalage_exo); // Cycling cadence is a merge of Exercise phase and RPM column

if Cyclingcadence <= 55 then
    Medical_report(19,1)= " - Impossibilité de maintenir la vitesse de pédalage "
else Cyclingcadence  > 55 
    Medical_report(19,1)= " - Possibilité de maintenir la vitesse de pédalage "
end


// Was CPET test maximal ?  
Maxcounteur=0; // Maxcounteur = number of criteria met
// If one criteria has been respected, Maxcounteur=Maxcounteur+1
//Patient effort is usually considered to be maximal if 1 or more of the following occurs:
// PMID: 12738602, PMID: 30093254, PMID: 30093255
// Could be more complicated in pediatric population (specially for VO2 plateau)
// These recommandations cannot be directly applied in children, 
// So,maximal criterion have to be checked by an expert in the field 
if HratePred >= 90 then // First criterion
    Maxcounteur=Maxcounteur+1
end
if RerMax >= 1.1 then // Second criterion
    Maxcounteur=Maxcounteur+1
end
if Dyspnée >= 7 then // Third criterion
    Maxcounteur=Maxcounteur+1
end
if Cyclingcadence <= 55 then // Fourth criterion
    Maxcounteur=Maxcounteur+1
end
// In order to help you, I display graphics when you run the script 
// It could be a good way to see if the CPET was maximal or not in complement of this criterion
if Maxcounteur>=1 then 
    Medical_report(14,1)= " Epreuve d''effort maximale avec pour critères de maximalité :";
else 
    Medical_report(14,1)= " Epreuve d''effort sous maximale avec pour critères :";

end

//----------- CARDIOLOGIC VARIABLES -----------//

SystolicMax=getValue(Val_res,"P Syst","Max"); // Maximal Systolic Blood Pressure(mmHg)
OxypulseRest=getValue(Val_res,"VO2/FC","Repos"); // Rest Systolic Blood Pressure(ml/beats)
OxypulseVat=getValue(Val_res,"VO2/FC","SV1"); //Oxygen pulse at VAT(ml/beats)
OxypulseMax=getValue(Val_res,"VO2/FC","Max"); ////Maximal Oxygen pulse (ml/beats)

Medical_report(20,1)= "";
Medical_report(21,1)= "PLAN CARDIOLOGIQUE";
Medical_report(22,1)= "Profil tensionnel normal avec une P syst à " +string(SystolicMax)+ "mmHg au max de l''effort";
Medical_report(23,1)= "Cinétique du Pouls d''O2 : repos "+ string(OxypulseRest)+" ml/btts au SV1 " + string(OxypulseVat)+" ml/btts et au max " + string(OxypulseMax)+" ml/btts";
Medical_report(24,1)="Sur l''ECG : Absence Sous décalage ST / Absence Trouble du rythme / absence d''ESV";

//-----------| RESPIRATORY VARIABLES | -----------//

// Breathing Reserve (VE/MVV)
BreathresMax=getValue(Val_res,"RR","Max"); // Breathing Reserve at the maximal effort (%)
Medical_report(25,1)= "";
Medical_report(26,1)= " PLAN RESPIRATOIRE ";
Medical_report(27,1)=("Réserves ventilatoires entamées/non entamées à ")+string(BreathresMax)+" % ";

// Pulmonary ventilation = Respiratory rate * Tidal volume

RespirateMax=getValue(Val_res,"F.R","Max"); // Maximal Respiratory rate(rates/min)
Petco2Max=getValue(Val_res,"PetCO2","Max");//Maximal End-tidal CO2 partial pressure (mmHg)
TidVolRest=round((getValue(Val_res,"VC","Repos"))*1000); // Tidal volume at rest (mL)
TidVolMax=round((getValue(Val_res,"VC","Max"))*1000);// Maximal Tidal volume ()
TidVolKg= round((TidVolMax/Weight));// Ratio Tidal volume (ml/ Kg)
Tidvolratio=round(TidVolMax/TidVolRest); // Tidal volume kinetics

Medical_report(28,1)="Fréquence Respiratoire correcte / Polypnée d''effort (FR Max = "+ string(RespirateMax)+"cyc/min)"
Medical_report(29,1)="Hyperventilation/Ventilation alvéolaire  (PetCO2 = "+ string (Petco2Max)+" mmHg)"
Medical_report(30,1)= "Augmentation  du VC (x"+string(Tidvolratio)+") avec : Repos = "+ string(TidVolRest) +" ml et Max = " + string(TidVolMax)+ " ml soit VC/Kg = " + string (TidVolKg)+ " ml/kg";

// Ventilatory Equivalent
Vevco2Max=getValue(Val_res,"VE/VCO2","Max");// Maximal Ventilatory equivalents for carbon dioxide (VE/VCO2)
Vevo2Max=getValue(Val_res,"VE/VO2","Max");// Maximal Ventilatory equivalents for oxygen (VE/VO2)
Medical_report(31,1)="Équivalent respiratoires : VE/VCO2 au max de l''effort = "+string(Vevco2Max)+" et VE/VO2 au max de l''effort = "+string(Vevo2Max);

// VE/VCO2 Slope and Oxygen Uptake Efficiency Slope (OUES)
Slopevevco2Max= getValue(Val_res,"Pente VE/VCO2","Mesure"); // Maximal Slope VE/VCO2
OuesMax=getValue(Val_res,"OUES","Mesure");// Maximal OUES (ml/min/l/min)
Medical_report(32,1)= "Ineficacité/ Efficacité respiratoire avec Pente VE/VCO2 au max de l''effort = "+ string(Slopevevco2Max);
Medical_report(33,1)= "OUES = "+string(OuesMax)+" ml/min/l/min";

//-----------| PERIPHERIC VARIABLES| -----------//

Vo2kgVat=getValue(Val_res,"VO2/kg","SV1");// VO2 (ml.min.kg) at VAT
Vo2kgPred=getValue(Val_res,"VO2/kg","Préd.");// Maximal VO2 (ml.min.kg) predicted
Vo2kgVatpred=round((Vo2kgVat/Vo2kgPred)*100);// VO2 predicted (ml.min.kg) at VAT
HrateVat=getValue(Val_res,"FC","SV1");// Heart rate (beats/min) at VAT
PowerVat=getValue(Val_res,"Power","SV1");// Power (Watts) at VAT

Medical_report(34,1)=""
Medical_report(35,1)=" PLAN PÉRIPHÉRIQUE "
Medical_report(36,1)= "Seuil ventilatoire (SV1) estimé à "+ string(Vo2kgVat)+" ml/min/kg soit "+string(Vo2kgVatpred)+" % de la VO2 max Théorique pour une fréquence cardiaque de "+ string(HrateVat)+" bpm et une puissance de "+string(PowerVat)+" Watts"

//-----------| INTERPRETATION | -----------// 
Medical_report(37,1)=""
Medical_report(38,1)=" BILAN "

// Cardiorespiratory fitness interpretation (VO2)
if Maxcounteur>=1 & VO2kgPred>80 then
    Medical_report(39,1)="Epreuve d''effort maximale avec aptitude aérobie normale (VO2kg ="+ string(VO2kgMax)+"ml/min/kg soit "+ string(VO2kgPred)+ " % de VO2 théorique)";
else Maxcounteur>=1 & VO2kgPred<80
    Medical_report(39,1)="Epreuve d''effort maximale avec aptitude aérobie diminuée (VO2kg ="+ string(VO2kgMax)+"ml/min/kg soit "+ string(VO2kgPred)+ " % de VO2 théorique)"
end
if Maxcounteur<1 then
    Medical_report(39,1)="Epreuve d''effort sous-maximale rendant l''interprétation de l''aptitude aérobie difficile"
end

// Peripheric muscular limitation 
if Vo2kgVatpred <50 then
    Medical_report(40,1) = "Présence d''un léger déconditionnement musculaire  périphérique "
else Vo2kgVatpred >= 50
    Medical_report(40,1)= "Bonne condition musculaire périphérique "
end
if Vo2kgVatpred <40 then
    Medical_report(40,1) = "Présence d''un déconditionnement musculaire périphérique important"
end
// EKG
// Cardiologist has to check cardiac variables during effort and report  himself 
Medical_report(41,1)= "Bonne / Mauvaise adaptation cardiovasculaire ; Absence / Présence de trouble du rythme "

// Respiratory Variables 
//Ventilatory in children have a huge intervariability, automatisation is complicated 
//Cardiologist interpretates these variables himself during the test
Medical_report(42,1)= "Bonne / Mauvaise adaptation respiratoire "



//-----------| Save Medical report in RES File | -----------// 

disp(Medical_report); // Display Medical report in Scilab console
fileresname=(fullfile(RES_PATH, "Medical_report_"+ Surname+'.txt' ));// Output txt file names is "Medical_report_Nameof file"
//Medical report is in RES file
mputl(Medical_report,fileresname);


//    |                                                                  |
//    | OBJECTIVE 2 : STORE VALUES OF EACH PARTICIPANT IN DATABASE FILE  |
//    |                                                                  |

// Import CSV Database from RES File
filenameid= fullfile(RES_PATH, "database_output.csv");
DataBase_read=csvRead(filenameid,";",[],"string");
DataBase=string(DataBase_read);

// We paste getInformation values in DataBase with PastegetInformation function
Infostr=["Nom de famille","Prenom","Date Naissance","Date du test","Taille (cm)","Poids (kg)","Protocole"];
Infoval=[Surname,Forename,DateOfBirth,TestDate,string(Height),string(Weight),Protocol];
DataBase=PasteInformation(DataBase,Infoval,Infostr);


// SPIROMETRY VARIABLES
// Create character matrix, then collect values with getValue function
StrSpiro=["CVF","VEMS"];
CollectSpiroMes=getValue(Val_res,StrSpiro,"Pré");
CollectSpiro=getValue(Val_res,StrSpiro,"% Préd.");
//Paste value in Database matrix, at the correct emplacement
DataBase=PasteValue(DataBase,CollectSpiroMes,StrSpiro,"Pre");
DataBase=PasteValue(DataBase,CollectSpiroMes,StrSpiro,"% Pred.");

// CPET VARIABLES
// We create character matrix of our variables
StrCpet=["Power","VO2","VO2/kg","QR","VE","RR","VC","F.R","FC","VO2/FC","P Syst","P Diast","PetCO2","PetO2","VE/VO2","VE/VCO2"]; // Str CPET is composed by variables measured at warm-up,VAT, Max
StrMesure(1,:)=["Pente VE/VCO2","OUES","RFC","Pente VO2/Puiss."];//Str CPET is composed by variables measured at once time

// We collect values with getValue function
CollectMesure=getValue(Val_res,StrMesure,"Mesure");
CollectVat=getValue(Val_res,StrCpet,"SV1");
CollectMax=getValue(Val_res,StrCpet,"Max");
CollectPred=getValue(Val_res,StrCpet,"% Préd.")
//Paste value in Database matrix, at the correct location /emplacement
DataBase=PasteValue(DataBase,CollectVat,StrCpet,"SV1");
DataBase=PasteValue(DataBase,CollectMax,StrCpet,"Max");
DataBase=PasteValue(DataBase,CollectMesure,StrMesure,"Mesure");
DataBase=PasteValue(DataBase,CollectPred,StrCpet,"% Pred.");


// Now, lines is completed by getInformation, we pick it from Data base scilab matrix
// And, paste in csv output to increment data base
LineImport=DataBase(3,:);
FileExportid= fullfile(RES_PATH, "database_output.csv");
Dataoutput_read=csvRead(FileExportid,";",[],"string");
DatabaseOutput=string(Dataoutput_read);

ilinsize= size(DatabaseOutput,'r');//get the last line index
// index line corresponding to FC SV1
ilinsize=ilinsize+1
DatabaseOutput(ilinsize,:)=LineImport
csvWrite(DatabaseOutput,FileExportid,';')
//DataBase=PasteInformation(DataBase,CollectVat,StrVat,"SV1")



//    |                                                        |
//    | BONUS : PLOT/ HELP TO FIND IF CPET WAS MAXIMAL OR NOT  |
//    |                                                        |

// Choose values recorded all along CPET test in sheet 1
iVo2plot= find(Str_info(1,:)=="VO2/kg")
Vo2plot=(Val_info(4:$,iVo2plot))

iPower=find(Str_info(1,:)=="Power")
Power=(Val_info(4:$,iPower))

iBreathReserve=find(Str_info(1,:)=="RR")
BreathReserve=(Val_info(4:$,iBreathReserve))

iHeartRate=find(Str_info(1,:)=="FC")
HeartRate=(Val_info(4:$,iHeartRate))

iTime=find(Str_info(1,:)=="t")
Time=((Val_info(4:$,iTime))*1000)

iOxygenpulse=find(Str_info(1,:)=="VO2/FC")
Oxygenpulse=(Val_info(4:$,iOxygenpulse))


// we plotted differents graphics which help cardiologist to make a decision about CPET maximality
// We generate  kinectics graphics of Cardiac, Metabolic, Ventilatory 
xdel(winsid());// delete graphic window
scf(0);
subplot(2,2,1);
xset("thickness",1); //thickness of the curve
plot(Time,Vo2kgPred,'b--'); // plot predicted Vo2 max value (horizontal line)
xset("thickness",2);//thickness of the curve
plot2d(Time,Vo2plot,style=5); // plot kinectics of Vo2 over time
legends(["Predicted maximal VO2 (ml.min.kg)";"VO2 measured (ml.min.kg)"],[2,5],with_box=%t,opt=4);
// legend with respective color [2,5], and with box placed on lower-right corner
xtitle("Oxygen uptake kinetics "); //title of the graphic
ylabel("VO2 (ml.min.kg) ");
xlabel("Time(min)"); 
xset("thickness",1);
set(gca(),"grid",[1 1]);

subplot(2,2,2);
xset("thickness",1); 
plot(Time,HrateMax,'b--');
xset("thickness",2);
plot2d(Time,HeartRate,style=5);
legends(["Predicted Heart rate (rate/min)";"Heart rate (beats/min)"],[2,5],with_box=%t,opt=4);
xtitle("Heart rate kinetics "); 
ylabel("Heart rate (beats/min)");
xlabel("Time(min)"); 
xset("thickness",1);
set(gca(),"grid",[1 1]);

subplot(2,2,3);
xset("thickness",1);
plot2d(Time,Power,style=[color('scilab brown3')]);
xtitle("Incremental Power "); 
ylabel("Power (watts)");
xlabel("Time(min)"); 
xset("thickness",1);
set(gca(),"grid",[1 1]);


subplot(2,2,4);
xset("thickness",1); 
plot(Time,BreathresMax,'y');
xset("thickness",2);
plot2d(Time,BreathReserve,style=[color('scilab green4')]);
legends(["Minimal Breath reserve";"Kinetics of Breath reserve"],[7,color('scilab green4')],with_box=%t,opt=1);
xtitle("Breath reserve kinetics "); 
xlabel("Time(min)"); 
xset("thickness",1);
set(gca(),"grid",[1 1]);


//Export to pdf in RES FILE
winnum=0; // number of figure
fileresnameplot=(fullfile(RES_PATH, "Graphics_"+ Surname));// Output pdf file names is "Graphics_Name of file"
xs2pdf(winnum,fileresnameplot,['portrait']);


