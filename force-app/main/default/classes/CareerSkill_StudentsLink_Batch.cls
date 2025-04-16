/* Link Student on Career_Skill__c uploaded from CSV (OMR).
* -------------------------------------------------------------------------------------------------------------------------
* History
 * Version	Date			Description
 * v1.0     13th mar 24     added logic to populate Academic year from current batch School Academic year
*/ 

public class CareerSkill_StudentsLink_Batch Implements Database.batchable<sObject>, schedulable, Database.Stateful{
public String query;
    public Integer Total_Success_Records = 0;
    public Integer Total_Failed_Records = 0;
    public Map <String, Contact> Grade_9_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_10_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_11_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_12_Barcode_Map = New Map <String, Contact>();
    Set<String> notExpansOf16Ques = new Set<String>{'E','F','G','*'};
    
    //Start method
    public Database.QueryLocator start(Database.BatchableContext BC){
        Id RecTypeCA = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Student').getRecordTypeId();
        if(String.isBlank(query)) {
            //query = 'Select Id, Barcode__c, Student__c from Career_Skill__c where Student__c = Null AND Barcode__c != Null AND Created_from_Form__c = False';
            query = 'Select Id, Barcode__c, Student__c, Created_from_Form__c, Marks_Recalculated__c,Student_Linked__c, Q_11_Ans__c, Q_12_Ans__c,' 
                +'Q_13_Ans__c, Q_14_Ans__c, Q_15_Ans__c, Q_16_Ans__c, Q_11_1__c, Q_13__c, Q_11_2__c, Q_14__c, Q_11_3__c, Q_15_1__c, Q_11_4__c,'
                +'Q_15_2__c, Q_11_5__c, Q_15_3__c, Q_11_6__c, Q_15_4__c, Q_11_7__c, Q_15_5__c, Q_11_8__c, Q_15_6__c, Q_11_9__c, Q_15_7__c, Q_12_1__c,'
                +'Q_15_8__c, Q_12_2__c, Q_15_9__c, Q_12_3__c, Q_16__c,Q_12_4__c,Error_Status__c'
                +' from Career_Skill__c '  
            	+'where Barcode__c != Null AND (Student_Linked__c = False OR Marks_Recalculated__c = False)';
        }
        return Database.getQueryLocator(query);
    }
    
    //Execute Method
    public void execute(Database.BatchableContext BC, List<Career_Skill__c> OMRList) {        
        Set<String> Barcodes = New Set<String>();
        Id RecTypeCA = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        Map<String,String> barcodeWithBatchId = new Map<String,String>();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        
        for(Career_Skill__c obj : OMRList){
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
        
        List<Career_Skill__c> omrObjList = New List<Career_Skill__c>();
        for(Career_Skill__c omr : OMRList){            
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
                omr.Q_11_Ans__c = 0; omr.Q_12_Ans__c = 0; omr.Q_13_Ans__c = 0; omr.Q_14_Ans__c = 0; omr.Q_15_Ans__c = 0; omr.Q_16_Ans__c = 0;
                double ansOf11 = 0;
                if(String.isNotBlank(omr.Q_11_1__c) && omr.Q_11_1__c == 'A'){
                	ansOf11 = ansOf11 + 0.5;
            	}
                if(String.isNotBlank(omr.Q_11_2__c) && omr.Q_11_2__c == 'A'){
                    ansOf11 = ansOf11 + 0.5;
                }
                if(String.isNotBlank(omr.Q_11_3__c) && omr.Q_11_3__c == 'A'){
                	ansOf11 = ansOf11 + 0.5;
            	}
                if(String.isNotBlank(omr.Q_11_6__c) && omr.Q_11_6__c == 'A'){
                    ansOf11 = ansOf11 + 0.5;
                }
                if(String.isNotBlank(omr.Q_11_8__c) && omr.Q_11_8__c == 'A'){
                	ansOf11 = ansOf11 + 0.5;
            	}
                if(String.isNotBlank(omr.Q_11_9__c) && omr.Q_11_9__c == 'A'){
               		ansOf11 = ansOf11 + 0.5;
            	}                 
            	if(ansOf11 > 0){
                	omr.Q_11_Ans__c = ansOf11;
            	}
                Integer cnt = 0;
            	if(String.isNotBlank(omr.Q_12_1__c)){
                	cnt++;
            	}
                if(String.isNotBlank(omr.Q_12_2__c)){
                	cnt++;
            	}
                if(String.isNotBlank(omr.Q_12_3__c)){
                	cnt++;
            	}
                if(String.isNotBlank(omr.Q_12_4__c)){
                	cnt++;
            	}
                if(cnt <= 2) {
                    double ans12Qus = 0;
                    
                    if(String.isNotBlank(omr.Q_12_1__c) && omr.Q_12_1__c != '*'){
                        ans12Qus = ans12Qus + 0.5;
                    }
                    if(String.isNotBlank(omr.Q_12_3__c) && omr.Q_12_3__c != '*'){
                        ans12Qus = ans12Qus + 0.5;
                    }if(ans12Qus > 0){
                        omr.Q_12_Ans__c = ans12Qus;
                    }
            	}                
                if(String.isNotBlank(omr.Q_13__c) && omr.Q_13__c == 'B'){
                	omr.Q_13_Ans__c = 1;
                }            
                if(String.isNotBlank(omr.Q_14__c) && (omr.Q_14__c == 'B' || omr.Q_14__c == 'D')){
                	omr.Q_14_Ans__c = 1;
                }        
                double ansOf15 = 0;
                if(String.isNotBlank(omr.Q_15_1__c) && omr.Q_15_1__c != '1' && omr.Q_15_1__c != '*'){
                    ansOf15 = ansOf15 + 1;
                }
                if(String.isNotBlank(omr.Q_15_2__c) && omr.Q_15_2__c != '1' && omr.Q_15_2__c != '*'){
                	ansOf15 = ansOf15 + 1;
            	}
                if(String.isNotBlank(omr.Q_15_3__c) && omr.Q_15_3__c != '1' && omr.Q_15_3__c != '*'){
                	ansOf15 = ansOf15 + 1;
            	}
                if(String.isNotBlank(omr.Q_15_4__c) && omr.Q_15_4__c != '1' && omr.Q_15_4__c != '*'){
                	ansOf15 = ansOf15 + 1;
            	}
                if(String.isNotBlank(omr.Q_15_5__c) && omr.Q_15_5__c != '1' && omr.Q_15_5__c != '*'){
                	ansOf15 = ansOf15 + 1;
            	}
                if(String.isNotBlank(omr.Q_15_6__c) && omr.Q_15_6__c != '1' && omr.Q_15_6__c != '*'){
               		ansOf15 = ansOf15 + 1;
            	}
                if(String.isNotBlank(omr.Q_15_7__c) && omr.Q_15_7__c != '1' && omr.Q_15_7__c != '*'){
                	ansOf15 = ansOf15 + 1;
            	}
                if(String.isNotBlank(omr.Q_15_8__c) && omr.Q_15_8__c != '1' && omr.Q_15_8__c != '*'){
                	ansOf15 = ansOf15 + 1;
            	}
                if(String.isNotBlank(omr.Q_15_9__c) && omr.Q_15_9__c != '1' && omr.Q_15_9__c != '*'){
                	ansOf15 = ansOf15 + 1;
            	}
                if(ansOf15 > 0){
                	omr.Q_15_Ans__c = ansOf15;
            	}
                if(String.isNotBlank(omr.Q_16__c) && !notExpansOf16Ques.contains(omr.Q_16__c)){
                	omr.Q_16_Ans__c = 1;
            	} else {
                	omr.Q_16_Ans__c = 0;
            	}
                omr.Marks_Recalculated__c = True; 
            }//mark calculation 
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
        email.setSubject('Records failed for Class CareerSkill_StudentsLink_Batch');
        
        List<String> emailTo = New List<String>();
        emailTo.add(emailId);
        email.setToAddresses(emailTo);
        
        email.setPlainTextBody('Total '+ Total_Failed_Records + ' records failed for class CareerSkill_StudentsLink_Batch');
        
        emlmsg.add(email); 
        if(Total_Failed_Records > 0){
            Messaging.sendEmail(emlmsg, false);
        }  
    }
    
        //schedule class method
    public void execute(SchedulableContext sc){
        CareerSkill_StudentsLink_Batch OMRStudent = new CareerSkill_StudentsLink_Batch();
        Id bprId = Database.executeBatch(OMRStudent, 20);
    }
}