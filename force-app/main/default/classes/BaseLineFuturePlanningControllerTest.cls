@isTest 
public class BaseLineFuturePlanningControllerTest {
	
    @testSetup
    public static void setupData(){
        Contact objCon = new Contact(LastName = 'Test Contact 1', Grade_9_Barcode__c = '1234567890');
        insert objCon ;
        
        Future_Planning__c objFuturePlan = new Future_Planning__c(Student__c = objCon.Id, Barcode__c = '1234567890',Q_17__c = 'A',Q_18_1__c='A',Q_18_2__c='A',
                                                                  Q_18_4__c='A',Q_18_6__c='A',Q_18_8__c='A',Q_18_10__c='A',Q_18_11__c='A',
                                                                  Q_19__c ='C',Q_20__c='D',Q_21__c='A',Q_22__c='A');
        insert objFuturePlan ;
    }
    
    @isTest
    public static void getRecordAptTest(){
        BaseLineFuturePlanningController.getRecordApt([Select id from contact limit 1].Id);
    }
    
    @isTest
    public static void submitNCalculateTest(){
        BaseLineFuturePlanningController.submitNCalculate([Select id from Future_Planning__c limit 1].Id);
    }
    
    @isTest
    public static void getObjectIdTest(){
        BaseLineFuturePlanningController.getObjectId([Select id from contact limit 1].Id, 'Future_Planning__c');
    }
    
    @isTest
    public static void autoSaveDataTest(){
        BaseLineFuturePlanningController.autoSaveData([Select id from contact limit 1].Id, '*', '*', '*', '*', '*', '*', '*', '*', '*', '*',
                                                      '*', '*', '*', '*', '*', '*', true, 'Grade 9', 'Form v2', 'English');
    }
}