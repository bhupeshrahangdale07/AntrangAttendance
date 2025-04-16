global class historicUpdateOMRUploadDate implements Database.Batchable<SObject>{

    global String objectAPIName;
    global string objectName;
    global String query; 
    
    global historicUpdateOMRUploadDate(String objectName, string objectAPIName) {
        this.objectName = objectName;
        this.objectAPIName = objectAPIName;
    }
    
     global Database.QueryLocator start(Database.BatchableContext bc) {
        if(String.isBlank(query)) {
            query = 'SELECT Id, Batch_Id__c, Error_Status__c, Student__c, CreatedDate,Academic_Year__c,RecordTypeId '
                +'FROM ' + objectAPIName
                +' WHERE Error_Status__c = \'No Error\' AND Student__c != null AND Academic_Year__c = 2023';
        }
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Sobject> scope) {
        system.debug('scope >>' +scope.size());
        set<Id> BatchSet = new set<Id>();
        list<string> omrSessionTypeIds = new list<string>();
        for(SObject obj: scope){
            string BatchId = (String) obj.get('Batch_Id__c');
            if(string.isNotBlank(BatchId) || !string.isEmpty(BatchId)){
                BatchSet.add((String) obj.get('Batch_Id__c'));
            }
        }
        
        if(BatchSet.size() > 0){
            
             String querySessionOMRType = 'SELECT Id, OMR_Assessment_Record_Type__c, Session_Batch_Id__c ' +
            'FROM Session_OMR_Type__c ' +
            'WHERE OMR_Assessment_Object__c = :objectName ' +
            'AND Session_Batch_Id__c =: BatchSet';
        
        	List<Session_OMR_Type__c> queriedSessionOMRObjects = Database.query(querySessionOMRType);
            
            if(queriedSessionOMRObjects.size() > 0){
                if(objectAPIName != 'Self_Awareness_and_Feedback__c' && objectAPIName != 'Self_Awareness_Realities__c'){
                     updateOMRUploadDate1(queriedSessionOMRObjects, objectAPIName);
                }else{
                     updateOMRUploadDate2(queriedSessionOMRObjects, objectAPIName);
                }
            }
           
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        // Perform any post-processing tasks
    }
    
    global static void updateOMRUploadDate1(list<Session_OMR_Type__c> listSessionOMRType, string objectAPIName){
        system.debug('listSessionOMRType >>' +listSessionOMRType.size());
        list<Session_OMR_Type__c> lstOMRsessionType = new list<Session_OMR_Type__c>();
        
        map<string,string> BaselineBatchMap = new map<string,string>();
        map<string, DateTime> OMRBaselineMap = new map<string,DateTime>();
        
        map<string,string> EndlineBatchMap = new map<string,string>();
        map<string,DateTime> OMREndlineMap = new map<string,DateTime>(); 
        
        Map<String, Schema.RecordTypeInfo> recordTypeMap = Schema.getGlobalDescribe().get(objectAPIName).getDescribe().getRecordTypeInfosByName();
        Id baselineRTID = recordTypeMap.get('Baseline') != null ? recordTypeMap.get('Baseline').getRecordTypeId() : null;
        Id endlineRTID = recordTypeMap.get('Endline') != null ? recordTypeMap.get('Endline').getRecordTypeId() : null;
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        decimal AcademicYear = antarangSett.Academic_Year__c;
        
        for(Session_OMR_Type__c sot : listSessionOMRType ){
            
            if(sot.OMR_Assessment_Record_Type__c == 'Baseline'){
                system.debug('Baseline');
                BaselineBatchMap.put(sot.Session_Batch_Id__c, sot.Id);
            }else if(sot.OMR_Assessment_Record_Type__c == 'Endline'){
                system.debug('Endline');
                EndlineBatchMap.put(sot.Session_Batch_Id__c, sot.Id);
            }
            
            
        }
        
        if(BaselineBatchMap != null && !BaselineBatchMap.isEmpty()){
            system.debug('Baseline');
            set<string> batchIdKeySet = new set<string>();
            for(string btId : BaselineBatchMap.keyset()){
                batchIdKeySet.add(btId);
            }
            string querySobject = 'SELECT Batch_Id__c,createdDate '
                + 'FROM ' +objectAPIName 
                + ' WHERE RecordTypeId =: baselineRTID AND Batch_Id__c =: batchIdKeySet AND '
                + 'Student__c != null AND Academic_Year__c =: AcademicYear AND '
                + 'Error_Status__c = \'No Error\' ORDER BY createdDate ASC';
            
            List<Sobject> queriedSobjectList = Database.query(querySobject);
            system.debug('queriedSobjectList >>' +queriedSobjectList.size());
            
            for(Sobject obj : queriedSobjectList){
                string BatchId = (String)obj.get('Batch_Id__c');
                DateTime CreatedDate = (DateTime)obj.get('CreatedDate');
                if(!OMRBaselineMap.containsKey(BatchId)){
                    OMRBaselineMap.put(BatchId, CreatedDate);
                }
            }
            
            for(string st : BaselineBatchMap.Keyset()){
                Session_OMR_Type__c sot = new Session_OMR_Type__c();
                if(OMRBaselineMap.ContainsKey(st)){
                    sot.Id = BaselineBatchMap.get(st);
                    sot.First_OMR_Uploaded_Date__c = date.ValueOf(OMRBaselineMap.get(st));
                    lstOMRsessionType.add(sot);
                }
            }
        }
        
        if(EndlineBatchMap != null && !EndlineBatchMap.isEmpty()){
            set<string> batchIdKeySet = new set<string>();
            for(string btId : EndlineBatchMap.keyset()){
                batchIdKeySet.add(btId);
            }
            
            string querySobject = 'SELECT Batch_Id__c,createdDate '
                + 'FROM ' +objectAPIName 
                + ' WHERE RecordTypeId =: endlineRTID AND Batch_Id__c =: batchIdKeySet AND '
                + 'Student__c != null AND Academic_Year__c =: AcademicYear AND '
                + 'Error_Status__c = \'No Error\' ORDER BY createdDate ASC';
            
            List<Sobject> queriedSobjectList = Database.query(querySobject);
            system.debug('queriedSobjectList >>' +queriedSobjectList.size());
            
            for(Sobject obj : queriedSobjectList){
                string BatchId = (String)obj.get('Batch_Id__c');
                DateTime CreatedDate = (DateTime)obj.get('CreatedDate');
                if(!OMREndlineMap.containsKey(BatchId)){
                    OMREndlineMap.put(BatchId, CreatedDate);
                }
            }
            
            for(string st : EndlineBatchMap.Keyset()){
                Session_OMR_Type__c sot = new Session_OMR_Type__c();
                if(OMREndlineMap.ContainsKey(st)){
                    sot.Id = EndlineBatchMap.get(st);
                    sot.First_OMR_Uploaded_Date__c = date.ValueOf(OMREndlineMap.get(st));
                    lstOMRsessionType.add(sot);
                }
            }
        }
        
        if(lstOMRsessionType.size() > 0){
            system.debug('lstOMRsessionType >>' +lstOMRsessionType.size());
            update lstOMRsessionType;
        }
        
    }
    
    global static void updateOMRUploadDate2(list<Session_OMR_Type__c> listSessionOMRType, string objectAPIName){
        list<Session_OMR_Type__c> lstOMRsessionType = new list<Session_OMR_Type__c>();
        
        map<string,string> BatchIDMap = new map<string,string>();
        map<string, DateTime> OMRCreatedMap = new map<string,DateTime>();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        decimal AcademicYear = antarangSett.Academic_Year__c;
        
        for(Session_OMR_Type__c sot : listSessionOMRType ){
               BatchIDMap.put(sot.Session_Batch_Id__c, sot.Id);
         }
        
        if(BatchIDMap != null && !BatchIDMap.isEmpty()){
            set<string> batchIdKeySet = new set<string>();
            for(string btId : BatchIDMap.keyset()){
                batchIdKeySet.add(btId);
            }
            
            string querySobject = 'SELECT Batch_Id__c,createdDate '
                + 'FROM ' +objectAPIName 
                + ' WHERE Batch_Id__c =: batchIdKeySet AND '
                + 'Student__c != null AND Academic_Year__c =: AcademicYear AND '
                + 'Error_Status__c = \'No Error\' ORDER BY createdDate ASC';
            
            List<Sobject> queriedSobjectList = Database.query(querySobject);
            
            for(Sobject obj : queriedSobjectList){
                string BatchId = (String)obj.get('Batch_Id__c');
                DateTime CreatedDate = (DateTime)obj.get('CreatedDate');
                if(!OMRCreatedMap.containsKey(BatchId)){
                    OMRCreatedMap.put(BatchId, CreatedDate);
                }
            }
            
            for(string st : BatchIDMap.Keyset()){
                Session_OMR_Type__c sot = new Session_OMR_Type__c();
                if(OMRCreatedMap.ContainsKey(st)){
                    sot.Id = BatchIDMap.get(st);
                    sot.First_OMR_Uploaded_Date__c = date.ValueOf(OMRCreatedMap.get(st));
                    lstOMRsessionType.add(sot);
                }
            }
        }
        
        if(lstOMRsessionType.size() > 0){
            system.debug('lstOMRsessionType >>' +lstOMRsessionType.size());
            update lstOMRsessionType;
        }
    }
    
}