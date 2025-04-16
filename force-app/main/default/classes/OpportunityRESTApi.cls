@RestResource(urlMapping='/placements/opportunities/*')
global class OpportunityRESTApi{
    
    @HttpGet
    global static void findallopportunity() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        res.addHeader('Content-Type', 'application/json');
        
        string fromdate =  string.valueof(req.params.get('fromdate'));
        string todate =  string.valueof(req.params.get('todate'));
        String URL = '';
        string jsonResponse = '';
        
        List<Opportunity__c> lstOpportunities = new List<Opportunity__c>();
        string strsoql = 'select Id,Name,RecordType.DeveloperName,RecordTypeId,Type_of_opportunity__c,Educational_Level__c,English_fluency__c,' +
            'Work_Days__c,Work_experience__c,Allotted_No_of_Opening__c,No_of_remaining_Openings__c,Additional_courses__c,' + 
            'Account__c,Account__r.name,Profession__c,Digital_Literacy__c,Course_Start_date__c,Recordtype.name,Opportunity_Description_Clip__c,' + 
            'No_of_Openings__c,Working_Hours_Start_Time__c,Working_Hours_End_Time__c,Is_Opportunity_Closed__c,' + 
            'Location__c,Zone__c,Gender__c,Account__r.website,Detailed_Job_Description__c,Address__c,Admission_Process__c,' + 
            'Salary_in_hand_monthly__c,Payroll_details__c,IsDeleted,Detailed_course_description__c, ' + 
            'Career_Progression_For_the_role__c,Duration__c,Admission_Schedule__c,Training_Days__c,Recurrence_Schedule__c,LastModifiedDate, ' +
            'Training_Hours_Start_Time__c, Training_Hours_End_Time__c,Post_Course_Placement__c,Recruitment_Process__c,Fees_Associated_costs__c,No_of_peers_looking_at_the_opportunity__c,Number_of_profile_matches__c, '+
            'Required_Documents__c, Opportunity_Unique_Id__c,Industry_name__c, createddate'+
            ' from Opportunity__c Where RecordType.DeveloperName not in (\'External_Education\',\'External_Employment\',\'External_Training\')';
        
        if(fromdate != null && todate != null){
            DateTime dtStart = DateTime.newInstanceGMT(Integer.valueOf(fromdate.split('-')[0]), Integer.valueOf(fromdate.split('-')[1]), Integer.valueOf(fromdate.split('-')[2]));
            DateTime dtEnd = DateTime.newInstanceGMT(Integer.valueOf(todate.split('-')[0]), Integer.valueOf(todate.split('-')[1]), Integer.valueOf(todate.split('-')[2]),23,59,59);
            
            strsoql += ' and (LastModifiedDate >=: dtStart and LastModifiedDate <=: dtEnd) Order By LastModifiedDate DESC ';
        }
        
        lstOpportunities  = Database.query(strsoql);
        
        if(lstOpportunities.size()>0){
            
            
            
            List<wrpOpportunity> lst = new List<wrpOpportunity>();
            for(Opportunity__c o : lstOpportunities){
              if(string.isNotBlank(o.Opportunity_Description_Clip__c)){               
                    URL='http://docs.google.com/uc?export=open&id=' + o.Opportunity_Description_Clip__c;
                    system.debug(URL);
               }                  
            wrpOpportunity w  = new wrpOpportunity();
            w.name = o.Name;
            w.profession =o.Profession__c;
            w.account =o.Account__c;
            w.account_name =o.Account__r.name;
            w.industry_name =o.Industry_name__c;
            w.type_of_opportunity =o.Type_of_opportunity__c;
            w.gender =o.Gender__c;
            w.course_start_date =string.valueof(o.Course_Start_date__c);
            w.admission_schedule =o.Admission_Schedule__c;
            w.recurrence_schedule =o.Recurrence_Schedule__c;
            w.detailed_course_description =o.Detailed_course_description__c;
            w.educational_level =o.Educational_Level__c;
            w.english_fluency =o.English_fluency__c;
            w.digital_literacy =o.Digital_Literacy__c;
            w.no_of_openings =string.valueof(o.No_of_Openings__c);
            w.no_of_remaining_opening = string.valueof(o.No_of_remaining_Openings__c);
            w.location =o.Location__c;
            w.training_Days =o.Training_Days__c;
            w.training_hours_start_time =string.valueof(o.Training_Hours_Start_Time__c);
            w.training_hours_end_time =string.valueof(o.Training_Hours_End_Time__c);
            w.duration =o.Duration__c;
            w.post_course_placement =o.Post_Course_Placement__c;
            w.fees_associated_costs= o.Fees_Associated_costs__c;
            w.required_documents =o.Required_Documents__c;
            w.admission_process = o.Admission_Process__c;
            w.is_opportunity_closed = o.Is_Opportunity_Closed__c;
            w.work_experience = o.Work_experience__c;
            w.additional_courses = o.Additional_courses__c;
            w.detailed_job_description = o.Detailed_Job_Description__c;
            w.work_days = o.Work_Days__c;
            w.address = o.Address__c;
            w.recruitment_process =o.Recruitment_Process__c;
            w.career_progression_for_the_role = o.Career_Progression_For_the_role__c;
            w.salary_in_hand_monthly = string.valueof(o.Salary_in_hand_monthly__c);
            w.payroll_details = o.Payroll_details__c;
            w.working_hours_start_time = string.valueof(o.Working_Hours_Start_Time__c);
            w.working_hours_end_time = string.valueof(o.Working_Hours_End_Time__c);
            w.recordTypeId= o.RecordTypeId;
            w.recordtype_name= o.Recordtype.name;
            w.opportunity_unique_Id = o.Opportunity_Unique_Id__c;
            w.Isdeleted = o.IsDeleted;
            w.opportunity_description_clip = URL;
            w.number_of_profile_matches = string.valueof(o.Number_of_profile_matches__c);
            w.no_of_peers_looking_at_the_opportunity = string.valueof(o.No_of_peers_looking_at_the_opportunity__c);
            w.created_date = string.valueOf(o.createddate);    
                //w.profession = o.Profession__c;
                //w.gender = o.Gender__c;
                //w.zone = o.Zone__c;
                
                lst.add(w);
            }
            
            res.statusCode = 200;
            //jsonResponse = '{"result": "Sucess","message":"Record(s) found.", "opportunities":' + stripJsonNulls(JSON.serialize(lst)) + '}';
            jsonResponse = '{"result": "Sucess","message":"Record(s) found.", "opportunities":' + JSON.serialize(lst) + '}';
            //if(jsonResponse.length()>131000){
            //    jsonResponse = jsonResponse.left(131000);
            //}
            
            //Log__c log = CatchLogs.createLog('Info','',lst.size(),0,'fromdate ='+fromdate +'/'+ 'todate ='+todate +'GETOpportunityRESTApi','Record(s) found', jsonResponse);
            //insert log;
        }else{
            res.statusCode = 200;
            jsonResponse = '{"result": "Error","message":"No any active Opportunities exist."}';
            if(jsonResponse.length()>131000){
                jsonResponse = jsonResponse.left(131000);
            }
            Log__c log = CatchLogs.createLog('Error','',0,0,'fromdate ='+fromdate +'/'+ 'todate ='+todate +'GETOpportunityRESTApi','No any active Opportunities exist', jsonResponse);
            insert log;
        }
        
        res.responseBody = blob.valueOf(jsonResponse);
        return;        
    }
    
    public static string stripJsonNulls(string JsonString)
    {
        if(JsonString != null)      
        {
            JsonString = JsonString.replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
            JsonString = JsonString.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
            JsonString = JsonString.replace('{,', '{'); //prevent opening brace from having a comma after it
            JsonString = JsonString.replace(',}', '}'); //prevent closing brace from having a comma before it
            JsonString = JsonString.replace('[,', '['); //prevent opening bracket from having a comma after it
            JsonString = JsonString.replace(',]', ']'); //prevent closing bracket from having a comma before it
        }
        
        return JsonString;
    }
    
    public class wrpOpportunity{
        public string name{get;set;}
        public string profession{get;set;}
        public string account{get;set;}
        public string account_name{get;set;}
        public string industry_name{get;set;}
        public string type_of_opportunity{get;set;}
        public string gender{get;set;}
        public string course_start_date{get;set;}
        public string admission_schedule{get;set;}
        public string recurrence_schedule{get;set;}
        public string detailed_course_description{get;set;}
        public string educational_level{get;set;}
        public string english_fluency {get;set;}
        public string digital_literacy{get;set;}
        public string no_of_openings{get;set;}
        public string no_of_remaining_opening{get;set;}
        public string location{get;set;}
        public string training_days{get;set;}
        public string training_hours_start_time{get;set;}
        public string training_hours_end_time{get;set;}
        public string duration{get;set;}
        public boolean post_course_placement{get;set;}
        public decimal fees_associated_costs{get;set;}
        public string required_documents {get;set;}
        public string admission_process{get;set;}
        public boolean is_opportunity_closed{get;set;}
        public string work_experience{get;set;}
        public string additional_courses{get;set;}
        public string detailed_job_description{get;set;}
        public string work_days{get;set;}
        public string address{get;set;}
        public string recruitment_process{get;set;}
        public string career_progression_for_the_role{get;set;}
        public string salary_in_hand_monthly{get;set;}
        public string payroll_details{get;set;}
        public string working_hours_start_time{get;set;}
        public string working_hours_end_time{get;set;}
        public string recordTypeId{get;set;}
        public string recordtype_name{get;set;}
        public string opportunity_unique_id{get;set;}
        public boolean isdeleted{get;set;}
        public string opportunity_description_clip{get;set;}
        public string number_of_profile_matches{get;set;}
        public string no_of_peers_looking_at_the_opportunity{get;set;}
        public string created_date{get;set;}
        
        /*wrpOpportunity(){
opportunityid = null;
website = '';
nameofthecompany = '';
opportunitytype='';
opportunityname='';
profession = '';
typeofopportunity = '';
gender = '';
educationlevel = '';
workexperience = '';
zone = '';
englishfluency='';
digitalliteracy='';
workdays='';
workingstarthourstime ='';
workingendhourstime =''; 
salaryinhand = 0.00;
payrolldetails = '';
recruitmentprocess = '';
careerprogressionfortherole = '';
}*/    
    }
    
}