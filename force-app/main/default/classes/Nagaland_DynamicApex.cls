public class Nagaland_DynamicApex {

    @AuraEnabled(cacheable=true)
    public static list<String> fetchAllFields(String sObjectApiName){
        Map<String, Schema.SObjectType> sObjectSchema = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> sobjectFields = sObjectSchema.get(sObjectApiName).getDescribe().fields.getMap();
        list<String> lstFieldNames = new List<String>();
        for(Schema.SObjectField field : sobjectFields.Values()){
            lstFieldNames.add(field.getDescribe().getLabel());
        }
        return lstFieldNames;
    }

    @AuraEnabled
    public static String fetchOptedQnAns(String sObjectApiName , List<String> fieldsToFetch,String whereClause){
        String query = 'SELECT '+String.join(fieldsToFetch,',')+' FROM '+sObjectApiName+' '+whereClause+' LIMIT 1';
        System.debug('###Query : '+query);
        Sobject fetchedRecord = Database.query(query);
        return JSON.serialize(fetchedRecord);

        //Omit:
        // try{
        //     Sobject fetchedRecord = Database.query(query);
        //     return JSON.serialize(fetchedRecord);
        // }catch(QueryException e){
        //     // return '{"error" : {"type":'+e.getTypeName()+',cause:'+e.getCause()+',"message":'+e.getMessage()+'}}';
        //     System.debug('### Error : '+error.getMessage());
        //     return '';
        // }
    }
}