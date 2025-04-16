@isTest
public class OMRObjectsDuplicateAssesmentBatchTest {

    @isTest
    public static void testBatch(){
        
        Account account=new Account();
        account.Name='Shreeram School';
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId();
        account.RecordTypeId=RecordTypeIdAccount;
        insert account;
        
        Contact demoCont = new Contact(LastName= 'Test Student', Bar_Code__c = '21036498', AccountId = account.Id);
        insert demoCont;
        
        List<OMR_Assessment__c> omrList = New List<OMR_Assessment__c>{
            New OMR_Assessment__c(Student__c = demoCont.Id, Barcode__c = '2303649890', Error_Status__c = '', Data_Clean_up__c = false, Academic_Year__c = 21, Grade__c = ''),
            New OMR_Assessment__c(Student__c = demoCont.Id, Barcode__c = '2303649890', Error_Status__c = '', Data_Clean_up__c = false, Academic_Year__c = 21, Grade__c = ''),
            New OMR_Assessment__c(Student__c = demoCont.Id, Barcode__c = '2303649890', Error_Status__c = '', Data_Clean_up__c = false, Academic_Year__c = 21, Grade__c = ''),
            New OMR_Assessment__c(Student__c = demoCont.Id, Barcode__c = '2303649890', Error_Status__c = '', Data_Clean_up__c = false, Academic_Year__c = 21, Grade__c = ''),
            New OMR_Assessment__c(Student__c = demoCont.Id, Barcode__c = '2303649890', Error_Status__c = '', Data_Clean_up__c = false, Academic_Year__c = 21, Grade__c = '')
        };
        Insert omrList;
      
        OMRObjectsDuplicateAssesmentScheduler scheduler = new OMRObjectsDuplicateAssesmentScheduler('OMR_Assessment__c');
        String cronExpression = '0 0 0 1 1 ?'; // Run immediately
        System.schedule('My Scheduler', cronExpression, scheduler);
        
        OMRObjectsDuplicateAssesmentBatch obj = new OMRObjectsDuplicateAssesmentBatch('OMR_Assessment__c');
        Database.executeBatch(obj);    

    }
}