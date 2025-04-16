/*
Description: Class for Batch trigger Handler
*/
public with sharing class BatchTriggerHandler {
    public static void updateDummyBatch(List<Batch__c> lstBatches, map<Id,Batch__c> mapOldBatches){
        Map<Decimal,Batch__c> batchNumbersMap = new Map<Decimal,Batch__c>(); 
        
        for(Batch__c objBatch: lstBatches){
            if(mapOldBatches.get(objBatch.Id).Dummy_Batch_Created__c && objBatch.School_Name__c != mapOldBatches.get(objBatch.Id).School_Name__c || objBatch.Grade__c != mapOldBatches.get(objBatch.Id).Grade__c ||
               objBatch.Academic_Year__c != mapOldBatches.get(objBatch.Id).Academic_Year__c || objBatch.Trainer_Name__c != mapOldBatches.get(objBatch.Id).Trainer_Name__c   ){
                   batchNumbersMap.put(Decimal.valueOf(objBatch.Batch_Number__c), objBatch);
               }
        }
        List<Batch__c> dummyBatchesLst =  new List<Batch__c>();
        for(Batch__c objBatch: [Select Id, School_Name__c, Academic_Year__c, Trainer_Name__c, Grade__c, Copy_of_Batch__c, Batch_Number__c From Batch__c Where Copy_of_Batch__c IN : batchNumbersMap.keySet()]){
            if(batchNumbersMap.containsKey(objBatch.Copy_of_Batch__c)){
                objBatch.Name = 'DUMMY-'+batchNumbersMap.get(objBatch.Copy_of_Batch__c).Name;
                objBatch.Academic_Year__c = batchNumbersMap.get(objBatch.Copy_of_Batch__c).Academic_Year__c;
                objBatch.School_Name__c = batchNumbersMap.get(objBatch.Copy_of_Batch__c).School_Name__c;
                objBatch.Trainer_Name__c = batchNumbersMap.get(objBatch.Copy_of_Batch__c).Trainer_Name__c;
                //system.debug('tet : '+batchNumbersMap.get(objBatch.Copy_of_Batch__c).Grade__c);
                objBatch.Grade__c = batchNumbersMap.get(objBatch.Copy_of_Batch__c).Grade__c;
                //system.debug('tet 1: '+batchNumbersMap.get(objBatch.Copy_of_Batch__c).Grade__c);
            }
            dummyBatchesLst.add(objBatch);
        }
        
        if(dummyBatchesLst.size() > 0){
            update dummyBatchesLst;
        }
        
    }
    
    public static void calculateNumberOfStudent(List<Batch__c> lstBatches, map<Id,Batch__c> mapOldBatches){
        set<Id> setofSchoolIds = new set<Id>();
        
        for(Batch__c objBatch: lstBatches){
            if(objBatch.School_Name__c != mapOldBatches.get(objBatch.Id).School_Name__c){
                if(objBatch.School_Name__c != null) setofSchoolIds.add(objBatch.School_Name__c);
                if(mapOldBatches.get(objBatch.Id).School_Name__c != null) setofSchoolIds.add(mapOldBatches.get(objBatch.Id).School_Name__c);
            }
            if(objBatch.Number_of_students_facilitated__c != mapOldBatches.get(objBatch.Id).Number_of_students_facilitated__c){
                if(objBatch.School_Name__c != null) setofSchoolIds.add(objBatch.School_Name__c);
            }
            if(objBatch.No_of_Students_in_G_10_left_school_20_21__c != mapOldBatches.get(objBatch.Id).No_of_Students_in_G_10_left_school_20_21__c){
                setofSchoolIds.add(objBatch.School_Name__c);
                
            }
        }
        
        if(setofSchoolIds.size() > 0){ 
            List<Account> lstSchoolsToUpdate = new List<Account>();
            for(Account objAcc: [select Id,No_of_Students_in_G_10_left_school_20_21__c ,Number_of_students__c, (select Id,Number_of_students_facilitated__c,No_of_Students_in_G_10_left_school_20_21__c  from Batches1__r) 
                                 from Account Where Id in: setofSchoolIds]){
                                     Integer NoofStudents = 0;
                                     Integer NoofLeftStudent = 0;
                                     for(Batch__c objB : objAcc.Batches1__r){
                                         if(objB.Number_of_students_facilitated__c != null) {
                                             NoofStudents += Integer.valueof(objB.Number_of_students_facilitated__c);
                                         }
                                         if(objB.No_of_Students_in_G_10_left_school_20_21__c!= null) {
                                             NoofLeftStudent += Integer.valueof(objB.No_of_Students_in_G_10_left_school_20_21__c);
                                         }
                                     }
                                     Account objSchool = new Account(Id = objAcc.Id, Number_of_students__c = string.valueof(NoofStudents),No_of_Students_in_G_10_left_school_20_21__c= NoofLeftStudent );
                                     lstSchoolsToUpdate.add(objSchool);
                                     
                                 }
            if(lstSchoolsToUpdate.size() > 0){
                update lstSchoolsToUpdate;
            }
        }
        
    }
    
    public static void calculateNumberOfBatches(List<Batch__c> lstBatches, map<Id,Batch__c> mapOldBatches, boolean isInsert, boolean isUpdate){
        set<Id> setOfDonorIds = new set<Id>();
        set<Id> setOfTrainerIds = new set<Id>();
        
        for(Batch__c objBatch: lstBatches){
            if(isInsert || (isUpdate && objBatch.Donor_Name__c != mapOldBatches.get(objBatch.Id).Donor_Name__c)){
                if(objBatch.Donor_Name__c != null) setOfDonorIds.add(objBatch.Donor_Name__c);
                if(mapOldBatches != null && mapOldBatches.get(objBatch.Id).Donor_Name__c != null) setOfDonorIds.add(mapOldBatches.get(objBatch.Id).Donor_Name__c);
            }
            if(isInsert || (isUpdate && objBatch.Trainer_Name__c != mapOldBatches.get(objBatch.Id).Trainer_Name__c)){
                if(objBatch.Trainer_Name__c != null) setOfTrainerIds.add(objBatch.Trainer_Name__c);
                if(mapOldBatches != null && mapOldBatches.get(objBatch.Id).Trainer_Name__c != null) setOfTrainerIds.add(mapOldBatches.get(objBatch.Id).Trainer_Name__c);
            }
        }
        //udpate number on donor
        if(setOfDonorIds.size() > 0){
            List<Account> lstDonorsToUpdate = new List<Account>();
            for(Account objAcc: [select Id, Number_of_batches_allocated__c, Number_of_batches_funded__c, Number_of_batches_pending__c, (select Id from Batches__r) 
                                 from Account Where Id in: setOfDonorIds]){
                                     Integer NumberofBatchsFunded = 0;
                                     for(Batch__c objBatch: objAcc.Batches__r) {
                                         NumberofBatchsFunded++;
                                     }
                                     Integer NumberofBatchsPending = (objAcc.Number_of_batches_allocated__c != null ? Integer.valueof(objAcc.Number_of_batches_allocated__c) : 0) - NumberofBatchsFunded;
                                     Account objDonor = new Account(Id = objAcc.Id, Number_of_batches_funded__c = NumberofBatchsFunded, Number_of_batches_pending__c = NumberofBatchsPending);
                                     lstDonorsToUpdate.add(objDonor);
                                     
                                 }
            if(lstDonorsToUpdate.size() > 0){
                update lstDonorsToUpdate;
            }
        }
        //update number of batches conducted
        if(setOfTrainerIds.size() > 0){
            List<Contact> lstTrainersToUpdate = new List<Contact>();
            for(Contact objCon: [select Id, Number_Of_Batches__c, (select Id from Batches__r) 
                                 from Contact Where Id in: setOfTrainerIds]){
                                     Integer NumberofBatches = 0;
                                     for(Batch__c objBatch: objCon.Batches__r) {
                                         NumberofBatches++;
                                     }        
                                     Contact objTrainer = new Contact(Id = objCon.Id, Number_Of_Batches__c = NumberofBatches);
                                     lstTrainersToUpdate.add(objTrainer);
                                 }
            if(lstTrainersToUpdate.size() > 0){
                update lstTrainersToUpdate;
            }
        } 
    }
    
    public static void countSession(List<Batch__c> newValues, map<Id,Batch__c> mapOldBatches,boolean isDelete){
        set<Id> contactIds = new set<Id>();
        if(isDelete){
            for(batch__c b : mapOldBatches.values()){
                if(b.Trainer_Name__c != null){
                    contactIds.add(b.Trainer_Name__c);                
                }
            } 
        }
        else{
            for(batch__c b : newValues){
                if(b.Trainer_Name__c != null){
                    contactIds.add(b.Trainer_Name__c);                
                } 
            } 
        }
        if(contactIds.size()>0){
            List<contact> conToUpdate = SessionTriggerHandler.updateContact(contactIds);            
            // Update count on contact
            if(conToUpdate.size() > 0){
                try{
                    update conToUpdate;
                    system.debug('conToUpdate : '+conToUpdate);
                }catch(System.Exception e){
                    System.debug('Error'+e.getMessage());
                }
            }
        }
    }
    
    public static void updatingFacilitatorName(map<Id,Batch__c> newBatches, map<Id,Batch__c> oldBatches){
        
        Map<Id,Batch__c> updatedBatch = new Map<Id,Batch__c>();
        
        for(Batch__c batch:newBatches.values()){
            
            if((batch.Followup_1_Trainer_Name__c != null && batch.Followup_1_Trainer_Name__c != oldBatches.get(batch.Id).Followup_1_Trainer_Name__c ) 
               || (batch.Trainer_Name__c !=null && batch.Trainer_Name__c != oldBatches.get(batch.Id).Trainer_Name__c )){
                   updatedBatch.put(batch.id,batch);
               }
        }
        //Getting Session records to update
        List<Session__c> session =[select id,Name,Assigned_Facilitator__c,Session_Grade__c,Batch__c,(select name from Sessions__r) 
                                   from Session__c where Batch__c IN :updatedBatch.keySet() AND SessionDate__c = null   ];
        
        for(Session__c se:session){
            if(se.sessions__r.size() == 0){
                se.Assigned_Facilitator__c = updatedBatch.get(se.Batch__c).Trainer_Name__c;
            }
        }
        
        try{
            update session;    
        }catch(system.Exception e){
            System.debug('Error'+e.getMessage());
        }
        
    }
    
    //20th oct 2021 updated related session record to child record based on field combined batch no/combined batch no for g10
    public static void updateSessionToChild(map<Id,Batch__c> newValues, map<Id,Batch__c> mapOldBatches){
        
        set<String> batchNoToUpdatedSessionToChild = new set<String>();
        set<String> batchNoToUpdatedSessionToNotChild = new set<String>();
        
        set<string> batchGrade10toChild = new set<string>();
        set<string> batchGrade10NotChild = new set<string>();
        
        set<string> allbatchnumbers = new set<string>();
        
        for(Batch__c batch:newValues.values()){
            if(batch.Combined_Batch_no__c != null && batch.Combined_Batch_no__c != mapOldBatches.get(batch.Id).Combined_Batch_no__c){
                batchNoToUpdatedSessionToChild.add(String.valueOf(batch.Batch_Number_edit__c));
                if(mapOldBatches.get(batch.Id).Combined_Batch_no__c != null)
                    batchNoToUpdatedSessionToNotChild.add(String.valueOf(mapOldBatches.get(batch.Id).Batch_Number_edit__c));
            }
            if(mapOldBatches.get(batch.Id).Combined_Batch_no__c != null && batch.Combined_Batch_no__c == null){
                batchNoToUpdatedSessionToNotChild.add(String.valueOf(mapOldBatches.get(batch.Id).Batch_Number_edit__c));
            }
            
            if(batch.Combined_Batch_no_for_G10__c != null && batch.Combined_Batch_no_for_G10__c != mapOldBatches.get(batch.Id).Combined_Batch_no_for_G10__c){
                batchGrade10toChild.addAll(String.valueOf(batch.Combined_Batch_no_for_G10__c).trim().split(','));
                if(mapOldBatches.get(batch.Id).Combined_Batch_no_for_G10__c != null){
                    
                    batchGrade10NotChild.addAll(String.valueOf(mapOldBatches.get(batch.Id).Combined_Batch_no_for_G10__c).trim().split(','));
                }
                    
            }
            if(mapOldBatches.get(batch.Id).Combined_Batch_no_for_G10__c != null && batch.Combined_Batch_no_for_G10__c == null){
                
                batchGrade10NotChild.addAll(String.valueOf(mapOldBatches.get(batch.Id).Combined_Batch_no_for_G10__c).trim().split(','));
            }
        }
        
        for(string s : batchGrade10toChild){
            //batchNoToUpdatedSessionToChild.add(s);
            if(batchGrade10NotChild.contains(s)){
                batchGrade10NotChild.remove(s);
            }
        }
        
        //if(batchGrade10NotChild.size()>0)
        // batchNoToUpdatedSessionToNotChild.addAll(batchGrade10NotChild);
        
        allbatchnumbers.addall(batchNoToUpdatedSessionToChild);
        allbatchnumbers.addall(batchNoToUpdatedSessionToNotChild);
        allbatchnumbers.addall(batchGrade10NotChild);
        allbatchnumbers.addall(batchGrade10toChild);
        
        List<Session__c> sessionToUpdate = new List<Session__c>();
        
        for(Session__c objSession : [select id,Batch__r.Batch_Number__c,Is_Inactive_Session__c,Session_Grade__c
                                     from Session__c where Batch__r.Batch_Number__c IN: batchNoToUpdatedSessionToChild
                                     OR Batch__r.Batch_Number__c IN: batchNoToUpdatedSessionToNotChild
                                    OR Batch__r.Batch_Number__c IN: batchGrade10toChild
                                    OR Batch__r.Batch_Number__c IN: batchGrade10NotChild])
        {
            if(allbatchnumbers.contains(objSession.Batch__r.Batch_Number__c)){
                allbatchnumbers.remove(objSession.Batch__r.Batch_Number__c);
            }
            
            if((batchNoToUpdatedSessionToChild.contains(objSession.Batch__r.Batch_Number__c) && objSession.Session_Grade__c == 'Class 9') ||
               (batchGrade10toChild.contains(objSession.Batch__r.Batch_Number__c) && objSession.Session_Grade__c == 'Class 10')) 
            {
                objSession.Is_Inactive_Session__c = true;
            } 
            if(batchNoToUpdatedSessionToNotChild.contains(objSession.Batch__r.Batch_Number__c) && objSession.Session_Grade__c == 'Class 9' ||
               (batchGrade10NotChild.contains(objSession.Batch__r.Batch_Number__c) && objSession.Session_Grade__c == 'Class 10'))
            {
                objSession.Is_Inactive_Session__c = false;
            } 
            
            sessionToUpdate.add(objSession); 
            
        }
        
        for(Batch__c batch:newValues.values()){
            if(allbatchnumbers.size()>0 && allbatchnumbers.size() == 1){
                batch.adderror('No Session record found for Batch '+string.valueof(allbatchnumbers)+'. Please exclude the batch or create session for the batch and then try again.');
            }
            else if (allbatchnumbers.size()>1){
                batch.adderror('No Session record found for Batches '+string.valueof(allbatchnumbers)+'. Please exclude the batches or create session for the batches and then try again.');
            }
        }
        
        if(sessionToUpdate.size()>0){
            update sessionToUpdate;
        }
        
        
    }
    
    public static void updateNoOfStudOnSOT(List<Batch__c> newBatchList, Map<Id,Batch__c> oldBatchMap) {
        Map<Id,Decimal> mapBatch = New Map<Id,Decimal>();
        List<Session_OMR_Type__c> sotList = New List<Session_OMR_Type__c>();
        for(Batch__c b: newBatchList) {
            if(b.Number_of_students_facilitated__c != oldBatchMap.get(b.Id).Number_of_students_facilitated__c) {
                mapBatch.put(b.Id, b.Number_of_students_facilitated__c);
            }
        }
        if(mapBatch.size()>0) {
            for(Session_OMR_Type__c sot: [Select Id, Session_Batch_Id__c, OMR_Type__c
                                          From Session_OMR_Type__c
                                          Where Session_Batch_Id__c IN: mapBatch.keySet()
                                          AND OMR_Type__c = 'Student Details']) {
                                              sot.OMR_Assessment_Count__c =  mapBatch.get(sot.Session_Batch_Id__c);
                                              sotList.add(sot);
                                          }
        }
        if(sotList.size()>0) {
            update sotList;
        }
    }
}