public without sharing class AssesementQuestionController {
    
	@AuraEnabled
    public static List<Assessment_Question__c> getAssesmentQuestion(String objectName, String formType, string grade) {
        List<Assessment_Question__c> questions = [select id,Sequence_Number__c,Question_Label_English__c,Question_Label_Hindi__c, 
                (select id,Option_Label_English__c,Option_Label_Hindi__c,Sequence_Number__c from Assessment_Question_Options__r 
                 order by Sequence_Number__c asc) from Assessment_Question__c where Assesment_Object__c = :objectName and 
                Form_Category__c = :formType and Grade__c = :grade order by Sequence_Number__c asc];
		return questions;
    }
    @AuraEnabled
    public static string getStudentName(String studId) {
        list<Contact> studList = [select id, name from contact where id = :studId];
        if(studList.size() > 0) return studList[0].name;
        return '';
    }
}