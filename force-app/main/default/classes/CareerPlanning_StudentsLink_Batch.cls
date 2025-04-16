/* Link Student on Career_Planning__c uploaded from CSV (OMR).
* -------------------------------------------------------------------------------------------------------------------------
* History
 * Version	Date			Description
 * v1.0     13th mar 24     added logic to populate Academic year from current batch School Academic year
*/ 
public class CareerPlanning_StudentsLink_Batch Implements Database.batchable<sObject>, schedulable, Database.Stateful{
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
            //query = 'Select Id, Barcode__c, Student__c from Career_Planning__c where Student__c = Null AND Barcode__c != Null AND Created_from_Form__c = False';
            query = 'Select Id, Barcode__c, Student__c, Created_from_Form__c, Marks_Recalculated__c, Student_Linked__c, Q_7__c, Q_7_Marks__c,Q_8__c, Q_8_Marks__c,'
                +'Q_9_1__c, Q_9_1_Marks__c, Q_9_2__c, Q_9_2_Marks__c, Q_9_3__c, Q_9_3_Marks__c, Q_9_4__c, Q_9_4_Marks__c, Q_9_5__c, Q_9_5_Marks__c,'
                +'Q_9_6__c, Q_9_6_Marks__c, Q_9_7__c, Q_9_7_Marks__c, Q_10__c, Q_10_Marks__c,Error_Status__c'
                +' from Career_Planning__c '
                +'where Barcode__c != Null AND (Student_Linked__c = False OR Marks_Recalculated__c = False)';        
        }
        return Database.getQueryLocator(query);
    }
    
    //Execute Method
    public void execute(Database.BatchableContext BC, List<Career_Planning__c> OMRList) {        
        Set<String> Barcodes = New Set<String>();
        Id RecTypeCA = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        Map<String,String> barcodeWithBatchId = new Map<String,String>();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        
        for(Career_Planning__c obj : OMRList){
            Barcodes.add(obj.Barcode__c);
        }
        
        List<Contact> contList = [SELECT Name, LastName, Id, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c,Current_Batch_Id__c from Contact WHERE RecordTypeId =: RecTypeCA AND (Grade_9_Barcode__c IN: Barcodes OR Grade_10_Barcode__c IN: Barcodes OR Grade_11_Barcode__c IN: Barcodes OR Grade_12_Barcode__c IN: Barcodes)];        
        for(Contact cont : contList){
            if(cont.Grade_9_Barcode__c != Null){
                Grade_9_Barcode_Map.put(cont.Grade_9_Barcode__c, cont);
            }if(cont.Grade_10_Barcode__c != Null){	//updated on 24.04.2023
                Grade_10_Barcode_Map.put(cont.Grade_10_Barcode__c, cont);
            }if(cont.Grade_11_Barcode__c != Null){	//updated on 24.04.2023
                Grade_11_Barcode_Map.put(cont.Grade_11_Barcode__c, cont);
            }if(cont.Grade_12_Barcode__c != Null){	//updated on 03.08.2023
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
        
        List<Career_Planning__c> omrObjList = New List<Career_Planning__c>();
        List<String> acceptedAnsForQue8 = new List<String>{'A','B','C','D','E','F'};
        for(Career_Planning__c omr : OMRList){
            
            if(omr.Student__c == null && omr.Student_Linked__c == False){
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
            //added on 12.04.2023
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
                omr.Q_7_Marks__c = 0; omr.Q_8_Marks__c = 0; omr.Q_10_Marks__c = 0;
                omr.Q_9_1_Marks__c = 0; omr.Q_9_2_Marks__c = 0; omr.Q_9_3_Marks__c = 0; omr.Q_9_4_Marks__c = 0; omr.Q_9_5_Marks__c = 0; omr.Q_9_6_Marks__c = 0; omr.Q_9_7_Marks__c = 0;                
                
                 if(String.isNotBlank(omr.Q_7__c) && omr.Q_7__c == 'B'){
                        omr.Q_7_Marks__c = 1;
                    }                 
                if(String.isNotBlank(omr.Q_8__c) && acceptedAnsForQue8.contains(omr.Q_8__c)){
                        omr.Q_8_Marks__c = 1;
                    } else if(String.isNotBlank(omr.Q_8__c) && omr.Q_8__c == 'K'){
                        omr.Q_8_Marks__c = 0.5;
                    }                   
                CareerPlanningTriggerHandler.calculateMarksForQ9('Q_9_', 7, omr, omr);                
                 if(String.isNotBlank(omr.Q_10__c) && omr.Q_10__c == 'B'){
                        omr.Q_10_Marks__c = 0.5;
                    } else if(String.isNotBlank(omr.Q_10__c) && (omr.Q_10__c == 'C' || omr.Q_10__c == 'D' || omr.Q_10__c == 'E')){
                        omr.Q_10_Marks__c = 1;
                    }               
                omr.Marks_Recalculated__c = True; 
            }                                   
            omrObjList.add(omr);                               
        }//for        
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
        email.setSubject('Records failed for Class CareerPlanning_StudentsLink_Batch');
        
        List<String> emailTo = New List<String>();
        emailTo.add(emailId);
        email.setToAddresses(emailTo);
        
        email.setPlainTextBody('Total '+ Total_Failed_Records + ' records failed for class CareerPlanning_StudentsLink_Batch');
        
        emlmsg.add(email); 
        if(Total_Failed_Records > 0){
            Messaging.sendEmail(emlmsg, false);
        }  
    }
    
    //schedule class method
    public void execute(SchedulableContext sc){
        CareerPlanning_StudentsLink_Batch OMRStudent = new CareerPlanning_StudentsLink_Batch();
        Id bprId = Database.executeBatch(OMRStudent, 20);
    }
}