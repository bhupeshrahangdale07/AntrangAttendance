/*
created by Kandisatech
Description: Class is created to Review records in SF based on the Uid of opportunity and SF id of Student
*/
@RestResource(urlMapping = '/placements/review/*')
global class ReviewsApiPost {

    @HttpPost
    global static void FindallReviews() {
        RestRequest req = RestContext.request;
        system.debug('req' + req);
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        string jsonResponse = '';
        string strRequestBody = req.requestBody.toString();
        system.debug('strRequestBody:' + strRequestBody);

        ReviewsDetails Detail = parse(strRequestBody);
        system.debug('Detail:' + Detail);

        set < string > opptyUId = new set < string > ();
        set < string > contid = new set < string > ();
        map < string, string > mapoptyuid = new map < string, string > ();
        map < string, string > mapcontuid = new map < string, string > ();

        list < responseWrapper > resToReturn = new list < responseWrapper > ();
        list < Reviews__c > Reviewlst = new list < Reviews__c > ();
        try {
            for (cls_Detail wopp: Detail.Detail) {
                opptyUId.add(wopp.opportunity);
                contid.add(wopp.student);
                system.debug('contid' + contid);
            }

            for (opportunity__c oppty: [select id, Opportunity_Unique_Id__c from opportunity__c where Opportunity_Unique_Id__c in : opptyUId]) {
                mapoptyuid.put(oppty.Opportunity_Unique_Id__c, oppty.id);
            }
            /*for(Contact Cont :[select id,UID__c,Recordtype.name from Contact where Recordtype.name =: 'CR Student' AND UID__c in: contid ] ){
                mapcontuid.put(Cont.UID__c,Cont.id);
                system.debug('mapcontuid'+mapcontuid);
            }*/
            system.debug('Detail.Detail:' + Detail.Detail);
            if (Detail.Detail != null && Detail.Detail.size() > 0) {
                for (cls_Detail reviewWrap: Detail.Detail) {
                    system.debug('reviewWrap:' + reviewWrap);
                    if (string.isBlank(reviewWrap.opportunity) && string.isBlank(reviewWrap.account) && string.isBlank(reviewWrap.student)) {
                        responseWrapper resReview = new responseWrapper();

                        resReview.status = 'fail';
                        resReview.message = 'Atleast One Field Should be Populated from Account,Opportunity,Student';
                        resToReturn.add(resReview);
                        string JSONS = JSON.serialize(resToReturn);
                        if (JSONS.length() > 131000) {
                            JSONS = JSONS.left(131000);
                        }
                        Log__c log = CatchLogs.createLog('Error', '', resToReturn.size(), 0, 'ReviewsApiPOST', 'Atleast One Field Should be Populated from Account,Opportunity,Student', JSONS);
                        insert log;

                    } else {
                        if (mapoptyuid.containsKey(reviewWrap.opportunity) || string.isNotBlank(reviewWrap.student)) {
                            system.debug('mapoptyuid:' + mapoptyuid);
                            Reviews__c reviews = new Reviews__c();
                            system.debug('reviewWrap:' + reviewWrap);
                            reviews.Description__c = reviewWrap.description;

                            if (string.isNotBlank(reviewWrap.opportunity) && mapoptyuid.containsKey(reviewWrap.opportunity))
                                reviews.Opportunity__c = mapoptyuid.get(reviewWrap.opportunity);

                            reviews.URL__c = reviewWrap.url;
                            reviews.Rating__c = reviewWrap.rating;

                            if (string.isNotBlank(reviewWrap.account))
                                reviews.Account__c = reviewWrap.account;

                            //if(mapcontuid.containsKey(reviewWrap.student))
                            if (string.isNotBlank(reviewWrap.student)) {
                                reviews.Student__c = reviewWrap.student; //mapcontuid.get(reviewWrap.student);
                            }
                            if (String.isNotblank(reviewWrap.azureid))
                                reviews.Azure_Id__c = reviewWrap.azureid;
                            
                            Reviewlst.add(reviews);
                            system.debug('Reviewlst:' + Reviewlst);

                        } else {
                            responseWrapper resReview = new responseWrapper();
                            resReview.SFId = '';
                            resReview.Azureid = reviewWrap.azureid;
                            resReview.status = 'fail';
                            resReview.message = 'We could not insert the review records as the matching student/opportunity is not available  in salesforce.';
                            resToReturn.add(resReview);
                            string JSONS = JSON.serialize(resToReturn);
                            if (JSONS.length() > 131000) {
                                JSONS = JSONS.left(131000);
                            }
                            Log__c log = CatchLogs.createLog('Error', '', resToReturn.size(), 0, 'ReviewsApiPOST', 'We could not insert the review records as the matching student/opportunity is not available  in salesforce.', JSONS);
                            insert log;
                        }
                    }
                }
            }

            if (Reviewlst.size() > 0) {

                system.debug('Reviewlst:' + Reviewlst);
                Database.SaveResult[] insertresults = Database.insert(Reviewlst, false);
                system.debug('insertresults:' + insertresults);
                for (Integer index = 0, size = insertresults.size(); index < size; index++) {
                    Reviews__c rev = Reviewlst[index];
                    responseWrapper reviewRes = new responseWrapper();
                    String msg = '';
                    reviewRes.status = insertresults[index].isSuccess() ? 'Success' : 'fail';
                    system.debug('insertresults@@@@@:' + insertresults[index]);
                    for (Database.Error err: insertresults[index].getErrors()) {
                        if (msg != '')
                            msg += ',';
                        msg += err.getStatusCode() + ', ' + err.getMessage() + ', ' + err.getFields();
                    }
                    reviewRes.SFId = rev.id;
                    reviewRes.Azureid = rev.Azure_Id__c;
                    reviewRes.message = msg;
                    resToReturn.add(reviewRes);

                }

                jsonResponse = '{"status": "success", "Reviews":"' + JSON.serialize(resToReturn) + '"}';
                //if(jsonResponse.length()>131000){
                //    jsonResponse = jsonResponse.left(131000);
                // }
                // Log__c log = CatchLogs.createLog('Info','',resToReturn.size(),0,'ReviewsApiPOST','success', jsonResponse);
                // insert log;
                res.responseBody = Blob.valueof(jsonResponse);
            }

        } catch (Exception ex) {
            
            jsonResponse = '{"status": "fail", "message":"' + ex.getMessage() + ' at ' + ex.getLineNumber() + '"}';
            System.debug('Exception :: ' + jsonResponse );
            responseWrapper reviewRes = new responseWrapper();
            reviewRes.message = jsonResponse;
            resToReturn.add(reviewRes);
            if (jsonResponse.length() > 131000) {
                jsonResponse = jsonResponse.left(131000);
            }
            Log__c log = CatchLogs.createLog('Error', '', resToReturn.size(), 0, 'ReviewsApiPOST', ex.getMessage(), jsonResponse);
            insert log;
            res.responseBody = Blob.valueof(jsonResponse);

        }
        res.responsebody = blob.valueOf(JSON.serialize(resToReturn));

    }

    global class ReviewsDetails {
        public cls_Detail[] Detail;
    }
    global class cls_Detail {
        public String description;
        public String opportunity;
        public String url;
        public string rating;
        public String account;
        public string student;
        public string azureid;

    }

    public static ReviewsDetails parse(String json) {
        return (ReviewsDetails) System.JSON.deserialize(json, ReviewsDetails.class);
    }

    public class responseWrapper {
        public string SFid;
        public string Azureid;
        public string Status;
        public string Message;
    }
}