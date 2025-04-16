public without sharing class GenericLookupController {
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