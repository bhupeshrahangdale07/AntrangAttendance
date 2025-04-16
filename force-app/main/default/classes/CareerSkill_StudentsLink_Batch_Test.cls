@isTest
public class CareerSkill_StudentsLink_Batch_Test {
    @isTest
    public static void StudentUpdate(){
        Id RecTypeCA = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        List<Contact> contList = New List<Contact>{
            new Contact(LastName = 'Test Last Name 1', Grade_9_Barcode__c = '2154697730'),
                new Contact(LastName = 'Test Last Name 2', Grade_10_Barcode__c = '2154783310'),
                new Contact(LastName = 'Test Last Name 3', Grade_11_Barcode__c = '2148796330')
                };  
                    Insert contList;
        
        List<Career_Skill__c> OMRList = New List<Career_Skill__c>{
            new Career_Skill__c(Barcode__c = '5555555555', Q_11_1__c = 'A', Q_11_2__c='A', Q_11_3__c='A', Q_11_6__c='A', 
                                Q_11_8__c='A', Q_11_9__c='A', Q_12_1__c='Z', Q_12_2__c='A', Q_12_3__c='A', Q_12_4__c='A', Q_13__c='B',
                                Q_14__c='B', Q_15_1__c='A', Q_15_2__c='A', Q_15_3__c='A', Q_15_4__c='A', Q_15_5__c='A', Q_15_6__c='A',
                                Q_15_7__c='A', Q_15_8__c='A', Q_15_9__c='A', Q_16__c='A'),
                new Career_Skill__c(Barcode__c = '6666666666'),
                new Career_Skill__c(Barcode__c = '7777777777',Q_11_1__c = 'A', Q_11_2__c='A', Q_11_3__c='A', Q_11_6__c='A', 
                                Q_11_8__c='A', Q_11_9__c='A', Q_12_1__c='Z', Q_12_3__c='A', Q_13__c='B',
                                Q_14__c='B', Q_15_1__c='A', Q_15_2__c='A', Q_15_3__c='A', Q_15_4__c='A', Q_15_5__c='A', Q_15_6__c='A',
                                Q_15_7__c='A', Q_15_8__c='A', Q_15_9__c='A', Q_16__c='A')
                };
                    Insert OMRList;
        
        OMRList[0].Barcode__c = '2154697730';
        OMRList[1].Barcode__c = '2154783310';
        OMRList[2].Barcode__c = '2148796330';       
        Update OMRList;
        
        Test.startTest();       
        CareerSkill_StudentsLink_Batch ORMBatch = new CareerSkill_StudentsLink_Batch();
        Database.executeBatch(ORMBatch, 20);
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test Check',sch,ORMBatch);
        
        Test.stopTest();
    }
}