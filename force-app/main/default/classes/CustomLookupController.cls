public class CustomLookupController {
    
    @AuraEnabled(cacheable=true)
    public static list<sObject> fetchLookupData(string searchKey , string sObjectApiName, String whereclause) {    
        List < sObject > returnList = new List < sObject > ();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        Integer year = INteger.valueOf(antarangSett.Academic_Year__c);
        string sWildCardText = '%' + searchKey + '%';
        string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText';
        if(String.isNotBlank(whereclause)){
            sQuery += ' AND ' + whereclause.replaceAll('#year#', String.valueOf(year));
        }
        sQuery += ' order by createdDate DESC LIMIT 5';
        system.debug('sQuery : ' + sQuery);
        for (sObject obj: database.query(sQuery)) {
            returnList.add(obj);
        }
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
}