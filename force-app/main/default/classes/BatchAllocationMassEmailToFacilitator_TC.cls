@isTest
public class BatchAllocationMassEmailToFacilitator_TC {
    
    @isTest
    public static void testsendemailtotrainer()
    {
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
        insert account1;
        
        Contact contact=new Contact();
        contact.FirstName='Test';
        contact.LastName='LName';
        contact.Email = 'test@gmail.com';
        contact.npe01__WorkEmail__c = 'test@gmail.com';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        insert contact;
        
        Contact contact1=new Contact();
        contact1.FirstName='Test';
        contact1.LastName='LName';
        contact1.Email = 'test@gmail.com';
        Id RecordTypeIdContact1 = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact1.RecordTypeId=RecordTypeIdContact;
        insert contact1;
        
        Contact contact2=new Contact();
        contact2.FirstName='Test';
        contact2.LastName='LName';
        contact2.Email = 'test@gmail.com';
        contact2.Academic_Year__c = 2020;
        Id RecordTypeIdContact2 = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact2.RecordTypeId=RecordTypeIdContact;
        insert contact2;
        
        batch.Trainer_Name__c=contact.id;
        
        batch.Donor_Name__c=account1.id;
        batch.Name='Batch 7';
        batch.Grade__c='Grade 9';
        batch.Number_of_students_facilitated__c=1.0;
        batch.Preferred_Language__c = 'Hindi';
        batch.Date_of_facilitation_starting__c = datetime.now() - 3;
        batch.Date_of_facilitation_completion__c = datetime.now();
        insert batch;      
        
        List<contact> btcLST = new List<contact>();
        btcLST.add(contact);
        btcLST.add(contact1);
        btcLST.add(contact2);
        
        Test.startTest();
        PageReference pageRef = Page.BatchAllocationMassEmailToFacilitator;
        pageRef.getParameters().put('id', String.valueOf(contact.Id));
        Test.setCurrentPage(pageRef);
        
        PageReference MasspageRef = Page.BatchAllocationMassEmailToFacilitator;
        MasspageRef.getParameters().put('id', String.valueOf(contact.Id));
        Test.setCurrentPage(MasspageRef);
        
        ApexPages.StandardSetController sc = new ApexPages.standardSetController(btcLST);
        sc.setSelected(btcLST);
        
        BatchAllocationMassEmailToFacilitator masssendemail = new BatchAllocationMassEmailToFacilitator(sc);
        masssendemail.backToList();
        BatchAllocationMassEmailToFacilitator.validateBatches(Contact.Id,2022);
        masssendemail.sendMasssEmailToOneContacts();
        Test.stopTest();
    }
    /*
    @isTest
    public static void testsendemailtotrainer2()
    {
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
        insert account1;
        
        Contact contact=new Contact();
        contact.FirstName='Test';
        contact.LastName='LName';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        insert contact;
        
        batch.Trainer_Name__c=contact.id;
        
        batch.Donor_Name__c=account1.id;
        batch.Name='Batch 7';
        batch.Grade__c='Grade 9';
        batch.Number_of_students_facilitated__c=1.0;
        batch.Preferred_Language__c = 'Hindi';
        batch.Date_of_facilitation_starting__c = datetime.now() - 3;
        batch.Date_of_facilitation_completion__c = datetime.now();
        insert batch;      
        
        List<Batch__c> btcLST = new List<Batch__c>();
        btcLST.add(batch);
        
        Test.startTest();
        PageReference pageRef = Page.SendEmailToBatchTrainer;
        pageRef.getParameters().put('id', String.valueOf(batch.Id));
        Test.setCurrentPage(pageRef);
        
        PageReference MasspageRef = Page.SendMassEmailsToBatchTrainer;
        MasspageRef.getParameters().put('id', String.valueOf(batch.Id));
        Test.setCurrentPage(MasspageRef);
        
        ApexPages.StandardSetController sc = new ApexPages.standardSetController(btcLST);
        sc.setSelected(btcLST);
        
        SendMassEmailToBatchTrainerCtrl masssendemail = new SendMassEmailToBatchTrainerCtrl(sc);
        masssendemail.sendMasssEmailToOneTrainer();
        Test.stopTest();
    }*/

}