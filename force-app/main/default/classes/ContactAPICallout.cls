public class ContactAPICallout implements Queueable,Database.AllowsCallouts{
 public set<id> contactid; 
    public ContactAPICallout (set<id> Conidset){
       this.contactid = Conidset;
        
    }
 public void execute(QueueableContext qc){ 
       ContactCallout(contactid);
    }
    public static string replaceQuotes(string str) {
        String strbody = str;
        String newstrbody = strbody.replaceAll('\""', 'null');
        System.debug(newstrbody);
        return newstrbody;
    }

    // Generic Http method to call out 
    public static HttpResponse doCallout(string strBody, string strMethod, string endpoint, string Acctoken) {

        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod(strMethod);
            request.setTimeout(120000);
            request.setBody(strBody);
            system.debug('strRequestBody ::: ' + strBody);
            system.debug('endpoint::: ' + endpoint);
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Content-Length', string.valueof(strBody.length()));
            request.setHeader('Authorization', Acctoken);
            HttpResponse response = new Http().send(request);
            system.debug(' Res:' + response.getBody());
            return response;
        } catch (Exception ex) {
              return null;
      }
   }
    public static void ContactCallout(set<id> contactid ){
     AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
        string strMessage = '';
        string Acctoken = setting.AccessToken__c;
        system.debug('Acctoken =' + Acctoken);
        List < Contact > ContactLst = new List < Contact > ();
        ContactLst = [select id,UID__c,FirstName,Lastname,Batch_Name__r.name,Location__c,Current_Education__c,Education_Status__c,Available_work_Days__c,
            Available_working_Hours_Start_Time__c,Digital_Literacy__c,Available_working_Hours_Finish_Time__c,English_Fluency__c,Available_for_Career_Linkage__c,
            Type_of_Career_linkage__c,Reason_for_career_linkage_unavilability__c,isDeleted,Createddate,Lastmodifieddate from Contact where Id in : contactid and Recordtype.name ='CR Student' ALL ROWS];
        if (ContactLst.size() > 0) {
            string Newstringbody = '';
            String strBody = '';
            strBody = '{';
            strBody += '"students":[';
            List < String > strList = new List < String > ();
            for (Contact con: ContactLst) {
                string body = '';
                body += '{';
                body += '"uid": "' + (con.UID__c != null ? con.UID__c : '') + '",';
                body += '"firstname": "' + (con.firstname != null ? con.firstname : '') + '",';
                body += '"lastname": "' + (con.lastname != null ? con.lastname : '') + '",';
                body += '"batch_name": "' + (con.Batch_Name__r.name != null ? con.Batch_Name__r.name : '') + '",';
                body += '"location": "' + (con.Location__c != null ? con.Location__c : '') + '",';
                body += '"education": "' + (con.Current_Education__c != null ? con.Current_Education__c : '') + '",';
                body += '"education_status": "' + (con.Education_Status__c != null ? con.Education_Status__c : '') + '",';
                body += '"available_work_days": "' + (con.Available_work_Days__c != null ? con.Available_work_Days__c : '') + '",';
                body += '"available_working_hours_start_time": "' + (con.Available_working_Hours_Start_Time__c != null ? string.valueof(con.Available_working_Hours_Start_Time__c) : '') + '",';
                body += '"available_working_hours_finish_time": "' + (con.Available_working_Hours_Finish_Time__c != null ? string.valueof(con.Available_working_Hours_Finish_Time__c) : '') + '",';
                body += '"english_fluency": "' + (con.English_Fluency__c != null ? con.English_Fluency__c : '') + '",';
                body += '"digital_literacy": "' + (con.Digital_Literacy__c != null ? con.Digital_Literacy__c : '') + '",';
                body += '"available_for_career_linkage": "' + (con.Available_for_Career_Linkage__c != null ? con.Available_for_Career_Linkage__c : '') + '",';
                body += '"type_of_career_linkage": "' + (con.Type_of_Career_linkage__c != null ? con.Type_of_Career_linkage__c : '') + '",';
                
                String unavailabilityReason = con.Reason_for_career_linkage_unavilability__c;
                if(unavailabilityReason != null){
                    if(Contact_ReasonForUnavailability.MAP_SF_PICKLIST_VALUES.containsKey(unavailabilityReason)){
                        body += '"reason_for_career_linkage_unavilability": "' + Contact_ReasonForUnavailability.MAP_SF_PICKLIST_VALUES.get(unavailabilityReason) +'",';
                    }else{
                        body += '"reason_for_career_linkage_unavilability": "' + unavailabilityReason + '",';
                    }
                    
                }else{
                    body += '"reason_for_career_linkage_unavilability": "' + '' + '",';
                }
                //body += '"reason_for_career_linkage_unavilability": "' + (con.Reason_for_career_linkage_unavilability__c != null ? con.Reason_for_career_linkage_unavilability__c : '') + '",';
                
                body += '"isdeleted": "' + con.IsDeleted + '",';
                body += '"id": "' + (con.id != null ? con.id : '') + '",';
                body += '"createddate": "' + (con.createddate != null ? String.valueof(con.createddate) : '') + '",';
                body += '"lastmodifieddate": "' + (con.lastmodifieddate != null ? string.valueof(con.lastmodifieddate) : '') + '",';
                body += '"access_token": "' + Acctoken + '"';
                body += '}';
                strList.add(body);

            }
            //strbody.removeEnd(',');
            //strbody =strbody.removeEnd(',');
            strbody += String.join(strList, ',') + ']';
            strbody += '}';

            Newstringbody = replaceQuotes(strbody);
            //AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
            String endpoint = '';
            if (setting == null || string.isblank(setting.BaseApiUrl__c)) {
                strMessage = 'Contact Api Endpoint is not populated. Please go to Custom Setting -> Antarang Setting -> Opportunity Api Endpoint  .';

            } else {
                endpoint = setting.BaseApiUrl__c + 'insertupdateapplicantprofilefromsalesforcerealtime/insertupdateapplicantprofilefromsalesforcetoazure';
            }
            // callout for contact 
            HttpResponse response = doCallout(Newstringbody, 'POST', endpoint, Acctoken);
            system.debug('response' + response);
            if (response != null && response.getStatusCode() == 200) {
                string resbody = response.getBody();
              
                system.debug('***' + resbody);
                list < object > reslst = (list < object > ) JSON.deserializeUntyped(resbody);
                for (object obj: reslst) {
                    Map < String, Object > m = (Map < String, Object > ) JSON.deserializeUntyped(json.serialize(obj));
                    system.debug(m);
                    if (m.containskey('Success')) {
                        strMessage = response.toString();
                    }
                }
                 /*Log__c log = CatchLogs.createLog('Info','',0,0,'OpportunityAssignmentAPIHandler','', strMessage);
                insert log;*/
            } else if (response != null) {
                Map < String, Object > m = (Map < String, Object > ) JSON.deserializeUntyped(response.getBody());
                if (m.containskey('error')) {
                    strMessage = string.valueof(m.get('error'));
                    strMessage = strMessage.replace('{', '').replace('}', '');
                }
            }
            //return strMessage;

        }
    }

}