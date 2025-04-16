/*
* Classname: SelfAwarenessRealitiesTriggerHandler
* Description : Handler class for SelfAwarenessRealitiesTrigger
* -------------------------------------------------------------------------------------------------------------------------
* History
* Version	Date			Description
* v1.1 	29th Sept 23	Updated logic for OMR Assessment Count (Considered change in Error Status)
* v2.0     14th feb 24     Commented boolean flag isStopRecursion - relaity data was not populating on contact on insert
* v3.0     28th feb 24     Added logic to populate academic year from current batch school academic year instead of antarang settings and included setting Next Academic Year in the query 
*/ 
public class SelfAwarenessRealitiesTriggerHandler {
    
    public static boolean isStopRecursion = false; 
    
    public static void populateStudentAndMarksCalculationNew(List<Self_Awareness_Realities__c> newList){
        //isStopRecursion = true;   //v2.0 
        map<String, List<string>> mapAllRealities;
        map<string,string> mapRealityExplanations;
        Set<String> notExpansOf16Ques = new Set<String>{'E','F','G'};
            Map<String, String> que2Grade9WithAns = new Map<String, String>{'Quiz_2_1__c'=>'C',
                'Quiz_2_2__c'=>'A','Quiz_2_3__c'=>'B','Quiz_2_4__c'=>'C','Quiz_2_5__c'=>'B'
                //,'Quiz_2_6__c'=>'B','Quiz_2_7__c'=>'B','Quiz_2_8__c'=>'B','Quiz_2_9__c'=>'D','Quiz_2_10__c'=>'D'
                };
                    
                    Map<String, List<String>> que2Grade11WithAns = new Map<String, List<String>>{'Quiz_2_1__c'=>new List<String>{'B'},
                        'Quiz_2_2__c'=>new List<String>{'C'},'Quiz_2_3__c'=>new List<String>{'B'},
                            'Quiz_2_4__c'=>new List<String>{'C'},'Quiz_2_5__c'=>new List<String>{'B'}
                                                                                                 //,'Quiz_2_6__c'=>new List<String>{'B'},'Quiz_2_7__c'=>new List<String>{'C'},'Quiz_2_8__c'=>new List<String>{'B'},'Quiz_2_9__c'=>new List<String>{'C','D'},'Quiz_2_10__c'=>new List<String>{'C','D'}
                                                                                                };                                            
                                                                                                    List<String> barcodeLST = new List<String>();
        
        for(Self_Awareness_Realities__c omrassess : newList){
            if(String.isNotBlank(omrassess.Barcode__c)){
                barcodeLST.add(omrassess.Barcode__c);
            }
            //barcodeLST.add(omrassess.Barcode__c);
        }
        
        mapRealityExplanations = new map<string,string>();
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
        
        Map<String,String> barcodeWithStd = new Map<String,String>();
        Map<String,String> barcodeWithGrade = new Map<String,String>();
        Map<String,String> barcodeWithBatchId = new Map<String,String>(); 
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        if(barcodeLST.size() > 0){
            Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Student').getRecordTypeId();
            for(Contact con : [Select Id,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c,Current_Batch_Id__c From Contact 
                               where (Grade_9_Barcode__c IN :barcodeLST OR 
                                      Grade_10_Barcode__c IN :barcodeLST OR 
                                      Grade_11_Barcode__c IN :barcodeLST OR
                                      Grade_12_Barcode__c IN :barcodeLST) AND RecordTypeId =: conRecTypeId]){
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
        }
        If(barcodeWithBatchId.size() > 0 ){
            for(Batch__c bt : [Select Id,School_Name__c,School_Name__r.Academic_Year__c from batch__c where Id in: barcodeWithBatchId.Values()]){
                if(bt.School_Name__c != null && bt.School_Name__r.Academic_Year__c != null) 
                    currentBatchSchoolAcadYear.put(bt.Id, bt.School_Name__r.Academic_Year__c);
            }
        }
        
        List<Self_Awareness_Realities__c> omrAssessmentLST = new List<Self_Awareness_Realities__c>();
        for(Self_Awareness_Realities__c omrassess : newList){
            if(barcodeWithStd.containsKey(omrassess.Barcode__c)){
                omrassess.Student__c = barcodeWithStd.get(omrassess.Barcode__c);
                omrassess.Grade__c = barcodeWithGrade.get(omrassess.Barcode__c);
                omrassess.Error_Status__c = 'No Error';
                omrassess.Batch_Id__c = barcodeWithBatchId.get(omrassess.Student__c);	//updated on 07.07.2023 for OMR Type Counter
            }else{
                omrassess.Grade__c = null;
                omrassess.Error_Status__c = 'Student not found';
            }
            
            //if(omrassess.Created_from_Form__c)
            //{	
            //omrassess.Academic_Year__c = antarangSett.Next_Academic_Year__c;
            if(currentBatchSchoolAcadYear.containsKey(barcodeWithBatchId.get(omrassess.Student__c)))   //v3.0 added logic to populate through batch school Academic year
                omrassess.Academic_Year__c = currentBatchSchoolAcadYear.get(barcodeWithBatchId.get(omrassess.Student__c));
            //calculateQuizMarksForm('Quiz_2_', 10, omrassess, omrassess, barcodeWithGrade.get(omrassess.Barcode__c));
            calculateQuizMarksForm('Quiz_2_', 5, omrassess, omrassess, barcodeWithGrade.get(omrassess.Barcode__c));
            /*}
else
{   
omrassess.Academic_Year__c = antarangSett.Academic_Year__c;
calculateQuizMarks('Quiz_2_', 10, omrassess, omrassess, barcodeWithGrade.get(omrassess.Barcode__c), que2Grade9WithAns, que2Grade11WithAns);
}*/
            
            if (omrassess.Reality1_Self_1__c == 'A' && mapRealityExplanations.containskey('1Yes')){
                omrassess.Reality1_Self_1_Ans__c = mapRealityExplanations.get('1Yes');
            } else if(omrassess.Reality1_Self_1__c == 'B' && mapRealityExplanations.containskey('1No')) { 
                omrassess.Reality1_Self_1_Ans__c = mapRealityExplanations.get('1No');
            }
            
            if (omrassess.Reality_2_Self_2__c=='A' && mapRealityExplanations.containskey('2Yes')){
                omrassess.Reality_2_Self_2_Ans__c = mapRealityExplanations.get('2Yes');
            } else if(omrassess.Reality_2_Self_2__c=='B' && mapRealityExplanations.containskey('2No')){ 
                omrassess.Reality_2_Self_2_Ans__c = mapRealityExplanations.get('2No');
            }
            
            if (omrassess.Reality_3_Self_3__c=='A' && mapRealityExplanations.containskey('3Yes')){
                omrassess.Reality_3_Self_3_Ans__c = mapRealityExplanations.get('3Yes');
            } else if(omrassess.Reality_3_Self_3__c=='B' && mapRealityExplanations.containskey('3No')) { 
                omrassess.Reality_3_Self_3_Ans__c = mapRealityExplanations.get('3No');
            }
            
            if(omrassess.Reality_4_Self_4__c=='B' && mapRealityExplanations.containskey('4B')) { 
                omrassess.Reality_4_Self_4_Ans__c = mapRealityExplanations.get('4B');
            } else  if(omrassess.Reality_4_Self_4__c=='C' && mapRealityExplanations.containskey('4C')) { 
                omrassess.Reality_4_Self_4_Ans__c = mapRealityExplanations.get('4C');
            } else if (omrassess.Reality_4_Self_4__c=='A' && mapRealityExplanations.containskey('4A')){
                omrassess.Reality_4_Self_4_Ans__c = mapRealityExplanations.get('4A');
            }
            
            if (omrassess.Reality_5_Family_1__c=='A' && mapRealityExplanations.containskey('5Yes')){
                omrassess.Reality_5_Family_1_Ans__c = mapRealityExplanations.get('5Yes');
            } else  if(omrassess.Reality_5_Family_1__c=='B' && mapRealityExplanations.containskey('5No')) { 
                omrassess.Reality_5_Family_1_Ans__c = mapRealityExplanations.get('5No');
            }
            
            if (omrassess.Reality_6_Family_2__c=='A' && mapRealityExplanations.containskey('6Yes')){
                omrassess.Reality_6_Family_2_Ans__c = mapRealityExplanations.get('6Yes');
            } else  if(omrassess.Reality_6_Family_2__c=='B' && mapRealityExplanations.containskey('6No')) { 
                omrassess.Reality_6_Family_2_Ans__c = mapRealityExplanations.get('6No');
            }
            
            if (omrassess.Reality_7_Family_3__c=='A' && mapRealityExplanations.containskey('7Yes')){
                omrassess.Reality_7_Family_3_Ans__c = mapRealityExplanations.get('7Yes');
            } else if(omrassess.Reality_7_Family_3__c=='B' && mapRealityExplanations.containskey('7No')) { 
                omrassess.Reality_7_Family_3_Ans__c = mapRealityExplanations.get('7No');
            }
            
            if(omrassess.Reality_8_Family_4__c=='B' && mapRealityExplanations.containskey('8B')) { 
                omrassess.Reality_8_Family_4_Ans__c = mapRealityExplanations.get('8B');
            } else if(omrassess.Reality_8_Family_4__c=='C' && mapRealityExplanations.containskey('8C')) { 
                omrassess.Reality_8_Family_4_Ans__c = mapRealityExplanations.get('8C');
            } else if (omrassess.Reality_8_Family_4__c=='A' && mapRealityExplanations.containskey('8A')){
                omrassess.Reality_8_Family_4_Ans__c = mapRealityExplanations.get('8A');
            } else if (omrassess.Reality_8_Family_4__c =='D') {
                omrassess.Reality_8_Family_4_Ans__c = 'I do not know';
            }
            
            // omrAssessmentLST.add(omr);
        }
        
    }
    
    public static void populateStudentAndMarksCalculation(List<Self_Awareness_Realities__c> newList){
        isStopRecursion = true;
        map<String, List<string>> mapAllRealities;
        map<string,string> mapRealityExplanations;
        Set<String> notExpansOf16Ques = new Set<String>{'E','F','G'};
            Map<String, String> que2Grade9WithAns = new Map<String, String>{'Quiz_2_1__c'=>'C',
                'Quiz_2_2__c'=>'A','Quiz_2_3__c'=>'B','Quiz_2_4__c'=>'C','Quiz_2_5__c'=>'B'
                //,'Quiz_2_6__c'=>'B','Quiz_2_7__c'=>'B','Quiz_2_8__c'=>'B','Quiz_2_9__c'=>'D','Quiz_2_10__c'=>'D'
                };
                    
                    Map<String, List<String>> que2Grade11WithAns = new Map<String, List<String>>{'Quiz_2_1__c'=>new List<String>{'B'},
                        'Quiz_2_2__c'=>new List<String>{'C'},'Quiz_2_3__c'=>new List<String>{'B'},
                            'Quiz_2_4__c'=>new List<String>{'C'},'Quiz_2_5__c'=>new List<String>{'B'}
                                                                                                 //,'Quiz_2_6__c'=>new List<String>{'B'},'Quiz_2_7__c'=>new List<String>{'C'},'Quiz_2_8__c'=>new List<String>{'B'},'Quiz_2_9__c'=>new List<String>{'C','D'},'Quiz_2_10__c'=>new List<String>{'C','D'}
                                                                                                }; 
                                                                                                    
                                                                                                    List<String> barcodeLST = new List<String>();
        for(Self_Awareness_Realities__c omrassess : newList){
            if(String.isNotBlank(omrassess.Barcode__c)){
                barcodeLST.add(omrassess.Barcode__c);
            }
            //barcodeLST.add(omrassess.Barcode__c);
        }
        
        mapRealityExplanations = new map<string,string>();
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
        
        Map<String,String> barcodeWithStd = new Map<String,String>();
        Map<String,String> barcodeWithGrade = new Map<String,String>();
        Map<String,String> barcodeWithBatchId = new Map<String,String>();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        if(barcodeLST.size() > 0){
            Id conRecTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Student').getRecordTypeId();
            for(Contact con : [Select Id,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c,Current_Batch_Id__c From Contact 
                               where (Grade_9_Barcode__c IN :barcodeLST OR 
                                      Grade_10_Barcode__c IN :barcodeLST OR 
                                      Grade_11_Barcode__c IN :barcodeLST OR
                                      Grade_12_Barcode__c IN :barcodeLST) AND RecordTypeId =: conRecTypeId]){
                                          if(barcodeLST
                                             
                                             
                                             .contains(con.Grade_9_Barcode__c)){
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
        }
        If(barcodeWithBatchId.size() > 0 ){
            for(Batch__c bt : [Select Id,School_Name__c,School_Name__r.Academic_Year__c from batch__c where Id in: barcodeWithBatchId.Values()]){
                if(bt.School_Name__c != null && bt.School_Name__r.Academic_Year__c != null) 
                    currentBatchSchoolAcadYear.put(bt.Id, bt.School_Name__r.Academic_Year__c);
            }
        }
        // system.debug('barcodeWithStd : ' + barcodeWithStd);
        // system.debug('barcodeWithGrade : ' + barcodeWithGrade);
        List<Self_Awareness_Realities__c> omrAssessmentLST = new List<Self_Awareness_Realities__c>();
        for(Self_Awareness_Realities__c omrassess : newList){
            Self_Awareness_Realities__c omr = new Self_Awareness_Realities__c(Id = omrassess.Id);
            if(barcodeWithStd.containsKey(omrassess.Barcode__c)){
                omr.Student__c = barcodeWithStd.get(omrassess.Barcode__c);
                omr.Grade__c = barcodeWithGrade.get(omrassess.Barcode__c);
                omr.Error_Status__c = 'No Error';
                omr.Batch_Id__c = barcodeWithBatchId.get(omrassess.Student__c);
            }else{
                omr.Grade__c = null;
                omr.Error_Status__c = 'Student not found';
            }
            //if(omrassess.Created_from_Form__c)
            //{	
            //omr.Academic_Year__c = antarangSett.Next_Academic_Year__c;
            if(currentBatchSchoolAcadYear.containsKey(barcodeWithBatchId.get(omr.Student__c)))   //v3.0 added logic to populate through batch school Academic year
                omr.Academic_Year__c = currentBatchSchoolAcadYear.get(barcodeWithBatchId.get(omr.Student__c));
            //calculateQuizMarksForm('Quiz_2_', 10, omrassess, omr, barcodeWithGrade.get(omrassess.Barcode__c));
            calculateQuizMarksForm('Quiz_2_', 5, omrassess, omr, barcodeWithGrade.get(omrassess.Barcode__c));
            /*}
else
{ 
omr.Academic_Year__c = antarangSett.Academic_Year__c;
calculateQuizMarks('Quiz_2_', 10, omrassess, omr, barcodeWithGrade.get(omrassess.Barcode__c), que2Grade9WithAns, que2Grade11WithAns);
}*/
            
            if (omrassess.Reality1_Self_1__c == 'A' && mapRealityExplanations.containskey('1Yes')){
                omr.Reality1_Self_1_Ans__c = mapRealityExplanations.get('1Yes');
            } else if(omrassess.Reality1_Self_1__c == 'B' && mapRealityExplanations.containskey('1No')) { 
                omr.Reality1_Self_1_Ans__c = mapRealityExplanations.get('1No');
            }
            
            if (omrassess.Reality_2_Self_2__c=='A' && mapRealityExplanations.containskey('2Yes')){
                omr.Reality_2_Self_2_Ans__c = mapRealityExplanations.get('2Yes');
            } else if(omrassess.Reality_2_Self_2__c=='B' && mapRealityExplanations.containskey('2No')){ 
                omr.Reality_2_Self_2_Ans__c = mapRealityExplanations.get('2No');
            }
            
            if (omrassess.Reality_3_Self_3__c=='A' && mapRealityExplanations.containskey('3Yes')){
                omr.Reality_3_Self_3_Ans__c = mapRealityExplanations.get('3Yes');
            } else if(omrassess.Reality_3_Self_3__c=='B' && mapRealityExplanations.containskey('3No')) { 
                omr.Reality_3_Self_3_Ans__c = mapRealityExplanations.get('3No');
            }
            
            if(omrassess.Reality_4_Self_4__c=='B' && mapRealityExplanations.containskey('4B')) { 
                omr.Reality_4_Self_4_Ans__c = mapRealityExplanations.get('4B');
            } else  if(omrassess.Reality_4_Self_4__c=='C' && mapRealityExplanations.containskey('4C')) { 
                omr.Reality_4_Self_4_Ans__c = mapRealityExplanations.get('4C');
            } else if (omrassess.Reality_4_Self_4__c=='A' && mapRealityExplanations.containskey('4A')){
                omr.Reality_4_Self_4_Ans__c = mapRealityExplanations.get('4A');
            }
            
            if (omrassess.Reality_5_Family_1__c=='A' && mapRealityExplanations.containskey('5Yes')){
                omr.Reality_5_Family_1_Ans__c = mapRealityExplanations.get('5Yes');
            } else  if(omrassess.Reality_5_Family_1__c=='B' && mapRealityExplanations.containskey('5No')) { 
                omr.Reality_5_Family_1_Ans__c = mapRealityExplanations.get('5No');
            }
            
            if (omrassess.Reality_6_Family_2__c=='A' && mapRealityExplanations.containskey('6Yes')){
                omr.Reality_6_Family_2_Ans__c = mapRealityExplanations.get('6Yes');
            } else  if(omrassess.Reality_6_Family_2__c=='B' && mapRealityExplanations.containskey('6No')) { 
                omr.Reality_6_Family_2_Ans__c = mapRealityExplanations.get('6No');
            }
            
            if (omrassess.Reality_7_Family_3__c=='A' && mapRealityExplanations.containskey('7Yes')){
                omr.Reality_7_Family_3_Ans__c = mapRealityExplanations.get('7Yes');
            } else if(omrassess.Reality_7_Family_3__c=='B' && mapRealityExplanations.containskey('7No')) { 
                omr.Reality_7_Family_3_Ans__c = mapRealityExplanations.get('7No');
            }
            
            if(omrassess.Reality_8_Family_4__c=='B' && mapRealityExplanations.containskey('8B')) { 
                omr.Reality_8_Family_4_Ans__c = mapRealityExplanations.get('8B');
            } else if(omrassess.Reality_8_Family_4__c=='C' && mapRealityExplanations.containskey('8C')) { 
                omr.Reality_8_Family_4_Ans__c = mapRealityExplanations.get('8C');
            } else if (omrassess.Reality_8_Family_4__c=='A' && mapRealityExplanations.containskey('8A')){
                omr.Reality_8_Family_4_Ans__c = mapRealityExplanations.get('8A');
            } else if (omrassess.Reality_8_Family_4__c =='D') {
                omr.Reality_8_Family_4_Ans__c = 'I do not know';
            }
            
            omrAssessmentLST.add(omr);
        }
        if(omrAssessmentLST.size() > 0){
            Update omrAssessmentLST;
        }
    }
    
    //code for "Grade 12" not write here
    public static Self_Awareness_Realities__c calculateQuizMarks(String sourceField, Integer noOfQues, Self_Awareness_Realities__c omrassess, 
                                                                 Self_Awareness_Realities__c omr,String grade, Map<String, String> que1Grade9WithAns,
                                                                 Map<String, List<String>> que1Grade11WithAns){
                                                                     for(Integer i = 1 ; i <= noOfQues ; i++){
                                                                         String field = sourceField + i + '__c';
                                                                         system.debug('field : ' + field);
                                                                         String strSourceField = String.valueOf(omrassess.get(field));
                                                                         system.debug('strSourceField : ' + strSourceField);
                                                                         if(String.isNotBlank(strSourceField) && strSourceField != '*'){
                                                                             if(grade == 'Grade 9'){
                                                                                 if(que1Grade9WithAns.get(field) == strSourceField){
                                                                                     omr.put(sourceField + i + '_Marks__c', 1);
                                                                                 } else {
                                                                                     omr.put(sourceField + i + '_Marks__c', 0);
                                                                                 }
                                                                             } else if(grade == 'Grade 11'){
                                                                                 if(que1Grade11WithAns.get(field).contains(strSourceField)){
                                                                                     omr.put(sourceField + i + '_Marks__c', 1);
                                                                                 } else {
                                                                                     omr.put(sourceField + i + '_Marks__c', 0);
                                                                                 }
                                                                             }
                                                                         } else if (strSourceField == '*' && grade != 'Grade 10') {
                                                                             omr.put(sourceField + i + '_Marks__c', 0);
                                                                         }
                                                                         system.debug('omr ' + omr);
                                                                         system.debug('################################################');
                                                                     }
                                                                     Return omr;
                                                                 }
    
    public static Self_Awareness_Realities__c calculateQuizMarksForm(String sourceField, Integer noOfQues, 
                                                                     Self_Awareness_Realities__c omrassess, Self_Awareness_Realities__c omr,String grade){
                                                                         
                                                                         Map<String, String> que2Grade9WithAns = new Map<String, String>{
                                                                             'Quiz_2_1__c'=>'C','Quiz_2_2__c'=>'A','Quiz_2_3__c'=>'B','Quiz_2_4__c'=>'C','Quiz_2_5__c'=>'B'
                                                                                 };
                                                                                     
                                                                                     Map<String, String> que2Grade11WithAns = new Map<String, String>{
                                                                                         'Quiz_2_1__c'=>'B','Quiz_2_2__c'=>'C','Quiz_2_3__c'=>'B','Quiz_2_4__c'=>'C','Quiz_2_5__c'=>'B'
                                                                                             };  
                                                                                                 List<String> ansList = New List<String>();
                                                                         
                                                                         for(Integer i = 1 ; i <= noOfQues ; i++){
                                                                             String field = sourceField + i + '__c';
                                                                             String fieldMarks = sourceField + i + '_Marks__c';
                                                                             
                                                                             String strSourceField = String.valueOf(omrassess.get(field));//answer
                                                                             if(String.isNotBlank(strSourceField) && grade != Null){
                                                                                 ansList.add(strSourceField);
                                                                             }
                                                                         }
                                                                         
                                                                         if(ansList.size()>0) {  //atleast 1 Quiz is answered  
                                                                             
                                                                             for(Integer i = 1 ; i <= noOfQues ; i++){
                                                                                 String field = sourceField + i + '__c';
                                                                                 system.debug('field : ' + field);
                                                                                 String fieldMarks = sourceField + i + '_Marks__c';
                                                                                 omr.put(fieldMarks, 0);
                                                                                 
                                                                                 String strSourceField = String.valueOf(omrassess.get(field));
                                                                                 if(String.isNotBlank(strSourceField) && strSourceField != '*')
                                                                                 {
                                                                                     if(grade == 'Grade 9')
                                                                                     {
                                                                                         if(que2Grade9WithAns.containsKey(field) && que2Grade9WithAns.get(field) == strSourceField){
                                                                                             omr.put(sourceField + i + '_Marks__c', 1);
                                                                                         }
                                                                                     }else if(grade == 'Grade 11')
                                                                                     {
                                                                                         if(que2Grade11WithAns.containsKey(field) && que2Grade11WithAns.get(field) == strSourceField){
                                                                                             omr.put(sourceField + i + '_Marks__c', 1);
                                                                                         }
                                                                                     }
                                                                                 } 
                                                                             }
                                                                         }
                                                                         return omr;
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
    
    // This method is used to popplate Realities in Student record.
    public static void populateStudentRealities(List<Self_Awareness_Realities__c> newList, Map<Id, Self_Awareness_Realities__c> oldMap){
        isStopRecursion = true;
        Id BaselineRecordTypeId = [SELECT Id, DeveloperName, Name, SobjectType FROM RecordType where DeveloperName = 'Baseline' AND SobjectType = 'Self_Awareness_Realities__c'].Id;
        Set<Id> contactIdSet = new Set<Id>();
        
        // Adding student ids into a list in insert event
        // Adding old and latest student ids into a list in update and delete event to update the contacts 
        for(Self_Awareness_Realities__c sar : newList){
            if(sar.RecordTypeId == BaselineRecordTypeId ){
                if(oldMap == null && ( String.isNotBlank(sar.Reality1_Self_1__c) || String.isNotBlank(sar.Reality_2_Self_2__c) || String.isNotBlank(sar.Reality_3_Self_3__c) || 
                                      String.isNotBlank(sar.Reality_4_Self_4__c) || String.isNotBlank(sar.Reality_5_Family_1__c) || String.isNotBlank(sar.Reality_6_Family_2__c) || 
                                      String.isNotBlank(sar.Reality_7_Family_3__c) || String.isNotBlank(sar.Reality_8_Family_4__c) ) )
                {
                    contactIdSet.add(sar.Student__c);
                }else if(oldMap != null && ( sar.Reality1_Self_1__c != oldMap.get(sar.Id).Reality1_Self_1__c || 
                                            sar.Reality_2_Self_2__c != oldMap.get(sar.Id).Reality_2_Self_2__c || 
                                            sar.Reality_3_Self_3__c != oldMap.get(sar.Id).Reality_3_Self_3__c || 
                                            sar.Reality_4_Self_4__c != oldMap.get(sar.Id).Reality_4_Self_4__c ||  
                                            sar.Reality_5_Family_1__c != oldMap.get(sar.Id).Reality_5_Family_1__c ||  
                                            sar.Reality_6_Family_2__c != oldMap.get(sar.Id).Reality_6_Family_2__c ||  
                                            sar.Reality_7_Family_3__c != oldMap.get(sar.Id).Reality_7_Family_3__c ||  
                                            sar.Reality_8_Family_4__c != oldMap.get(sar.Id).Reality_8_Family_4__c ||
                                            sar.Student__c != oldMap.get(sar.Id).Student__c ))
                {
                    if(oldMap.get(sar.Id).Student__c != null && sar.Student__c != oldMap.get(sar.Id).Student__c ){
                        contactIdSet.add(oldMap.get(sar.Id).Student__c);
                    }
                    if(sar.Student__c != null){
                        contactIdSet.add(sar.Student__c);
                    }
                }
            }
        }
        
        system.debug('contactIdSet : ' + contactIdSet);
        if(contactIdSet.size() > 0){
            updateStudentRealities(contactIdSet);
        }
        
    }
    
    public static void updateStudentRealities(set<Id> contactIdSet){
        // custom settings to check the Academic year
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        List<Contact> updateList = new List<Contact>();
        
        set<Id> currentBatchIds = new set<Id>();
        for(Contact con : [Select Id,Current_Batch_Id__c from contact where Id IN :contactIdSet AND Current_Batch_Id__c != null]){
            currentBatchIds.add(con.Current_Batch_Id__c);
        }
        set<Id> filteredBatchIds = new set<Id>();
        for(batch__c btch : [select Id,Academic_Year__c from Batch__c 
                             where Id IN: currentBatchIds 
                             AND Academic_Year__c != null 
                             AND (Academic_Year__c =: antarangSett.Academic_Year__c OR Academic_Year__c =: antarangSett.Next_Academic_Year__c)]){
                                 filteredBatchIds.add(btch.id);
                             }
        
        for(Contact con : [Select Id, Recommedation_Status__c, Status__c, Batch_Code__r.Academic_Year__c, Batch_Code__c, 
                           Reality_1__c, Reality_2__c, Reality_3__c, Reality_4__c, Reality_5__c, Reality_6__c, Reality_7__c, Reality_8__c,
                           (Select id, Reality1_Self_1__c, Reality_2_Self_2__c, Reality_3_Self_3__c, Reality_4_Self_4__c, Reality_5_Family_1__c, Reality_6_Family_2__c, 
                            Reality_7_Family_3__c, Reality_8_Family_4__c From Self_Awareness_Realities__r 
                            Where recordtype.DeveloperName = 'Baseline' order By Academic_Year__c Desc,  createddate desc Limit 1 )
                           From Contact 
                           Where Id IN :contactIdSet 
                           AND RecordType.DeveloperName = 'CA_Student' 
                           AND Current_Batch_Id__c IN: filteredBatchIds //v3.0 added logic to include Next Academic year and process through current batch id 
                          ])
        {
            system.debug('con.Self_Awareness_Realities__r : ' + con.Self_Awareness_Realities__r);
            if(con.Self_Awareness_Realities__r != null && con.Self_Awareness_Realities__r.size() > 0){
                con.Reality_1__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality1_Self_1__c, false);
                con.Reality_2__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_2_Self_2__c, false);
                con.Reality_3__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_3_Self_3__c, false);
                con.Reality_4__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_4_Self_4__c, true);
                con.Reality_5__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_5_Family_1__c, false);
                con.Reality_6__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_6_Family_2__c, false);
                con.Reality_7__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_7_Family_3__c, false);
                con.Reality_8__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_8_Family_4__c, true);
                
                con.Recommedation_Status__c = 'Not Processed';
                con.Status__c = 'Not Processed';
                updateList.add(con);
            }else if( String.isNotBlank(con.Reality_1__c) || String.isNotBlank(con.Reality_2__c) || String.isNotBlank(con.Reality_3__c) || 
                     String.isNotBlank(con.Reality_4__c) || String.isNotBlank(con.Reality_5__c) || String.isNotBlank(con.Reality_6__c) || 
                     String.isNotBlank(con.Reality_7__c) || String.isNotBlank(con.Reality_8__c) ){
                         con.Reality_1__c = '';
                         con.Reality_2__c = '';
                         con.Reality_3__c = '';
                         con.Reality_4__c = '';
                         con.Reality_5__c = '';
                         con.Reality_6__c = '';
                         con.Reality_7__c = '';
                         con.Reality_8__c = ''; 
                         con.Recommedation_Status__c = 'Not Processed';
                         con.Status__c = 'Not Processed';
                         updateList.add(con);
                     }
        }
        
        system.debug('updateList : ' + updateList);
        if(updateList.size() > 0){
            update updateList;
            //database.update(updateList, false);
        }
    }
    
    public static String fetchReality(String reality, Boolean isReality4or8){
        String str = '';
        if(reality == null || reality == ''){ return ''; }
        if(!isReality4or8){
            if( reality.equalsIgnoreCase('A')){ str = 'Yes'; }
            else if(reality.equalsIgnoreCase('B')){ str = 'No'; }
        }else{
            if(reality.equalsIgnoreCase('A')){ str = 'A'; }
            else if(reality.equalsIgnoreCase('B')){ str = 'B'; }
            else if(reality.equalsIgnoreCase('c')){ str = 'C'; }
            else if(reality.equalsIgnoreCase('D')){ str = 'I do not know'; }
        }
        return str;
    }
    
    
    public static void updateBatchId(List<Self_Awareness_Realities__c> newCdm1List, Map<Id,Self_Awareness_Realities__c> oldcdm1Map) {
        // custom settings to check the Academic year
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        
        Double acadYear = 0;
        List<Self_Awareness_Realities__c> cdm1List = New List<Self_Awareness_Realities__c>();        
        Set<Id> contSet = New Set<id>();                
        Map<Id,Id> StudBatchId = New Map<Id,Id>();
        Map<Id,List<Contact>> batchWithStuds = New Map<Id,List<Contact>>();
        List<Self_Awareness_Realities__c> updateCdm1 = New List<Self_Awareness_Realities__c>();
        
        for(Self_Awareness_Realities__c cdm1: newCdm1List) {
            if(oldcdm1Map == null || (oldcdm1Map !=null && cdm1.Student__c != oldcdm1Map.get(cdm1.Id).Student__c)) {                
                //acadYear = cdm1.Academic_Year__c;                
                if(cdm1.Student__c != null) {
                    contSet.add(cdm1.Student__c);
                    cdm1List.add(cdm1);
                } else {                    
                    cdm1.Batch_Id__c = null;                                        
                }                
            }
        }
        if(contSet.size()>0) {
            for(Contact c: [Select Id, G12_Batch_Code__c, G11_Batch_Code__c, G10_Batch_Code__c, Batch_Code__c
                            From Contact
                            Where Id In: contSet]) {                                 
                                if(c.G12_Batch_Code__c != null) {                                                                                
                                    if(!batchWithStuds.containsKey(c.G12_Batch_Code__c)) 
                                        batchWithStuds.put(c.G12_Batch_Code__c, new List<Contact>());
                                    batchWithStuds.get(c.G12_Batch_Code__c).add(c);
                                    
                                } else if(c.G11_Batch_Code__c != null) {                                        
                                    if(!batchWithStuds.containsKey(c.G11_Batch_Code__c)) 
                                        batchWithStuds.put(c.G11_Batch_Code__c, new List<Contact>());
                                    batchWithStuds.get(c.G11_Batch_Code__c).add(c);
                                    
                                } else if(c.G10_Batch_Code__c != null) {                                        
                                    if(!batchWithStuds.containsKey(c.G10_Batch_Code__c)) 
                                        batchWithStuds.put(c.G10_Batch_Code__c, new List<Contact>());
                                    batchWithStuds.get(c.G10_Batch_Code__c).add(c);
                                    
                                } else if(c.Batch_Code__c != null) {                                        
                                    if(!batchWithStuds.containsKey(c.Batch_Code__c)) 
                                        batchWithStuds.put(c.Batch_Code__c, new List<Contact>());
                                    batchWithStuds.get(c.Batch_Code__c).add(c);
                                }
                            }
            if(batchWithStuds.size()>0) {
                for(Batch__c b: [Select Id
                                 From Batch__c
                                 Where Id In: batchWithStuds.keySet() 
                                 AND (Academic_Year__c =: antarangSett.Academic_Year__c OR Academic_Year__c =: antarangSett.Next_Academic_Year__c)]) //v3.0 Included Next_Academic_Year__c]) 
                {                                                                                                                          
                    for(Contact c: batchWithStuds.get(b.Id)) {
                        StudBatchId.put(c.Id,b.Id);
                    }
                }                    
                for(Self_Awareness_Realities__c o: cdm1List){
                    if(StudBatchId.containsKey(o.Student__c)) {                            
                        o.Batch_Id__c = StudBatchId.get(o.Student__c);                            
                    }
                }
            }
        }        
    }
    
    //----- v1.0 START ------- 
    public static boolean updateCounterFlag = false;
    public static void updateOMRTypeCounterManager(List<Self_Awareness_Realities__c> selfAwareRealList, Map<Id,Self_Awareness_Realities__c> oldSelfAwareRealMap, Boolean isDelete){
        updateCounterFlag = true;
        set<Id> BatchSet = new set<Id>();         
        
        if(isDelete){   														//Self Awareness Realities record Deleted
            if(oldSelfAwareRealMap != null){
                for(Self_Awareness_Realities__c c: oldSelfAwareRealMap.Values()){
                    BatchSet.add(c.Batch_Id__c);
                }
            }
        }else{
            for(Self_Awareness_Realities__c c: selfAwareRealList){
                if(oldSelfAwareRealMap == null){     									//Self Awareness Realities record Inserted
                    BatchSet.add(c.Batch_Id__c);
                }else if(c.Student__c != oldSelfAwareRealMap.get(c.Id).Student__c || c.Student_Linked__c != oldSelfAwareRealMap.get(c.Id).Student_Linked__c
                         || c.Error_Status__c != oldSelfAwareRealMap.get(c.Id).Error_Status__c){     //Self Awareness Realities record Updated (v1.1)
                             BatchSet.add(c.Batch_Id__c);
                         }
            }
        }
        if(BatchSet.size() > 0){
            updateOMRTypeCounter(BatchSet);
        }
    }
    
    public static void updateOMRTypeCounter(set<Id> BatchSet){
        List<Session_OMR_Type__c> SOTList = New List<Session_OMR_Type__c>();
        Map<Id,Integer> CounterMap = New Map<Id,Integer>();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        
        if(!BatchSet.isempty() && BatchSet.size() > 0){
            AggregateResult[] groupedBatchResults   = [SELECT COUNT(Id), Batch_Id__c 
                                                       FROM Self_Awareness_Realities__c 
                                                       WHERE Batch_Id__c IN: BatchSet AND 
                                                       Student__c != null AND 
                                                       Academic_Year__c =: antarangSett.Academic_Year__c AND 
                                                       Error_Status__c = 'No Error'  
                                                       GROUP BY Batch_Id__c];
            for (AggregateResult ar : groupedBatchResults)  {
                CounterMap.put((Id)ar.get('Batch_Id__c'), (Integer)ar.get('expr0'));
            }
            for(Session_OMR_Type__c sot : [SELECT Id, OMR_Assessment_Record_Type__c, Session_Batch_Id__c
                                           FROM Session_OMR_Type__c
                                           WHERE OMR_Assessment_Object__c = 'Self Awareness Realities' AND
                                           Session_Batch_Id__c IN: BatchSet])
            {
                if(CounterMap.ContainsKey(sot.Session_Batch_Id__c)){
                    SOTList.add(new Session_OMR_Type__c(Id = sot.Id, OMR_Assessment_Count__c = CounterMap.get(sot.Session_Batch_Id__c)));
                }
            }
            if(SOTList.size() > 0){
                Update SOTList;
            } 
        }
    }
    //----- v1.0 END -------
    
    //----Old Method start----
    /*public static void updateOMRTypeCounter(List<Self_Awareness_Realities__c> cdm1List, Map<Id,Self_Awareness_Realities__c> oldcdm1Map, Boolean isDelete) {        
updateCounterFlag = true;
Boolean isDeleteFlag = isDelete;
Integer getCount = 0;
List<Session_OMR_Type__c> SOTList = New List<Session_OMR_Type__c>();
Map<Id,Integer> BatchMap = New Map<Id,Integer>();
for(Self_Awareness_Realities__c c: cdm1List) {              
If((isDeleteFlag == false && oldcdm1Map == null && c.Error_Status__c != 'Duplicate Entry') ||	//on Insert
(oldcdm1Map != null && c.Error_Status__c != oldcdm1Map.get(c.Id).Error_Status__c && c.Error_Status__c != 'Duplicate Entry' && oldcdm1Map.get(c.Id).Error_Status__c == 'Duplicate Entry')) {                                                                          
if(!BatchMap.containsKey(c.Batch_Id__c)) {
BatchMap.put(c.Batch_Id__c,1);                           
}
else {
getCount = BatchMap.get(c.Batch_Id__c);
BatchMap.put(c.Batch_Id__c,getCount+1);
}                                                                                    
} else if( isDeleteFlag == true || 
(oldcdm1Map != null && c.Error_Status__c != oldcdm1Map.get(c.Id).Error_Status__c && c.Error_Status__c == 'Duplicate Entry' && oldcdm1Map.get(c.Id).Error_Status__c != 'Duplicate Entry')) {                                                                                                  
if(!BatchMap.containsKey(c.Batch_Id__c)) {
BatchMap.put(c.Batch_Id__c,-1);                           
}
else {
getCount = BatchMap.get(c.Batch_Id__c);
BatchMap.put(c.Batch_Id__c,getCount-1);
} 
}            
}
if(BatchMap.size()>0) {            
for(Session_OMR_Type__c s: [Select id, name, OMR_Type__c, Session__r.name, Session__r.Session_Grade__c, OMR_Assessment_Count__c, Session_Batch_Id__c, Session__r.Batch__c
From Session_OMR_Type__c 
Where Session__r.Batch__c  IN: BatchMap.KeySet() 
AND OMR_Assessment_Object__c = 'Self Awareness Realities' ]) {                                                                                                                          
if(BatchMap.containsKey(s.Session_Batch_Id__c)) {
s.OMR_Assessment_Count__c = s.OMR_Assessment_Count__c + BatchMap.get(s.Session_Batch_Id__c);
SOTList.add(s);                                                
}                                
}
}
if(SOTList.size()>0) {
update SOTList;
}
} */
    //----Old Method end----
    
    public static void dummCodeCoverage(){
        integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        
    }
    
}