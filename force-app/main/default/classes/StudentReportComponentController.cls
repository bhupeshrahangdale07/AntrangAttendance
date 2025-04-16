/*
    Description: Class is created for Student Report Component
*/
public with sharing class StudentReportComponentController {
    
    public Contact objContact {get; set;}
    public String grade {get; set;}
    public String SchoolName {get; set;}
    public String BatchNumber {get; set;}
    public String TrainerName {get; set;}
    public String PreferredLanguage {get; set;}
    
    public string strAspiration {get; set;}
    public List<Explanations__c> lstInterests {get; set;}
    
    
    public string strPersonality {get; set;}
    public List<string> lstPesonalityIcons {get; set;}
    public List<Explanations__c> lstAptitude {get; set;}
    public List<Explanations__c> lstPersonality {Get; set;}
    public string strOrgId {get; set;}
    public string strMiddleIconDocId {get; set;}
    
    public map<Integer, List<string>> mapAllRealities {get; set;}

    public WrapperStudentReport wrapStudentReport;
    public WrapperStudentReport.InterestLabel InterestLabels {get; set;}
    public WrapperStudentReport.AptitudeLabel AptitudeLabels {get; set;}
    
    public WrapperStudentReport getStudentReportWrap() {
        return wrapStudentReport;
    }
    
    public void setStudentReportWrap(WrapperStudentReport wrpsreport) {
        wrapStudentReport = wrpsreport;
        strOrgId = UserInfo.getOrganizationId();
        strMiddleIconDocId = wrpsreport.strMiddleIconDocId;
        objContact = wrapStudentReport.objContact;
        if (String.isNotBlank(objContact.Profession_1_You_could_be_a__c)) {
            objContact.Profession_1_You_could_be_a__c = objContact.Profession_1_You_could_be_a__c.replace('\n', ', ');
        }
        if (String.isNotBlank(objContact.Profession_2_You_could_be_a__c)) {
            objContact.Profession_2_You_could_be_a__c = objContact.Profession_2_You_could_be_a__c.replace('\n', ', ');
        }
        strAspiration = wrapStudentReport.strAspiration;
        lstInterests = wrapStudentReport.lstInterests;
        lstPesonalityIcons = wrapStudentReport.lstPesonalityIcons;
        strPersonality = wrapStudentReport.strPersonality;
        lstAptitude = wrapStudentReport.lstAptitude;
        mapAllRealities = wrapStudentReport.mapAllRealities;
        
        InterestLabels = wrapStudentReport.InterestLabels;
        AptitudeLabels = wrapStudentReport.AptitudeLabels;
        
        if(objContact.G12_Batch_Code__c != null){
            grade = objContact.G12_Batch_Code__r.Grade__c;
            SchoolName = objContact.G12_Batch_Code__r.School_Name__c != null ? objContact.G12_Batch_Code__r.School_Name__r.Name : '';
            TrainerName = objContact.G12_Batch_Code__r.Trainer_Name__c != null ? objContact.G12_Batch_Code__r.Trainer_Name__r.Name : '';
            BatchNumber = objContact.G12_Batch_Code__r.Batch_Number__c;
            PreferredLanguage = objContact.G12_Batch_Code__r.Preferred_Language__c;
            
        }else if(objContact.G11_Batch_Code__c != null){
            grade = objContact.G11_Batch_Code__r.Grade__c;
            SchoolName = objContact.G11_Batch_Code__r.School_Name__c != null ? objContact.G11_Batch_Code__r.School_Name__r.Name : '';
            TrainerName = objContact.G11_Batch_Code__r.Trainer_Name__c != null ? objContact.G11_Batch_Code__r.Trainer_Name__r.Name : '';
            BatchNumber = objContact.G11_Batch_Code__r.Batch_Number__c;
            PreferredLanguage = objContact.G11_Batch_Code__r.Preferred_Language__c;
            
        }else if(objContact.G10_Batch_Code__c != null){
            grade = objContact.G10_Batch_Code__r.Grade__c;
            SchoolName = objContact.G10_Batch_Code__r.School_Name__c != null ? objContact.G10_Batch_Code__r.School_Name__r.Name : '';
            TrainerName = objContact.G10_Batch_Code__r.Trainer_Name__c != null ? objContact.G10_Batch_Code__r.Trainer_Name__r.Name : '';
            BatchNumber = objContact.G10_Batch_Code__r.Batch_Number__c;
            PreferredLanguage = objContact.G10_Batch_Code__r.Preferred_Language__c;
            
        }else if(objContact.Batch_Code__c != null){
            grade = objContact.Batch_Code__r.Grade__c;
            SchoolName = objContact.Batch_Code__r.School_Name__c != null ? objContact.Batch_Code__r.School_Name__r.Name : '';
            TrainerName = objContact.Batch_Code__r.Trainer_Name__c != null ? objContact.Batch_Code__r.Trainer_Name__r.Name : '';
            BatchNumber = objContact.Batch_Code__r.Batch_Number__c;
            PreferredLanguage = objContact.Batch_Code__r.Preferred_Language__c;
            
        }else{
            grade = '';
            SchoolName = '';
            TrainerName = '';
            BatchNumber = '';
            PreferredLanguage = 'English';
        }
        
        for(Explanations__c ex : lstInterests){
            switch on PreferredLanguage {
                when 'Hindi' {
                    ex.Particulars__c = ex.Particulars_Hindi__c;
                }   
                when 'Marathi' {
                    ex.Particulars__c = ex.Particulars_Marathi__c;
                }
                when else {
                    ex.Particulars__c = ex.Particulars__c;
                }
            }
        }
        
        for(Explanations__c ex : lstAptitude){
            switch on PreferredLanguage {
                when 'Hindi' {
                    ex.Particulars__c = ex.Particulars_Hindi__c;
                }   
                when 'Marathi' {
                    ex.Particulars__c = ex.Particulars_Marathi__c;
                }
                when else {
                    ex.Particulars__c = ex.Particulars__c;
                }
            }
        }
        
        system.debug('**Test InterestLabels '+InterestLabels);
                system.debug('**Test AptitudeLabels '+AptitudeLabels);
    }
}