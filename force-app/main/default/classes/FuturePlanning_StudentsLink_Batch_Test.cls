@isTest
public class FuturePlanning_StudentsLink_Batch_Test {
    @isTest
    public static void StudentUpdate(){
        Id RecTypeCA = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        List<Contact> contList = New List<Contact>{
            new Contact(LastName = 'Test Last Name 1', Grade_9_Barcode__c = '2154697730'),
                new Contact(LastName = 'Test Last Name 2', Grade_10_Barcode__c = '2154783310'),
                new Contact(LastName = 'Test Last Name 3', Grade_11_Barcode__c = '2148796330')
                };  
                    Insert contList;
        
        List<Future_Planning__c> OMRList = New List<Future_Planning__c>{
            new Future_Planning__c(Barcode__c = '5555555555'),
                new Future_Planning__c(Barcode__c = '6666666666'),
                new Future_Planning__c(Barcode__c = '7777777777')
                };
                    Insert OMRList;
        
        OMRList[0].Barcode__c = '2154697730';
        OMRList[1].Barcode__c = '2154783310';
        OMRList[2].Barcode__c = '2148796330';       
        Update OMRList;
        
        Test.startTest();       
        FuturePlanning_StudentsLink_Batch ORMBatch = new FuturePlanning_StudentsLink_Batch();
        Database.executeBatch(ORMBatch, 20);
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Check',sch,ORMBatch);
        
        Test.stopTest();
    }
}