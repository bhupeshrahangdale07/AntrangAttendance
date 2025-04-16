@isTest
public class OmrLoginFormControllerTest {
	
    @isTest
    public static void test1(){
        AntarangSetting__c settings = AntarangSetting__c.getOrgDefaults();
        settings.Academic_Year__c = 2021;
        upsert settings custSettings__c.Id;
        
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai';
        sm.Name = 'Mumbai Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'test';
        insert sm;
        
        
         State_Govt_Body_Level__c state = new State_Govt_Body_Level__c(Name = 'Test State');
        insert state;
        
        District_Master__c district =  new District_Master__c(Name = 'Mumbai', State__c = state.id, 
                                      Payout_Supervisor_Username__c = '',
                                      Payout_Supervisor_Password__c = '',
                                      Payout_Admin_Password__c = '',
                                      Payout_Admin_Username__c = '',
                                      OMR_Submitter_Username__c = 'test@tt.tt',
                                      OMR_Submitter_Password__c='ttet');
        insert district;
        
        OmrLoginFormController.omrSubmitterLoginCheck('test@tt.tt', 'ttet');
        
    }
}