/*
    Description: Wrapper class for Student Report
*/
public with sharing class WrapperStudentReport {
    
    public Contact objContact {Get; set;}
    public string strAspiration{Get; set;}
    public List<Explanations__c> lstInterests{Get; set;}
    public string strPersonality {get; set;}
    public List<string> lstPesonalityIcons {get; set;}
    public List<Explanations__c> lstAptitude{Get; set;}
    public map<Integer, List<string>> mapAllRealities{Get; set;}
    public string strMiddleIconDocId {get; set;}
    
    public InterestLabel InterestLabels {get; set;}
    public AptitudeLabel AptitudeLabels {get; set;}
            
    public WrapperStudentReport(){
        objContact = new Contact();
        strAspiration = '';
        lstInterests = new List<Explanations__c>();
        lstPesonalityIcons = new List<string>();
        strPersonality = '';
        lstAptitude = new List<Explanations__c>();
        mapAllRealities = new map<Integer, List<string>>();
        strMiddleIconDocId = '';
        InterestLabels = new InterestLabel();
        AptitudeLabels = new AptitudeLabel();
    }
    
    public class InterestLabel{
        public string Interest_1_Label {get; set;}
        public string Interest_2_Label {get; set;}
        public string Interest_3_Label {get; set;}
    }
    
    public class AptitudeLabel{
        public string Aptitude_1_Label {get; set;}
        public string Aptitude_2_Label {get; set;}
        public string Aptitude_3_Label {get; set;}
    }
     
}