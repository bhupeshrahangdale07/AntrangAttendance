public Without Sharing class FacilitatorPaymentLoginFormController {
     
    @AuraEnabled
    public static Map<String, Object> checkEmailExist(String stremail, String strPassword) {
        Map<String, Object> result = new Map<String, Object>();
        result.put('isValid', false);
        result.put('error', 'Invalid UserName');
        /*
         Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        Contact c = new Contact();
        */                                      
        
        //AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        
        //if((String.isNotBlank(stremail) && stremail.contains('@') && stremail.split('@').get(1) == 'antarangfoundation.org') 
         //  || (stremail == 'farheenshaikh@antarangfoundation.org' || stremail.split('@').get(1) == 'kandisatech.com' )) {
          
               for(District_Master__c objDistrict : [SELECT Id,
                                                     Payout_Admin_Username__c,
                                                     Payout_Admin_Password__c,
                                                     Payout_Supervisor_Username__c,
                                                     Payout_Supervisor_Password__c
                                                     FROM District_Master__c
                                                     WHERE (Payout_Admin_Username__c =: stremail OR Payout_Supervisor_Username__c =: stremail) ])
               {
                   
                   
                   if(objDistrict.Payout_Admin_Username__c == stremail && objDistrict.Payout_Admin_Password__c != '' && objDistrict.Payout_Admin_Password__c.equals(strPassword) ){
                       result.put('UserType', 'Admin');
                       result.put('isValid', true);
                       result.put('error', '');
                   }else if(objDistrict.Payout_Admin_Username__c == stremail){
                       result.put('error', 'Invalid Password');
                   }
                   
                   if(objDistrict.Payout_Supervisor_Username__c == stremail && objDistrict.Payout_Supervisor_Password__c != '' && objDistrict.Payout_Supervisor_Password__c.equals(strPassword) ){
                       result.put('UserType', 'Supervisor');
                       result.put('isValid', true);
                       result.put('error', '');
                   }else if(objDistrict.Payout_Supervisor_Username__c == stremail){
                       system.debug('test');
                       result.put('error', 'Invalid Password');
                       result.put('ttt1', objDistrict.Payout_Supervisor_Username__c == stremail);
                   }
                   
               }
               
               if( result.containsKey('isValid') && result.get('isValid') == false && result.containsKey('error') && result.get('error') == 'Invalid UserName' ){
                   result.put('ttt', 'Invalid Password');
                   if(Label.Finance_Login_Username == stremail && Label.Finance_Login_Password != '' && Label.Finance_Login_Password.equals(strPassword) ){
                       result.put('UserType', 'Finance');
                       result.put('isValid', true);
                       result.put('error', '');
                   }else if(Label.Finance_Login_Username == stremail){
                       result.put('error', 'Invalid Password');
                   }
               }
               
               /* for (Contact objcon : [
SELECT id, npe01__WorkEmail__c
FROM contact
WHERE npe01__WorkEmail__c = :stremail AND RecordTypeId = :recordTypeId
AND Academic_Year__c =: antarangSett.Next_Academic_Year__c
AND Facilitator_Work_Status__c = 'Active'
ORDER BY CreatedDate DESC
LIMIT 1
]) {
c = objcon;
}

result.put('contact', c);
return result;*/
               //return 'success';
               
           //}
        
        return result;
        
    }
}