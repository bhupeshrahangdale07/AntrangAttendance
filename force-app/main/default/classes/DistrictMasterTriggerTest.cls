@isTest
public class DistrictMasterTriggerTest {
	@testSetup
    public static void setupData(){
        
    }
    
    @isTest
    public static void testDistrictMasterInsert(){
        Session_Mapping__c sm = new Session_Mapping__c();
        sm.District__c = 'Mumbai';
        sm.Name = 'Mumbai Session';
        sm.Session_Number__c = 0;
        sm.Grade__c = 'Grade 9';
        sm.Description__c = 'description';
        insert sm;
        
        State_Govt_Body_Level__c st = new State_Govt_Body_Level__c();
        st.Name = 'GOA';
        insert st;
        
        District_Master__c dm = new District_Master__c();
        dm.Name = 'Mumbai';
        dm.State__c = st.id;
        insert dm;
    }
}