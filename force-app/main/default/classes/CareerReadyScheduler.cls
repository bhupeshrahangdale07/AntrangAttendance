global class CareerReadyScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        // awesome code here
        IARPRecommendation CRStudent = new IARPRecommendation();
        CRStudent.strQuery = 'select Name,Bar_Code__c,Batch_Code__c,Profession_1__c,Profession_2__c,Aptitude_1__c,Aptitude_2__c,';
        CRStudent.strQuery += 'Interest_1__c,Interest_2__c,Aspiration_1__c,Aspiration_2__c,Aspiration_3__c,Reality_1__c,Reality_2__c,Reality_3__c,';
        CRStudent.strQuery += 'Reality_4__C,Reality_5__C,Reality_6__C,Reality_7__C,Reality_8__c,Personality_1__c,Personality_2__c,Personality_3__c,';
        CRStudent.strQuery += 'Personality_4__c,Personality_5__c,Personality_6__c,Personality_7__c,Personality_8__c,Profession_1_Recommendation__c,';
        CRStudent.strQuery += 'Profession_2_Recommendation__c,Status__c from Contact where Status__c=\'Processed\' AND ';
        CRStudent.strQuery += 'Contact.RecordType.Name=\'CR Student\' AND Recommedation_Status__c=\'Not Processed\' ';
        CRStudent.strQuery += 'ORDER BY Bar_Code__c';
        
        
        Database.executeBatch(CRStudent,1);
         
    }
}