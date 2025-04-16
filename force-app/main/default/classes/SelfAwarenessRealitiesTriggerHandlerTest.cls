@isTest
public class SelfAwarenessRealitiesTriggerHandlerTest {

    @testsetup
    public static void testData()
    {      
        State_Govt_Body_Level__c state=new State_Govt_Body_Level__c();
        state.Name='SSC';
        insert state;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai';
        sm.Name = 'TDistrict Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'test description';
        insert sm;
        
        District_Master__c distict=new District_Master__c();
        distict.State__c=state.id;
        distict.Name='Mumbai';
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
        
        Batch__c batch=new Batch__c();
        batch.School_Name__c=account.id;
        batch.Preferred_Language__c='Hindi';
        insert batch; 
        
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Student').getRecordTypeId();
        List<Contact> conList = New List<Contact>{
            New Contact(LastName= 'Test Student', Grade_9_Barcode__c = '2103649801', Bar_Code__c = '210364980', AccountId = account.Id, RecordTypeId = conRecTypeId, Batch_Code__c = batch.Id ),
            New Contact(LastName= 'Test Student2', Grade_10_Barcode__c = '2103649801', Bar_Code__c = '210364981', AccountId = account.Id, RecordTypeId = conRecTypeId),
            New Contact(LastName= 'Test Student3', Grade_11_Barcode__c = '2103649801', Bar_Code__c = '210364982', AccountId = account.Id, RecordTypeId = conRecTypeId),
                New Contact(LastName= 'Test Student3', Grade_12_Barcode__c = '2103649801', Bar_Code__c = '210364983', AccountId = account.Id, RecordTypeId = conRecTypeId)
        };     
        Insert conList;
               
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
    }

    @isTest
    public static void SelfAwarenessTest(){
        List<Contact> conList = [SELECT Id, Name FROM Contact WHERE Name LIKE '%Test Student%'];
        
        SelfAwarenessRealitiesTriggerHandler.fetchReality('D', true);
        Test.startTest();
        List<Self_Awareness_Realities__c> sarList = New List<Self_Awareness_Realities__c>{
            New Self_Awareness_Realities__c(Student__c = conList[0].Id, Barcode__c = '2103649801', Reality1_Self_1__c = 'A', Quiz_2_1__c = '1', Quiz_2_1_Marks__c = 1),
            New Self_Awareness_Realities__c(Student__c = conList[1].Id, Barcode__c = '2103649801', Reality1_Self_1__c = 'B', Quiz_2_1__c = '1', Quiz_2_1_Marks__c = 1),
            New Self_Awareness_Realities__c(Student__c = conList[2].Id, Barcode__c = '2103649801', Reality1_Self_1__c = 'A', Quiz_2_1__c = '1', Quiz_2_1_Marks__c = 1)
        };                    
        Insert sarList;
        SelfAwarenessRealitiesTriggerHandler.populateStudentAndMarksCalculation(sarList);
        SelfAwarenessRealitiesTriggerHandler.dummCodeCoverage();
        Test.stopTest();
    }

    @isTest
    public static void sarTestMethod01(){
         //Map<String, String> que2Grade9WithAns = new Map<String, String>{'Quiz_2_1__c'=>'B',
           //     'Quiz_2_2__c'=>'C','Quiz_2_3__c'=>'A','Quiz_2_4__c'=>'C','Quiz_2_5__c'=>'B','Quiz_2_6__c'=>'B','Quiz_2_7__c'=>'B',
             //   'Quiz_2_8__c'=>'B','Quiz_2_9__c'=>'D','Quiz_2_10__c'=>'D'};
        List<Self_Awareness_Realities__c> sarList = new List<Self_Awareness_Realities__c>();
        
        List<Contact> conList = [SELECT Id, Name FROM Contact WHERE Name LIKE '%Test Student%'];
        Self_Awareness_Realities__c sar01 = new Self_Awareness_Realities__c();
        sar01.Student__c = conList[0].Id;
        sar01.Barcode__c = '2103649801';
        sar01.Created_from_Form__c = true;
        sar01.Quiz_2_1__c = 'A';
        sar01.Quiz_2_2__c = 'A';
        sar01.Quiz_2_3__c = 'B';
        sar01.Quiz_2_4__c = 'C';
        sar01.Quiz_2_5__c = '*';
        sar01.Reality1_Self_1__c = 'A';
        sar01.Reality_2_Self_2__c = 'A';
        sar01.Reality_3_Self_3__c = 'A';
        sar01.Reality_4_Self_4__c = 'A';
        sar01.Reality_5_Family_1__c = 'A';
        sar01.Reality_6_Family_2__c = 'A';
        sar01.Reality_7_Family_3__c = 'A';
        sar01.Reality_8_Family_4__c = 'A';        
        insert sar01;
            
        Self_Awareness_Realities__c sar02 = new Self_Awareness_Realities__c();        
        sar02.Barcode__c = '2103649000';
        sar02.Created_from_Form__c = true;
        sar02.Quiz_2_1__c = 'A';
        sar02.Quiz_2_2__c = 'A';
        sar02.Quiz_2_3__c = 'B';
        sar02.Quiz_2_4__c = 'C';
        sar02.Quiz_2_5__c = '*';
        sar02.Reality1_Self_1__c = 'B';
        sar02.Reality_2_Self_2__c = 'B';
        sar02.Reality_3_Self_3__c = 'B';
        sar02.Reality_4_Self_4__c = 'B';
        sar02.Reality_5_Family_1__c = 'B';
        sar02.Reality_6_Family_2__c = 'B';
        sar02.Reality_7_Family_3__c = 'B';
        sar02.Reality_8_Family_4__c = 'B';
        sarList.add(sar02);
        
        Test.startTest();   
        Insert sarList;  
        SelfAwarenessRealitiesTriggerHandler.populateStudentAndMarksCalculation(sarList);
        
        Map<String, String> que2Grade9WithAns = new Map<String, String>{'Quiz_2_1__c'=>'B',
                'Quiz_2_2__c'=>'C','Quiz_2_3__c'=>'A','Quiz_2_4__c'=>'C','Quiz_2_5__c'=>'B','Quiz_2_6__c'=>'B','Quiz_2_7__c'=>'B',
                'Quiz_2_8__c'=>'B','Quiz_2_9__c'=>'D','Quiz_2_10__c'=>'D'};
                    
                    Map<String, List<String>> que2Grade11WithAns = new Map<String, List<String>>{'Quiz_2_1__c'=>new List<String>{'A'},
                        'Quiz_2_2__c'=>new List<String>{'C'},'Quiz_2_3__c'=>new List<String>{'D'},
                            'Quiz_2_4__c'=>new List<String>{'C'},'Quiz_2_5__c'=>new List<String>{'C'},
                                'Quiz_2_6__c'=>new List<String>{'B'},'Quiz_2_7__c'=>new List<String>{'C'},
                                    'Quiz_2_8__c'=>new List<String>{'B'},'Quiz_2_9__c'=>new List<String>{'C','D'},
                                        'Quiz_2_10__c'=>new List<String>{'C','D'}};
        SelfAwarenessRealitiesTriggerHandler.calculateQuizMarks('Quiz_2_', 5, sar01, sar01, 'Grade 9', que2Grade9WithAns, que2Grade11WithAns);
        SelfAwarenessRealitiesTriggerHandler.calculateQuizMarks('Quiz_2_', 5, sar01, sar01, 'Grade 11', que2Grade9WithAns, que2Grade11WithAns);
        SelfAwarenessRealitiesTriggerHandler.dummCodeCoverage();
        delete sarList; 
        Test.stopTest();
        
        
    }
}