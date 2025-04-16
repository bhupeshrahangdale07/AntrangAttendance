@RestResource(urlMapping = '/placements/students/*')
global class ContactRESTApi {

    @HttpGet
    global static void findallcontacts() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');

        string fromdate = string.valueof(req.params.get('fromdate'));
        string todate = string.valueof(req.params.get('todate'));

        string jsonResponse = '';

        List < Contact > lstContacts = new List < Contact > ();
        string strsoql = 'Select id,FirstName,LastName,Salutation,UID__c,AccountId,Account.name,Phone,MobilePhone,Email,CR_Status__c,Monthly_Salary_Currently__c,Name_of_Trainer__r.name,Marital_status__c,BirthDate,' +
            'Gender__c,English_Fluency__c,Digital_Literacy__c,Trainer_s_Contact_No__c, Student_Last_Login_Date__c, Education_Status__c, HomePhone, OtherPhone,' +
            ' Plan_A__c,Available_for_Career_Linkage__c,Type_of_Career_linkage__c,Additional_courses__c,Location__c,Zone_Match_Required__c,Currently_working_not_through_AF_Bline__c,' +
            'Current_Salary_not_through_AF_baseline__c,Zone__c,Education_Level__c,Current_Education__c,Plan_B__c,Available_work_Days__c,Available_working_Hours_Start_Time__c,Available_working_Hours_Finish_Time__c,' +
            'Work_experience_total__c,CreatedById,Batch_Name__r.Batch_Code__c,Batch_Name__r.Batch_Start_Date__c,LastModifiedById,RecordTypeId,RecordType.Name,IsDeleted,Blacklisted__c,Disable_App_Login__c,Date_for_Placements_re_engage__c,'+
            'Student_Profile_Picture__c,Reason_for_career_linkage_unavilability__c,App_Password__c,CreatedDate,LastModifiedDate from Contact where RecordType.name = \'CR Student\'';

        if (fromdate != null && todate != null) {
            DateTime dtStart = DateTime.newInstanceGMT(Integer.valueOf(fromdate.split('-')[0]), Integer.valueOf(fromdate.split('-')[1]), Integer.valueOf(fromdate.split('-')[2]));
            DateTime dtEnd = DateTime.newInstanceGMT(Integer.valueOf(todate.split('-')[0]), Integer.valueOf(todate.split('-')[1]), Integer.valueOf(todate.split('-')[2]), 23, 59, 59);
            system.debug('**'+dtStart);
            system.debug('**'+dtEnd);

            strsoql += 'and (LastModifiedDate >=: dtStart and LastModifiedDate <=: dtEnd)  ';
        }
            lstContacts = Database.query(strsoql);

            if (lstContacts.size() > 0) {

                List < wrapContacts > lstcon = new List < wrapContacts > ();
                for (contact c: lstContacts) {
                    wrapContacts w = new wrapContacts();
                    w.id = c.id;
                    w.salutation = c.Salutation;
                    w.firstName = c.FirstName;
                    w.lastName = c.LastName;
                    w.uid = c.UID__c;
                    
                   /* w.accountname = c.Account.name;
                    w.accountId = c.AccountId;
                    w.donor = c.Donor__c;*/
                    
                    w.batch_name = c.Batch_Name__r.Batch_Code__c;
                    w.name_of_trainer = c.Name_of_Trainer__r.name;
                    w.monthly_salary_currently = c.Monthly_Salary_Currently__c;
                    w.phone = c.Phone;
                    w.mobile = c.MobilePhone;
                    w.otherphone = c.OtherPhone;
                    w.email = c.Email;
                    
                  /*  w.studentstatus = c.Student_Status__c;
                    w.mailingcity = c.MailingCity;
                    w.mailingcountry = c.MailingCountry;
                    w.mailingpostalcode = c.MailingPostalCode;
                    w.mailingstate = c.MailingState;
                    w.mailingstreet = c.MailingStreet;*/
                    
                    w.marital_status = c.Marital_status__c;
                    w.birthdate = string.valueof(c.BirthDate);
                    w.gender = c.Gender__c;
                    w.datefoplacementsreengage = string.valueOf(c.Date_for_Placements_re_engage__c);
                    
                   /* w.profession1 = c.Profession_1__c;
                    w.profession2 = c.Profession_2__c;
                    w.dateofmockinterview = string.valueof(c.Date_of_Mock_Interview__c);
                    w.educationbaseline = c.Current_Education_baseline__c;
                    w.educationstatusbaseline = c.Education_Status_baseline__c;*/
                    
                    w.english_fluency = c.English_Fluency__c;
                    w.digital_literacy = c.Digital_Literacy__c;
                    w.plan_a = c.Plan_A__c;
                    w.available_for_career_linkage = c.Available_for_Career_Linkage__c;
                    w.type_of_career_linkage = c.Type_of_Career_linkage__c;
                    w.additional_courses = c.Additional_courses__c;
                    w.location = c.Location__c;
                    
                   /* w.zonematchrequired = c.Zone_Match_Required__c;
                    w.workingnotthroughafbaseline = c.Currently_working_not_through_AF_Bline__c;
                    w.salarynotthroughafbbaseline = c.Current_Salary_not_through_AF_baseline__c;*/
                    
                    w.zone = c.Zone__c;
                    w.education_level = c.Education_Level__c;
                    w.education = c.Current_Education__c;
                    w.plan_b = c.Plan_B__c;
                    w.available_work_days = c.Available_work_Days__c;
                    w.available_working_hours_start_time = c.Available_working_Hours_Start_Time__c;
                    w.available_working_hours_finish_time = c.Available_working_Hours_Finish_Time__c;
                    w.work_experience_total = c.Work_experience_total__c;
                    
                   /* w.createdbyid = c.createdbyID;
                    w.lastmodifiedbyId = c.LastModifiedById;
                    w.apistatus = c.API_Status__c;
                    w.recordtypename = c.RecordType.Name;
                    w.recordtypeid = c.RecordTypeId;*/
                    
                    w.isdeleted = c.IsDeleted;
                    w.blacklisted = c.Blacklisted__c;
                    w.app_password = c.App_Password__c;
                    w.disable_app_login =c.Disable_App_Login__c;
                    w.trainer_s_contact_no = c.Trainer_s_Contact_No__c;
                    w.student_last_login_date =string.valueof(c.Student_Last_Login_Date__c);
                    w.education_status =c.Education_Status__c;
                    w.batch_start_date = String.valueof(c.Batch_Name__r.Batch_Start_Date__c);
                    //w.homephone = c.HomePhone;
                    w.student_profile_picture = c.Student_Profile_Picture__c;
                    
                    String unavailabilityReason = c.Reason_for_career_linkage_unavilability__c;
                    if(String.isNotBlank(unavailabilityReason) && Contact_ReasonForUnavailability.MAP_SF_PICKLIST_VALUES.containsKey(unavailabilityReason)){
                        w.reason_for_career_linkage_unavilability = Contact_ReasonForUnavailability.MAP_SF_PICKLIST_VALUES.get(unavailabilityReason);
                    }else{
                        w.reason_for_career_linkage_unavilability = unavailabilityReason;
                    }
                    
                    //w.reason_for_career_linkage_unavilability = c.Reason_for_career_linkage_unavilability__c;
                    w.createddate = string.valueof(c.CreatedDate);
                    w.lastModifieddate =string.valueof(c.LastModifiedDate);
                    lstcon.add(w);
                }
                    system.debug('lstcon:'+lstcon);
                res.statusCode = 200;

                jsonResponse = '{"result": "sucess","message":"record(s) found.", "students":' + JSON.serialize(lstcon) + '}';
                //if(jsonResponse.length()>131000){
                //jsonResponse = jsonResponse.left(131000);
            //}
                //Log__c log = CatchLogs.createLog('Info','',lstcon.size(),0,'fromdate ='+fromdate +'/'+ 'todate ='+todate +'GETContactRESTApi','Record(s) found', jsonResponse);
                //insert log;

            } else {
                res.statusCode = 200;
                jsonResponse = '{"result": "error","message":"No  students exist."}';
                 if(jsonResponse.length()>131000){
                jsonResponse = jsonResponse.left(131000);
            }
                Log__c log = CatchLogs.createLog('Error','',0,0,'fromdate ='+fromdate +'/'+ 'todate ='+todate +'GETContactRESTApi','No  students exist.', jsonResponse);
                insert log;
            }

            res.responseBody = blob.valueOf(jsonResponse);
            return;

    }

    public static string stripJsonNulls(string JsonString) {
        if (JsonString != null) {
            JsonString = JsonString.replaceAll('\"[^\"]*\":null', ''); //basic removeal of null values
            JsonString = JsonString.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
            JsonString = JsonString.replace('{,', '{'); //prevent opening brace from having a comma after it
            JsonString = JsonString.replace(',}', '}'); //prevent closing brace from having a comma before it
            JsonString = JsonString.replace('[,', '['); //prevent opening bracket from having a comma after it
            JsonString = JsonString.replace(',]', ']'); //prevent closing bracket from having a comma before it
        }

        return JsonString;
    }
    public class wrapContacts{
        public string id{get;set;}
        public string salutation{get;set;}
        public string firstName{get;set;}
        public string lastName{get;set;}
        public string uid{get;set;}
        
        //public string accountname{get;set;}
       // public string accountId{get;set;}
       // public string donor{get;set;}
       
        public string batch_name{get;set;}
        public string name_of_trainer{get;set;}
        public decimal monthly_salary_currently{get;set;}
        public string phone{get;set;}
        public string mobile{get;set;}
        public string otherphone{get;set;}
        public string email{get;set;}
        
       /* public string studentstatus{get;set;}
        public string mailingcity{get;set;}
        public string mailingcountry{get;set;}
        public string mailingpostalcode{get;set;}
        public string mailingstate{get;set;}
        public string mailingstreet{get;set;}*/
        
        public string marital_status{get;set;}
        public string birthdate{get;set;}
        public string gender{get;set;}
        public string datefoplacementsreengage{get;set;}
        
       /* public string profession1{get;set;}
        public string profession2{get;set;}
        public string dateofmockinterview{get;set;}
        public string educationbaseline{get;set;}
        public string educationstatusbaseline{get;set;}*/
        
        public string english_fluency{get;set;}
        public string digital_literacy{get;set;}
        public string plan_a{get;set;}
        public string available_for_career_linkage{get;set;}
        public string type_of_career_linkage{get;set;}
        public string additional_courses{get;set;}
        public string location{get;set;}
        
       /* public string zonematchrequired{get;set;}
        public string workingnotthroughafbaseline{get;set;}
        public string salarynotthroughafbbaseline{get;set;}*/
        
        public string zone{get;set;}
        public string education_level{get;set;}
        public string plan_b{get;set;}
        public string available_work_days{get;set;}
        public time available_working_hours_start_time{get;set;}
        public time available_working_hours_finish_time{get;set;}
        public string work_experience_total{get;set;}
        
        /*public string createdbyid{get;set;}
        public string lastmodifiedbyid{get;set;}
        public string apistatus{get;set;}
        public string recordtypename{get;set;}
        public string recordtypeid{get;set;}*/
        
        public boolean isdeleted{get;set;}
        public string blacklisted{get;set;}
        public string app_password{get;set;}
        public boolean disable_app_login{get;set;}
        public string trainer_s_contact_no{get;set;}
        public string student_last_login_date{get;set;}
        public string education_status{get;set;}
        public string education{get;set;}
        //public string homephone{get;set;}
        
        public string student_profile_picture{get;set;}
        public string batch_start_date{get;set;}
        public string reason_for_career_linkage_unavilability{get;set;}
        public string createddate{get;set;}
        public string lastModifieddate{get;set;}
        
       
        
       
    }
}