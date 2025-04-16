@RestResource(urlMapping = '/placements/oppassignments/*')
global with sharing class OpportunityAPIHelper {

    //this method returns Active Opportunity_Assignment__c records for the given StudentID/UID
    @HttpGet
    global static void doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');

        String jsonResponse;
        //getting UID from URL
        //String uid = getUIDFromURI();// = RestContext.request.params.get('id');
        string fromdate = string.valueof(req.params.get('fromdate'));
        string todate = string.valueof(req.params.get('todate'));
        DateTime dtStart;
        DateTime dtEnd;
        if (fromdate != null && todate != null) {
            dtStart = DateTime.newInstanceGMT(Integer.valueOf(fromdate.split('-')[0]), Integer.valueOf(fromdate.split('-')[1]), Integer.valueOf(fromdate.split('-')[2]));
            dtEnd = DateTime.newInstanceGMT(Integer.valueOf(todate.split('-')[0]), Integer.valueOf(todate.split('-')[1]), Integer.valueOf(todate.split('-')[2]), 23, 59, 59);
        }

        GetOppResponseModel rm = new GetOppResponseModel();
        rm.OpportunityAssignments = new List < GetOppDetailsWrapper > ();
        //fetching Active OpportunityAssignment records for the Contact
        for (Opportunity_Assignment__c oppAss: [select id, Name, Opportunity__c, Opportunity__r.Name, Created_Via_App__c, Opportunity__r.Opportunity_Unique_Id__c, Applicant_Job_Status__c,Continued_working_for_3_months_Date__c,
                Student__c, Student__r.Name, Student__r.UID__C, Linkage_Not_Achieved__c, Reasons_for_Rejection__c, Reasons_for_Leaving__c, Last_Status_changed_on__c,Continued_working_for_1_year_Date__c,Continued_working_for_6_months_Date__c,
                RecordTypeId, RecordType.Name, Payroll_details__c,Gross_Salary_monthly__c, Status__c,Interview_scheduled_Date__c,Education_achieved_Date__c, Active__c, Job_Start_Date__c, Left_Job_Date__c, Course_start_Date__c, LastModifiedDate, Course_completed_Date__c, IsDeleted
                from Opportunity_Assignment__c where(LastModifiedDate >= : dtStart and LastModifiedDate <= : dtEnd) AND RecordType.DeveloperName not in ('External_Education','External_Employment','External_Training')
                Order By LastModifiedDate DESC
            ]) {
            system.debug('oppAss' + oppAss);
            //creatting a model object data for the OppAssignment record
            //and adding it to the list of wrapper object
            rm.OpportunityAssignments.add(new GetOppDetailsWrapper(oppAss));
        }

        if (rm.OpportunityAssignments.size() > 0) {
            rm.message = 'Record(s) found';
            //string jResponse = JSON.serialize(rm);
            //if (jResponse.length() > 131000) {
            //jResponse = jResponse.left(131000);
            //}
            //Log__c log = CatchLogs.createLog('Info', '', rm.OpportunityAssignments.size(), 0, 'fromdate =' + fromdate + '/' + 'todate =' + todate + 'Get All OpportunityAssignment', rm.message, jResponse);
           // insert log;
        } else //returning message when no active opportunity found
        {
            rm.message = 'No active opportunity assignments exist for the student';
            string jResponse = JSON.serialize(rm);
            if (jResponse.length() > 131000) {
                jResponse = jResponse.left(131000);
            }
            Log__c log = CatchLogs.createLog('Error', '', 0, 0, 'fromdate =' + fromdate + '/' + 'todate =' + todate + 'Get All OpportunityAssignment', rm.message, jResponse);
            insert log;
        }
        jsonResponse = JSON.serialize(rm);
        res.statusCode = 200;
        res.responseBody = blob.valueOf(jsonResponse);
        return;

    }

    //this method get the last parameter in uri after '/'
    //for e.g uri is /apex/asss/12345678, so this method will return 12345678
    /*public static String getUIDFromURI(){
        String[] uriKeys = RestContext.request.requestURI.split('oppassignments/');
        if(uriKeys.size() > 1){
            return uriKeys[1];
        }
        return null;
    }

    //this method return contact record with matching UID
    public static List<Contact> getContactByExternalId(String uid){
        return [select id, Name from Contact where UID__c=:uid];
    }

    //this method creates Opportunity Assignment records for the given StudentID/UID
    @HttpPost
    global static void doPost() {
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');

        String jsonResponse;

        //return RestContext.request.requestBody.toString();
        PostOppResponseModel rm = new PostOppResponseModel();

        try{
            //getting UID from URL
            String uid = getUIDFromURI();
            if(String.isNotBlank(uid)){
                //querying Contact record for the matching UID
                List<Contact> conList = getContactByExternalId(uid);
                if(conList.size()>0){
                    Contact con = conList[0];

                    //populating Student UID & Name in response
                    rm.UID = uid;
                    rm.StudentName = con.Name;

                    //parsing the json request body
                    String jsonData = RestContext.request.requestBody.toString();
                    rm.Opportunities = 
                            (List<PostOppDetailsWrapper>) System.JSON.deserialize(jsonData, List<PostOppDetailsWrapper>.class);

                    if(rm.Opportunities == null || rm.Opportunities.size()==0){
                        res.statusCode = 200;
                        jsonResponse = JSON.serialize(new ErrorModel('No opportunity data received for creation', 'Error'));
                    }else{

                        Set<String> oppIds = new Set<String>();
                        Set<String> invalidOppIds = new Set<String>();
                        Set<String> duplicateOppIds = new Set<String>();
                        Map<String, Opportunity__c> oppMap = new Map<String, Opportunity__c>();
                        Integer totalSuccess=0;

                        //Validating Opportunity IDS in request body
                        //adding response error message for records where:
                            //Duplicate Opportunity exists in request, so skipped
                            //OpportunityId Missing
                        //Also collecting the remaining opportunity ids in a set
                        for(PostOppDetailsWrapper model:rm.Opportunities){
                            if(String.isNotBlank(model.OpportunityId)){
                                if(!invalidOppIds.contains(model.OpportunityId)) //collecting oppIds
                                    invalidOppIds.add(model.OpportunityId);
                                else //adding response error message for duplicate opp ids
                                    model.ResponseStatus = 'Duplicate Opportunity exists in request, so skipped';
                            }else //adding response error message for record where OppId is missing/null
                                model.ResponseStatus = 'OpportunityId Missing';
                        }

                        //fetching Opportunity records for the collected OppIds
                        //so returned Opps records would refer to valid opp ids in the collection 
                        for(Opportunity__c opp:[select id, Name,  
                                                (
                                                    select id, Student__c from Opportunity_Assignments__r
                                                    where Student__c=:con.Id AND Active__c=true
                                                ) 
                                            from Opportunity__c where Id in:invalidOppIds])
                        {
                            //collecting the opportunities
                            oppMap.put(opp.Id+'', opp);
                            //removing valid opp ids from set, so remaining would be invalid
                            invalidOppIds.remove(opp.Id);

                            //checking if given OppId already has related OppAssignment records then adding to duplicate list
                            if(opp.Opportunity_Assignments__r.size()>0)
                                duplicateOppIds.add(opp.Id);
                            else //else adding to set for creating new OppAssignment record
                                oppIds.add(opp.Id);
                        }

                        //adding response error message for invalid OppId & duplicate OppId records in json model data
                        for(PostOppDetailsWrapper model:rm.Opportunities){
                            model.OpportunityName = oppMap.containsKey(model.OpportunityId) ? oppMap.get(model.OpportunityId).Name : null;

                            if(String.isBlank(model.ResponseStatus)){
                                if(invalidOppIds.contains(model.OpportunityId)){
                                    model.ResponseStatus = 'Opportunity does not exists';
                                }else if(duplicateOppIds.contains(model.OpportunityId))
                                    model.ResponseStatus = 'Duplicate Opportunity for the Student';
                            }
                        }

                        //fetching Opportunity Assignment Active RecordTypes, and storing in a map by name
                        Map<String,Id> rtMapByName = new Map<String,Id>();
                        //Create a map between the Record Type Name and Id for easy retrieval
                        Map<String,String> accountRecordTypes = new Map<String,String>{};
                        for(RecordType rt: [Select Name, Id From RecordType 
                                            where sObjectType='Opportunity_Assignment__c' and isActive=true])
                            rtMapByName.put(rt.Name,rt.Id);

                        //adding OppAssignment record in map for valid ids from request
                        List<Opportunity_Assignment__c> oppAssignments = new List<Opportunity_Assignment__c>();
                        for(PostOppDetailsWrapper model:rm.Opportunities){
                            if(String.isBlank(model.ResponseStatus) && oppIds.contains(model.OpportunityId)){
                                oppAssignments.add(
                                    new Opportunity_Assignment__c(
                                        Student__c = con.Id,
                                        Opportunity__c = model.OpportunityId,
                                        Status__c = model.Status,
                                        Linkage_Not_Achieved__c = model.LinkageNotAchieved,
                                        RecordTypeId = rtMapByName.get(model.RecordType_Name),
                                        Active__c = true
                                    )
                                );
                            }
                        }

                        if(oppAssignments.size()>0){
                            Map<String,String> resultMap = new Map<String,String>();

                            //creating OppAssignment records
                            Database.SaveResult[] results = Database.insert(oppAssignments, false);                        
                            //handling errors on failed records
                            for(Integer index = 0; index < results.size(); index++) {
                                String msg = '';
                                if(results[index].isSuccess()) {
                                    msg = 'Created';
                                    totalSuccess++;
                                }else{
                                    //adding message for failed records
                                    for(Database.Error err:results[index].getErrors()){
                                        if(msg != '')
                                            msg += ',';
                                        msg += err.getStatusCode()+', '+err.getMessage()+', '+err.getFields();
                                    }
                                }
                                resultMap.put(oppAssignments[index].Opportunity__c,msg);
                            }

                            //adding response for Opp records 
                            for(PostOppDetailsWrapper model:rm.Opportunities){
                                if(
                                    String.isBlank(model.ResponseStatus) &&
                                    resultMap.containsKey(model.OpportunityId)
                                ){
                                    //adding response status for created/failed OppAssignment records
                                    model.ResponseStatus = resultMap.get(model.OpportunityId); 
                                }
                            }
                        }

                        //adding a genric response message and status for the request 
                        //based on number of records success/failed
                        if(totalSuccess > 0 && totalSuccess == rm.Opportunities.size()){
                            rm.message = 'All opportunities created successfuly';
                            rm.result = 'Success';
                            res.statusCode = 201;
                        }else if(totalSuccess > 0){
                            rm.message = 'Some opportunities are not created';
                            rm.result = 'Partial Success';
                            res.statusCode = 206;
                        }else{
                            rm.message = 'No opportunities has created';
                            rm.result = 'Error';
                            res.statusCode = 200;
                        }

                        //converting response model in json
                        jsonResponse = JSON.serialize(rm);
                    }
                }else{ //returning response error message, when no data is processed
                    jsonResponse = JSON.serialize(new ErrorModel('Invalid student id', 'Error'));
                    res.statusCode = 200;
                }
            }else{ //returning response error message, when no data is processed
                jsonResponse = JSON.serialize(new ErrorModel('Missing student id', 'Error'));
                res.statusCode = 200;
            }
        }catch(Exception e){  //returning response error message, when a run time exception happened
            jsonResponse = JSON.serialize(new ErrorModel('No opportunities has created, '+e.getMessage()+ '=='+e.getCause()+'=='+e.getLineNumber(), 'Error'));
            res.statusCode = 200;
        }

        res.responseBody = blob.valueOf(jsonResponse);
        return;
    }*/

    public class PostOppResponseModel {
        public List < PostOppDetailsWrapper > Opportunities;
        public String UID;
        public String StudentName;
        public String result;
        public String message;
    }

    public class GetOppResponseModel {
        public List < GetOppDetailsWrapper > OpportunityAssignments;
        public String message;
    }

    /*public class ErrorModel{
        public String message;
        public String result;

        public ErrorModel(String msg, String result){
            this.message = msg;
            this.result = result;
        }
    }*/
    public class PostOppDetailsWrapper {
        public String OpportunityId;
        public String OpportunityName;
        public Boolean LinkageNotAchieved;
        public String RecordType_Name;
        public String Status;
        public String ResponseStatus;
    }

    public class GetOppDetailsWrapper {
        public string name;
        public string id;
        public string studentid;
        public string job_start_date;
        public string payroll_details;
        public string salary;
        public string status;
        public string last_status_changed_on;
        public string reasons_for_rejection;
        public string reasons_for_leaving;
        //public string comments;
        public string left_job_date;
        //public string admission_gained_date;
        //public string educationachieveddate;
        public boolean linkage_not_achieved;
        // public boolean blacklisted;
        public boolean active;
        public string course_started_date;
        public string course_completed_date;
        public string student_uid;
        public string opportunityID;
        public string opportunity_name;
        public string recordtype_name;
        public string recordtypeId;
        public string education_achieved_date;
        public boolean isdeleted;
        public boolean created_via_app;
        public string opportunity_unique_id;
        public string applicant_job_status;
        public string continued_working_for_1_year_date;
        public string continued_working_for_3_months_date;
        public string continued_working_for_6_months_date;
        public string student_interview_date;
        //public string student_scheduled_interview_date;
        

        //this wrapper constructor, copies the OppAssignment record fields into wrapper model
        public GetOppDetailsWrapper(Opportunity_Assignment__c oppAss) {
            this.name = oppAss.name;
            this.id = oppAss.id;
            this.recordtypeId = oppAss.RecordTypeId;
            this.studentid = oppAss.Student__c;
            this.student_uid = oppAss.student__r.UID__c;
            this.reasons_for_rejection = oppAss.Reasons_for_Rejection__c;
            this.reasons_for_leaving = oppAss.Reasons_for_Leaving__c;
            this.last_status_changed_on = string.valueOf(oppAss.Last_Status_changed_on__c);
            this.left_job_date = string.valueOf(oppAss.Left_Job_Date__c);
            this.job_start_date = string.valueOf(oppAss.Job_Start_Date__c);
            //this.admission_gained_date=string.valueOf(oppAss.Admission_gained_Date__c);
            this.linkage_not_achieved = oppAss.Linkage_Not_Achieved__c;
            this.active = oppAss.Active__c;
            this.course_started_date = string.valueOf(oppAss.Course_start_Date__c);
            this.course_completed_date = string.valueOf(oppAss.Course_completed_Date__c);
            this.education_achieved_date = string.valueOf(oppAss.Education_achieved_Date__c);
            this.continued_working_for_1_year_date = string.valueOf(oppAss.Continued_working_for_1_year_Date__c);
            this.continued_working_for_3_months_date =string.valueOf(oppAss.Continued_working_for_3_months_Date__c);
            this.continued_working_for_6_months_date =string.valueOf(oppAss.Continued_working_for_6_months_Date__c);
            this.isdeleted = oppAss.IsDeleted;
            this.created_via_app = oppAss.Created_Via_App__c;
            this.applicant_job_status = oppAss.Applicant_Job_Status__c;
            this.opportunityId = oppAss.Opportunity__c;
            this.opportunity_unique_id = oppAss.Opportunity__r.Opportunity_Unique_Id__c;
            this.opportunity_name = oppAss.Opportunity__r.Name;
            this.linkage_not_achieved = oppAss.Linkage_Not_Achieved__c;
            this.recordType_Name = oppAss.RecordTypeId != null ? oppAss.RecordType.Name : null;
            this.status = oppAss.Status__c;
            this.student_interview_date = string.valueof(oppAss.Interview_scheduled_Date__c);
            this.payroll_details = string.valueof(oppAss.Payroll_details__c);
            this.salary = string.valueof(oppAss.Gross_Salary_monthly__c);
            //this.student_scheduled_interview_date = string.valueof(oppAss.Interview_scheduled_Date__c);
            //this.StudentName = oppAss.Student__r.Name;
        }

    }
    /*

        @HttpPut
        global static String updateObject() {

            String obj;

            return obj;

        }

        @HttpDelete
        global static void remove() {

        }*/

}