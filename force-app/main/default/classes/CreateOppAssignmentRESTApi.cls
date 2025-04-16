/*
    Description: Class is created to create opportunity assignment records from any external App.
*/
@RestResource(urlMapping = '/placements/assignments/*')
global class CreateOppAssignmentRESTApi {

    @HttpPost
    global static list < wrapOppAssignResponse > CreateOppAssignments() {
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
        string Acctoken = setting.AccessToken__c;
        RestRequest req = RestContext.request;
        system.debug('req' + req);
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        try {
            string strRequestBody = req.requestBody.toString();
            system.debug('strRequestBody ::: ' + strRequestBody);

            wrapMain main = (wrapMain) json.deserialize(strRequestBody, wrapMain.class);
            List < wrapOpportunity > lstWrapOpportunities = main.opportunities;
            system.debug('lstWrapOpportunities ::: ' + lstWrapOpportunities);
            //storing oppty uid
            set < string > opptyUId = new set < string > ();
            map < string, string > mapoptyuid = new map < string, string > ();



            List < Opportunity_Assignment__c > lstOppAssignments = new List < Opportunity_Assignment__c > ();
            map < string, string > opptyRecordType = new map < string, string > ();

            for (wrapOpportunity wopp: lstWrapOpportunities) {
                opptyUId.add(wopp.opportunityid);
            }
            for (opportunity__c oppty: [select id, Opportunity_Unique_Id__c from opportunity__c where Opportunity_Unique_Id__c =: opptyUId]) {
                mapoptyuid.put(oppty.Opportunity_Unique_Id__c, oppty.id);
            }

            map < String, String > OppAssignMentRecordTypeMap = new map < string, string > ();
            set < String > recordTypeNames = new set < String > ();
            if (!mapoptyuid.isEmpty()) {
                for (opportunity__c oppRecord: [select id, recordtype.Name from opportunity__c where id in: mapoptyuid.values()]) {
                    opptyRecordType.put(oppRecord.id, oppRecord.recordtype.Name);
                    recordTypeNames.add(oppRecord.RecordType.Name);
                }
                //system.debug('**recordTypeNames' + recordTypeNames);
                //system.debug('**opptyRecordType' + opptyRecordType);
                for (RecordType rt: [Select Id, Name from RecordType where Name in: recordTypeNames and SObjectType = 'Opportunity_Assignment__c']) {

                    OppAssignMentRecordTypeMap.put(rt.Name, rt.Id);
                }
                system.debug('**OppAssignMentRecordTypeMap' + OppAssignMentRecordTypeMap);
            }

            for (wrapOpportunity wopp: lstWrapOpportunities) {
                for (wrapOppAssignments wrapoa: wopp.assignments) {
                    Opportunity_Assignment__c oppassign = new Opportunity_Assignment__c();

                    if (string.isnotblank(wrapoa.id)) {
                        oppassign.Id = wrapoa.id;
                    }
                    if (string.isblank(wrapoa.id) && string.isnotblank(wrapoa.studentid)) {
                        oppassign.Student__c = wrapoa.studentid;
                    }

                    if (string.isblank(wrapoa.id) && string.isnotblank(wopp.opportunityid)) {
                        oppassign.Opportunity__c = mapoptyuid.get(wopp.opportunityid); //wopp.opportunityid;
                    }
                    if (string.isnotblank(wrapoa.job_start_date)) {
                        oppassign.Job_Start_Date__c = date.valueof(wrapoa.job_start_date);
                    }

                    if (string.isblank(wrapoa.id) && string.isnotblank(wrapoa.applicant_job_status) && wrapoa.applicant_job_status == '1') {
                        oppassign.Status__c = 'Student Curious';
                    } else if (string.isblank(wrapoa.id) && string.isnotblank(wrapoa.applicant_job_status) && wrapoa.applicant_job_status == '2') {
                        oppassign.Status__c = 'Student Interested';
                    } else if (string.isNotblank(wrapoa.id) && wrapoa.status == 'Student Curious' && wrapoa.applicant_job_status == '2') {
                        oppassign.Status__c = 'Student Interested';
                    } else if (string.isnotblank(wrapoa.status)) {
                        oppassign.Status__c = wrapoa.status;
                    }
                    if (string.isnotblank(wrapoa.last_status_changed_on)) {
                        oppassign.Last_Status_changed_on__c = DateTime.valueOf(wrapoa.last_status_changed_on);
                    }

                    if (string.isblank(wrapoa.id)) {
                        System.debug('*OppAssignMentRecordTypeMap' + OppAssignMentRecordTypeMap);
                        system.debug('*Opp Id' + wopp.opportunityid);
                        id optyid = mapoptyuid.get(wopp.opportunityid);
                        system.debug('@@@@' + optyid);
                        system.debug('*opp assign recordtype id' + OppAssignMentRecordTypeMap.get(opptyRecordType.get(optyid)));
                        string recTypeName = opptyRecordType.get(optyid);
                        system.debug('*recTypeName' + recTypeName);
                        system.debug('*recType Id' + OppAssignMentRecordTypeMap.get(recTypeName));
                        oppassign.recordtypeID = OppAssignMentRecordTypeMap.get(recTypeName);
                    }
                    if (string.isnotblank(wrapoa.left_job_date)) {
                        oppassign.Left_Job_Date__c = DateTime.valueOf(wrapoa.left_job_date);
                    }
                    //if (string.isnotblank(wrapoa.admission_gained_date)) {
                    //   oppassign.Admission_gained_Date__c = /*setStringToDateFormat*/DateTime.valueOf(wrapoa.admission_gained_date);
                    //}
                    if (string.isnotblank(wrapoa.course_started_Date)) {
                        system.debug('***' + wrapoa.course_started_Date);
                        oppassign.Course_started_Date__c = Datetime.valueof(wrapoa.course_started_Date);
                    }
                    if (string.isnotblank(wrapoa.course_completed_date)) {
                        oppassign.Course_completed_Date__c = DateTime.valueOf(wrapoa.course_completed_date);
                    }

                    if (string.isnotblank(wrapoa.education_achieved_date)) {
                        oppassign.Education_achieved_Date__c = DateTime.valueOf(wrapoa.education_achieved_date);
                    }
                    if (string.isnotblank(wrapoa.applicant_job_status)) {
                        oppassign.Applicant_Job_Status__c = wrapoa.applicant_job_status;
                    }
                    /*if(string.isnotblank(wrapoa.status) && (wrapoa.status =='Interview appeared')){
                        oppassign.Interview_scheduled_Date__c = System.today();
                    }*/
                    if (string.isnotblank(wrapoa.status) && (wrapoa.status == 'Left Job after 3 months' || wrapoa.status == 'Left Job after 6 months' || wrapoa.status == 'Left job after more than 1 year' ||
                            wrapoa.status == 'Continued working for 3 months' || wrapoa.status == 'Continued working for 6 months')) {
                        oppassign.Payroll_details__c = 'monthly';
                    }
                    /*if(string.isnotblank(wrapoa.status) && (wrapoa.status == 'Left Job after 3 months' || wrapoa.status == 'Left Job after 6 months' || wrapoa.status == 'Left job after more than 1 year' ||
                       wrapoa.status =='Continued working for 3 months' || wrapoa.status =='Continued working for 6 months' )){
                        oppassign.Gross_Salary_monthly__c = 0;
                    }*/

                    oppassign.Created_Via_App__c = wrapoa.created_via_app;
                    if (string.isblank(wrapoa.id)) {
                        oppassign.Linkage_Not_Achieved__c = true;
                    } else {
                        oppassign.Linkage_Not_Achieved__c = wrapoa.linkage_not_achieved;
                    }
                    //oppassign.Blacklisted__c = wrapoa.blacklisted;
                    //oppassign.Active__c = wrapoa.active;
                    lstOppAssignments.add(oppassign);
                }
            }
            Set < id > Setoppassign = new Set < id > ();
            //upsert opp assignment records
            Database.UpsertResult[] upsertresults = Database.upsert(lstOppAssignments, false);
            system.debug('upsertresults' + upsertresults);
            for (Opportunity_Assignment__c opass: lstOppAssignments) {
                Setoppassign.add(opass.id);
            }

            map < id, list < Opportunity_Assignment__c >> mapopptytoget = new map < id, list < Opportunity_Assignment__c >> ();
            for (Opportunity_Assignment__c optlst: [select id, name, Student__c, Student__r.name, Job_Start_Date__c, Status__c, Last_Status_changed_on__c, Reasons_for_Rejection__c, Reasons_for_Leaving__c, recordtypeID, recordtype.name, Left_Job_Date__c, Opportunity_End_Date__c, Opportunity_Start_Date__c,
                    Applicant_Job_Status__c, Education_achieved_Date__c, Course_completed_Date__c, Course_start_Date__c, Student__r.UID__c, Continued_working_for_1_year_Date__c, Continued_working_for_3_months_Date__c, Continued_working_for_6_months_Date__c, Comments__c,
                    Created_Via_App__c, Linkage_Not_Achieved__c, Active__c, Opportunity__c, Opportunity__r.name, Opportunity__r.Opportunity_Unique_Id__c, Interview_scheduled_Date__c, Gross_Salary_monthly__c, Payroll_details__c, IsDeleted from Opportunity_Assignment__c where Id in: Setoppassign
                    AND RecordType.DeveloperName not in ('External_Education', 'External_Employment', 'External_Training')
                ]) {

                if (mapopptytoget.containskey(optlst.id)) {
                    mapopptytoget.get(optlst.id).add(optlst);
                } else {
                    mapopptytoget.put(optlst.id, new list < Opportunity_Assignment__c > {
                        optlst
                    });
                }
            }
            List < wrapOppAssignResponse > OppAssignments = new List < wrapOppAssignResponse > ();

            for (Integer index = 0, size = upsertresults.size(); index < size; index++) {
                list < Opportunity_Assignment__c > oppassign = mapopptytoget.get(lstOppAssignments[index].id);
                wrapOppAssignResponse oppassignresponse = new wrapOppAssignResponse();
                if (upsertresults[index].isSuccess()) {
                    oppassignresponse.oppassignmentid = upsertresults[index].getId();
                    oppassignresponse.message = '';
                    oppassignresponse.apistatus = 'success';
                    oppassignresponse.jobstatus = oppassign[0].Status__c;
                    oppassignresponse.oppassignmentid = oppassign[0].id;
                    oppassignresponse.studentid = oppassign[0].Student__c;
                    oppassignresponse.student_uid = oppassign[0].Student__r.UID__c;
                    oppassignresponse.status = oppassign[0].Status__c;
                    oppassignresponse.recordtypeId = oppassign[0].recordtypeId;
                    oppassignresponse.recordtype_name = oppassign[0].recordtype.name;
                    oppassignresponse.reasons_for_rejection = oppassign[0].Reasons_for_Rejection__c;
                    oppassignresponse.reasons_for_leaving = oppassign[0].Reasons_for_Leaving__c;
                    oppassignresponse.opportunityID = oppassign[0].Opportunity__c;
                    oppassignresponse.opportunity_unique_id = oppassign[0].Opportunity__r.Opportunity_Unique_Id__c;
                    oppassignresponse.opportunity_name = oppassign[0].Opportunity__r.name;
                    oppassignresponse.name = oppassign[0].name;
                    oppassignresponse.linkage_not_achieved = oppassign[0].Linkage_Not_Achieved__c;
                    oppassignresponse.left_job_date = String.valueof(oppassign[0].Opportunity_End_Date__c);
                    oppassignresponse.last_status_changed_on = String.valueof(oppassign[0].Last_Status_changed_on__c);
                    oppassignresponse.job_start_date = String.valueof(oppassign[0].Opportunity_Start_Date__c);
                    oppassignresponse.isdeleted = oppassign[0].IsDeleted;
                    oppassignresponse.id = oppassign[0].id;
                    oppassignresponse.education_achieved_date = String.valueof(oppassign[0].Education_achieved_Date__c);
                    oppassignresponse.created_via_app = oppassign[0].Created_Via_App__c;
                    oppassignresponse.course_started_date = String.valueof(oppassign[0].Opportunity_Start_Date__c);
                    oppassignresponse.course_completed_date = String.valueof(oppassign[0].Opportunity_End_Date__c);
                    oppassignresponse.applicant_job_status = oppassign[0].Applicant_Job_Status__c;
                    oppassignresponse.Continued_working_for_1_year_Date = String.valueof(oppassign[0].Continued_working_for_1_year_Date__c);
                    oppassignresponse.Continued_working_for_3_months_Date = String.valueof(oppassign[0].Continued_working_for_3_months_Date__c);
                    oppassignresponse.Continued_working_for_6_months_Date = String.valueof(oppassign[0].Continued_working_for_6_months_Date__c);
                    oppassignresponse.student_interview_date = String.valueof(oppassign[0].Interview_scheduled_Date__c);
                    oppassignresponse.payroll_detail = oppassign[0].Payroll_details__c;
                    oppassignresponse.salary = String.valueof(oppassign[0].Gross_Salary_monthly__c);
                    oppassignresponse.active = oppassign[0].Active__c;
                    oppassignresponse.authentication_token = Acctoken;

                } else {
                    string errormessage = '';
                    for (Database.Error err: upsertresults[index].getErrors()) {
                        errormessage += err.getMessage();
                    }
                    oppassignresponse.oppassignmentid = upsertresults[index].getId();
                    oppassignresponse.message = errormessage;
                    oppassignresponse.apistatus = 'fail';
                }

                OppAssignments.add(oppassignresponse);
            }


            //string jsons = JSON.serialize(lstresponse);
            //if(jsons.length()>131000){
            //   jsons = jsons.left(131000);
            //}
            // Log__c log = CatchLogs.createLog('Info','',lstresponse.size(),0,'Post OpportunityAssignment','', jsons);
            // insert log;
            //res.statusCode = 200;
            //string jsonResponse = '{"status": "success", "opportunities":"' + Json.serialize(lstresponse) + '"}';

            //res.responseBody = Blob.valueof(jsonResponse);
            system.debug('OppAssignments' + OppAssignments);
            return OppAssignments;

        } catch (Exception ex) {
            List < wrapOppAssignResponse > OppAssignments = new List < wrapOppAssignResponse > ();
            wrapOppAssignResponse oppres = new wrapOppAssignResponse();
            string jsonResponse = '{"status": "fail", "message":"' + ex.getMessage() + ' at ' + ex.getLineNumber() + '"}';
            oppres.message = jsonResponse;
            OppAssignments.add(oppres);
            res.responseBody = Blob.valueof(jsonResponse);
            if (jsonResponse.length() > 131000) {
                jsonResponse = jsonResponse.left(131000);
            }
            Log__c log = CatchLogs.createLog('Error', '', 0, 0, 'Post OpportunityAssignment', ex.getMessage(), jsonResponse);
            insert log;
            return OppAssignments;
        }

    }

    global class wrapMain {
        public List < wrapOpportunity > opportunities;
    }

    global class wrapOpportunity {
        public string opportunityid;
        public List < wrapOppAssignments > assignments;
        //public wrapOppAssignments[] assignments;
    }

    global class wrapOppAssignments {
        public string name;
        public string id;
        public string studentid;
        public string job_start_date;
        //public string pay_roll_details;
        //public decimal gross_salary_monthly;
        public string status;
        public string last_status_changed_on;
        public string reasons_for_rejection;
        public string reasons_for_leaving;
        //public string comments;
        public string left_job_date;
        public boolean linkage_not_achieved;
        //public string recordtypeID;
        // public boolean blacklisted;
        // public string opportunityID;
        public boolean active;
        public string course_started_Date;
        public string course_completed_date;
        public string education_achieved_date;
        public boolean isdeleted;
        public boolean created_via_app;
        //public string opportunity_unique_id;
        public string applicant_job_status;

    }
    /*
        public class wrapOppResponse {
            public string opportunityid;
            public List < wrapOppAssignResponse > assignments;
        }
    */
    global class wrapOppAssignResponse {
        public string oppassignmentid;
        public string jobstatus;
        public string message;
        public string apistatus;
        public string studentid;
        public string student_uid;
        public string status;
        public string recordtypeId;
        public string recordtype_name;
        public string reasons_for_rejection;
        public string reasons_for_leaving;
        public string opportunityID;
        public string opportunity_unique_id;
        public string opportunity_name;
        public string name;
        public boolean linkage_not_achieved;
        public string left_job_date;
        public string last_status_changed_on;
        public string job_start_date;
        public boolean isdeleted;
        public string id;
        public string education_achieved_date;
        public boolean created_via_app;
        public string course_started_date;
        public string course_completed_date;
        public string applicant_job_status;
        public string Continued_working_for_1_year_Date;
        public string Continued_working_for_3_months_Date;
        public string Continued_working_for_6_months_Date;
        public string student_interview_date;
        public string payroll_detail;
        public string salary;
        public boolean active;
        public string authentication_token;
    }

}