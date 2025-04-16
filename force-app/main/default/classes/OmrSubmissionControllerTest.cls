@isTest
public class OmrSubmissionControllerTest {
    
    @isTest
    public static void test1(){
        AntarangSetting__c settings = AntarangSetting__c.getOrgDefaults();
        settings.Academic_Year__c = 2021;
        settings.Next_Academic_Year__c = 2022;
        upsert settings custSettings__c.Id;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai';
        sm.Name = 'Mumbai Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'test';
        insert sm;
        
         State_Govt_Body_Level__c state = new State_Govt_Body_Level__c(Name = 'Test State');
        insert state;
        /*Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'TDistrict';
        sm.Name = 'TDistrict Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        insert sm;*/
        District_Master__c district =  new District_Master__c(Name = 'Mumbai', State__c = state.id, 
                                      Payout_Supervisor_Username__c = '',
                                      Payout_Supervisor_Password__c = '',
                                      Payout_Admin_Password__c = '',
                                      Payout_Admin_Username__c = '',
                                      OMR_Submitter_Username__c = 'test@tt.tt',
                                      OMR_Submitter_Password__c='ttet');
        insert district;
        
        Account account = new Account();
        account.Name = 'Shreeram School';
        account.District__c = district.id;
        account.State__c = state.Id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId = RecordTypeIdAccount;
        insert account;
        
        Account account1 = new Account();
        account1.Name = 'VPM Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId = RecordTypeIdAccount1;
        account1.Number_of_batches_funded__c=100;
        account1.Number_of_batches_allocated__c=50;
        account1.Number_of_batches_pending__c=1.0;
        insert account1;
        
        Contact contact=new Contact();
        contact.FirstName='Kurund12';
        contact.LastName='Jalmi';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;//contact.Recommedation_Status__c='Not Processed';
        // contact.Batch_Code__c=batch.id;
        insert contact;
        
        Batch__c batch = new Batch__c();
        batch.Preferred_Language__c='Hindi';
        batch.School_Name__c = account.id;
        batch.Donor_Name__c = account1.id;
        batch.Name = 'Batch Test';
        batch.Grade__c = 'Grade 12';
        batch.Trainer_Name__c = contact.Id;
        batch.Academic_Year__c = 2021;
        batch.Trainer_Name__c = contact.Id;
        insert batch;
        
        session__c session = new session__c();
        session.Name = 'test';
        session.Batch__c = batch.id;
        session.Assigned_facilitator__c = contact.Id;
        session.SessionDate__c = date.valueOf('2020-03-26');
        session.Session_Number__c = 1;
        session.OMR_required__c = true;
        insert session;
        
        Session_OMR_Type__c o = new Session_OMR_Type__c();
        o.Session__c = session.Id;
        insert o;
            
        OmrSubmissionController.fetchBatchRecords('Grade 12', account.Id, contact.Id);
        OmrSubmissionController.fetchOmrRecords(batch.id);
        OmrSubmissionController.saveRecords(new List<Session_OMR_Type__c>{o});
        
        OmrSubmissionController.fetchLookupData('', 'Batch__c', ' Academic_Year__c = #year# ', 'Trainer_Name__r.Name', 'Trainer_Name__c', 'Trainer_Name__c Id, Trainer_Name__r.name', ' group by Trainer_Name__c, Trainer_Name__r.name ', 'TDistrict');
    }
}