@isTest
public class TestOppRestWebService {
    @isTest
    static void TestOpportunityWebservice() {
    
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();

        Account acc = new Account(Name = 'test', recordtypeid=accRecordTypeId);
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
        c.UID__c='test';
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
        opp.Payroll_details__c = 'hourly';
        opp.Salary_in_hand_monthly__c = 100;
        insert opp;

        Opportunity__c  opp2 = new Opportunity__c();
        opp2.name = 'Test Opporunity';
        opp2.recordtypeid = oppRecordTypeId;
        opp2.Educational_Level__c = 'Graduate';
        opp2.Type_of_opportunity__c = 'Education';
        opp2.Account__c = acc.id;
        opp2.Gender__c = 'Male only';
        opp2.No_of_Openings__c = 1;
        opp2.Working_Hours_Start_Time__c = Time.newInstance(7, 1, 1, 1);
        opp2.Working_Hours_End_Time__c = Time.newInstance(15, 1, 1, 1);
        opp2.Work_Days__c = 'Tuesday; Wednesday;';
        opp2.Payroll_details__c = 'hourly';
        opp2.Salary_in_hand_monthly__c = 100;
        insert opp2;

        Opportunity_Assignment__c oa = new Opportunity_Assignment__c(
            Student__c = c.Id,
            RecordTypeId = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId(),
            Opportunity__c = opp.Id,
            Status__c ='Student Interested'
        );
        insert oa;


        //Get method coverage
        RestContext.response = new RestResponse();
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/placements/oppassignments/test';
        request.httpMethod = 'GET';
        RestContext.request = request;

        OpportunityAPIHelper.doGet();
        String oppAssignments = RestContext.response.responseBody.toString();

        request.params.put('id','ssss');
        RestContext.request = request;
        OpportunityAPIHelper.doGet();
        oppAssignments = RestContext.response.responseBody.toString();

        request.params.put('id',c.UID__c);
        RestContext.request = request;
        OpportunityAPIHelper.doGet();
        oppAssignments = RestContext.response.responseBody.toString();
        OpportunityAPIHelper.GetOppResponseModel oppDetailModel = 
                (OpportunityAPIHelper.GetOppResponseModel) System.JSON.deserialize(oppAssignments, OpportunityAPIHelper.GetOppResponseModel.class);
        system.assertEquals(oppDetailModel.OpportunityAssignments.size(),1);

        //Post method coverage
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf('[{ "Status": "Education not achieved", "RecordTypeName": "Education", "OpportunityId": "'+opp2.Id+'", "LinkageNotAchieved": true }, { "Status": "Education not achieved", "RecordTypeName": "Education", "OpportunityId": "'+opp.Id+'", "LinkageNotAchieved": true },{ "Status": "Education not achieved", "RecordTypeName": "Education", "OpportunityId": "'+opp2.Id+'", "LinkageNotAchieved": true },{ "Status": "Education not achieved", "RecordTypeName": "Education", "OpportunityId": "0035D00000T8y52QABsssss", "LinkageNotAchieved": true }, { "Status": "Education not achieved", "RecordTypeName": "Education", "OpportunityId": "", "LinkageNotAchieved": true }]');
        RestContext.request = request;
        //OpportunityAPIHelper.doPost();
        //system.assertEquals([select id from Opportunity_Assignment__c where Student__c=:c.Id].size(),2);
    }
}