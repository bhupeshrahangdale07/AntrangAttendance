public class FetchAllData {
            // get all student data which have all csv files are imported and IARP calculation not processed
   public List<sObject> getAllData(String name){
            integer count=0;
            SObjectType t  = Schema.getGlobalDescribe().get(name);
            Map<String,Schema.SObjectField> fieldMap = t.getDescribe().fields.getMap();
            String field = '';
            for (String fieldName : fieldMap.keySet()){
            field += ''+fieldName+', ';
            }
            count=field.lastIndexOf(',');
            field=field.substring(0, count);
            
            Integer recordLimit = 10;
            if(System.Label.IARP_Batch_Limit != null) {
                recordLimit = Integer.valueof(System.Label.IARP_Batch_Limit);
            }
            
            String soqlQuery = 'select '+field+' from '+name + ' where Import_Status__c =\'' + 'Import Completed'+'\'' + ' and Status__c=\''+'Not Processed'+'\''+' order by Bar_Code__c limit :recordLimit ';
            List<sObject> con = Database.query(soqlQuery);
            return con;
   }
}