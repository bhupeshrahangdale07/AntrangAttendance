/* Getting the code coverage for DeleteStudentNumber trigger  */
@isTest(seealldata=false)
public class DeleteStudentNumberTestCalss {
   public static testMethod void test(){      
    
        TriggerCheck triggerCheck=new TriggerCheck();
        Account account=new Account();
        account.Name='Web Household';
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household Account').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
        triggerCheck.setVariable(true);
    
       
        Batch__c batch=new Batch__c();
        batch.Preferred_Language__c='Hindi';
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
        
        City_Master__c city=new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
       // city.City_Code__c='2';
        insert city;
       
        triggerCheck.setVariable(true);
       // triggerCheck.calculateCityCode(city.id);
      
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West';
       // ward.Ward_Code__c='1';
        insert ward;
       
        triggerCheck.setVariable(true);
        //triggerCheck.calculateWardCode(ward.id);
       
        Account account1=new Account();
        account1.Name='Shreeram School';
       // account1.School_Code__c='1';
        account1.State__c=state.id;
        account1.Ward__c=ward.id;
        account1.City__c=city.id;
        account1.District__c=distict.id;
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        insert account1;
       
        triggerCheck.setVariable(true);
        //triggerCheck.calculateSchoolCode(account.id);
        
        batch.School_Name__c=account1.id;
        
        Account account2=new Account();
        account2.Name='Shreeram School Donor';
        Id RecordTypeIdAccount2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account2.RecordTypeId=RecordTypeIdAccount2;
        account2.Number_of_batches_funded__c=100;
        account2.Number_of_batches_allocated__c=50;
        account2.Number_of_batches_pending__c=1.0;
        insert account2;
       
        triggerCheck.setVariable(true);
            
        batch.Donor_Name__c=account2.id;
        
        batch.Name='Batch 7';
        batch.Number_of_students_facilitated__c=0.0;
        insert batch;
    
        Contact con=new Contact();
        con.FirstName='Web';
        con.LastName='Check';
        con.AccountId=account.id;
        con.Batch_Code__c=batch.id;
        //con.Recommedation_Status__c='Not Processed';
        insert con;
       
        delete account;
    
        Account deletedAccount = [SELECT Id, IsDeleted FROM Account WHERE Id = :account.Id ALL ROWS];
        System.assert(deletedAccount.IsDeleted);
 }
}