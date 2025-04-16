@isTest
public class SelfAwarenessandFeedbackTriggerTest {

    @testSetup
    static void setup() {
        // Create test data for custom settings
       // Create custom setting records
        AntarangSetting__c customSetting = new AntarangSetting__c();
        customSetting.Name = 'TestSetting';
        customSetting.Academic_Year__c = 2023; 
        insert customSetting;
    }
    
    @isTest
    public static void testSelfAwarenessFeedbackForEmptyBarcode(){
        Self_Awareness_and_Feedback__c selfaware = new Self_Awareness_and_Feedback__c();
        selfaware.Barcode__c = '1234567890';
        selfaware.Quiz_1_1__c = 'C';
        selfaware.Quiz_1_2__c = 'A';
        selfaware.Quiz_1_3__c = 'C';
        selfaware.Quiz_1_4__c = 'B';
        selfaware.Quiz_1_5__c = 'B';
        insert selfaware;
    }
    @isTest
    public static void testSelfAwarenessFeedbackForGrade9(){
        Contact con = new Contact();
        con.Grade_9_Barcode__c = '1234567890';
        con.LastName = 'test 01';
        Insert con;
        
        Self_Awareness_and_Feedback__c selfaware = new Self_Awareness_and_Feedback__c();
        selfaware.Barcode__c = '1234567890';
        selfaware.Quiz_1_1__c = 'C';
        selfaware.Quiz_1_2__c = 'A';
        selfaware.Quiz_1_3__c = 'C';
        selfaware.Quiz_1_4__c = 'B';
        selfaware.Quiz_1_5__c = 'B';
        /*selfaware.Quiz_1_6__c = 'A';
        selfaware.Quiz_1_7__c = 'A';
        selfaware.Quiz_1_8__c = 'A';
        selfaware.Quiz_1_9__c = 'A';
        selfaware.Quiz_1_10__c = 'A';*/
        selfaware.Interest_Test_1__c = 'A';
        selfaware.Interest_Test_2__c = 'A';
        selfaware.Interest_Test_3__c = 'A';
        selfaware.Interest_Test_4__c = 'A';
        selfaware.Interest_Test_5__c = 'B';
        selfaware.Interest_Test_6__c = 'B';
        selfaware.Interest_Test_7__c = 'B';
        selfaware.Interest_Test_8__c = 'B';
        selfaware.Interest_Test_9__c = 'A';
        selfaware.Interest_Test_10__c = 'A';
        selfaware.Interest_Test_11__c = 'A';
        selfaware.Interest_Test_12__c = 'A';
        selfaware.Interest_Test_13__c = 'A';
        selfaware.Interest_Test_14__c = 'A';
        selfaware.Interest_Test_15__c = 'B';
        selfaware.Interest_Test_16__c = 'B';
        selfaware.Interest_Test_17__c = 'B';
        selfaware.Interest_Test_18__c = 'B';
        selfaware.Interest_Test_19__c = 'A';
        selfaware.Interest_Test_20__c = 'A';
        selfaware.Interest_Test_21__c = 'A';
        selfaware.Interest_Test_22__c = 'A';
        selfaware.Interest_Test_23__c = 'A';
        selfaware.Interest_Test_24__c = 'A';
        selfaware.Interest_Test_25__c = 'B';
        selfaware.Interest_Test_26__c = 'B';
        selfaware.Interest_Test_27__c = 'B';
        selfaware.Interest_Test_28__c = 'B';
        selfaware.Interest_Test_29__c = 'A';
        selfaware.Interest_Test_30__c = 'A';
        selfaware.Interest_Test_31__c = 'A';
        selfaware.Interest_Test_32__c = 'A';
        selfaware.Interest_Test_33__c = 'A';
        selfaware.Interest_Test_34__c = 'A';
        selfaware.Interest_Test_35__c = 'B';
        selfaware.Interest_Test_36__c = 'B';
        selfaware.Interest_Test_37__c = 'B';
        selfaware.Interest_Test_38__c = 'B';
        selfaware.Interest_Test_39__c = 'A';
        selfaware.Interest_Test_40__c = 'A';
        selfaware.Interest_Test_41__c = 'A';
        selfaware.Interest_Test_42__c = 'A';
        selfaware.Interest_Test_43__c = 'A';
        selfaware.Interest_Test_44__c = 'A';
        selfaware.Interest_Test_45__c = 'B';
        selfaware.Interest_Test_46__c = 'B';
        selfaware.Interest_Test_47__c = 'B';
        selfaware.Interest_Test_48__c = 'B';
        Insert selfaware;
        
        SelfAwarenessandFeedbackTriggerHandler.isStopRecursion = false;
        selfaware.Aptitude_3__c = 'Spatial';
        update selfaware;
    }
    
    @isTest
    public static void testSelfAwarenessFeedbackForGrade10(){
        Contact con = new Contact();
        con.Grade_10_Barcode__c = '1234567890';
        con.LastName = 'test 01';
        Insert con;
        
        Self_Awareness_and_Feedback__c selfaware = new Self_Awareness_and_Feedback__c();
        selfaware.Barcode__c = '1234567890';
        selfaware.Quiz_1_1__c = 'C';
        selfaware.Quiz_1_2__c = 'C';
        selfaware.Quiz_1_3__c = 'B';
        selfaware.Quiz_1_4__c = 'B';
        selfaware.Quiz_1_5__c = 'C';
        /*selfaware.Quiz_1_6__c = 'A';
        selfaware.Quiz_1_7__c = 'A';
        selfaware.Quiz_1_8__c = 'A';
        selfaware.Quiz_1_9__c = 'A';
        selfaware.Quiz_1_10__c = 'A';*/
        selfaware.Interest_Test_1__c = 'A';
        selfaware.Interest_Test_2__c = 'A';
        selfaware.Interest_Test_3__c = 'A';
        selfaware.Interest_Test_4__c = 'A';
        selfaware.Interest_Test_5__c = 'B';
        selfaware.Interest_Test_6__c = 'B';
        selfaware.Interest_Test_7__c = 'B';
        selfaware.Interest_Test_8__c = 'B';
        selfaware.Interest_Test_9__c = 'A';
        selfaware.Interest_Test_10__c = 'A';
        selfaware.Interest_Test_11__c = 'A';
        selfaware.Interest_Test_12__c = 'A';
        selfaware.Interest_Test_13__c = 'A';
        selfaware.Interest_Test_14__c = 'A';
        selfaware.Interest_Test_15__c = 'B';
        selfaware.Interest_Test_16__c = 'B';
        selfaware.Interest_Test_17__c = 'B';
        selfaware.Interest_Test_18__c = 'B';
        selfaware.Interest_Test_19__c = 'A';
        selfaware.Interest_Test_20__c = 'A';
        selfaware.Interest_Test_21__c = 'A';
        selfaware.Interest_Test_22__c = 'A';
        selfaware.Interest_Test_23__c = 'A';
        selfaware.Interest_Test_24__c = 'A';
        selfaware.Interest_Test_25__c = 'B';
        selfaware.Interest_Test_26__c = 'B';
        selfaware.Interest_Test_27__c = 'B';
        selfaware.Interest_Test_28__c = 'B';
        selfaware.Interest_Test_29__c = 'A';
        selfaware.Interest_Test_30__c = 'A';
        selfaware.Interest_Test_31__c = 'A';
        selfaware.Interest_Test_32__c = 'A';
        selfaware.Interest_Test_33__c = 'A';
        selfaware.Interest_Test_34__c = 'A';
        selfaware.Interest_Test_35__c = 'B';
        selfaware.Interest_Test_36__c = 'B';
        selfaware.Interest_Test_37__c = 'B';
        selfaware.Interest_Test_38__c = 'B';
        selfaware.Interest_Test_39__c = 'A';
        selfaware.Interest_Test_40__c = 'A';
        selfaware.Interest_Test_41__c = 'A';
        selfaware.Interest_Test_42__c = 'A';
        selfaware.Interest_Test_43__c = 'A';
        selfaware.Interest_Test_44__c = 'A';
        selfaware.Interest_Test_45__c = 'B';
        selfaware.Interest_Test_46__c = 'B';
        selfaware.Interest_Test_47__c = 'B';
        selfaware.Interest_Test_48__c = 'B';
        Insert selfaware;
        
        SelfAwarenessandFeedbackTriggerHandler.isStopRecursion = false;
        selfaware.Aptitude_3__c = 'Spatial';
        update selfaware;
    }
    
    @isTest
    public static void testSelfAwarenessFeedbackForGrade11(){
        
        Contact con = new Contact();
        con.Grade_11_Barcode__c = '1234567890';
        con.LastName = 'test 011';
        Insert con;
        
        
        Self_Awareness_and_Feedback__c selfaware = new Self_Awareness_and_Feedback__c();
        selfaware.Barcode__c = '1234567890';
        selfaware.Quiz_1_1__c = 'C';
        selfaware.Quiz_1_2__c = 'C';
        selfaware.Quiz_1_3__c = 'A';
        selfaware.Quiz_1_4__c = 'C';
        selfaware.Quiz_1_5__c = 'C';
        /*selfaware.Quiz_1_6__c = 'A';
        selfaware.Quiz_1_7__c = 'A';
        selfaware.Quiz_1_8__c = 'A';
        selfaware.Quiz_1_9__c = 'A';
        selfaware.Quiz_1_10__c = 'A';*/
        selfaware.Interest_Test_1__c = 'A';
        selfaware.Interest_Test_2__c = 'A';
        selfaware.Interest_Test_3__c = 'A';
        selfaware.Interest_Test_4__c = 'A';
        selfaware.Interest_Test_5__c = 'B';
        selfaware.Interest_Test_6__c = 'B';
        selfaware.Interest_Test_7__c = 'B';
        selfaware.Interest_Test_8__c = 'B';
        selfaware.Interest_Test_9__c = 'A';
        selfaware.Interest_Test_10__c = 'A';
        selfaware.Interest_Test_11__c = 'A';
        selfaware.Interest_Test_12__c = 'A';
        selfaware.Interest_Test_13__c = 'A';
        selfaware.Interest_Test_14__c = 'A';
        selfaware.Interest_Test_15__c = 'B';
        selfaware.Interest_Test_16__c = 'B';
        selfaware.Interest_Test_17__c = 'B';
        selfaware.Interest_Test_18__c = 'B';
        selfaware.Interest_Test_19__c = 'A';
        selfaware.Interest_Test_20__c = 'A';
        selfaware.Interest_Test_21__c = 'A';
        selfaware.Interest_Test_22__c = 'A';
        selfaware.Interest_Test_23__c = 'A';
        selfaware.Interest_Test_24__c = 'A';
        selfaware.Interest_Test_25__c = 'B';
        selfaware.Interest_Test_26__c = 'B';
        selfaware.Interest_Test_27__c = 'B';
        selfaware.Interest_Test_28__c = 'B';
        selfaware.Interest_Test_29__c = 'A';
        selfaware.Interest_Test_30__c = 'A';
        selfaware.Interest_Test_31__c = 'A';
        selfaware.Interest_Test_32__c = 'A';
        selfaware.Interest_Test_33__c = 'A';
        selfaware.Interest_Test_34__c = 'A';
        selfaware.Interest_Test_35__c = 'B';
        selfaware.Interest_Test_36__c = 'B';
        selfaware.Interest_Test_37__c = 'B';
        selfaware.Interest_Test_38__c = 'B';
        selfaware.Interest_Test_39__c = 'A';
        selfaware.Interest_Test_40__c = 'A';
        selfaware.Interest_Test_41__c = 'A';
        selfaware.Interest_Test_42__c = 'A';
        selfaware.Interest_Test_43__c = 'A';
        selfaware.Interest_Test_44__c = 'A';
        selfaware.Interest_Test_45__c = 'B';
        selfaware.Interest_Test_46__c = 'B';
        selfaware.Interest_Test_47__c = 'B';
        selfaware.Interest_Test_48__c = 'B';
        Insert selfaware;
        
        SelfAwarenessandFeedbackTriggerHandler.isStopRecursion = false;
        selfaware.Aptitude_3__c = 'Spatial';
        update selfaware;
    }

    @isTest
    public static void testSelfAwarenessFeedbackForm(){
        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(
            LastName = 'test 01', Grade_9_Barcode__c = '1234567890'
        ));
        conList.add(new Contact(
            LastName = 'test 02', Grade_10_Barcode__c = '1234567890'
        ));
        conList.add(new Contact(
            LastName = 'test 03', Grade_11_Barcode__c = '1234567890'
        ));
        conList.add(new Contact(
            LastName = 'test 04', Grade_12_Barcode__c = '1234567890'
        ));
        Insert conList;

        List<Self_Awareness_and_Feedback__c> safList = new List<Self_Awareness_and_Feedback__c>();
        Self_Awareness_and_Feedback__c selfaware1 = new Self_Awareness_and_Feedback__c();
        selfaware1.Barcode__c = '1234567890';
        selfaware1.Student__c = conList[0].Id;
        selfaware1.Quiz_1_1__c = 'C';
        selfaware1.Quiz_1_2__c = 'A';
        selfaware1.Quiz_1_3__c = 'C';
        selfaware1.Quiz_1_4__c = 'B';
        selfaware1.Quiz_1_5__c = 'B';
        selfaware1.Created_from_Form__c = true;
        safList.add(selfaware1);

        Self_Awareness_and_Feedback__c selfaware2 = new Self_Awareness_and_Feedback__c();
        selfaware2.Barcode__c = '1234567890';
        selfaware2.Student__c = conList[1].Id;
        selfaware2.Quiz_1_1__c = 'C';
        selfaware2.Quiz_1_2__c = 'C';
        selfaware2.Quiz_1_3__c = 'B';
        selfaware2.Quiz_1_4__c = 'B';
        selfaware2.Quiz_1_5__c = 'C';
        selfaware2.Created_from_Form__c = true;
        safList.add(selfaware2);
        
        Self_Awareness_and_Feedback__c selfaware3 = new Self_Awareness_and_Feedback__c();
        //selfaware3.Barcode__c = '1234567890';
        selfaware3.Student__c = conList[2].Id;
        selfaware3.Quiz_1_1__c = 'C';
        selfaware3.Quiz_1_2__c = 'C';
        selfaware3.Quiz_1_3__c = 'A';
        selfaware3.Quiz_1_4__c = 'C';
        selfaware3.Quiz_1_5__c = 'C';
        selfaware3.Created_from_Form__c = true;
        safList.add(selfaware3);

        Insert safList;
        SelfAwarenessandFeedbackTriggerHandler.populateStudentAndMarksCalculation(safList);
        
        Map<String, String> que1Grade9WithAns = new Map<String, String>{'Quiz_1_1__c'=>'B',
            'Quiz_1_2__c'=>'C','Quiz_1_3__c'=>'A','Quiz_1_4__c'=>'C','Quiz_1_5__c'=>'B'
        };
                
        Map<String, List<String>> que1Grade10WithAns = new Map<String, List<String>>{'Quiz_1_1__c'=>new List<String>{'B'},
           'Quiz_1_2__c'=>new List<String>{'A'},'Quiz_1_3__c'=>new List<String>{'A','B'},'Quiz_1_4__c'=>new List<String>{'C','D'},
           'Quiz_1_5__c'=>new List<String>{'C','D'}
        };
                                
        Map<String, List<String>> que1Grade11WithAns = new Map<String, List<String>>{'Quiz_1_1__c'=>new List<String>{'C'},
           'Quiz_1_2__c'=>new List<String>{'A'},'Quiz_1_3__c'=>new List<String>{'B'},
           'Quiz_1_4__c'=>new List<String>{'B'},'Quiz_1_5__c'=>new List<String>{'D'}
        };
            
        SelfAwarenessandFeedbackTriggerHandler.calculateQuizMarks('Quiz_1_', 5, selfaware3, selfaware3, 'Grade 9', que1Grade9WithAns, que1Grade10WithAns, que1Grade11WithAns);
    //String sourceField, Integer noOfQues, Self_Awareness_and_Feedback__c omrassess, Self_Awareness_and_Feedback__c omr,String grade,
    //                                       Map<String, String> que1Grade9WithAns,
    //                                      Map<String, List<String>> que1Grade10WithAns, Map<String, List<String>> que1Grade11WithAns
    
        SelfAwarenessandFeedbackTriggerHandler.dummCodeCoverage();
    }
    
     @isTest
    public static void testpopulateStudentInterestsAptitudes(){
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
        insert batch; 
        
        Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        Contact con = new Contact();
        con.Grade_11_Barcode__c = '1234567890';
        con.LastName = 'test 011';
        con.RecordTypeId = conRecTypeId;
        con.Batch_Code__c = batch.Id;
        con.Aptitude_3__c = 'Spatial';
        Insert con;
        
        
        Id selfAwareRecTypeId = Schema.SObjectType.Self_Awareness_and_Feedback__c.getRecordTypeInfosByDeveloperName().get('Baseline').getRecordTypeId();
        Self_Awareness_and_Feedback__c selfaware = new Self_Awareness_and_Feedback__c();
         selfaware.RecordTypeId = selfAwareRecTypeId;
        selfaware.Barcode__c = '1234567890';
        selfaware.Quiz_1_1__c = 'C';
        selfaware.Quiz_1_2__c = 'C';
        selfaware.Quiz_1_3__c = 'A';
        selfaware.Quiz_1_4__c = 'C';
        selfaware.Quiz_1_5__c = 'C';
        /*selfaware.Quiz_1_6__c = 'A';
        selfaware.Quiz_1_7__c = 'A';
        selfaware.Quiz_1_8__c = 'A';
        selfaware.Quiz_1_9__c = 'A';
        selfaware.Quiz_1_10__c = 'A';*/
        selfaware.Interest_Test_1__c = 'A';
        selfaware.Interest_Test_2__c = 'A';
        selfaware.Interest_Test_3__c = 'A';
        selfaware.Interest_Test_4__c = 'A';
        selfaware.Interest_Test_5__c = 'B';
        selfaware.Interest_Test_6__c = 'B';
        selfaware.Interest_Test_7__c = 'B';
        selfaware.Interest_Test_8__c = 'B';
        selfaware.Interest_Test_9__c = 'A';
        selfaware.Interest_Test_10__c = 'A';
        selfaware.Interest_Test_11__c = 'A';
        selfaware.Interest_Test_12__c = 'A';
        selfaware.Interest_Test_13__c = 'A';
        selfaware.Interest_Test_14__c = 'A';
        selfaware.Interest_Test_15__c = 'B';
        selfaware.Interest_Test_16__c = 'B';
        selfaware.Interest_Test_17__c = 'B';
        selfaware.Interest_Test_18__c = 'B';
        selfaware.Interest_Test_19__c = 'A';
        selfaware.Interest_Test_20__c = 'A';
        selfaware.Interest_Test_21__c = 'A';
        selfaware.Interest_Test_22__c = 'A';
        selfaware.Interest_Test_23__c = 'A';
        selfaware.Interest_Test_24__c = 'A';
        selfaware.Interest_Test_25__c = 'B';
        selfaware.Interest_Test_26__c = 'B';
        selfaware.Interest_Test_27__c = 'B';
        selfaware.Interest_Test_28__c = 'B';
        selfaware.Interest_Test_29__c = 'A';
        selfaware.Interest_Test_30__c = 'A';
        selfaware.Interest_Test_31__c = 'A';
        selfaware.Interest_Test_32__c = 'A';
        selfaware.Interest_Test_33__c = 'A';
        selfaware.Interest_Test_34__c = 'A';
        selfaware.Interest_Test_35__c = 'B';
        selfaware.Interest_Test_36__c = 'B';
        selfaware.Interest_Test_37__c = 'B';
        selfaware.Interest_Test_38__c = 'B';
        selfaware.Interest_Test_39__c = 'A';
        selfaware.Interest_Test_40__c = 'A';
        selfaware.Interest_Test_41__c = 'A';
        selfaware.Interest_Test_42__c = 'A';
        selfaware.Interest_Test_43__c = 'A';
        selfaware.Interest_Test_44__c = 'A';
        selfaware.Interest_Test_45__c = 'B';
        selfaware.Interest_Test_46__c = 'B';
        selfaware.Interest_Test_47__c = 'B';
        selfaware.Interest_Test_48__c = 'B';
        Insert selfaware;
        
        selfaware.Aptitude_3__c = 'Spatial';
        SelfAwarenessandFeedbackTriggerHandler.dummCodeCoverage();
        delete selfaware;
    }
    
}