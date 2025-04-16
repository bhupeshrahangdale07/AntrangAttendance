@isTest
public class ContactRestApiTest {
    
    @isTest
    static void ValidateConatctRESTApiTest(){
        Test.startTest();
        
       RestResponse res = new RestResponse();
       RestRequest req = new RestRequest();
        
        
       Contact con =new Contact();
        con.FirstName='Test12';
        con.LastName='LN';
        con.Reason_for_career_linkage_unavilability__c = 'Migrated';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CR_Student').getRecordTypeId();
        con.RecordTypeId=RecordTypeIdContact;
        insert con;
        req.requestUri = URL.getOrgDomainURL().toExternalForm() +'/services/apexrest/placements/students';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        /*req.addParameter('fromdate', '2020-02-01');
        req.addParameter('todate', '2020-02-07');*/
        
        ContactRESTApi.stripJsonNulls('Test');
        ContactRESTApi.findallcontacts();
        delete con;
        ContactRESTApi.findallcontacts();
        
        Test.stopTest();            
    }

}