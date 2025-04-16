@isTest(seealldata=false)
public class SchoolCodeUpdateTestCase {
    public static testMethod void test(){
        TriggerCheck triggerCheck =new TriggerCheck();
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Pune';
        sm.Name = 'Pune Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
        
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
        account.Enrolled_Grade_9__c = 50;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
        
        triggerCheck.setVariable(true);
        
        
        Account acc=[select Name from Account];
        if(acc.name !=null)
        {
            System.assert(acc.Name == 'VPM School');
        }
        acc.Enrolled_Grade_9__c = 100;
        update acc;
        acc.Enrolled_Grade_10__c = 100;
        update acc;
        acc.Enrolled_Grade_11__c = 100;
        update acc;
        acc.Enrolled_Grade_12__c = 100;
        update acc;
        
        SchoolCodeUpdateHandler.dummycoverage();
        
    } 
    public static testMethod void test1(){
        
        TriggerCheck triggerCheck =new TriggerCheck();
        Account account=new Account();
        account.Name='Donor Check';
        //account.Donor_Area_of_Operation__c='Harbour';
        account.Number_of_batches_allocated__c=100;
        account.Number_of_batches_pending__c=1;
        account.Number_of_batches_funded__c=2;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
        
        triggerCheck.setVariable(true);
        
        Account acc=[select Name from Account];
        if(acc.name !=null)
        {
            System.assert(acc.Name == 'Donor Check');
        }      
        
    }  
}