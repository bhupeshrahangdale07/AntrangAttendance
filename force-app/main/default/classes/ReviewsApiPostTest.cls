@isTest(SeeAllData=false)
public class ReviewsApiPostTest {
    
    @isTest
    static void ValidateReviewsApiPostTest(){
        
        RestResponse res = new RestResponse();
        RestRequest req = new RestRequest();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        
        
        Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
        insert acc;
        
        Contact con =new Contact();
        con.FirstName='Test12';
        con.LastName='LN';
        con.UID__c = '123';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CR_Student').getRecordTypeId();
        con.RecordTypeId=RecordTypeIdContact;
        insert con;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
        Opportunity__c  opp = new Opportunity__c();
        opp.name = 'Test Opporunity';
        opp.recordtypeid = oppRecordTypeId;
        opp.Educational_Level__c = 'Graduate';
        opp.Type_of_opportunity__c = 'Education';
        opp.Account__c = acc.id;
        opp.Gender__c = 'Male only';
        opp.No_of_Openings__c = 1;
        opp.Working_Hours_Start_Time__c = Time.newInstance(7, 1, 1, 1);
        opp.Working_Hours_End_Time__c = Time.newInstance(15, 1, 1, 1);
        opp.Work_Days__c = 'Tuesday; Wednesday;';
        insert opp;
        opportunity__c oppt = [select id,Opportunity_Unique_Id__c from opportunity__c where id =: opp.id];
        
        Reviews__c  rev = new Reviews__c();
        rev.Opportunity__c = opp.id;
        rev.Description__c = 'Test';
        rev.URL__c = 'http://dummy.restapiexample.com/api/v1/create';
        rev.Name='test';
        
        
        String JsonMsg='{  "Detail": [{  "account": "'+acc.Id+'",  "description": "",  "opportunity": "'+opp.id+'",  "url": "test.com",  "rating": "2",  "student": "'+con.Id+'",  "azureid": "71296080-18D1-4F46-ADBC-14A7B4DACDC9"  },  {  "account": "'+acc.Id+'",  "description": "testbk1",  "opportunity": "'+opp.Id+'",  "url": "test.com",  "rating": "2",  "student": "'+con.Id+'",  "azureid": "71296080-18D1-4F46-ADBC-14A7B4DACDC6"  },  {  "account": "'+acc.Id+'",  "description": "testbk1",  "opportunity":"'+opp.Id+'" ,  "url": "test.com",  "rating": "2",  "student": "'+con.Id+'",  "azureid": "71296080-18D1-4F46-ADBC-14A7B4DACDC7"  }  ] }';
        string jsonresponse = '[{"SFid": "", "AzureId": "71296080-18D1-4F46-ADBC-14A7B4DACDC9" ,"status": "Success","message": ""},{"SFid": "","AzureId": "71296080-18D1-4F46-ADBC-14A7B4DACDC6", "status": "Success","message": ""},{"SFid": "","AzureId": "71296080-18D1-4F46-ADBC-14A7B4DACDC7" ,"status": "Success","message": ""}]';
        system.debug(JsonMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        req.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/placements/review';
        req.httpMethod = 'post';
        req.requestBody = Blob.valueof(JsonMsg);
        
        Test.StartTest();    
        ReviewsApiPost.FindallReviews();
        res.responseBody =Blob.valueof(jsonresponse);
        
        Test.stopTest();            
    }
    
    @isTest
    static void ValidateReviewsApiPostTest1(){
        
        
        RestResponse res = new RestResponse();
        RestRequest req = new RestRequest();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        
        
        Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
        insert acc;
        
        Contact con =new Contact();
        con.FirstName='Test12';
        con.LastName='LN';
        con.UID__c = '123';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CR_Student').getRecordTypeId();
        con.RecordTypeId=RecordTypeIdContact;
        insert con;
        
        /*Id oppRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
        Opportunity__c  opp = new Opportunity__c();
        opp.name = 'Test Opporunity';
        opp.recordtypeid = oppRecordTypeId;
        opp.Educational_Level__c = 'Graduate';
        opp.Type_of_opportunity__c = 'Education';
        opp.Account__c = acc.id;
        opp.Gender__c = 'Male';
        opp.No_of_Openings__c = 1;
        opp.Working_Hours_Start_Time__c = Time.newInstance(7, 1, 1, 1);
        opp.Working_Hours_End_Time__c = Time.newInstance(15, 1, 1, 1);
        opp.Work_Days__c = 'Tuesday; Wednesday;';
        insert opp;*/
        
        Reviews__c  rev = new Reviews__c();
        // rev.Opportunity__c = opp.id;
        rev.Description__c = 'Test';
        rev.URL__c = 'http://dummy.restapiexample.com/api/v1/create';
        rev.Name='test';
        
        
        String JsonMsg='{  "Detail": [{  "account": "",  "description": "",  "opportunity": "",  "url": "test.com",  "rating": "2",  "student": "",  "azureid": ""  },{"account": "",  "description": "testbk1",  "opportunity": "",  "url": "test.com",  "rating": "2",  "student": "",  "azureid": ""  },  {  "account": "",  "description": "testbk1",  "opportunity": "",  "url": "test.com",  "rating": "2",  "student": "",  "azureid": "" }]}';
        string jsonresponse = '[{"Status": "fail","SFid": null,"Message": "Atleast One Field Should be Populated from Account,Opportunity,Student","Azureid": null}';
        system.debug(JsonMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        req.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/placements/review';
        req.httpMethod = 'post';
        req.requestBody = Blob.valueof(JsonMsg);
        
        Test.StartTest();    
        ReviewsApiPost.FindallReviews();
        res.responseBody =Blob.valueof(jsonresponse);
        
        
        Test.stopTest();            
    }
    
    
    //Invalid data to exceute Exception Code
    @isTest
    static void ValidateReviewsApiPostTest2(){
        
        
        RestResponse res = new RestResponse();
        RestRequest req = new RestRequest();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        
        
        Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
        insert acc;
        
        Contact con =new Contact();
        con.FirstName='Test12';
        con.LastName='LN';
        con.UID__c = '123';
        Id RecordTypeIdContact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CR_Student').getRecordTypeId();
        con.RecordTypeId=RecordTypeIdContact;
        insert con;
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Employment').getRecordTypeId();
        Opportunity__c  opp = new Opportunity__c();
        opp.name = 'Test Opporunity';
        opp.recordtypeid = oppRecordTypeId;
        opp.Educational_Level__c = 'Graduate';
        opp.Type_of_opportunity__c = 'Education';
        opp.Account__c = acc.id;
        opp.Gender__c = 'Male only';
        opp.No_of_Openings__c = 1;
        opp.Working_Hours_Start_Time__c = Time.newInstance(7, 1, 1, 1);
        opp.Working_Hours_End_Time__c = Time.newInstance(15, 1, 1, 1);
        opp.Work_Days__c = 'Tuesday; Wednesday;';
        insert opp;
        opportunity__c oppt = [select id,Opportunity_Unique_Id__c from opportunity__c where id =: opp.id];
        
        Reviews__c  rev = new Reviews__c();
        rev.Opportunity__c = opp.id;
        rev.Description__c = 'Test';
        rev.URL__c = 'http://dummy.restapiexample.com/api/v1/create';
        rev.Name='test';
        
        
        String JsonMsg='{  "Detail": [{  "account": "1234556777744",  "description": "",  "opportunity": null,  "url": "test.com",  "rating": "2",  "student": null,  "azureid": "71296080-18D1-4F46-ADBC-14A7B4DACDC9"  },  {  "account": "'+acc.Id+'",  "description": "testbk1",  "opportunity": "'+opp.Id+'",  "url": "test.com",  "rating": "2",  "student": "'+con.Id+'",  "azureid": "71296080-18D1-4F46-ADBC-14A7B4DACDC6"  },  {  "account": "'+acc.Id+'",  "description": "testbk1",  "opportunity":"'+opp.Id+'" ,  "url": "test.com",  "rating": "2",  "student": "'+con.Id+'",  "azureid": "71296080-18D1-4F46-ADBC-14A7B4DACDC7"  }  ] }';
        string jsonresponse = '[{"SFid": "", "AzureId": "71296080-18D1-4F46-ADBC-14A7B4DACDC9" ,"status": "Success","message": ""},{"SFid": "","AzureId": "71296080-18D1-4F46-ADBC-14A7B4DACDC6", "status": "Success","message": ""},{"SFid": "","AzureId": "71296080-18D1-4F46-ADBC-14A7B4DACDC7" ,"status": "Success","message": ""}]';
        system.debug(JsonMsg);
        
        RestContext.request = req;
        RestContext.response= res;
        
        req.requestUri = URL.getSalesforceBaseUrl().toExternalForm() + '/services/apexrest/placements/review';
        req.httpMethod = 'post';
        req.requestBody = Blob.valueof(JsonMsg);
        
        Test.StartTest();    
        ReviewsApiPost.FindallReviews();
        res.responseBody =Blob.valueof(jsonresponse);
        
        Test.stopTest();          
    }
    
}