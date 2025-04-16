/*
    Description: Controller is created for School Report.
*/
public with sharing class SchoolReportController {
    public decimal TotalStudents {get; set;}
    public decimal Totalforthismediumofinstruction{get; set;}
    public decimal TotalforpartnerState{get; set;}
    public decimal Malecount{get; set;} 
    public decimal Femalecount{get; set;}
    public decimal Malecountbymedium{get; set;} 
    public decimal Femalecountbymedium{get; set;}
    public decimal Malecountbypartner{get; set;} 
    public decimal Femalecountbypartner{get; set;}
    public decimal countAware{get; set;}
    public decimal countMaleAware{get; set;}
    public decimal countFemaleAware{get; set;}
    public decimal countAwareBymedium{get; set;}
    public decimal countAwareBymediumMale{get; set;}
    public decimal countAwareBymediumFemale{get; set;}
    public decimal countAwarebyPartner{get; set;}
    public decimal countAwareByPartnerMale{get; set;}
    public decimal countAwareByPartnerFemale{get; set;}
    public decimal countCareerAware{get; set;}
    public decimal countCareerMale{get; set;}
    public decimal countCareerFemale{get; set;}
    public decimal countCareerBymedium{get; set;}
    public decimal countCareerBymediumMale{get; set;}
    public decimal countCareerBymediumFemale{get; set;}
    public decimal countCareerByPartner{get; set;}
    public decimal countCareerByPartnerMale{get; set;}
    public decimal countCareerBypartnerFemale{get; set;}
    public decimal countClarityReports{get; set;}
    public decimal countClarityReportsMale{get; set;}
    public decimal countClarityreportsFemale{get; set;}
    public decimal countClarityBymedium{get; set;}
    public decimal countClarityBymediumMale{get; set;}
    public decimal countClarityBymediumFemale{get; set;}
    public decimal countClarityByPartner {get; set;}
    public decimal countClarityByPartnerMale{get; set;}
    public decimal countClarityByPartnerFemale{get; set;}
    public decimal countCounselling{get; set;}
    public decimal countCounsellingMale {get; set;}
    public decimal countCounsellingFemale {get; set;}
    public decimal countCounsellingBymedium {get; set;}
    public decimal countCounsellingBymediumMale {get; set;}
    public decimal countCounsellingBymediumFemale {get; set;}
    public decimal countCounsellingByPartner{get; set;}
    public decimal countCounsellingByPartnerMale {get; set;}
    public decimal countCounsellingByPartnerFemale{get; set;}
    public string  Top1{get; set;}
    public string  Top2{get; set;}
    public string  Top3{get; set;}
    public string  Top1Girl{get; set;}
    public string  Top2Girl{get; set;}
    public string  Top3Girl{get; set;}
    public string  Top1Boy{get; set;}
    public string  Top2Boy{get; set;}
    public string  Top3Boy {get; set;}
    public string selectedYear {get;set;}
    public Id accountid;


    public SchoolReportController(ApexPages.StandardController controller) {
        accountid = controller.getId();
        TotalStudents = 0;
        Totalforthismediumofinstruction = 0;
        TotalforpartnerState=0;
        Malecount=0;
        Femalecount=0;
        Malecountbymedium=0;
        Femalecountbymedium=0;
        Malecountbypartner=0;
        Femalecountbypartner=0;
        countAware=0;
        countMaleAware=0;
        countFemaleAware=0;
        countAwareBymedium=0;
        countAwareBymediumMale=0;
        countAwareBymediumFemale=0;
        countAwarebyPartner=0;
        countAwareByPartnerMale=0;
        countAwareByPartnerFemale=0;
        countCareerAware=0;
        countCareerMale=0;
        countCareerFemale=0;
        countCareerBymedium=0;
        countCareerBymediumMale=0;
        countCareerBymediumFemale=0;
        countCareerByPartner=0;
        countCareerByPartnerMale=0;
        countCareerBypartnerFemale=0;
        countClarityReports=0;
        countClarityReportsMale=0;
        countClarityreportsFemale=0;
        countClarityBymedium=0;
        countClarityBymediumMale=0;
        countClarityBymediumFemale=0;
        countClarityByPartner =0;
        countClarityByPartnerMale=0;
        countClarityByPartnerFemale=0;
        countCounselling=0;
        countCounsellingMale =0;
        countCounsellingFemale =0;
        countCounsellingBymedium =0;
        countCounsellingBymediumMale =0;
        countCounsellingBymediumFemale =0;
        countCounsellingByPartner=0;
        countCounsellingByPartnerMale =0;
        countCounsellingByPartnerFemale=0;
        Top1= '';
        Top2= '';
        Top3= '';
        Top1Girl= '';
        Top2Girl= '';
        Top3Girl= '';
        Top1Boy= '';
        Top2Boy= '';
        Top3Boy= '';
        if(Apexpages.currentPage().getParameters().get('selectedYear') != null) {
            selectedYear = string.valueof(Apexpages.currentPage().getParameters().get('selectedYear'));
            CalculateReport();
        } else {
            selectedYear = 'All';
        }
    }
    
    
    
    public PageReference CalculateReport(){
        try {    
            system.debug('selectedYear ::: '+selectedYear);
            
            List < Account > acclst = [select id, name, School_Name__c, Partner__c , Medium_Language_of_Instruction__c,
                Number_of_students1__c from Account Where Account.id = : accountid  
            ];
    
    
            Account account = acclst.get(0);
            //total students for school
    
            /*if(account.Partner__c == '' || account.Partner__c == null)
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter Partner'));*/
            Date fromDate = Date.NewInstance(1, 1, 2016);
            Date ToDate = System.Today().addYears(5);
            if(string.isnotblank(selectedYear) && selectedYear != 'All'){
                Integer fromYear = Integer.valueof(selectedYear.split('-')[0]);
                Integer toYear = Integer.valueof(selectedYear.split('-')[1]);
                fromDate = Date.NewInstance(fromYear, 5, 1);
                ToDate = Date.NewInstance(toYear, 4, 30);
            }
            
            /*//total students for schhol
            AggregateResult[] agrTotalStudents = [Select sum(Number_of_students1__c) countTotal from Account Where RecordType.name = 'School'
                and Id = : account.Id
            ];
            for (AggregateResult ar: agrTotalStudents) {
                TotalStudents = (decimal) ar.get('countTotal');
            }
    
            //total students with same school medium
            AggregateResult[] agrMediumOfInstruction = [Select sum(Number_of_students1__c) countforMedium from Account Where RecordType.name = 'School'
                and Medium_Language_of_Instruction__c = : account.Medium_Language_of_Instruction__c
            ];
            for (AggregateResult ar: agrMediumOfInstruction) {
                Totalforthismediumofinstruction = (decimal) ar.get('countforMedium');
            }
            
            //total students wit same school partner
            AggregateResult[] agrParter = [Select sum(Number_of_students1__c) countforPartner from Account Where RecordType.name = 'School'
                and Partner__c = : account.Partner__c
            ];
            for (AggregateResult ar: agrParter) {
                TotalforpartnerState = (decimal) ar.get('countforPartner');
            }*/
    
            //query on all students of this school
            List<Contact> conForNumerofStudent = [select id, Gender__c, Possible_Career_Report__c,Possible_Career_Report_Formula__c,
                Career_Tracks__c, Clarity_Report_Yes__c, Counselling_Session_Attended__c from contact where RecordType.Name = 'CA Student'
                and Batch_Code__c in (select Id from Batch__c where School_Name__c = : Account.Id
                AND Day_Only(Date_of_facilitation_starting__c) >=: fromdate AND Day_Only(Date_of_facilitation_starting__c) <=: ToDate)
            ];
            //check no of male and female 
            decimal NumofMale = 0;
            decimal NumofFemale = 0;
            
            decimal NumofMaleselfaware = 0;
            decimal NumofFemaleselfaware = 0;
                        
            decimal NumofMaleCareerAware = 0;
            decimal NumofFemaleCareerAware = 0;
            
            decimal NumofMaleClarity = 0;
            decimal NumofFemaleClarity = 0;
            
            decimal NumofMaleCounselling = 0;
            decimal NumofFemaleCounselling = 0;
    
            for (contact student: conForNumerofStudent) {
                TotalStudents++;
                if(student.Possible_Career_Report__c > 0)countAware++;
                if(student.Career_Tracks__c >= 5)countCareerAware++;
                if(student.Clarity_Report_Yes__c)countClarityReports++;
                if(student.Counselling_Session_Attended__c)countCounselling++;
                if (student.Gender__c == 'Male') {
                    NumofMale++;
                    if (student.Possible_Career_Report__c > 0) {
                        NumofMaleselfaware++;
                    }
                    
                    if (student.Career_Tracks__c >= 5) {
                        NumofMaleCareerAware++;
                    }
                    
                    if (student.Clarity_Report_Yes__c == true) {
                        NumofMaleClarity++;
                    }
                        
                    if (student.Counselling_Session_Attended__c == true) {
                        NumofMaleCounselling++;
                    }
                } else if (student.Gender__c == 'Female') {
                    NumofFemale++;
                    if (student.Possible_Career_Report__c > 0) {
                        NumofFemaleselfaware++;
                    }
                    
                    if (student.Career_Tracks__c >= 5) {
                        NumofFemaleCareerAware++;
                    }
                    
                    if (student.Clarity_Report_Yes__c == true) {
                        NumofFemaleClarity++;
                    }
                    
                    if (student.Counselling_Session_Attended__c == true) {
                        NumofFemaleCounselling++;
                    }
                }
            }
            // Calculating Percentage
            if(TotalStudents > 0){
                Malecount = ((NumofMale / TotalStudents) * 100).setScale(2);
                Femalecount = ((NumofFemale / TotalStudents) * 100).setScale(2);
            }
            //countAware = NumofMaleselfaware + NumofFemaleselfaware;
            if(NumofMale > 0) countMaleAware = ((NumofMaleselfaware / NumofMale) * 100).setScale(2);
            if(NumofFemale > 0) countFemaleAware = ((NumofFemaleselfaware / NumofFemale ) * 100).setScale(2);
            
            //countCareerAware = NumofMaleCareerAware + NumofFemaleCareerAware;
            if(NumofMale > 0) countCareerMale = ((NumofMaleCareerAware / NumofMale) * 100).setScale(2);
            if(NumofFemale > 0) countCareerFemale = ((NumofFemaleCareerAware / NumofFemale ) * 100).setScale(2);
            
            //countClarityReports = NumofMaleClarity + NumofFemaleClarity;
            if(NumofMale > 0) countClarityReportsMale = ((NumofMaleClarity / NumofMale) * 100).setScale(2);
            if(NumofFemale  > 0) countClarityreportsFemale = ((NumofFemaleClarity / NumofFemale ) * 100).setScale(2);
            
            //countCounselling = NumofMaleCounselling + NumofFemaleCounselling;
            if(NumofMale > 0)countCounsellingMale = ((NumofMaleCounselling / NumofMale) * 100).setScale(2);
            if(NumofFemale > 0) countCounsellingFemale = ((NumofFemaleCounselling / NumofFemale ) * 100).setScale(2);
            
            //query on all students of this school with same medium  
            list < Contact > conForbyMedium = [select id, Gender__c, Possible_Career_Report__c,Possible_Career_Report_Formula__c , Career_Tracks__c, Clarity_Report_Yes__c, Counselling_Session_Attended__c from contact where RecordType.Name = 'CA Student'
                and Batch_Code__c in (select Id from Batch__c where School_Name__r.Medium_Language_of_Instruction__c = : account.Medium_Language_of_Instruction__c
                AND School_Name__r.Partner__c = : account.Partner__c
                AND Day_Only(Date_of_facilitation_starting__c) >=: fromdate AND Day_Only(Date_of_facilitation_starting__c) <=: ToDate)
            ];
            //check no of male and female with same medium 
            decimal NumofMaleMedium = 0;
            decimal NumofFemaleMedium = 0;
            
            decimal NumofMaleselfawareMedium = 0;
            decimal NumofFemaleselfawareMedium = 0;
            
            decimal NumofMaleCareerbyMedium = 0;
            decimal NumofFemaleCareerbyMedium = 0;
            
            decimal NumofMaleClaritybyMedium = 0;
            decimal NumofFemaleClarityByMedium = 0;
            
            decimal NumofMaleCounsellingBymedium = 0;
            decimal NumofFemaleCounsellingBymedium = 0;
    
            for (contact medium: conForbyMedium) {
                Totalforthismediumofinstruction++;
                if(medium.Possible_Career_Report__c > 0)countAwareBymedium++;
                if(medium.Career_Tracks__c >= 5)countCareerBymedium++;
                if(medium.Clarity_Report_Yes__c)countClarityBymedium++;
                if(medium.Counselling_Session_Attended__c)countCounsellingBymedium++;
                if (medium.Gender__c == 'Male') {
                    NumofMaleMedium++;
                    if (medium.Possible_Career_Report__c > 0) {
                        NumofMaleselfawareMedium++;
                    }
                    
                    if (medium.Career_Tracks__c >= 5) {
                        NumofMaleCareerbyMedium++;
                    }
                    
                    if (medium.Clarity_Report_Yes__c == true) {
                        NumofMaleClaritybyMedium++;
                    }
                    if (medium.Counselling_Session_Attended__c == true) {
                        NumofMaleCounsellingBymedium++;
                    }
    
                } else if (medium.Gender__c == 'Female') {
                    NumofFemaleMedium++;
                    if (medium.Possible_Career_Report__c > 0) {
                        NumofFemaleselfawareMedium++;
                    }
                    
                    if (medium.Career_Tracks__c >= 5) {
                        NumofFemaleCareerbyMedium++;
                    }
                    
                    if (medium.Clarity_Report_Yes__c == true) {
                        NumofFemaleClarityByMedium++;
                    }
                    if (medium.Counselling_Session_Attended__c == true) {
                        NumofFemaleCounsellingBymedium++;
                    }
    
                }
            }
            // Calculating Percentage 
            if(Totalforthismediumofinstruction > 0) {
                Malecountbymedium = ((NumofMaleMedium / Totalforthismediumofinstruction) * 100).setScale(2);
                Femalecountbymedium = ((NumofFemaleMedium / Totalforthismediumofinstruction) * 100).setScale(2);
            }
    
            //countAwareBymedium = NumofMaleselfawareMedium + NumofFemaleselfawareMedium;
            if(NumofMaleMedium > 0) countAwareBymediumMale = ((NumofMaleselfawareMedium / NumofMaleMedium) * 100).setScale(2);
            if(NumofFemaleMedium > 0) countAwareBymediumFemale = ((NumofFemaleselfawareMedium / NumofFemaleMedium ) * 100).setScale(2);
           
    
            //countCareerBymedium = NumofMaleCareerbyMedium + NumofFemaleCareerbyMedium;
            if(NumofMaleMedium > 0) countCareerBymediumMale = ((NumofMaleCareerbyMedium / NumofMaleMedium ) * 100).setScale(2);
            if(NumofFemaleMedium > 0) countCareerBymediumFemale = ((NumofFemaleCareerbyMedium / NumofFemaleMedium ) * 100).setScale(2);
            
            //countClarityBymedium = NumofMaleClaritybyMedium + NumofFemaleClarityByMedium;
            if(NumofMaleMedium > 0) countClarityBymediumMale = ((NumofMaleClaritybyMedium / NumofMaleMedium ) * 100).setScale(2);
            if(NumofFemaleMedium > 0) countClarityBymediumFemale = ((NumofFemaleClarityByMedium / NumofFemaleMedium ) * 100).setScale(2);
            
            //countCounsellingBymedium = NumofMaleCounsellingBymedium + NumofFemaleCounsellingBymedium;
            if(NumofMaleMedium > 0) countCounsellingBymediumMale = ((NumofMaleCounsellingBymedium / NumofMaleMedium ) * 100).setScale(2);
            if(NumofFemaleMedium > 0) countCounsellingBymediumFemale = ((NumofFemaleCounsellingBymedium / NumofFemaleMedium ) * 100).setScale(2);
            
    
            //query on all students of this school with same partner
            list < Contact > conByPartner = [select id, Gender__c, Possible_Career_Report__c,Possible_Career_Report_Formula__c , Career_Tracks__c, Clarity_Report_Yes__c, Counselling_Session_Attended__c from contact where RecordType.Name = 'CA Student'
                and Batch_Code__c in (select Id from Batch__c where School_Name__r.Partner__c = : account.Partner__c
                AND Day_Only(Date_of_facilitation_starting__c) >=: fromdate AND Day_Only(Date_of_facilitation_starting__c) <=: ToDate)
            ];
            //check no of male and female with same Partner
            decimal NumofMalePartner = 0;
            decimal NumofFemalePartner = 0;
            
            decimal NumofmaleAwarePartner = 0;
            decimal NumofFemaleAwarePartner = 0;
            
            decimal NumOfMaleCareerPartner = 0;
            decimal NumofFemaleCareerPartner = 0;
            
            decimal NumofMaleClarityPartner = 0;
            decimal NumofFemaleClarityPartner = 0;
            
            decimal NumofMaleCounsellingPartner = 0;
            decimal NumofFemaleCounsellingPartner = 0;
    
            for (contact partner: conByPartner) {
                TotalforpartnerState++;
                if(partner.Possible_Career_Report__c > 0)countAwareByPartner++;
                if(partner.Career_Tracks__c >= 5)countCareerByPartner++;
                if(partner.Clarity_Report_Yes__c)countClarityByPartner++;
                if(partner.Counselling_Session_Attended__c)countCounsellingByPartner++;
                if (partner.Gender__c == 'Male') {
                    NumofMalePartner++;
                    if (partner.Possible_Career_Report__c > 0) {
                        NumofMaleAwarePartner++;
                    }
                    
                    if (partner.Career_Tracks__c >= 5) {
                        NumOfMaleCareerPartner++;
                    }
                    
                    if (partner.Clarity_Report_Yes__c == true) {
                        NumofMaleClarityPartner++;
                    }
                    if (partner.Counselling_Session_Attended__c == true) {
                        NumofMaleCounsellingPartner++;
                    }
    
                } else if (partner.Gender__c == 'Female') {
                    NumofFemalePartner++;
                    if (partner.Possible_Career_Report__c > 0) {
                        NumofFemaleAwarePartner++;
                    }
                    
                    if (partner.Career_Tracks__c >= 5) {
                        NumofFemaleCareerPartner++;
                    }
                    
                    if (partner.Clarity_Report_Yes__c == true) {
                        NumofFemaleClarityPartner++;
                    }
                    if (partner.Counselling_Session_Attended__c == true) {
                        NumofFemaleCounsellingPartner++;
                    }
    
                }
            }
            // Calculating Percentage 
            if(TotalforpartnerState > 0){
                Malecountbypartner = ((NumofMalePartner / TotalforpartnerState) * 100).setScale(2);
                Femalecountbypartner = ((NumofFemalePartner / TotalforpartnerState) * 100).setScale(2);
            }
    
            //countAwarebyPartner = NumofmaleAwarePartner + NumofFemaleAwarePartner;
            if(NumofMalePartner > 0) countAwareByPartnerMale = ((NumofmaleAwarePartner / NumofMalePartner ) * 100).setScale(2);
            if(NumofFemalePartner > 0) countAwareByPartnerFemale = ((NumofFemaleAwarePartner / NumofFemalePartner ) * 100).setScale(2);
            
            //countCareerByPartner = NumOfMaleCareerPartner + NumofFemaleCareerPartner;
            if(NumofMalePartner > 0) countCareerByPartnerMale = ((NumOfMaleCareerPartner /  NumofMalePartner ) * 100).setScale(2);
            if(NumofFemalePartner > 0) countCareerBypartnerFemale = ((NumofFemaleCareerPartner / NumofFemalePartner ) * 100).setScale(2);
            
            //countClarityByPartner = NumofMaleClarityPartner + NumofFemaleClarityPartner;
            if(NumofMalePartner > 0) countClarityByPartnerMale = ((NumofMaleClarityPartner / NumofMalePartner ) * 100).setScale(2);
            if(NumofFemalePartner > 0) countClarityByPartnerFemale = ((NumofFemaleClarityPartner / NumofFemalePartner ) * 100).setScale(2);
            
            //countCounsellingByPartner = NumofMaleCounsellingPartner + NumofFemaleCounsellingPartner;
            if(NumofMalePartner > 0) countCounsellingByPartnerMale = ((NumofMaleCounsellingPartner / NumofMalePartner ) * 100).setScale(2);
            if(NumofFemalePartner > 0) countCounsellingByPartnerFemale = ((NumofFemaleCounsellingPartner / NumofFemalePartner ) * 100).setScale(2);
            
    
            Map<integer, string> profSchool = new Map<integer, string>();
            //Aggregate query on all students of this school by Profssion_1
    
            AggregateResult[] prof = [select count(id) prop1name, Profession_1__r.Name Profession1 from Contact Where RecordType.Name = 'CA Student'
                And Batch_Code__c in (select Id from Batch__c where School_Name__c = : Account.Id
                AND Day_Only(Date_of_facilitation_starting__c) >=: fromdate AND Day_Only(Date_of_facilitation_starting__c) <=: ToDate) 
                AND Profession_1__c != null group by Profession_1__r.Name Order by count(id) desc limit 15
            ];
            for (AggregateResult ag1: prof) {
                string profession = (string) ag1.get('Profession1');
                integer profcount = (integer) ag1.get('prop1name');
                if(profSchool.containskey(profcount)){
                    string existprofession = profSchool.get(profcount) + ' / '+profession;
                    profSchool.put(profcount, existprofession);
                } else {
                    profSchool.put(profcount, profession);
                }
            }
            system.debug('profSchool::: '+profSchool);
            //Aggregate query on all students of this school by Profssion_2
    
            /*AggregateResult[] prof_2 = [select count(id) prop2name, Profession_2__r.Name Profession2 from Contact Where RecordType.Name = 'CA Student'
                And Batch_Code__c in (select Id from Batch__c where School_Name__c = : Account.Id 
                AND Day_Only(Date_of_facilitation_starting__c) >=: fromdate AND Day_Only(Date_of_facilitation_starting__c) <=: ToDate) 
                AND Profession_2__c != null group by Profession_2__r.Name Order by count(id) desc limit 3
            ];
            for(AggregateResult ag2: prof_2) {
                string profession = (string) ag2.get('Profession2');
                integer profcount = (integer) ag2.get('prop2name');
                if(profSchool.containskey(profession)){
                    if(profcount > profSchool.get(profession)){
                        profSchool.put(profession, profcount);
                    }
                } else {
                    profSchool.put(profession, profcount);
                }
            }*/
            List<Integer> lstprofSchool = new List<Integer>();
            lstprofSchool.addAll(profSchool.keyset());
            lstprofSchool.sort();
            for(Integer i = lstprofSchool.size()-1; i >= 0; i--){
                if(profSchool.containskey(lstprofSchool[i])){
                    string profession = profSchool.get(lstprofSchool[i]);
                    if(string.isblank(Top1)){
                        Top1 = profession;
                    } else if(string.isblank(Top2)){
                        Top2 = profession;
                    } else if(string.isblank(Top3)){
                        Top3 = profession;
                    }
                }
                if(string.isnotblank(Top1) && string.isnotblank(Top2) && string.isnotblank(Top3)) break; 
            }
            
            Map <integer, string> profGirl = new map<integer, string> ();
            //Aggregate query on all students of this school by Profssion_1 for female
    
            AggregateResult[] proffG = [select count(id) a, Profession_1__r.Name profession1Girl from Contact Where RecordType.Name = 'CA Student'
                AND Gender__c = 'Female'
                And Batch_Code__c in (select Id from Batch__c where School_Name__c = : Account.Id
                AND Day_Only(Date_of_facilitation_starting__c) >=: fromdate AND Day_Only(Date_of_facilitation_starting__c) <=: ToDate) 
                AND Profession_1__c != null group by Profession_1__r.Name Order by count(id) desc limit 15
            ];
            for (AggregateResult ag1G: proffG) {
                string profession = (string) ag1G.get('profession1Girl');
                integer profcount = (integer) ag1G.get('a');
                if(profGirl.containskey(profcount)){
                    string existprofession = profGirl.get(profcount) + ' / '+profession;
                    profGirl.put(profcount, existprofession);
                } else {
                    profGirl.put(profcount, profession);
                }
            }
            system.debug('profGirl::: '+profGirl);
            //Aggregate query on all students of this school by Profssion_2 for female
            /*AggregateResult[] proffG_2 = [select count(id) a, Profession_2__r.Name profession2Girl from Contact Where RecordType.Name = 'CA Student'
                AND Gender__c = 'Female'
                And Batch_Code__c in (select Id from Batch__c where School_Name__c = : Account.Id
                AND Day_Only(Date_of_facilitation_starting__c) >=: fromdate AND Day_Only(Date_of_facilitation_starting__c) <=: ToDate) 
                AND Profession_2__c != null group by Profession_2__r.Name Order by count(id) desc limit 3
            ];
            for (AggregateResult ag2G: proffG_2) {
                string profession = (string) ag2G.get('profession2Girl');
                integer profcount = (integer) ag2G.get('a');
                if(profGirl.containskey(profession)){
                    if(profcount > profGirl.get(profession)){
                        profGirl.put(profession, profcount);
                    }
                } else {
                    profGirl.put(profession, profcount);
                }
            }*/
            List<Integer> lstprofGirl = new List<Integer>();
            lstprofGirl.addAll(profGirl.keyset());
            lstprofGirl.sort();
            for(Integer i = lstprofGirl.size()-1; i >= 0; i--){
                if(profGirl.containskey(lstprofGirl[i])){
                    string profession = profGirl.get(lstprofGirl[i]);
                    if(string.isblank(Top1Girl)){
                        Top1Girl = profession;
                    } else if(string.isblank(Top2Girl)){
                        Top2Girl = profession;
                    } else if(string.isblank(Top3Girl)){
                        Top3Girl = profession;
                    }
                }
                if(string.isnotblank(Top1Girl) && string.isnotblank(Top2Girl) && string.isnotblank(Top3Girl)) break; 
            }
    
            Map<integer, string> profBoy = new map<integer, string>();
            //Aggregate query on all students of this school by Profssion_1 for Male
    
            AggregateResult[] proffB = [select count(id) a, Profession_1__r.Name profession1Boy from Contact Where RecordType.Name = 'CA Student'
                AND Gender__c = 'Male'
                And Batch_Code__c in (select Id from Batch__c where School_Name__c = : Account.Id
                AND Day_Only(Date_of_facilitation_starting__c) >=: fromdate AND Day_Only(Date_of_facilitation_starting__c) <=: ToDate) 
                AND Profession_1__c != null group by Profession_1__r.Name Order by count(id) desc limit 15
            ];
            for (AggregateResult ag1B: proffB) {
                string profession = (string) ag1B.get('profession1Boy');
                integer profcount = (integer) ag1B.get('a');
                if(profBoy.containskey(profcount)){
                    string existprofession = profBoy.get(profcount) + ' / '+profession;
                    profBoy.put(profcount, existprofession);
                } else {
                    profBoy.put(profcount, profession);
                }
            }
            system.debug('profBoy ::: '+profBoy);
            //Aggregate query on all students of this school by Profssion_1 for Male
            /*AggregateResult[] proffB_2 = [select count(id) a, Profession_2__r.Name profession2Boy from Contact Where RecordType.Name = 'CA Student'
                AND Gender__c = 'Male'
                And Batch_Code__c in (select Id from Batch__c where School_Name__c = : Account.Id
                AND Day_Only(Date_of_facilitation_starting__c) >=: fromdate AND Day_Only(Date_of_facilitation_starting__c) <=: ToDate) 
                AND Profession_2__c != null group by Profession_2__r.Name Order by count(id) desc limit 3
            ];
            for (AggregateResult ag2B: proffB_2) {
                string profession = (string) ag2B.get('profession2Boy');
                integer profcount = (integer) ag2B.get('a');
                if(profBoy.containskey(profession)){
                    if(profcount > profBoy.get(profession)) {
                        profBoy.put(profession, profcount);
                    }
                } else {
                    profBoy.put(profession, profcount);
                }
            }*/
            //Comparing the profession_1 and profession_2 for top 3 list for Male
            List<Integer> lstprofBoy = new List<Integer>();
            lstprofBoy.addAll(profBoy.keyset());
            lstprofBoy.sort();
            
            for(Integer i = lstprofBoy.size()-1; i >= 0; i--){
                if(profBoy.containskey(lstprofBoy[i])){
                    string profession = profBoy.get(lstprofBoy[i]);
                    if(string.isblank(Top1Boy)){
                        Top1Boy = profession;
                    } else if(string.isblank(Top2Boy)){
                        Top2Boy = profession;
                    } else if(string.isblank(Top3Boy)){
                        Top3Boy = profession;
                    }
                }
                if(string.isnotblank(Top1Boy) && string.isnotblank(Top2Boy) && string.isnotblank(Top3Boy)) break; 
            }
            
            PageReference pg = new PageReference('/apex/SchoolReport?id='+ account.Id +'&render=pdf&selectedYear='+selectedYear);
            pg.setRedirect(true);
            return pg;
        } catch (Exception ex){
            Apexpages.addMessages(ex);
            return null;
        }
    }
}