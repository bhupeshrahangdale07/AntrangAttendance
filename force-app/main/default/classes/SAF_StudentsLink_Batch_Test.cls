@isTest
public class SAF_StudentsLink_Batch_Test {
    @isTest
    public static void StudentUpdate(){
        Id RecTypeCA = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        List<Contact> contList = New List<Contact>{
            new Contact(LastName = 'Test Last Name 1', Grade_9_Barcode__c = '2154697730'),
                new Contact(LastName = 'Test Last Name 2', Grade_10_Barcode__c = '2154783310'),
                new Contact(LastName = 'Test Last Name 3', Grade_11_Barcode__c = '2148796330')
                };  
                    Insert contList;
        
        	List<Self_Awareness_and_Feedback__c> SAFList = New List<Self_Awareness_and_Feedback__c>{
            	new Self_Awareness_and_Feedback__c(Barcode__c = '5555555555'),
                new Self_Awareness_and_Feedback__c(Barcode__c = '6666666666'),
                new Self_Awareness_and_Feedback__c(Barcode__c = '7777777777')
                };
                    Insert SAFList;
        
        SAFList[0].Barcode__c = '2154697730';
        SAFList[1].Barcode__c = '2154783310';
        SAFList[2].Barcode__c = '2148796330';       
        Update SAFList;
        
        Test.startTest();       
        SAF_StudentsLink_Batch ORMBatch = new SAF_StudentsLink_Batch();
        Database.executeBatch(ORMBatch, 20);
        Test.stopTest();
    }
}