@RestResource(urlMapping = '/placements/reviews/*')
global class ReviewsRESTApi {

    @HttpGet
    global static void findallreviews() {

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');

        string fromdate = string.valueof(req.params.get('fromdate'));
        string todate = string.valueof(req.params.get('todate'));
        system.debug('fromdate' + fromdate);
        system.debug('todate' + todate);
        string jsonResponse = '';
        DateTime dtStart = DateTime.newInstanceGMT(Integer.valueOf(fromdate.split('-')[0]), Integer.valueOf(fromdate.split('-')[1]), Integer.valueOf(fromdate.split('-')[2]));
        DateTime dtEnd = DateTime.newInstanceGMT(Integer.valueOf(todate.split('-')[0]), Integer.valueOf(todate.split('-')[1]), Integer.valueOf(todate.split('-')[2]), 23, 59, 59);

        List < Reviews__c > lstreviews = new List < Reviews__c > ();
        string strsoql = 'select id, Account__c, Description__c, Opportunity__c, URL__c, LastModifiedDate,Azure_Id__c, Name, Opportunity__r.Opportunity_Unique_Id__c, Rating__c, Student__r.UID__c  from Reviews__c where ';
        if (fromdate != null && todate != null) {

            strsoql += 'LastModifiedDate >=: dtStart and LastModifiedDate <=: dtEnd';
        }
        lstreviews = Database.query(strsoql);
        system.debug('lstreviews@@@' + lstreviews);
        if (lstreviews.size() > 0) {
            List < wrpReviews > lst = new List < wrpReviews > ();
            for (Reviews__c r: lstreviews) {
                wrpReviews w = new wrpReviews();
                w.account = r.Account__c;
                w.description = r.Description__c;
                w.opportunity = r.Opportunity__c;
                w.url = r.URL__c;
                w.add_posted_on_date = string.valueOf(r.LastModifiedDate);
                w.title = r.Name;
                w.opportunity_unique_id = r.Opportunity__r.Opportunity_Unique_Id__c;
                w.id = r.id;
                w.rating = r.Rating__c;
                w.student = r.Student__r.UID__c;
                w.AzureID = r.Azure_Id__c;
                lst.add(w);
            }

            res.statusCode = 200;
            jsonResponse = '{"result": "Sucess","message":"Record(s) found.", "reviews":' + JSON.serialize(lst) + '}';
            //if (jsonResponse.length() > 131000) {
             //   jsonResponse = jsonResponse.left(131000);
            //}
           // Log__c log = CatchLogs.createLog('Info', '', lst.size(), 0, 'fromdate =' + fromdate + '/' + 'todate =' + todate + 'GetReviews', 'Record(s) found', jsonResponse);
           // insert log;

        } else {
            res.statusCode = 200;
            jsonResponse = '{"result": "Error","message":"No reviews records found."}';
            if (jsonResponse.length() > 131000) {
                jsonResponse = jsonResponse.left(131000);
            }
            Log__c log = CatchLogs.createLog('Error', '', 0, 0, 'fromdate =' + fromdate + '/' + 'todate =' + todate + 'GetReviews', 'No reviews records found', jsonResponse);
            insert log;
        }

        res.responseBody = blob.valueOf(jsonResponse);
        return;
    }
    
    public class wrpReviews{
        public string account{get;set;}
        public string description{get;set;}  
        public string opportunity{get;set;} 
        public string url{get;set;} 
        public string add_posted_on_date{get;set;} 
        public string title{get;set;} 
        public string opportunity_unique_id{get;set;} 
        public string id{get;set;} 
        public string rating{get;set;}
        public string student{get;set;}
        public string AzureID{get;set;}
        
    }
}