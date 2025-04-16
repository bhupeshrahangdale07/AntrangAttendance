@isTest
public class OpportunityRESTApiTest {

    @isTest
    static void validateOpportunityRESTApi(){
        Test.startTest();
        
        RestResponse res = new RestResponse();
        RestRequest req = new RestRequest();

        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();

        
        Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
        insert acc;
                    
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
        opp.Payroll_details__c ='montly';
        opp.Salary_in_hand_monthly__c = 2000;
        insert opp;
        
        req.requestUri = '/services/apexrest/placements/opportunities';
        req.httpMethod = 'GET';
        RestContext.request = req;
        
        RestContext.response= res;
        
        OpportunityRESTApi.findallopportunity();
        
        delete opp;
        
        OpportunityRESTApi.findallopportunity();
        
        Test.stopTest();            
    }
    
    @isTest
    static void validateOpportunityRESTApi2(){
        Test.startTest();
        
        RestResponse res = new RestResponse();
        RestRequest req = new RestRequest();
        
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Institute').getRecordTypeId();

        
        Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
        insert acc;
                    
        Id oppRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Education').getRecordTypeId();
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
        
        req.requestUri = '/services/apexrest/placements/opportunities';
        req.httpMethod = 'GET';
        RestContext.request = req;
        
        RestContext.response= res;
        
        OpportunityRESTApi.findallopportunity();
        
        delete opp;
        
        OpportunityRESTApi.findallopportunity();
        
        Test.stopTest();            
    }    
    
}