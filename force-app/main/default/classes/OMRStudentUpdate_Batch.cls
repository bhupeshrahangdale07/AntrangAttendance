//Batch class to Link OMR students and recalculation of marks.

public class OMRStudentUpdate_Batch Implements Database.batchable<sObject>, schedulable{
    public String query;
    public Map <String, Contact> Grade_9_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_10_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_11_Barcode_Map = New Map <String, Contact>();
    public String grade;
    
    Map<String, String> que1Grade9WithAns = new Map<String, String>{'Quiz_1_1__c'=>'B',
        'Quiz_1_2__c'=>'C','Quiz_1_3__c'=>'A','Quiz_1_4__c'=>'C','Quiz_1_5__c'=>'B','Quiz_1_6__c'=>'B','Quiz_1_7__c'=>'B',
        'Quiz_1_8__c'=>'C','Quiz_1_9__c'=>'D','Quiz_1_10__c'=>'B'};
            
            Map<String, List<String>> que1Grade10WithAns = new Map<String, List<String>>{'Quiz_1_1__c'=>new List<String>{'B'},
                'Quiz_1_2__c'=>new List<String>{'A'},'Quiz_1_3__c'=>new List<String>{'A','B'},'Quiz_1_4__c'=>new List<String>{'C','D'},
                    'Quiz_1_5__c'=>new List<String>{'C','D'},'Quiz_1_6__c'=>new List<String>{'A','B'},'Quiz_1_7__c'=>new List<String>{'C','D'},
                        'Quiz_1_8__c'=>new List<String>{'A','B'},'Quiz_1_9__c'=>new List<String>{'A','B'},'Quiz_1_10__c'=>new List<String>{'A'}};
                            
                            Map<String, List<String>> que1Grade11WithAns = new Map<String, List<String>>{'Quiz_1_1__c'=>new List<String>{'C'},
                                'Quiz_1_2__c'=>new List<String>{'A'},'Quiz_1_3__c'=>new List<String>{'B'},
                                    'Quiz_1_4__c'=>new List<String>{'B'},'Quiz_1_5__c'=>new List<String>{'D'},
                                        'Quiz_1_6__c'=>new List<String>{'C'},'Quiz_1_7__c'=>new List<String>{'A'},
                                            'Quiz_1_8__c'=>new List<String>{'B'},'Quiz_1_9__c'=>new List<String>{'C'},
                                                'Quiz_1_10__c'=>new List<String>{'C','D'}};
                                                    
                                                    Map<String, String> que2Grade9WithAns = new Map<String, String>{'Quiz_2_1__c'=>'B',
                                                        'Quiz_2_2__c'=>'C','Quiz_2_3__c'=>'A','Quiz_2_4__c'=>'C','Quiz_2_5__c'=>'B','Quiz_2_6__c'=>'B','Quiz_2_7__c'=>'B',
                                                        'Quiz_2_8__c'=>'B','Quiz_2_9__c'=>'D','Quiz_2_10__c'=>'D'};
                                                            
                                                            Map<String, List<String>> que2Grade11WithAns = new Map<String, List<String>>{'Quiz_2_1__c'=>new List<String>{'A'},
                                                                'Quiz_2_2__c'=>new List<String>{'C'},'Quiz_2_3__c'=>new List<String>{'D'},
                                                                    'Quiz_2_4__c'=>new List<String>{'C'},'Quiz_2_5__c'=>new List<String>{'C'},
                                                                        'Quiz_2_6__c'=>new List<String>{'B'},'Quiz_2_7__c'=>new List<String>{'C'},
                                                                            'Quiz_2_8__c'=>new List<String>{'B'},'Quiz_2_9__c'=>new List<String>{'C','D'},
                                                                                'Quiz_2_10__c'=>new List<String>{'C','D'}};                                                                                                                                
                                                                                    
                                                                                    //Start method
                                                                                    public Database.QueryLocator start(Database.BatchableContext BC){
                                                                                        Id RecTypeCA = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Student').getRecordTypeId();
                                                                                        if(String.isBlank(query)) {
                                                                                            query = 'SELECT Name, LastName, Id, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c from Contact WHERE RecordTypeId =: RecTypeCA AND (Grade_9_Barcode__c != Null OR Grade_10_Barcode__c != Null OR Grade_11_Barcode__c != Null)';            
                                                                                        }
                                                                                        return Database.getQueryLocator(query);
                                                                                    }
    
    //Execute Method
    public void execute(Database.BatchableContext BC, List<Contact> contList) {
        if(!contList.isEmpty()){
            For(Contact cont : contList){
                Grade_9_Barcode_Map.put(cont.Grade_9_Barcode__c, cont);
                Grade_10_Barcode_Map.put(cont.Grade_10_Barcode__c, cont);
                Grade_11_Barcode_Map.put(cont.Grade_11_Barcode__c, cont);
            } 
        }
        
        //CDM1
        List<OMR_Assessment__c> ListCDM1 = New List<OMR_Assessment__c>();
        For (OMR_Assessment__c cdm1 : [Select Id, Barcode__c, Student__c from OMR_Assessment__c where Student__c = Null AND Barcode__c != Null AND Created_from_Form__c = False AND (Barcode__c IN: Grade_11_Barcode_Map.keySet() OR Barcode__c IN: Grade_10_Barcode_Map.keySet() OR Barcode__c IN: Grade_9_Barcode_Map.keySet() )]){
            If(cdm1 != Null){
                If(Grade_9_Barcode_Map.containsKey(cdm1.Barcode__c)){
                    cdm1.Student__c = Grade_9_Barcode_Map.get(cdm1.Barcode__c).Id;
                }
                Else if(Grade_10_Barcode_Map.containsKey(cdm1.Barcode__c)){
                    cdm1.Student__c = Grade_10_Barcode_Map.get(cdm1.Barcode__c).Id;
                }
                Else if(Grade_11_Barcode_Map.containsKey(cdm1.Barcode__c)){
                    cdm1.Student__c = Grade_11_Barcode_Map.get(cdm1.Barcode__c).Id;
                }
                ListCDM1.add(cdm1);               
            }
        }
        If(!ListCDM1.isEmpty()){
            Update ListCDM1;
        }
        
        //CDM2
        List<CDM2__c> ListCDM2 = New List<CDM2__c>();
        For(CDM2__c cdm2 : [Select Id, Barcode__c, Student__c from CDM2__c where Student__c = Null AND Barcode__c != Null AND Created_from_Form__c = False AND (Barcode__c IN: Grade_11_Barcode_Map.keySet() OR Barcode__c IN: Grade_10_Barcode_Map.keySet() OR Barcode__c IN: Grade_9_Barcode_Map.keySet() )]){
            If(cdm2 != Null){
                If(Grade_9_Barcode_Map.containsKey(cdm2.Barcode__c)){
                    cdm2.Student__c = Grade_9_Barcode_Map.get(cdm2.Barcode__c).Id;
                }
                Else if(Grade_10_Barcode_Map.containsKey(cdm2.Barcode__c)){
                    cdm2.Student__c = Grade_10_Barcode_Map.get(cdm2.Barcode__c).Id;
                }
                Else if(Grade_11_Barcode_Map.containsKey(cdm2.Barcode__c)){
                    cdm2.Student__c = Grade_11_Barcode_Map.get(cdm2.Barcode__c).Id;
                }
                ListCDM2.add(cdm2);
            }
        }   
        If(!ListCDM2.isEmpty()){
            Update ListCDM2;
        }
        
        //Career Planning
        List<Career_Planning__c> CPList = New List<Career_Planning__c>();
        For(Career_Planning__c cp : [Select Id, Barcode__c, Student__c from Career_Planning__c where Student__c = Null AND Barcode__c != Null AND Created_from_Form__c = False AND (Barcode__c IN: Grade_11_Barcode_Map.keySet() OR Barcode__c IN: Grade_10_Barcode_Map.keySet() OR Barcode__c IN: Grade_9_Barcode_Map.keySet())]){
            If(cp != Null){
                If(Grade_9_Barcode_Map.containsKey(cp.Barcode__c)){
                    cp.Student__c = Grade_9_Barcode_Map.get(cp.Barcode__c).Id;
                }
                Else if(Grade_10_Barcode_Map.containsKey(cp.Barcode__c)){
                    cp.Student__c = Grade_10_Barcode_Map.get(cp.Barcode__c).Id;
                }
                Else if(Grade_11_Barcode_Map.containsKey(cp.Barcode__c)){
                    cp.Student__c = Grade_11_Barcode_Map.get(cp.Barcode__c).Id;
                }
                CPList.add(cp);
            }
        }
        If(!CPList.isEmpty()){
            Update CPList;
        }
        
        //Career Skill
        List<Career_Skill__c> CSList = New List<Career_Skill__c>();
        For(Career_Skill__c cs : [Select Id, Barcode__c, Student__c from Career_Skill__c where Student__c = Null AND Barcode__c != Null AND Created_from_Form__c = False AND (Barcode__c IN: Grade_11_Barcode_Map.keySet() OR Barcode__c IN: Grade_10_Barcode_Map.keySet() OR Barcode__c IN: Grade_9_Barcode_Map.keySet() )]){
            If(cs != Null){
                If(Grade_9_Barcode_Map.containsKey(cs.Barcode__c)){
                    cs.Student__c = Grade_9_Barcode_Map.get(cs.Barcode__c).Id;
                }
                Else if(Grade_10_Barcode_Map.containsKey(cs.Barcode__c)){
                    cs.Student__c = Grade_10_Barcode_Map.get(cs.Barcode__c).Id;
                }
                Else if(Grade_11_Barcode_Map.containsKey(cs.Barcode__c)){
                    cs.Student__c = Grade_11_Barcode_Map.get(cs.Barcode__c).Id;
                }
                CSList.add(cs);
            }
        }
        If(!CSList.isEmpty()){
            Update CSList;
        }
        
        //Future Planning
        List<Future_Planning__c> FPList = New List<Future_Planning__c>();
        For(Future_Planning__c fp : [Select Id, Barcode__c, Student__c from Future_Planning__c where Student__c = Null AND Barcode__c != Null AND Created_from_Form__c = False AND (Barcode__c IN: Grade_11_Barcode_Map.keySet() OR Barcode__c IN: Grade_10_Barcode_Map.keySet() OR Barcode__c IN: Grade_9_Barcode_Map.keySet() )]){
            If(fp != Null){
                If(Grade_9_Barcode_Map.containsKey(fp.Barcode__c)){
                    fp.Student__c = Grade_9_Barcode_Map.get(fp.Barcode__c).Id;
                }
                Else if(Grade_10_Barcode_Map.containsKey(fp.Barcode__c)){
                    fp.Student__c = Grade_10_Barcode_Map.get(fp.Barcode__c).Id;
                }
                Else if(Grade_11_Barcode_Map.containsKey(fp.Barcode__c)){
                    fp.Student__c = Grade_11_Barcode_Map.get(fp.Barcode__c).Id;
                }
                FPList.add(fp);
            }
        }
        If(!FPList.isEmpty()){
            Update FPList;
        }
        
        //Self Awareness & Feedback
        List<Self_Awareness_and_Feedback__c> SAFList = New List<Self_Awareness_and_Feedback__c>();
        List<Self_Awareness_and_Feedback__c> omrAssessmentLST = new List<Self_Awareness_and_Feedback__c>();
        For(Self_Awareness_and_Feedback__c saf : [Select Id, Barcode__c, Student__c, Quiz_1_1__c, Quiz_1_2__c, 
                                                  Quiz_1_3__c, Quiz_1_4__c, Quiz_1_5__c, Quiz_1_6__c, Quiz_1_7__c, Quiz_1_8__c, 
                                                  Quiz_1_9__c, Quiz_1_10__c, Quiz_1_1_Marks__c, Quiz_1_10_Marks__c, Quiz_1_2_Marks__c, 
                                                  Quiz_1_3_Marks__c, Quiz_1_4_Marks__c, Quiz_1_5_Marks__c, Quiz_1_6_Marks__c, Quiz_1_7_Marks__c, 
                                                  Quiz_1_8_Marks__c, Quiz_1_9_Marks__c from Self_Awareness_and_Feedback__c 
                                                  where Student__c = Null AND Barcode__c != Null AND Created_from_Form__c = False
                                                 AND (Barcode__c IN: Grade_11_Barcode_Map.keySet() 
                                                      OR Barcode__c IN: Grade_10_Barcode_Map.keySet() 
                                                      OR Barcode__c IN: Grade_9_Barcode_Map.keySet())]){
                                                      
                                                      If(saf != Null){
                                                          If(Grade_9_Barcode_Map.containsKey(saf.Barcode__c)){
                                                              saf.Student__c = Grade_9_Barcode_Map.get(saf.Barcode__c).Id;
                                                              grade = 'Grade 9';
                                                          }
                                                          Else if(Grade_10_Barcode_Map.containsKey(saf.Barcode__c)){
                                                              saf.Student__c = Grade_10_Barcode_Map.get(saf.Barcode__c).Id;
                                                              grade = 'Grade 10';
                                                          }
                                                          Else if(Grade_11_Barcode_Map.containsKey(saf.Barcode__c)){
                                                              saf.Student__c = Grade_11_Barcode_Map.get(saf.Barcode__c).Id;
                                                              grade = 'Grade 11';
                                                          }
                                                          Self_Awareness_and_Feedback__c omrassess = saf;
                                                          Self_Awareness_and_Feedback__c omr = saf; 
                                                          omrAssessmentLST.add(SelfAwarenessandFeedbackTriggerHandler.calculateQuizMarks('Quiz_1_', 10, omrassess, omr, grade, que1Grade9WithAns, que1Grade10WithAns, que1Grade11WithAns));                                                        
                                                      }
                                                  }
        system.debug('SAFList '+ SAFList);
        If(!omrAssessmentLST.isEmpty() && omrAssessmentLST.size() > 0){
            // Update SAFList;            
            
            update omrAssessmentLST;
        }
        
        //Self Awareness Realities        
        List<Self_Awareness_Realities__c> SARList = New List<Self_Awareness_Realities__c>();
        Map<String, String> stuGrade = New Map<String, String>();
        List<Self_Awareness_Realities__c> omrRealities = New List<Self_Awareness_Realities__c>();
        For(Self_Awareness_Realities__c sar : [Select Id, Barcode__c, Student__c, Quiz_2_1__c, Quiz_2_2__c, Quiz_2_3__c, Quiz_2_4__c, 
                                               Quiz_2_5__c, Quiz_2_6__c, Quiz_2_7__c, Quiz_2_8__c, Quiz_2_10__c, Quiz_2_9__c, Quiz_2_1_Marks__c, 
                                               Quiz_2_2_Marks__c, Quiz_2_3_Marks__c, Quiz_2_4_Marks__c, Quiz_2_5_Marks__c, Quiz_2_6_Marks__c, 
                                               Quiz_2_7_Marks__c, Quiz_2_8_Marks__c, Quiz_2_9_Marks__c, Quiz_2_10_Marks__c 
                                               from Self_Awareness_Realities__c where Student__c = Null AND Barcode__c != Null AND Created_from_Form__c = False
                                              AND (Barcode__c IN: Grade_11_Barcode_Map.keySet() 
                                                   OR Barcode__c IN: Grade_10_Barcode_Map.keySet() 
                                                   OR Barcode__c IN: Grade_9_Barcode_Map.keySet() )]){
                                                   If(sar != Null){
                                                       If(Grade_9_Barcode_Map.containsKey(sar.Barcode__c)){
                                                           sar.Student__c = Grade_9_Barcode_Map.get(sar.Barcode__c).Id;
                                                           grade = 'Grade 9';
                                                           stuGrade.put(sar.Student__c, 'Grade 9');
                                                       }
                                                       Else if(Grade_10_Barcode_Map.containsKey(sar.Barcode__c)){
                                                           sar.Student__c = Grade_10_Barcode_Map.get(sar.Barcode__c).Id;
                                                           grade = 'Grade 10';
                                                           stuGrade.put(sar.Student__c, 'Grade 10');
                                                       }
                                                       Else if(Grade_11_Barcode_Map.containsKey(sar.Barcode__c)){
                                                           sar.Student__c = Grade_11_Barcode_Map.get(sar.Barcode__c).Id;
                                                           grade = 'Grade 11';
                                                           stuGrade.put(sar.Student__c, 'Grade 11');
                                                       }
                                                       Self_Awareness_Realities__c omrassess = sar;
                                                       Self_Awareness_Realities__c omr = sar;
                                                       if(stuGrade.containsKey(sar.Student__c) && stuGrade.get(sar.Student__c) != 'Grade 10'){
                                                           omrRealities.add(SelfAwarenessRealitiesTriggerHandler.calculateQuizMarks('Quiz_2_', 10, omrassess, omr, grade, que2Grade9WithAns, que2Grade11WithAns));                                                                                 
                                                       }Else{
                                                           omrRealities.add(omr);
                                                       } 
                                                   }
                                               }
        If(!omrRealities.isEmpty() && omrRealities.size() > 0){
            Update omrRealities;
        }
    }
    
    
    // finish method  
    public void finish(Database.BatchableContext BC){  
        
    }
    
    //schedule class method
    public void execute(SchedulableContext sc){
        OMRStudentUpdate_Batch OMRStudent = new OMRStudentUpdate_Batch();
        Id bprId = Database.executeBatch(OMRStudent, 50);
    }
}