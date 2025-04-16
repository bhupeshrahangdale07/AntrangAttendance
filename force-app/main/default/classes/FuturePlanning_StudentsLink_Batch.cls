/* Link Student on Future_Planning__c uploaded from CSV (OMR).
* -------------------------------------------------------------------------------------------------------------------------
* History
 * Version	Date			Description
 * v1.0     13th mar 24     added logic to populate Academic year from current batch School Academic year
*/ 
public class FuturePlanning_StudentsLink_Batch Implements Database.batchable<sObject>, schedulable, Database.Stateful{
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
            //query = 'Select Id, Barcode__c, Student__c from Future_Planning__c where Student__c = Null AND Barcode__c != Null AND Created_from_Form__c = False';            
        	query = 'Select Id, Barcode__c, Student__c, Created_from_Form__c, Marks_Recalculated__c, Student_Linked__c,Error_Status__c,'
                    +'Q_17__c, Q_17_Ans__c, Q_18_1__c, Q_18_2__c, Q_18_3__c, Q_18_4__c, Q_18_5__c, Q_18_6__c, Q_18_7__c, Q_18_8__c, Q_18_9__c,'
                	+'Q_18_10__c, Q_18_11__c, Q_18_Ans__c, Q_19__c, Q_19_Ans__c, Q_20__c, Q_20_Ans__c, Q_21__c, Q_21_Ans__c, Q_22__c, Q_22_Ans__c'
                	+' from Future_Planning__c '
            		+'where Barcode__c != Null AND (Student_Linked__c = False OR Marks_Recalculated__c = False)';//updated on 13.04.2023
        }
        return Database.getQueryLocator(query);
    }
    
    //Execute Method
    public void execute(Database.BatchableContext BC, List<Future_Planning__c> OMRList) {
        system.debug('Future_Planning__c>>'+ OMRList.size());
        Set<String> ansOf17Ques = new Set<String>{'A','B','C','D','E','F','G','H'};
        Set<String> ansOf19Ques = new Set<String>{'C','D'};
        Set<String> ansOf21Ques = new Set<String>{'F','G','H'};
        Set<String> Barcodes = New Set<String>();
        Id RecTypeCA = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        Map<String,String> barcodeWithBatchId = new Map<String,String>();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        
        for(Future_Planning__c obj : OMRList){
            Barcodes.add(obj.Barcode__c);
        }
        
        List<Contact> contList = [SELECT Name, LastName, Id, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c,Current_Batch_Id__c from Contact WHERE RecordTypeId =: RecTypeCA AND (Grade_9_Barcode__c IN: Barcodes OR Grade_10_Barcode__c IN: Barcodes OR Grade_11_Barcode__c IN: Barcodes OR Grade_12_Barcode__c IN: Barcodes)];
        system.debug('Contact List>>'+ contList.size());
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
        
        List<Future_Planning__c> omrObjList = New List<Future_Planning__c>();
        
        for(Future_Planning__c omr : OMRList){
            if(omr.Student__c == null && omr.Student_Linked__c == False){		//---- link student if Student is null
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
            if(omr.Marks_Recalculated__c == False){ 
                omr.Q_17_Ans__c = 0; omr.Q_18_Ans__c = 0;  omr.Q_19_Ans__c = 0;
               	omr.Q_20_Ans__c = 0; omr.Q_21_Ans__c = 0; omr.Q_22_Ans__c = 0;
                
                if(String.isNotBlank(omr.Q_17__c) && ansOf17Ques.contains(omr.Q_17__c)){
                	omr.Q_17_Ans__c = 1;            	 
                }
                
                double ans18Qus = 0;
                if(String.isNotBlank(omr.Q_18_1__c) && omr.Q_18_1__c == 'A'){
                    ans18Qus = ans18Qus + 0.5;
                }
                if(String.isNotBlank(omr.Q_18_2__c) && omr.Q_18_2__c == 'A'){
                    ans18Qus = ans18Qus + 0.5;
                }
                if(String.isNotBlank(omr.Q_18_4__c) && omr.Q_18_4__c == 'A'){
                    ans18Qus = ans18Qus + 0.5;
                }
                if(String.isNotBlank(omr.Q_18_6__c) && omr.Q_18_6__c == 'A'){
                    ans18Qus = ans18Qus + 0.5;
                }
                if(String.isNotBlank(omr.Q_18_8__c) && omr.Q_18_8__c == 'A'){
                    ans18Qus = ans18Qus + 0.5;
                }
                if(String.isNotBlank(omr.Q_18_10__c) && omr.Q_18_10__c == 'A'){
                    ans18Qus = ans18Qus + 0.5;
                }
                if(String.isNotBlank(omr.Q_18_11__c) && omr.Q_18_11__c == 'A'){
                    ans18Qus = ans18Qus + 0.5;
                }
                if(ans18Qus > 0){
                    omr.Q_18_Ans__c = ans18Qus;
                }
                
                if(String.isNotBlank(omr.Q_19__c) && ansOf19Ques.contains(omr.Q_19__c)){
                	omr.Q_19_Ans__c = 1;
            	} else if(String.isNotBlank(omr.Q_19__c) && omr.Q_19__c == 'E'){
                	omr.Q_19_Ans__c = 0.5;
            	}
                
                if(String.isNotBlank(omr.Q_20__c) && (omr.Q_20__c == 'D' || omr.Q_20__c == 'E')){
                	omr.Q_20_Ans__c = 1;
            	}
                
                if(String.isNotBlank(omr.Q_21__c) && !ansOf21Ques.contains(omr.Q_21__c) && omr.Q_21__c != 'I' && omr.Q_21__c != '*'){
                	omr.Q_21_Ans__c = 1;
            	} else if(omr.Q_21__c == 'I') {
                	omr.Q_21_Ans__c = 0.5;
            	}
                
                if(String.isNotBlank(omr.Q_22__c) && omr.Q_22__c == 'A'){
                	omr.Q_22_Ans__c = 1;
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
        email.setSubject('Records failed for Class FuturePlanning_StudentsLink_Batch');
        
        List<String> emailTo = New List<String>();
        emailTo.add(emailId);
        email.setToAddresses(emailTo);
        
        email.setPlainTextBody('Total '+ Total_Failed_Records + ' records failed for class FuturePlanning_StudentsLink_Batch');
        
        emlmsg.add(email); 
        if(Total_Failed_Records > 0){
            Messaging.sendEmail(emlmsg, false);
        }  
    }
    
        //schedule class method
    public void execute(SchedulableContext sc){
        FuturePlanning_StudentsLink_Batch OMRStudent = new FuturePlanning_StudentsLink_Batch();
        Id bprId = Database.executeBatch(OMRStudent, 20);
    }
    
}