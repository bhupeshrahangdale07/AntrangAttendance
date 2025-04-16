@isTest
public class SupportNumberAPI_Test {

    public static testMethod void SupportTest() {
        AntarangSetting__c setting = new AntarangSetting__c();   
        setting.Placement_Team__c ='7406679476';
        setting.Support_Number__c = '7506077529';
        insert setting;
        
         RestResponse res = new RestResponse();
         RestRequest req = new RestRequest();
         
        req.requestUri = URL.getOrgDomainURL().toExternalForm() +'/services/apexrest/placements/SupportNumbers/*';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        SupportNumberAPI.SupportNumbers();
        Test.stopTest();
    }

}