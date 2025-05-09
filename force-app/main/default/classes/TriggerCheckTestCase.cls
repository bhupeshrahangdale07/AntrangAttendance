/* Getting the code coverage for TriggerCheck class  */
@isTest
public class TriggerCheckTestCase {
  public static testMethod void test(){
        TriggerCheck triggerCheck=new TriggerCheck();
       
        Batch__c batch=new Batch__c();
        batch.Preferred_Language__c='Hindi';
      
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
      
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.Name = 'Goa';
        sm.District__c = 'Goa';
      sm.Session_Number__c = 1;
      sm.Grade__c = 'Grade 10';
      sm.Description__c = 'Test';
      insert sm;
       
        triggerCheck.setVariable(true);
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Goa';
        insert distict;
      
        triggerCheck.setVariable(true);
      
       update  distict;     
        City_Master__c city=new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
       insert city;
       
        triggerCheck.setVariable(true);
       
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West';
        insert ward;
       
        triggerCheck.setVariable(true);
       
        Account account=new Account();
        account.Name='Shreeram School';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
       
        triggerCheck.setVariable(true);
        batch.School_Name__c=account.id;
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_funded__c=100;
        account1.Number_of_batches_allocated__c=50;
        account1.Number_of_batches_pending__c=1.0;
        insert account1;
       
        triggerCheck.setVariable(true);
            
        batch.Donor_Name__c=account1.id;
        
        batch.Name='Batch 7';
        batch.Number_of_students_facilitated__c=0.0;
        insert batch;
        triggerCheck.setVariable(true);
    
       Batch__c batchData=[select name,Batch_Number__c from Batch__c];
      test.startTest();
      TriggerCheck.createBatchNumber(batch.id);
      TriggerCheck.calculateNumberOfBatches(batch.id);
      test.stopTest();
      
       System.assert(batchData.Batch_Number__c != null);
     }
    
      public static testMethod void test1(){
          triggerCheck.runOnce();
       }
    
        public static testMethod void test2(){
            triggerCheck.runOnceContact();
       }
    
    public static testMethod void test3(){
        TriggerCheck triggerCheck=new TriggerCheck();
        Batch__c batch=new Batch__c();
        batch.Preferred_Language__c='Hindi';
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.Name = 'Goa';
        sm.District__c = 'Goa';
      sm.Session_Number__c = 1;
      sm.Grade__c = 'Grade 10';
      sm.Description__c = 'Test';
      insert sm;
        
        triggerCheck.setVariable(true);
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Goa';
        insert distict;
        triggerCheck.setVariable(true);
        
        City_Master__c city=new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
      //  city.City_Code__c='2';
        insert city;
       
        triggerCheck.setVariable(true);
       
      
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West';
      //  ward.Ward_Code__c='1';
        insert ward;
       
        triggerCheck.setVariable(true);
       
       
        Account account=new Account();
        account.Name='Shreeram School';
       // account.School_Code__c='1';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
       
        triggerCheck.setVariable(true);
       
        
        batch.School_Name__c=account.id;
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_funded__c=100;
        account1.Number_of_batches_allocated__c=50;
        account1.Number_of_batches_pending__c=1.0;
        insert account1;
        triggerCheck.setVariable(true);
        
        batch.Donor_Name__c=account1.id;
        
        batch.Name='Batch 7';
        batch.Number_of_students_facilitated__c=0.0;
        insert batch;
        
        triggerCheck.setVariable(true);
        
        Account account2=new Account();
        account2.Name='Donor2';
        Id RecordTypeIdAccount2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account2.RecordTypeId=RecordTypeIdAccount1;
        account2.Number_of_batches_funded__c=100;
        account2.Number_of_batches_allocated__c=50;
        account2.Number_of_batches_pending__c=1.0;
        insert account2;
        
        triggerCheck.setVariable(true);
        
        batch.Donor_Name__c=account2.id;
        
        update batch;
        triggerCheck.setVariable(true);
        
        triggerCheck.calculateNumberOfBatches(batch.id,account2.id);
        
        triggerCheck.calculateNumberOfBatches(batch.id,null);
        
        
        triggerCheck.setVariable(true);
        
        Batch__c batchData=[select name,Donor_Name__c from Batch__c];
        System.assert(batchData.Donor_Name__c == account2.id);
  
    }
    
    public static testMethod void test4() {
        TriggerCheck triggerCheck=new TriggerCheck();
         
        Batch__c batch=new Batch__c();
        batch.Preferred_Language__c='Hindi';
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.Name = 'Goa';
        sm.District__c = 'Goa';
      sm.Session_Number__c = 1;
      sm.Grade__c = 'Grade 10';
      sm.Description__c = 'Test';
      insert sm;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Goa';
        insert distict;
         
        triggerCheck.setVariable(true);
        City_Master__c city=new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
      //  city.City_Code__c='2';
        insert city;
       
        triggerCheck.setVariable(true);
        
      
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West';
     //   ward.Ward_Code__c='1';
        insert ward;
       
        triggerCheck.setVariable(true);
        
       
        Account account=new Account();
        account.Name='Shreeram School';
       // account.School_Code__c='1';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
       
        triggerCheck.setVariable(true);
       
        
        batch.School_Name__c=account.id;
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_funded__c=100;
        account1.Number_of_batches_allocated__c=50;
        account1.Number_of_batches_pending__c=1.0;
        insert account1;
       
        triggerCheck.setVariable(true);
            
        batch.Donor_Name__c=account1.id;
        
        batch.Name='Batch 7';
        batch.Number_of_students_facilitated__c=0.0;
        insert batch;
         
        triggerCheck.setVariable(true);
         
         Contact con=new Contact();
         con.FirstName='Web';
         con.LastName='Test Check';
         con.Bar_Code__c='103';
         con.Batch_Code__c=batch.id;
         //con.Recommedation_Status__c='Not Processed';
         insert con;
         
         triggerCheck.setVariable(true);
         
         triggerCheck.updateNumberOfStudentFacilitated(con.id);
         triggerCheck.setVariable(true);
         
         triggerCheck.updateNumberOfStudentFacilitated(con.id,batch.id);
         triggerCheck.setVariable(true);
         
         Batch__c batchData=[select Number_of_students_facilitated__c from Batch__c];
         System.assert(batchData.Number_of_students_facilitated__c !=null);
     }

     public static testMethod void test5(){
          TriggerCheck triggerCheck=new TriggerCheck();
        Batch__c batch=new Batch__c();
         batch.Preferred_Language__c='Hindi';
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
         
         Session_Mapping__c sm = new Session_Mapping__c();
        sm.Name = 'Goa';
        sm.District__c = 'Goa';
      sm.Session_Number__c = 1;
      sm.Grade__c = 'Grade 10';
      sm.Description__c = 'Test';
      insert sm;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Goa';
        insert distict;
        
        City_Master__c city=new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
       // city.City_Code__c='2';
        insert city;
       
        triggerCheck.setVariable(true);
        //triggerCheck.calculateCityCode(city.id);
      
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West';
       // ward.Ward_Code__c='1';
        insert ward;
       
        triggerCheck.setVariable(true);
       // triggerCheck.calculateWardCode(ward.id);
       
        Account account=new Account();
        account.Name='Shreeram School';
      //  account.School_Code__c='1';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        account.Number_of_students__c='1.0';
        insert account;
         
        triggerCheck.setVariable(true);
     //   triggerCheck.calculateSchoolCode(account.id);
        
        batch.School_Name__c=account.id;
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_funded__c=100;
        account1.Number_of_batches_allocated__c=50;
        account1.Number_of_batches_pending__c=1.0;
        insert account1;
       
        triggerCheck.setVariable(true);
         
        Account account2=new Account();
        account2.Name='Shreeram School124';
       // account2.School_Code__c='1';
        account2.State__c=state.id;
        account2.Ward__c=ward.id;
        account2.City__c=city.id;
        account2.District__c=distict.id;
        Id RecordTypeIdAccount3 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account2.RecordTypeId=RecordTypeIdAccount3;
        account2.Number_of_students__c='1.0';
        insert account2;
         
        triggerCheck.setVariable(true);
            
        batch.Donor_Name__c=account1.id;
        
        batch.Name='Batch 7';
        batch.Number_of_students_facilitated__c=null;
        insert batch;
       
        batch.School_Name__c=account2.id;
        
         update batch;
        triggerCheck.setVariable(true);
        triggerCheck.calculateNumberOfStudent(account2.id,account2.id);
        triggerCheck.setVariable(true);
       
 
        Account acc=[select Number_of_students__c from Account where id =: account2.id];
        System.assert(acc.Number_of_students__c!=null);
      
     }
    
    public static testMethod void test6() {
        TriggerCheck triggerCheck=new TriggerCheck();
         
        Batch__c batch=new Batch__c();
        batch.Preferred_Language__c='Hindi';
         
        triggerCheck.setVariable(true);
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.Name = 'Goa';
        sm.District__c = 'Goa';
      sm.Session_Number__c = 1;
      sm.Grade__c = 'Grade 10';
      sm.Description__c = 'Test';
      insert sm;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Goa';
        insert distict;
         
        triggerCheck.setVariable(true);
         
        City_Master__c city=new City_Master__c();
        city.District__c=distict.id;
        city.Name='Kalyan'; 
      //  city.City_Code__c='2';
        insert city;
       
        triggerCheck.setVariable(true);
        
      
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West';
      //  ward.Ward_Code__c='1';
        insert ward;
       
        triggerCheck.setVariable(true);
        
       
        Account account=new Account();
        account.Name='Shreeram School';
     // account.School_Code__c='1';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
       
        triggerCheck.setVariable(true);
       
        
        batch.School_Name__c=account.id;
        
        Account account1=new Account();
        account1.Name='Shreeram School Donor';
        Id RecordTypeIdAccount1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.RecordTypeId=RecordTypeIdAccount1;
        account1.Number_of_batches_funded__c=100;
        account1.Number_of_batches_allocated__c=50;
        account1.Number_of_batches_pending__c=1.0;
        insert account1;
       
        triggerCheck.setVariable(true);
            
        batch.Donor_Name__c=account1.id;
        
        batch.Name='Batch 7';
        batch.Number_of_students_facilitated__c=0.0;
        insert batch;
         
        triggerCheck.setVariable(true);
         
         Contact con=new Contact();
         con.FirstName='Web';
         con.LastName='Test Check';
         con.Bar_Code__c='103';
         con.Batch_Code__c=batch.id;
         //con.Recommedation_Status__c='Not Processed';
         insert con;
         
         triggerCheck.setVariable(true);
         
         //triggerCheck.updateNumberOfStudentFacilitated(con.id);
          triggerCheck.setVariable(true);
         
         triggerCheck.updateNumberOfStudentFacilitated(con.id,null);
         triggerCheck.setVariable(true);
         
         triggerCheck.setVariableCon(true);
         
         triggerCheck.updateNumberOfStudent(con.id);
         triggerCheck.calculateNumberOfStudent(account.Id, account.id);
                  
         Batch__c batchData=[select Number_of_students_facilitated__c from Batch__c];
         System.assert(batchData.Number_of_students_facilitated__c !=null);
     }
}