@isTest
public class CareerPlanningTriggerTest {
    
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
                New Contact(LastName= 'Test Student6', Grade_12_Barcode__c = '2103649841', Bar_Code__c = '2103649841', AccountId = account.Id, RecordTypeId = conRecTypeId, G12_Batch_Code__c = batch.Id)
                };     
        Insert conList;
        
    }
    
    public static testMethod void calculateCareerPlanningMarksTestMethodForGrade9(){
    
    	Contact objCon = new Contact(LastName = 'Test Contact 1', Grade_9_Barcode__c = '1234567890');
        insert objCon ;
        
        Career_Planning__c objCP = new Career_Planning__c(Created_from_Form__c=true,Barcode__c = '1234567890',Q_7__c = 'B',Q_8__c = 'K',Q_9_1__c = 'A',Q_9_2__c = 'A',
                                                         Q_9_3__c = 'A',Q_9_4__c = 'A',Q_9_5__c = 'A',Q_9_6__c = 'A',Q_9_7__c = 'A',Q_10__c = 'C');
        insert objCP ;
        
        Career_Planning__c objCareerPlanning = [select Id,Student__c,Q_7_Marks__c,Q_8_Marks__c,Q_10_Marks__c,Q_9_1_Marks__c,
                                               Q_9_2_Marks__c,Q_9_3_Marks__c,Q_9_4_Marks__c,Q_9_5_Marks__c,Q_9_6_Marks__c,Q_9_7_Marks__c 
                                               from Career_Planning__c where Id =:objCP.Id ];

        list<Career_Planning__c> cplIst = new list<Career_Planning__c>{objCP};
        CareerPlanningTriggerHandler.calculateCareerPlanningMarks(cplIst);
 
    }
    
    public static testMethod void calculateCareerPlanningMarksTestMethodForGrade10(){
    
    	Contact objCon = new Contact(LastName = 'Test Contact 1', Grade_10_Barcode__c = '1234567890');
        insert objCon ;
        
        Career_Planning__c objCP = new Career_Planning__c(Barcode__c = '1234567890',Q_7__c = 'B',Q_8__c = 'A',Q_9_1__c = 'A',Q_9_2__c = 'A',
                                                         Q_9_3__c = 'A',Q_9_4__c = 'A',Q_9_5__c = 'A',Q_9_6__c = 'A',Q_9_7__c = 'A',Q_10__c = 'B');
        insert objCP ;
        
        Career_Planning__c objCareerPlanning = [select Id,Student__c,Q_7_Marks__c,Q_8_Marks__c,Q_10_Marks__c,Q_9_1_Marks__c,
                                               Q_9_2_Marks__c,Q_9_3_Marks__c,Q_9_4_Marks__c,Q_9_5_Marks__c,Q_9_6_Marks__c,Q_9_7_Marks__c 
                                               from Career_Planning__c where Id =:objCP.Id ];

        list<Career_Planning__c> cplIst = new list<Career_Planning__c>{objCP};
        CareerPlanningTriggerHandler.calculateCareerPlanningMarks(cplIst);
 
    }
    
    public static testMethod void calculateCareerPlanningMarksTestMethodForGrade11(){
    
    	Contact objCon = new Contact(LastName = 'Test Contact 1', Grade_11_Barcode__c = '1234567890');
        insert objCon ;
        
        Career_Planning__c objCP = new Career_Planning__c(Barcode__c = '1234567890',Q_7__c = 'B',Q_8__c = 'A',Q_9_1__c = 'A',Q_9_2__c = 'A',
                                                         Q_9_3__c = 'A',Q_9_4__c = 'A',Q_9_5__c = 'A',Q_9_6__c = 'A',Q_9_7__c = 'A',Q_10__c = 'B');
        insert objCP ;
        
        Career_Planning__c objCareerPlanning = [select Id,Student__c,Q_7_Marks__c,Q_8_Marks__c,Q_10_Marks__c,Q_9_1_Marks__c,
                                               Q_9_2_Marks__c,Q_9_3_Marks__c,Q_9_4_Marks__c,Q_9_5_Marks__c,Q_9_6_Marks__c,Q_9_7_Marks__c 
                                               from Career_Planning__c where Id =:objCP.Id ];

        list<Career_Planning__c> cplIst = new list<Career_Planning__c>{objCP};
        CareerPlanningTriggerHandler.calculateCareerPlanningMarks(cplIst);
 
    }
    
    public static testMethod void calculateCareerPlanningMarksTestMethodForGrade12(){
    
    	Contact objCon = new Contact(LastName = 'Test Contact 1', Grade_12_Barcode__c = '1234567890');
        insert objCon ;
        
        Career_Planning__c objCP = new Career_Planning__c(Barcode__c = '1234567890',Q_7__c = 'B',Q_8__c = 'A',Q_9_1__c = 'A',Q_9_2__c = 'A',
                                                         Q_9_3__c = 'A',Q_9_4__c = 'A',Q_9_5__c = 'A',Q_9_6__c = 'A',Q_9_7__c = 'A',Q_10__c = 'B');
        insert objCP ;
        
        Career_Planning__c objCareerPlanning = [select Id,Student__c,Q_7_Marks__c,Q_8_Marks__c,Q_10_Marks__c,Q_9_1_Marks__c,
                                               Q_9_2_Marks__c,Q_9_3_Marks__c,Q_9_4_Marks__c,Q_9_5_Marks__c,Q_9_6_Marks__c,Q_9_7_Marks__c 
                                               from Career_Planning__c where Id =:objCP.Id ];

        list<Career_Planning__c> cplIst = new list<Career_Planning__c>{objCP};
        CareerPlanningTriggerHandler.calculateCareerPlanningMarks(cplIst);
 
    }
    
    public static testMethod void calculateCareerPlanningMarksForGrade10TestMethod(){
    
    Contact objCon = new Contact(LastName = 'Test Contact 2', Grade_10_Barcode__c = '1234567890');
        insert objCon ;
        
        Career_Planning__c objCP = new Career_Planning__c(Barcode__c = '1234567890',Q_7__c = 'B',Q_8__c = 'B',Q_9_1__c = 'B',Q_9_2__c = 'B',
                                                         Q_9_3__c = 'B',Q_9_4__c = 'B',Q_9_5__c = 'B',Q_9_6__c = 'B',Q_9_7__c = 'B',Q_10__c = 'C');
        insert objCP ;
        
        Career_Planning__c objCareerPlanning = [select Id,Student__c,Q_7_Marks__c,Q_8_Marks__c,Q_10_Marks__c,Q_9_1_Marks__c,
                                               Q_9_2_Marks__c,Q_9_3_Marks__c,Q_9_4_Marks__c,Q_9_5_Marks__c,Q_9_6_Marks__c,Q_9_7_Marks__c 
                                               from Career_Planning__c where Id =:objCP.Id ];
        
        System.assertEquals(objCon.Id, objCareerPlanning.Student__c);
        System.assertEquals( 1 , objCareerPlanning.Q_7_Marks__c);
		System.assertEquals( 1 , objCareerPlanning.Q_8_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_10_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_1_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_2_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_3_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_4_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_5_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_6_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_7_Marks__c);

 
    }
    
    public static testMethod void calculateCareerPlanningMarksForGrade11TestMethod(){
    
    Contact objCon = new Contact(LastName = 'Test Contact 3', Grade_11_Barcode__c = '1234567890');
        insert objCon ;
        
        Career_Planning__c objCP = new Career_Planning__c(Created_from_Form__c=true,Barcode__c = '1234567890',Q_7__c = 'B',Q_8__c = 'K',Q_9_1__c = 'A',Q_9_2__c = 'B',
                                                         Q_9_3__c = 'A',Q_9_4__c = 'B',Q_9_5__c = 'A',Q_9_6__c = 'B',Q_10__c = 'C');
        insert objCP ;
        
        Career_Planning__c objCareerPlanning = [select Id,Student__c,Q_7_Marks__c,Q_8_Marks__c,Q_10_Marks__c,Q_9_1_Marks__c,
                                               Q_9_2_Marks__c,Q_9_3_Marks__c,Q_9_4_Marks__c,Q_9_5_Marks__c,Q_9_6_Marks__c,Q_9_7_Marks__c 
                                               from Career_Planning__c where Id =:objCP.Id ];
        
        System.assertEquals(objCon.Id, objCareerPlanning.Student__c);
        System.assertEquals( 1 , objCareerPlanning.Q_7_Marks__c);
		System.assertEquals( 0.5 , objCareerPlanning.Q_8_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_10_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_1_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_2_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_3_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_4_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_5_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_6_Marks__c);

 
    }
    
        public static testMethod void calculateCareerPlanningMarksForGrade12TestMethod(){
    
    Contact objCon = new Contact(LastName = 'Test Contact 3', Grade_12_Barcode__c = '1234567890');
        insert objCon ;
        
        Career_Planning__c objCP = new Career_Planning__c(Barcode__c = '1234567890', Q_7__c = 'B',Q_8__c = 'K',Q_9_1__c = 'A',Q_9_2__c = 'B',
                                                         Q_9_3__c = 'A',Q_9_4__c = 'B',Q_9_5__c = 'A',Q_9_6__c = 'B',Q_10__c = 'C');
        insert objCP ;
        
        Career_Planning__c objCareerPlanning = [select Id,Student__c,Q_7_Marks__c,Q_8_Marks__c,Q_10_Marks__c,Q_9_1_Marks__c,
                                               Q_9_2_Marks__c,Q_9_3_Marks__c,Q_9_4_Marks__c,Q_9_5_Marks__c,Q_9_6_Marks__c,Q_9_7_Marks__c 
                                               from Career_Planning__c where Id =:objCP.Id ];
        
        System.assertEquals(objCon.Id, objCareerPlanning.Student__c);
        System.assertEquals( 1 , objCareerPlanning.Q_7_Marks__c);
		System.assertEquals( 0.5 , objCareerPlanning.Q_8_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_10_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_1_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_2_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_3_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_4_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_5_Marks__c);
        System.assertEquals( 1 , objCareerPlanning.Q_9_6_Marks__c);

 
    }
    
     @isTest
    public static void test_calculateMarksForm(){
         List<Contact> conList = [SELECT Id, Name FROM Contact WHERE LastName LIKE '%Test Student%'];
        
        List<Career_Planning__c> omrList = New List<Career_Planning__c>{
            new Career_Planning__c(Student__c = conList[0].Id, Barcode__c = '2103649800'),
                new Career_Planning__c(Student__c = conList[0].Id, Barcode__c = '2103649810'),
                new Career_Planning__c(Student__c = conList[0].Id, Barcode__c = '2103649820'),
                new Career_Planning__c(Student__c = conList[0].Id, Barcode__c = '2103649841'),
                new Career_Planning__c(Student__c = conList[0].Id, Barcode__c = '2103649000')
                };
        Test.startTest();
        Insert omrList;
        CareerPlanningTriggerHandler.calculateCareerPlanningMarksNew(omrList);
        CareerPlanningTriggerHandler.calculateCareerPlanningMarks(omrList);
        Test.stopTest();

    }
    
    
}