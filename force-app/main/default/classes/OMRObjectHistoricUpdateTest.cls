@isTest
public class OMRObjectHistoricUpdateTest {
    
    @isTest
    public static void testBatch(){
        
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
        insert account;
        
        Contact demoCont = new Contact(LastName= 'Test Student', Bar_Code__c = '21036498', AccountId = account.Id);
        insert demoCont;
        
        List<OMR_Assessment__c> omrList = New List<OMR_Assessment__c>{
            New OMR_Assessment__c(Student__c = demoCont.Id, Barcode__c = '230364989', Error_Status__c = '', Data_Clean_up__c = false, Academic_Year__c = 21, Grade__c = ''),
            New OMR_Assessment__c(Student__c = demoCont.Id, Barcode__c = '220364981', Error_Status__c = '', Data_Clean_up__c = false, Academic_Year__c = 21, Grade__c = ''),
            New OMR_Assessment__c(Student__c = demoCont.Id, Barcode__c = '_10364982', Error_Status__c = '', Data_Clean_up__c = false, Academic_Year__c = 21, Grade__c = ''),
            New OMR_Assessment__c(Student__c = demoCont.Id, Barcode__c = 'a10364983', Error_Status__c = '', Data_Clean_up__c = false, Academic_Year__c = 21, Grade__c = ''),
            New OMR_Assessment__c(Student__c = demoCont.Id, Barcode__c = '', Error_Status__c = '', Data_Clean_up__c = false, Academic_Year__c = 21, Grade__c = '')
        };
        Insert omrList;
        
        
        OMRObjectHistoricUpdateScheduler scheduler = new OMRObjectHistoricUpdateScheduler();
        String cronExpression = '0 0 0 1 1 ?'; // Run immediately
        System.schedule('My Scheduler', cronExpression, scheduler);
        
        OMRObjectHistoricUpdate obj = new OMRObjectHistoricUpdate('OMR_Assessment__c');
        Database.executeBatch(obj);    

    }
}