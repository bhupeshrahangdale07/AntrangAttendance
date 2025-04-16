/*
 * Classname: OMRObjectsDuplicateAssesmentBatch
 * Description : Dynamic batch class to query duplicate records and mark them as duplicate
 * -------------------------------------------------------------------------------------------------------------------------
 * History
 * 	Date			Description
 * 	20th Oct 23 	Updated logic to considered only records with Error Status as 'No Error' or blank
 */ 
global class OMRObjectsDuplicateAssesmentBatch implements Database.Batchable<SObject> {
    public String objectName;
    
    public OMRObjectsDuplicateAssesmentBatch(String objectName) {
        this.objectName = objectName;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // Query to retrieve all records where "Data Clean up" is false
        String query = 'SELECT Id, Unique_Key__c, Error_Status__c, Data_Clean_up__c, CreatedDate ' +
            'FROM ' + objectName +
            ' WHERE Data_Clean_up__c = false';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
        Map<String, List<SObject>> mapObjectsWithKey = new Map<String, List<SObject>>();
        Set<string> uniqueKeys = new Set<string>();
        
        for (SObject obj : scope) {
            uniqueKeys.add((string) obj.get('Unique_Key__c'));
        }
        
        String dynamicQuery = 'SELECT Id, Unique_Key__c, Error_Status__c, Data_Clean_up__c, CreatedDate FROM ' + objectName +
            ' WHERE Unique_Key__c IN :uniqueKeys ORDER BY CreatedDate DESC';
        List<SObject> queriedObjects = Database.query(dynamicQuery);
        
        for (SObject obj : queriedObjects) {
            String uniqueKey = (String) obj.get('Unique_Key__c');
            if (!mapObjectsWithKey.containsKey(uniqueKey)) {
                mapObjectsWithKey.put(uniqueKey, new List<SObject>());
            } 
            mapObjectsWithKey.get(uniqueKey).add(obj);
        }
        
        List<SObject> recordsToUpdate = new List<SObject>();
        for (String key : mapObjectsWithKey.keySet()) {
            List<SObject> objList = mapObjectsWithKey.get(key);
            for (Integer i = 0; i < objList.size(); i++) {
                SObject ob = objList[i];
                string ErrorStatus = (string)ob.get('Error_Status__c');
                boolean dataCleanUp= (boolean)ob.get('Data_Clean_up__c');
                // SObject ob = new SObject();
                if(i == 0){
                    
                    if(ErrorStatus != 'No Error' || !dataCleanUp){
                        ob.put('Error_Status__c','No Error');
                        ob.put('Data_Clean_up__c', true);
                        recordsToUpdate.add(ob);
                    }
                    
                }else if(ErrorStatus == 'No Error' || string.isEmpty(ErrorStatus) || string.isBlank(ErrorStatus)){
                    
                    if(ErrorStatus != 'Duplicate Entry' || !dataCleanUp){
                        ob.put('Error_Status__c', 'Duplicate Entry');
                        ob.put('Data_Clean_up__c', true);
                        
                        recordsToUpdate.add(ob);
                    }  
                }
                
            }
        }
        
        if (recordsToUpdate.size() > 0) {
            update recordsToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        // Perform any post-processing tasks
    }
}