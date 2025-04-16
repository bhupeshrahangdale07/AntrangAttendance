public without sharing class OmrSubmissionController {
    
    @AuraEnabled
    public static List<Map<String,String>> fetchBatchRecords(String grade, String school, String facilitator ){
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        List<Map<String,String>> response = new List<Map<String,String>>();
        for(Batch__c b: [Select Id, Name From Batch__c Where Grade__c = :grade AND Trainer_Name__c = :facilitator AND School_Name__c =:school AND Academic_Year__c = :antarangSett.Academic_Year__c ]){
            response.add( new Map<String,String>{ 'label' => b.Name, 'value' => b.Id });
        }
        return response;
    }
    
    @AuraEnabled
    public static List<Map<String, String>> fetchOmrReceivedByOptions(String batchId ){
        Batch__c bt = [Select Id, School_Name__r.District__r.OMR_Received_By__c from Batch__c where Id = :batchId];
        String s = bt.School_Name__r?.District__r?.OMR_Received_By__c;
        
        List<Map<String, String>> options = new List<Map<String, String>>();
        Map<String, String> singleOption = new Map<String, String>();
        singleOption.put('label', 'Select OMR Recieved By');
        singleOption.put('value', '');
        options.add(singleOption);
        
        if(String.isNotBlank(s)){
            for(String opt : s.split(';')){
                Map<String, String> singleOption1 = new Map<String, String>();
                singleOption1.put('label', opt);
                singleOption1.put('value', opt);
                options.add(singleOption1);
            }
        }
        
        return options;
    }
    
    @AuraEnabled
    public static Map<String, Object> fetchOmrRecords(String batchId ){
        Map<String, Object> Response =  new Map<String, Object>();
        
        //// Session__r.Batch__r.OMR_Submission_Notes__c Replaced thi sfield from below query with OMR_Submission_Notes__c new field created in Session_OMR_Type__c.
        List<Session_OMR_Type__c> omrRecords = new List<Session_OMR_Type__c>([select id, Name, OMR_Submission_Notes__c, OMR_Type__c, OMRs_Received_Count__c, OMR_Received_By__c, OMR_Received_Date__c, 
                                            Session__r.Name, Session__r.Batch__r.Batch_Number__c from Session_OMR_Type__c
                                            where Session__r.OMR_required__c = true AND Session__c != null And Session__r.Batch__c = :batchId order by Session__r.Session_Number__c  ]);
        Response.put('OmrRecords', omrRecords );
        Response.put('omrReceivedByOptions', fetchOmrReceivedByOptions(batchId) );
        return Response;
    }
    
    @AuraEnabled
    public static void saveRecords(List<Session_OMR_Type__c> records){   
    /* Commented Below code as we are going to store omrSubmissionNotes in Session_OMR_Type__c Record.
    @AuraEnabled
    public static void saveRecords(List<Session_OMR_Type__c> records, String batchId, String omrSubmissionNotes){  
        system.debug('batchId'+batchId);
        system.debug('omrSubmissionNotes'+omrSubmissionNotes);
        if(String.isNotBlank(batchId)){
            Batch__c batch = new Batch__c();
            batch.Id = batchId;
            batch.OMR_Submission_Notes__c = String.isNotBlank(omrSubmissionNotes) ? omrSubmissionNotes : '';
            try{
                system.debug('batch'+batch);
                update batch;
            }catch(Exception e){
                system.debug('failed batch'+batch);
                throw new AuraHandledException('Batch Update Failed '+e.getMessage());
            }
        }
    */
        
        if(records.size() > 0){
            try{
                update records;
            }catch(Exception e){
                throw new AuraHandledException('OMR Type Update Failed '+e.getMessage());
            }
        }        
    }
    
    @AuraEnabled(cacheable=true)
    public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName, String whereclause, String fieldNameForLabel, String fieldNameForValue, String queryfields, String querygroupby, String selectedDistricts) {  
       
        List < sObject > returnList = new List < sObject > ();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        Integer year = INteger.valueOf(antarangSett.Academic_Year__c);
        Integer nextYear = INteger.valueOf(antarangSett.Next_Academic_Year__c);
        
        String fields = String.isNotBlank(queryfields) ? queryfields: ' Id, Name ';
        String groupBy = String.isNotBlank(querygroupby) ? querygroupby: '';
        
        string sQuery = 'Select '+fields+' From ' + sObjectApiName + ' Where CreatedDate != null ';
        string sWildCardText = '%' + searchKey + '%';
        if( String.isNotBlank(searchKey) ){
            if( String.isNotBlank(fieldNameForLabel) ){
                sQuery += ' AND '+fieldNameForLabel+ ' Like : sWildCardText';
            }else{
                sQuery +=  ' AND Name Like : sWildCardText';
            }
        }
        
        List<String> districts = new List<String>();
        system.debug('selectedDistricts '+selectedDistricts);
        if(String.isNotBlank(selectedDistricts)){
            system.debug('selectedDistricts '+selectedDistricts);
            
            districts = selectedDistricts.split(',');
            system.debug('districts '+districts);
            if(districts.size() > 0){
                sQuery += ' AND School_District__c IN : districts';
            }
        }
        
        if(String.isNotBlank(whereclause)){
            whereclause = whereclause.replaceAll('#year#', String.valueOf(year));
            whereclause = whereclause.replaceAll('#newYear#', String.valueOf(nextYear));
            sQuery += ' AND ' + whereclause;
        }
        
        sQuery += QueryGroupBy;
        sQuery += QueryGroupBy != '' ? ' LIMIT 5 ' : ' order by createdDate DESC LIMIT 5';
        system.debug('sQuery : ' + sQuery);
        for (sObject obj: database.query(sQuery)) {
            returnList.add(obj);
        }
        return returnList;
    }
}