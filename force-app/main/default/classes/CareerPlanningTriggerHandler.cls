/*
 * Classname: CareerPlanningTriggerHandler
 * Description : Handler class for CareerPlanningTrigger
 * -------------------------------------------------------------------------------------------------------------------------
 * History
 * Version	Date			Description
 * v1.1 	29th Sept 23	Updated logic for OMR Assessment Count (Considered change in Error Status)
 * v2.0     28th feb 24     Added logic to populate academic year from current batch school academic year instead of antarang settings and included setting Next Academic Year in the query
 */ 
public class CareerPlanningTriggerHandler {

    public static boolean isStopRecursion = false;
    
    public static void calculateCareerPlanningMarksNew(List<Career_Planning__c> newList){
        //isStopRecursion = true;
        
        List<String> barcodeLST = new List<String>();
        
        for(Career_Planning__c omrassess : newList){
             if(String.isNotBlank(omrassess.Barcode__c)){
                barcodeLST.add(omrassess.Barcode__c);
            }
            //barcodeLST.add(omrassess.Barcode__c);
        }
        Map<String,String> barcodeWithStd = new Map<String,String>();
        Map<String,String> barcodeWithGrade = new Map<String,String>(); 
        Map<String,String> barcodeWithBatchId = new Map<String,String>(); 
		AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        
        if(barcodeLST.size() > 0){
            for(Contact con : [Select Id,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c,Current_Batch_Id__c From Contact 
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
                                   }else if(barcodeLST.contains(con.Grade_12_Barcode__c)){
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
            //if(barcodeWithStd.size() > 0){
                List<Career_Planning__c> omrAssessmentLST = new List<Career_Planning__c>();
                List<String> acceptedAnsForQue8 = new List<String>{'A','B','C','D','E','F'};
                for(Career_Planning__c omrassess : newList){
                    //Career_Planning__c omr = new Career_Planning__c(Id = omrassess.Id);
                    /*if(String.isBlank(omrassess.Barcode__c)){
                        omrassess.Error_Status__c = 'Missing Barcode. ';
                    }*/
                    
                    /*if(omrassess.Created_from_Form__c){
                        omrassess.Academic_Year__c = antarangSett.Next_Academic_Year__c;
                    }else{
                        omrassess.Academic_Year__c = antarangSett.Academic_Year__c;
                    }*/
                    
                    //if(!omrassess.Created_from_Form__c)
                    //{
                    if(barcodeWithStd.containsKey(omrassess.Barcode__c)){
                        omrassess.Student__c = barcodeWithStd.get(omrassess.Barcode__c);
                        omrassess.Grade__c = barcodeWithGrade.get(omrassess.Barcode__c);
                        omrassess.Error_Status__c = 'No Error';
                        omrassess.Batch_Id__c = barcodeWithBatchId.get(omrassess.Student__c);	//updated on 07.07.2023 for OMR Type Counter
                    }else{
                        omrassess.Grade__c = null;
                        omrassess.Error_Status__c = 'Student not found';
                    } 
                    
                    if(currentBatchSchoolAcadYear.containsKey(barcodeWithBatchId.get(omrassess.Student__c)))   //v2.0 added logic to populate through batch school Academic year
                        omrassess.Academic_Year__c = currentBatchSchoolAcadYear.get(barcodeWithBatchId.get(omrassess.Student__c));
                    
                    //}else{
                     //    omrassess.Academic_Year__c = antarangSett.Next_Academic_Year__c;
                    //}
                    
                    if(String.isNotBlank(omrassess.Q_7__c) && omrassess.Q_7__c == 'B'){
                        omrassess.Q_7_Marks__c = 1;
                    } 
                    
                    if(String.isNotBlank(omrassess.Q_8__c) && acceptedAnsForQue8.contains(omrassess.Q_8__c)){
                        omrassess.Q_8_Marks__c = 1;
                    } else if(String.isNotBlank(omrassess.Q_8__c) && omrassess.Q_8__c == 'K'){
                        omrassess.Q_8_Marks__c = 0.5;
                    }
                    
                    calculateMarksForQ9('Q_9_', 7, omrassess, omrassess);
                    
                    if(String.isNotBlank(omrassess.Q_10__c) && omrassess.Q_10__c == 'B'){
                        omrassess.Q_10_Marks__c = 0.5;
                    } else if(String.isNotBlank(omrassess.Q_10__c) && (omrassess.Q_10__c == 'C' || omrassess.Q_10__c == 'D' || omrassess.Q_10__c == 'E')){
                        omrassess.Q_10_Marks__c = 1;
                    }
                   // omrAssessmentLST.add(omr);
               // }
                
            //}
        }
    }
    
    public static void calculateCareerPlanningMarks(List<Career_Planning__c> newList){
        isStopRecursion = true;
        
        List<String> barcodeLST = new List<String>();
        
        for(Career_Planning__c omrassess : newList){
             if(String.isNotBlank(omrassess.Barcode__c)){
                barcodeLST.add(omrassess.Barcode__c);
            }
            //barcodeLST.add(omrassess.Barcode__c);
        }
        Map<String,String> barcodeWithStd = new Map<String,String>();
        Map<String,String> barcodeWithGrade = new Map<String,String>(); 
        Map<String,String> barcodeWithBatchId = new Map<String,String>();
		AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        
        if(barcodeLST.size() > 0){
            for(Contact con : [Select Id,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c,Current_Batch_Id__c From Contact 
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
            If(barcodeWithBatchId.size() > 0 ){
                for(Batch__c bt : [Select Id,School_Name__c,School_Name__r.Academic_Year__c from batch__c where Id in: barcodeWithBatchId.Values()]){
                    if(bt.School_Name__c != null && bt.School_Name__r.Academic_Year__c != null) 
                        currentBatchSchoolAcadYear.put(bt.Id, bt.School_Name__r.Academic_Year__c);
                }
            }
            if(barcodeWithStd.size() > 0){
                List<Career_Planning__c> omrAssessmentLST = new List<Career_Planning__c>();
                List<String> acceptedAnsForQue8 = new List<String>{'A','B','C','D','E','F'};
                for(Career_Planning__c omrassess : newList){
                    Career_Planning__c omr = new Career_Planning__c(Id = omrassess.Id);

                    //if(!omrassess.Created_from_Form__c)
                    //{
                        if(barcodeWithStd.containsKey(omrassess.Barcode__c)){
                            omr.Student__c = barcodeWithStd.get(omrassess.Barcode__c);
                            omr.Grade__c = barcodeWithGrade.get(omrassess.Barcode__c);
                            //omr.Academic_Year__c = antarangSett.Academic_Year__c;
                            omr.Error_Status__c = 'No Error';
                            omr.Batch_Id__c = barcodeWithBatchId.get(omrassess.Student__c);
                        }else{
                            omr.Grade__c = null;
                            omr.Error_Status__c = 'Student not found';
                        }
                    //}else{
                      //   omr.Academic_Year__c = antarangSett.Next_Academic_Year__c;
                    //}
                    if(currentBatchSchoolAcadYear.containsKey(barcodeWithBatchId.get(omr.Student__c)))   //v2.0 added logic to populate through batch school Academic year
                        omr.Academic_Year__c = currentBatchSchoolAcadYear.get(barcodeWithBatchId.get(omr.Student__c));
                    
                    if(String.isNotBlank(omrassess.Q_7__c) && omrassess.Q_7__c == 'B'){
                        omr.Q_7_Marks__c = 1;
                    } 
                    
                    if(String.isNotBlank(omrassess.Q_8__c) && acceptedAnsForQue8.contains(omrassess.Q_8__c)){
                        omr.Q_8_Marks__c = 1;
                    } else if(String.isNotBlank(omrassess.Q_8__c) && omrassess.Q_8__c == 'K'){
                        omr.Q_8_Marks__c = 0.5;
                    }
                    
                    calculateMarksForQ9('Q_9_', 7, omrassess, omr);
                    
                    if(String.isNotBlank(omrassess.Q_10__c) && omrassess.Q_10__c == 'B'){
                        omr.Q_10_Marks__c = 0.5;
                    } else if(String.isNotBlank(omrassess.Q_10__c) && (omrassess.Q_10__c == 'C' || omrassess.Q_10__c == 'D' || omrassess.Q_10__c == 'E')){
                        omr.Q_10_Marks__c = 1;
                    }
                    omrAssessmentLST.add(omr);
                }
                if(omrAssessmentLST.size() > 0){
                    Update omrAssessmentLST;
                }
            }
        }
    }
    
    public static void calculateMarksForQ9(String sourceField, Integer noOfQues, Career_Planning__c omrassess, Career_Planning__c omr){
        List<String> expectedAns = new List<String>{'A','B'};
        for(Integer i = 1 ; i <= noOfQues ; i++){
            String field = sourceField + i + '__c';
            String strSourceField = String.valueOf(omrassess.get(field));
            if(String.isNotBlank(strSourceField) && expectedAns.contains(strSourceField)){
				omr.put(sourceField + i + '_Marks__c', 1);
            }
        }
    }
    
    
    public static void updateBatchId(List<Career_Planning__c> newCdm1List, Map<Id,Career_Planning__c> oldcdm1Map) {
		// custom settings to check the Academic year
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        
        Double acadYear = 0;
        List<Career_Planning__c> cdm1List = New List<Career_Planning__c>();        
        Set<Id> contSet = New Set<id>();                
        Map<Id,Id> StudBatchId = New Map<Id,Id>();
        Map<Id,List<Contact>> batchWithStuds = New Map<Id,List<Contact>>();
        List<Career_Planning__c> updateCdm1 = New List<Career_Planning__c>();
        
        for(Career_Planning__c cdm1: newCdm1List) {
            if(oldcdm1Map == null || (oldcdm1Map !=null && cdm1.Student__c != oldcdm1Map.get(cdm1.Id).Student__c)) {                
               // acadYear = cdm1.Academic_Year__c;                
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
                                 AND (Academic_Year__c =: antarangSett.Academic_Year__c OR Academic_Year__c =: antarangSett.Next_Academic_Year__c)]) //v2.0 Included Next_Academic_Year__c
                				{
                                     for(Contact c: batchWithStuds.get(b.Id)) {
                                         StudBatchId.put(c.Id,b.Id);
                                     }
                                 }                    
                for(Career_Planning__c o: cdm1List){
                    if(StudBatchId.containsKey(o.Student__c)) {                            
                        o.Batch_Id__c = StudBatchId.get(o.Student__c);                            
                    }
                }
            }
        }        
    }
    
    
    //----- v1.0 START ------- 
    public static boolean updateCounterFlag = false;
    public static void updateOMRTypeCounterManager(List<Career_Planning__c> careerPlanList, Map<Id,Career_Planning__c> oldCareerPlanMap, Boolean isDelete){
        updateCounterFlag = true;
        set<Id> BaselineBatchSet = new set<Id>();
        set<Id> EndlineBatchSet = new set<Id>();
        Id baselineRTID = Schema.SObjectType.Career_Planning__c.getRecordTypeInfosByName().get('Baseline').getRecordTypeId();
        Id endlineRTID = Schema.SObjectType.Career_Planning__c.getRecordTypeInfosByName().get('Endline').getRecordTypeId();
        
        if(isDelete){   														//Career_Planning__c record Deleted
            if(oldCareerPlanMap != null){
                for(Career_Planning__c c: oldCareerPlanMap.Values()){
                    if(c.RecordTypeId == baselineRTID){
                        BaselineBatchSet.add(c.Batch_Id__c);
                    }else if(c.RecordTypeId == endlineRTID){
                        EndlineBatchSet.add(c.Batch_Id__c);
                    }
                    
                }
            }
        }else{
            for(Career_Planning__c c: careerPlanList){
                if(oldCareerPlanMap == null){     									//Career_Planning__c record Inserted
                    if(c.RecordTypeId == baselineRTID){
                        BaselineBatchSet.add(c.Batch_Id__c);
                    }else if(c.RecordTypeId == endlineRTID){
                        EndlineBatchSet.add(c.Batch_Id__c);
                    }
                }else if(c.Student__c != oldCareerPlanMap.get(c.Id).Student__c || c.Student_Linked__c != oldCareerPlanMap.get(c.Id).Student_Linked__c
                        || c.Error_Status__c != oldCareerPlanMap.get(c.Id).Error_Status__c ){     //Career Planning record Updated (v1.1)
                    if(c.RecordTypeId == baselineRTID){
                        BaselineBatchSet.add(c.Batch_Id__c);
                    }else if(c.RecordTypeId == endlineRTID){
                        EndlineBatchSet.add(c.Batch_Id__c);
                    }
                }
            }
        }
        if(BaselineBatchSet.size() > 0 || EndlineBatchSet.size() > 0){
            updateOMRTypeCounter(BaselineBatchSet, EndlineBatchSet);
        }        
    }
    
    public static void updateOMRTypeCounter(set<Id> BaselineBatchSet, set<Id> EndlineBatchSet){
        List<Session_OMR_Type__c> SOTList = New List<Session_OMR_Type__c>();
        Map<Id,Integer> BaselineCounterMap = New Map<Id,Integer>();
        Map<Id,Integer> EndlineCounterMap = New Map<Id,Integer>();
        Id baselineRTID = Schema.SObjectType.Career_Planning__c.getRecordTypeInfosByName().get('Baseline').getRecordTypeId();
        Id endlineRTID = Schema.SObjectType.Career_Planning__c.getRecordTypeInfosByName().get('Endline').getRecordTypeId();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();

        
        if(!BaselineBatchSet.isEmpty() && BaselineBatchSet.size() > 0){
            AggregateResult[] groupedBatchResults   = [SELECT COUNT(Id), Batch_Id__c 
                                                       FROM Career_Planning__c 
                                                       WHERE RecordTypeId =: baselineRTID AND 
                                                       Batch_Id__c IN: BaselineBatchSet AND 
                                                       Student__c != null AND 
                                                       Academic_Year__c =: antarangSett.Academic_Year__c AND 
                                                       Error_Status__c = 'No Error'  
                                                       GROUP BY Batch_Id__c];
            for (AggregateResult ar : groupedBatchResults)  {
                 BaselineCounterMap.put((Id)ar.get('Batch_Id__c'), (Integer)ar.get('expr0'));
            }
        }
        if(!EndlineBatchSet.isEmpty() && EndlineBatchSet.size() > 0){
            AggregateResult[] groupedBatchResults   = [SELECT COUNT(Id), Batch_Id__c 
                                                       FROM Career_Planning__c 
                                                       WHERE RecordTypeId =: endlineRTID AND 
                                                       Batch_Id__c IN: EndlineBatchSet AND 
                                                       Student__c != null AND 
                                                       Academic_Year__c =: antarangSett.Academic_Year__c AND 
                                                       Error_Status__c = 'No Error'  
                                                       GROUP BY Batch_Id__c];
            for (AggregateResult ar : groupedBatchResults)  {
                 EndlineCounterMap.put((Id)ar.get('Batch_Id__c'), (Integer)ar.get('expr0'));
            }
        }
        
        for(Session_OMR_Type__c sot : [SELECT Id, OMR_Assessment_Record_Type__c, Session_Batch_Id__c
                                       FROM Session_OMR_Type__c
									   WHERE OMR_Assessment_Object__c = 'Career Planning' AND
                                       (Session_Batch_Id__c IN: BaselineBatchSet OR Session_Batch_Id__c IN: EndlineBatchSet) AND 
                                       OMR_Assessment_Record_Type__c IN ('Baseline', 'Endline')])
        {
            if(sot.OMR_Assessment_Record_Type__c == 'Baseline' && BaselineCounterMap.ContainsKey(sot.Session_Batch_Id__c)){
                SOTList.add(new Session_OMR_Type__c(Id = sot.Id, OMR_Assessment_Count__c = BaselineCounterMap.get(sot.Session_Batch_Id__c)));
                
            }else if(sot.OMR_Assessment_Record_Type__c == 'Endline' && EndlineCounterMap.ContainsKey(sot.Session_Batch_Id__c)){
                SOTList.add(new Session_OMR_Type__c(Id = sot.Id, OMR_Assessment_Count__c = EndlineCounterMap.get(sot.Session_Batch_Id__c)));
            }
            
        }
        
        if(SOTList.size() > 0){
            Update SOTList;
        }
    }
    //----- v1.0 END ------- 
    
    //----Old Method start----
/*    public static void updateOMRTypeCounter(List<Career_Planning__c> cdm1List, Map<Id,Career_Planning__c> oldcdm1Map, Boolean isDelete) {        
        updateCounterFlag = true;
        Boolean isDeleteFlag = isDelete;
        Integer getCount = 0;
        List<Session_OMR_Type__c> SOTList = New List<Session_OMR_Type__c>();
        Map<Id,Integer> BaselineBatchMap = New Map<Id,Integer>();
        Map<Id,Integer> EndlineBatchMap = New Map<Id,Integer>();
        Id baselineRTID = Schema.SObjectType.Career_Planning__c.getRecordTypeInfosByName().get('Baseline').getRecordTypeId();
        Id endlineRTID = Schema.SObjectType.Career_Planning__c.getRecordTypeInfosByName().get('Endline').getRecordTypeId();              
        
        for(Career_Planning__c c: cdm1List) {              
            If((isDeleteFlag == false && oldcdm1Map == null && c.Error_Status__c != 'Duplicate Entry') ||	//on Insert
               (oldcdm1Map != null && c.Error_Status__c != oldcdm1Map.get(c.Id).Error_Status__c && c.Error_Status__c != 'Duplicate Entry' && oldcdm1Map.get(c.Id).Error_Status__c == 'Duplicate Entry')) {                                   
                   if(c.RecordTypeId == baselineRTID) {                       
                       if(!BaselineBatchMap.containsKey(c.Batch_Id__c)) {
                           BaselineBatchMap.put(c.Batch_Id__c,1);                           
                       }
                       else {
                           getCount = BaselineBatchMap.get(c.Batch_Id__c);
                           BaselineBatchMap.put(c.Batch_Id__c,getCount+1);
                       }                                                                
                   } else if(c.RecordTypeId == endlineRTID) {                       
                       if(!EndlineBatchMap.containsKey(c.Batch_Id__c)) {
                           EndlineBatchMap.put(c.Batch_Id__c,1);                           
                       }
                       else {
                           getCount = EndlineBatchMap.get(c.Batch_Id__c);
                           EndlineBatchMap.put(c.Batch_Id__c,getCount+1);
                       } 
                   }  
                   
               } else if( isDeleteFlag == true || 
                         (oldcdm1Map != null && c.Error_Status__c != oldcdm1Map.get(c.Id).Error_Status__c && c.Error_Status__c == 'Duplicate Entry' && oldcdm1Map.get(c.Id).Error_Status__c != 'Duplicate Entry')) {                                                
                             if(c.RecordTypeId == baselineRTID) {                       
                                 if(!BaselineBatchMap.containsKey(c.Batch_Id__c)) {
                                     BaselineBatchMap.put(c.Batch_Id__c,-1);                           
                                 }
                                 else {
                                     getCount = BaselineBatchMap.get(c.Batch_Id__c);
                                     BaselineBatchMap.put(c.Batch_Id__c,getCount-1);
                                 }                                                                
                             } else if(c.RecordTypeId == endlineRTID) {                       
                                 if(!EndlineBatchMap.containsKey(c.Batch_Id__c)) {
                                     EndlineBatchMap.put(c.Batch_Id__c,-1);                           
                                 }
                                 else {
                                     getCount = EndlineBatchMap.get(c.Batch_Id__c);
                                     EndlineBatchMap.put(c.Batch_Id__c,getCount-1);
                                 } 
                             } 
                         }            
        }
        if(BaselineBatchMap.size()>0) {            
            for(Session_OMR_Type__c s: [Select id, name, OMR_Type__c, Session__r.name, Session__r.Session_Grade__c, OMR_Assessment_Count__c, Session_Batch_Id__c, Session__r.Batch__c
                                        From Session_OMR_Type__c 
                                        Where Session__r.Batch__c  IN: BaselineBatchMap.KeySet() 
                                        AND OMR_Assessment_Object__c = 'Career Planning' 
                                        And OMR_Assessment_Record_Type__c = 'Baseline']) {                                           
                                            if(BaselineBatchMap.containsKey(s.Session_Batch_Id__c)) {
                                                s.OMR_Assessment_Count__c = s.OMR_Assessment_Count__c + BaselineBatchMap.get(s.Session_Batch_Id__c);
                                                SOTList.add(s);
                                            }                                
                                        }
        }
        if(EndlineBatchMap.size()>0) {
            for(Session_OMR_Type__c s:[Select id, name, OMR_Type__c, Session__r.name, Session__r.Session_Grade__c, OMR_Assessment_Count__c, Session_Batch_Id__c
                                       From Session_OMR_Type__c 
                                       Where Session__r.Batch__c  IN: EndlineBatchMap.KeySet() 
                                       AND OMR_Assessment_Object__c = 'Career Planning' 
                                       And OMR_Assessment_Record_Type__c = 'Endline']) {
                                           if(EndlineBatchMap.containsKey(s.Session_Batch_Id__c)) {
                                                s.OMR_Assessment_Count__c = s.OMR_Assessment_Count__c + EndlineBatchMap.get(s.Session_Batch_Id__c);
                                                SOTList.add(s);
                                            }  
                                       }
        }
        if(SOTList.size()>0) {
            update SOTList;
        }
    } */
    //----Old Method end----
}