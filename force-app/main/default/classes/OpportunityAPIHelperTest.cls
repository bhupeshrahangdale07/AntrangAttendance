@isTest(SeeAllData=false)
public class OpportunityAPIHelperTest {
    
     @isTest
    static void ValidateOpportunityRESTApiTest(){
        Test.startTest();
        
       RestResponse res = new RestResponse();
       RestRequest req = new RestRequest();
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
       
        Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
       insert acc;
       
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
       Contact c = new Contact();
       c.lastname = 'test';
       c.recordtypeid = contactRecordTypeId;
       c.Gender__c = 'Male only';
       c.Education_Level__c = 'Graduate';
       c.Available_working_Hours_Start_Time__c =  Time.newInstance(8, 1, 1, 1);
       c.Available_working_Hours_Finish_Time__c = Time.newInstance(9, 1, 1, 1);
       c.Available_work_Days__c = 'Tuesday';
       c.AccountId = acc.id;
       c.UID__c = '2000';
       insert c;
        Id oppRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
        Opportunity__c  opp = new Opportunity__c();
        opp.name = 'Test Opporunity';
        opp.recordtypeid = oppRecordTypeId;
        opp.Educational_Level__c = 'Graduate';
        opp.Type_of_opportunity__c = 'Education';
        opp.Account__c = acc.id;
        opp.Gender__c = 'Male only';
        opp.No_of_Openings__c = 1;
        opp.Working_Hours_Start_Time__c = Time.newInstance(7, 1, 1, 1);
        opp.Working_Hours_End_Time__c = Time.newInstance(15, 1, 1, 1);
        opp.Work_Days__c = 'Tuesday; Wednesday;';
        insert opp;
        
       Id oppAssgRecordTypeId = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
        Opportunity_Assignment__c oppassign = new Opportunity_Assignment__c();
        oppassign.Student__c=c.id;
        oppassign.Opportunity__c=opp.id;
        oppassign.recordtypeid = oppAssgRecordTypeId;
        oppassign.Status__c ='Student Interested';
        insert oppassign;
        
        req.requestUri = URL.getSalesforceBaseUrl().toExternalForm()+'/services/apexrest/placements/oppassignments';
        req.httpMethod = 'GET';
        
        
        RestContext.request = req;
        RestContext.response= res;
        OpportunityAPIHelper.doGet();
        /*delete opp;
        OpportunityAPIHelper.doGet();*/
        
        Test.stopTest();            
    }

}