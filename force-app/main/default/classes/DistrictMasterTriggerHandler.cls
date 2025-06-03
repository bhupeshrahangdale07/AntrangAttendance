public class DistrictMasterTriggerHandler {
    public static void checkDistrictInSessionMapping(List<District_Master__c> lstDistrictM){
        Set<String> districts = new Set<String>();
        
        for(Session_Mapping__c setting :[Select District__c FROM Session_Mapping__c]){
            if(String.isNotBlank(setting.District__c)) districts.add(setting.District__c.toLowerCase());
            System.debug('**districts:'+districts);
        }
        
        for(District_Master__c dm : lstDistrictM){
            if(String.isNotBlank(dm.Name) && !districts.contains(dm.Name.toLowerCase())){
                dm.Name.addError('This District is not present in Session Mapping.');
            }
        }
    }
}