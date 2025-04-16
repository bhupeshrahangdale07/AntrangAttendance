/* Link Student on Self_Awareness_Realities__c uploaded from CSV (OMR) Calculate marks after linking
* -------------------------------------------------------------------------------------------------------------------------
* History
 * Version	Date			Description
 * v1.0     13th mar 24     added logic to populate Academic year from current batch School Academic year
*/ 

public class SAR_StudentsLink_Batch Implements Database.batchable<sObject>, Database.Stateful, schedulable{
    public String query;
    public Integer Total_Success_Records = 0;
    public Integer Total_Failed_Records = 0;    
    Set<Id> Ids = new Set<Id>();
                                    
    //Start method
    public Database.QueryLocator start(Database.BatchableContext BC){
        if(String.isBlank(query)) {
            //update on 14-04-2023
            query = 'Select Id, Barcode__c, Created_from_Form__c, Student__c, Student_Linked__c, Marks_Recalculated__c,Error_Status__c,'
                +' Quiz_2_1__c, Quiz_2_2__c, Quiz_2_3__c, Quiz_2_4__c, Quiz_2_5__c, Quiz_2_6__c, Quiz_2_7__c, Quiz_2_8__c, Quiz_2_9__c, Quiz_2_10__c,'
                +' Quiz_2_1_Marks__c, Quiz_2_2_Marks__c, Quiz_2_3_Marks__c, Quiz_2_4_Marks__c, Quiz_2_5_Marks__c, Quiz_2_6_Marks__c, Quiz_2_7_Marks__c, Quiz_2_8_Marks__c, Quiz_2_9_Marks__c, Quiz_2_10_Marks__c,'
                +' Reality1_Self_1__c, Reality1_Self_1_Ans__c, Reality_2_Self_2__c, Reality_2_Self_2_Ans__c, Reality_3_Self_3__c, Reality_3_Self_3_Ans__c, Reality_4_Self_4__c, Reality_4_Self_4_Ans__c,'
                +' Reality_5_Family_1__c, Reality_5_Family_1_Ans__c, Reality_6_Family_2__c, Reality_6_Family_2_Ans__c, Reality_7_Family_3__c, Reality_7_Family_3_Ans__c, Reality_8_Family_4__c, Reality_8_Family_4_Ans__c'
                +' from Self_Awareness_Realities__c'
                +' where Barcode__c != Null AND (Student_Linked__c = False OR Marks_Recalculated__c = False)';
            
        }
        return Database.getQueryLocator(query);
    }
    //Execute Method
    public void execute(Database.BatchableContext BC, List<Self_Awareness_Realities__c> sarOMRList){
        Id RecTypeCA = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId(); 
        Set<String> barcodeLST = New Set<String>();  
        List<Self_Awareness_Realities__c> SARList = New List<Self_Awareness_Realities__c>();                                     
        Map<string,string> mapRealityExplanations = New Map<string,string>();
        Map<String,String> barcodeWithStd = new Map<String,String>();
        Map<String,String> barcodeWithGrade = new Map<String,String>();
        Map<String,String> barcodeWithBatchId = new Map<String,String>();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        
        for (Explanations__c ex: [Select Name,Particulars__c,Realities__c,Code__c,Particulars_Hindi__c,Particulars_Marathi__c,
                                  Document_Icon_Id__c from Explanations__c where Name= 'Realities' and Code__c != null Order by Code__c]){
                                      if(ex.Code__c.startswith('Self 1')) {
                                          if(ex.Realities__c == 'Yes') {
                                              mapRealityExplanations.put('1Yes',getRealityText(ex,'eng'));
                                          }
                                          if(ex.Realities__c == 'No') {
                                              mapRealityExplanations.put('1No',getRealityText(ex,'eng'));
                                          }
                                      }
                                      if(ex.Code__c.startswith('Self 2')) {
                                          if(ex.Realities__c == 'Yes') {
                                              mapRealityExplanations.put('2Yes',getRealityText(ex,'eng'));
                                          }
                                          if(ex.Realities__c == 'No') {
                                              mapRealityExplanations.put('2No',getRealityText(ex,'eng'));
                                          }
                                      }
                                      if(ex.Code__c.startswith('Self 3')) {
                                          if(ex.Realities__c == 'Yes') {
                                              mapRealityExplanations.put('3Yes',getRealityText(ex,'eng'));
                                          }
                                          if(ex.Realities__c == 'No') {
                                              mapRealityExplanations.put('3No',getRealityText(ex,'eng'));
                                          }
                                      }
                                      if(ex.Code__c.startswith('Self 4')) {
                                          if(ex.Realities__c == 'A') {
                                              mapRealityExplanations.put('4A',getRealityText(ex,'eng'));
                                          }
                                          if(ex.Realities__c == 'B') {
                                              mapRealityExplanations.put('4B',getRealityText(ex,'eng'));
                                          }
                                          if(ex.Realities__c == 'C') {
                                              mapRealityExplanations.put('4C',getRealityText(ex,'eng'));
                                          }
                                      }
                                      if(ex.Code__c.startswith('Family 1')) {
                                          if(ex.Realities__c == 'Yes') {
                                              mapRealityExplanations.put('5Yes',getRealityText(ex,'eng'));
                                          }
                                          if(ex.Realities__c == 'No') {
                                              mapRealityExplanations.put('5No',getRealityText(ex,'eng'));
                                          }
                                      }
                                      if(ex.Code__c.startswith('Family 2')) {
                                          if(ex.Realities__c == 'Yes') {
                                              mapRealityExplanations.put('6Yes',getRealityText(ex,'eng'));
                                          }
                                          if(ex.Realities__c == 'No') {
                                              mapRealityExplanations.put('6No',getRealityText(ex,'eng'));
                                          }
                                      }
                                      if(ex.Code__c.startswith('Family 3')) {
                                          if(ex.Realities__c == 'Yes') {
                                              mapRealityExplanations.put('7Yes',getRealityText(ex,'eng'));
                                          }
                                          if(ex.Realities__c == 'No') {
                                              mapRealityExplanations.put('7No',getRealityText(ex,'eng'));
                                          }
                                      }
                                      if(ex.Code__c.startswith('Family 4')) {
                                          if(ex.Realities__c == 'A') {
                                              mapRealityExplanations.put('8A',getRealityText(ex,'eng'));
                                          }
                                          if(ex.Realities__c == 'B') {
                                              mapRealityExplanations.put('8B',getRealityText(ex,'eng'));
                                          }
                                          if(ex.Realities__c == 'C') {
                                              mapRealityExplanations.put('8C',getRealityText(ex,'eng'));
                                          }
                                      }
                                  }
        
        for(Self_Awareness_Realities__c objSaf : sarOMRList){
            barcodeLST.add(objSaf.Barcode__c);
        }
        
        for(Contact con : [SELECT Name, LastName, Id, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c,Current_Batch_Id__c
                           From Contact 
                           WHERE RecordTypeId =: RecTypeCA AND (Grade_9_Barcode__c IN: barcodeLST OR Grade_10_Barcode__c IN: barcodeLST OR Grade_11_Barcode__c IN: barcodeLST OR Grade_12_Barcode__c IN: barcodeLST)]){
                               if(barcodeLST.contains(con.Grade_9_Barcode__c)){
                                   barcodeWithStd.put(con.Grade_9_Barcode__c, con.Id);  
                                   barcodeWithGrade.put(con.Grade_9_Barcode__c, 'Grade 9');  
                               } else if(barcodeLST.contains(con.Grade_10_Barcode__c)){
                                   barcodeWithStd.put(con.Grade_10_Barcode__c, con.Id);
                                   barcodeWithGrade.put(con.Grade_10_Barcode__c, 'Grade 10');  
                               } else if(barcodeLST.contains(con.Grade_11_Barcode__c)){
                                   barcodeWithStd.put(con.Grade_11_Barcode__c, con.Id); 
                                   barcodeWithGrade.put(con.Grade_11_Barcode__c, 'Grade 11');  
                               } else if(barcodeLST.contains(con.Grade_12_Barcode__c)){
                                   barcodeWithStd.put(con.Grade_12_Barcode__c, con.Id); 
                                   barcodeWithGrade.put(con.Grade_12_Barcode__c, 'Grade 12');  
                               }
                               barcodeWithBatchId.put(con.Id, con.Current_Batch_Id__c);
                           }
        
        If(barcodeWithBatchId.size() > 0 ){
            for(Batch__c bt : [Select Id,School_Name__c,School_Name__r.Academic_Year__c from batch__c where Id in: barcodeWithBatchId.Values()]){
                if(bt.School_Name__c != null && bt.School_Name__r.Academic_Year__c != null) 
                    currentBatchSchoolAcadYear.put(bt.Id, bt.School_Name__r.Academic_Year__c);
            }
        }
        
        for(Self_Awareness_Realities__c s: sarOMRList) {
            
            if(s.Student__c == null && s.Student_Linked__c == False && barcodeWithStd.containsKey(s.Barcode__c)){           
                s.Student__c = barcodeWithStd.get(s.Barcode__c);        
                s.Grade__c = barcodeWithGrade.get(s.Barcode__c);
            }
            if(s.Marks_Recalculated__c == False && barcodeWithGrade.containsKey(s.Barcode__c)) {
                s.Reality1_Self_1_Ans__c = null; s.Reality_2_Self_2_Ans__c = null; s.Reality_3_Self_3_Ans__c = null; s.Reality_4_Self_4_Ans__c = null;
                s.Reality_4_Self_4_Ans__c = null; s.Reality_6_Family_2_Ans__c = null; s.Reality_7_Family_3_Ans__c = null; s.Reality_8_Family_4_Ans__c = null;
                s.Quiz_2_1_Marks__c = null; s.Quiz_2_2_Marks__c = null; s.Quiz_2_3_Marks__c = null; s.Quiz_2_4_Marks__c = null; s.Quiz_2_5_Marks__c = null;
                /*s.Quiz_2_6_Marks__c = 0; s.Quiz_2_7_Marks__c = 0; s.Quiz_2_8_Marks__c = 0; s.Quiz_2_9_Marks__c = 0; s.Quiz_2_10_Marks__c = 0;  */             
                
                SelfAwarenessRealitiesTriggerHandler.calculateQuizMarksForm('Quiz_2_', 5, s, s, barcodeWithGrade.get(s.Barcode__c));
                if (s.Reality1_Self_1__c == 'A' && mapRealityExplanations.containskey('1Yes')){
                    s.Reality1_Self_1_Ans__c = mapRealityExplanations.get('1Yes');
                } else if(s.Reality1_Self_1__c == 'B' && mapRealityExplanations.containskey('1No')) { 
                    s.Reality1_Self_1_Ans__c = mapRealityExplanations.get('1No');
                }
                
                if (s.Reality_2_Self_2__c=='A' && mapRealityExplanations.containskey('2Yes')){
                    s.Reality_2_Self_2_Ans__c = mapRealityExplanations.get('2Yes');
                } else if(s.Reality_2_Self_2__c=='B' && mapRealityExplanations.containskey('2No')){ 
                    s.Reality_2_Self_2_Ans__c = mapRealityExplanations.get('2No');
                }
                
                if (s.Reality_3_Self_3__c=='A' && mapRealityExplanations.containskey('3Yes')){
                    s.Reality_3_Self_3_Ans__c = mapRealityExplanations.get('3Yes');
                } else if(s.Reality_3_Self_3__c=='B' && mapRealityExplanations.containskey('3No')) { 
                    s.Reality_3_Self_3_Ans__c = mapRealityExplanations.get('3No');
                }
                
                if(s.Reality_4_Self_4__c=='B' && mapRealityExplanations.containskey('4B')) { 
                    s.Reality_4_Self_4_Ans__c = mapRealityExplanations.get('4B');
                } else  if(s.Reality_4_Self_4__c=='C' && mapRealityExplanations.containskey('4C')) { 
                    s.Reality_4_Self_4_Ans__c = mapRealityExplanations.get('4C');
                } else if (s.Reality_4_Self_4__c=='A' && mapRealityExplanations.containskey('4A')){
                    s.Reality_4_Self_4_Ans__c = mapRealityExplanations.get('4A');
                }
                
                if (s.Reality_5_Family_1__c=='A' && mapRealityExplanations.containskey('5Yes')){
                    s.Reality_5_Family_1_Ans__c = mapRealityExplanations.get('5Yes');
                } else  if(s.Reality_5_Family_1__c=='B' && mapRealityExplanations.containskey('5No')) { 
                    s.Reality_5_Family_1_Ans__c = mapRealityExplanations.get('5No');
                }
                
                if (s.Reality_6_Family_2__c=='A' && mapRealityExplanations.containskey('6Yes')){
                    s.Reality_6_Family_2_Ans__c = mapRealityExplanations.get('6Yes');
                } else  if(s.Reality_6_Family_2__c=='B' && mapRealityExplanations.containskey('6No')) { 
                    s.Reality_6_Family_2_Ans__c = mapRealityExplanations.get('6No');
                }
                
                if (s.Reality_7_Family_3__c=='A' && mapRealityExplanations.containskey('7Yes')){
                    s.Reality_7_Family_3_Ans__c = mapRealityExplanations.get('7Yes');
                } else if(s.Reality_7_Family_3__c=='B' && mapRealityExplanations.containskey('7No')) { 
                    s.Reality_7_Family_3_Ans__c = mapRealityExplanations.get('7No');
                }
                
                if(s.Reality_8_Family_4__c=='B' && mapRealityExplanations.containskey('8B')) { 
                    s.Reality_8_Family_4_Ans__c = mapRealityExplanations.get('8B');
                } else if(s.Reality_8_Family_4__c=='C' && mapRealityExplanations.containskey('8C')) { 
                    s.Reality_8_Family_4_Ans__c = mapRealityExplanations.get('8C');
                } else if (s.Reality_8_Family_4__c=='A' && mapRealityExplanations.containskey('8A')){
                    s.Reality_8_Family_4_Ans__c = mapRealityExplanations.get('8A');
                } else if (s.Reality_8_Family_4__c =='D') {
                    s.Reality_8_Family_4_Ans__c = 'I do not know';
                }     
                s.Marks_Recalculated__c = True;
            }
            if(s.Student__c != null){
                s.Student_Linked__c = True;
                //added on 07.07.2023
                if(s.Error_Status__c != null && s.Error_Status__c == 'Student not found') {
                    s.Error_Status__c = 'No Error';
                }
                //added on 13/03/24
                if(currentBatchSchoolAcadYear.containsKey(barcodeWithBatchId.get(s.Student__c)))   //v1.0 added logic to populate through batch school Academic year
                s.Academic_Year__c = currentBatchSchoolAcadYear.get(barcodeWithBatchId.get(s.Student__c));
            } 
            SARList.add(s);            
        }            
        
        If(!SARList.isEmpty() && SARList.size() > 0){              
            Database.SaveResult[] result = Database.Update(SARList, false); 
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
        String emailId = System.Label.Batch_Email_Ids;
        List<Messaging.SingleEmailMessage> emlmsg = New List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage email = New Messaging.SingleEmailMessage();
        email.setSubject('Records failed for Class SAR_StudentsLink_Batch');
        
        List<String> emailTo = New List<String>();
        emailTo.add(emailId);
        email.setToAddresses(emailTo);
        
        email.setPlainTextBody('Total '+ Total_Failed_Records + ' records failed for class SAR_StudentsLink_Batch');
        
        emlmsg.add(email); 
        if(Total_Failed_Records > 0){
            Messaging.sendEmail(emlmsg, false);
        }  
    }
    
    //schedule class method
    public void execute(SchedulableContext sc){
        SAR_StudentsLink_Batch OMRStudent = new SAR_StudentsLink_Batch();
        Id bprId = Database.executeBatch(OMRStudent, 20);
    }
    
    public static string getRealityText(Explanations__c ex, String language){
        string strParticulars = ex.Particulars__c;
        if(language == 'hin') {
            strParticulars = ex.Particulars_Hindi__c;
        } else if(language == 'mar'){
            strParticulars = ex.Particulars_Marathi__c;
        } else if(language == 'eng'){
            strParticulars = ex.Particulars__c;
        }
        return strParticulars;
    }    
}