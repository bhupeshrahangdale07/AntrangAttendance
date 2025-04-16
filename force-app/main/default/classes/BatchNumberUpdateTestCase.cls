/* Getting the code coverage for BatchNumberUpdate trigger  */
@isTest(seealldata=false)
public class BatchNumberUpdateTestCase {
    
    public static testMethod void test() {
        TriggerCheck triggerCheck=new TriggerCheck();
        Batch__c batch = new Batch__c();
        batch.Preferred_Language__c='Hindi';
        State_Govt_Body_Level__c state = new State_Govt_Body_Level__c();
        state.Name = 'SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai (City & Suburban)';
        sm.Name = 'Mum Grade 9 S1';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
        
        District_Master__c dm = new District_Master__c();
        dm.Name = 'Mumbai (City & Suburban)';
        dm.State__c = state.id;
        insert dm;
        triggerCheck.setVariable(true);
        
        City_Master__c city = new City_Master__c();
        city.District__c = dm.id;
        city.Name = 'Kalyan'; 
        //city.City_Code__c = '2';
        insert city;
        triggerCheck.setVariable(true);
        
        Ward_Master__c ward = new Ward_Master__c();
        ward.City__c = city.id;
        ward.Name = 'West';
        //ward.Ward_Code__c = '1';
        insert ward;
        triggerCheck.setVariable(true);
        
        Account account = new Account();
        account.Name = 'Shreeram School';
        //account.School_Code__c = '1';
        account.State__c = state.id;
        account.Ward__c = ward.id;
        account.City__c = city.id;
        account.District__c = dm.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId = RecordTypeIdAccount;
        insert account;
        triggerCheck.setVariable(true);
        
        batch.School_Name__c = account.id;
        
        Account account1 = new Account();
        account1.Name = 'VPM Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId = RecordTypeIdAccount1;
        account1.Number_of_batches_funded__c=100;
        account1.Number_of_batches_allocated__c=50;
        account1.Number_of_batches_pending__c=1.0;
        insert account1;
        triggerCheck.setVariable(true);
        
        batch.Donor_Name__c = account1.id;
        batch.Name = 'Batch Test';
        insert batch;
        Batch__c batchData=[select name,Batch_Number__c from Batch__c];
        System.assert(batchData.Batch_Number__c != null);
    } 
    
    public static testMethod void test1() {
        TriggerCheck triggerCheck=new TriggerCheck();
        Batch__c batch = new Batch__c();
        batch.Preferred_Language__c='Hindi';
        State_Govt_Body_Level__c state = new State_Govt_Body_Level__c();
        state.Name = 'SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai (City & Suburban)';
        sm.Name = 'Mum Grade 9 S1';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
        
        District_Master__c distict = new District_Master__c();
        distict.State__c = state.id;
        distict.Name = 'Mumbai (City & Suburban)';
        insert distict;
        triggerCheck.setVariable(true);
        
        City_Master__c city = new City_Master__c();
        city.District__c = distict.id;
        city.Name = 'Kalyan'; 
       // city.City_Code__c = '2';
        insert city;
        triggerCheck.setVariable(true);
        
        Ward_Master__c ward = new Ward_Master__c();
        ward.City__c = city.id;
        ward.Name = 'West';
      //  ward.Ward_Code__c = '1';
        insert ward;
        triggerCheck.setVariable(true);
        
        Account account = new Account();
        account.Name = 'Shreeram School';
      //  account.School_Code__c = '1';
        account.State__c = state.id;
        account.Ward__c = ward.id;
        account.City__c = city.id;
        account.District__c = distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId = RecordTypeIdAccount;
        insert account;
        triggerCheck.setVariable(true);
        
        batch.School_Name__c = account.id;
        
        Account account1 = new Account();
        account1.Name = 'VPM Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId = RecordTypeIdAccount1;
        account1.Number_of_batches_funded__c=100;
        account1.Number_of_batches_allocated__c=50;
        account1.Number_of_batches_pending__c=1.0;
        insert account1;
        triggerCheck.setVariable(true);
        
        batch.Donor_Name__c = account1.id;
        batch.Name = 'Batch Test';
        insert batch;
      
        batch.Name = 'Batch Test';
        
        Account account3 = new Account();
        account3.Name = 'Web School';
        //account3.School_Code__c = '2';
        account3.State__c = state.id;
        account3.Ward__c = ward.id;
        account3.City__c = city.id;
        account3.District__c = distict.id;
        Id RecordTypeIdAccount3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account3.RecordTypeId = RecordTypeIdAccount3;
        insert account3;
        
        triggerCheck.setVariable(true);
        
        batch.School_Name__c = account3.id;
   
        update batch;
        
        Batch__c batchData=[select name,School_Name__c from Batch__c];
        System.assert(batchData.School_Name__c == account3.id);
    } 
    
     public static testMethod void test2() {
        TriggerCheck triggerCheck=new TriggerCheck();
        Batch__c batch = new Batch__c();
        batch.Preferred_Language__c='Hindi';
        State_Govt_Body_Level__c state = new State_Govt_Body_Level__c();
        state.Name = 'SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai (City & Suburban)';
        sm.Name = 'Mum Grade 9 S1';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm; 
        
        District_Master__c distict = new District_Master__c();
        distict.State__c = state.id;
        distict.Name = 'Mumbai (City & Suburban)';
        insert distict;
        triggerCheck.setVariable(true);
        
        City_Master__c city = new City_Master__c();
        city.District__c = distict.id;
        city.Name = 'Kalyan'; 
       // city.City_Code__c = '2';
        insert city;
        triggerCheck.setVariable(true);
        
        Ward_Master__c ward = new Ward_Master__c();
        ward.City__c = city.id;
        ward.Name = 'West';
      //  ward.Ward_Code__c = '1';
        insert ward;
        triggerCheck.setVariable(true);
        
        Account account = new Account();
        account.Name = 'Shreeram School';
        //account.School_Code__c = '1';
        account.State__c = state.id;
        account.Ward__c = ward.id;
        account.City__c = city.id;
        account.District__c = distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId = RecordTypeIdAccount;
        insert account;
        triggerCheck.setVariable(true);
        
        batch.School_Name__c = account.id;
        
        Account account1 = new Account();
        account1.Name = 'VPM Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId = RecordTypeIdAccount1;
        account1.Number_of_batches_funded__c=100;
        account1.Number_of_batches_allocated__c=50;
        account1.Number_of_batches_pending__c=1.0;
        insert account1;
        triggerCheck.setVariable(true);
        
        batch.Donor_Name__c = account1.id;
        batch.Name = 'Batch Test';
        insert batch;
         
        Account account2 = new Account();
        account2.Name = 'BPM Donor2';
        Id RecordTypeIdAccount2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account2.RecordTypeId = RecordTypeIdAccount2;account1.Number_of_batches_funded__c=100;
        account2.Number_of_batches_allocated__c=50;
        account2.Number_of_batches_pending__c=1.0;
        insert account2;
        triggerCheck.setVariable(true);
        
        batch.Donor_Name__c = account2.id;
        update batch;
         
        Batch__c batchData=[select name,Donor_Name__c from Batch__c];
        System.assert(batchData.Donor_Name__c == account2.id);
         
         
         
    } 
    
    @istest
    public static void testSessionNumberInsert(){
        
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai (City & Suburban)';
        sm.Name = 'Mum Grade 9 S1';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Mumbai (City & Suburban)';
        insert distict;
        
        City_Master__c city =new City_Master__c();
        city.District__c=distict.id;
        city.Name='Mumbai'; 
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
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        account.Medium_Language_of_Instruction__c = 'English';
        account.School_Location__c = 'Test Principal address';
        account.Principal_Name__c = 'Test Principal';
        insert account;
        
        Contact contact=new Contact();
        contact.FirstName='Test';
        contact.LastName='LName';
        contact.Email = 'test@gmail.com';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        contact.Language__c='English;Hindi';
        contact.Cities_of_Operation__c = 'Thane';
        contact.Trainer_Status__c = 'morning';
        insert contact;
        
        Batch__c batch1 = new Batch__c();
        batch1.Name = 'batch 1';
        batch1.Trainer_Name__c = contact.Id;
        batch1.School_Name__c=account.id;
        batch1.Preferred_Language__c = 'Hindi';
        batch1.Medium_Language_of_Instruction__c = 'English';
        insert batch1;
        
        session__c session = new session__c();
        session.Name = 'test';
        session.Batch__c = batch1.id;
        session.Assigned_facilitator__c = contact.Id;
        session.SessionDate__c = date.valueOf('2020-03-26');
        
        insert session;
        
        
       
        
        
        test.startTest();
        
        
        delete batch1;
        test.stopTest();
        
        contact c = [select id,Number_Of_Sessions__c from contact where id=: contact.Id];
        
        system.assertEquals(0, c.Number_Of_Sessions__c);
    }
    
    @istest
    public static void testCombineNumber(){
        
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai (City & Suburban)';
        sm.Name = 'Mum Grade 9 S1';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Mumbai (City & Suburban)';
        insert distict;
        
        City_Master__c city =new City_Master__c();
        city.District__c=distict.id;
        city.Name='Mumbai'; 
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
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        account.Medium_Language_of_Instruction__c = 'English';
        account.School_Location__c = 'Test Principal address';
        account.Principal_Name__c = 'Test Principal';
        insert account;
        
        Contact contact=new Contact();
        contact.FirstName='Test';
        contact.LastName='LName';
        contact.Email = 'test@gmail.com';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        contact.Language__c='English;Hindi';
        contact.Cities_of_Operation__c = 'Thane';
        contact.Trainer_Status__c = 'morning';
        insert contact;
        
        Batch__c batch1 = new Batch__c();
        batch1.Name = 'batch 1';
        batch1.Trainer_Name__c = contact.Id;
        batch1.School_Name__c=account.id;
        batch1.Preferred_Language__c = 'Hindi';
        batch1.Medium_Language_of_Instruction__c = 'English';
        insert batch1;
        
        session__c session = new session__c();
        session.Name = 'test';
        session.Batch__c = batch1.id;
        session.Assigned_facilitator__c = contact.Id;
        session.SessionDate__c = date.valueOf('2020-03-26');
        
        insert session;
        
        
        
        Batch__c batch = new Batch__c();
        batch.Name = 'batch 1';
        batch.Trainer_Name__c = contact.Id;
        batch.School_Name__c=account.id;
        batch.Preferred_Language__c = 'Hindi';
        batch.Medium_Language_of_Instruction__c = 'English';
        insert batch;
        
        session__c session1 = new session__c();
        session1.Name = 'test';
        session1.Batch__c = batch.id;
        session1.Assigned_facilitator__c = contact.Id;
        session1.SessionDate__c = date.valueOf('2020-03-26');
        
        insert session1;
        
        
        
        
        test.startTest();
        
        Batch__C Onebatch = [select id,Combined_Batch_no__c,Batch_Number_edit__c,Combined_Batch_no_for_G10__c from Batch__c where id =: batch.Id];
        
        batch1.Combined_Batch_no__c = decimal.valueOf(Onebatch.Batch_Number_edit__c);
        batch1.Combined_Batch_no_for_G10__c = Onebatch.Batch_Number_edit__c;
        batch1.Number_of_students_facilitated__c = 1;
        update batch1;
        
        
        test.stopTest();
        
    }
}