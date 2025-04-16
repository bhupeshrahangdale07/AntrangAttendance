//added by kandisatech on 11/11/2019
@isTest
public class BatchToUpdateOppAssignPrevStatusTest {
    
    public static testMethod void test(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();     
        Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
        insert acc;

        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        Contact c = new Contact();
        c.lastname = 'test';
        c.recordtypeid = contactRecordTypeId;
        c.Gender__c = 'Male only';
        c.Education_Level__c = 'Graduate';
        c.Available_working_Hours_Start_Time__c = Time.newInstance(8, 1, 1, 1);
        c.Available_working_Hours_Finish_Time__c = Time.newInstance(9, 1, 1, 1);
        c.Available_work_Days__c = 'Tuesday';
        c.AccountId = acc.id;
        c.UID__c = '2000';
        insert c;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByDeveloperName().get('Training').getRecordTypeId();
        Opportunity__c opp = new Opportunity__c();
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

        Id oppAssgRecordTypeId = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByDeveloperName().get('Training').getRecordTypeId();
        Opportunity_Assignment__c oppassign = new Opportunity_Assignment__c();
        oppassign.Student__c = c.id;
        oppassign.Opportunity__c = opp.id;
        oppassign.recordtypeid = oppAssgRecordTypeId;
        oppassign.Status__c = 'Not contactable';
        //oppassign.Reasons_for_Rejection__c = 'Completed course elsewhere';
        //oppassign.Reasons_for_Leaving__c = 'Health';
        oppassign.Linkage_Not_Achieved__c = true;
        oppassign.Active__c = true;
        insert oppassign;

        
        
        Test.startTest();
        
        oppassign.Status__c = 'Left msg for call back';
        update oppassign;

        BatchToUpdateOppAssignPrevStatus b = new BatchToUpdateOppAssignPrevStatus();
        database.executeBatch(b);


        Test.stopTest();

    }
}