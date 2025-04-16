@isTest
public class cdm2TriggerTest {
    
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

     public static testMethod void populateStudentOnCDM2Grade9TestMethod(){
    
	Contact objCon = new Contact(LastName = 'Test Contact 1', Grade_9_Barcode__c = '1234567890');
        insert objCon ;
         
         CDM2__c objCDM2 = NEW CDM2__c(Barcode__c = '1234567890',Q5__c = 'A',Q6_1__c = 'A',Q6_2__c = 'A',Q6_3__c = 'A' ,Q6_4__c = 'B' ,
                                       Q6_5__c = 'A' ,Q6_6__c = 'A' ,Q6_7__c = 'A' ,Q6_8__c = 'A' ,Q6_9__c = 'A' ,Q6_10__c = 'B' ,
                                       Q6_11__c = 'A' ,Q6_12__c = 'A');
         insert objCDM2 ;
         
         CDM2__c objectCDM2 = [select Id, Student__c ,Q6_1_Marks__c,Q6_2_Marks__c,Q6_3_Marks__c,Q6_4_Marks__c,Q6_5_Marks__c,Q6_6_Marks__c,Q6_7_Marks__c,
                              Q6_8_Marks__c,Q6_9_Marks__c,Q6_10_Marks__c,Q6_11_Marks__c,Q6_12_Marks__c,X6_Options_that_fit_into_Industry__c,X5_Confident_about_chosen_career__c from CDM2__c where Id=:objCDM2.Id];
         
		
         /*System.assertEquals(objCon.Id, objectCDM2.Student__c);
         System.assertEquals( 1 , objectCDM2.Q6_1_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_2_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_3_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_4_Marks__c);
         System.assertEquals( -1 , objectCDM2.Q6_5_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_6_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_7_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_8_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_9_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_10_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_11_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_12_Marks__c);
         System.assertEquals( 0 , objectCDM2.X6_Options_that_fit_into_Industry__c);
         System.assertEquals( 1 , objectCDM2.X5_Confident_about_chosen_career__c);
         */

     }
    
    public static testMethod void populateStudentOnCDM2Grade10TestMethod(){
    
	Contact objCon = new Contact(LastName = 'Test Contact 2', Grade_10_Barcode__c = '1111111111');
        insert objCon ;
         
         CDM2__c objCDM2 = NEW CDM2__c(Barcode__c = '1111111111',Q5__c = 'D',Q6_1__c = 'A,D,E',Q6_2__c = 'B',Q6_3__c = 'A,C,E,G' ,Q6_4__c = 'D,E' ,
                                       Q6_5__c = 'A' ,Q6_6__c = 'A,B,D' ,Q6_7__c = 'A' ,Q6_8__c = 'A' ,Q6_9__c = 'A,D,B' ,Q6_10__c = 'B' ,
                                       Q6_11__c = 'A' ,Q6_12__c = 'A');
         insert objCDM2 ;
         
         CDM2__c objectCDM2 = [select Id, Student__c ,Q6_1_Marks__c,Q6_2_Marks__c,Q6_3_Marks__c,Q6_4_Marks__c,Q6_5_Marks__c,Q6_6_Marks__c,Q6_7_Marks__c,
                              Q6_8_Marks__c,Q6_9_Marks__c,Q6_10_Marks__c,Q6_11_Marks__c,Q6_12_Marks__c,X6_Options_that_fit_into_Industry__c,X5_Confident_about_chosen_career__c from CDM2__c where Id=:objCDM2.Id];
         
		
         /*System.assertEquals(objCon.Id, objectCDM2.Student__c);
         System.assertEquals( 3 , objectCDM2.Q6_1_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_2_Marks__c);
         System.assertEquals( 4 , objectCDM2.Q6_3_Marks__c);
         System.assertEquals( 2 , objectCDM2.Q6_4_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_5_Marks__c);
         System.assertEquals( 3 , objectCDM2.Q6_6_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_7_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_8_Marks__c);
         System.assertEquals( 3 , objectCDM2.Q6_9_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_10_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_11_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_12_Marks__c);
         System.assertEquals( 4 , objectCDM2.X6_Options_that_fit_into_Industry__c);
         System.assertEquals( 0 , objectCDM2.X5_Confident_about_chosen_career__c);
         */
     }
    
    public static testMethod void populateStudentOnCDM2Grade11TestMethod(){
    
	Contact objCon = new Contact(LastName = 'Test Contact 3', Grade_11_Barcode__c = '2222222890');
        insert objCon ;
         
         CDM2__c objCDM2 = NEW CDM2__c(Barcode__c = '2222222890',Q5__c = 'C',Q6_1__c = 'A,D,E',Q6_2__c = 'B',Q6_3__c = 'A,C,E,G' ,Q6_4__c = 'D,E,A,F,H' ,
                                       Q6_5__c = 'A' ,Q6_7__c = 'A' ,Q6_9__c = 'A,D,B' ,Q6_10__c = 'B' ,
                                       Q6_11__c = 'A,B,C' ,Q6_12__c = 'A');
         insert objCDM2 ;
         
         CDM2__c objectCDM2 = [select Id, Student__c ,Q6_1_Marks__c,Q6_2_Marks__c,Q6_3_Marks__c,Q6_4_Marks__c,Q6_5_Marks__c,Q6_6_Marks__c,Q6_7_Marks__c,
                              Q6_8_Marks__c,Q6_9_Marks__c,Q6_10_Marks__c,Q6_11_Marks__c,Q6_12_Marks__c,X6_Options_that_fit_into_Industry__c,X5_Confident_about_chosen_career__c from CDM2__c where Id=:objCDM2.Id];
         
		
         /*System.assertEquals(objCon.Id, objectCDM2.Student__c);
         System.assertEquals( 3 , objectCDM2.Q6_1_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_2_Marks__c);
         System.assertEquals( 4 , objectCDM2.Q6_3_Marks__c);
         System.assertEquals( 3 , objectCDM2.Q6_4_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_5_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_7_Marks__c);
         System.assertEquals( 3 , objectCDM2.Q6_9_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_10_Marks__c);
         System.assertEquals( 3 , objectCDM2.Q6_11_Marks__c);
         System.assertEquals( 1 , objectCDM2.Q6_12_Marks__c);
         System.assertEquals( 5 , objectCDM2.X6_Options_that_fit_into_Industry__c);
         System.assertEquals( 1 , objectCDM2.X5_Confident_about_chosen_career__c);
         */
     }
    
    @isTest
    public static void test_calculateMarksForm(){
        Test.startTest(); 

        Contact objCon = new Contact(LastName = 'Test Contact 1', Grade_9_Barcode__c = '1234567890');
        Insert objCon ;

        CDM2__c objCDM2 = new CDM2__c();
        objCDM2.Student__c = objCon.Id;
        objCDM2.Barcode__c = '1234567890';
        objCDM2.Q6_1__c = 'A,C,D,E,G';
        objCDM2.Q6_2__c = 'A,D,E,G,H';
        objCDM2.Q6_3__c = 'A,C,E,F,G';
        objCDM2.Q6_4__c = 'B,D,E,F,H';
        objCDM2.Q6_5__c = 'A,B,D,F,H';
        objCDM2.Q6_6__c = 'A,B,D,E,G';
        objCDM2.Q6_7__c = 'A,B,D,E,H';
        objCDM2.Q6_8__c = 'A,B,D,E,G';
        objCDM2.Q6_9__c = 'A,B,D,E,G';
        objCDM2.Q6_10__c = 'B,D,E,F,G';
        objCDM2.Q6_11__c = 'A,B,C,E,H';
        objCDM2.Q6_12__c = 'A,B,C,D,G';
        objCDM2.Created_from_Form__c = true; 
        //List<CDM2__c> cdm2List = new List<CDM2__c>{objCDM2};
        //Insert cdm2List; 
        Insert objCDM2;
        
        
        List<Contact> conList = [SELECT Id, Name FROM Contact WHERE LastName LIKE '%Test Student%'];
        
        List<CDM2__c> omrList = New List<CDM2__c>{
            new CDM2__c(Student__c = conList[0].Id, Barcode__c = '2103649800', Q6_1__c = 'A,C,D,E,G'),
                new CDM2__c(Student__c = conList[0].Id, Barcode__c = '2103649810', Q6_1__c = 'A,C,D,E,G'),
                new CDM2__c(Student__c = conList[0].Id, Barcode__c = '2103649820', Q6_1__c = 'A,C,D,E,G'),
                new CDM2__c(Student__c = conList[0].Id, Barcode__c = '2103649841', Q6_1__c = 'A,C,D,E,G'),
                new CDM2__c(Student__c = conList[0].Id, Barcode__c = '2103649000', Q6_1__c = 'A,C,D,E,G', Q5__c = 'A')
                };
        Insert omrList;

        //cdm2TriggerHandler.populateStudentOnCDM2(cdm2List);
        cdm2TriggerHandler.populateStudentOnCDM2(omrList);
        cdm2TriggerHandler.calculateMarks('Q6_', 'X6_Options_that_fit_into_Industry__c', 12, objCDM2, objCDM2);
        Test.stopTest();
    }       
}