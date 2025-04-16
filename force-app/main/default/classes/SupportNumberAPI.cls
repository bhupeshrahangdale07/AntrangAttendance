@RestResource(urlMapping = '/placements/SupportNumbers/*')
global class SupportNumberAPI {
    
  @HttpGet
 global static void SupportNumbers() {
     RestRequest req = RestContext.request;
     RestResponse res = RestContext.response;
     res.addHeader('Content-Type', 'application/json');
     string jsonResponse = '';
     List < AntarangSetting__c > Customsetting = new List < AntarangSetting__c > ();
     string strsoql = 'Select id,Placement_Team__c,Support_Number__c from AntarangSetting__c ';
     Customsetting = Database.query(strsoql);
     system.debug('Customsetting@@@' + Customsetting);
     if (Customsetting.size() > 0) {
         List < wrpNumbers > lst = new List < wrpNumbers > ();
         for (AntarangSetting__c CS: Customsetting) {
             wrpNumbers w = new wrpNumbers();
             w.Placement_Team = CS.Placement_Team__c;
             w.Support_Number = CS.Support_Number__c;
             lst.add(w);
         }

         res.statusCode = 200;
         jsonResponse = JSON.serialize(lst);
     } else {
         res.statusCode = 200;
         jsonResponse = '{"result": "Error","message":"No Phone Number Available."}';
         if (jsonResponse.length() > 131000) {
             jsonResponse = jsonResponse.left(131000);
         }
         Log__c log = CatchLogs.createLog('Error', '', 0, 0, '', 'No Phone number records.', jsonResponse);
         insert log;
     }

     res.responseBody = blob.valueOf(jsonResponse);
     return;
 }
    
    public class wrpNumbers{
        public string Placement_Team{get;set;}
        public string Support_Number{get;set;}  
   
    }
}