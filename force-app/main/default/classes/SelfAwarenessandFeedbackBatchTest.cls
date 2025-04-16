@isTest
public class SelfAwarenessandFeedbackBatchTest {

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
        
        SelfAwarenessandFeedbackBatch s = new SelfAwarenessandFeedbackBatch();
        s.execute(null);
    }
    
}