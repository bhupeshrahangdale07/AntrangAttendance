public without sharing class CustomLookupController {
    
    @AuraEnabled(cacheable=true)
    public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName, String whereclause) {  
        system.debug('test : searchKey '+searchKey );
        system.debug('test : searchKey '+sObjectApiName );
        system.debug('test : searchKey '+whereclause );
        
        List < sObject > returnList = new List < sObject > ();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        Integer year = INteger.valueOf(antarangSett.Academic_Year__c);
        string sWildCardText = '%' + searchKey + '%';
        
        system.debug('sQuery : sWildCardText ----' + sWildCardText);
        
        string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText';
        if(String.isNotBlank(whereclause)){
            sQuery += ' AND ' + whereclause.replaceAll('#year#', String.valueOf(year));
        }
        sQuery += ' order by createdDate DESC LIMIT 5';
        system.debug('sQuery : ' + sQuery);
        for (sObject obj: database.query(sQuery)) {
            returnList.add(obj);
        }
        
        system.debug('sQuery : 1 ------' + returnList);
        return returnList;
    }
    
    // Method to fetch lookup default value 
    @AuraEnabled
    public static sObject fetchDefaultRecord(string recordId , string sObjectApiName, String whereclause) {
        string sRecId = recordId;    
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Id = : sRecId';
        if(String.isNotBlank(whereclause)){
        	sQuery += ' AND ' + whereclause;
        }
        sQuery += ' LIMIT 1';
        system.debug('sQuery ' + sQuery);
        for (sObject obj: database.query(sQuery)) {
            return obj;
        }
        return null;
    }

    @AuraEnabled(cacheable=true)
    public static list<sObject> fetchLookupData1(string searchKey , string sObjectApiName, String whereclause,
     String fieldNameForLabel, String fieldNameForValue, String queryfields,
      String querygroupby, String selectedDistricts) {  
        system.debug('test : searchKey '+searchKey );
        system.debug('test : searchKey '+sObjectApiName );
        system.debug('test : searchKey '+whereclause );
        
        List < sObject > returnList = new List < sObject > ();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        Integer year = INteger.valueOf(antarangSett.Academic_Year__c);
        
        
        
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
            sQuery += ' AND ' + whereclause.replaceAll('#year#', String.valueOf(year));
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