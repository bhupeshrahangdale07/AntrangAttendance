/* Link Student on CDM2__c uploaded from CSV (OMR).
* -------------------------------------------------------------------------------------------------------------------------
* History
 * Version	Date			Description
 * v1.0     13th mar 24     added logic to populate Academic year from current batch School Academic year
*/ 
public class CDM2_StudentsLink_Batch Implements Database.batchable<sObject>, schedulable, Database.Stateful {
    public String query;
    public Integer Total_Success_Records = 0;
    public Integer Total_Failed_Records = 0;
    public Map <String, Contact> Grade_9_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_10_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_11_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_12_Barcode_Map = New Map <String, Contact>();
    
    //Start method
    public Database.QueryLocator start(Database.BatchableContext BC){
        Id RecTypeCA = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Student').getRecordTypeId();
        if(String.isBlank(query)) {
            //query = 'Select Id, Barcode__c, Student__c from CDM2__c where Student__c = Null AND Barcode__c != Null AND Created_from_Form__c = False';
            query = 'Select Id, Barcode__c, Student__c, Created_from_Form__c, Marks_Recalculated__c,Student_Linked__c,Error_Status__c,'
                +'Q5__c, X5_Confident_about_chosen_career__c, Q6_1__c, Q6_1_Marks__c, Q6_2__c, Q6_2_Marks__c, Q6_3__c, Q6_3_Marks__c,'
                +'Q6_4__c, Q6_4_Marks__c, Q6_5__c, Q6_5_Marks__c, Q6_6__c, Q6_6_Marks__c, Q6_7__c, Q6_7_Marks__c, Q6_8__c, Q6_8_Marks__c,'
                +'Q6_9__c, Q6_9_Marks__c, Q6_10__c, Q6_10_Marks__c, Q6_11__c, Q6_11_Marks__c, Q6_12__c, Q6_12_Marks__c, X6_Options_that_fit_into_Industry__c'
                +' from CDM2__c '
                + 'where Barcode__c != Null AND (Student_Linked__c = False OR Marks_Recalculated__c = False)';//updated on 07.04.2023             
        }
        return Database.getQueryLocator(query);
    }
    
        //Execute Method
    public void execute(Database.BatchableContext BC, List<CDM2__c> OMRList) {        
        Set<String> Barcodes = New Set<String>();
        Id RecTypeCA = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        Map<String,String> barcodeWithBatchId = new Map<String,String>();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        
        for(CDM2__c obj : OMRList){
            Barcodes.add(obj.Barcode__c);
        }
        
        List<Contact> contList = [SELECT Name, LastName, Id, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c ,Grade_12_Barcode__c,Current_Batch_Id__c from Contact WHERE RecordTypeId =: RecTypeCA AND (Grade_9_Barcode__c IN: Barcodes OR Grade_10_Barcode__c IN: Barcodes OR Grade_11_Barcode__c IN: Barcodes OR Grade_12_Barcode__c IN: Barcodes)];        
        for(Contact cont : contList){
            if(cont.Grade_9_Barcode__c != Null){
                Grade_9_Barcode_Map.put(cont.Grade_9_Barcode__c, cont);
            }if(cont.Grade_10_Barcode__c != Null){	//updated on 24.04.2023
                Grade_10_Barcode_Map.put(cont.Grade_10_Barcode__c, cont);
            }if(cont.Grade_11_Barcode__c != Null){	//updated on 24.04.2023
                Grade_11_Barcode_Map.put(cont.Grade_11_Barcode__c, cont);
            }if(cont.Grade_12_Barcode__c != Null){	//updated on 24.04.2023
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
        
        List<CDM2__c> omrObjList = New List<CDM2__c>();
        for(CDM2__c omr : OMRList){                                   
             if(omr.Student__c == null && omr.Student_Linked__c == False){	//updated on 10.04.2023 ---- link student if Student is null                 
                //added Grade on 21.06.2023
                 if(Grade_9_Barcode_Map.containsKey(omr.Barcode__c)){
                    omr.Student__c = Grade_9_Barcode_Map.get(omr.Barcode__c).Id;
                    omr.Grade__c = 'Grade 9';               
                }Else if(Grade_10_Barcode_Map.containsKey(omr.Barcode__c)){
                    omr.Student__c = Grade_10_Barcode_Map.get(omr.Barcode__c).Id;
                    omr.Grade__c = 'Grade 10';
                }Else if(Grade_11_Barcode_Map.containsKey(omr.Barcode__c)){
                    omr.Student__c = Grade_11_Barcode_Map.get(omr.Barcode__c).Id;
                    omr.Grade__c = 'Grade 11'; 
                }Else if(Grade_12_Barcode_Map.containsKey(omr.Barcode__c)){
                    omr.Student__c = Grade_12_Barcode_Map.get(omr.Barcode__c).Id;
                    omr.Grade__c = 'Grade 12'; 
                }                
            }            
            //added on 10.04.2023
            if(omr.Student__c != null){
                omr.Student_Linked__c = True;
                //added on 07.07.2023
                if(omr.Error_Status__c != null && omr.Error_Status__c == 'Student not found') {
                    omr.Error_Status__c = 'No Error';
                }
                //added on 13/03/24
                if(currentBatchSchoolAcadYear.containsKey(barcodeWithBatchId.get(omr.Student__c)))   //v1.0 added logic to populate through batch school Academic year
                omr.Academic_Year__c = currentBatchSchoolAcadYear.get(barcodeWithBatchId.get(omr.Student__c));
            }        
        	//marks calculation       		
            if(omr.Marks_Recalculated__c == False) { 
                if(String.isNotBlank(omr.Q5__c) && (omr.Q5__c == 'A' || omr.Q5__c == 'B' || omr.Q5__c == 'C')){
                    omr.X5_Confident_about_chosen_career__c = 1;
                } else {
                    omr.X5_Confident_about_chosen_career__c = 0;
                }                
                cdm2TriggerHandler.calculateMarksForm('Q6_', 'X6_Options_that_fit_into_Industry__c', 12, omr, omr);
                omr.Marks_Recalculated__c = True; 
            }                                   
            omrObjList.add(omr);                       
        }        
       
        if(!omrObjList.isEmpty() && omrObjList.size() > 0){
            Database.SaveResult[] result = Database.Update(omrObjList, false); 
            For(Database.SaveResult sr : result){
                If(sr.isSuccess()){
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
        String emailId = System.Label.Batch_Email_Ids;
        List<Messaging.SingleEmailMessage> emlmsg = New List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = New Messaging.SingleEmailMessage();
        email.setSubject('Records failed for Class CDM2_StudentsLink_Batch');
        
        List<String> emailTo = New List<String>();
        emailTo.add(emailId);
        email.setToAddresses(emailTo);
        
        email.setPlainTextBody('Total '+ Total_Failed_Records + ' records failed for class CDM2_StudentsLink_Batch');
        
        emlmsg.add(email); 
        if(Total_Failed_Records > 0){
            Messaging.sendEmail(emlmsg, false);
        }  
    }
    
        //schedule class method
    public void execute(SchedulableContext sc){
        CDM2_StudentsLink_Batch OMRStudent = new CDM2_StudentsLink_Batch();
        Id bprId = Database.executeBatch(OMRStudent, 20);
    }
}