/* Link Student on Self_Awareness_and_Feedback__c uploaded from CSV (OMR) Calculate marks after linking
* -------------------------------------------------------------------------------------------------------------------------
* History
 * Version	Date			Description
 * v1.0     14th feb 24     commented initialisation of interest 1/2/3 and aptitude 1/2/3 - this logic was nullifying actual data in many cases
 * v2.0     13th mar 24     added logic to populate Academic year from current batch School Academic year
 */ 
public class SAF_StudentsLink_Batch Implements Database.batchable<sObject>, Database.Stateful, schedulable{
    public String query;
    public Map <String, Contact> Grade_9_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_10_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_11_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_12_Barcode_Map = New Map <String, Contact>();
    public Integer Total_Success_Records = 0;
    public Integer Total_Failed_Records = 0;
    public String grade;
    Set<Id> Ids = new Set<Id>();
    
    //Start method
    public Database.QueryLocator start(Database.BatchableContext BC){
        if(String.isBlank(query)) {
            query = 'Select Id, Barcode__c, Student__c, Created_from_Form__c, Marks_Recalculated__c, Student_Linked__c,Error_Status__c,'
                +'Quiz_1_1__c, Quiz_1_1_Marks__c, Quiz_1_2__c, Quiz_1_2_Marks__c, Quiz_1_3__c, Quiz_1_3_Marks__c, Quiz_1_4__c, Quiz_1_4_Marks__c, Quiz_1_5__c, Quiz_1_5_Marks__c,'
                +'Quiz_1_6__c, Quiz_1_6_Marks__c, Quiz_1_7__c, Quiz_1_7_Marks__c, Quiz_1_8__c, Quiz_1_8_Marks__c, Quiz_1_9__c, Quiz_1_9_Marks__c, Quiz_1_10__c, Quiz_1_10_Marks__c'
                +' from Self_Awareness_and_Feedback__c '
                +'where Barcode__c != Null AND (Student_Linked__c = False OR Marks_Recalculated__c = False)';
            
        }
        return Database.getQueryLocator(query);
    }
    
    //Execute Method
    public void execute(Database.BatchableContext BC, List<Self_Awareness_and_Feedback__c> safOMRList) {
        Set<String> Barcodes = New Set<String>();
        Id RecTypeCA = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        Map<String,String> barcodeWithBatchId = new Map<String,String>();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        
        for(Self_Awareness_and_Feedback__c objSaf : safOMRList){
            Barcodes.add(objSaf.Barcode__c);
        }
        
        List<Contact> contList = [SELECT Name, LastName, Id, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c,Current_Batch_Id__c from Contact WHERE RecordTypeId =: RecTypeCA AND (Grade_9_Barcode__c IN: Barcodes OR Grade_10_Barcode__c IN: Barcodes OR Grade_11_Barcode__c IN: Barcodes OR Grade_12_Barcode__c IN: Barcodes)];
        for(Contact cont : contList){
            if(cont.Grade_9_Barcode__c != Null){
                Grade_9_Barcode_Map.put(cont.Grade_9_Barcode__c, cont);
            }if(cont.Grade_10_Barcode__c != Null){
                Grade_10_Barcode_Map.put(cont.Grade_10_Barcode__c, cont);
            }if(cont.Grade_11_Barcode__c != Null){
                Grade_11_Barcode_Map.put(cont.Grade_11_Barcode__c, cont);
            }if(cont.Grade_12_Barcode__c != Null){
                Grade_12_Barcode_Map.put(cont.Grade_12_Barcode__c, cont);
            }
            barcodeWithBatchId.put(cont.Id, cont.Current_Batch_Id__c);
        }
        If(barcodeWithBatchId.size() > 0 ){
            for(Batch__c bt : [Select Id,School_Name__c,School_Name__r.Academic_Year__c from batch__c where Id in: barcodeWithBatchId.Values()]){
                if(bt.School_Name__c != null && bt.School_Name__r.Academic_Year__c != null) 
                    currentBatchSchoolAcadYear.put(bt.Id, bt.School_Name__r.Academic_Year__c);
            }
        }
        
        List<Self_Awareness_and_Feedback__c> SAFList = New List<Self_Awareness_and_Feedback__c>();
        List<Self_Awareness_and_Feedback__c> omrAssessmentLST = new List<Self_Awareness_and_Feedback__c>();
        
        for(Self_Awareness_and_Feedback__c saf : safOMRList){ 
            if(saf.Marks_Recalculated__c == False) {
                //saf.Interest_1__c = null; saf.Interest_2__c = null; saf.Interest_3__c = null; // v1.0
               // saf.Aptitude_1__c = null; saf.Aptitude_2__c = null; saf.Aptitude_3__c = null;  // v1.0
                saf.Quiz_1_1_Marks__c = null; saf.Quiz_1_2_Marks__c = null; saf.Quiz_1_3_Marks__c = null; saf.Quiz_1_4_Marks__c = null; saf.Quiz_1_5_Marks__c = null; 
                /*saf.Quiz_1_6_Marks__c = 0; saf.Quiz_1_7_Marks__c = 0; saf.Quiz_1_8_Marks__c = 0; saf.Quiz_1_9_Marks__c = 0; saf.Quiz_1_10_Marks__c = 0;*/
            }
            //added SAF Grade on 21.06.2023
            if(Grade_9_Barcode_Map.containsKey(saf.Barcode__c)){
                grade = 'Grade 9';
                if(saf.Student__c == null && saf.Student_Linked__c == False){
                    saf.Student__c = Grade_9_Barcode_Map.get(saf.Barcode__c).Id;
                    saf.Grade__c = 'Grade 9';
                }                                        
                if(saf.Marks_Recalculated__c == False) {                    
                    SelfAwarenessandFeedbackTriggerHandler.calculateQuizMarksForm('Quiz_1_', 5, saf, saf, grade);
                	saf.Marks_Recalculated__c = True;
                }
            }Else if(Grade_10_Barcode_Map.containsKey(saf.Barcode__c)){
                grade = 'Grade 10';
                if(saf.Student__c == null && saf.Student_Linked__c == False){
                    saf.Student__c = Grade_10_Barcode_Map.get(saf.Barcode__c).Id;   
                    saf.Grade__c = 'Grade 10';
                }
                if(saf.Marks_Recalculated__c == False) {                                        
                    SelfAwarenessandFeedbackTriggerHandler.calculateQuizMarksForm('Quiz_1_', 5, saf, saf, grade);
                	saf.Marks_Recalculated__c = True;                    
                }
            }Else if(Grade_11_Barcode_Map.containsKey(saf.Barcode__c)){
                grade = 'Grade 11';
                if(saf.Student__c == null && saf.Student_Linked__c == False){
                    saf.Student__c = Grade_11_Barcode_Map.get(saf.Barcode__c).Id;
                    saf.Grade__c = 'Grade 11';
                }
                if(saf.Marks_Recalculated__c == False) {                    
                    SelfAwarenessandFeedbackTriggerHandler.calculateQuizMarksForm('Quiz_1_', 5, saf, saf, grade);
                	saf.Marks_Recalculated__c = True;
                }
            }Else if(Grade_12_Barcode_Map.containsKey(saf.Barcode__c)){
                grade = 'Grade 12';
                if(saf.Student__c == null && saf.Student_Linked__c == False){
                    saf.Student__c = Grade_12_Barcode_Map.get(saf.Barcode__c).Id;
                    saf.Grade__c = 'Grade 12';
                }
                if(saf.Marks_Recalculated__c == False) {                    
                    SelfAwarenessandFeedbackTriggerHandler.calculateQuizMarksForm('Quiz_1_', 5, saf, saf, grade);
                	saf.Marks_Recalculated__c = True;
                }
            }
            if(saf.Student__c != null){
                saf.Student_Linked__c = True;
                //added on 07.07.2023
                if(saf.Error_Status__c != null && saf.Error_Status__c == 'Student not found') {
                    saf.Error_Status__c = 'No Error';
                }
                //added on 13/03/24
                if(currentBatchSchoolAcadYear.containsKey(barcodeWithBatchId.get(saf.Student__c)))   //v2.0 added logic to populate through batch school Academic year
                saf.Academic_Year__c = currentBatchSchoolAcadYear.get(barcodeWithBatchId.get(saf.Student__c));
            }   
            omrAssessmentLST.add(saf);           
            for(Self_Awareness_and_Feedback__c s: omrAssessmentLST) {
                system.debug(s.Id);
            }
        }//for
        
        If(!omrAssessmentLST.isEmpty() && omrAssessmentLST.size() > 0){  
            
            Database.SaveResult[] result = Database.Update(omrAssessmentLST, false); 
            For(Database.SaveResult sr : result){
                If(sr.isSuccess()){
                    Ids.add(sr.getId());
                    Total_Success_Records += 1;
                }
                Else{
                    Total_Failed_Records += 1;
                }
            }
        }
    }
    
    // finish method  
    public void finish(Database.BatchableContext BC){
        if(Ids.size() > 0){            
            SelfAwarenessandFeedbackBatch selfAwar = new SelfAwarenessandFeedbackBatch(Ids);
            Database.executeBatch(selfAwar, 20);
        }
        
        String emailId = System.Label.Batch_Email_Ids;
        List<Messaging.SingleEmailMessage> emlmsg = New List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = New Messaging.SingleEmailMessage();
        email.setSubject('Records failed for Class SAF_StudentsLink_Batch');
        
        List<String> emailTo = New List<String>();
        emailTo.add(emailId);
        email.setToAddresses(emailTo);
        
        email.setPlainTextBody('Total '+ Total_Failed_Records + ' records failed for class SAF_StudentsLink_Batch');
        
        emlmsg.add(email); 
        if(Total_Failed_Records > 0){
           Messaging.sendEmail(emlmsg, false);
        }  
    }
    
    //schedule class method
    public void execute(SchedulableContext sc){
        SAF_StudentsLink_Batch OMRStudent = new SAF_StudentsLink_Batch();
        Id bprId = Database.executeBatch(OMRStudent, 20);
    }
}