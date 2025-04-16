@isTest
public class SAR_StudentsLink_Batch_Test {
    @isTest
    public static void StudentUpdate(){
        Id RecTypeCA = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        List<Contact> contList = New List<Contact>{
            new Contact(LastName = 'Test Last Name 1', Grade_9_Barcode__c = '2154697730'),
                new Contact(LastName = 'Test Last Name 2', Grade_10_Barcode__c = '2154783310'),
                new Contact(LastName = 'Test Last Name 3', Grade_11_Barcode__c = '2148796330')
                };  
                    Insert contList;
        
        List<Self_Awareness_Realities__c> SARList = New List<Self_Awareness_Realities__c>{
            new Self_Awareness_Realities__c(Barcode__c = '5555555555'),
                new Self_Awareness_Realities__c(Barcode__c = '6666666666'),
                new Self_Awareness_Realities__c(Barcode__c = '7777777777')
                };
                    Insert SARList;
        List<Explanations__c> explanations =new List<Explanations__c>{ 
            new Explanations__c(Name='Interest',Code__c='Enterprising - E',Particulars__c='Enterprising people like to lead, influence people and are able to negotiate and persuade well.'),
            new Explanations__c(Name='Interest',Code__c='Social - S',Particulars__c='Social people like to be with people and provide information or services to help, train or cure people.'),
            new Explanations__c(Name='Aptitude',Code__c='Verbal Ability',Particulars__c='Verbal ability is the ability to reason with words, to understand and use concepts expressed in words.'),
            new Explanations__c(Name='Aptitude',Code__c='Mechanical Ability',Particulars__c='Mechanical ability is the ability to understand and apply concepts related to tools.'),
            new Explanations__c(Name='Personality',Code__c='Extrovert,Sensing,Thinking,Judging',Particulars__c='Extroverts'),
            new Explanations__c(Name='Realities',Code__c='Self 1',Realities__c='Yes',Particulars__c='Student has family member(s) that have studied upto 12th Grade'),
            new Explanations__c(Name='Realities',Code__c='Self 1',Realities__c='No',Particulars__c='Student does not have family member(s) that have studied upto 12th Grade'),
            new Explanations__c(Name='Realities',Code__c='Self 2',Realities__c='Yes',Particulars__c='Student family allows everyone including women to work past 10pm.'),
            new Explanations__c(Name='Realities',Code__c='Self 2',Realities__c='No',Particulars__c='Student family does not allow women to work past 10pm'),
            new Explanations__c(Name='Realities',Code__c='Self 3',Realities__c='Yes',Particulars__c='Student family income is above INR 20,000 per month'),
            new Explanations__c(Name='Realities',Code__c='Self 3',Realities__c='No',Particulars__c='Student family income is below INR 20,000 per month'),
            new Explanations__c(Name='Realities',Code__c='Self 4',Realities__c='A',Particulars__c='Student family will  provide monetary support for education'),
            new Explanations__c(Name='Realities',Code__c='Self 4',Realities__c='B',Particulars__c='Student family will not provide monetary support for education'),
            new Explanations__c(Name='Realities',Code__c='Self 4',Realities__c='C',Particulars__c='Student family will not provide monetary support for education'),
            new Explanations__c(Name='Realities',Code__c='Family 1',Realities__c='Yes',Particulars__c='Student will not get married till atleast 22 years of age'),
            new Explanations__c(Name='Realities',Code__c='Family 1',Realities__c='No',Particulars__c='Student will get married before 22 years of age'),
            new Explanations__c(Name='Realities',Code__c='Family 2',Realities__c='Yes',Particulars__c='Student will be the fIrst to work in the organized sector in their family'),
            new Explanations__c(Name='Realities',Code__c='Family 2',Realities__c='No',Particulars__c='Student will not get married till atleast 22 years of ageStudent will not be the fIrst to work in the organized sector in their family'),
            new Explanations__c(Name='Realities',Code__c='Family 3',Realities__c='Yes',Particulars__c='Students is already working for 1+ years'),
            new Explanations__c(Name='Realities',Code__c='Family 3',Realities__c='No',Particulars__c='Students is not working for 1+ years'),
            new Explanations__c(Name='Realities',Code__c='Family 4',Realities__c='A',Particulars__c='Student is calm and does not get angry'),
            new Explanations__c(Name='Realities',Code__c='Family 4',Realities__c='B',Particulars__c='Student is not calm and gets angry'),
            new Explanations__c(Name='Realities',Code__c='Family 4',Realities__c='C',Particulars__c='Student is not calm and gets angry')
        };                               
        insert explanations;
        
        SARList[0].Barcode__c = '2154697730';
        SARList[1].Barcode__c = '2154783310';
        SARList[2].Barcode__c = '2148796330';       
        Update SARList;
        
        Test.startTest();       
        SAR_StudentsLink_Batch ORMBatch = new SAR_StudentsLink_Batch();
        Database.executeBatch(ORMBatch, 20);
        Test.stopTest();
    }
}