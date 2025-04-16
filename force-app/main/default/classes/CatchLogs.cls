public class CatchLogs {
     public static Log__c createLog(String type, String uid, 
                                    Integer totalRecords, Integer totalSuccess, 
                                    String summary, String message, String logBody)
    {

        return new Log__c(
            Type__c = type,
            UID__C = uid,
            Total_Records__c =totalRecords,
            Total_Success__c =totalSuccess,
            Summary__c = summary,
            Message__c = message,
            Body__c = logBody
        );
    }

}