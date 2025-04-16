@isTest
public class BatchAllocationEmailToFacilitatorTest {
    /*
    @isTest
    public static void testsendemailtotrainer(){
        Batch__c batch=new Batch__c();
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Pune';
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
        account.School_Location__c = 'Test Principal address';
        account.Principal_Name__c = 'Test Principal';
        account.Est_Number_of_Students_in_Grade_9_19_20__c = 20;
        account.Estimated_Number_Of_Students__c = 'test';
        account.Medium_Language_of_Instruction__c = 'Hindi';
        account.Principal_Contact_3__c = 'test';
        account.Approx_school_attendance_20_21__c = 23;
        insert account;
        
        
        batch.School_Name__c=account.id;
        batch.Preferred_Language__c='Hindi';
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_pending__c=1.0;
        account1.Number_of_batches_allocated__c=2.0;
        account1.Number_of_batches_funded__c=1.0;
        account1.Medium_Language_of_Instruction__c = 'Hindi';
        account.Principal_Contact_3__c = 'test';
        account.Approx_school_attendance_20_21__c = 23;
        insert account1;
        
        Contact contact=new Contact();
        contact.FirstName='Test';
        contact.LastName='LName';
        contact.Email = 'test@gmail.com';
        contact.npe01__WorkEmail__c = 'test@gmail.com'; 
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        insert contact;
        
        batch.Trainer_Name__c=contact.id;
        
        batch.Donor_Name__c=account1.id;
        batch.Name='Batch 7';
        batch.Grade__c='Grade 9';
        batch.Number_of_students_facilitated__c=1.0;
        batch.Medium_Language_of_Instruction__c = 'Hindi';
        batch.Date_of_facilitation_starting__c = datetime.now() - 3;
        batch.Date_of_facilitation_completion__c = datetime.now();
        batch.Combined_Batch_no__c = 23;
        insert batch;      
        
        Test.startTest();
        PageReference pageRef = Page.SendEmailToBatchTrainer;
        pageRef.getParameters().put('id', String.valueOf(batch.Id));
        Test.setCurrentPage(pageRef);
        
        PageReference MasspageRef = Page.SendMassEmailsToBatchTrainer;
        MasspageRef.getParameters().put('id', String.valueOf(batch.Id));
        Test.setCurrentPage(MasspageRef);
        
        SendEmailToBatchTrainerCtrl sendemail = new SendEmailToBatchTrainerCtrl(new ApexPages.StandardController(batch));
        sendemail.sendEmailToOneTrainer();
        Test.stopTest();
    }*/
    
    @isTest
    public static void testsendemailtotrainer2(){
        Batch__c batch=new Batch__c();
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Pune';
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
        account.Medium_Language_of_Instruction__c = 'Hindi';
        account.Phone = '13413431';
        account.Principal_Contact_2__c = 'test';
        account.Approx_school_attendance_20_21__c = 23;
        insert account;
        
        
        batch.School_Name__c=account.id;
        batch.Preferred_Language__c='Hindi';
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_pending__c=1.0;
        account1.Number_of_batches_allocated__c=2.0;
        account1.Number_of_batches_funded__c=1.0;
        account1.Medium_Language_of_Instruction__c = 'Hindi';
        account.Approx_school_attendance_20_21__c = 23;
        insert account1;
        
        Contact contact=new Contact();
        contact.FirstName='Test';
        contact.LastName='LName';
        contact.npe01__WorkEmail__c = 'test@gmail.com';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        insert contact;
        
        batch.Trainer_Name__c=contact.id;
        
        batch.Donor_Name__c=account1.id;
        batch.Name='Batch 7';
        batch.Grade__c='Grade 9';
        batch.Number_of_students_facilitated__c=1.0;
        batch.Combined_Batch_no__c = 23;
        insert batch;      
        
        Batch__c batch1 = new Batch__c();
        
        batch1.School_Name__c=account.id;
        batch1.Preferred_Language__c='Hindi';
        batch1.Trainer_Name__c=contact.id;
        
        batch1.Donor_Name__c = account1.id;
        batch1.Name='Batch 87';
        batch1.Grade__c='Grade 9';
        batch1.Number_of_students_facilitated__c=1.0;
        batch1.Combined_Batch_no__c = 23;
        insert batch1; 
        
        Test.startTest();
        PageReference pageRef = Page.BatchAllocationEmailToFacilitator;
        pageRef.getParameters().put('id', String.valueOf(contact.Id));
        Test.setCurrentPage(pageRef);
        
        BatchAllocationEmailToFacilitator ba = new BatchAllocationEmailToFacilitator(new ApexPages.StandardController(Contact));
        ba.ContactId = contact.Id;
        ba.sendBatchAllocationEmail();
        ba.backToContact();
        
        Test.stopTest();
    }
}