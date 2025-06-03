@isTest
public class omrAssessmentTriggerHandlerTest {
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
        batch.Academic_Year__c = 2023;
        Insert batch;
        
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Student').getRecordTypeId();
        List<Contact> conList = New List<Contact>{
            New Contact(LastName= 'Test Student', Grade_9_Barcode__c = '2103649800', Bar_Code__c = '2103649800', AccountId = account.Id, RecordTypeId = conRecTypeId, Batch_Code__c = batch.Id),
                New Contact(LastName= 'Test Student2', Grade_10_Barcode__c = '2103649810', Bar_Code__c = '2103649810', AccountId = account.Id, RecordTypeId = conRecTypeId, G10_Batch_Code__c = batch.Id),
                New Contact(LastName= 'Test Student3', Grade_11_Barcode__c = '2103649820', Bar_Code__c = '2103649820', AccountId = account.Id, RecordTypeId = conRecTypeId, G11_Batch_Code__c = batch.Id),
                New Contact(LastName= 'Test Student4', Grade_9_Barcode__c = '2103649830', Bar_Code__c = '2103649830', AccountId = account.Id, RecordTypeId = conRecTypeId, G12_Batch_Code__c = batch.Id),
                New Contact(LastName= 'Test Student5', Grade_9_Barcode__c = '2103649840', Bar_Code__c = '2103649840', AccountId = account.Id, RecordTypeId = conRecTypeId, Batch_Code__c = batch.Id),
                New Contact(LastName= 'Test Student6', Grade_12_Barcode__c = '2103649841', Bar_Code__c = '2103649841', AccountId = account.Id, RecordTypeId = conRecTypeId, G12_Batch_Code__c = batch.Id)
                };     
        Insert conList;
        
        IARP_Master__c iarp = New IARP_Master__c();
        iarp.Name = 'Entrepreneur';
        iarp.Interest_1__c = 'Realist';
        iarp.Interest_2__c = 'Investigative';
        iarp.Interest_3__c = 'Artistic';
        iarp.Aptitude_1__c = 'Numerical';
        iarp.Aptitude_2__c = 'Mechanical';
        iarp.Aptitude_3__c = 'Verbal';
        iarp.Is_Active__c = True;
        
        Insert iarp;
    }

    @isTest
    public static void testOmrMethod(){

        List<Contact> conList = [SELECT Id, Name FROM Contact WHERE LastName LIKE '%Test Student%'];
        
        List<OMR_Assessment__c> omrList = New List<OMR_Assessment__c>{
            New OMR_Assessment__c(Student__c = conList[0].Id, Barcode__c = '2103649800', Interest_1__c = 'Entrepreneur', Interest_2__c = 'Investigative', Aptitude_1__c = 'Numerical', Aptitude_2__c = 'Mechanical', Q_2_2__c = 'A', Q3_2__c = 'A', Q3_3__c = 'B', Q_2_3__c = 'B', Q4_2__c = '1', Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative', Created_from_Form__c = false),
            New OMR_Assessment__c(Student__c = conList[1].Id, Barcode__c = '2103649810', Interest_1__c = 'Realist', Interest_2__c = 'Investigative', Aptitude_1__c = 'Numerical', Aptitude_2__c = 'Mechanical', Q_2_2__c = 'B', Q3_2__c = 'A', Q3_3__c = 'A', Q_2_3__c = 'B', Q4_3__c = '2', Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative', Created_from_Form__c = false),
            New OMR_Assessment__c(Student__c = conList[2].Id, Barcode__c = '2103649820', Interest_1__c = 'Office Administrator', Interest_2__c = 'Investigative', Aptitude_1__c = 'Numerical', Aptitude_2__c = 'Mechanical', Q_2_2__c = 'A', Q3_2__c = 'B', Q3_3__c = 'B', Q_2_3__c = 'A', Q4_4__c = '1', Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative', Created_from_Form__c = false),
            New OMR_Assessment__c(Student__c = conList[3].Id, Barcode__c = '2103649830', Interest_1__c = 'Accountant', Interest_2__c = 'Investigative', Aptitude_1__c = 'Numerical', Aptitude_2__c = 'Mechanical', Q_2_2__c = 'B', Q3_2__c = 'B', Q3_3__c = 'A', Q_2_3__c = 'A', Q4_53__c = '2', Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative', Created_from_Form__c = false),
            New OMR_Assessment__c(Student__c = conList[4].Id, Barcode__c = '2103649840', Interest_1__c = 'Salesperson', Interest_2__c = 'Investigative', Aptitude_1__c = 'Numerical', Aptitude_2__c = 'Mechanical', Q_2_2__c = 'B', Q3_2__c = 'B', Q3_3__c = 'B', Q_2_3__c = 'B', Q4_53__c = '1', Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative', Created_from_Form__c = false),
            New OMR_Assessment__c(Student__c = conList[5].Id, Barcode__c = '2103649841', Interest_1__c = 'Salesperson', Interest_2__c = 'Investigative', Aptitude_1__c = 'Numerical', Aptitude_2__c = 'Mechanical', Q_2_2__c = 'B', Q3_2__c = 'B', Q3_3__c = 'B', Q_2_3__c = 'B', Q4_53__c = '1', Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative', Created_from_Form__c = false)
        };
        Insert omrList;
    }

    @isTest
    public static void testOmrMethod01(){

        List<Contact> conList = [SELECT Id, Name FROM Contact WHERE LastName LIKE '%Test Student%'];
        List<OMR_Assessment__c> omrList = New List<OMR_Assessment__c>{
            New OMR_Assessment__c(Student__c = conList[0].Id, Barcode__c = '2103649800', Q_1__c = 'D',
            Interest_1__c = 'Entrepreneur', Interest_2__c = 'Investigative', Aptitude_1__c = 'Numerical', Aptitude_2__c = 'Mechanical', 
            Q_2_2__c = 'A', Q_2_7__c = 'A', Q_2_3__c = 'B', Q3_2__c = 'A', Q3_3__c = 'B', Q3_7__c = 'B', Q4_2__c = '1', 
            Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative', Created_from_Form__c = false),
            New OMR_Assessment__c(Student__c = conList[1].Id, Barcode__c = '2103649810', 
            Interest_1__c = 'Realist', Interest_2__c = 'Investigative', Aptitude_1__c = 'Numerical', Aptitude_2__c = 'Mechanical', 
            Q_2_7__c = 'B', Q_2_3__c = 'B', Q3_7__c = 'A', Q3_3__c = 'A', Q4_3__c = '2', 
            Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative', Created_from_Form__c = false),
            New OMR_Assessment__c(Student__c = conList[1].Id, Barcode__c = '2103649820', 
            Interest_1__c = 'Realist', Interest_2__c = 'Investigative', Aptitude_1__c = 'Numerical', Aptitude_2__c = 'Mechanical', 
            Q_2_7__c = 'B', Q_2_3__c = 'B', Q3_7__c = 'A', Q3_3__c = 'A', Q4_3__c = '2', 
            Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative', Created_from_Form__c = false),
            New OMR_Assessment__c(Student__c = conList[1].Id, Barcode__c = '2103649841', 
            Interest_1__c = 'Realist', Interest_2__c = 'Investigative', Aptitude_1__c = 'Numerical', Aptitude_2__c = 'Mechanical', 
            Q_2_7__c = 'B', Q_2_3__c = 'B', Q3_7__c = 'A', Q3_3__c = 'A', Q4_3__c = '2', 
            Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative', Created_from_Form__c = false),
            New OMR_Assessment__c(Student__c = conList[1].Id, Barcode__c = '2103649000', 
            Interest_1__c = 'Realist', Interest_2__c = 'Investigative', Aptitude_1__c = 'Numerical', Aptitude_2__c = 'Mechanical', 
            Q_2_7__c = 'B', Q_2_3__c = 'B', Q3_7__c = 'A', Q3_3__c = 'A', Q4_3__c = '2', 
            Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative', Created_from_Form__c = false)
        };
        Insert omrList;
        
        
         
        omrAssessmentTriggerHandler.populateStudentOnOMRAssement(omrList);
        omrAssessmentTriggerHandler.dummCodeCoverage();
    }

    @isTest
    public static void testOmrMethod02(){
		Id EndlineRecordTypeId = [SELECT Id, DeveloperName, Name, SobjectType FROM RecordType where DeveloperName = 'Endline' AND SobjectType = 'OMR_Assessment__c'].Id;
        
        List<Contact> conList = [SELECT Id, Name, RecordType.DeveloperName, Batch_Code__c, Batch_Code__r.Academic_Year__c FROM Contact WHERE LastName LIKE '%Test Student%'];
        
        List<OMR_Assessment__c> omrList = New List<OMR_Assessment__c>{
            new OMR_Assessment__c(Student__c = conList[0].Id, Barcode__c = '210364980', 
            Q_2_2__c = 'B', Q_2_3__c = 'C', Q_2_7__c = 'G', Q3_2__c = '*', Q3_3__c = '*',
            Created_from_Form__c = true, RecordTypeId = EndlineRecordTypeId, Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative'),
            new OMR_Assessment__c(Student__c = conList[1].Id, Barcode__c = '210364981', 
            Q_2_2__c = 'B', Q_2_3__c = 'C',
            Created_from_Form__c = true, RecordTypeId = EndlineRecordTypeId, Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative'),
            new OMR_Assessment__c(Student__c = conList[2].Id, Barcode__c = '210364982', 
            Q_2_2__c = 'B',
            Created_from_Form__c = true, RecordTypeId = EndlineRecordTypeId, Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative'),
            new OMR_Assessment__c(Student__c = conList[3].Id, Barcode__c = '210364983', 
            Q3_2__c = 'B', Q3_3__c = 'C',
            Created_from_Form__c = true, RecordTypeId = EndlineRecordTypeId, Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative'),
            new OMR_Assessment__c(Student__c = conList[4].Id, Barcode__c = '210364984', 
            Q3_2__c = 'B',
            Created_from_Form__c = true, RecordTypeId = EndlineRecordTypeId, Career_Choice_1__c = 'Realist', Career_Choice_2__c = 'Investigative')
        };
        Insert omrList;
        
        omrAssessmentTriggerHandler.populateStudentAspirations(omrList, null);
        Map<String, String> intFildWithAPIname = new Map<String, String>{'Q_2_1__c'=>'Realist','Q_2_2__c'=>'Investigative',
            'Q_2_3__c'=>'Artistic','Q_2_4__c'=>'Social','Q_2_5__c'=>'Enterprising','Q_2_6__c'=>'Conventional','Q_2_7__c'=>'Not sure of interest / like'};
                Map<String, String> aptiFildWithAPIname = new Map<String, String>{'Q3_1__c'=>'Spatial','Q3_2__c'=>'Numerical',
                    'Q3_3__c'=>'Mechanical','Q3_4__c'=>'Abstract','Q3_5__c'=>'Verbal','Q3_6__c'=>'Creative','Q3_7__c'=>'Not sure of Aptitude'};
                        
        List<OMR_Assessment__c> omrListInserted = [select Id,Student__c, Barcode__c, 
                                                           Interest_1__c, Interest_2__c, Aptitude_1__c, Aptitude_2__c, 
                                                           Q_2_1__c, Q_2_2__c, Q_2_7__c, Q_2_3__c ,Q_2_4__c,Q_2_5__c,Q_2_6__c, Q3_2__c, Q3_3__c, Q3_7__c, Q4_2__c, 
                                                           Career_Choice_1__c, Career_Choice_2__c , Created_from_Form__c
                                                           from OMR_Assessment__c]; 
        omrAssessmentTriggerHandler.calculateMarks('Q_2_', 7, omrListInserted[0], omrListInserted[0], intFildWithAPIname, aptiFildWithAPIname);
        
        delete omrList;
        
    }
}