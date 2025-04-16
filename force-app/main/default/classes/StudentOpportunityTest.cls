@isTest
public class StudentOpportunityTest {

    @isTest
    static void validateStudentOpportunity(){
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
       c.Gender__c = 'Male';
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
       opp.Gender__c = 'Male';
       opp.No_of_Openings__c = 1;
       opp.Working_Hours_Start_Time__c = Time.newInstance(7, 1, 1, 1);
       opp.Working_Hours_End_Time__c = Time.newInstance(15, 1, 1, 1);
       opp.Work_Days__c = 'Tuesday; Wednesday;';
       opp.Payroll_details__c = 'monthly';
       opp.Salary_in_hand_monthly__c = 999999;
       insert opp;
        
        req.requestUri = '/services/apexrest/placements/studentopportunities/'+c.UID__c;
        req.httpMethod = 'GET';
        RestContext.request = req;
        
        RestContext.response= res;
    
        StudentOpportunity.findstudentopportunity();
        
        delete opp;
        
        StudentOpportunity.findstudentopportunity();
        
        delete c;
        
        StudentOpportunity.findstudentopportunity();
    
        Test.stopTest();            
    }
    
    
}