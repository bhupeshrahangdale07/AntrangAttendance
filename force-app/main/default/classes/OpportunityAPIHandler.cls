/*

Handler for Outbound Api callout to insert/update/delete Opportunity 

*/
public class OpportunityAPIHandler{
public static Boolean CallOutforOpprtunity = false;
    // Mehtod to call future method 
   public static void OpportunityAPI(List<opportunity__c>lstoppty,boolean Inserted,boolean Updated,boolean Deleted,Map<Id,opportunity__c> oldmapOppty ){
        Id oppAssRecordTypeIdTraining = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('External Training').getRecordTypeId();
        Id oppAssRecordTypeIdEmployment = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('External Employment').getRecordTypeId();
        Id oppAssRecordTypeIdEducation = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('External Education').getRecordTypeId();
        set<id> opptyID = new set<id>();
        for(Opportunity__c opp : lstoppty){
            if(((oldmapOppty != null && (opp.Type_of_opportunity__c != oldmapOppty.get(opp.id).Type_of_opportunity__c ||
            opp.Work_Days__c != oldmapOppty.get(opp.id).Work_Days__c||opp.Educational_Level__c != oldmapOppty.get( opp.id ).Educational_Level__c|| 
            opp.Additional_courses__c != oldmapOppty.get( opp.id ).Additional_courses__c || opp.English_fluency__c != oldmapOppty.get( opp.id ).English_fluency__c ||  
            opp.Digital_Literacy__c != oldmapOppty.get( opp.id ).Digital_Literacy__c || opp.Opportunity_Description_Clip__c != oldmapOppty.get( opp.id ).Opportunity_Description_Clip__c || opp.Name != oldmapOppty.get( opp.id ).Name || 
            opp.Zone__c != oldmapOppty.get( opp.id ).Zone__c||  opp.Work_experience__c != oldmapOppty.get( opp.id ).Work_experience__c|| opp.No_of_Openings__c != oldmapOppty.get( opp.id ).No_of_Openings__c||opp.Gender__c != oldmapOppty.get( opp.id ).Gender__c ||
            opp.Profession__c != oldmapOppty.get( opp.id ).Profession__c|| opp.Is_Opportunity_Closed__c != oldmapOppty.get( opp.id ).Is_Opportunity_Closed__c || opp.Course_Start_date__c != oldmapOppty.get(opp.id).Course_Start_date__c ||opp.Admission_Schedule__c != oldmapOppty.get(opp.id).Admission_Schedule__c ||
            opp.Detailed_course_description__c != oldmapOppty.get(opp.id).Detailed_course_description__c ||opp.Address__c != oldmapOppty.get(opp.id).Address__c ||
            opp.Location__c != oldmapOppty.get(opp.id).Location__c ||opp.Training_Days__c != oldmapOppty.get(opp.id).Training_Days__c ||opp.Duration__c != oldmapOppty.get(opp.id).Duration__c ||opp.Training_Hours_Start_Time__c != oldmapOppty.get(opp.id).Training_Hours_Start_Time__c ||
            opp.Post_course_placement_response_time__c != oldmapOppty.get(opp.id).Post_course_placement_response_time__c ||opp.Training_Hours_End_Time__c != oldmapOppty.get(opp.id).Training_Hours_End_Time__c||opp.Post_Course_Placement__c != oldmapOppty.get(opp.id).Post_Course_Placement__c ||
            opp.Fees_Associated_costs__c != oldmapOppty.get(opp.id).Fees_Associated_costs__c ||opp.Admission_Process__c != oldmapOppty.get(opp.id).Admission_Process__c ||opp.Recruitment_Process__c != oldmapOppty.get(opp.id).Recruitment_Process__c ||
            opp.Required_Documents__c != oldmapOppty.get(opp.id).Required_Documents__c ||opp.Accreditation_Type__c != oldmapOppty.get(opp.id).Accreditation_Type__c)))|| Inserted || Deleted){
            if(opp.Recordtypeid != oppAssRecordTypeIdTraining && opp.Recordtypeid != oppAssRecordTypeIdEmployment && opp.Recordtypeid != oppAssRecordTypeIdEducation){
            opptyID.add(opp.id);
            system.debug('opptyID::'+opptyID.size());
            }
          } //CallOpportunityApi(opp.id,Inserted,Updated,Deleted);
        }
        if(opptyID != null && opptyID.size() > 0){
            OpportunityAPIHandler.CallOutforOpprtunity = True;
            CallOpportunityApi(opptyID,Inserted,Updated,Deleted);
        }
    }
    // Future method for opportunity callout
    @future (callout= true)
    public static void CallOpportunityApi(set<id> opptyID ,boolean Inserted,boolean Updated,boolean Deleted){
        
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
        String URL = '';
        string strMessage = '';
        string Acctoken = setting.AccessToken__c;//'317C05947E5147E097720D15A3E5CC73'; //getAccessToken();
        system.debug('Acctoken ='+Acctoken);
        DescribeSObjectResult describe = SObjectType.Opportunity__c;
        string API_name = describe.getLabel();
        List<Opportunity__c> opptyLst = new List<Opportunity__c>();
        opptyLst = [Select id,Opportunity_Unique_Id__c,Name,Account__c,Contact__c,Gender__c,Course_Start_date__c,Detailed_course_description__c,Educational_Level__c,English_fluency__c,Digital_Literacy__c,No_of_Openings__c,Address__c,Location__c,
                    Training_Hours_Start_Time__c,Training_Hours_End_Time__c,Duration__c,Post_Course_Placement__c,Accreditation_Type__c,Work_experience__c,Detailed_Job_Description__c,Salary_in_hand_monthly__c,Opportunity_Description_Clip__c,
                    Working_Hours_Start_Time__c,Working_Hours_End_Time__c,RecordTypeId,Profession__c,Training_Days__c,Required_Documents__c,Additional_courses__c,Work_Days__c,Admission_Process__c,Admission_Schedule__c,
                    Fees_Associated_costs__c,Is_Opportunity_Closed__c,Account__r.name,Number_of_profile_matches__c,Closed_Date__c,No_of_remaining_Openings__c,Career_Progression_For_the_role__c,Recruitment_Process__c,Dummy_Insert_Opportunity__c,No_of_peers_looking_at_the_opportunity__c,Recurrence_Schedule__c,Payroll_details__c,Type_of_opportunity__c,Industry_name__c,IsDeleted from Opportunity__c where Id in : opptyID
                    AND RecordType.DeveloperName not in ('External_Education','External_Employment','External_Training') ALL ROWS];
        if(opptyLst.size() > 0){
              if(string.isNotBlank(opptyLst[0].Opportunity_Description_Clip__c)){               
                    URL='http://docs.google.com/uc?export=open&id=' + opptyLst[0].Opportunity_Description_Clip__c;
                    system.debug(URL);
               }                  
            //Api String Body to pass
            String strBody ='';
            strBody = '{';  
            strBody += '"OPPORTUNITY_UNIQUE_ID__C": "' + (opptyLst[0].Opportunity_Unique_Id__c != null ? opptyLst[0].Opportunity_Unique_Id__c : '') + '",';
            strBody += '"NAME": "' + (opptyLst[0].Name != null ? opptyLst[0].Name : '') + '",';
            strBody += '"ACCOUNT__C": "' + (opptyLst[0].Account__r.name != null ? opptyLst[0].Account__r.name : '') + '",';
            strBody += '"CONTACT__C": "' + /*(opptyLst[0].Contact__c != null ? opptyLst[0].Contact__c : '')*/ opptyLst[0].Contact__c + '",';
            strBody += '"TYPE_OF_OPPORTUNITY__C": "' + (opptyLst[0].Type_of_opportunity__c != null ? opptyLst[0].Type_of_opportunity__c : '') + '",'; 
            strBody += '"GENDER__C": "' + (opptyLst[0].Gender__c != null ? opptyLst[0].Gender__c : '') + '",';
            strBody += '"COURSE_START_DATE__C": "' + (opptyLst[0].Course_Start_date__c != null ? string.valueOf(opptyLst[0].Course_Start_date__c) : '') + '",';
            strBody += '"DETAILED_COURSE_DESCRIPTION__C": "' + (opptyLst[0].Detailed_course_description__c != null ? opptyLst[0].Detailed_course_description__c.escapeUnicode() : '') + '",';
            strBody += '"EDUCATIONAL_LEVEL__C": "' + (opptyLst[0].Educational_Level__c != null ? opptyLst[0].Educational_Level__c : '') + '",';
            strBody += '"ENGLISH_FLUENCY__C": "' + (opptyLst[0].English_fluency__c  != null ? opptyLst[0].English_fluency__c     : '') + '",';
            strBody += '"DIGITAL_LITERACY__C": "' + (opptyLst[0].Digital_Literacy__c != null ? opptyLst[0].Digital_Literacy__c : '') + '",';
            strBody += '"NO_OF_OPENINGS__C": "'+ (opptyLst[0].No_of_Openings__c != null ? string.valueof(opptyLst[0].No_of_Openings__c) : '') + '",';
            strBody += '"ADDRESS__C": "' + (opptyLst[0].Address__c != null ? opptyLst[0].Address__c : '') + '",';
            strBody += '"LOCATION__C": "' + (opptyLst[0].Location__c != null ? opptyLst[0].Location__c : '') + '",';
            strBody += '"TRAINING_HOURS_START_TIME__C": "' + (opptyLst[0].Training_Hours_Start_Time__c != null ? String.valueof(opptyLst[0].Training_Hours_Start_Time__c) : '') + '",';
            strBody += '"TRAINING_HOURS_END_TIME__C": "' + (opptyLst[0].Training_Hours_End_Time__c != null ? String.valueof(opptyLst[0].Training_Hours_End_Time__c) : '') + '",';
            strBody += '"DURATION__C": "' + (opptyLst[0].Duration__c != null ? opptyLst[0].Duration__c : '') + '",';
            strBody += '"POST_COURSE_PLACEMENT__C": "' + opptyLst[0].Post_Course_Placement__c + '",';
            strBody += '"ACCREDITATION_TYPE__C": "' + (opptyLst[0].Accreditation_Type__c != null ? opptyLst[0].Accreditation_Type__c : '') + '",';
            strBody += '"WORK_EXPERIENCE__C": "' + (opptyLst[0].Work_experience__c != null ? opptyLst[0].Work_experience__c : '') + '",';
            strBody += '"DETAILED_JOB_DESCRIPTION__C": "' + (opptyLst[0].Detailed_Job_Description__c != null ? opptyLst[0].Detailed_Job_Description__c.escapeUnicode() : '') + '",';
            strBody += '"SALARY_IN_HAND_MONTHLY__C": "' + (opptyLst[0].Salary_in_hand_monthly__c != null ? string.valueof(opptyLst[0].Salary_in_hand_monthly__c) : '') + '",';
            strBody += '"WORKING_HOURS_START_TIME__C": "' + (opptyLst[0].Working_Hours_Start_Time__c != null ? string.valueOf(opptyLst[0].Working_Hours_Start_Time__c) : '') + '",';
            strBody += '"WORKING_HOURS_END_TIME__C": "' + (opptyLst[0].Working_Hours_End_Time__c != null ? string.valueOf(opptyLst[0].Working_Hours_End_Time__c) : '') + '",';
            strBody += '"RECORDTYPEID": "' + (opptyLst[0].RecordTypeId != null ? opptyLst[0].RecordTypeId : '') + '",';
            strBody += '"API_OBJECT_NAME": "' + API_name + '",';
            strBody += '"PROFESSION__C": "' + (opptyLst[0].Profession__c != null ? opptyLst[0].Profession__c : '') + '",';
            strBody += '"TRAINING_DAYS__C": "' + (opptyLst[0].Training_Days__c != null ? opptyLst[0].Training_Days__c : '') + '",';
            strBody += '"REQUIRED_DOCUMENTS__C": "' + (opptyLst[0].Required_Documents__c != null ? opptyLst[0].Required_Documents__c : '') + '",';
            strBody += '"ADDITIONAL_COURSES__C": "' + (opptyLst[0].Additional_courses__c != null ? opptyLst[0].Additional_courses__c : '') + '",';
            strBody += '"WORK_DAYS__C": "' + (opptyLst[0].Work_Days__c != null ? opptyLst[0].Work_Days__c : '') + '",';
            strBody += '"OPPORTUNITY_API_USER_AUTH_TOKEN": "' + Acctoken + '",';
            strBody += '"OPPORTUNITY_EMPLOYER_ID": "' + (opptyLst[0].Account__c != null ? opptyLst[0].Account__c : '') + '",';
            strBody += '"OPPORTUNITY_ADMISSION_PROCESS": "' + (opptyLst[0].Admission_Process__c != null ? opptyLst[0].Admission_Process__c.escapeUnicode() : '') + '",';
            strBody += '"OPPORTUNITY_ADMISSION_SCHEDULE": "' + (opptyLst[0].Admission_Schedule__c != null ? opptyLst[0].Admission_Schedule__c : '') + '",';
            strBody += '"OPPORTUNITY_AUDIO_VIDEO_URL": "' + (string.isNotBlank(URL) ? URL : '') + '",';
            strBody += '"OPPORTUNITY_FEES_ASSOCIATED_COSTS": "' + (opptyLst[0].Fees_Associated_costs__c != null ? string.valueof(opptyLst[0].Fees_Associated_costs__c) : '') + '",';
            strBody += '"OPPORTUNITY_IS_OPPORTUNITY_CLOSED": "' + opptyLst[0].Is_Opportunity_Closed__c  + '",';
            strBody += '"OPPORTUNITY_NOS_OF_PROFILE_MATCHES": "' + (opptyLst[0].Number_of_profile_matches__c != null ? string.valueOf(opptyLst[0].Number_of_profile_matches__c) : '') + '",';
            strBody += '"OPPORTUNITY_NOS_PEERS_LOOKING_OPPORTUNITY": "' + opptyLst[0].No_of_peers_looking_at_the_opportunity__c  + '",';
            strBody += '"OPPORTUNITY_RECURRENCE_SCHEDULE": "' + (opptyLst[0].Recurrence_Schedule__c != null ? opptyLst[0].Recurrence_Schedule__c : '') + '",';
            strBody += '"OPPORTUNITY_PAYROLL_DETAIL": "' + (opptyLst[0].Payroll_details__c != null ? opptyLst[0].Payroll_details__c : '') + '",';
            strBody += '"OPPORTUNITY_IS_DELETED": "' + opptyLst[0].IsDeleted + '",';
            strbody += '"Recruitment_Process": "' + (opptyLst[0].Recruitment_Process__c != null ? opptyLst[0].Recruitment_Process__c.escapeUnicode() : '') + '",';
            strbody += '"Career_Progression_For_the_role": "' + (opptyLst[0].Career_Progression_For_the_role__c != null ? opptyLst[0].Career_Progression_For_the_role__c.escapeUnicode() : '') + '",';
            strbody += '"Industry_Name": "' + (opptyLst[0].Industry_name__c != null ? opptyLst[0].Industry_name__c : '') + '",';
            strbody += '"app_opp_nos_remaining_opening": "' + (opptyLst[0].No_of_remaining_Openings__c != null ? string.valueOf(opptyLst[0].No_of_remaining_Openings__c) : '') + '",';
            strbody += '"Closed_Date__c": "' + (opptyLst[0].Closed_Date__c!= null ? string.valueOf(date.valueOf(opptyLst[0].Closed_Date__c)) : '') + '",';

            if(Inserted){
                strBody += '"MODE": "I"';
            }else if (Updated){
                if(opptyLst[0].Dummy_Insert_Opportunity__c){
                    strBody += '"MODE": "I"';
                 }
                 else{
                    strBody += '"MODE": "U"'; 
                } 
            }else if(Deleted){
                strBody += '"MODE": "D"'; 
            }
            strbody += '}';
            // Opportunity Endpoint from Custom setting 
            //AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
            String endpoint = '';
            if (setting == null || string.isblank(setting.BaseApiUrl__c )) {
                strMessage = 'Opportunity Api Endpoint is not populated. Please go to Custom Setting --> Antarang Setting --> Opportunity Api Endpoint  .';
                
            } else {
                endpoint = setting.BaseApiUrl__c +'applicantopportunity/insertupdateapplicantopportunity'  ;
            }
            // Callout for opportunity 
            HttpResponse response = doCallout(strBody,'POST',endpoint,Acctoken);
            system.debug('response'+response);
            if (response != null && response.getStatusCode() == 200){
                string resbody = response.getBody();
                system.debug('***'+resbody);
                list <object> reslst = (list<object > ) JSON.deserializeUntyped(resbody);
                for(object obj : reslst){
                    Map < String, Object > m = (Map < String, Object > ) JSON.deserializeUntyped(json.serialize(obj));
                    system.debug(m);
                    if (m.containskey('Success')) {
                        strMessage = response.toString();
                    }
                } 
            }else if (response != null) {
                Map < String, Object > m = (Map < String, Object > ) JSON.deserializeUntyped(response.getBody());
                if (m.containskey('error')) {
                    strMessage = string.valueof(m.get('error'));
                    strMessage = strMessage.replace('{', '').replace('}', '');
                }
            }
            //return strMessage;
            
        }
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
            request.setHeader( 'Authorization', Acctoken );
            HttpResponse response = new Http().send(request);
            system.debug(' Res:' + response.getBody());
            return response;
        } catch (Exception ex) {
            return null;
        }
    }
    
    
}