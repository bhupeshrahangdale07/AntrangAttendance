/*
 * Handler class for trigger -->  createBatchesForSchool
*/
public class createBatchesForSchoolHandler {
    
    public static void createbatches(list<Account> newValues, map<Id,Account> oldvaluesMap, boolean isInsert){
        System.debug('---createbatches---');
        System.debug('IsInsert: ' + isInsert);
        Id RecordTypeIdSchool = Schema.SObjectType.Account.getRecordTypeInfosByName().get('School').getRecordTypeId(); 

        Map<Id, Account> mapAccIdToStudents = new Map<Id, Account>();            
        for(Account acc: newValues) {
            if(acc.recordtypeId == RecordTypeIdSchool && acc.total_student_count_21_22__c > 0 && 
               (isInsert || (acc.total_student_count_21_22__c != oldvaluesMap.get(acc.Id).total_student_count_21_22__c &&
                             acc.total_student_count_21_22__c > oldvaluesMap.get(acc.Id).total_student_count_21_22__c))
              ){
                  mapAccIdToStudents.put(acc.Id, acc);
              }
        }
        System.debug('mapAccIdToStudents: ' + mapAccIdToStudents);
        
        if(mapAccIdToStudents.size() > 0){
            //Get the existing batches of account if Update event is fired
            Map<Id, Integer> mapAccIdToBatchCnt = new Map<Id, Integer>();
            if(!isInsert){
                List<AggregateResult> aggrResult = [SELECT COUNT(Id), School_Name__c  
                                                    FROM Batch__c 
                                                    WHERE School_Name__c IN:mapAccIdToStudents.keySet() AND 
                                                    Date_of_facilitation_starting__c > 2021-05-01T00:00:00.000+05:30 
                                                    GROUP BY School_Name__c];
                
                if(!aggrResult.isEmpty() && aggrResult.size() > 0){
                    for(AggregateResult result : aggrResult){
                        Integer existingBatches = (Integer)result.get('expr0');
                        Id accountId = (Id)result.get('School_Name__c');
                        mapAccIdToBatchCnt.put(accountId, existingBatches);
                    }
                }
            }
            
            List<Batch__c> batchesToBeInserted = new List<Batch__c>();
            for(Id accountId : mapAccIdToStudents.keyset()){
                Integer studentCnt = (Integer)mapAccIdToStudents.get(accountId).total_student_count_21_22__c;
                Integer existingBatches = mapAccIdToBatchCnt.containsKey(accountId) ? mapAccIdToBatchCnt.get(accountId) : 0;
                Integer createBatchesCnt = 0;
                
                System.debug('AccountId: ' + accountId);
                System.debug('studentCnt: ' + studentCnt);
                System.debug('existingBatches: ' + existingBatches);
                
                if(studentCnt <= 40 && existingBatches == 0){
                    createBatchesCnt = 1;
                }else if(studentCnt > 40){
                    if(studentCnt/35 <= (Decimal)studentCnt/35){
                        createBatchesCnt = ((studentCnt/35) + 1) - existingBatches;
                    }else{
                        createBatchesCnt = (studentCnt/35)- existingBatches;
                    }
                    
                }
                
                System.debug('createBatchesCnt: ' + createBatchesCnt);
                //Create batches for current account
                for(integer i = 0 ; i < createBatchesCnt ; i++){
                    batch__c bc = new batch__c();
                    bc.Name = mapAccIdToStudents.get(accountId).Name+' '+System.Today().year(); 
                    bc.School_Name__c = accountId;
                    bc.Need_to_assign_G9__c = TRUE;
                    bc.Need_to_assign_G10__c = TRUE;
                    bc.Preferred_Language__c = mapAccIdToStudents.get(accountId).Medium_Language_of_Instruction__c;
                    bc.Date_of_facilitation_starting__c = system.today();
                    batchesToBeInserted.add(bc);
                }
            }
            
            //Insert batches
            if(batchesToBeInserted.size() > 0){
                Insert batchesToBeInserted;
            }
        }
        
    }
    
    
}