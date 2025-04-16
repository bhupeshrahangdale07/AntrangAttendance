@isTest(SeeAllData=false)
public class OpportunityAPIHandlerTest {
     static testMethod void TestOpportunityAPI() {
     AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();   
     setting.BaseApiUrl__c = 'http://dscareereadyapp.azurewebsites.net/api/apiuserlogin/validateapiuser';
     insert setting;
     system.debug('1*'+ setting);
         CalloutMock accTokenRes = new CalloutMock('http://dscareereadyapp.azurewebsites.net/api/apiuserlogin/validateapiuser',200,'OK','[{"authentication_token": "1D17830820B64487A26DAFEAF0974E57"}]', new map < string, string > {'Content-Type' => 'application/json'});
         Test.setMock(HttpCalloutMock.class, accTokenRes);
         Test.startTest();
         GenerateAccessToken.getAccessToken();
         
         Test.stopTest();

         
     }
      static testMethod void TestOpportunityAPI1(){
      map<id,Opportunity__c> opptyMap = new map<id,Opportunity__c>();  
      list<opportunity__c> lstoppty = new list<opportunity__c> ();
      AntarangSetting__c setting = new AntarangSetting__c();
      setting.BaseApiUrl__c = 'http://dscareereadyapp.azurewebsites.net/api/mastersync/insertupdatemaster';
      insert setting;
       system.debug('2*'+ setting);

        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();

         system.debug('3*'+ accRecordTypeId);
       Account acc = new Account(Name = 'Test Account', recordtypeid=accRecordTypeId);
       insert acc;
       
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId();
       Contact c = new Contact();
       c.lastname = 'test';
       c.recordtypeid = contactRecordTypeId;
       c.Gender__c = 'Male only';
       c.Education_Level__c = 'Graduate';
       c.Available_working_Hours_Start_Time__c =  Time.newInstance(8, 1, 1, 1);
       c.Available_working_Hours_Finish_Time__c = Time.newInstance(9, 1, 1, 1);
       c.Available_work_Days__c = 'Tuesday';
       c.AccountId = acc.id;
       c.UID__c = '2000';
       insert c;
       system.debug('4*'+ c);
       
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
       opp.Contact__c = c.id;
       opp.Payroll_details__c ='montly';
       opp.Salary_in_hand_monthly__c = 2000;
       insert opp;
       system.debug('5*'+ opp);
       lstoppty.add(opp);
       opptyMap.put(opp.id,opp);
      
      CalloutMock opptyapi = new CalloutMock(setting.BaseApiUrl__c,200,'OK','[{"response": "Opportunity Inserted successfully","StatusCode": "SUCCESS"}]',new map < string, string > {'Content-Type' => 'application/json'});
      Test.setMock(HttpCalloutMock.class, opptyapi);
      Test.startTest();
      OpportunityAPIHandler.OpportunityAPI(lstoppty,False,False,False,opptyMap);
      opp.Is_Opportunity_Closed__c = true;
      update opp;
      OpportunityAPIHandler.OpportunityAPI(lstoppty,False,False,False,opptyMap);
      Test.stopTest();
      
       /*delete opp;
      OpportunityAPIHandler.OpportunityAPI(lstoppty,False,False,False);*/
  
      }
      
      static testMethod void TestOpportunityAPI3() {
     AntarangSetting__c setting = new AntarangSetting__c();  
     setting.BaseApiUrl__c = 'http://dscareereadyapp.azurewebsites.net/api/apiuserlogin/validateapiuser';
     insert setting;
     system.debug('6*'+ setting);
     
         CalloutMock accTokenRes = new CalloutMock('',200,'OK','', new map < string, string > {'Content-Type' => 'application/json'});
         Test.setMock(HttpCalloutMock.class, accTokenRes);
         Test.startTest();
         GenerateAccessToken.getAccessToken();
         Test.stopTest();

         
     }
       static testMethod void testbatch() 
    {
       
           Account acc = new Account();
           acc.Name ='Name';
           insert acc;
        
        Test.startTest();

         GenerateAccessTokenbatch obj = new GenerateAccessTokenbatch();
         DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}