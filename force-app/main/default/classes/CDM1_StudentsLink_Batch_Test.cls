@isTest
public class CDM1_StudentsLink_Batch_Test {
    @isTest
    public static void StudentUpdate(){
        Id RecTypeCA = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        List<Contact> contList = New List<Contact>{
            new Contact(LastName = 'Test Last Name 1', Grade_9_Barcode__c = '2154697730'),
                new Contact(LastName = 'Test Last Name 2', Grade_10_Barcode__c = '2154783310'),
                new Contact(LastName = 'Test Last Name 3', Grade_11_Barcode__c = '2148796330')
                };  
                    Insert contList;
        
        List<OMR_Assessment__c> OMRList = New List<OMR_Assessment__c>{
            	new OMR_Assessment__c(Barcode__c = '5555555555',Interest_1__c='TestData',Interest_2__c='TestData',Aptitude_1__c='TestData',Aptitude_2__c='TestData',Career_Choice_1__c='TestData',Career_Choice_2__c='TestData',Interest_Marks__c=1.0,Aptitude_Marks__c=1.0,Career_Choice_1_Marks__c=1.0,Career_Choice_2_Marks__c=1.0,Q3_1__c='A',Q3_2__c='A',Q3_3__c='A',Q3_4__c='A',Q3_5__c='A',Q3_6__c='A',Q3_7__c='A',Q4_1__c='A',Q4_2__c='A',Q4_3__c='A',Q4_4__c='A',Q4_5__c='A',Q4_6__c='A',Q4_7__c='A',Q4_8__c='A',Q4_9__c='A',Q4_10__c='A'),
                                      //,Q4_1__c='A',Q4_2__c='A',Q4_3__c='A',Q4_4__c='A',Q4_5__c='A',Q4_6__c='A',Q4_7__c='A',Q4_8__c='A',Q4_9__c='A',Q4_10__c='A'
                                      //,Q4_11__c='Test Data',Q4_12__c='Test Data',Q4_13__c='Test Data',Q4_14__c='Test Data',Q4_15__c='Test Data'),
                                     
                new OMR_Assessment__c(Barcode__c = '6666666666'),
                new OMR_Assessment__c(Barcode__c = '7777777777')
                };
                    
                    Insert OMRList;
        
        OMRList[0].Barcode__c = '2154697730';
        OMRList[1].Barcode__c = '2154783310';
        OMRList[2].Barcode__c = '2148796330';       
        Update OMRList;
        
        Test.startTest();       
        CDM1_StudentsLink_Batch ORMBatch = new CDM1_StudentsLink_Batch();
        Database.executeBatch(ORMBatch, 20);
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Check',sch,ORMBatch);
        
        Test.stopTest();
    }
}