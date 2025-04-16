public class StudentSyncTempBatchHelper{

    //this method copies values from json model to Contact object
    //batch code map contains key as batch name and value as batch record
    //months map has 3 digit month name as key, and month number as value
    public static Contact mapStudeData(StudentJSONParser model, Contact existingCon, Batch__c batchCode,
                                        Id recordTypeId, Map<String, Integer> monthsMap, Account objAccount, Contact objTrainer, String api){
        Contact con = new Contact(
            UID__c = model.uid
        );
        
        if(model.plan_a != null && !string.isblank(model.plan_a)){
            con.Plan_A__c = model.plan_a;
        }
        if(model.plan_b != null &&  !string.isblank(model.plan_b)){
            con.Plan_B__c = model.plan_b;
        }

        //if record is already in the system, then do not need to update all fields
        // if(existingCon != null)
        //     return con;

        if(api=='1') 
            con.API_Status__c ='1st API Executed';   
        else
            con.API_Status__c ='Both APIs Executed';   

        con.Status__c= 'Processed';
        con.RecordTypeId = recordTypeId;

        if(objAccount!= null)
        con.Batch_Name__c = objAccount.Id;
       // con.Batch_Type__c = model.batch_type;
       // con.Batch_Name__c = model.community_college_name;
        con.Firstname = model.student_firstname;
        con.LastName = model.student_lastname;
        
        if(model.gender!=null)
        {    
            if(model.gender=='M')
               con.Gender__c = 'Male only';
            else
               if(model.gender=='F')
                   con.Gender__c = 'Female only';
            else
                con.Gender__c = model.gender;
        }
        
        con.Expected_starting_salary_after_Antarang__c  = model.expected_salary_after_antarang_career_connect;

        //if batch code has a valid record in system then poplating the record id
       // con.Batch_Code__c = batchCode != null ? batchCode.Id : null;
        
        //con.Name_of_Trainer__c = model.trainer_name;

        if(objTrainer!= null)
        con.Name_of_Trainer__c = objTrainer.Id;
        
        //if(String.isNotBlank(model.trainer_status)){
           // con.Trainer_Status__c = model.trainer_status;
       // }
        
        if(model.student_contact_1 != null && !string.isblank(model.student_contact_1)){
            con.Phone = model.student_contact_1;
        }
        if(model.student_contact_2 != null && !string.isblank(model.student_contact_2)){
            con.MobilePhone = model.student_contact_2;
        }
        if(model.student_contact_3 != null && !string.isblank(model.student_contact_3)){
            con.OtherPhone = model.student_contact_3;
        }
        //con.Phone = model.student_contact_1; //Verified
        //con.MobilePhone = model.student_contact_2; //Verified
        //con.OtherPhone = model.student_contact_3; //Verified

        // converting date from //13-Mar-2002 into salesforce date instance
        if(String.isNotBlank(model.dob) && model.dob.split('-').size()==3){
            List<String> dtList = model.dob.split('-');
        
            con.Birthdate = date.newinstance(
                                Integer.valueOf(dtList[2]), 
                                monthsMap.get(dtList[1].toLowerCase()), 
                                Integer.valueOf(dtList[0])
                            );//conversion //13-Mar-2002
        }else
            con.Birthdate = null;

        con.Interest_1__c = model.interest_mapping_code_1;
        con.Interest_2__c = model.interest_mapping_code_2;
        con.Interest_3__c = model.interest_mapping_code_3;
        con.Caste_Certificate_present__c = model.caste_certificate_present;
        con.Marital_status__c = model.marital_status;
        con.Mother_s_Position__c = model.mother_position;
        con.Father_s_Position__c = model.father_position;
        con.household_income__c = model.monthly_family_income;
        con.No_of_siblings__c = model.no_of_siblings;
        //con.Education_Status__c = model.education_status;
        if(model.education_status != null && !string.isblank(model.education_status)){
            con.Education_Status_baseline__c = model.education_status;
        }
        //con.Education_Status_baseline__c = model.education_status;
        if(model.education_level != null && !string.isblank(model.education_level)){
            con.Education_Level__c = model.education_level;
        }
        if(model.digital_literacy!= null && !string.isblank(model.digital_literacy)){
            con.Digital_Literacy__c = model.digital_literacy;
        }
        if(model.spoken_english_fluency!= null && !string.isblank(model.spoken_english_fluency)){
            con.English_Fluency__c = model.spoken_english_fluency;
        }
        //con.Education_Level__c = model.education_level;
        //con.Digital_Literacy__c = model.digital_literacy;
        //con.English_Fluency__c = model.spoken_english_fluency;
      
        con.Aptitude_1__c = model.aptitude_highest; //Verified
        con.Aptitude_2__c = model.aptitude_second_highest; //Verified
        con.Personality_1__c = model.personality_1;
        con.Personality_2__c = model.personality_2;
        con.Personality_3__c = model.personality_3;
        con.Personality_4__c = model.personality_4;
        con.Reality_1__c = model.reality_1_self;
        con.Reality_2__c = model.reality_2_self;
        con.Reality_3__c = model.reality_3_self;
        con.Reality_4__c = model.reality_4_self;
        con.Reality_5__c = model.reality_5_family;
        con.Reality_6__c = model.reality_6_family;
        con.Reality_7__c = model.reality_7_family;
        con.Reality_8__c = model.reality_8_family;
        if(model.current_education != null && !string.isblank(model.current_education)){
            con.Current_Education_baseline__c = model.current_education;
        }
        //con.Current_Education_baseline__c = model.current_education;
        con.MailingStreet = model.student_address; //Verified
        if(model.location_name != null && !string.isblank(model.location_name)){
            con.Location__c = model.location_name;
        }
        //con.Location__c = model.location_name;
        con.MailingPostalCode = model.student_pincode;

        //converting income from string to decimal for currency conversion
       // con.household_income__c = String.isNotBlank(model.household_income) ? Decimal.ValueOf(model.household_income) : null;
        
        con.Mother_Education__c = model.mother_education; //Verify datatype with client
        con.Father_Education__c = model.father_education; //Verify datatype with client
        con.Mother_Occupation__c = model.mother_sector_of_employment; //Verify with client
        con.Father_Occupation__c = model.father_sector_of_employment; //Verify with client
        con.Sibling1_Sector_of_Employment__c = model.sibling1_sector_of_employment; //Verify datatype with client
        con.Sibling1_Education__c = model.sibling1_education; //Verify datatype with client

        con.Email = model.student_email;
        if(model.completed_on_going_courses != null && !string.isblank(model.completed_on_going_courses)){
            con.Additional_courses__c = model.completed_on_going_courses;
        }
        //con.Additional_courses__c = model.completed_on_going_courses;
        
        if(model.working_not_through_af!= null && !string.isblank(model.working_not_through_af)){
            con.Currently_working_not_through_AF_Bline__c = model.working_not_through_af;
        }
        if(model.sector_of_employment_not_through_af != null && !string.isblank(model.sector_of_employment_not_through_af)){
            con.Sector_of_employment_not_through_AF__c  = model.sector_of_employment_not_through_af;
        }
        //con.Currently_working_not_through_AF_Bline__c = model.working_not_through_af;
        //con.Sector_of_employment_not_through_AF__c  = model.sector_of_employment_not_through_af;
        if(model.current_salary_not_through_af != null && !string.isBlank(model.current_salary_not_through_af)) {
            con.Current_Salary_not_through_AF_baseline__c = model.current_salary_not_through_af;
        }
        
        con.Donor__c = model.donor_name;
        con.Student_Status__c = model.student_Status;
        
        return con;
    }

    //this method returns months map has 3 digit month name as key, and month number as value
    public static Map<String,Integer> getMonthsMap(){
        return new Map<String,Integer>{
            'jan'=>1,
            'feb'=>2,
            'mar'=>3,
            'apr'=>4,
            'may'=>5,
            'jun'=>6,
            'jul'=>7,
            'aug'=>8,
            'sep'=>9,
            'oct'=>10,
            'nov'=>11,
            'dec'=>12
        };
    }

    //this method create logs
    public static Log__c createLog(String type, String uid, 
                                    Integer totalRecords, Integer totalSuccess, 
                                    String summary, String message, String logBody)
    {
        //Checking the field length and truncating value if its larger than field's length
        if(String.isNotBlank(summary)){
            Schema.DescribeFieldResult F = Log__c.Summary__c.getDescribe();
            summary = summary.length()>F.getLength() ? summary.substring(0,F.getLength()) : summary;
        }

        if(String.isNotBlank(message)){
            Schema.DescribeFieldResult F = Log__c.Message__c.getDescribe();
            message = message.length()>F.getLength() ? message.substring(0,F.getLength()) : message;
        }

        if(String.isNotBlank(logBody)){
            Schema.DescribeFieldResult F = Log__c.Body__c.getDescribe();
            logBody = logBody.length()>F.getLength() ? logBody.substring(0,F.getLength()) : logBody;
        }

        return new Log__c(
            Type__c = type,
            UID__C = uid,
            Total_Records__c =totalRecords,
            Total_Success__c =totalSuccess,
            Summary__c = summary,
            Message__c = message,
            Body__c = logBody
        );
    }

    //this method makes calls getStudents methods for given date range <<<<<< This is the first API that we need to invoke>>>>>>
    //then parse the response with StudentJSONParser class
    //Using batch_code value to match Batch records with name and populate the lookup if a mathcing record founds
    //Using UID as external id to create/update contact records 
    public static void syncStudentsFromAntarang(Date fromDate, Date toDate, String api){
        if(Test.isRunningTest()){
            if(fromDate == null){
                fromDate = System.Date.today().addDays(-100);
            }
            if(toDate == null){
                toDate = System.Date.today();
            }
        }
        
        List<Log__c> logs = new List<Log__c>();

        //getting students from Antarang
        HTTPModel httpModel = getStudents(fromDate, toDate, api);
        
        //creating log for the sync
        Log__c log = createLog(
                            httpModel.isError ? 'Error' : 'Info', 
                            null,
                            null,
                            null,
                            fromDate.format()+'-'+toDate.format()+' Antarang Student Sync', 
                            httpModel.isError ? 'Callout Error' : 'Callout Response',
                            httpModel.responseStr
                    );
        logs.add(log);

        if(!httpModel.isError){
            try{
                //parsing json response with StudentJSONParser class
                List<StudentJSONParser> studentModelList = 
                    (List<StudentJSONParser>) System.JSON.deserialize(httpModel.responseStr, List<StudentJSONParser>.class);
                
                if(studentModelList == null){
                    log.Message__c = 'No data received';
                }

                //if parser has only one record in list, and response variable is not blank
                //this indicates, the response has an error message, so handling accordingly
                else if(
                    studentModelList.size()==1 && 
                    String.isNotBlank(studentModelList[0].responce) && 
                    String.isBlank(studentModelList[0].uid)
                ){
                    log.Type__c = 'Error';
                    log.Message__c = studentModelList[0].responce;

                    httpModel.isError = true;
                    //httpModel.responseStr = studentModelList[0].responce;

                    system.debug('@@@@ response error =='+httpModel);
                }else{
                    List<List<StudentJSONParser>> wrapList = new List<List<StudentJSONParser>>();
                    List<StudentJSONParser> lstTemp;
                    Integer BatchSize = Integer.valueOf(Label.Batch_size_for_Student_Sync);
                    for(Integer i = 0 ; i < (studentModelList .size() / BatchSize)+1 ; i++){
                        lstTemp = new List<StudentJSONParser>();
                        for(Integer j=(i*BatchSize);(j<(i*BatchSize)+BatchSize) && j<studentModelList .size() ; j++){
                            lstTemp.add(studentModelList.get(j));
                        }
                        wrapList.add(lstTemp);
                        //syncStudentsFromAntarangAsync(lstTemp, fromDate, toDate, api);
                    }
                    if(wrapList.size() > 0){
                        for(List<StudentJSONParser> wrap : wrapList){
                            //syncStudentsFromAntarangAsync(wrap , fromDate, toDate, api);
                            ID jobID = System.enqueueJob(new SyncAPICallout(wrap,fromDate,toDate,api));
                        }
                    }    
                    
                }
            }catch(Exception e){
                logs.add(createLog(
                            'Error', 
                            null,
                            null,
                            null,
                            'Run time exception', 
                            e.getMessage()+' at line '+e.getLineNumber(),
                            httpModel.responseStr
                    ));
            }
        }

        logs[0] = log;
        insert logs;

        system.debug('@@@@ logs =='+logs);
    }
    
    
    
    //this method makes callout to get student for a date range from antrang
    //this uses "Antarang" named credential for callout
    public static HTTPModel getStudents(Date fromDate, Date toDate, String api){        

        String bodyStr ='{'+
                            '"from_date": "'+fromDate.year()+'-'+fromDate.month()+'-'+fromDate.day()+'",'+
                            '"to_date": "'+toDate.year()+'-'+toDate.month()+'-'+toDate.day()+'",'+
                            '"api_user_name": "{!HTMLENCODE($Credential.Username)}",'+
                            '"api_key": "{!HTMLENCODE($Credential.Password)}"'+
                        '}';

        Map<String,String> headersMap = new Map<String,String>{
            'Content-Type'=> 'application/json'
        };

        String endpoint = '';

        if(api == '1')
        endpoint = 'callout:Antarang/antarang-api/api/student/getgraduatedstudents';
        else
        if(api =='2')
        endpoint ='callout:Antarang/antarang-api/api/student/getallstudents';

        
        return doHTTPCallout(
                    endpoint,
                    'POST',
                    headersMap,
                    bodyStr
                );
    }
    
    //this method received callout parameter values and invoke the callout
    //has debugs for received params as well as for response body
    //this returns HTTPModel which has respone string and error flag
    public static HTTPModel doHTTPCallout(String endpoint, String httpMethod, Map<String,String> headerMap, String bodyStr){
        HTTPModel httpModel = new HTTPModel();
        system.debug('@@@@@@@callout request body');
        system.debug('endpoint =='+endpoint);
        system.debug('httpMethod =='+httpMethod);
        system.debug('headerMap =='+headerMap);

        try{
            HttpRequest req = new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(endpoint);            
            req.setMethod(httpMethod);
            if(String.isNotBlank(bodyStr))
                req.setBody(bodyStr);
            if(headerMap != null){
                for(String key:headerMap.keySet())
                    req.setHeader(key,headerMap.get(key));
            }

            Http http = new Http();
            HTTPResponse res = http.send(req);

            system.debug('@@@ HttpRequest =='+req);
            system.debug('@@@ HttpRequest =='+req.getBody());

            httpModel.responseStr = res.getBody();
        }catch(Exception e){
            httpModel.isError = true;
            httpModel.responseStr = e.getMessage();
        }
        system.debug('@@@ response body =='+httpModel.responseStr);
        
        return httpModel;
    }



    public class ResponseModel{
        public Boolean isError;
        public Boolean isCalloutException;
        public String errmsg;
        //public AutodeskJSONParser.AccessTokenParser tokenParser;
        //public AutodeskJSONParser.AutodeskDataParser dataParser;
        
        public ResponseModel(){
            isError = false;
            isCalloutException = false;
        }
    }

    public class HTTPModel{
        public Boolean isError;
        public String responseStr;

        public HTTPModel(){
            isError = false;
        }
    }
}