@isTest
public class SessionOMRTypeTriggerHandlerTest {
    
    @testSetup
    public static void dataSetup() {
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
		Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai';
        sm.Name = 'TDistrict Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'test description';
        insert sm;

        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Mumbai';
        insert distict;
        
        City_Master__c city =new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan';
        insert city;
        
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West Kalyan';
        insert ward;
        
        Account account=new Account();
        account.Name='Shreeram School';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;

        Batch__c batch=new Batch__c();
        batch.School_Name__c=account.id;
        batch.Preferred_Language__c='Hindi';
        batch.Academic_Year__c = 2023;
        Insert batch;
        
        Session__c session = New Session__c();
        session.Name = 'Test';
        session.Batch__c = batch.id;
        insert session;
        
        Session_OMR_Type__c sot = New Session_OMR_Type__c();
        sot.Session__c = session.Id;
		insert sot;        
       
    }
        
    public static testMethod void test1() {
		
        Id accRecType = SObjectType.Account.getRecordTypeInfosByDeveloperName().get('School_Account').getRecordTypeId();
		Account acc = new Account();
        acc.RecordTypeId = accRecType;
        acc.Name = 'Anonymous Household';
        acc.School_Name__c = 'Anonymous Household';
        
        insert acc;
        
        Contact cont = new Contact();
        cont.FirstName = 'Test FirstName';
        cont.LastName = 'Test LastName';
        cont.AccountId = acc.Id;
        insert cont;
        
        Batch__c bat = new Batch__c();
        bat.Name = 'Test Batch';
        bat.School_Name__c = acc.Id;
        bat.Preferred_Language__c = 'English';
        insert bat;
        
        Session__c sess = new Session__c();
        sess.Name = 'Test Session';
        sess.Assigned_Facilitator__c = cont.Id;
        sess.Batch__c = bat.Id;
        insert sess;
        
        Session_OMR_Type__c somr = new Session_OMR_Type__c();
        somr.OMR_Type__c = 'Career Decision Making- 1A';
        somr.OMR_Assessment_Count__c = 0;
        somr.OMR_Assessment_Object__c = 'CDM1';
        somr.OMR_Assessment_Record_Type__c = 'Baseline';
        somr.Session__c = sess.Id;
        
        insert somr;
        
        Session_OMR_Type__c somr1 = new Session_OMR_Type__c();
        somr1.OMR_Type__c = 'Career Decision Making- 1A';
        somr1.OMR_Assessment_Count__c = 2;
        somr1.OMR_Assessment_Object__c = 'CDM1';
        somr1.OMR_Assessment_Record_Type__c = 'Baseline';
        somr1.Session__c = sess.Id;
        
        insert somr1;
        
        somr.OMR_Assessment_Count__c = 1;
        somr1.OMR_Assessment_Count__c = 0;

        Session_OMR_Type__c s = [Select Id,OMRs_Received_Count__c From Session_OMR_Type__c LIMIT 1];
        s.OMRs_Received_Count__c = 2;
        
        Test.startTest();
        update s;
        update somr;
        update somr1;
        Test.stopTest();
    }

}