@isTest(seealldata=false)
Private class FetchAllDataTestCase {
     @isTest static void test(){
         FetchAllData fetchData=new FetchAllData();
         Contact contact=new Contact();
         contact.FirstName='Kurund';
         contact.LastName='Jalmi';
         contact.Import_Status__c ='Import Completed';
         contact.Status__c ='Not Processed';
         insert contact;
         
        TriggerCheck triggerCheck =new TriggerCheck();
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
        triggerCheck.setVariable(true);
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Pune';
        insert distict;
        triggerCheck.setVariable(true);
     
        City_Master__c city =new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
        insert city;
        triggerCheck.setVariable(true);
     
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West Kalyan';
        insert ward;
        triggerCheck.setVariable(true);
     
        Account account=new Account();
        account.Name='VPM School';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
         
         List<Contact> con= fetchData.getAllData('Contact');
         System.assertEquals(con.size(), 1);
         
     }
}