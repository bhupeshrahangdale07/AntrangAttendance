/*
 * Classname: cdm2TriggerHandler
 * Description : Handler class for cdm2Trigger
 * -------------------------------------------------------------------------------------------------------------------------
 * History
 * Version	Date			Description
 * v1.1 	29th Sept 23	Updated logic for OMR Assessment Count (Considered change in Error Status)
 * v2.0     28th feb 24     Added logic to populate academic year from current batch school academic year instead of antarang settings and included setting Next Academic Year in the query
 */ 

public class cdm2TriggerHandler {
    public static void populateStudentOnCDM2New(List<CDM2__c> newList){
       // isStopRecursion = true;
        
        system.debug('$$$ List<CDM2__c> newList: ' + newList);                                
        List<String> barcodeLST = new List<String>();
        for(CDM2__c omrassess : newList){
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
        }
       
        If(barcodeWithBatchId.size() > 0 ){
            for(Batch__c bt : [Select Id,School_Name__c,School_Name__r.Academic_Year__c from batch__c where Id in: barcodeWithBatchId.Values()]){
                if(bt.School_Name__c != null && bt.School_Name__r.Academic_Year__c != null) 
                    currentBatchSchoolAcadYear.put(bt.Id, bt.School_Name__r.Academic_Year__c);
             }
        }
        
        List<CDM2__c> cdm2LST = new List<CDM2__c>();
        for(CDM2__c cdm2 : newList){
            /* if(String.isBlank(cdm2.Barcode__c)){
                cdm2.Error_Status__c = 'Missing Barcode. ';
            } */
            //CDM2__c omr = new CDM2__c(Id = cdm2.Id);
            
            /*if(cdm2.Created_from_Form__c){
                cdm2.Academic_Year__c = antarangSett.Next_Academic_Year__c;
            }else{
                cdm2.Academic_Year__c = antarangSett.Academic_Year__c;
            }*/
            
            
            if(barcodeWithStd.size() > 0 && barcodeWithStd.containsKey(cdm2.Barcode__c)){
                cdm2.Student__c = barcodeWithStd.get(cdm2.Barcode__c);
                cdm2.Grade__c = barcodeWithGrade.get(cdm2.Barcode__c);
                cdm2.Batch_Id__c = barcodeWithBatchId.get(cdm2.Student__c);	//updated on 07.07.2023 for OMR Type Counter
                cdm2.Error_Status__c = 'No Error';
            }else{
                cdm2.Grade__c = null;
                cdm2.Error_Status__c = 'Student not found';
            }
            
            if(currentBatchSchoolAcadYear.containsKey(barcodeWithBatchId.get(cdm2.Student__c)))   //v2.0 added logic to populate through batch school Academic year
                cdm2.Academic_Year__c = currentBatchSchoolAcadYear.get(barcodeWithBatchId.get(cdm2.Student__c));
            
            if(String.isNotBlank(cdm2.Q5__c) && (cdm2.Q5__c == 'A' || cdm2.Q5__c == 'B' || cdm2.Q5__c == 'C')){
                cdm2.X5_Confident_about_chosen_career__c = 1;
            } else {
                cdm2.X5_Confident_about_chosen_career__c = 0;
            }
            
            //if(cdm2.Created_from_Form__c)
            //{
                calculateMarksForm('Q6_', 'X6_Options_that_fit_into_Industry__c', 12, cdm2, cdm2);
            /*}
            else
            {
                calculateMarks('Q6_', 'X6_Options_that_fit_into_Industry__c', 12, cdm2, cdm2);
            }*/
            
           // cdm2LST.add(omr);
        }
        
    }
    
    public static boolean isStopRecursion = false;
    public static void populateStudentOnCDM2(List<CDM2__c> newList){
        isStopRecursion = true;
        
                                        
        List<String> barcodeLST = new List<String>();
        for(CDM2__c omrassess : newList){
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
        }
        If(barcodeWithBatchId.size() > 0 ){
            for(Batch__c bt : [Select Id,School_Name__c,School_Name__r.Academic_Year__c from batch__c where Id in: barcodeWithBatchId.Values()]){
                if(bt.School_Name__c != null && bt.School_Name__r.Academic_Year__c != null) 
                    currentBatchSchoolAcadYear.put(bt.Id, bt.School_Name__r.Academic_Year__c);
            }
        }
        List<CDM2__c> cdm2LST = new List<CDM2__c>();
        for(CDM2__c cdm2 : newList){
            CDM2__c omr = new CDM2__c(Id = cdm2.Id);
            
            /*if(cdm2.Created_from_Form__c){
                omr.Academic_Year__c = antarangSett.Next_Academic_Year__c;
            }else{
                omr.Academic_Year__c = antarangSett.Academic_Year__c;
            }*/
            
            
            if(barcodeWithStd.size() > 0 && barcodeWithStd.containsKey(cdm2.Barcode__c)){
                omr.Student__c = barcodeWithStd.get(cdm2.Barcode__c);
                omr.Grade__c = barcodeWithGrade.get(cdm2.Barcode__c);
                omr.Error_Status__c = 'No Error';
                omr.Batch_Id__c = barcodeWithBatchId.get(cdm2.Student__c);
            }else{
                omr.Grade__c = null;
                omr.Error_Status__c = 'Student not found';
            }
            if(currentBatchSchoolAcadYear.containsKey(barcodeWithBatchId.get(omr.Student__c)))   //v2.0 added logic to populate through batch school Academic year
                omr.Academic_Year__c = currentBatchSchoolAcadYear.get(barcodeWithBatchId.get(omr.Student__c));
            
            if(String.isNotBlank(cdm2.Q5__c) && (cdm2.Q5__c == 'A' || cdm2.Q5__c == 'B' || cdm2.Q5__c == 'C')){
                omr.X5_Confident_about_chosen_career__c = 1;
            } else {
                omr.X5_Confident_about_chosen_career__c = 0;
            }
            
           // if(cdm2.Created_from_Form__c)
            //{
                calculateMarksForm('Q6_', 'X6_Options_that_fit_into_Industry__c', 12, cdm2, omr);
          /*  }
            else
            {
                calculateMarks('Q6_', 'X6_Options_that_fit_into_Industry__c', 12, cdm2, omr);
            }*/
            
            cdm2LST.add(omr);
        }
        if(cdm2LST.size() > 0){
            Update cdm2LST;
        }
        
    }
    
    public static void calculateMarks(String sourceField, String resultField, Integer noOfQues, CDM2__c omrassess, CDM2__c omr){
        Map<Integer, Set<String>> expectedResMap = new Map<Integer, Set<String>>();
        expectedResMap.put(1, new Set<String>{'A','C','D','E','G'}); //Industry Independent
        expectedResMap.put(2, new Set<String>{'A','D','E','G','H'}); //Art, Design & Architecture
        expectedResMap.put(3, new Set<String>{'A','C','E','F','G'}); //Media and Entertainment
        expectedResMap.put(4, new Set<String>{'B','D','E','F','H'}); //Finance
        expectedResMap.put(5, new Set<String>{'A','B','D','F','H'}); //Healthcare
        expectedResMap.put(6, new Set<String>{'A','B','D','E','G'}); //Tourism and Hospitality
        expectedResMap.put(7, new Set<String>{'A','B','D','E','H'}); //Wellness and Fitness
        expectedResMap.put(8, new Set<String>{'A','B','D','E','G'}); //Education
        expectedResMap.put(9, new Set<String>{'A','B','D','E','G'}); //Public Services
        expectedResMap.put(10, new Set<String>{'B','D','E','F','G'}); //Environment and Bioscience
        expectedResMap.put(11, new Set<String>{'A','B','C','E','H'}); //Information Technology
        expectedResMap.put(12, new Set<String>{'A','B','C','D','G'}); //Engineering & Trades
        
        Integer overAllMarks = 0;
        for(Integer i = 1 ; i <= noOfQues ; i++){
        	String field = sourceField + i + '__c';
            String strSourceField = String.valueOf(omrassess.get(field));
            if(String.isNotBlank(strSourceField)){
                Integer marks = 0;
                for(String s : strSourceField.split(',')){
                    if(expectedResMap.get(i).contains(s)){
                        marks = marks + 1;
                    } else {
                        if(s != '*'){
                            marks = marks - 1;
                        }
                    }
                }
                String marksField = sourceField + i + '_Marks__c';
                omr.put(marksField, marks);
                if(marks >= 3){
                    overAllMarks++;
                }
                omr.put(marksField, marks);
            }
        }
        omr.put(resultField, overAllMarks);
    }

    public static void calculateMarksForm(String sourceField, String resultField, Integer noOfQues, CDM2__c omrassess, CDM2__c omr){
        Map<Integer, Set<String>> expectedResMap = new Map<Integer, Set<String>>();
        expectedResMap.put(1, new Set<String>{'A','B','D','E','G'}); //Education
        expectedResMap.put(2, new Set<String>{'A','B','D','F','H'}); //Healthcare
        expectedResMap.put(3, new Set<String>{'A','B','D','E','H'}); //Wellness and Fitness
        expectedResMap.put(4, new Set<String>{'A','B','D','E','G'}); //Public Services
        expectedResMap.put(5, new Set<String>{'B','D','E','F','H'}); //Finance
        expectedResMap.put(6, new Set<String>{'A','B','D','E','G'}); //Tourism and Hospitality
        expectedResMap.put(7, new Set<String>{'A','D','E','G','H'}); //Art, Design & Architecture
        expectedResMap.put(8, new Set<String>{'A','C','E','F','G'}); //Media and Entertainment
        expectedResMap.put(9, new Set<String>{'A','B','C','E','H'}); //Information Technology
        expectedResMap.put(10, new Set<String>{'A','B','C','D','G'}); //Engineering & Trades
        expectedResMap.put(11, new Set<String>{'A','C','D','E','G'}); //Industry Independent
        expectedResMap.put(12, new Set<String>{'B','D','E','F','G'}); //Environment and Bioscience
        
        Integer overAllMarks = 0;
        for(Integer i = 1 ; i <= noOfQues ; i++){
        	String field = sourceField + i + '__c';
            String strSourceField = String.valueOf(omrassess.get(field));
            if(String.isNotBlank(strSourceField)){
                Integer marks = 0;
                for(String s : strSourceField.split(',')){
                    if(expectedResMap.get(i).contains(s)){
                        marks = marks + 1;
                    } else {
                        if(s != '*'){
                            marks = marks - 1;
                        }
                    }
                }
                String marksField = sourceField + i + '_Marks__c';
                omr.put(marksField, marks);
                if(marks >= 3){
                    overAllMarks++;
                }
                omr.put(marksField, marks);
            }
        }
        omr.put(resultField, overAllMarks);
    }
    
    public static void updateBatchId(List<CDM2__c> newCdm1List, Map<Id,CDM2__c> oldcdm1Map) {
		// custom settings to check the Academic year
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        
        Double acadYear = 0;
        List<CDM2__c> cdm1List = New List<CDM2__c>();        
        Set<Id> contSet = New Set<id>();                
        Map<Id,Id> StudBatchId = New Map<Id,Id>();
        Map<Id,List<Contact>> batchWithStuds = New Map<Id,List<Contact>>();
        List<CDM2__c> updateCdm1 = New List<CDM2__c>();
        
        for(CDM2__c cdm1: newCdm1List) {
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
                                 AND (Academic_Year__c =: antarangSett.Academic_Year__c OR Academic_Year__c =: antarangSett.Next_Academic_Year__c)]) //v2.0 Included Next_Academic_Year__c
                				{                                                                                                                          
                                     for(Contact c: batchWithStuds.get(b.Id)) {
                                         StudBatchId.put(c.Id,b.Id);
                                     }
                                 }                    
                for(CDM2__c o: cdm1List){
                    if(StudBatchId.containsKey(o.Student__c)) {                            
                        o.Batch_Id__c = StudBatchId.get(o.Student__c);                            
                    }
                }
            }
        }        
    }
    
    //----- v1.0 START -------
    public static boolean updateCounterFlag = false;
    public static void updateOMRTypeCounterManager(List<CDM2__c> cdm2List, Map<Id,CDM2__c> oldcdm2Map, Boolean isDelete){
        updateCounterFlag = true;
        set<Id> BaselineBatchSet = new set<Id>();
        set<Id> EndlineBatchSet = new set<Id>();
        Id baselineRTID = Schema.SObjectType.CDM2__c.getRecordTypeInfosByName().get('Baseline').getRecordTypeId();
        Id endlineRTID = Schema.SObjectType.CDM2__c.getRecordTypeInfosByName().get('Endline').getRecordTypeId();
        
        if(isDelete){   														//CDM2 record Deleted
            if(oldcdm2Map != null){
                for(CDM2__c c: oldcdm2Map.Values()){
                    if(c.RecordTypeId == baselineRTID){
                        BaselineBatchSet.add(c.Batch_Id__c);
                    }else if(c.RecordTypeId == endlineRTID){
                        EndlineBatchSet.add(c.Batch_Id__c);
                    }
                    
                }
            }
        }else{
            for(CDM2__c c: cdm2List){
                if(oldcdm2Map == null){     									//CDM2 record Inserted
                    if(c.RecordTypeId == baselineRTID){
                        BaselineBatchSet.add(c.Batch_Id__c);
                    }else if(c.RecordTypeId == endlineRTID){
                        EndlineBatchSet.add(c.Batch_Id__c);
                    }
                }else if(c.Student__c != oldcdm2Map.get(c.Id).Student__c || c.Student_Linked__c != oldcdm2Map.get(c.Id).Student_Linked__c
                        || c.Error_Status__c != oldcdm2Map.get(c.Id).Error_Status__c ){     //CDM2 record Updated (v1.1)
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
        Id baselineRTID = Schema.SObjectType.CDM2__c.getRecordTypeInfosByName().get('Baseline').getRecordTypeId();
        Id endlineRTID = Schema.SObjectType.CDM2__c.getRecordTypeInfosByName().get('Endline').getRecordTypeId();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();

        
        if(!BaselineBatchSet.isEmpty() && BaselineBatchSet.size() > 0){
            AggregateResult[] groupedBatchResults   = [SELECT COUNT(Id), Batch_Id__c 
                                                       FROM CDM2__c 
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
                                                       FROM CDM2__c 
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
									   WHERE OMR_Assessment_Object__c = 'CDM2' AND
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
    
        //----Old Method start---
   /* public static void updateOMRTypeCounter(List<CDM2__c> cdm1List, Map<Id,CDM2__c> oldcdm1Map, Boolean isDelete) {        
        updateCounterFlag = true;
        Boolean isDeleteFlag = isDelete;
        Integer getCount = 0;
        List<Session_OMR_Type__c> SOTList = New List<Session_OMR_Type__c>();
        Map<Id,Integer> BaselineBatchMap = New Map<Id,Integer>();
        Map<Id,Integer> EndlineBatchMap = New Map<Id,Integer>();
        Id baselineRTID = Schema.SObjectType.CDM2__c.getRecordTypeInfosByName().get('Baseline').getRecordTypeId();
        Id endlineRTID = Schema.SObjectType.CDM2__c.getRecordTypeInfosByName().get('Endline').getRecordTypeId();              
        
        for(CDM2__c c: cdm1List) {              
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
                                        AND OMR_Assessment_Object__c = 'CDM2' 
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
                                       AND OMR_Assessment_Object__c = 'CDM2' 
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