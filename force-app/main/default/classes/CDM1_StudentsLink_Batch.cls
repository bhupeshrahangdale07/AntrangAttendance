/* Link Student on OMR_Assessment__c uploaded from CSV (OMR).
* -------------------------------------------------------------------------------------------------------------------------
* History
 * Version	Date			Description
 * v1.0     13th mar 24     added logic to populate Academic year from current batch School Academic year
*/ 
public class CDM1_StudentsLink_Batch Implements Database.batchable<sObject>, schedulable, Database.Stateful{
    public String query;
    public Integer Total_Success_Records = 0;
    public Integer Total_Failed_Records = 0;
    public Map <String, Contact> Grade_9_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_10_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_11_Barcode_Map = New Map <String, Contact>();
    public Map <String, Contact> Grade_12_Barcode_Map = New Map <String, Contact>();
    Map<String, IARP_Master__c> iarpMasterLst = new Map<String, IARP_Master__c>();
    Map<String, String> intFildWithAPIname = new Map<String, String>{'Q_2_1__c'=>'Realist','Q_2_2__c'=>'Investigative',
        'Q_2_3__c'=>'Artistic','Q_2_4__c'=>'Social','Q_2_5__c'=>'Enterprising','Q_2_6__c'=>'Conventional','Q_2_7__c'=>'Not sure of interest / like'};
    Map<String, String> aptiFildWithAPIname = new Map<String, String>{'Q3_1__c'=>'Spatial','Q3_2__c'=>'Numerical',
                'Q3_3__c'=>'Mechanical','Q3_4__c'=>'Abstract','Q3_5__c'=>'Verbal','Q3_6__c'=>'Creative','Q3_7__c'=>'Not sure of Aptitude'};
    
    //Start method
    public Database.QueryLocator start(Database.BatchableContext BC){
        Id RecTypeCA = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CA Student').getRecordTypeId();
        if(String.isBlank(query)) {
            //query = 'Select Id, Barcode__c, Student__c from OMR_Assessment__c where Student__c = Null AND Barcode__c != Null AND Created_from_Form__c = False';            
            query = 'Select Id, Barcode__c, Student__c, Marks_Recalculated__c,Student_Linked__c, Q_1__c,Q_2_1__c,Q_2_2__c,Q_2_3__c,Q_2_4__c,Q_2_5__c,Q_2_6__c,Q_2_7__c,'
                +'Interest_1__c,Interest_2__c,Aptitude_1__c,Aptitude_2__c,Career_Choice_1__c,Career_Choice_2__c,Interest_Marks__c,Aptitude_Marks__c,Career_Choice_1_Marks__c,'
                +'Career_Choice_2_Marks__c,Error_Status__c,'
                + 'Q3_1__c,Q3_2__c,Q3_3__c,Q3_4__c,Q3_5__c,Q3_6__c,Q3_7__c,'
                + 'Q4_1__c,Q4_2__c,Q4_3__c,Q4_4__c,Q4_5__c,Q4_6__c,Q4_7__c,Q4_8__c,Q4_9__c,Q4_10__c,Q4_11__c,Q4_12__c,Q4_13__c,Q4_14__c,Q4_15__c,Q4_16__c,Q4_17__c,Q4_18__c,Q4_19__c,Q4_20__c,Q4_21__c,Q4_22__c,Q4_23__c,Q4_24__c,Q4_25__c,Q4_26__c,Q4_27__c,Q4_28__c,Q4_29__c,Q4_30__c,Q4_31__c,Q4_32__c,Q4_33__c,Q4_34__c,Q4_35__c,Q4_36__c,Q4_37__c,Q4_38__c,Q4_39__c,Q4_40__c,Q4_41__c,Q4_42__c,Q4_43__c,Q4_44__c,Q4_45__c,Q4_46__c,Q4_47__c,Q4_48__c,Q4_49__c,Q4_50__c,Q4_51__c,Q4_52__c,Q4_53__c'
                + ' from OMR_Assessment__c '
                + 'where Barcode__c != Null AND (Student_Linked__c = False OR Marks_Recalculated__c = False) ' ;//updated on 06.04.2023 
                          
        }
        return Database.getQueryLocator(query); 
    }
    
    //Execute Method
    public void execute(Database.BatchableContext BC, List<OMR_Assessment__c> OMRList) {        
        Set<String> Barcodes = New Set<String>();
        Map<String,String> barcodeWithBatchId = new Map<String,String>();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        
        for(IARP_Master__c iarp : [
                Select Id,Name,Interest_1__c,Interest_2__c,Interest_3__c,Aptitude_1__c,Aptitude_2__c,Aptitude_3__c From IARP_Master__c 
                where Is_Active__c = true
        ]){
            iarpMasterLst.put(iarp.Name, iarp);
        }
        
        Id RecTypeCA = SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        for(OMR_Assessment__c obj : OMRList){
            Barcodes.add(obj.Barcode__c);
        }
        
        List<Contact> contList = [SELECT Name, LastName, Id, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c,Grade_12_Barcode__c,Current_Batch_Id__c from Contact WHERE RecordTypeId =: RecTypeCA AND (Grade_9_Barcode__c IN: Barcodes OR Grade_10_Barcode__c IN: Barcodes OR Grade_11_Barcode__c IN: Barcodes OR Grade_12_Barcode__c IN: Barcodes)];        
                
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
        
        List<OMR_Assessment__c> omrObjList = New List<OMR_Assessment__c>();
        for(OMR_Assessment__c omr : OMRList){            
            if(omr.Student__c == null && omr.Student_Linked__c == False){	//updated on 06.04.2023 ---- link student if Student is null                 
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
            //added on 06.04.2023
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
                omr.Interest_1__c = null; omr.Interest_2__c = null; omr.Interest_Marks__c = null;
                omr.Aptitude_1__c = null; omr.Aptitude_2__c = null; omr.Aptitude_Marks__c = null;
                omr.Career_Choice_1__c = null; omr.Career_Choice_2__c = null; omr.Career_Choice_1_Marks__c = 0; omr.Career_Choice_2_Marks__c = 0; omr.Career_Choice_Total_Marks__c = 0;
                
                if(String.isNotBlank(omr.Q_1__c) && omr.Q_1__c == 'D'){
                    omr.X1_A_good_career_plan_has_the_following__c = 1;                 
                } else {
                    omr.X1_A_good_career_plan_has_the_following__c = 0;
                }
                omrAssessmentTriggerHandler.calculateMarksForm('Q_2_', 7, omr, omr, intFildWithAPIname, aptiFildWithAPIname);
                omrAssessmentTriggerHandler.calculateMarksForm('Q3_', 7, omr, omr, intFildWithAPIname, aptiFildWithAPIname);
                omrAssessmentTriggerHandler.calculateMarksForQ4('Q4_', 53, omr, omr, String.valueOf(omr.get('Interest_1__c')),String.valueOf(omr.get('Interest_2__c')),String.valueOf(omr.get('Aptitude_1__c')),String.valueOf(omr.get('Aptitude_2__c')), iarpMasterLst);                
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
        email.setSubject('Records failed for Class CDM1_StudentsLink_Batch');
        
        List<String> emailTo = New List<String>();
        emailTo.add(emailId);
        email.setToAddresses(emailTo);
        
        email.setPlainTextBody('Total '+ Total_Failed_Records + ' records failed for class CDM1_StudentsLink_Batch');
        
        emlmsg.add(email); 
        if(Total_Failed_Records > 0){
            Messaging.sendEmail(emlmsg, false);
        }  
    }
    
        //schedule class method
    public void execute(SchedulableContext sc){
        CDM1_StudentsLink_Batch OMRStudent = new CDM1_StudentsLink_Batch();
        Id bprId = Database.executeBatch(OMRStudent, 20);
    }
    
    
}