/*
created by Kandisatech
Description: Class is created to Update student records from external App.
*/
@RestResource(urlMapping = '/placements/student/*')
global class contactUpdateRestApi {

    @HttpPost
    global static void findallcontact() {
        RestRequest req = RestContext.request;
        system.debug('req' + req);
        RestResponse res = RestContext.response;
        //listOfConWrap  reqBodyObj = Detail; 
        res.addHeader('Content-Type', 'application/json');
        string jsonResponse = '';
        string strRequestBody = req.requestBody.toString();
        system.debug('strRequestBody:' + strRequestBody);

        ContactDetails Detail = parse(strRequestBody);
        system.debug('Detail:' + Detail);

        //if(responseWrapper.id != null && responseWrapper.id != ''){

        list < responseWrapper > resToReturn = new list < responseWrapper > ();
        try {
            //to store error contacts
            //map < string, ContactDetail > errorContactMap = new map < string, ContactDetail > ();
            //To update contact records
            list < contact > listcont = new list < contact > ();
            // list<listOfConWrap> wropcon = listOfConWrap;
            if (Detail.Detail != null && Detail.Detail.size() > 0) {
                set < id > conIds = new set < id > ();
                for (cls_Detail conWrap: Detail.Detail) {
                    if (string.isNotBlank(conWrap.id)) {
                        if (!conIds.contains(conWrap.Id)) {
                            contact cont = new contact(id = conWrap.id);
                            cont.Salutation = conWrap.Salutation.trim();
                            cont.firstName = conWrap.firstName.trim();
                            cont.lastName = conWrap.lastName.trim();
                            cont.UID__c = conWrap.uid.trim();
                            //cont.Batch_Name__c = conWrap.batch_name.trim();
                            //cont.Name_of_Trainer__c = conWrap.name_of_trainer.trim();
                            cont.phone = conWrap.phone.trim();
                            system.debug(conWrap.phone);
                            cont.MobilePhone = conWrap.mobilephone.trim();
                            //cont.HomePhone = conWrap.homePhone.trim();
                            if(conWrap.otherphone != null){
                              cont.OtherPhone = conWrap.otherphone.trim();
                            }
                            cont.email = conWrap.Email.trim();
                            cont.Marital_status__c = conWrap.marital_status;
                            cont.BirthDate = Date.valueOf(conWrap.birthdate);
                            cont.Gender__c = conWrap.gender.trim();
                            if(String.isNotBlank(conWrap.english_fluency)){
                               cont.English_Fluency__c = conWrap.english_fluency.trim();
                            }
                            if(String.isNotBlank(conWrap.digital_literacy)){
                            cont.Digital_Literacy__c = conWrap.digital_literacy.trim();
                            }
                            if(String.isNotBlank(conWrap.plan_a)){
                            cont.Plan_A__c = conWrap.plan_a.trim();
                            }
                            if(String.isNotBlank(conWrap.available_for_career_linkage)){
                            cont.Available_for_Career_Linkage__c = conWrap.available_for_career_linkage.trim();
                            }
                            
                            
                            String unavailabilityReason = conWrap.reason_for_career_linkage_unavilability;
                            if(String.isNotBlank(unavailabilityReason) && Contact_ReasonForUnavailability.MAP_EXTERNAL_SYSTEM_VALUES.containsKey(unavailabilityReason)){
                                cont.Reason_for_career_linkage_unavilability__c = Contact_ReasonForUnavailability.MAP_EXTERNAL_SYSTEM_VALUES.get(unavailabilityReason);
                            }else{
                                cont.Reason_for_career_linkage_unavilability__c = unavailabilityReason;
                            }
                            /*if(String.isNotBlank(conWrap.reason_for_career_linkage_unavilability)){
                            cont.Reason_for_career_linkage_unavilability__c = conWrap.reason_for_career_linkage_unavilability.trim();
                            }*/
                            
                            
                            if(String.isNotBlank(conWrap.type_of_career_linkage)){
                            cont.Type_of_Career_linkage__c = conWrap.type_of_career_linkage.trim();
                            }
                            cont.Additional_courses__c = conWrap.additional_courses.trim();
                            cont.Location__c = conWrap.location.trim();
                            
                            if(String.isNotBlank(conWrap.education_status)){
                            cont.Education_Status__c = conWrap.education_status.trim();
                            }
                            if(String.isNotBlank(conWrap.education_level)){
                            cont.Education_Level__c = conWrap.education_level.trim();
                            }
                            if(String.isNotBlank(conWrap.education)){
                            cont.Current_Education__c = conWrap.education.trim();
                            }
                            if(String.isNotBlank(conWrap.plan_b)){
                            cont.Plan_B__c = conWrap.plan_b.trim();
                            }
                            cont.Available_work_Days__c = conWrap.available_work_days.trim();
                            if(conWrap.available_working_hours_start_time != null){
                                time t2 = conWrap.available_working_hours_start_time.addHours(5).addMinutes(30);
                                cont.Available_working_Hours_Start_Time__c = t2;// conWrap.available_working_hours_start_time;
                            }
                            
                            if(conWrap.available_working_hours_finish_time != null){
                                time t3 = conWrap.available_working_hours_finish_time.addHours(5).addMinutes(30);
                                cont.Available_working_Hours_Finish_Time__c = t3;
                            }
                            cont.Work_experience_total__c = conWrap.work_experience_total.trim();
                            cont.Blacklisted__c = conWrap.blacklisted.trim();
                            cont.App_Password__c = conWrap.app_password.trim();
                            cont.Disable_App_Login__c = conWrap.disable_app_login;
                            cont.Trainer_s_Contact_No__c = conWrap.trainer_s_contact_no.trim();
                            cont.Student_Last_Login_Date__c = Date.valueOf(conWrap.student_last_login_date);
                            cont.Student_Profile_Picture__c = conWrap.student_profile_picture.trim();
                            cont.id = conWrap.id;
                            cont.Date_for_Placements_re_engage__c = conWrap.Date_for_Placements_re_engage;
                            conIds.add(conWrap.Id);
                            listcont.add(cont);
                        } else {
                            responseWrapper resCon = new responseWrapper();

                            resCon.Contactid = conWrap.Id;
                            resCon.status = 'fail';
                            resCon.message = 'Duplicate Contact Id.';
                            resToReturn.add(resCon);
                            string JSONS = JSON.serialize(resCon);
                            if (JSONS.length() > 131000) {
                                JSONS = JSONS.left(131000);
                            }
                            Log__c log = CatchLogs.createLog('Error', '', 0, 0, 'POSTContactUpdateRestApi', 'Duplicate Contact Id.', JSONS);
                            insert log;

                        }

                    } else {
                        responseWrapper resCon = new responseWrapper();

                        resCon.Contactid = '';
                        resCon.status = 'fail';
                        resCon.message = 'Student Id required.';
                        resToReturn.add(resCon);
                        string JSONS = JSON.serialize(resCon);
                        if (JSONS.length() > 131000) {
                            JSONS = JSONS.left(131000);
                        }
                        Log__c log = CatchLogs.createLog('Error', '', 0, 0, 'POSTContactUpdateRestApi', 'Student Id required.', JSONS);
                        insert log;

                    }

                }
            }

            // if(listcont.size() > 0){

            system.debug('listcont:' + listcont);
            Database.SaveResult[] updateresults = Database.Update(listcont, false);
            system.debug('updateresults:' + updateresults);
            //map < Id, List < responseWrapper >> mapconAssignments = new map < Id, List < responseWrapper >> ();
            for (Integer index = 0, size = updateresults.size(); index < size; index++) {
                Contact con = listcont[index];
                responseWrapper resCon = new responseWrapper();
                String msg = '';
                resCon.Contactid = con.id;
                resCon.status = updateresults[index].isSuccess() ? 'Success' : 'fail';
                system.debug('updateresults@@@@@:' + updateresults[index]);
                //resCon.message = updateresults[index].getErrors()[index].getMessage();
                for (Database.Error err: updateresults[index].getErrors()) {
                    if (msg != '')
                        msg += ',';
                    msg += err.getStatusCode() + ', ' + err.getMessage() + ', ' + err.getFields();
                }
                resCon.message = msg;
                resToReturn.add(resCon);
                /*
                if(mapconAssignments.containskey(con.id)){
                    mapconAssignments.get(con.id).add(resCon);
                } else {
                    mapconAssignments.put(con.id, new  List<responseWrapper>{resCon});
                }
                */

            }

            jsonResponse = '{"status": "success", "contacts":"' + JSON.serialize(resToReturn) + '"}';
           // if (jsonResponse.length() > 131000) {
            //    jsonResponse = jsonResponse.left(131000);
            //}
           // Log__c log = CatchLogs.createLog('Info', '', resToReturn.size(), 0, 'POSTContactUpdateRestApi', 'Success', jsonResponse);
           // insert log;
            res.responseBody = Blob.valueof(jsonResponse);

        } catch (Exception ex) {

            jsonResponse = '{"status": "fail", "message":"' + ex.getMessage() + ' at ' + ex.getLineNumber() + '"}';
            if (jsonResponse.length() > 131000) {
                jsonResponse = jsonResponse.left(131000);
            }
            Log__c log = CatchLogs.createLog('Error', '', 0, 0, 'POSTContactUpdateRestApi', ex.getMessage(), jsonResponse);
            insert log;
            res.responseBody = Blob.valueof(jsonResponse);

            //return;
            //return 'message:' + ex.getMessage() + ' at ' + ex.getLineNumber();
        }
        res.responsebody = blob.valueOf(JSON.serialize(resToReturn));
        //return blob.valueOf(JSON.serialize(resToReturn));
        // return JSON.serialize(resToReturn);
    }

    global class ContactDetails {
        public cls_Detail[] Detail;
    }
    class cls_Detail {
        public String Salutation; //Mr.
        public String firstName; //testing
        public String lastName; //testbk1
        public String uid; //85236
        //public String batch_name; //0017F00001iyRAA
        //public String name_of_trainer; //003O000001K6Vg5
        public Integer monthly_salary_currently; //0
        public String phone; //8528528525
        public String mobilephone; //9696969696
        //public String homePhone; //8542158721
        public string otherphone;
        public String email; //tets@abc.com
        public String marital_status; //single
        public date birthdate; //2019-05-08
        public String gender; //male
        public String english_fluency; //Not present
        public String digital_literacy; //Level 4
        public String plan_a; //Accounting
        public String available_for_career_linkage; //no
        public String reason_for_career_linkage_unavilability; //Currently working
        public String type_of_career_linkage; //Part time employment
        public String additional_courses; //Basic Tally;Advanced Excel
        public String location; //Andheri
        public String zone; //Airoli
        public String education_status; //Completed
        public String education_level; //Graduate
        public String education;
        public String plan_b; //Animation
        public String available_work_days; //Monday;Tuesday
        public Time available_working_hours_start_time;
        public Time available_working_hours_finish_time;
        public String work_experience_total; //-1
        public boolean isdeleted;
        public String blacklisted; //no
        public String app_password; //pass
        public boolean disable_app_login;
        public String trainer_s_contact_no; //852125634
        public Date student_last_login_date; //2019-06-09
        public String student_profile_picture; //http://dummy.restapiexample.com/api/v1/create
        public String id; //003O000001FaYfU
        public String createddate; //2019-06-03 04:00:00
        public String lastmodifieddate; //2019-06-03 04:00:00
        public Date Date_for_Placements_re_engage;
    }

    public static ContactDetails parse(String json) {
        return (ContactDetails) System.JSON.deserialize(json, ContactDetails.class);
    }

    public class responseWrapper {
        public string status;
        //public Contact ContactInfo;
        public string message;
        public string Contactid;
    }
}