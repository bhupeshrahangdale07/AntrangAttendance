/*
    Description: class to used for Recommendation Component
*/
public with sharing class RecommendationComponent {
    
    public WrapperContactDetails WrapperContact;
    
    public WrapperContactDetails getWrapperContact() {
        return WrapperContact;
    }
    
    public void setWrapperContact(WrapperContactDetails wrapcontact) {
        WrapperContact = wrapcontact;
        CallRecommendation();
    }
     
    public String pdf{set;get;}
    public String grade{set;get;}
    public String batchNumber{set;get;}
    public String schoolName{set;get;}
    public String trainerName{set;get;}
    public String interest1{set;get;}
    public String interest2{set;get;}
    public String aptitude1{set;get;}
    public String aptitude2{set;get;}
    public String personality1{set;get;}
    public String personality2{set;get;}
    public String personality3{set;get;}
    public String personality4{set;get;}
    public String personality5{set;get;}
    public String personality6{set;get;}
    public String personality7{set;get;}
    public String personality8{set;get;}
    public String reality1{set;get;}
    public String reality2{set;get;}
    public String reality3{set;get;}
    public String reality4{set;get;}
    public String reality5{set;get;}
    public String reality6{set;get;}
    public String reality7{set;get;}
    public String reality8{set;get;}
    Public String profession1{set;get;}
    Public String profession2{set;get;}
    Public String commaSepratedList{set;get;}
    public Contact objcontact {get; set;}
    public Boolean professionshowContent1 { get; set; }
    public Boolean professionshowContent2 { get; set; }
    
    public RecommendationComponent(){}
    
    public void CallRecommendation(){
        objcontact = WrapperContact.objcontact;
        grade = WrapperContact.grade;
        batchNumber  = WrapperContact.batchNumber;
        schoolName = WrapperContact.schoolName;
        trainerName = WrapperContact.trainerName;
        interest1 = WrapperContact.interest1;
        interest2 = WrapperContact.interest2;
        aptitude1 = WrapperContact.aptitude1;
        aptitude2 = WrapperContact.aptitude2;
        personality1 = WrapperContact.personality1; 
        personality2 = WrapperContact.personality2; 
        personality3 = WrapperContact.personality3; 
        personality4 = WrapperContact.personality4; 
        personality5 = WrapperContact.personality5; 
        personality6 = WrapperContact.personality6; 
        personality7 = WrapperContact.personality7; 
        personality8 = WrapperContact.personality8;
        reality1 = WrapperContact.reality1; 
        reality2 = WrapperContact.reality2; 
        reality3 = WrapperContact.reality3; 
        reality4 = WrapperContact.reality4; 
        reality5 = WrapperContact.reality5; 
        reality6 = WrapperContact.reality6; 
        reality7 = WrapperContact.reality7; 
        reality8 = WrapperContact.reality8; 
        profession1 = WrapperContact.profession1; 
        profession2 = WrapperContact.profession2; 
        commaSepratedList = WrapperContact.commaSepratedList;
        professionshowContent1  = WrapperContact.professionshowContent1;
        professionshowContent2 = WrapperContact.professionshowContent2;
    }
    
    public PageReference redirect(){
        pdf = 'pdf';
        return null;
    }
}