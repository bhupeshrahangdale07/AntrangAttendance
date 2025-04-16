@isTest
public class PayoutProcessController_Test {
	
    @isTest
    public static void test2(){
        User y = new User();
        y.id='0051m000004iZ2O';
        System.runAs(y) {
            system.debug(System.OrgLimits.getMap().get('SingleEmail').getlimit());
            system.debug(System.OrgLimits.getMap().get('SingleEmail').getValue());
        }
		AntarangSetting__c setting = new AntarangSetting__c(Academic_Year__c = 2023, Next_Academic_Year__c = 2024,Max_Batch_Size__c=2);
        insert setting;
        
        Batch__c batch=new Batch__c();
        Batch__c childBatch=new Batch__c();
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'TDistrict';
        sm.Name = 'TDistrict Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'test description';
        insert sm;
        
        District_Master__c distict = new District_Master__c(Name = 'TDistrict', State__c = state.id, 
                                                             Payout_Supervisor_Username__c = 'payout.supervisor@test.com',
                                                             Payout_Supervisor_Password__c = 'Password1',
                                                             Payout_Admin_Password__c = 'Password2',
                                                             Payout_Admin_Username__c = 'payout.admin@test.com');
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
        account.Principal_Contact_2__c = '12345678';
        account.Principal_Contact_3__c = '12345678';
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
        insert account1;
        
        Contact contact=new Contact();
        contact.FirstName='Test';
        contact.LastName='LName';
        contact.Email = 'test@gmail.com';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
        contact.RecordTypeId=RecordTypeIdContact;
        contact.npe01__WorkEmail__c = 'test@gmail.com';
        contact.Payment_Type__c = 'Session';
        contact.Fixed_Amount__c  = 3000;
        insert contact;       
                
        childBatch.School_Name__c=account.id;
        childBatch.Preferred_Language__c='Hindi';
        childBatch.Trainer_Name__c=contact.id;        
        childBatch.Donor_Name__c=account1.id;
        childBatch.Name='Batch 8';
        childBatch.Grade__c='Grade 9';
        childBatch.Number_of_students_facilitated__c=1.0;
        childBatch.Medium_Language_of_Instruction__c = 'Hindi';
        childBatch.Date_of_facilitation_starting__c = datetime.now() - 3;
        childBatch.Date_of_facilitation_completion__c = datetime.now();
        childBatch.Followup_1_Trainer_Name__c = contact.id;
        childBatch.Date_of_1st_Follow_up_session__c = system.today() + 2;
        insert childBatch;
        
        String b = [Select Id,Batch_Number__c From Batch__c Where Id =: childBatch.Id].Batch_Number__c;
        
        batch.Trainer_Name__c=contact.id;        
        batch.Donor_Name__c=account1.id;
        batch.Name='Batch 7';
        batch.Grade__c='Grade 9';
        batch.Number_of_students_facilitated__c=1.0;
        batch.Medium_Language_of_Instruction__c = 'Hindi';
        batch.Date_of_facilitation_starting__c = datetime.now() - 3;
        batch.Date_of_facilitation_completion__c = datetime.now();
        batch.Followup_1_Trainer_Name__c = contact.id;
        batch.Date_of_1st_Follow_up_session__c = system.today() + 2;
        batch.Combined_Batch_no_for_G10__c = b;
        batch.Dummy_Batch__c =  false;
        batch.Academic_Year__c = 2023;
        
        //batch.Academic_Year__c = AntarangSetting__c.getOrgDefaults().Academic_Year__c;
        insert batch;
        
        session__c session = new session__c();
        session.Name = 'test';
        session.Batch__c = batch.Id;
        session.Assigned_facilitator__c = contact.Id;
        session.SessionDate__c = date.today();
        session.Session_Grade__c = 'Grade 9';
        session.Payment_Status__c = 'Ready For Payment';
        session.SessionDate__c = date.today();
        session.Total_Student_Present__c=100;
        session.Total_Parent_Present__c=10;
        session.Total_Amount__c=3000;
        session.Session_Type__c = 'Student';
        insert session;
        
        Test.startTest();
        String accId = account.Id;
        String donorId = account1.Id;
        String batchId = Batch.Id;
       PayoutProcessController.getFacilitator(contact.Id);
        list<session__c> lst = [SELECT id, Name, Number_of_Sessions_No_of_Units__c, Session_Code__c, Copy_of_Session__c, Present_Count__c, Dummy_Session_Created__c,Session_Amount__c, Parent_Session_Code__c, SessionDate__c, Session_Grade__c, Attendance_Count__c, Dummy_Session__c, Total_Student_Present__c, Batch__r.Name, Batch__r.Batch_Number__c, Assigned_Facilitator__c, Deferred_Reason__c, Assigned_Facilitator__r.Name, Payment_Status__c FROM Session__c WHERE Payment_Status__c IN ('Ready For Payment', 'Deferred for Payment') AND SessionDate__c <=:system.today() AND Batch__r.Academic_Year__c = 2023 AND Batch__r.Dummy_Batch__c = false AND Assigned_Facilitator__r.Payment_Type__c = 'Session' AND Batch__r.School_Name__r.District__c = :distict.id];
        system.debug('sessionLst = '+lst);
        //Object a = PayoutProcessController.getSessions(system.today(),  PayoutProcessController.getFacilitator(contact.Id).Id , donorId, accId, batchId, 'Grade 9',distict.id);
       Object a = PayoutProcessController.getSessions(system.today(),  '' , '', '', '', '',distict.id);
       Map<String, Object> result = new Map<String, Object>();
        result = (Map<String, Object>)a;
        system.debug('test : '+result);
        system.debug('test 1 : '+result.get('sessionData') );
        List<PayoutProcessController.sessionWrapper> wrapList = new List<PayoutProcessController.sessionWrapper>();
        wrapList = (List<PayoutProcessController.sessionWrapper>)result.get('sessionData');
        
        PayoutProcessController.updateSessions(wrapList);
        PayoutProcessController.generateInvoiceAndSendEmail(wrapList, system.today(),distict.id);
        PayoutProcessController.sendInvoiceToFacilitator(system.today(), contact.npe01__WorkEmail__c);
        PayoutProcessController.sendInvoicetoFinance(system.today());
        GenericLookupController.fetchLookupData('', 'Batch__c', ' Academic_Year__c = #year# ', 'Trainer_Name__r.Name', 'Trainer_Name__c', 'Trainer_Name__c Id, Trainer_Name__r.name', ' group by Trainer_Name__c, Trainer_Name__r.name ', 'TDistrict');
        PayoutProcessController.getPicklistValues();
        Test.stopTest();
    }
}