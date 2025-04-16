public class SyncAPICallout implements Queueable,Database.AllowsCallouts{
 public List<StudentJSONParser> wraplist;
 public date frmdate;
 public date todate;
 string api;
    public SyncAPICallout (List<StudentJSONParser> studentJsonList, Date fromDate, Date toDate, String api){
       
       this.frmdate = fromDate;
       this.todate = toDate;
       this.wraplist = studentJsonList;
       this.api = api;
    }
 public void execute(QueueableContext qc){ 
 StudentSyncTempBatchHelper.HTTPModel httpModel = StudentSyncTempBatchHelper.getStudents(frmdate , toDate, api);
        List<Log__c> logs = new List<Log__c>();
        //creating log for the sync
        Log__c log = StudentSyncTempBatchHelper.createLog(
                            httpModel.isError ? 'Error' : 'Info', 
                            null,
                            null,
                            null,
                            frmdate.format()+'-'+toDate.format()+' Antarang Student Sync', 
                            httpModel.isError ? 'Callout Error' : 'Callout Response',
                            httpModel.responseStr
                    );
                    
        //total records in response to be processed
        log.Total_Records__c = wraplist .size();
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
        for(StudentJSONParser model: wraplist){
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
        Map<String,Integer> monthsMap = StudentSyncTempBatchHelper.getMonthsMap();

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
       
        for(StudentJSONParser model: wraplist ){
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
                logs.add(StudentSyncTempBatchHelper.createLog(
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
                                StudentSyncTempBatchHelper.mapStudeData(
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
                                StudentSyncTempBatchHelper.mapStudeData(
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
                    logs.add(StudentSyncTempBatchHelper.createLog(
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
 
 
 }