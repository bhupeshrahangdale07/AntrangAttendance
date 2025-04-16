/*
    Description: Test class for ContactMassUpdateController
*/
@isTest
public with sharing class ContactMassUpdateControllerTest {
    
    static testmethod void MastUpdateTest(){
        
        Batch__c batch = new Batch__c();
        
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Pune';
        sm.Name = 'Pune Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 12';
        sm.Description__c = 'description';
        insert sm;
        
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

        Account account = new Account();
        account.Name='Shreeram School';
        account.State__c = state.id;
        account.Ward__c = ward.id;
        account.City__c = city.id;
        account.District__c = distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId = RecordTypeIdAccount;
        insert account;
        
        batch.School_Name__c = account.id;
        batch.Preferred_Language__c = 'Hindi';
        
        Account account1 = new Account();
        account1.Name = 'Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId = RecordTypeIdAccount1;
        account1.Number_of_batches_pending__c = 1.0;
        account1.Number_of_batches_allocated__c = 2.0;
        account1.Number_of_batches_funded__c = 1.0;
        insert account1;
        
        Contact contact=new Contact();
        contact.FirstName='Test12';
        contact.LastName='LN';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        insert contact;
        
        batch.Trainer_Name__c = contact.id;
        batch.Donor_Name__c = account1.id;
        batch.Name = 'Batch 7';
        batch.Grade__c = 'Grade 12';
        batch.Number_of_students_facilitated__c = 1.0;
        insert batch;
        
        Contact contact1=new Contact();
        contact1.FirstName='Test123';
        contact1.LastName='LN12';
        Id RecordTypeIdStudent = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        contact1.RecordTypeId=RecordTypeIdStudent;
        contact1.Batch_Code__c=batch.id;
        contact1.Current_Aspiration__c='SELF EMPLOYED';
        contact1.Age__c=25;
        contact1.Interest_1__c='Social';
        contact1.Interest_2__c='Enterprising';
        contact1.Aptitude_1__c='Verbal';
        contact1.Aptitude_2__c='Mechanical';
        contact1.Personality_1__c='Extrovert';
        contact1.Personality_2__c='Extrovert';
        contact1.Personality_3__c='Practical';
        contact1.Personality_4__c='Practical';
        contact1.Personality_5__c='Thoughtful';
        contact1.Personality_6__c='Conservative';
        contact1.Personality_7__c='Talkative';
        contact1.Personality_8__c='Bold';
        contact1.Reality_1__c='No';
        contact1.Reality_2__c='No';
        contact1.Reality_3__c='No';
        contact1.Reality_4__c='No';
        contact1.Reality_5__c='No';
        contact1.Reality_6__c='No';
        contact1.Reality_7__c='No';
        contact1.Reality_8__c='No';
        /*contact1.Profession_1__c=iarp.id;
        contact1.Profession_1_Next_steps__c='To be a school teacher - Students must complete 12th grade in any stream';
        contact1.Profession_1_Recommendation__c='Teacher';
        contact1.Profession_2__c=iarp1.id;
        contact1.Profession_2_Next_steps__c='';*/
        contact1.Profession_2_Recommendation__c='Fitness Instructor';
        contact1.Batch_Code__c=batch.id;//contact1.Recommedation_Status__c='Processed';
        insert contact1;
        
        ContactMassUpdateController controller = new ContactMassUpdateController(new Apexpages.standardcontroller(batch));
        controller.Submit();

    }
}