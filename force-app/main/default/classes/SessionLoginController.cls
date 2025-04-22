public without sharing class SessionLoginController {

    @AuraEnabled
    public static object checkEmail(String strEmail){
        try {
            Boolean formLogin = false;
            Map<String, Object> result = new Map<String, Object>();
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults(); // updated: 23.03.2023
        
        result.put('grade', getdynamicpicklistval('Batch__c', 'Grade__c'));
        List<Contact> con = new List<Contact>();
        string labelForDomain = System.Label.Antarang_Domain;
        if((String.isNotBlank(strEmail) && strEmail.contains('@') && labelForDomain.contains(strEmail.split('@').get(1)))) {
            for (Contact objcon : [
            SELECT id, npe01__WorkEmail__c, Form_Login__c
            FROM contact
            WHERE npe01__WorkEmail__c = :strEmail AND RecordTypeId = :recordTypeId
                AND (Academic_Year__c =: antarangSett.Academic_Year__c OR Academic_Year__c =: antarangSett.Next_Academic_Year__c)
                AND Facilitator_Work_Status__c = 'Active'
                ORDER BY CreatedDate DESC
            LIMIT 1
        ]) {
            System.debug('objcon- '+objcon);
            if(objcon != null){
            formLogin = objcon.Form_Login__c;
            con.add(objcon);
            }
        }
        if(formLogin){
            system.debug('Already Logged In');
            result.put('Already Logged In', new Contact());
        } else if(con.size() > 0){
            system.debug('Contact-- '+ con[0]);
            Contact updateCon = [Select Id, Form_Login__c from Contact Where Id =: con[0].Id];
            system.debug('Contact- '+updateCon);
            updateCon.Form_Login__c = true;
            update updateCon;
            result.put('contact', con[0]);
        } else {
            result.put('error', 'No matching contact found.');
        }
        
        return result;
        }else{
            result.put('contact', new contact());
        return result;
        }
        } catch (Exception e) {
            system.debug('Error at line no- '+e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
            
        }
    }
    @AuraEnabled
    public static List<picklistwrapper> getdynamicpicklistval(String objectName,String fieldName){
        List<picklistwrapper> options = new List<picklistwrapper>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult r = s.getDescribe();
        Map<String, Schema.SObjectField> fields = r.fields.getMap();
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        options.add(new picklistwrapper('--None--', ''));
        for (Schema.PicklistEntry pickListVal : ple) {
            options.add(
                new picklistwrapper(pickListVal.getLabel(), String.valueOf(pickListVal.getValue()))
            );
        }
        return options;
    }

    public class picklistwrapper {
        @AuraEnabled
        public String label { get; set; }
        
        @AuraEnabled
        public String value { get; set; }
        
        public picklistwrapper(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}