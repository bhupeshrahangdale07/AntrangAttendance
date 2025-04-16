global class Delete_NonGraduate_CR_StudentsSchedule implements Schedulable{
    global void execute(SchedulableContext sc){
        String query = 'SELECT ID,API_Status__c,Student_Status__c FROM Contact where recordtype.name=\'CR Student\' AND API_Status__c= \'Both APIs Executed\' AND Student_Status__c !=\'Graduated\'';
        DeleteNon_Graduate_CRstudents delBatch = new DeleteNon_Graduate_CRstudents(query);
        Id BatchProcessId = Database.ExecuteBatch(delBatch);
    }
}