@isTest
public class CustomLookupControllerTest {

    
    @isTest
    public static void testCustomLookup(){
        Account acc = new Account();
        acc.Name = 'Test acc';
        Insert acc;
        
        Test.startTest();
        CustomLookupController.fetchLookupData('','Account','');
        CustomLookupController.fetchDefaultRecord(acc.Id,'Account','');
        
        Test.stopTest();
        
    }
}