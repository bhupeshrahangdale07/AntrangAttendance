public class OpportunityAssignmentAPIHandler {
    public static Boolean CallOutforOpprtunityAssignment = false;
    public static boolean recurrsion = false;
    // Mehtod to call future method 
    public static void OpportunityAssignmentAPI(List < Opportunity_Assignment__c > lstopptyassing, boolean Inserted, boolean Updated, boolean Deleted, Map < Id, Opportunity_Assignment__c > oldmapOpptyAssign) {
            AntarangSetting__c antarangSettings = AntarangSetting__c.getOrgDefaults();
            Id oppAssRecordTypeIdTraining = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('External Training').getRecordTypeId();
            Id oppAssRecordTypeIdEmployment = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('External Employment').getRecordTypeId();
            Id oppAssRecordTypeIdEducation = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('External Education').getRecordTypeId();
            set < id > oppassginIdset = new set < id > ();
            system.debug('lstopptyassingSIZE:::=' + lstopptyassing.size());
            system.debug('lstopptyassing:::=' + lstopptyassing);
            for (Opportunity_Assignment__c oppassign: lstopptyassing) {
               if(antarangSettings.Api_User_id__c != UserInfo.getUserId() || antarangSettings.Dummy_Update_Check__c ||((oldmapOpptyAssign != null && (oppassign.Active__c != oldmapOpptyAssign.get(oppassign.id).Active__c)) && oppassign.Active__c == false)){
                system.debug('CallOutforOpprtunityAssignment =' + CallOutforOpprtunityAssignment);
                //oppassginIdset.add(oppassign.id);
                if ((oldmapOpptyAssign != null && (oppassign.Status__c != oldmapOpptyAssign.get(oppassign.id).Status__c || oppassign.Reasons_for_Rejection__c != oldmapOpptyAssign.get(oppassign.id).Reasons_for_Rejection__c || oppassign.Reasons_for_Leaving__c != oldmapOpptyAssign.get(oppassign.id).Reasons_for_Leaving__c ||
                    oppassign.Active__c != oldmapOpptyAssign.get(oppassign.id).Active__c || oppassign.Linkage_Not_Achieved__c != oldmapOpptyAssign.get(oppassign.id).Linkage_Not_Achieved__c ))
                     || Inserted || Deleted) {
                     if(oppassign.Recordtypeid != oppAssRecordTypeIdTraining && oppassign.Recordtypeid != oppAssRecordTypeIdEmployment && oppassign.Recordtypeid != oppAssRecordTypeIdEducation){
                        oppassginIdset.add(oppassign.id);
                    }    //CallOpportunityassignmentApi(oppassginIdset, Inserted, Updated, Deleted);
                }
                system.debug('oppassginIdsetSIZE:::' + oppassginIdset.size());
                system.debug('oppassginIdset:::' + oppassginIdset);
            }
           } 
            if(oppassginIdset != null && oppassginIdset.size() > 0){
                CallOpportunityassignmentApi(oppassginIdset, Inserted, Updated, Deleted);
            }
        }
        
    
    //Opp Assignment Duplicate Validation
    //Added on 1st June 2020
    public static void OppAssignDuplicateValidation(List < Opportunity_Assignment__c > lstopptyassing){
        
        List<Id> contactIds = new List<Id>();
        Map<Id, Set<id>> mapConIdToLstOppIds = new Map<Id, Set<id>>();
        

        Set<Id> oppIds = new Set<Id>();
        
       
        for(Opportunity_Assignment__c oppAssign : lstopptyassing){
            
            oppIds.add(oppAssign.Opportunity__c);
            
            if(!mapConIdToLstOppIds.containsKey(oppAssign.Student__c)){
                mapConIdToLstOppIds.put(oppAssign.Student__c, new Set<Id>());
            }
            
            if(!mapConIdToLstOppIds.get(oppAssign.Student__c).contains(oppAssign.Opportunity__c)){
                mapConIdToLstOppIds.get(oppAssign.Student__c).add(oppAssign.Opportunity__c);
            }
            
        }
        
        //Duplicate validations checks only for non external opps
        Map<Id,Opportunity__c> IncludedOpps = new Map<Id,Opportunity__c>([SELECT Id, Name 
                                                                     FROM Opportunity__c 
                                                                     WHERE Id IN: oppIds  AND   
                                                                          (RecordType.Name != 'External Education') AND 
                                                                          (RecordType.Name != 'External Employment') AND 
                                                                          (RecordType.Name != 'External Training')]);
        
        
        
         //Check dupliactes in old records before insert
        List<Opportunity_Assignment__c> lstOldOppAssign = [SELECT Id, Student__c, Opportunity__c FROM Opportunity_Assignment__c WHERE Student__c  IN: mapConIdToLstOppIds.keySet()];
        
        
        
        Map<Id, Set<id>> mapExistingConIdToOppIds = new Map<Id, Set<id>>();
        
        Map<String, String> mapConOppKey = new Map<String, String>();
        
        
        if(lstOldOppAssign != Null && lstOldOppAssign.size() > 0){
        
        
        for(Opportunity_Assignment__c  oa :lstOldOppAssign)
        {
            if(!mapExistingConIdToOppIds.containsKey(oa.Student__c)){
                mapExistingConIdToOppIds.put(oa.Student__c, new Set<Id>());
            }
            
            if(!mapExistingConIdToOppIds.get(oa.Student__c).contains(oa.Opportunity__c)){
                mapExistingConIdToOppIds.get(oa.Student__c).add(oa.Opportunity__c);
            }
            
        }       
        
        }
        
        
        if(lstOldOppAssign != Null && lstOldOppAssign.size() > 0){
            for(Opportunity_Assignment__c oppAssign : lstopptyassing){
                
                if(mapExistingConIdToOppIds.containsKey(oppAssign.Student__c) && IncludedOpps.containsKey(oppAssign.Opportunity__c)){
                    if(mapExistingConIdToOppIds.get(oppAssign.Student__c).contains(oppAssign.Opportunity__c)){
                        //addError
                        oppAssign.addError('Duplicate Assignment Detected : This student has already applied for this opportunity.');
                    }
                }
            }
        }
    }
    
    
    // Future method for opportunity callout
    @future(callout = true)
    public static void CallOpportunityassignmentApi(set < id > oppassginIdset, boolean Inserted, boolean Updated, boolean Deleted) {
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
        string strMessage = '';
        string Acctoken = setting.AccessToken__c;
        system.debug('Acctoken =' + Acctoken);
        List < Opportunity_Assignment__c > opptyAssignmentLst = new List < Opportunity_Assignment__c > ();
        opptyAssignmentLst = [select id, name, Student__c, Student__r.name, Job_Start_Date__c, Status__c, Last_Status_changed_on__c, Reasons_for_Rejection__c, Reasons_for_Leaving__c, recordtypeID, recordtype.name, Left_Job_Date__c,Opportunity_End_Date__c,Opportunity_Start_Date__c,
            Applicant_Job_Status__c, Education_achieved_Date__c, Course_completed_Date__c, Course_start_Date__c, Student__r.UID__c,Continued_working_for_1_year_Date__c,Continued_working_for_3_months_Date__c,Continued_working_for_6_months_Date__c,Comments__c,
            Created_Via_App__c, Linkage_Not_Achieved__c, Active__c, Opportunity__c, Opportunity__r.name, Opportunity__r.Opportunity_Unique_Id__c,Interview_scheduled_Date__c,Gross_Salary_monthly__c,Payroll_details__c, IsDeleted from Opportunity_Assignment__c where Id in : oppassginIdset
             AND RecordType.DeveloperName not in ('External_Education','External_Employment','External_Training') ALL ROWS];
        if (opptyAssignmentLst.size() > 0) {
            string Newstringbody = '';
            String strBody = '';
            strBody = '{';
            strBody += '"OpportunityAssignments":[';
            List < String > strList = new List < String > ();
            for (Opportunity_Assignment__c Opptyassgn: opptyAssignmentLst) {
                string jobStatus = '';
                string body = '';
                body += '{';
                body += '"studentid": "' + (Opptyassgn.Student__c != null ? Opptyassgn.Student__c : '') + '",';
                body += '"student_uid": "' + (Opptyassgn.Student__r.UID__c != null ? Opptyassgn.Student__r.UID__c : '') + '",';
                body += '"status": "' + (Opptyassgn.Status__c != null ? Opptyassgn.Status__c : '') + '",';
                body += '"recordtypeId": "' + (Opptyassgn.recordtypeID != null ? Opptyassgn.recordtypeID : '') + '",';
                body += '"recordtype_name": "' + (Opptyassgn.recordtype.name != null ? Opptyassgn.recordtype.name : '') + '",';
                body += '"reasons_for_rejection": "' + (Opptyassgn.Reasons_for_Rejection__c != null ? Opptyassgn.Reasons_for_Rejection__c : '') + '",';
                body += '"reasons_for_leaving": "' + (Opptyassgn.Reasons_for_Leaving__c != null ? string.valueOf(Opptyassgn.Reasons_for_Leaving__c) : '') + '",';
                body += '"opportunityID": "' + (Opptyassgn.Opportunity__c != null ? Opptyassgn.Opportunity__c : '') + '",';
                body += '"opportunity_unique_id": "' + (Opptyassgn.Opportunity__r.Opportunity_Unique_Id__c != null ? Opptyassgn.Opportunity__r.Opportunity_Unique_Id__c : '') + '",';
                body += '"opportunity_name": "' + (Opptyassgn.Opportunity__r.name != null ? Opptyassgn.Opportunity__r.name : '') + '",';
                body += '"name": "' + (Opptyassgn.name != null ? Opptyassgn.name : '') + '",';
                body += '"linkage_not_achieved": "' + (Opptyassgn.Linkage_Not_Achieved__c != null ? string.valueof(Opptyassgn.Linkage_Not_Achieved__c) : '') + '",';
                body += '"left_job_date": "' + (Opptyassgn.Opportunity_End_Date__c != null ? String.valueof(Opptyassgn.Opportunity_End_Date__c) : '') + '",';
                body += '"last_status_changed_on": "' + (Opptyassgn.Last_Status_changed_on__c != null ? String.valueof(Opptyassgn.Last_Status_changed_on__c) : '') + '",';
                body += '"job_start_date": "' + (Opptyassgn.Opportunity_Start_Date__c != null ? String.valueof(Opptyassgn.Opportunity_Start_Date__c) : '') + '",';
                body += '"isdeleted": "' + Opptyassgn.IsDeleted + '",';
                body += '"id": "' + (Opptyassgn.id != null ? Opptyassgn.id : '') + '",';
                body += '"education_achieved_date": "' + (Opptyassgn.Education_achieved_Date__c != null ? String.valueof(Opptyassgn.Education_achieved_Date__c) : '') + '",';
                body += '"created_via_app": "' + Opptyassgn.Created_Via_App__c + '",';
                body += '"course_started_date": "' + (Opptyassgn.Opportunity_Start_Date__c != null ? String.valueof(Opptyassgn.Opportunity_Start_Date__c) : '') + '",';
                body += '"course_completed_date": "' + (Opptyassgn.Opportunity_End_Date__c != null ? string.valueof(Opptyassgn.Opportunity_End_Date__c) : '') + '",';
                if(Opptyassgn.Status__c != null && Opptyassgn.Status__c == 'Student Curious'){
                    jobStatus = '1';
                }else if(Opptyassgn.Status__c != null && Opptyassgn.Status__c == 'Student Interested'){
                    jobStatus = '2';
                }               
                body += '"applicant_job_status": "' + (jobStatus != null ? jobStatus : '') + '",';
                body += '"Continued_working_for_1_year_Date": "' + (Opptyassgn.Continued_working_for_1_year_Date__c != null ? String.valueof(Opptyassgn.Continued_working_for_1_year_Date__c) : '') + '",';
                body += '"Continued_working_for_3_months_Date": "' + (Opptyassgn.Continued_working_for_3_months_Date__c != null ? String.valueof(Opptyassgn.Continued_working_for_3_months_Date__c) : '') + '",';
                body += '"Continued_working_for_6_months_Date": "' + (Opptyassgn.Continued_working_for_6_months_Date__c != null ? String.valueof(Opptyassgn.Continued_working_for_6_months_Date__c) : '') + '",';
                body += '"student_interview_date": "' + (Opptyassgn.Interview_scheduled_Date__c != null ? String.valueof(Opptyassgn.Interview_scheduled_Date__c) : '') + '",';
                body += '"payroll_detail": "' + (Opptyassgn.Payroll_details__c != null ? String.valueof(Opptyassgn.Payroll_details__c) : '') + '",';
                body += '"salary": "' + (Opptyassgn.Gross_Salary_monthly__c != null ? String.valueof(Opptyassgn.Gross_Salary_monthly__c) : '') + '",';
                body += '"active": "' + Opptyassgn.Active__c + '",';
                body += '"authentication_token": "' + Acctoken + '"';
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
                strMessage = 'OpportunityAssignment  Api Endpoint is not populated. Please go to Custom Setting -> Antarang Setting -> Opportunity Api Endpoint  .';

            } else {
                endpoint = setting.BaseApiUrl__c + 'opportunityassignment/insertupdateapplicantopportunityassignment';
            }
            // callout for opportunity 
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
                    Log__c log = CatchLogs.createLog('Error','',0,0,'OpportunityAssignmentAPIHandler','', strMessage);
                    insert log;
                }
            }
            //return strMessage;

        }
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
    public static void UpdateInterviewDate_and_Salary (List<Opportunity_Assignment__c>lstopptyAssign, Map<id,Opportunity_Assignment__c> MapopptyAssign){
        String UserId = UserInfo.getUserId();//Returns the context user's ID.
        For(Opportunity_Assignment__c OptAss : lstopptyAssign){
        if(UserId == Label.Current_User){
            if(string.isnotblank(OptAss.Status__c) && OptAss.Status__c == 'Interview appeared' && OptAss.Interview_scheduled_Date__c == null ){
                OptAss.Interview_scheduled_Date__c = System.now();
            }
            if(string.isnotblank(OptAss.Status__c) && (OptAss.Status__c == 'Left Job after 3 months' || OptAss.Status__c == 'Left Job after 6 months' || OptAss.Status__c == 'Left job after more than 1 year' ||
                       OptAss.Status__c =='Continued working for 3 months' || OptAss.Status__c =='Continued working for 6 months' ) &&  OptAss.Gross_Salary_monthly__c == null){
                           OptAss.Gross_Salary_monthly__c = 0;
            }
         }
       }  
    }
    Public static void UpdateStatusWhenBlank(List<Opportunity_Assignment__c>lstopptyAssign){
    
    For(Opportunity_Assignment__c OptAss : lstopptyAssign){
    if(String.isBlank(OptAss.Status__c)){
       OptAss.Status__c = 'Needs to be contacted';
    }
   }
  }
    Public static void UpdateAdditionalcourse(List<Opportunity_Assignment__c>lstopptyAssign, Map<id,Opportunity_Assignment__c> MapopptyAssign){
        string External_Training = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('External Training').getRecordTypeId();
        System.debug('External_Training' +External_Training );
        string External_Employment = Schema.SObjectType.Opportunity_Assignment__c.getRecordTypeInfosByName().get('External Employment').getRecordTypeId();
        System.debug('External_Employment ' +External_Employment );
        map<id,string> conmapid = new map<id,string>();   
        for(Opportunity_Assignment__c opp : lstopptyAssign){
            if(opp.Course_name__c!=null && (opp.RecordTypeID == External_Training  || opp.RecordTypeID == External_Employment ||(MapopptyAssign!= null && opp.Course_name__c != MapopptyAssign.get(opp.id).Course_name__c))){
                //if(opp.Course_name__c != MapopptyAssign.get(opp.id).Course_name__c){
                    conmapid.put(opp.Student__C,opp.Course_name__c);
                //}
                system.debug('conmapid' +conmapid);
            }  
        }
        system.debug('conmapid' + conmapid);
        
        List<Contact> updatecontact = new List<Contact>();
        set<string> Splitvalueset = new set<string>();
        List<Contact> conlist = [select id,Additional_courses__c from Contact where Recordtype.name ='CR Student' AND id in:conmapid.keyset()  ];
        for(contact con :conlist){
            if(con.Additional_courses__c != null){
                Splitvalueset.addAll(con.Additional_courses__c.split(';'));
                system.debug('Splitvalueset' + Splitvalueset);
            }
            system.debug('Splitvalueset' + Splitvalueset.size());
            if(Splitvalueset.size() > 0){
                system.debug('Mapvalue' +conmapid.get(con.id));
                if(!Splitvalueset.contains(conmapid.get(con.id))){
                    con.Additional_courses__c = con.Additional_courses__c + ';' + conmapid.get(con.id);
                }
            }
            else {
                con.Additional_courses__c = conmapid.get(con.id);
            }
            updatecontact.add(con);
        }
        update updatecontact;
    }
     
    
}