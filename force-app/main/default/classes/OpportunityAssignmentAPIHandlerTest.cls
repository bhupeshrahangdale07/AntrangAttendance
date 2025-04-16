@isTest
Public class OpportunityAssignmentAPIHandlerTest {

    public static testMethod void OpptyAssgnAPITest() {
        List < Opportunity_Assignment__c > opptyassgnLst = new List < Opportunity_Assignment__c > ();
        map < id, Opportunity_Assignment__c > opptyassginMap = new map < id, Opportunity_Assignment__c > ();
        AntarangSetting__c setting = new AntarangSetting__c();
        setting.BaseApiUrl__c = 'http://dscareereadyapp.azurewebsites.net/api/opportunityassignment/insertupdateapplicantopportunityassignment';
        insert setting;
        system.debug('1*'+ setting);
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        system.debug('2*'+ accRecordTypeId);
        Account acc = new Account(Name = 'Test Account', recordtypeid = accRecordTypeId);
        insert acc;
        system.debug('3*'+ acc);
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        system.debug('4*'+ contactRecordTypeId);
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
        c.Additional_courses__c = 'Digital Marketing';
        insert c;
        system.debug('5*'+ c);
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
        system.debug('6*'+ oppRecordTypeId);
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
        opp.Payroll_details__c = 'weekly';
        opp.Salary_in_hand_monthly__c = 1000;
        insert opp;
        system.debug('7*'+ opp);
         Id oppRecordTypeId1 = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('External Employment').getRecordTypeId();
        system.debug('6*'+ oppRecordTypeId);
        Opportunity__c opp1 = new Opportunity__c();
        opp1.name = 'Test Opporunity';
        opp1.recordtypeid = oppRecordTypeId1;
        opp1.Educational_Level__c = 'Graduate';
        opp1.Type_of_opportunity__c = 'Education';
        opp1.Account__c = acc.id;
        opp1.Gender__c = 'Male only';
        opp1.No_of_Openings__c = 1;
        opp1.Working_Hours_Start_Time__c = Time.newInstance(7, 1, 1, 1);
        opp1.Working_Hours_End_Time__c = Time.newInstance(15, 1, 1, 1);
        opp1.Work_Days__c = 'Tuesday; Wednesday;';
        opp1.Payroll_details__c = 'weekly';
        opp1.Salary_in_hand_monthly__c = 1000;
        insert opp1;
        

        Id oppAssgRecordTypeId = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
        Opportunity_Assignment__c oppassign = new Opportunity_Assignment__c();
        oppassign.Student__c = c.id;
        oppassign.Opportunity__c = opp.id;
        oppassign.Status__c = 'Not contactable';
        //oppassign.Reasons_for_Rejection__c = 'Completed course elsewhere';
        //oppassign.Reasons_for_Leaving__c = 'Health';
        oppassign.recordtypeid = oppAssgRecordTypeId;
        oppassign.Linkage_Not_Achieved__c = true;
        oppassign.Active__c = true;
        oppassign.Course_name__c = 'Digital Marketing';
        //insert oppassign;
        system.debug('8*'+ oppassign);
        
        Id oppAssgRecordTypeId1 = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('External Employment').getRecordTypeId();
        Opportunity_Assignment__c oppassign1 = new Opportunity_Assignment__c();
        oppassign1.Student__c = c.id;
        oppassign1.Opportunity__c = opp1.id;
        oppassign1.Status__c = 'Not contactable';
        //oppassign.Reasons_for_Rejection__c = 'Completed course elsewhere';
        //oppassign.Reasons_for_Leaving__c = 'Health';
        oppassign1.recordtypeid = oppAssgRecordTypeId1;
        oppassign1.Linkage_Not_Achieved__c = true;
        oppassign1.Active__c = true;
        oppassign1.Course_name__c = 'Digital Marketing';
        insert oppassign1;
        
        opptyassgnLst.add(oppassign);
        opptyassginMap.put(oppassign.id, oppassign);

        CalloutMock opptyassignapi = new CalloutMock(setting.BaseApiUrl__c, 200, 'OK', '[{"StatusCode": "SUCCESS","message": "Opportunity Assignment added successfully"}]', new map < string, string > {'Content-Type' => 'application/json'});
        Test.setMock(HttpCalloutMock.class, opptyassignapi);
        Test.startTest();
        OpportunityAssignmentAPIHandler.OpportunityAssignmentAPI(opptyassgnLst, False, False, False, opptyassginMap);
        Test.stopTest();

    }
     public static testMethod void OpptyAssgnAPITest1() {
         
         List < Opportunity_Assignment__c > opptyassgnLst = new List < Opportunity_Assignment__c > ();
        map < id, Opportunity_Assignment__c > opptyassginMap = new map < id, Opportunity_Assignment__c > ();
        AntarangSetting__c setting = new AntarangSetting__c();
        setting.BaseApiUrl__c = 'http://dscareereadyapp.azurewebsites.net/api/opportunityassignment/insertupdateapplicantopportunityassignment';
        insert setting;
        system.debug('9*'+ setting);
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        system.debug('10*'+ accRecordTypeId);
        
        Account acc = new Account(Name = 'Test Account', recordtypeid = accRecordTypeId);
        insert acc;
        system.debug('11*'+ acc);

        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        system.debug('12*'+ contactRecordTypeId);
        
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
        system.debug('13*'+ c);
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
        
        system.debug('14*'+ oppRecordTypeId);
        
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
        opp.Payroll_details__c = 'weekly';
        opp.Salary_in_hand_monthly__c = 1000;
        insert opp;
        
        system.debug('15*'+ opp);

        Id oppAssgRecordTypeId = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
        Opportunity_Assignment__c oppassign = new Opportunity_Assignment__c();
        oppassign.Student__c = c.id;
        oppassign.Opportunity__c = opp.id;
        oppassign.Status__c = 'Not contactable';
        //oppassign.Reasons_for_Rejection__c = 'Completed course elsewhere';
        //oppassign.Reasons_for_Leaving__c = 'Health';
        oppassign.recordtypeid = oppAssgRecordTypeId;
        oppassign.Linkage_Not_Achieved__c = true;
        oppassign.Active__c = true;
        //oppassign.Course_name__c = 'Digital Marketing';
        insert oppassign;
        system.debug('16*'+ oppassign);
        
        opptyassgnLst.add(oppassign);
        opptyassginMap.put(oppassign.id, oppassign);

        CalloutMock opptyassignapi = new CalloutMock(setting.BaseApiUrl__c, 200, 'OK', '[{"StatusCode": "SUCCESS","message": "Opportunity Assignment added successfully"}]', new map < string, string > {'Content-Type' => 'application/json'});
        Test.setMock(HttpCalloutMock.class, opptyassignapi);
        Test.startTest();
        
        oppassign.Status__c = 'CVs sent to the employer';
        update oppassign;
        opptyassgnLst.add(oppassign);
        opptyassginMap.put(oppassign.id, oppassign);
        OpportunityAssignmentAPIHandler.OpportunityAssignmentAPI(opptyassgnLst, False, False, False, opptyassginMap);

        Test.stopTest();
         
     }
    
    public static testMethod void OpptyAssgnDuplicateValidation() {
         
       
        
         List < Opportunity_Assignment__c > opptyassgnLst = new List < Opportunity_Assignment__c > ();
        map < id, Opportunity_Assignment__c > opptyassginMap = new map < id, Opportunity_Assignment__c > ();
        AntarangSetting__c setting = new AntarangSetting__c();
        setting.BaseApiUrl__c = 'http://dscareereadyapp.azurewebsites.net/api/opportunityassignment/insertupdateapplicantopportunityassignment';
        setting.Enable_Opp_Assignment_Duplicate_Validati__c = true;
        insert setting;
        
        system.debug('9*'+ setting);
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        system.debug('10*'+ accRecordTypeId);
        
        Account acc = new Account(Name = 'Test Account', recordtypeid = accRecordTypeId);
        insert acc;
        system.debug('11*'+ acc);

        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
        system.debug('12*'+ contactRecordTypeId);
        
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
        system.debug('13*'+ c);
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
        
        system.debug('14*'+ oppRecordTypeId);
        
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
        opp.Payroll_details__c = 'weekly';
        opp.Salary_in_hand_monthly__c = 1000;
        insert opp;
        
        system.debug('15*'+ opp);

        Id oppAssgRecordTypeId = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
        Opportunity_Assignment__c oppassign = new Opportunity_Assignment__c();
        oppassign.Student__c = c.id;
        oppassign.Opportunity__c = opp.id;
        oppassign.Status__c = 'Not contactable';
        oppassign.recordtypeid = oppAssgRecordTypeId;
        oppassign.Linkage_Not_Achieved__c = true;
        oppassign.Active__c = true;
        insert oppassign;
        
        
        Test.startTest();
        
        try{
            Opportunity_Assignment__c oppassign1 = new Opportunity_Assignment__c();
            oppassign1.Student__c = c.id;
            oppassign1.Opportunity__c = opp.id;
            oppassign1.Status__c = 'Not contactable';
            oppassign1.recordtypeid = oppAssgRecordTypeId;
            oppassign1.Linkage_Not_Achieved__c = true;
            oppassign1.Active__c = true;
            insert oppassign1;
        }catch(Exception e){
            
            Boolean expectedExceptionThrown =  (e.getMessage().contains('Duplicate')) ? true : false;
            
            System.AssertEquals(expectedExceptionThrown, true);
            
        } 
        

        

        Test.stopTest();
         
     }

}