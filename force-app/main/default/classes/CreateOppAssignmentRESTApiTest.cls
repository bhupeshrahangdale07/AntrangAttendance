@isTest
global class CreateOppAssignmentRESTApiTest{
    
    public static testMethod void validateOppAssignmentRESTApi() {
        
        RestResponse res = new RestResponse();
        RestRequest req = new RestRequest();
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
     
        Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
        insert acc;
        
        Contact con =new Contact();
        con.FirstName='Test12';
        con.LastName='LN';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CR_Student').getRecordTypeId();
        con.RecordTypeId=RecordTypeIdContact;
        insert con;
      
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
        opp.Payroll_details__c = 'Monthly';
        opp.Salary_in_hand_monthly__c= 20000;
        insert opp;
        opportunity__c oppty =[select id,Opportunity_Unique_Id__c from opportunity__c where id=:opp.id];
   
        Id oppAssgRecordTypeId = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
        Opportunity_Assignment__c oppassign = new Opportunity_Assignment__c();
        oppassign.Student__c=con.id;
        oppassign.Opportunity__c=opp.id;
        oppassign.Student__c=con.id;
        oppassign.recordtypeid = oppAssgRecordTypeId;
        oppassign.Opportunity__c=opp.id;
        oppassign.Job_Start_Date__c=Date.newInstance(2008, 12, 1);
        //oppassign.Payroll_details__C='daily';
        //oppassign.Gross_Salary_monthly__c =2500;
        oppassign.Status__c ='Student Intersted';
        oppassign.Last_Status_changed_on__c=Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        oppassign.Reasons_for_Rejection__c='Got another job';
        oppassign.Reasons_for_Leaving__c='Health';
        //oppassign.Comments__c='test';
        oppassign.Left_Job_Date__c=Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        //oppassign.Admission_gained_Date__c=Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        oppassign.Linkage_Not_Achieved__c= true;
        oppassign.Blacklisted__c= false;
        oppassign.Active__c= true;
        oppassign.Course_Started_Date__c=Datetime.newInstance(2008, 12, 1,12, 30, 2);
        oppassign.Course_completed_Date__c=Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        oppassign.Education_achieved_Date__c = Datetime.newInstance(2008, 12, 2, 12, 30, 2);
        oppassign.Created_Via_App__c = true;
        oppassign.Active__c = true;
        oppassign.Applicant_Job_Status__c = '1';
        Insert oppassign;
        
        
        
        
        String JsonMsg='{"opportunities": [{"opportunityid": "'+ oppty.Opportunity_Unique_Id__c +'","assignments": [{"name": "","id":"'+ oppassign.id +'","studentid": "'+con.id+'","job_start_date": "2019-04-03","status": "Left Job after 6 months","last_status_changed_on": "2019-06-03 04:00:00","reasons_for_rejection": "Got another job","reasons_for_leaving": "Health","left_job_date": "2019-07-03 06:00:00","admission_gained_date": "2019-04-03 05:00:00","linkage_not_achieved": false,"active": false,"course_started_Date": "2019-06-01 05:00:00","course_completed_date": "2019-06-01 05:00:00","student_uid": "","opportunity_name": "","recordtype_name": "","recordtypeId": "","education_achieved_date": "2019-06-01 05:00:00","isdeleted": false,"created_via_app": false,"applicant_job_status": "1"}]}]}';
        string jsonresponse = '[{"status": "success","opportunityid": "'+opp.id+'","error": null,"assignments": [{"status": "success","oppassignmentid": "'+oppassign.id+'","message": "","jobstatus": "Left Job after 6 months"}]}]';
        system.debug('JsonMsg'+JsonMsg);
        system.debug('jsonresponse'+jsonresponse);
        
        
        RestContext.request = req;
        RestContext.response= res;
        
        req.requestUri = URL.getOrgDomainURL().toExternalForm() + '/services/apexrest/placements/assignments';
        req.httpMethod = 'POST';
        // req.setHeader('Content-Type', 'application/json');
        //req.setHeader('Authorization', 'OAuth  00DO0000004yEyC!AQcAQDaMqxIOuoSiZQGp7QsCJAiBvCRjSZEdcYq3rv22sbyxnejlHj7fMPJcOTJ3OtaYgQ2oa0GWVkayIaez4OXHq4UD8m8E');
        req.requestBody = Blob.valueof(JsonMsg);
        system.debug('req.requestBody '+ req.requestBody);
        Test.StartTest();
        CreateOppAssignmentRESTApi.CreateOppAssignments();
        res.responseBody =Blob.valueof(jsonresponse);
        
        Test.stopTest();
        
    }
     public static testMethod void validateOppAssignmentRESTApi1() {
        
        RestResponse res = new RestResponse();
        RestRequest req = new RestRequest();
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
     
        Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
        insert acc;
        
        Contact con =new Contact();
        con.FirstName='Test12';
        con.LastName='LN';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CR_Student').getRecordTypeId();
        con.RecordTypeId=RecordTypeIdContact;
        insert con;
      
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
        opp.Payroll_details__c = 'Monthly';
        opp.Salary_in_hand_monthly__c= 20000;
        insert opp;
        opportunity__c oppty =[select id,Opportunity_Unique_Id__c from opportunity__c where id=:opp.id];
   
        Id oppAssgRecordTypeId = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
        Opportunity_Assignment__c oppassign = new Opportunity_Assignment__c();
        oppassign.Student__c=con.id;
        oppassign.Opportunity__c=opp.id;
        oppassign.Student__c=con.id;
        oppassign.recordtypeid = oppAssgRecordTypeId;
        oppassign.Opportunity__c=opp.id;
        oppassign.Job_Start_Date__c=Date.newInstance(2008, 12, 1);
        //oppassign.Payroll_details__C='daily';
        //oppassign.Gross_Salary_monthly__c =2500;
        oppassign.Status__c ='Interview appeared';
        oppassign.Last_Status_changed_on__c=Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        oppassign.Reasons_for_Rejection__c='Got another job';
        oppassign.Reasons_for_Leaving__c='Health';
        //oppassign.Comments__c='test';
        oppassign.Left_Job_Date__c=Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        //oppassign.Admission_gained_Date__c=Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        oppassign.Linkage_Not_Achieved__c= true;
        oppassign.Blacklisted__c= false;
        oppassign.Active__c= true;
        oppassign.Course_Started_Date__c=Datetime.newInstance(2008, 12, 1,12, 30, 2);
        oppassign.Course_completed_Date__c=Datetime.newInstance(2008, 12, 1, 12, 30, 2);
        oppassign.Education_achieved_Date__c = Datetime.newInstance(2008, 12, 2, 12, 30, 2);
        oppassign.Created_Via_App__c = true;
        oppassign.Active__c = true;
        oppassign.Applicant_Job_Status__c = '1';
        Insert oppassign;
        
        
        
        
        String JsonMsg='{"opportunities": [{"opportunityid":'+ oppty.Opportunity_Unique_Id__c +',"assignments": [{"name": "","id": "","studentid": "'+con.id+'","job_start_date": "2019-04-03","status": "Interview appeared","last_status_changed_on": "2019-06-03 04:00:00","reasons_for_rejection": "Got another job","reasons_for_leaving": "Health","left_job_date": "2019-07-03 06:00:00","admission_gained_date": "2019-04-03 05:00:00","linkage_not_achieved": false,"active": false,"course_started_Date": "2019-06-01 05:00:00","course_completed_date": "2019-06-01 05:00:00","student_uid": "","opportunity_name": "","recordtype_name": "","recordtypeId": "","education_achieved_date": "2019-06-01 05:00:00","isdeleted": false,"created_via_app": false,"applicant_job_status": "1"}]}]}';
        string jsonresponse = '[{"status": "success","opportunityid": "'+opp.id+'","error": null,"assignments": [{"status": "success","oppassignmentid": "'+oppassign.id+'","message": "","jobstatus": "Interview appeared"}]}]';
        system.debug('JsonMsg'+JsonMsg);
        system.debug('jsonresponse'+jsonresponse);
        
        RestContext.request = req;
        RestContext.response= res;
        
        req.requestUri = URL.getOrgDomainURL().toExternalForm() + '/services/apexrest/placements/assignments';
        req.httpMethod = 'POST';
        // req.setHeader('Content-Type', 'application/json');
        //req.setHeader('Authorization', 'OAuth  00DO0000004yEyC!AQcAQDaMqxIOuoSiZQGp7QsCJAiBvCRjSZEdcYq3rv22sbyxnejlHj7fMPJcOTJ3OtaYgQ2oa0GWVkayIaez4OXHq4UD8m8E');
        req.requestBody = Blob.valueof(JsonMsg);
        system.debug('req.requestBody '+ req.requestBody);
        Test.StartTest();
        CreateOppAssignmentRESTApi.CreateOppAssignments();
        res.responseBody =Blob.valueof(jsonresponse);
        
        Test.stopTest();
        
    }
    
    
}