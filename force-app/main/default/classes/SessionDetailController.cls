public class SessionDetailController {

    @AuraEnabled
    public static Object checkEmailExist(String stremail) {
        Map<String, Set<String>> schoolSessionMap = new Map<String, Set<String>>();
        try{
            if(!String.isEmpty(strEmail)){
                List<Session__c> sessions = [
                SELECT 
                    Id, 
                    Batch__r.School_Name__r.Name, 
                    Batch__r.Grade__c, 
                    Batch__r.Batch_Number__c 
                FROM 
                    Session__c 
                WHERE 
                    SessionDate__c = NULL
                    AND Assigned_Facilitator__c = :stremail
                    AND Attendance_Count__c = 0
                    AND Batch__r.Academic_Year__c IN (2024, 2025) order by Batch__r.School_Name__r.Name	
            ];
            
            
            
            for (Session__c session : sessions) {
                String schoolName = session.Batch__r.School_Name__r.Name;
                String mergedValue = session.Batch__r.Grade__c + ' - ' + session.Batch__r.Batch_Number__c;
            
                if (!schoolSessionMap.containsKey(schoolName)) {
                    schoolSessionMap.put(schoolName, new Set<String>());
                }
            
                schoolSessionMap.get(schoolName).add(mergedValue);
            }
            }
        }catch(exception e){
            
        }
        return schoolSessionMap;
    }
}