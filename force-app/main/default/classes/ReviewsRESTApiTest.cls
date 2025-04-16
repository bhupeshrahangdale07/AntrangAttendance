@isTest
public class ReviewsRESTApiTest {
    
    @isTest
    static void validateReviewsRESTApiTest(){
          Reviews__c  rev = new Reviews__c();
        
           rev.Description__c = 'Test';
           rev.URL__c = 'http://dummy.restapiexample.com/api/v1/create';
           rev.Name='test';
           
           insert rev;
       
         String Endpoint = URL.getSalesforceBaseUrl().toExternalForm() + '/apexrest/placements/reviews?fromdate=2019-09-11&todate=2019-12-01';
         CalloutMock accTokenRes = new CalloutMock(Endpoint,200,'OK','{"result": "Sucess","message": "Record(s) found.","reviews": [{"url": null,"title": "test31","opportunity_unique_id": null,"opportunity": null,"id": "'+rev.id+'","description": null,"add_posted_on_date": "2019-10-31 15:52:36","account": null }]}', new map < string, string > {'Content-Type' => 'application/json'});
         Test.setMock(HttpCalloutMock.class, accTokenRes);
        Test.startTest();
        
       RestResponse res = new RestResponse();
       RestRequest req = new RestRequest();
       
        req.requestUri = '/services/apexrest/placements/reviews';
        Date d = System.today();
        Date d1 = System.today().adddays(1);
        req.params.put('fromdate', String.valueOf(d));
        req.params.put('todate', String.valueOf(d1));
        req.httpMethod = 'GET';
          
        RestContext.request = req;
        RestContext.response= res;
        
       ReviewsRESTApi.findallreviews();
        delete rev;
       ReviewsRESTApi.findallreviews();
        
        Test.stopTest();            
    }

}