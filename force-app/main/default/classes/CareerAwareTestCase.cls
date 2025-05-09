/* Getting the code coverage for CareerAware Class  */
@isTest(seealldata=false)
public class CareerAwareTestCase {
     public static testMethod void test() {
         
        TriggerCheck triggerCheck=new TriggerCheck();
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
        //triggerCheck.calculateCityCode(city.id);
      
        Ward_Master__c ward=new Ward_Master__c();
        ward.City__c=city.id;
        ward.Name='West';
       // ward.Ward_Code__c='1';
        insert ward;
       
        triggerCheck.setVariable(true);
      //  triggerCheck.calculateWardCode(ward.id);
       
        Account account=new Account();
        account.Name='Shreeram School';
      //  account.School_Code__c='1';
        account.State__c=state.id;
        account.Ward__c=ward.id;
        account.City__c=city.id;
        account.District__c=distict.id;
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
       
        triggerCheck.setVariable(true);
       // triggerCheck.calculateSchoolCode(account.id);
        
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
         
         Contact contact=new Contact();
         contact.FirstName='Kurund';
         contact.LastName='Jalmi';
         contact.Import_Status__c='Import Completed';
         contact.Status__c='Not Processed';
         //contact.Recommedation_Status__c='Not Processed';
         contact.Batch_Code__c=batch.id;
         contact.Design__c='A;B;C;D;E';
         contact.Performance_Arts__c='B';
         contact.Media_Communication__c='C';
         contact.Beauty_Wellness__c='A';
         contact.Education__c='C';
         contact.Sports_Fitness__c='C';
         contact.Finance__c='C';
         contact.Hospitality_Tourism__c='A';
         contact.Medical__c='C';
         contact.Public_Services__c='C';
         contact.Enginnering_technologies__c='A';
         contact.Trades__c='C';
         contact.Enviomental_and_Biological_Sciences__c='C';
         insert contact;
         
         Question_Bank__c questionBank=new Question_Bank__c();
         questionBank.Category1__c='Design';
         questionBank.Category__c='A;B;C;D;E';
         insert questionBank;
         
         Question_Bank__c questionBank1=new Question_Bank__c();
         questionBank1.Category1__c='Performance Arts';
         questionBank1.Category__c='B';
         insert questionBank1;
         
         Question_Bank__c questionBank2=new Question_Bank__c();
         questionBank2.Category1__c='Media and communication';
         questionBank2.Category__c='C';
         insert questionBank2;
         
         Question_Bank__c questionBank3=new Question_Bank__c();
         questionBank3.Category1__c='Beauty and Wellness';
         questionBank3.Category__c='A';
         insert questionBank3;
         
         Question_Bank__c questionBank4=new Question_Bank__c();
         questionBank4.Category1__c='Education';
         questionBank4.Category__c='C';
         insert questionBank4;
         
         Question_Bank__c questionBank5=new Question_Bank__c();
         questionBank5.Category1__c='Sports and fitness';
         questionBank5.Category__c='C';
         insert questionBank5;
         
         Question_Bank__c questionBank6=new Question_Bank__c();
         questionBank6.Category1__c='Finance';
         questionBank6.Category__c='C';
         insert questionBank6;
         
         Question_Bank__c questionBank7=new Question_Bank__c();
         questionBank7.Category1__c='Hospitality';
         questionBank7.Category__c='A';
         insert questionBank7;
         
         Question_Bank__c questionBank8=new Question_Bank__c();
         questionBank8.Category1__c='Medical';
         questionBank8.Category__c='C';
         insert questionBank8;
         
         Question_Bank__c questionBank9=new Question_Bank__c();
         questionBank9.Category1__c='Public services';
         questionBank9.Category__c='C';
         insert questionBank9;
         
         Question_Bank__c questionBank10=new Question_Bank__c();
         questionBank10.Category1__c='Engineering';
         questionBank10.Category__c='A';
         insert questionBank10;
         
         Question_Bank__c questionBank11=new Question_Bank__c();
         questionBank11.Category1__c='Trades';
         questionBank11.Category__c='C';
         insert questionBank11;
         
         Question_Bank__c questionBank12=new Question_Bank__c();
         questionBank12.Category1__c='Environmental and biological';
         questionBank12.Category__c='C'; 
         insert questionBank12;
         
         CareerAware careerAware=new CareerAware();
         careerAware.getCareerData(contact);
         
        Contact conData=[select Career_Tracks__c from Contact];
        System.assert(conData.Career_Tracks__c != null);
        
         
     }
}