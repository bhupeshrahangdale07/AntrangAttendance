@isTest
public class StudentReportBatchTest {

    @isTest
    public static void test1(){
        
        AntarangSetting__c settings = AntarangSetting__c.getOrgDefaults();
        settings.Academic_Year__c = 2021;
        upsert settings custSettings__c.Id;
        
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
        
        Batch__c batch=new Batch__c();
        batch.School_Name__c=account.id;
        batch.Preferred_Language__c='Hindi';
        batch.Academic_Year__c = settings.Academic_Year__c;
        insert batch; 
        
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Student').getRecordTypeId();
        List<Contact> conList = New List<Contact>{
            New Contact(LastName= 'Test Student', Grade_9_Barcode__c = '210364980', Bar_Code__c = '210364980', AccountId = account.Id, RecordTypeId = conRecTypeId, Batch_Code__c = batch.Id ),
            New Contact(LastName= 'Test Student2', Grade_10_Barcode__c = '210364981', Bar_Code__c = '210364981', AccountId = account.Id, RecordTypeId = conRecTypeId),
            New Contact(LastName= 'Test Student3', Grade_11_Barcode__c = '210364982', Bar_Code__c = '210364982', AccountId = account.Id, RecordTypeId = conRecTypeId)
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
        
        List<OMR_Assessment__c> omrList = New List<OMR_Assessment__c>{
            new OMR_Assessment__c(Student__c = conList[0].Id, Barcode__c = '210364980', RecordTypeId = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByName().get('Endline').getRecordTypeId(),
            Q_2_2__c = 'B', Q_2_3__c = 'C', Q_2_7__c = 'G', Q3_2__c = '*', Q3_3__c = '*', Career_Choice_1__c = 'not sure', Career_Choice_2__c = 'not sure',
            Created_from_Form__c = true)
        };
        Insert omrList;
        
        List<Self_Awareness_Realities__c> sarList = New List<Self_Awareness_Realities__c>{
            New Self_Awareness_Realities__c(Student__c = conList[0].Id, Barcode__c = '210364980', Quiz_2_1__c = '1', Reality1_Self_1__c =  'A', 
                                            Reality_2_Self_2__c =  'B', 
                                            Reality_3_Self_3__c =  'B', Reality_4_Self_4__c =  'C', Reality_5_Family_1__c =  'B', Reality_6_Family_2__c =  'B', 
                                            Reality_7_Family_3__c =  'B', Reality_8_Family_4__c =  'D',  
                                            RecordTypeId = Schema.SObjectType.Self_Awareness_Realities__c.getRecordTypeInfosByName().get('Baseline').getRecordTypeId(), Quiz_2_1_Marks__c = 1)
        };                    
        Insert sarList;  
        
        Self_Awareness_and_Feedback__c selfaware = new Self_Awareness_and_Feedback__c();
        selfaware.RecordTypeId = Schema.SObjectType.Self_Awareness_and_Feedback__c.getRecordTypeInfosByName().get('Baseline').getRecordTypeId();
        selfaware.Student__c =  conList[0].Id;
        selfaware.Barcode__c = '210364980';
        selfaware.Interest_1__c = 'Enterprising';
        selfaware.Interest_2__c = 'Realistic';
        selfaware.Interest_3__c = 'Artistic';
        selfaware.Aptitude_1__c = 'Numerical';
        selfaware.Aptitude_2__c = 'Abstract';
        selfaware.Aptitude_3__c = 'Verbal';
        Insert selfaware;

        Test.startTest();
        	Database.executeBatch(new StudentReportBatch(''));
        Test.stopTest();
    }
    
    @isTest
    public static void test2(){
        
        AntarangSetting__c settings = AntarangSetting__c.getOrgDefaults();
        settings.Academic_Year__c = 2021;
        upsert settings custSettings__c.Id;
        
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
        
        Batch__c batch=new Batch__c();
        batch.School_Name__c=account.id;
        batch.Preferred_Language__c='Hindi';
        batch.Academic_Year__c = settings.Academic_Year__c;
        insert batch; 
        
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Student').getRecordTypeId();
        List<Contact> conList = New List<Contact>{
            New Contact(LastName= 'Test Student', Grade_9_Barcode__c = '210364980', Reality_1__c = 'Yes', Aptitude_1__c = 'Verbal', Bar_Code__c = '210364980', AccountId = account.Id, RecordTypeId = conRecTypeId, Batch_Code__c = batch.Id ),
            New Contact(LastName= 'Test Student2', Grade_10_Barcode__c = '210364981', Bar_Code__c = '210364981', AccountId = account.Id, RecordTypeId = conRecTypeId),
            New Contact(LastName= 'Test Student3', Grade_11_Barcode__c = '210364982', Bar_Code__c = '210364982', AccountId = account.Id, RecordTypeId = conRecTypeId)
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
        
        List<OMR_Assessment__c> omrList = New List<OMR_Assessment__c>{
            new OMR_Assessment__c(Student__c = conList[0].Id, Barcode__c = '210364980', RecordTypeId = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByName().get('Endline').getRecordTypeId(),
            Q_2_2__c = 'B', Q_2_3__c = 'C', Q_2_7__c = 'G', Q3_2__c = '*', Q3_3__c = '*', Career_Choice_1__c = 'not sure', Career_Choice_2__c = 'not sure',
            Created_from_Form__c = true)
        };
        Insert omrList;
        
        
        /*
        Self_Awareness_and_Feedback__c selfaware = new Self_Awareness_and_Feedback__c();
        selfaware.RecordTypeId = Schema.SObjectType.Self_Awareness_and_Feedback__c.getRecordTypeInfosByName().get('Baseline').getRecordTypeId();
        selfaware.Student__c =  conList[0].Id;
        selfaware.Barcode__c = '210364980';
        selfaware.Interest_1__c = '';
        selfaware.Interest_2__c = '';
        selfaware.Interest_3__c = '';
        selfaware.Aptitude_1__c = '';
        selfaware.Aptitude_2__c = '';
        selfaware.Aptitude_3__c = '';
        Insert selfaware;
		*/
            
        Test.startTest();
        	Database.executeBatch(new StudentReportBatch(''));
        Test.stopTest();
    }
}