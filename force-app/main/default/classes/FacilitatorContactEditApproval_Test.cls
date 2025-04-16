@isTest
public class FacilitatorContactEditApproval_Test{

    @isTest
    static void test1(){
        Account account1=new Account();
         account1.Name='Shreeram School Donor';
         Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
         account1.RecordTypeId=RecordTypeIdAccount1;
         account1.Number_of_batches_pending__c=1.0;
         account1.Number_of_batches_allocated__c=2.0;
         account1.Number_of_batches_funded__c=1.0;
         insert account1;
        
        Batch__c batch = new Batch__c();
        
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
        account.Principal_Contact_2__c = '12345678';
        account.Principal_Contact_3__c = '12345678';
        insert account;
        
        batch.School_Name__c=account.id;
        batch.Preferred_Language__c='Hindi';
        
        batch.Name='Batch 7';
        batch.Grade__c='Grade 9';
        batch.Number_of_students_facilitated__c=1.0;
        //Preferred_Language__c, School_Name__c
        batch.Academic_Year__c = AntarangSetting__c.getOrgDefaults().Academic_Year__c;
        insert batch;
        
        
        Contact contact=new Contact();
        contact.FirstName='Kurund12';
        contact.LastName='Jalmi';
        contact.Bar_Code__c = '210000001';
        contact.Batch_Code__c = batch.Id;
        contact.npe01__WorkEmail__c  = 'test@antarangfoundation.org';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
         contact.RecordTypeId=RecordTypeIdContact;//contact.Recommedation_Status__c='Not Processed';
        // contact.Batch_Code__c=batch.id;
         contact.Grade_9_Barcode__c = '210000001';
        contact.Birthdate = system.today().addDays(-1000);
         insert contact;
        
        Test.StartTest();
        
        FacilitatorContactEditApprovalController.fetchContact('210000001','test@antarangfoundation.org');
        FacilitatorContactEditApprovalController.checkEmailExist('test@antarangfoundation.org');
        
        FacilitatorContactEditApprovalController.formWrap formData = new FacilitatorContactEditApprovalController.formWrap();
        formData.Id = contact.Id;
        formData.FirstName = 'test';
        formData.Current_Grade = 9;
        formData.SubmitterEmail = 'test@antarangfoundation.org';
        
        FacilitatorContactEditApprovalController.createTempContact(formData, 'test@antarangfoundation.org');
        
        String Emails = System.Label.Student_Update_Approver;
        List<String> sendingToEmailAdd = new List<String>();
        if(String.isNotBlank(Emails)){
            sendingToEmailAdd = Emails.split(';');
        }
        for(String s:sendingToEmailAdd){
            FacilitatorContactEditApprovalController.checkApproverEmailExist(s);
        }
        
         List<FacilitatorContactEditApprovalController.approverWrap> aw = new List<FacilitatorContactEditApprovalController.approverWrap>();
        
        Object a = FacilitatorContactEditApprovalController.pendingRecords();
        Map<String, Object> result = new Map<String, Object>();
        result = (Map<String, Object>)a;
        system.debug('test : '+result);
        system.debug('test 1 : '+result.get('data') );
        aw = (List<FacilitatorContactEditApprovalController.approverWrap>)result.get('data');
        
        for(FacilitatorContactEditApprovalController.approverWrap app:aw){
            //FacilitatorContactEditApprovalController.mergeContact(JSON.serializePretty(app.clonedContact), 'Rejected', 'reasonreasonreasonreasonreasonreasonreasonreason');
        }
        
       CA_Stud_Temp__c CAtempCon = [Select Name, Current_Grade__c, UID__c, SubmitterEmail__c, Contact__r.Name, Contact__c, Gender__c, Birthdate__c, MobilePhone__c, Currently_Studying_In__c, LastName__c, FirstName__c,
                                                                              Batch_Code__r.Batch_Number__c, Batch_Code__r.Academic_Year__c,G9_Alternate_Mobile_No__c, G9_Whatsapp_Number__c,
                                                                              G10_Batch_Code__r.Batch_Number__c, G11_Batch_Code__r.Batch_Number__c, G10_Batch_Code__r.Academic_Year__c,
                                                                              G10_Alternate_Mobile_No__c, G10_Whatsapp_Number__c,  G11_Batch_Code__r.Academic_Year__c, G11_Alternate_Mobile_No__c,
                                                                              G11_Whatsapp_Number__c  From CA_Stud_Temp__c limit 1 ];
        
        
        FacilitatorContactEditApprovalController.sendApprovedEmail(CAtempCon);
        FacilitatorContactEditApprovalController.sendRejectedEmail(CAtempCon,'ehhd');
        
        CAtempCon.Current_Grade__c = 10;
        update CAtempCon;
        FacilitatorContactEditApprovalController.sendEmail(CAtempCon.Id, 'test@antarangfoundation.org');
        
        CAtempCon.Current_Grade__c = 11;
        update CAtempCon;
        FacilitatorContactEditApprovalController.sendEmail(CAtempCon.Id, 'test@antarangfoundation.org');
        
        Test.StopTest();
    }
}