public class OMRObjectHistoricUpdate implements Database.Batchable<sObject> {
    public String objectName;
    public Map<String, SObjectField> objectFieldsMap;
    public OMRObjectHistoricUpdate(String objectName) {
        this.objectName = objectName;
        this.objectFieldsMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
    
    }
    
    public Database.QueryLocator start(Database.BatchableContext context) {
        String query = 'SELECT Id, Barcode__c, Student__c, Error_Status__c, Data_Clean_up__c, Academic_Year__c, Grade__c, Student__r.Current_Batch_Grade__c FROM ' + objectName ;
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext context, List<sObject> scope) {
        List<sObject> recordsToUpdate = new List<sObject>();
        
        for (sObject obj : scope) {
           // String currentBatchGrade = null;
            
            if (String.isNotBlank((String)obj.get('Barcode__c')) )  {
                
                if(((String)obj.get('Barcode__c')).isNumeric() && ((String)obj.get('Barcode__c')).length() == 9){
                    String barcodePrefix = ((String)obj.get('Barcode__c')).substring(0, 2);
                    
                    if (barcodePrefix == '22') {
                        obj.put('Academic_Year__c', 2022);
                    } else if (barcodePrefix == '23') {
                        obj.put('Academic_Year__c', 2023);
                    }
                    
                    if (obj.get('Student__c') != null ) {
                        String currentBatchGrade = (String)obj.getSobject('Student__r').get('Current_Batch_Grade__c');
                        obj.put('Grade__c', currentBatchGrade);
                        system.debug('Grade__c:: ' + currentBatchGrade);
                    }
                }
                else if (!((String)obj.get('Barcode__c')).isNumeric() || ((String)obj.get('Barcode__c')).length() != 9) {
                    obj.put('Student__c', null);
                    obj.put('Error_Status__c', 'Incorrect Barcode');
                    obj.put('Data_Clean_up__c', true);
                }
            } 
            else if (String.isBlank((String)obj.get('Barcode__c'))) {
                obj.put('Student__c', null);
                obj.put('Error_Status__c', 'Blank Barcode');
                obj.put('Data_Clean_up__c', true);
            } 
            
            
            
            recordsToUpdate.add(obj);
        }
        system.debug('recordsToUpdate size:: '+recordsToUpdate.size());
        update recordsToUpdate;
    }
    
    public void finish(Database.BatchableContext context) {
        // Perform any post-processing logic
    }
}