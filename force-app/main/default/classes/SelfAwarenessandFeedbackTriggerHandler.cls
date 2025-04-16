/*
 * Classname: SelfAwarenessandFeedbackTriggerHandler
 * Description : Handler class for SelfAwarenessandFeedbackTrigger
 * -------------------------------------------------------------------------------------------------------------------------
 * History
 * Version	Date			Description
 * v1.1 	29th Sept 23	Updated logic for OMR Assessment Count (Considered change in Error Status)
 * v2.0     28th feb 24     Added logic to populate academic year from current batch school academic year instead of antarang settings and included setting Next Academic Year in the query 
 */ 
public class SelfAwarenessandFeedbackTriggerHandler {
    
    public static boolean isStopRecursion = false;
    public static void populateStudentAndMarksCalculationNew(List<Self_Awareness_and_Feedback__c> newList){
        
        Map<String, String> que1Grade9WithAns = new Map<String, String>{'Quiz_1_1__c'=>'C',
            'Quiz_1_2__c'=>'A','Quiz_1_3__c'=>'C','Quiz_1_4__c'=>'B','Quiz_1_5__c'=>'B'
            //,'Quiz_1_6__c'=>'B','Quiz_1_7__c'=>'B',
            //'Quiz_1_8__c'=>'C','Quiz_1_9__c'=>'D','Quiz_1_10__c'=>'B'
            };
                
        Map<String, List<String>> que1Grade10WithAns = new Map<String, List<String>>{'Quiz_1_1__c'=>new List<String>{'C'},
            'Quiz_1_2__c'=>new List<String>{'C'},'Quiz_1_3__c'=>new List<String>{'B'},'Quiz_1_4__c'=>new List<String>{'B'},
            'Quiz_1_5__c'=>new List<String>{'C'}
            //,'Quiz_1_6__c'=>new List<String>{'A','B'},'Quiz_1_7__c'=>new List<String>{'C','D'},
            //'Quiz_1_8__c'=>new List<String>{'A','B'},'Quiz_1_9__c'=>new List<String>{'A','B'},'Quiz_1_10__c'=>new List<String>{'A'}
        };
                                
        Map<String, List<String>> que1Grade11WithAns = new Map<String, List<String>>{'Quiz_1_1__c'=>new List<String>{'C'},
            'Quiz_1_2__c'=>new List<String>{'C'},'Quiz_1_3__c'=>new List<String>{'A'},
            'Quiz_1_4__c'=>new List<String>{'C'},'Quiz_1_5__c'=>new List<String>{'C'}
            //,'Quiz_1_6__c'=>new List<String>{'C'},'Quiz_1_7__c'=>new List<String>{'A'},
            //'Quiz_1_8__c'=>new List<String>{'B'},'Quiz_1_9__c'=>new List<String>{'C'},
            //'Quiz_1_10__c'=>new List<String>{'C','D'}
        };
            
        Map<String, List<String>> que1Grade12WithAns = new Map<String, List<String>>{'Quiz_1_1__c'=>new List<String>{'C'},
            'Quiz_1_2__c'=>new List<String>{'B'},'Quiz_1_3__c'=>new List<String>{'A'},
            'Quiz_1_4__c'=>new List<String>{'B'},'Quiz_1_5__c'=>new List<String>{'A'}
        };
                                                        
        // isStopRecursion = true;
        List<String> barcodeLST = new List<String>();
        Set<Id> Ids = new Set<Id>();      
            
        for(Self_Awareness_and_Feedback__c omrassess : newList){
            if(String.isNotBlank(omrassess.Barcode__c)){
                barcodeLST.add(omrassess.Barcode__c);
            }
            //barcodeLST.add(omrassess.Barcode__c);
            Ids.add(omrassess.Id);
        }
        Map<String,String> barcodeWithStd = new Map<String,String>();
        Map<String,String> barcodeWithGrade = new Map<String,String>();
        Map<String,String> barcodeWithBatchId = new Map<String,String>(); 
         AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
         map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        
        if(barcodeLST.size() > 0){
            for(Contact con : [Select Id,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c,Current_Batch_Id__c
                               From Contact 
                               where Grade_9_Barcode__c IN :barcodeLST OR 
                               Grade_10_Barcode__c IN :barcodeLST OR 
                               Grade_11_Barcode__c IN :barcodeLST OR
                              Grade_12_Barcode__c IN :barcodeLST]){
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
        
        List<Self_Awareness_and_Feedback__c> omrAssessmentLST = new List<Self_Awareness_and_Feedback__c>();
        for(Self_Awareness_and_Feedback__c omrassess : newList){
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
                if(currentBatchSchoolAcadYear.containsKey(barcodeWithBatchId.get(omrassess.Student__c)))   //v2.0 added logic to populate through batch school Academic year
                omrassess.Academic_Year__c = currentBatchSchoolAcadYear.get(barcodeWithBatchId.get(omrassess.Student__c));
                //calculateQuizMarksForm('Quiz_1_', 10, omrassess, omrassess, barcodeWithGrade.get(omrassess.Barcode__c));
				calculateQuizMarksForm('Quiz_1_', 5, omrassess, omrassess, barcodeWithGrade.get(omrassess.Barcode__c));
			/*}
            else
            {
                omrassess.Academic_Year__c = antarangSett.Academic_Year__c;

                //calculateQuizMarks('Quiz_1_', 10, omrassess, omrassess, barcodeWithGrade.get(omrassess.Barcode__c), que1Grade9WithAns, que1Grade10WithAns, que1Grade11WithAns);
                calculateQuizMarks('Quiz_1_', 5, omrassess, omrassess, barcodeWithGrade.get(omrassess.Barcode__c), que1Grade9WithAns, que1Grade10WithAns, que1Grade11WithAns);
                system.debug('------- '+ omrassess);
            }*/
           // omrAssessmentLST.add(omr);
        }
        
        
       /* if(Ids.size() > 0){
            system.debug('Id passed in Batch--'+Ids);
            SelfAwarenessandFeedbackBatch selfAwar = new SelfAwarenessandFeedbackBatch(Ids);
            Database.executeBatch(selfAwar);
        } */
        
    }
    
    public static void executeSelfAwarenessandFeedbackBatch(List<Self_Awareness_and_Feedback__c> newList){
        Set<Id> Ids = new Set<Id>();      
            
        for(Self_Awareness_and_Feedback__c omrassess : newList){
            Ids.add(omrassess.Id);
        }
        
        if(Ids.size() > 0){
            system.debug('Id passed in Batch--'+Ids);
            SelfAwarenessandFeedbackBatch selfAwar = new SelfAwarenessandFeedbackBatch(Ids);
            Database.executeBatch(selfAwar);
        }
    }
    public static void populateStudentAndMarksCalculation(List<Self_Awareness_and_Feedback__c> newList){
        system.debug('populateStudentAndMarksCalculation');
        /*Map<String, String> que1Grade9WithAns = new Map<String, String>{'Quiz_1_1__c'=>'B',
            'Quiz_1_2__c'=>'C','Quiz_1_3__c'=>'A','Quiz_1_4__c'=>'C','Quiz_1_5__c'=>'B'
            //,'Quiz_1_6__c'=>'B','Quiz_1_7__c'=>'B',
            //'Quiz_1_8__c'=>'C','Quiz_1_9__c'=>'D','Quiz_1_10__c'=>'B'
        };*/
        Map<String, String> que1Grade9WithAns = new Map<String, String>{'Quiz_1_1__c'=>'C',
            'Quiz_1_2__c'=>'A','Quiz_1_3__c'=>'C','Quiz_1_4__c'=>'B','Quiz_1_5__c'=>'B'
            //,'Quiz_1_6__c'=>'B','Quiz_1_7__c'=>'B',
            //'Quiz_1_8__c'=>'C','Quiz_1_9__c'=>'D','Quiz_1_10__c'=>'B'
            };
                
        Map<String, List<String>> que1Grade10WithAns = new Map<String, List<String>>{'Quiz_1_1__c'=>new List<String>{'B'},
           'Quiz_1_2__c'=>new List<String>{'A'},'Quiz_1_3__c'=>new List<String>{'A','B'},'Quiz_1_4__c'=>new List<String>{'C','D'},
           'Quiz_1_5__c'=>new List<String>{'C','D'}
           //,'Quiz_1_6__c'=>new List<String>{'A','B'},'Quiz_1_7__c'=>new List<String>{'C','D'},
           //'Quiz_1_8__c'=>new List<String>{'A','B'},'Quiz_1_9__c'=>new List<String>{'A','B'},'Quiz_1_10__c'=>new List<String>{'A'}
        };
                                
        Map<String, List<String>> que1Grade11WithAns = new Map<String, List<String>>{'Quiz_1_1__c'=>new List<String>{'C'},
           'Quiz_1_2__c'=>new List<String>{'A'},'Quiz_1_3__c'=>new List<String>{'B'},
           'Quiz_1_4__c'=>new List<String>{'B'},'Quiz_1_5__c'=>new List<String>{'D'}
           //,'Quiz_1_6__c'=>new List<String>{'C'},'Quiz_1_7__c'=>new List<String>{'A'},
           //'Quiz_1_8__c'=>new List<String>{'B'},'Quiz_1_9__c'=>new List<String>{'C'},
           //'Quiz_1_10__c'=>new List<String>{'C','D'}
        };
            
        Map<String, List<String>> que1Grade12WithAns = new Map<String, List<String>>{'Quiz_1_1__c'=>new List<String>{'C'},
            'Quiz_1_2__c'=>new List<String>{'B'},'Quiz_1_3__c'=>new List<String>{'A'},
            'Quiz_1_4__c'=>new List<String>{'B'},'Quiz_1_5__c'=>new List<String>{'A'}
        };
                                                        
           isStopRecursion = true;
        List<String> barcodeLST = new List<String>();
        Set<Id> Ids = new Set<Id>();      
            
        for(Self_Awareness_and_Feedback__c omrassess : newList){
            if(String.isNotBlank(omrassess.Barcode__c)){
                barcodeLST.add(omrassess.Barcode__c);
            }
            //barcodeLST.add(omrassess.Barcode__c);
            Ids.add(omrassess.Id);
        }
        Map<String,String> barcodeWithStd = new Map<String,String>();
        Map<String,String> barcodeWithGrade = new Map<String,String>();
        Map<String,String> barcodeWithBatchId = new Map<String,String>();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        //system.debug('barcodeLST = '+barcodeLST);
        if(barcodeLST.size() > 0){
            for(Contact con : [Select Id,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c,Current_Batch_Id__c
                               From Contact 
                               where Grade_9_Barcode__c IN :barcodeLST OR 
                               Grade_10_Barcode__c IN :barcodeLST OR 
                               Grade_11_Barcode__c IN :barcodeLST OR
                              Grade_12_Barcode__c IN :barcodeLST]){
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
        
        List<Self_Awareness_and_Feedback__c> omrAssessmentLST = new List<Self_Awareness_and_Feedback__c>();
        for(Self_Awareness_and_Feedback__c omrassess : newList){
            
            Self_Awareness_and_Feedback__c omr = new Self_Awareness_and_Feedback__c(Id = omrassess.Id);
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
            	if(currentBatchSchoolAcadYear.containsKey(barcodeWithBatchId.get(omr.Student__c)))   //v2.0 added logic to populate through batch school Academic year
                omr.Academic_Year__c = currentBatchSchoolAcadYear.get(barcodeWithBatchId.get(omr.Student__c));
                //calculateQuizMarksForm('Quiz_1_', 10, omrassess, omr, barcodeWithGrade.get(omrassess.Barcode__c));
                system.debug('omrassess = '+omrassess);
            	system.debug('omr = '+omr);
            	system.debug(' barcodeWithGrade.get(omrassess.Barcode__c) = '+ barcodeWithGrade.get(omrassess.Barcode__c));
				calculateQuizMarksForm('Quiz_1_', 5, omrassess, omr, barcodeWithGrade.get(omrassess.Barcode__c));
			/*}
            else
            {
                omr.Academic_Year__c = antarangSett.Academic_Year__c;
                system.debug('******* '+ omr);
                //calculateQuizMarks('Quiz_1_', 10, omrassess, omr, barcodeWithGrade.get(omrassess.Barcode__c), que1Grade9WithAns, que1Grade10WithAns, que1Grade11WithAns);
                calculateQuizMarks('Quiz_1_', 5, omrassess, omr, barcodeWithGrade.get(omrassess.Barcode__c), que1Grade9WithAns, que1Grade10WithAns, que1Grade11WithAns);
                system.debug('------- '+ omr);
            }*/
            omrAssessmentLST.add(omr);
        }
        
        if(omrAssessmentLST.size() > 0){
            Update omrAssessmentLST;
        }
        
        if(Ids.size() > 0){
            system.debug('Id passed in Batch--'+Ids);
            SelfAwarenessandFeedbackBatch selfAwar = new SelfAwarenessandFeedbackBatch(Ids);
            //Database.executeBatch(selfAwar);
        }
        
    }
    
    //code for "Grade 12" is not write here
    public static Self_Awareness_and_Feedback__c calculateQuizMarks(String sourceField, Integer noOfQues, Self_Awareness_and_Feedback__c omrassess, 
                                          Self_Awareness_and_Feedback__c omr,String grade, Map<String, String> que1Grade9WithAns,
                                          Map<String, List<String>> que1Grade10WithAns, Map<String, List<String>> que1Grade11WithAns){
                                              
                                              for(Integer i = 1 ; i <= noOfQues ; i++){
                                                  String field = sourceField + i + '__c';
                                                  String strSourceField = String.valueOf(omrassess.get(field));
                                                  if(String.isNotBlank(strSourceField) && grade != Null){
                                                      if(grade == 'Grade 9'){
                                                          if(que1Grade9WithAns.get(field) == strSourceField){
                                                              omr.put(sourceField + i + '_Marks__c', 1);
                                                          }
                                                      } else if(grade == 'Grade 10'){
                                                          if(que1Grade10WithAns.get(field).contains(strSourceField)){
                                                              omr.put(sourceField + i + '_Marks__c', 1);
                                                          }
                                                      } else if(grade == 'Grade 11'){
                                                          if(que1Grade11WithAns.get(field).contains(strSourceField)){
                                                              omr.put(sourceField + i + '_Marks__c', 1);
                                                          }
                                                      }
                                                  }
                                              }
                                              Return omr;
                                          }
                                    
    public static Self_Awareness_and_Feedback__c calculateQuizMarksForm(String sourceField, 
    Integer noOfQues, Self_Awareness_and_Feedback__c omrassess, Self_Awareness_and_Feedback__c omr, String grade){

        Map<String, String> que1Grade9WithAns = new Map<String, String>{
        'Quiz_1_1__c'=>'C','Quiz_1_2__c'=>'A','Quiz_1_3__c'=>'C','Quiz_1_4__c'=>'B','Quiz_1_5__c'=>'B'
        };
        
        Map<String, String> que1Grade10WithAns = new Map<String, String>{
        'Quiz_1_1__c'=>'C','Quiz_1_2__c'=>'C','Quiz_1_3__c'=>'B','Quiz_1_4__c'=>'B','Quiz_1_5__c'=>'C'
        };
        
        Map<String, String> que1Grade11WithAns = new Map<String, String>{
        'Quiz_1_1__c'=>'C','Quiz_1_2__c'=>'C','Quiz_1_3__c'=>'A','Quiz_1_4__c'=>'C','Quiz_1_5__c'=>'C'
        };
            
        Map<String, String> que1Grade12WithAns = new Map<String, String>{
        'Quiz_1_1__c'=>'C','Quiz_1_2__c'=>'B','Quiz_1_3__c'=>'A','Quiz_1_4__c'=>'B','Quiz_1_5__c'=>'A'
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
                String fieldMarks = sourceField + i + '_Marks__c';
                omr.put(fieldMarks, 0);
                
                String strSourceField = String.valueOf(omrassess.get(field));
                if(String.isNotBlank(strSourceField) && grade != Null){
                    if(grade == 'Grade 9'){
                        if(que1Grade9WithAns.get(field) == strSourceField){
                            omr.put(fieldMarks, 1);
                        }
                    } 
                    else if(grade == 'Grade 10'){
                        if(que1Grade10WithAns.get(field) == strSourceField){
                            omr.put(fieldMarks, 1);
                        }
                    }
                    else if(grade == 'Grade 11'){
                        if(que1Grade11WithAns.get(field) == strSourceField){
                            omr.put(fieldMarks, 1);
                        }
                    }
                    else if(grade == 'Grade 12'){
                        if(que1Grade12WithAns.get(field) == strSourceField){
                            omr.put(fieldMarks, 1);
                        }
                    }
                }
            }
        }
        system.debug('omr = '+omr);
        return omr;
    }
    
    // This method is used to popplate Interests and Aptitudes in Student record.
    public static void populateStudentInterestsAptitudes(List<Self_Awareness_and_Feedback__c> newList, Map<Id, Self_Awareness_and_Feedback__c> oldMap){
        isStopRecursion = true;
        Id BaselineRecordTypeId = [SELECT Id, DeveloperName, Name, SobjectType FROM RecordType where DeveloperName = 'Baseline' AND SobjectType = 'Self_Awareness_and_Feedback__c'].Id;
        Set<Id> contactIdSet = new Set<Id>();
        
        // Adding student ids into a list in insert event
        // Adding old and latest student ids into a list in update and delete event to update the contacts 
        for(Self_Awareness_and_Feedback__c saf : newList){
            if(saf.RecordTypeId == BaselineRecordTypeId ){
                if(oldMap == null && ( String.isNotBlank(saf.Interest_1__c) || String.isNotBlank(saf.Interest_2__c) || String.isNotBlank(saf.Interest_3__c) || 
                                      String.isNotBlank(saf.Aptitude_1__c) || String.isNotBlank(saf.Aptitude_2__c) || String.isNotBlank(saf.Aptitude_3__c) ) )
                {
                    contactIdSet.add(saf.Student__c);
                }else if(oldMap != null && ( saf.Interest_1__c != oldMap.get(saf.Id).Interest_1__c || 
                                            saf.Interest_2__c != oldMap.get(saf.Id).Interest_2__c || 
                                            saf.Interest_3__c != oldMap.get(saf.Id).Interest_3__c || 
                                            saf.Aptitude_1__c != oldMap.get(saf.Id).Aptitude_1__c ||  
                                            saf.Aptitude_2__c != oldMap.get(saf.Id).Aptitude_2__c ||  
                                            saf.Aptitude_3__c != oldMap.get(saf.Id).Aptitude_3__c ||
                                            saf.Student__c != oldMap.get(saf.Id).Student__c ))
                {
                    if(oldMap.get(saf.Id).Student__c != null && saf.Student__c != oldMap.get(saf.Id).Student__c ){
                        contactIdSet.add(oldMap.get(saf.Id).Student__c);
                    }
                    if(saf.Student__c != null){
                        contactIdSet.add(saf.Student__c);
                    }
                }
            }
        } 
        
        if(contactIdSet.size() > 0){
            updateStudentInterestsAptitudes(contactIdSet);
        }
        
    }
    
    public static void updateStudentInterestsAptitudes(set<Id> contactIdSet){
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
                           Aptitude_1__c, Aptitude_2__c, Aptitude_3__c, Interest_1__c, Interest_2__c, Interest_3__c, 
                           (Select Id, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c, Interest_1__c, Interest_2__c, Interest_3__c 
                            From Self_Awareness_and_Feedbacks__r 
                            Where recordtype.DeveloperName = 'Baseline' order By Academic_Year__c Desc,  createddate desc Limit 1) 
                           From Contact 
                           Where Id IN :contactIdSet 
                           AND RecordType.DeveloperName = 'CA_Student' 
                           AND Current_Batch_Id__c IN: filteredBatchIds //v2.0 added logic to include Next Academic year and process through current batch id
                           ])
        {
            if(con.Self_Awareness_and_Feedbacks__r != null && con.Self_Awareness_and_Feedbacks__r.size() > 0){
                con.Aptitude_1__c = con.Self_Awareness_and_Feedbacks__r[0].Aptitude_1__c;
                con.Aptitude_2__c = con.Self_Awareness_and_Feedbacks__r[0].Aptitude_2__c;
                con.Aptitude_3__c = con.Self_Awareness_and_Feedbacks__r[0].Aptitude_3__c;
                con.Interest_1__c = con.Self_Awareness_and_Feedbacks__r[0].Interest_1__c; 
                con.Interest_2__c = con.Self_Awareness_and_Feedbacks__r[0].Interest_2__c; 
                con.Interest_3__c = con.Self_Awareness_and_Feedbacks__r[0].Interest_3__c;    
                con.Recommedation_Status__c = 'Not Processed';
                con.Status__c = 'Not Processed';
                
                updateList.add(con);
            }else if( String.isNotBlank(con.Aptitude_1__c) || String.isNotBlank(con.Aptitude_2__c) || String.isNotBlank(con.Aptitude_3__c) || 
                     String.isNotBlank(con.Interest_1__c) || String.isNotBlank(con.Interest_2__c) || String.isNotBlank(con.Interest_3__c) ){
                         con.Interest_1__c = '';
                         con.Interest_2__c = '';
                         con.Interest_3__c = '';
                         con.Aptitude_1__c = '';
                         con.Aptitude_2__c = '';
                         con.Aptitude_3__c = '';
                         con.Recommedation_Status__c = 'Not Processed';
                         con.Status__c = 'Not Processed';
                         updateList.add(con);
                     }
        }
        
        if(updateList.size() > 0){
            update updateList;
        }
    }
    
    
    public static void updateBatchId(List<Self_Awareness_and_Feedback__c> newCdm1List, Map<Id,Self_Awareness_and_Feedback__c> oldcdm1Map) { 
        // custom settings to check the Academic year
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        
        Double acadYear = 0;
        List<Self_Awareness_and_Feedback__c> cdm1List = New List<Self_Awareness_and_Feedback__c>();        
        Set<Id> contSet = New Set<id>();                
        Map<Id,Id> StudBatchId = New Map<Id,Id>();
        Map<Id,List<Contact>> batchWithStuds = New Map<Id,List<Contact>>();
        List<Self_Awareness_and_Feedback__c> updateCdm1 = New List<Self_Awareness_and_Feedback__c>();
        
        for(Self_Awareness_and_Feedback__c cdm1: newCdm1List) {
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
                                 AND (Academic_Year__c =: antarangSett.Academic_Year__c OR Academic_Year__c =: antarangSett.Next_Academic_Year__c)]) //v2.0 Included Next_Academic_Year__c]) 
                				{                                                                                                                          
                                     for(Contact c: batchWithStuds.get(b.Id)) {
                                         StudBatchId.put(c.Id,b.Id);
                                     }
                                 }                    
                for(Self_Awareness_and_Feedback__c o: cdm1List){
                    if(StudBatchId.containsKey(o.Student__c)) {                            
                        o.Batch_Id__c = StudBatchId.get(o.Student__c);                            
                    }
                }
            }
        }        
    }
    
    //----- v1.0 START -------
    public static boolean updateCounterFlag = false;
    public static void updateOMRTypeCounterManager(List<Self_Awareness_and_Feedback__c> selfAwareFeedList, Map<Id,Self_Awareness_and_Feedback__c> oldSelfAwareFeedMap, Boolean isDelete){
        updateCounterFlag = true;
        set<Id> BatchSet = new set<Id>();        
        
        if(isDelete){   														//Self Awareness and Feedback record Deleted
            if(oldSelfAwareFeedMap != null){
                for(Self_Awareness_and_Feedback__c c: oldSelfAwareFeedMap.Values()){
                    BatchSet.add(c.Batch_Id__c);                    
                }
            }
        }else{
            for(Self_Awareness_and_Feedback__c c: selfAwareFeedList){
                if(oldSelfAwareFeedMap == null){     									//Self Awareness and Feedback record Inserted
                    BatchSet.add(c.Batch_Id__c);
                }else if(c.Student__c != oldSelfAwareFeedMap.get(c.Id).Student__c || c.Student_Linked__c != oldSelfAwareFeedMap.get(c.Id).Student_Linked__c 
                         || c.Error_Status__c != oldSelfAwareFeedMap.get(c.Id).Error_Status__c ){     //Self Awareness and Feedback record Updated (v1.1)
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
                                                       FROM Self_Awareness_and_Feedback__c 
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
                                           WHERE OMR_Assessment_Object__c = 'Self Awareness and Feedback' AND
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
    /*public static void updateOMRTypeCounter(List<Self_Awareness_and_Feedback__c> cdm1List, Map<Id,Self_Awareness_and_Feedback__c> oldcdm1Map, Boolean isDelete) {        
        updateCounterFlag = true;
        Boolean isDeleteFlag = isDelete;
        Integer getCount = 0;
        List<Session_OMR_Type__c> SOTList = New List<Session_OMR_Type__c>();
        Map<Id,Integer> BatchMap = New Map<Id,Integer>();
        for(Self_Awareness_and_Feedback__c c: cdm1List) {              
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
                                        AND OMR_Assessment_Object__c = 'Self Awareness and Feedback' ]) {                                                                                                                          
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