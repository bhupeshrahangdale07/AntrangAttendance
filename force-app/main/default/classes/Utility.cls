/*
    Description: Utility class is created for common functions
*/
public without sharing class Utility {
    
    public static map<string, List<Question_Bank__c>> getAllCategorywiseQuestions(){
        map<string, List<Question_Bank__c>> mapQuestionBanks = new map<string, List<Question_Bank__c>>();
        
        for(Question_Bank__c qb: [select Category__c,Name,Category1__c from Question_Bank__c order by Category1__c, Name]){
            if(mapQuestionBanks.containskey(qb.Category1__c)){
                mapQuestionBanks.get(qb.Category1__c).add(qb);
            } else {
                mapQuestionBanks.put(qb.Category1__c, new List<Question_Bank__c>{qb});
            }
        }
        return mapQuestionBanks;
    }
}