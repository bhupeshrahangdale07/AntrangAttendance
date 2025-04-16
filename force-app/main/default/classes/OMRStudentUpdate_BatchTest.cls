@isTest
public class OMRStudentUpdate_BatchTest {
    @isTest
    public static void StudentUpdate(){
        Id RecTypeCA = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Student').getRecordTypeId();
        List<Contact> contList = New List<Contact>{
            new Contact(LastName = 'Test Last Name 1', Grade_9_Barcode__c = '215469773'),
                new Contact(LastName = 'Test Last Name 2', Grade_10_Barcode__c = '215478331'),
                new Contact(LastName = 'Test Last Name 3', Grade_11_Barcode__c = '214879633')
                };  
                    Insert contList;
        
        List<OMR_Assessment__c> ListCDM1 = New List<OMR_Assessment__c>{
            new OMR_Assessment__c(Barcode__c = '11111111'),
                new OMR_Assessment__c(Barcode__c = '22222222'),
                new OMR_Assessment__c(Barcode__c = '33333333')
                };
                    Insert ListCDM1;
        
        ListCDM1[0].Barcode__c = '215469773';
        ListCDM1[1].Barcode__c = '215478331';
        ListCDM1[2].Barcode__c = '214879633';       
        Update ListCDM1;
        
        List<CDM2__c> ListCDM2 = New List<CDM2__c>{
            new CDM2__c(Barcode__c = '99999999'),
                new CDM2__c(Barcode__c = '888888888'),
                new CDM2__c(Barcode__c = '7777777777')
                };
                    Insert ListCDM2;
        
        ListCDM2[0].Barcode__c = '215469773';
        ListCDM2[1].Barcode__c = '215478331';
        ListCDM2[2].Barcode__c = '214879633';       
        Update ListCDM2;
        
        List<Career_Planning__c> CPList = New List<Career_Planning__c>{
            new Career_Planning__c(Barcode__c = '6666666666'),
                new Career_Planning__c(Barcode__c = '55555555'),
                new Career_Planning__c(Barcode__c = '444444444')
                };
                    Insert CPList;
        
        CPList[0].Barcode__c = '215469773';
        CPList[1].Barcode__c = '215478331';
        CPList[2].Barcode__c = '214879633';       
        Update CPList;
        
        List<Career_Skill__c> CSList = New List<Career_Skill__c>{
            new Career_Skill__c(Barcode__c = '222222222'),
                new Career_Skill__c(Barcode__c = '33333333'),
                new Career_Skill__c(Barcode__c = '88888888')
                };
                    Insert CSList;
        
        CSList[0].Barcode__c = '215469773';
        CSList[1].Barcode__c = '215478331';
        CSList[2].Barcode__c = '214879633';       
        Update CSList;
        
        List<Future_Planning__c> FPList = New List<Future_Planning__c>{
            new Future_Planning__c(Barcode__c = '1111111111'),
                new Future_Planning__c(Barcode__c = '222222222'),
                new Future_Planning__c(Barcode__c = '333333333')
                };
                    Insert FPList;
        
        FPList[0].Barcode__c = '215469773';
        FPList[1].Barcode__c = '215478331';
        FPList[2].Barcode__c = '214879633';       
        Update FPList;
        
        List<Self_Awareness_and_Feedback__c> SAFList = New List<Self_Awareness_and_Feedback__c>{
            new Self_Awareness_and_Feedback__c(Barcode__c = '5555555555'),
                new Self_Awareness_and_Feedback__c(Barcode__c = '666666666'),
                new Self_Awareness_and_Feedback__c(Barcode__c = '7777777')
                };
                    Insert SAFList;
        
        SAFList[0].Barcode__c = '215469773';
        SAFList[1].Barcode__c = '215478331';
        SAFList[2].Barcode__c = '214879633';       
        Update SAFList;
        
        List<Self_Awareness_Realities__c> SARList = New List<Self_Awareness_Realities__c>{
            new Self_Awareness_Realities__c(Barcode__c = '555555555'),
                new Self_Awareness_Realities__c(Barcode__c = '999999999'),
                new Self_Awareness_Realities__c(Barcode__c = '111111111')
                };
                    Insert SARList;
        
        SARList[0].Barcode__c = '215469773';
        SARList[1].Barcode__c = '215478331';
        SARList[2].Barcode__c = '214879633';       
        Update SARList;
        
        Test.startTest();       
        OMRStudentUpdate_Batch ORMBatch = new OMRStudentUpdate_Batch();
        Database.executeBatch(ORMBatch, 20);
        Test.stopTest();
    }   
}