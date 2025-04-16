public without sharing class OmrLoginFormController {
    @AuraEnabled 
    public static Map<String, object> omrSubmitterLoginCheck(String Email, String Password) {
        Map<String, object> response = new Map<String, object>{'isValid' => false, 'error' => 'Invalid UserName', 'data' => null};
        Set<String> distList = new Set<String>();
        List<District_Master__c> objDistricttList = new List<District_Master__c>( [SELECT Id, Name, OMR_Submitter_Username__c, OMR_Submitter_Password__c
                                                                                   FROM District_Master__c WHERE OMR_Submitter_Username__c =: Email ]);
        if(objDistricttList.size() > 0){
            response.put('isValid', false);
            response.put('error', 'Invalid Password');
        } 
        for(District_Master__c objDistrict : objDistricttList){
            if(objDistrict.OMR_Submitter_Username__c.equalsIgnoreCase(Email) && objDistrict.OMR_Submitter_Password__c.equals(Password)){
                distList.add(objDistrict.Name);
            }
        } 
        if(distList.size() > 0){
            response.put('isValid', true);
            response.put('error', '');
            response.put('data', distList);
        }
        return response;
    }
}