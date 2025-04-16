@istest
public class SessionTriggerTest {
    
    @TestSetup
    public static void setup() {
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.Name = 'Thane';
        sm.District__c = 'Thane';
        sm.Session_Number__c = 1;
        sm.Grade__c = 'Grade 10';
        sm.Description__c = 'Test';
        insert sm;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Thane';
        insert distict;
        
        City_Master__c city =new City_Master__c();
        city.District__c=distict.id;
        city.Name='Thane'; 
        insert city;
        
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='Anderi';
        insert ward;
        
        Account account=new Account();
        account.Name='Shreeram School';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.School_Timing__c = 'morning';
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('School_Account').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        account.Medium_Language_of_Instruction__c = 'English';
        account.School_Location__c = 'Test Principal address';
        account.Principal_Name__c = 'Test Principal';
        insert account;
        
        Contact contact=new Contact();
        contact.FirstName='Test';
        contact.LastName='LName';
        contact.Email = 'test@gmail.com';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        contact.Language__c='English;Hindi';
        contact.Cities_of_Operation__c = 'Thane';
        contact.Trainer_Status__c = 'morning';
        insert contact;
        
        Contact contact1=new Contact();
        contact1.FirstName='Test1';
        contact1.LastName='LName1';
        contact1.Email = 'test@gmail.com';
        contact1.RecordTypeId=RecordTypeIdContact;
        contact1.Language__c='English;Hindi';
        contact1.Cities_of_Operation__c = 'Thane';
        contact1.Trainer_Status__c = 'morning';
        insert contact1;
        
        Batch__c batch1 = new Batch__c();
        batch1.Name = 'batch 1';
        batch1.School_Name__c=account.id;
        batch1.Preferred_Language__c = 'Hindi';
        batch1.Medium_Language_of_Instruction__c = 'English';
        insert batch1;
        
        Batch__c b = [Select Id,Name,Batch_Number__c From Batch__c Where Name = 'batch 1'];
        Batch__c batch2 = new Batch__c();
        batch2.Name = 'batch 2';
        batch2.School_Name__c=account.id;
        batch2.Preferred_Language__c = 'Hindi';
        batch2.Medium_Language_of_Instruction__c = 'English';
        batch2.Combined_Batch_no__c = Decimal.valueOf(b.Batch_Number__c);
        insert batch2;
    }
    
    @istest
    public static void testSessionNumberInsert(){
        
        Batch__c batch = [Select Id From Batch__c Where Name = 'batch 1'];
        Contact cont = [Select Id From Contact Where Lastname = 'LName'];
        
        session__c session = new session__c();
        session.Name = 'test';
        session.Batch__c = batch.id;
        session.Assigned_facilitator__c = cont.Id;
        session.SessionDate__c = date.valueOf('2020-03-26');
        session.Session_Number__c = 1;
        test.startTest();
        insert session;
        
        session.SessionDate__c = System.today();
        update session;
        session.SessionDate__c = System.today()+1;
        update session;
        
        contact c = [select id,Number_Of_Sessions__c from contact where id=: cont.Id];
        
        system.assertEquals(1, c.Number_Of_Sessions__c);
        test.stopTest();
    }
    
    @istest
    public static void testSessionNumberUpdate(){
        
        Batch__c batch = [Select Id From Batch__c Where Name = 'batch 1'];
        Contact cont = [Select Id From Contact Where Lastname = 'LName'];   
        Contact cont1 = [Select Id From Contact Where Lastname = 'LName1'];
        
        session__c session = new session__c();
        session.Name = 'test';
        session.Batch__c = batch.Id;
        session.Assigned_facilitator__c = cont.Id;
        session.SessionDate__c = date.valueOf('2020-03-26');
        insert session;
        
        test.startTest();
        
        session.Assigned_facilitator__c = cont1.Id;
        update session;
        
        test.stopTest();
        SessionTriggerHandler.dummycoverage();
        contact cOld = [select id,Number_Of_Sessions__c from contact where id=: cont.Id];
        system.assertEquals(0, cOld.Number_Of_Sessions__c); 
        
        contact c = [select id,Number_Of_Sessions__c from contact where id=: cont1.Id];
        system.assertEquals(1, c.Number_Of_Sessions__c);
    }
    
    @isTest
    public static void testUpdateInactiveSessions() {
        Batch__c batch1 = [Select Id From Batch__c Where Name = 'batch 1'];
        Batch__c batch2 = [Select Id From Batch__c Where Name = 'batch 2'];
        Contact cont = [Select Id From Contact Where Lastname = 'LName'];
        
        session__c session = new session__c();
        session.Name = 'test';
        session.Batch__c = batch1.Id;
        session.Assigned_facilitator__c = cont.Id;
        session.SessionDate__c = date.valueOf('2020-03-26');
        session.Session_Grade__c = 'Grade 10';
        insert session;
        
        session__c session1 = new session__c();
        session1.Name = 'test';
        session1.Batch__c = batch2.Id;
        session1.Assigned_facilitator__c = cont.Id;
        session1.SessionDate__c = date.valueOf('2020-03-26');
        session1.Session_Grade__c = 'Grade 10';
        session1.Is_Inactive_Session__c = true;
        insert session1;
        
        test.startTest();
        session.Payment_Status__c = 'Payment Made';
        session.SessionDate__c = system.today();
        update session;
        
        session1.Payment_Status__c = 'Ready For Payment';
        session1.Session_Type__c = 'Counseling';
        session1.Attendance_Submitted__c = true;
        update session1;
        test.stopTest();
        Session__c sess = [Select Id,Payment_Status__c From Session__c Where Id =: session.Id];
        system.assertEquals('Payment Made', sess.Payment_Status__c);
    }
}