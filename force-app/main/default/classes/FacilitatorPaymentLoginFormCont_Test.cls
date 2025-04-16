@isTest
public class FacilitatorPaymentLoginFormCont_Test {
    
    private static String districtId;
    private static String testEmail = 'test@example.com';
    private static String testPassword = 'testPassword';
    
    @testSetup
    public static void testData() {
        State_Govt_Body_Level__c state = new State_Govt_Body_Level__c(Name = 'Test State');
        insert state;
        
        District_Master__c district = new District_Master__c(Name = 'TDistrict', State__c = state.id, 
                                                             Payout_Supervisor_Username__c = testEmail,
                                                             Payout_Supervisor_Password__c = testPassword,
                                                             Payout_Admin_Password__c = testPassword,
                                                             Payout_Admin_Username__c = testEmail);
        insert district;
        districtId = district.Id;
    }
    
    @IsTest
    public static void testMethod1() {
            Test.startTest();
			Map<String, Object> result1 = FacilitatorPaymentLoginFormController.checkEmailExist(testEmail, testPassword);
        	Map<String, Object> result2 = FacilitatorPaymentLoginFormController.checkEmailExist(testEmail, 'RandomPassword');
            Map<String, Object> result3 = FacilitatorPaymentLoginFormController.checkEmailExist('random@invalid.email', 'RandomPassword');
            Test.stopTest();           

    }
}