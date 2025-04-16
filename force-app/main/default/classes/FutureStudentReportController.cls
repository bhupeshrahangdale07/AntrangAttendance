public with sharing class FutureStudentReportController {
    public Contact objContact {get; set;}
    public string strAspiration {get; set;}    
    public List<Explanations__c> lstInterests {get; set;}    
    public List<Explanations__c> lstAptitude {get; set;}    
    public map<Integer, List<string>> mapAllRealities {get; set;}
    public boolean blnRealityFound {get; set;}
    public string strMiddleIconDocId {get; set;}
    public string strOrgId {get; set;}
    
    public map<string,Explanations__c> mapofInterest;
    public map<string,Explanations__c> mapofPersonality;
    public map<string,Explanations__c> mapofAptitude;
    public map<string,string> mapRealityExplanations;
    
    public FutureStudentReportController(){
        
    }
}