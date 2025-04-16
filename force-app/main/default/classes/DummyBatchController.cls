public class DummyBatchController {
    @AuraEnabled
    public static String cloneRecord(Id recordId){
        Map<String, Schema.SObjectField> batchFieldMap = Batch__c.sObjectType.getDescribe().fields.getMap();
        Set<String> setBatchFieldNames = batchFieldMap.keySet();
        list<String> lstBatchFieldNames = new List<String>(setBatchFieldNames);
        
        Batch__c b = Database.query('SELECT ' + String.join(lstBatchFieldNames, ',') + ' FROM Batch__c Where Id =:recordId');
        system.debug('Batch with all feilds : '+b);
        
        Map<String, Schema.SObjectField> sessionFieldMap = Session__c.sObjectType.getDescribe().fields.getMap();
        Set<String> setSessionFieldNames = sessionFieldMap.keySet();
        list<String> lstSessionFieldNames = new List<String>(setSessionFieldNames);
        
        List<Session__c> sessionsList = Database.query('SELECT ' + String.join(lstSessionFieldNames, ',') + ' FROM Session__c Where Batch__c =:recordId AND Copy_of_Session__c = null');
        
        //Batch__c b = [Select Id,Name,Preferred_Language__c, School_Name__c, (Select FIELDS(ALL) from Sessions__r Limit 200) from Batch__c where Id =:recordId Limit 1];
        List<Batch__c> BatchUpsertList = new List<Batch__c>();
        
        // Added flexibility to create the multiple dummy batches 
        //if(!b.Dummy_Batch_Created__c && !b.Name.startsWith('DUMMY-')){
        if(!b.Dummy_Batch__c && !b.Name.startsWith('DUMMY-')){
            Batch__c clonedBatch = b.clone(false,true,false,false);
            clonedBatch.Name = 'DUMMY-'+b.Name;
            clonedBatch.Dummy_Batch_Created__c = false;
            clonedBatch.Dummy_Batch__c = true;
            clonedBatch.Copy_of_Batch__c = Integer.valueOf(b.Batch_Number__c);
            
            try{
                insert clonedBatch;
                String name = 'DUMMY-'+b.Name;
                String BatchId = clonedBatch.Id; //[select id from Batch__c where Name=:name Limit 1].Id;
                b.Dummy_Batch_Created__c = true;
                update b;
                
                List<Session__c> clonedSessions = new List<Session__c>();
                for(session__c s:sessionsList){
                    Session__c session = new Session__c();
                    session = s.clone(false,true,false,false);
                    /*
                    session.SessionDate__c = s.SessionDate__c;
                    session.Assigned_Facilitator__c = s.Assigned_Facilitator__c;
                    session.Assigned_Facilitator__c = s.Assigned_Facilitator__c;
                    session.Session_End_Time__c = s.Session_End_Time__c;
                    session.Session_Start_Time__c = s.Session_Start_Time__c;
                    session.Payment_Status__c = s.Payment_Status__c;
                    session.Log_Reason__c = s.Log_Reason__c;
                    session.Payment_Date__c = s.Payment_Date__c;
                    session.Invoice_Date__c = s.Invoice_Date__c;
                        */
                    session.Session_Grade__c = s.Session_Grade__c;
                    //system.debug('ttt : '+s.Session_Grade__c);
                    session.Copy_of_Session__c = s.Session_Code__c;
                    session.Dummy_Session__c = true;
                    session.Batch__c = BatchId;
                    
                    //session.Attendance_Count__c = 0;
                    session.Attendance_Submitted__c = false;
                    session.Log_Reason__c = '';
                    session.Total_Student_Present__c = 0;
                    session.Total_Parent_Present__c = 0;
                        
                    s.Dummy_Session_Created__c = true;
                    
                    clonedSessions.add(session);
                }
                
                if(clonedSessions.size() > 0){
                    insert clonedSessions;
                    update sessionsList;
                    return 'SUCCESS'+BatchId;
                }else{
                    return 'No Sessions to Update';
                }
                
                // return 'Cloned Batch Record and updated';
                
            }catch(Exception e){
                return e.getMessage();
            } 
            
            //system.debug('tettt : '+clonedBatch);
        }else if(b.Dummy_Batch__c && b.Name.startsWith('DUMMY-')){
            return 'This record is Dummy Batch you are not able to clone';
        }else{
            return 'This Batch is already Cloned';
        }
        
    }
    
}