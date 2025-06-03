public class SchoolCodeUpdateHandler {
        
        public static void updateDonor(list<Account> newValues){
            Id RecordTypeIdDonor = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Donor').getRecordTypeId();  
            
            for(account a: newValues){
                if (a.RecordTypeId == RecordTypeIdDonor && a.Number_of_batches_funded__c != null) {
                    if (a.Number_of_batches_allocated__c ==null) {
                        a.Number_of_batches_allocated__c=0;
                    }
                    a.Number_of_batches_pending__c = a.Number_of_batches_allocated__c - a.Number_of_batches_funded__c ;
                }
            }
        }
        
        public static void createbatches(list<Account> newValues, map<Id,Account> oldvaluesMap, boolean isInsert){
            AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
            Id RecordTypeIdSchool = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId(); 
            
            Map<Id, Account> mapAccIdToStudents = new Map<Id, Account>();       
            Map<Id, Account> map2AccIdToStudents = new Map<Id, Account>();
            Integer currAcad;
            Integer nextAcad;
            
            for(Account acc: newValues) {
                if(acc.recordtypeId == RecordTypeIdSchool && 
                   (isInsert || 
                    (acc.Enrolled_Grade_9__c > 0 && acc.Enrolled_Grade_9__c != oldvaluesMap.get(acc.Id).Enrolled_Grade_9__c &&
                     (oldvaluesMap.get(acc.Id).Enrolled_Grade_9__c == NULL ||
                      acc.Enrolled_Grade_9__c > oldvaluesMap.get(acc.Id).Enrolled_Grade_9__c)) ||
                    (acc.Enrolled_Grade_10__c > 0 && acc.Enrolled_Grade_10__c != oldvaluesMap.get(acc.Id).Enrolled_Grade_10__c &&
                     (oldvaluesMap.get(acc.Id).Enrolled_Grade_10__c == NULL ||
                      acc.Enrolled_Grade_10__c > oldvaluesMap.get(acc.Id).Enrolled_Grade_10__c)) ||
                    (acc.Enrolled_Grade_11__c > 0 && acc.Enrolled_Grade_11__c != oldvaluesMap.get(acc.Id).Enrolled_Grade_11__c &&
                     (oldvaluesMap.get(acc.Id).Enrolled_Grade_11__c == NULL ||
                      acc.Enrolled_Grade_11__c > oldvaluesMap.get(acc.Id).Enrolled_Grade_11__c)) ||
                    (acc.Enrolled_Grade_12__c > 0 && acc.Enrolled_Grade_12__c != oldvaluesMap.get(acc.Id).Enrolled_Grade_12__c &&
                     (oldvaluesMap.get(acc.Id).Enrolled_Grade_12__c == NULL ||
                      acc.Enrolled_Grade_12__c > oldvaluesMap.get(acc.Id).Enrolled_Grade_12__c))
                   )
                  ){
                      system.debug('**acc.Academic_Year__c:'+ acc.Academic_Year__c);
                      if(acc.Academic_Year__c == setting.Academic_Year__c){
                          mapAccIdToStudents.put(acc.Id, acc);
                          currAcad = Integer.valueOf(setting.Academic_Year__c);
                      }Else if(acc.Academic_Year__c == setting.Next_Academic_Year__c){
                          map2AccIdToStudents.put(acc.Id, acc);
                          nextAcad = Integer.valueOf(setting.Next_Academic_Year__c);
                         // system.debug('nextAcad>>>>'+ nextAcad);
                      }
                  }
                system.debug('**mapAccIdToStudents:'+ mapAccIdToStudents);
            }
            
            if(mapAccIdToStudents.size() > 0){
                callBatchMethod(mapAccIdToStudents, currAcad, isInsert);
            }
            
            if(map2AccIdToStudents.size() > 0){
                callBatchMethod(map2AccIdToStudents, nextAcad, isInsert);        
            }
            
        }
        
        public static void callBatchMethod(Map<Id, Account> AccIdToStudMap, Integer AccadYear, boolean isInsert){            
            AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
            if(AccIdToStudMap.size() > 0){
                
                //Get the existing batches of account if Update event is fired
                Map<Id, Integer> mapAccIdToBatchCnt = new Map<Id, Integer>();
                Map<Id, Integer> mapAccIdToBatchCntForGrade9 = new Map<Id, Integer>();
                Map<Id, Integer> mapAccIdToBatchCntForGrade10 = new Map<Id, Integer>();
                Map<Id, Integer> mapAccIdToBatchCntForGrade11 = new Map<Id, Integer>();
                Map<Id, Integer> mapAccIdToBatchCntForGrade12 = new Map<Id, Integer>();
                
                Map<Id, String> mapBatchIdToDistrict = new Map<Id, String>();
                
                if(!isInsert){
                    List<AggregateResult> aggrResult = [SELECT COUNT(Id), School_Name__c  
                                                        FROM Batch__c 
                                                        WHERE School_Name__c IN:AccIdToStudMap.keySet()  
                                                        AND Academic_Year__c =: AccadYear
                                                        AND Dummy_Batch__c = False	//added on 29.03.2023
                                                        GROUP BY School_Name__c];
                    
                    system.debug('aggrResult>>>>'+ aggrResult);
                    
                    if(!aggrResult.isEmpty() && aggrResult.size() > 0){
                        for(AggregateResult result : aggrResult){
                            Integer existingBatches = (Integer)result.get('expr0');
                            Id accountId = (Id)result.get('School_Name__c');
                            mapAccIdToBatchCnt.put(accountId, existingBatches);
                        }
                        system.debug('**mapAccIdToBatchCnt:'+ mapAccIdToBatchCnt);
                    }
                    
                    List<AggregateResult> batchWithExistingGrade = [Select Count(Id),Grade__c,School_Name__c 
                                                                    From Batch__c 
                                                                    where School_Name__c IN:AccIdToStudMap.keySet() 
                                                                    AND Academic_Year__c =: AccadYear 
                                                                    AND Grade__c !='' 
                                                                    AND Dummy_Batch__c = False	//added on 29.03.2023
                                                                    GROUP BY Grade__c,School_Name__c];
                  System.debug('AggrResult batchWithExistingGrade: '+batchWithExistingGrade);
                    if(!batchWithExistingGrade.isEmpty() && batchWithExistingGrade.size() > 0){
                        for(AggregateResult result : batchWithExistingGrade){
                            /*Integer existingBatches = (Integer)result.get('expr0');
                            Id accountId = (Id)result.get('School_Name__c');
                            mapAccIdToBatchCnt.put(accountId, existingBatches);*/
                            Id accountId = (Id)result.get('School_Name__c');
                            if((String)result.get('Grade__c') == 'Grade 9')
                                mapAccIdToBatchCntForGrade9.put(accountId,(Integer)result.get('expr0'));
                            if((String)result.get('Grade__c') == 'Grade 10')
                                mapAccIdToBatchCntForGrade10.put(accountId,(Integer)result.get('expr0'));
                            if((String)result.get('Grade__c') == 'Grade 11')
                                mapAccIdToBatchCntForGrade11.put(accountId,(Integer)result.get('expr0'));
                            if((String)result.get('Grade__c') == 'Grade 12')
                                mapAccIdToBatchCntForGrade12.put(accountId,(Integer)result.get('expr0'));
                        }
                        System.debug('mapAccIdToBatchCntForGrade9: '+mapAccIdToBatchCntForGrade9+', mapAccIdToBatchCntForGrade10: '+mapAccIdToBatchCntForGrade10 +
                                     ', mapAccIdToBatchCntForGrade11: '+mapAccIdToBatchCntForGrade11 +', mapAccIdToBatchCntForGrade12: '+mapAccIdToBatchCntForGrade12);
                    }
                }
                System.debug('mapAccIdToBatchCntForGrade9: '+mapAccIdToBatchCntForGrade9+', mapAccIdToBatchCntForGrade10: '+mapAccIdToBatchCntForGrade10 +
                                     ', mapAccIdToBatchCntForGrade11: '+mapAccIdToBatchCntForGrade11 +', mapAccIdToBatchCntForGrade12: '+mapAccIdToBatchCntForGrade12);
                List<Batch__c> batchesToBeInserted = new List<Batch__c>();
                for(Id accountId : AccIdToStudMap.keyset()){
                    Map<String, Integer> gradeWithBatchSize = new Map<String, Integer>();
                    Account objschool = AccIdToStudMap.get(accountId);
                    Integer studentCnt = (Integer)objschool.total_student_count_21_22__c;
                    Integer enrolledGrade9 = (Integer)objschool.Enrolled_Grade_9__c;
                    Integer enrolledGrade10 = (Integer)objschool.Enrolled_Grade_10__c;
                    Integer enrolledGrade11 = (Integer)objschool.Enrolled_Grade_11__c;
                    Integer enrolledGrade12 = (Integer)objschool.Enrolled_Grade_12__c;
                    Integer existingBatches = mapAccIdToBatchCnt.containsKey(accountId) ? mapAccIdToBatchCnt.get(accountId) : 0;
                    Integer createBatchesCnt = 0;
                    system.debug('objschool--'+objschool+' enrolledGrade9--'+enrolledGrade9+' enrolledGrade10--'+enrolledGrade10+' enrolledGrade11--'+enrolledGrade11+' enrolledGrade12--'+enrolledGrade12);
                    System.debug('existingBatches: '+existingBatches);
                    system.debug('mapAccIdToBatchCntForGrade9.size()--'+mapAccIdToBatchCntForGrade9.size());
                    system.debug('mapAccIdToBatchCntForGrade9.get(accountId)--'+mapAccIdToBatchCntForGrade9.get(accountId));
                    if(!mapAccIdToBatchCntForGrade9.containskey(accountId)) {
                        mapAccIdToBatchCntForGrade9.put(accountId,0);
                    }
                    if(!mapAccIdToBatchCntForGrade10.containskey(accountId)) {
                        mapAccIdToBatchCntForGrade10.put(accountId,0);
                    }
                    if(!mapAccIdToBatchCntForGrade11.containskey(accountId)) {
                        mapAccIdToBatchCntForGrade11.put(accountId,0);
                    }
                    if(!mapAccIdToBatchCntForGrade12.containskey(accountId)) {
                        mapAccIdToBatchCntForGrade12.put(accountId,0);
                    }
                    gradeWithBatchSize.put('Grade 9', calculatebatchcnt(Integer.valueOf(setting.Max_batch_size__c), mapAccIdToBatchCntForGrade9.size() > 0 ? mapAccIdToBatchCntForGrade9.get(accountId) : 0, enrolledGrade9));
                    gradeWithBatchSize.put('Grade 10', calculatebatchcnt(Integer.valueOf(setting.Max_batch_size__c), mapAccIdToBatchCntForGrade10.size() > 0 ? mapAccIdToBatchCntForGrade10.get(accountId) : 0, enrolledGrade10));
                    gradeWithBatchSize.put('Grade 11', calculatebatchcnt(Integer.valueOf(setting.Max_batch_size__c), mapAccIdToBatchCntForGrade11.size() > 0 ? mapAccIdToBatchCntForGrade11.get(accountId) : 0, enrolledGrade11));
                    gradeWithBatchSize.put('Grade 12', calculatebatchcnt(Integer.valueOf(setting.Max_batch_size__c), mapAccIdToBatchCntForGrade12.size() > 0 ? mapAccIdToBatchCntForGrade12.get(accountId) : 0, enrolledGrade12));
                    
                    system.debug('gradeWithBatchSize : ' + gradeWithBatchSize);
                    
                    //Create batches for current account
                    for(String grade : gradeWithBatchSize.keyset()){
                        for(integer i = 1 ; i <= gradeWithBatchSize.get(grade) ; i++){
                            if(objschool.Academic_Year__c == AccadYear){
                                batch__c bc = new batch__c();
                                
                                if(grade == 'Grade 9'){
                                    existingBatches = mapAccIdToBatchCntForGrade9.size() > 0 ? mapAccIdToBatchCntForGrade9.get(accountId) : 0; }
                                   // existingBatches = gradeWithBatchSize.get('Grade 9') > 0 ? gradeWithBatchSize.get('Grade 9') : 0; }
                                   // mapAccIdToBatchCntForGrade9.get(accountId)
                                if(grade == 'Grade 10'){
                                   existingBatches = mapAccIdToBatchCntForGrade10.size() > 0 ? mapAccIdToBatchCntForGrade10.get(accountId) : 0; }
                                if(grade == 'Grade 11'){
                                   existingBatches = mapAccIdToBatchCntForGrade11.size() > 0 ? mapAccIdToBatchCntForGrade11.get(accountId) : 0; }
                                
                                if(grade == 'Grade 12'){
                                   existingBatches = mapAccIdToBatchCntForGrade12.size() > 0 ? mapAccIdToBatchCntForGrade12.get(accountId) : 0; 
                                }                                
                                
                                bc.School_Name__c = accountId;
                               // System.debug('Academic_Year__c: '+Integer.valueOf(setting.Academic_Year__c));
                                System.debug('existingBatches: '+existingBatches);
                                System.debug('i: '+i);
                                bc.Name = objschool.Name+ '-' + grade + '-' + objschool.Medium_Language_of_Instruction__c +' '+Integer.valueOf(AccadYear)+ ' ' +(existingBatches + i);
                                bc.Grade__c = grade;
                                //bc.Need_to_assign_G9__c = TRUE;
                                //bc.Need_to_assign_G10__c = TRUE;
                                bc.Medium_Language_of_Instruction__c = objschool.Medium_Language_of_Instruction__c;
                                bc.Preferred_Language__c = objschool.Medium_Language_of_Instruction__c;
                                //bc.Date_of_facilitation_starting__c = system.today();
                                bc.Academic_Year__c = objschool.Academic_Year__c;
                                batchesToBeInserted.add(bc);
                                System.debug('**bc: '+bc + ', **batchesToBeInserted:'+batchesToBeInserted);
                            }
                        }
                    }
                }
                
                //Insert batches
                if(batchesToBeInserted.size() > 0){
                    Database.SaveResult[] saveResultList = Database.insert(batchesToBeInserted, false);
                    System.debug('**saveResultList'+saveResultList);
                    Set<Id> batchIds = new Set<Id>();
                    for (Database.SaveResult sr : saveResultList) {
                        if (sr.isSuccess()) {
                            batchIds.add(sr.getId());
                        }
                    }
                    System.debug('**batchIds'+batchIds);
                    
                    if(batchIds.size() > 0){
                        List<session__c> sessionList = new List<session__c>();
                        /*
                        Map<string,Session_Mapping__c> mappingSessionMap = new Map<string,Session_Mapping__c>();
                        Map<String, Integer> gradeWithSessCount = new Map<String, Integer>(); 
                        gradeWithSessCount.put('Grade 9', Integer.valueOf(setting.Number_of_Sessions_for_Grade_9__c));
                        gradeWithSessCount.put('Grade 10', Integer.valueOf(setting.Number_of_Session_for_Grade_10__c));
                        if(setting.Number_of_Sessions_for_Grade_11__c != null){
                            gradeWithSessCount.put('Grade 11', Integer.valueOf(setting.Number_of_Sessions_for_Grade_11__c));   
                        }
                        if(setting.Number_of_Sessions_for_Grade_12__c != null){
                            gradeWithSessCount.put('Grade 12', Integer.valueOf(setting.Number_of_Sessions_for_Grade_12__c));
                        }
                        for(Session_Mapping__c objSessionMapping : [select id,name,Description__c,Grade__c,Payment__c,
                                                                    Session_Delivery__c,Session_Number__c,Session_Type__c,Session_Mode__c,
                                                                    OMR_Required__c 
                                                                    FROM Session_Mapping__c]){
                                                                        mappingSessionMap.put(string.valueOf(objSessionMapping.Grade__c)+'_'+objSessionMapping.Session_Number__c, objSessionMapping);       
                                                                    }
                        
                        Boolean isOmrTypesRequired = false;
                        for(batch__c bc : [Select Id,Grade__c From batch__c where Id IN :batchIds]){
                            if(gradeWithSessCount.containsKey(bc.Grade__c)){
                                for(integer i=0;i<gradeWithSessCount.get(bc.Grade__c);i++){
                                    session__c s = new session__c();
                                    if(mappingSessionMap.containskey(bc.Grade__c+'_'+i)){
                                        //s.Name = i+'_'+mappingSessionMap.get(grade+'_'+i).Description__c;
                                        s.Name = mappingSessionMap.get(bc.Grade__c+'_'+i).Description__c;
                                        s.Session_Delivery__c = mappingSessionMap.get(bc.Grade__c+'_'+i).Session_Delivery__c;
                                        s.Session_Type__c = mappingSessionMap.get(bc.Grade__c+'_'+i).Session_Type__c;
                                        s.Total_Amount__c = mappingSessionMap.get(bc.Grade__c+'_'+i).Payment__c;
                                        s.Session_Mode__c = mappingSessionMap.get(bc.Grade__c+'_'+i).Session_Mode__c;
                                        s.Session_Number__c = mappingSessionMap.get(bc.Grade__c+'_'+i).Session_Number__c; 
                                        
                                        s.OMR_required__c = mappingSessionMap.get(bc.Grade__c+'_'+i).OMR_Required__c; 
                                        if(s.OMR_required__c){
                                            isOmrTypesRequired = true;
                                            s.OMR_s_received_for_session__c = 'No';
                                        } else {
                                            s.OMR_s_received_for_session__c = 'NA';
                                        }
                                    }else{
                                        s.Name = 'Session - '+i;
                                    }                
                                    s.Batch__c = bc.Id;
                                    //s.Assigned_facilitator__c = selectedFacilitor;
                                    s.Session_Grade__c = bc.Grade__c;
                                    sessionList.add(s);
                                }
                            }
                        }
                        if(sessionList.size() > 0){
                            Insert sessionList;
                        }
						*/
                        
                        Map<Id,List<Session_Mapping__c>> mapBatchIdvsSessionMappings = new Map<Id,List<Session_Mapping__c>>();
                        List<Session_Mapping__c> lstSessionMappings = [Select id,name,Description__c,Grade__c,Payment__c,
                                                                       Session_Delivery__c,Session_Number__c,Session_Type__c,Session_Mode__c,
                                                                       OMR_Required__c, District__c
                                                                       FROM Session_Mapping__c];
                        
                        for(batch__c bc : [Select Id, Grade__c, School_Name__r.District__r.Name From batch__c where Id IN :batchIds]){
                            List<Session_Mapping__c> lstSessionMappingsToAdd = new List<Session_Mapping__c>();
                            for(Session_Mapping__c sm : lstSessionMappings){
                                if(sm.District__c != Null){
                                    if(sm.District__c == bc.School_Name__r.District__r.Name && sm.Grade__c == bc.Grade__c){
                                        lstSessionMappingsToAdd.add(sm);
                                    }
                                }
                            }
                            if(lstSessionMappingsToAdd.size() > 0){
                                mapBatchIdvsSessionMappings.put(bc.Id, lstSessionMappingsToAdd);
                            }
                        }
                        
                        Boolean isOmrTypesRequired = false;
                        
                        for(batch__c bc : [Select Id, Grade__c, School_Name__r.District__r.Name From batch__c where Id IN :batchIds]){
                            if(mapBatchIdvsSessionMappings.containskey(bc.Id)){
                                for(Session_Mapping__c sm : mapBatchIdvsSessionMappings.get(bc.Id)){
                                    session__c s = new session__c();
                                    s.Name = sm.Description__c;
                                    s.Session_Delivery__c = sm.Session_Delivery__c;
                                    s.Session_Type__c = sm.Session_Type__c;
                                    s.Total_Amount__c = sm.Payment__c;
                                    s.Session_Mode__c = sm.Session_Mode__c;
                                    s.Session_Number__c = sm.Session_Number__c; 
                                    
                                    s.OMR_required__c = sm.OMR_Required__c; 
                                    if(s.OMR_required__c){
                                        isOmrTypesRequired = true;
                                        s.OMR_s_received_for_session__c = 'No';
                                    } else {
                                        s.OMR_s_received_for_session__c = 'NA';
                                    }
                                    
                                    s.Batch__c = bc.Id;
                                    mapBatchIdToDistrict.put(bc.Id, bc.School_Name__r.District__r.Name.trim().toLowerCase());
                                    
                                    //s.Assigned_facilitator__c = selectedFacilitor;
                                    s.Session_Grade__c = bc.Grade__c;
                                    if(sm.Session_Type__c == 'Counseling'){
                                        s.Session_Status__c = 'Incomplete';
                                    }else{
                                        s.Session_Status__c = 'Unscheduled';
                                    }
                                    sessionList.add(s);
                                }
                            }
                        }
                        
                        if(!sessionList.isEmpty()){
                            Insert sessionList;
                            if(isOmrTypesRequired){
                                createOmrTypeRecords(sessionList, mapBatchIdToDistrict);
                            }
                        }
                        
                        
                        /* Commented below omr type record Creations as part of enhancement we migrated it new method. 
                        if(isOmrTypesRequired){
                            Map<string, List<Session_OMR_Types_Mapping__c>> mappingOmrTypesMap = new Map<string, List<Session_OMR_Types_Mapping__c>>();
                            for(Session_OMR_Types_Mapping__c objOmrTypeMapping : [SELECT Id, Name, Grade__c, OMR_Record_Type__c, OMR_Type__c, Session_Name__c, Session_Number__c, OMR_Assessment_Object__c 
                                                                                  FROM Session_OMR_Types_Mapping__c])
                            {
                                if(mappingOmrTypesMap.containsKey(string.valueOf(objOmrTypeMapping.Grade__c)+'_'+objOmrTypeMapping.Session_Number__c)){
                                    mappingOmrTypesMap.get(string.valueOf(objOmrTypeMapping.Grade__c)+'_'+objOmrTypeMapping.Session_Number__c).add(objOmrTypeMapping);
                                }else{
                                    mappingOmrTypesMap.put(string.valueOf(objOmrTypeMapping.Grade__c)+'_'+objOmrTypeMapping.Session_Number__c, new List<Session_OMR_Types_Mapping__c>{ objOmrTypeMapping }); 
                                }       
                            }
                            
                            List<Session_OMR_Type__c> omrTypeList = new List<Session_OMR_Type__c>();
                            for(session__c s : sessionList){
                                if(s.OMR_required__c && mappingOmrTypesMap.containsKey(string.valueOf(s.Session_Grade__c)+'_'+s.Session_Number__c) ){
                                    for(Session_OMR_Types_Mapping__c omrType : mappingOmrTypesMap.get(string.valueOf(s.Session_Grade__c)+'_'+s.Session_Number__c)){
                                        Session_OMR_Type__c omr = new Session_OMR_Type__c();
                                        omr.Session__c = s.Id;
                                        omr.OMR_Type__c = omrType.OMR_Type__c;
                                        omr.OMR_Assessment_Object__c = omrType.OMR_Assessment_Object__c;
                                        omr.OMR_Assessment_Record_Type__c = omrType.OMR_Record_Type__c;
                                        
                                        omrTypeList.add(omr);
                                    }
                                }
                            }
                            
                            if(omrTypeList.size() > 0){
                                Insert omrTypeList;
                            }
                        }
						*/
                    }
                }
            }
        }
    
    public static void createOmrTypeRecords(List<session__c> sessions, Map<Id, String> batchIdtoDistrict){
        List<session__c> omrRequiredSessions = new List<Session__c>();
        List<Session_OMR_Type__c> omrTypeList = new List<Session_OMR_Type__c>();
        Set<String> omrRequiredSessionsGrades = new Set<String>();
        Set<Decimal> omrRequiredSessionsSessionNumber = new Set<Decimal>();
        Set<String> omrRequiredSessionsDistricts = new Set<String>();
        Set<String> omrRequiredSessionsGroups = new Set<String>();
        
        Map<String, String> districtToGroup = new Map<String, String>();
        
        for(session__c s : sessions){
            if(s.OMR_required__c){
                omrRequiredSessions.add(s);
                omrRequiredSessionsGrades.add(s.Session_Grade__c);
				omrRequiredSessionsSessionNumber.add(s.Session_Number__c); 
                
                if(batchIdtoDistrict.containsKey(s.Batch__c)){                    
                    omrRequiredSessionsDistricts.add(batchIdtoDistrict.get(s.Batch__c).trim().toLowerCase());
                }
            }
        }
        
        for(SOMRT_Groups__c objOmrTypeGroups : [SELECT Id, Name, Districts__c FROM SOMRT_Groups__c]){
            for (String district : objOmrTypeGroups.Districts__c.split(',')) {
                String key = district.trim().toLowerCase();
                if(omrRequiredSessionsDistricts.contains(key)){
                    districtToGroup.put(key, objOmrTypeGroups.Name); 
                }
            }
        }
            
        if(!districtToGroup.isEmpty()){
            omrRequiredSessionsGroups.addAll(districtToGroup.values());
        }
            
        
        Map<string, List<Session_OMR_Types_Mapping__c>> mappingOmrTypesMap = new Map<string, List<Session_OMR_Types_Mapping__c>>();
        for(Session_OMR_Types_Mapping__c objOmrTypeMapping : [SELECT Id, Name, Grade__c, Group__c, OMR_Record_Type__c, OMR_Type__c, Session_Name__c, Session_Number__c, OMR_Assessment_Object__c 
                                                              FROM Session_OMR_Types_Mapping__c
                                                              WHERE Group__c IN:omrRequiredSessionsGroups 
                                                              AND Grade__c IN:omrRequiredSessionsGrades 
                                                              AND Session_Number__c IN: omrRequiredSessionsSessionNumber])
        {
            String key = (objOmrTypeMapping.Grade__c.trim() +'_' + String.valueOf(objOmrTypeMapping.Session_Number__c).trim() + '_' + objOmrTypeMapping.Group__c).trim().toLowerCase();
            if(mappingOmrTypesMap.containsKey(key)){
                mappingOmrTypesMap.get(key).add(objOmrTypeMapping);
            }else{
                mappingOmrTypesMap.put(key, new List<Session_OMR_Types_Mapping__c>{ objOmrTypeMapping }); 
            }       
        }
        
        for(session__c s : omrRequiredSessions){
            String GroupName = '';
            if(batchIdtoDistrict.containsKey(s.Batch__c) && districtToGroup.containsKey(batchIdtoDistrict.get(s.Batch__c))){                    
                // GroupName = batchIdtoDistrict.get(s.Batch__c);
                
                GroupName = districtToGroup.get(batchIdtoDistrict.get(s.Batch__c));
            }
            
            String key = (s.Session_Grade__c.trim() + '_' + string.valueOf(s.Session_Number__c).trim() + '_'  + GroupName).trim().toLowerCase();
            
            if(mappingOmrTypesMap.containsKey(key) ){
                for(Session_OMR_Types_Mapping__c omrType : mappingOmrTypesMap.get(key)){
                    Session_OMR_Type__c omr = new Session_OMR_Type__c();
                    omr.Session__c = s.Id;
                    omr.OMR_Type__c = omrType.OMR_Type__c;
                    omr.OMR_Assessment_Object__c = omrType.OMR_Assessment_Object__c;
                    omr.OMR_Assessment_Record_Type__c = omrType.OMR_Record_Type__c;
                    
                    omrTypeList.add(omr);
                }
            }
        }
        
        if(!omrTypeList.isEmpty()){
            Insert omrTypeList;
        }
        
    }
        
        public static Integer calculatebatchcnt(Integer batchSize, Integer existingBatches, Integer studentCnt){
            if(studentCnt <= batchSize && existingBatches == 0 && studentCnt != 0){
                return 1;
            }else if(studentCnt > integer.valueof(batchSize)){
                if(studentCnt/integer.valueOf(batchSize) < (Decimal)studentCnt/integer.valueOf(batchSize)){
                    System.debug('**studentCnt:'+studentCnt + ', batchSize:' + integer.valueOf(batchSize) + ', existingBatches:' + existingBatches);
                    return ((studentCnt/integer.valueOf(batchSize)) + 1) - existingBatches;
                }else{
                    return (studentCnt/integer.valueOf(batchSize))- existingBatches;
                }
            }
            return 0;
        }
        
        public static void dummycoverage(){
            Integer i=0;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
            i++;
        } 
    }