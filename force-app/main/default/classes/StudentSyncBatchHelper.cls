public class StudentSyncBatchHelper{

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
                    //total records in response to be processed
                    log.Total_Records__c = studentModelList.size();
                    log.Total_Success__c = 0;

                    Map<String, Batch__c> batchCodeMap = new Map<String, Batch__c>();
                    Set<String> batchCodes = new Set<String>();
                    
                    Map<String, Contact> conUIDMap = new Map<String, Contact>();
                    Set<String> uids = new Set<String>();
                    
                    Map<String, Contact> TrainerMap = new Map<String, Contact>();
                    Map<String, Contact> TrainerMapJunction = new Map<String, Contact>();
                    Set<String> trainerNames = new Set<String>();
                    Map<String,String> maptrainerNameVsStatus = new Map<String,String>();
                    List<Contact> lstTrainerUpdate = new list<Contact>();
                    Map<String,StudentJSONParser> mapContactTrainer = new Map<String,StudentJSONParser>();

                    Map<String, Account> accountIdMap = new Map<String, Account>();
                    Set<String> accountNames = new Set<String>();
                    Map<String,StudentJSONParser> mapAccountStudent = new Map<String,StudentJSONParser>();
                    Map<String,Set<string>> mapAccountStudentJunction = new Map<String,Set<string>>();

                    //collecting batch codes
                    for(StudentJSONParser model:studentModelList){
                        if(String.isNotBlank(model.batch_code))
                            batchCodes.add(model.batch_code);
                        if(String.isNotBlank(model.uid))
                            uids.add(model.uid);
                        if(String.isNotBlank(model.community_college_name))
                            accountNames.add(model.community_college_name);
                        if(String.isNotBlank(model.trainer_name)){
                            integer intTname = 0;
                            for(string str : model.trainer_name.split(',')){
                                trainerNames.add(str);
                                 integer intTStatus = 0;
                                for(string strStatus : model.trainer_status.split(';')){
                                 if(!maptrainerNameVsStatus.containskey(str) && intTStatus == intTname){
                                     maptrainerNameVsStatus.put(str,strStatus);
                                 }
                                 intTStatus++;
                                }
                                intTname++;
                                
                                mapContactTrainer.put(str, model);

                                // added this map to check trainer in junction object
                                if(mapAccountStudentJunction.containskey(model.batch_code)){
                                    mapAccountStudentJunction.get(model.batch_code).add(str);
                                }else{
                                    mapAccountStudentJunction.put(model.batch_code,new Set<string> {str});
                                }

                            }  
                                                  
                        }
                        mapAccountStudent.put(model.batch_code, model);
                    }

                    //fethcing Account records where name and code matching **** Batch Name Lookup of Account
                    String strAccountNameWithBatchCode = '';
                    Id CRBatchAccountRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CR Batch').getRecordTypeId();
                    List<Account> lstAccountDateChange = new List<Account>();
                    Map<String,Integer> monthsMap = getMonthsMap();

                    for(Account acc: [select id, Name, Batch_Code__c,Batch_Start_Date__c,Batch_End_Date__c from Account where (Name in:accountNames Or Batch_Code__c in: batchCodes) and recordTypeId =: CRBatchAccountRT ]){
                        strAccountNameWithBatchCode = acc.Batch_Code__c;                        
                        accountIdMap.put(strAccountNameWithBatchCode, acc);
                        if(mapAccountStudent.containsKey(strAccountNameWithBatchCode)){
                            Boolean isblnchange = false;
                            StudentJSONParser model = mapAccountStudent.get(strAccountNameWithBatchCode);
                            if(!String.isBlank(model.batch_start_date)){
                                List<String> dtList = model.batch_start_date.split('-');        
                                Date dt = date.newinstance(
                                                                Integer.valueOf(dtList[2]), 
                                                                monthsMap.get(dtList[1].toLowerCase()), 
                                                                Integer.valueOf(dtList[0])
                                                            );//conversion //13-Mar-2002
                                if(acc.Batch_Start_Date__c != dt){
                                    acc.Batch_Start_Date__c = dt;
                                    isblnchange = true;
                                }
                            }

                            if(!String.isBlank(model.batch_end_date)){
                                List<String> dtList = model.batch_end_date.split('-');        
                                Date dt = date.newinstance(
                                                                Integer.valueOf(dtList[2]), 
                                                                monthsMap.get(dtList[1].toLowerCase()), 
                                                                Integer.valueOf(dtList[0])
                                                            );//conversion //13-Mar-2002
                                if(acc.Batch_End_Date__c != dt){
                                    acc.Batch_End_Date__c = dt;
                                    isblnchange = true;
                                }
                            }

                            if(isblnchange){
                                lstAccountDateChange.add(acc);
                            }

                            mapAccountStudent.remove(strAccountNameWithBatchCode);
                        }
                    }

                    if(lstAccountDateChange.size()>0){
                        Update lstAccountDateChange;
                    }

                    if(mapAccountStudent.size()>0){
                        List<Account> lstAccount = new List<Account>();
                        
                        for (StudentJSONParser model : mapAccountStudent.values()) {
                            if(String.isBlank(model.uid)){
                                continue;
                            }

                           Account objacc = new Account(recordTypeId = CRBatchAccountRT);
                           objacc.Name = model.batch_code;

                           if(String.isNotBlank(model.community_college_name)){
                               objacc.Batch_Name__c = model.community_college_name;
                           }

                           if(!String.isBlank(model.batch_start_date)){
                                List<String> dtList = model.batch_start_date.split('-');        
                                objacc.Batch_Start_Date__c = date.newinstance(
                                                                Integer.valueOf(dtList[2]), 
                                                                monthsMap.get(dtList[1].toLowerCase()), 
                                                                Integer.valueOf(dtList[0])
                                                            );//conversion //13-Mar-2002
                           }

                           if(!String.isBlank(model.batch_end_date)){
                                List<String> dtList = model.batch_end_date.split('-');        
                                objacc.Batch_End_Date__c = date.newinstance(
                                                                Integer.valueOf(dtList[2]), 
                                                                monthsMap.get(dtList[1].toLowerCase()), 
                                                                Integer.valueOf(dtList[0])
                                                            );//conversion //13-Mar-2002
                           }
                           objacc.Batch_Code__c = model.batch_code;  
                           objacc.Batch_Type__c = model.batch_type;  
                           objacc.Donor__c = model.donor_name;                                                  
                           lstAccount.add(objacc);
                        }

                        if(lstAccount.size()>0) insert lstAccount;  

                        for(Account acc : lstAccount){
                            accountIdMap.put(acc.Batch_Code__c, acc);
                        }
                    }
                    // End for Batch Name Lookup of Account

                    //Trainer Contact Lookup Start 
                    Id CRTrainerContactRT = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Trainer').getRecordTypeId();
                    for(Contact con: [select id,Trainer_Status__c,LastName from Contact where (LastName in:trainerNames ) and recordTypeId =: CRTrainerContactRT ]){ //Or Batch_Code__c in: batchCodes
                        TrainerMap.put(con.LastName, con);
                        if(mapContactTrainer.containsKey(con.LastName)){
                            mapContactTrainer.remove(con.LastName);
                            if(maptrainerNameVsStatus.Containskey(con.LastName)){
                                lstTrainerUpdate.add(new contact(id= con.id,Trainer_Status__c=maptrainerNameVsStatus.get(con.LastName)));
                            }
                        }
                    }
                    if(lstTrainerUpdate.size() > 0) update lstTrainerUpdate;
                    
                    if(TrainerMap.size()>0){
                        TrainerMapJunction = TrainerMap.deepclone();
                    }

                    if(mapContactTrainer.size()>0){
                        List<Contact> lstContact = new List<Contact>();
                        Map<Integer,Id> mapAccountIds = new Map<Integer,Id>();
                        
                        List<Batch_Trainer_Junction__c> lstTJ = new List<Batch_Trainer_Junction__c>();
                        Integer intAccountIds = 0;
                        for (string strconname : mapContactTrainer.keySet()) {
                            StudentJSONParser model = mapContactTrainer.get(strconname);
                            if(String.isBlank(model.uid)){
                                continue;
                            }

                            Contact objcon = new Contact(recordTypeId = CRTrainerContactRT);
                            objcon.LastName = strconname;
                            if(accountIdMap.containsKey(model.batch_code)){ // need to confirm account id
                                //objcon.AccountId = accountIdMap.get(model.community_college_name+model.batch_code).Id;
                                mapAccountIds.put(intAccountIds, accountIdMap.get(model.batch_code).Id);
                            }
                             if(maptrainerNameVsStatus.Containskey(objcon.LastName)){
                                 objcon.Trainer_Status__c=maptrainerNameVsStatus.get(objcon.LastName);
                                 
                             }
                            lstContact.add(objcon);

                            intAccountIds++;
                        }

                        if(lstContact.size()>0) insert lstContact;  // need to confirm

                        intAccountIds = 0;
                        for(Contact con : lstContact){
                            TrainerMap.put(con.LastName, con);

                            Batch_Trainer_Junction__c objbtj = new Batch_Trainer_Junction__c();
                            if(mapAccountIds.containsKey(intAccountIds)){
                                objbtj.Batch__c = mapAccountIds.get(intAccountIds);
                                objbtj.Trainer__c = con.Id;
                                lstTJ.add(objbtj);
                            }
                            intAccountIds++;                             
                        }

                        if(lstTJ.size()>0){
                            insert lstTJ;
                        }
                    }
                    //Trainer Contact Lookup End 

                    //If trainer exist but junction record against batch is not exist
                    
                    Set<string> setBatchvsTrainer = new Set<string>();
                    for(Batch_Trainer_Junction__c btj : [select id,Batch__c,batch__r.Batch_Code__c,Trainer__c,Trainer__r.LastName from Batch_Trainer_Junction__c where batch__r.Batch_Code__c in: accountIdMap.keyset()]){
                        if(mapAccountStudentJunction.containsKey(btj.batch__r.Batch_Code__c)){
                            if(mapAccountStudentJunction.get(btj.batch__r.Batch_Code__c).contains(btj.Trainer__r.LastName)){
                                mapAccountStudentJunction.get(btj.batch__r.Batch_Code__c).remove(btj.Trainer__r.LastName);
                            }
                        }
                    }
                    
                    system.debug('str@@@@@@@ INNNNNNNNNNNNNNNNNN '  );
                    if(mapAccountStudentJunction.size()>0){
                        List<Batch_Trainer_Junction__c> lstTJNotExist = new List<Batch_Trainer_Junction__c>();
                        for(string str : mapAccountStudentJunction.keyset()){
                            for(string t : mapAccountStudentJunction.get(str)){
                                system.debug('str@@@@@@@ ' + str + ' trainer ' + t );
                                system.debug('str@@@@@@@ ' + TrainerMap.containskey(t) + ' trainer ' + accountIdMap.ContainsKey(str) );

                                if(TrainerMap.containskey(t) && accountIdMap.ContainsKey(str)){
                                    Batch_Trainer_Junction__c objbtj = new Batch_Trainer_Junction__c();
                                    objbtj.Batch__c = accountIdMap.get(str).Id;
                                    objbtj.Trainer__c = TrainerMap.get(t).Id;
                                    lstTJNotExist.add(objbtj);
                                }
                            }
                        }

                        if(lstTJNotExist.size()>0) insert lstTJNotExist;
                    }

                    //end of trainer exist but junction record against batch is not exist

                    //fethcing Batch records where name matching the BatchName
                   // for(Batch__c batch: [select id, Name from Account where recordTypeId =: CRBatchAccountRT and name in:batchCodes]){
                     //   batchCodeMap.put(batch.Name, batch);
                  //  }

                    //fethcing Batch records where name matching the BatchName
                    Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CR Student').getRecordTypeId(); 
                    Set<string> setBothAPIsContacts = new Set<string>();
                    for(Contact con: [select id, UID__c, API_Status__c from Contact where UID__c in:uids and recordtypeid=:recordTypeId   ]){
                        conUIDMap.put(con.UID__c, con);
                        if(con.API_Status__c == 'Both APIs Executed'){
                            setBothAPIsContacts.add(con.UID__c);
                        }
                    }

                    //Map<String,Contact> conMap = new Map<String,Contact>();
                    List<Contact> conList = new List<Contact>();
                    //Map<String,Integer> monthsMap = getMonthsMap();
                    

                    //syncing the Contact records i.e copying json model record values to a Contact Object
                    //filling the Contact object into map, where key is UID received in json body
                   
                    for(StudentJSONParser model: studentModelList){
                        String errMsg = '';
                        if(String.isBlank(model.uid)){
                            errMsg = 'UID is missing';
                        }
                        /*if(String.isNotBlank(model.batch_code) && batchCodeMap.containsKey(model.batch_code)){
                            if(errMsg != '')
                                errMsg += ',';
                            errMsg += 'Invalid batch code';
                        }*/
                        if(errMsg != ''){
                            //creating log for the error record
                            logs.add(createLog(
                                        'Error', 
                                        model.uid,
                                        1,
                                        0,
                                        'Invalid Data', 
                                        errMsg,
                                        httpModel.responseStr
                                ));
                        }else{
                            
                            //check if api_status = Both APIs Executed then not doing anything on contact records
                            if(setBothAPIsContacts.contains(model.uid)){
                                continue;
                            }

                            if(api=='1')
                            {
                                string[] strarr = model.trainer_name.split(',');
                                for(Integer int1=0; int1 < strarr.size(); int1++){
                                    
                                    if(int1 == strarr.size() -1){
                                        conList.add( 
                                            StudentSyncBatchHelper.mapStudeData(
                                                model, 
                                                conUIDMap.get(model.uid), 
                                                batchCodeMap.get(model.batch_code), 
                                                recordTypeId, 
                                                monthsMap,
                                                accountIdMap.get(model.batch_code),
                                                TrainerMap.get(strarr[int1]), '1'
                                            )
                                        );
                                    }                                    
                                 }

                                
                             }
                             else
                             {
                                 string[] strarr = model.trainer_name.split(',');
                                 for(Integer int1=0; int1 < strarr.size(); int1++){
                                    
                                    if(int1 == strarr.size() -1){
                                        conList.add( 
                                            StudentSyncBatchHelper.mapStudeData(
                                                model, 
                                                null, 
                                                batchCodeMap.get(model.batch_code), 
                                                recordTypeId, 
                                                monthsMap,
                                                accountIdMap.get(model.batch_code),
                                                TrainerMap.get(strarr[int1]),'2'
                                            )
                                        );
                                    }
                                    
                                 }

                             }
                        }
                    }

                    system.debug('@@@@ total contacts =='+conList.size());

                    if(conList.size()>0){
                        //upserting records with UID External ID, 
                        //so it will update existing record where the external id exists
                        //else create new record in system
                        Database.UpsertResult[] results = Database.upsert(conList, Contact.UID__c, false);

                        //handling errors on failed records
                        for(Integer index = 0; index < results.size(); index++) {
                            if(results[index].isSuccess()) {
                                //counting total succeed records in response
                                log.Total_Success__c++;
                                if(results[index].isCreated()) {
                                    //System.debug(results[index].get('UID__c') +' was created');
                                } else {
                                    //System.debug(results[index].get('UID__c') +' was updated');
                                }
                            }else{
                                //adding log for failed records
                                String errMsg = '';
                                for(Database.Error err:results[index].getErrors()){
                                    if(errMsg != '')
                                        errMsg += ',';
                                    errMsg += err.getStatusCode()+', '+err.getMessage()+', '+err.getFields();
                                }

                                system.debug('@@@@ faliure =='+errMsg+'=='+conList[index]);

                                //creating log for the error record
                                logs.add(createLog(
                                        'Error', 
                                        conList[index].UID__c,
                                        1,
                                        0,
                                        'DML Exception', 
                                        errMsg,
                                        JSON.serialize(conList[index])
                                ));
                                //System.debug(results[index].get('UID__c') +' has error=='+errors);
                            }
                        }
                    }

                    system.debug('@@@@ response success result =='+conList);
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