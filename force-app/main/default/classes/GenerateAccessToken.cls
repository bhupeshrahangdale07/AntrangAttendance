public class GenerateAccessToken {
 public static string getAccessToken(){
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
        String strBody ='';
        string strMessage = '';
        try{
            strbody += '{';
            strBody += '"api_user_name": "'+ setting.ApiUserName__c  +'",';
            strBody += '"api_user_password": "'+ setting.ApiUserPassword__c  +'"';
            strbody += '}';
            String endpoint = '';
            // Access Token Endpoint from custom setting 
            if (setting == null || string.isblank(setting.BaseApiUrl__c)) {
                strMessage = 'Access Token Endpoint is not populated. Please go to Custom Setting --> Antarang Setting --> Access Token Endpoint .';
                return strMessage;
            } else {
                endpoint = setting.BaseApiUrl__c +'apiuserlogin/validateapiuser' ;
            }
            // Callout for Access Token 
            HttpResponse response = OpportunityAPIHandler.doCallout(strBody,'POST',endpoint,'');
            if (response != null && response.getStatusCode() == 200) {
                string restBody = response.getBody();
                list <object> tokenlst = (list <object > ) JSON.deserializeUntyped(restBody);
                for(object obj : tokenlst){
                    Map < String, Object > m = (Map < String, Object > ) JSON.deserializeUntyped(json.serialize(obj));
                    if (m.containskey('authentication_token')) {
                        strMessage = string.valueof(m.get('authentication_token'));
                        system.debug(strMessage);
                        break;
                        system.debug(strMessage);
                    }
                }
                if(string.isNotBlank(strMessage)){
                    setting.AccessToken__c = strMessage;
                    upsert setting;
                }
                system.debug(strMessage);
            }else if (response != null) {
                list <object> tokenlst = (list <object > ) JSON.deserializeUntyped(response.getBody());
                for(object obj : tokenlst){
                    Map < String, Object > m = (Map < String, Object > ) JSON.deserializeUntyped(json.serialize(obj));
                    if (m.containskey('error')) {
                        strMessage = string.valueof(m.get('error'));
                        strMessage = strMessage.replace('{', '').replace('}', '');
                    }
                }
            }
        }catch (Exception ex) {
            strMessage = ex.getMessage();
        }
        return strMessage;
    }
    
   

}