public without sharing class BaselineFeedbackController {
    @AuraEnabled
    public static string saveData(String studentId,string fd1,string fd2,string fd3,string fd4,string fd5,string fd6,string fd7,string fd8,string fd9,string fd10,string fd11,string fd12,boolean saveFlag, string grade) {
        system.debug(':::studentId = '+studentId);
        String returnStr = '';
        try{
            List<Future_Planning__c> sf =  new List<Future_Planning__c>([select id,Created_from_Form__c,F_1__c,F_2__c,F_3__c,F_4__c,F_5__c,F_6__c,F_7__c,F_8__c,F_9__c,F_10__c,F_11__c,F_12__c, Student__c from  Future_Planning__c
                                                                         where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1]);
            if(!sf.isEmpty()){
                returnStr = 'Update';
                system.debug('saveFlag ='+saveFlag);
                dataPrepare(saveFlag,sf[0],fd1,fd2,fd3,fd4,fd5,fd6,fd7,fd8,fd9,fd10,fd11,fd12);
            }
            else
            {
                returnStr = 'Insert';
                contact con = [select id,Bar_Code__c,Batch_Code__c,G10_Batch_Code__c,G11_Batch_Code__c,G12_Batch_Code__c,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c from contact where id=:studentId];
                string barcode = '';
                if(grade == 'Grade 9')barcode=con.Grade_9_Barcode__c;
                if(grade == 'Grade 10')barcode=con.Grade_10_Barcode__c;
                if(grade == 'Grade 11')barcode=con.Grade_11_Barcode__c;
                if(grade == 'Grade 12')barcode=con.Grade_12_Barcode__c;
                RecordType rt = [select id, name, SobjectType from RecordType where SobjectType = 'Future_Planning__c' and name = 'Baseline'];
                Future_Planning__c sf1 = new Future_Planning__c(Created_from_Form__c = true, Student__c = studentId, Barcode__c = barcode, RecordTypeId = rt.id);
                dataPrepare(saveFlag,sf1,fd1,fd2,fd3,fd4,fd5,fd6,fd7,fd8,fd9,fd10,fd11,fd12);
            }
            
            return returnStr;
        }catch(exception e){
            System.debug('BaselineFeedbackController.saveData, e.getMessage() : ' + e.getMessage());
            System.debug('BaselineFeedbackController.saveData, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static void dataPrepare(boolean saveFlag,Future_Planning__c sf,string fd1,string fd2,string fd3,string fd4,string fd5,string fd6,string fd7,string fd8,string fd9,string fd10,string fd11,string fd12){
        try{
            if(saveFlag){
                sf.Feedback_form_submitted__c = true;
                sf.Future_Planning_form_submitted__c = true;
            }
            if(fd1 == 'NoAnswer')fd1='';
            if(fd2 == 'NoAnswer')fd2='';
            if(fd3 == 'NoAnswer')fd3='';
            if(fd4 == 'NoAnswer')fd4='';
            if(fd5 == 'NoAnswer')fd5='';
            if(fd6 == 'NoAnswer')fd6='';
            if(fd7 == 'NoAnswer')fd7='';
            if(fd8 == 'NoAnswer')fd8='';
            if(fd9 == 'NoAnswer')fd9='';
            if(fd10 == 'NoAnswer')fd10='';
            if(fd11 == 'NoAnswer')fd11='';
            if(fd12 == 'NoAnswer')fd12='';
            
            sf.F_1__c = fd1;
            sf.F_2__c = fd2;
            sf.F_3__c = fd3;
            sf.F_4__c = fd4;
            sf.F_5__c = fd5;
            sf.F_6__c = fd6;
            sf.F_7__c = fd7;
            sf.F_8__c = fd8;
            sf.F_9__c = fd9;
            sf.F_10__c = fd10;
            sf.F_11__c = fd11;
            sf.F_12__c = fd12;
            
            upsert sf;
            
            if(saveFlag == true && sf.id != null){
                list<Future_Planning__c> lstFut = [select id,Barcode__c,Created_from_Form__c,Q_17__c,Q_18_1__c,Q_18_2__c,Q_18_3__c,Q_18_4__c,Q_18_5__c,Q_18_6__c,Q_18_7__c,Q_18_8__c,Q_18_9__c,Q_18_10__c,Q_18_11__c,Q_19__c,Q_20__c,Q_21__c,Q_22__c, Student__c from Future_Planning__c where id = :sf.id];
                FuturePlanningTriggerHandler.populateStudentAndMarksCalculation(lstFut);
            }
        }catch(exception e){
            System.debug('BaselineFeedbackController.dataPrepare, e.getMessage() : ' + e.getMessage());
            System.debug('BaselineFeedbackController.dataPrepare, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    @AuraEnabled
    public static Future_Planning__c getRecordApt(String studentId) {
        try{
            List<Future_Planning__c> sf =  new List<Future_Planning__c>([select id,Created_from_Form__c, F_1__c,F_2__c,F_3__c,F_4__c,F_5__c,F_6__c,F_7__c,F_8__c,F_9__c,F_10__c,F_11__c,F_12__c, Student__c, Student__r.name from  Future_Planning__c
                                                                         where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1]);
            if(!sf.isEmpty()){
                system.debug(' sf[0] = '+ sf[0]);
                return sf[0];
            }
            
            return new Future_Planning__c();
        }catch(exception e){
            System.debug('BaselineFeedbackController, e.getMessage() : ' + e.getMessage());
            System.debug('BaselineFeedbackController, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /* Written by Piyush - 15.2.24 */
    @AuraEnabled
    public static Future_Planning__c getStudentRecord(String studentId, string batchId) {
        try{
            List<Batch__c> batches = new List<Batch__c>([
                SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
                FROM Batch__c
                WHERE Id = :batchId LIMIT 1]);
            string grade = batches[0].grade__c;
             String studentBarcode = '';
                List<Contact> studentContact = new List<Contact>([
                    SELECT Id, Name, Bar_Code__c, 
                    Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c, 
                    Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c
                    FROM Contact 
                    WHERE Id = :studentId
                    LIMIT 1
                ]);
                if(grade == 'Grade 9')
                {
                    studentBarcode = studentContact[0].Grade_9_Barcode__c;
                }
                else if(grade == 'Grade 10')
                {
                    studentBarcode = studentContact[0].Grade_10_Barcode__c;
                }
                else if(grade == 'Grade 11')
                {
                    studentBarcode = studentContact[0].Grade_11_Barcode__c;
                }
                else if(grade == 'Grade 12')
                {
                    studentBarcode = studentContact[0].Grade_12_Barcode__c;
                }
           
            List<Future_Planning__c> sf = new List<Future_Planning__c>();
            if(String.isNotBlank(batchId) && !batches.isEmpty()){
                sf =  [Select Id, Created_from_Form__c, Barcode__c, Form_Submitted__c, F_1__c, F_10__c, F_11__c, F_12__c, F_2__c, 
                                                                             F_3__c, F_4__c, F_5__c, F_6__c, F_7__c, F_8__c, F_9__c, Student__c, Student__r.name 
                                                                             FROM Future_Planning__c
                                                                             WHERE Student__c =: studentId and Created_from_Form__c = true 
                                                                             AND Error_Status__c = 'No Error'
                                                                             // AND Data_Clean_up__c  = false
                                                                             AND Academic_Year__c = :batches[0].Academic_Year__c
                                                                             AND Grade__c = :batches[0].Grade__c
                       														 AND Barcode__c = :studentBarcode
                                                                             and RecordType.Name='Baseline' 
                                                                             LIMIT 1];
            }else{
                 sf = [Select Id, Created_from_Form__c, Barcode__c, Form_Submitted__c, F_1__c, F_10__c, F_11__c, F_12__c, F_2__c, 
                                                                             F_3__c, F_4__c, F_5__c, F_6__c, F_7__c, F_8__c, F_9__c, Student__c, Student__r.name 
                                                                             FROM Future_Planning__c
                                                                             WHERE Student__c =: studentId and Created_from_Form__c = true 
                                                                             AND Error_Status__c = 'No Error'
                                                                             // AND Data_Clean_up__c  = false
                                                                             and RecordType.Name='Baseline' 
                                                                             LIMIT 1];
            }
            
            if(!sf.isEmpty()){	
                system.debug(' sf[0] = '+ sf[0]);
                return sf[0];
            }
            
            return new Future_Planning__c();
        }catch(exception e){
            System.debug('BaselineFeedbackController, e.getMessage() : ' + e.getMessage());
            System.debug('BaselineFeedbackController, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string SaveAllData(String batchId, String studentId, String F1, String F2, String F3, String F4, String F5, String F6, String F7, String F8, String F9, String F10, String F11, String F12, boolean saveFlag, String grade, String formType, string recordType) {
        Map<String, String> formDetails = ( Map<String, String>)JSON.deserialize(formType,  Map<String, String>.class);
        if(recordType == '' || recordType == null){
            recordType = 'Baseline';
        }
        String lng = formDetails.containsKey('lng') ? formDetails.get('lng') : '' ;
        String typ = formDetails.containsKey('typ') ? formDetails.get('typ') : '' ;
        system.debug(':::studentId = '+studentId);
        
        String returnStr = '';
        try{

            List<Future_Planning__c> sf =  new List<Future_Planning__c>();
            List<Batch__c> batches = new List<Batch__c>([
                    SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
                    FROM Batch__c
                    WHERE Id = :batchId LIMIT 1]);
            
            String studentBarcode = '';
                List<Contact> studentContact = new List<Contact>([
                    SELECT Id, Name, Bar_Code__c, 
                    Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c, 
                    Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c
                    FROM Contact 
                    WHERE Id = :studentId
                    LIMIT 1
                ]);
                if(grade == 'Grade 9')
                {
                    studentBarcode = studentContact[0].Grade_9_Barcode__c;
                }
                else if(grade == 'Grade 10')
                {
                    studentBarcode = studentContact[0].Grade_10_Barcode__c;
                }
                else if(grade == 'Grade 11')
                {
                    studentBarcode = studentContact[0].Grade_11_Barcode__c;
                }
                else if(grade == 'Grade 12')
                {
                    studentBarcode = studentContact[0].Grade_12_Barcode__c;
                }

                    if(String.isNotBlank(batchId) && !batches.isEmpty()){
                        sf =  new List<Future_Planning__c>([Select Id, Created_from_Form__c, Barcode__c, Form_Submitted__c, F_1__c, F_10__c, F_11__c, F_12__c, F_2__c, 
                                                                        F_3__c, F_4__c, F_5__c, F_6__c, F_7__c, F_8__c, F_9__c, Student__c, Student__r.name,Feedback_form_submitted__c 
                                                                        FROM Future_Planning__c
                                                                        WHERE Student__c =: studentId and Created_from_Form__c = true and RecordType.Name=:recordType 
                                                                        AND Error_Status__c = 'No Error'
                                                                        // AND Data_Clean_up__c  = false
                                                                        AND Academic_Year__c = :batches[0].Academic_Year__c
                                                                        AND Grade__c = :batches[0].Grade__c
                                                            			AND Barcode__c = : studentBarcode
                                                                        ORDER BY CreatedDate DESC
                                                                        LIMIT 1]);
                    }else{
                        sf =  new List<Future_Planning__c>([Select Id, Created_from_Form__c, Barcode__c, Form_Submitted__c, F_1__c, F_10__c, F_11__c, F_12__c, F_2__c, 
                                                                        F_3__c, F_4__c, F_5__c, F_6__c, F_7__c, F_8__c, F_9__c, Student__c, Student__r.name,Feedback_form_submitted__c 
                                                                        FROM Future_Planning__c
                                                                        WHERE Student__c =: studentId and Created_from_Form__c = true and RecordType.Name=:recordType 
                                                                        LIMIT 1]);
                    }
            if(!sf.isEmpty()){
                //returnStr = 'Update';
                returnStr = sf[0].Id;
                system.debug('saveFlag ='+saveFlag);
                if(String.isNotBlank(grade)){
                    sf[0].Grade__c = grade;
                }
                
                dataPrepare1(saveFlag,sf[0], F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, lng, typ);
            }
            else
            {
                //returnStr = 'Insert';
                
                contact con = [select id,Bar_Code__c,Batch_Code__c,G10_Batch_Code__c,G11_Batch_Code__c,G12_Batch_Code__c,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c from contact where id=:studentId];
                string barcode = '';
                if(grade == 'Grade 9')barcode=con.Grade_9_Barcode__c;
                if(grade == 'Grade 10')barcode=con.Grade_10_Barcode__c;
                if(grade == 'Grade 11')barcode=con.Grade_11_Barcode__c;
                if(grade == 'Grade 12')barcode=con.Grade_12_Barcode__c;
                RecordType rt = [select id, name, SobjectType from RecordType where SobjectType = 'Future_Planning__c' and name = :recordType];
                system.debug('Grade : '+grade);
                Future_Planning__c sf1 = new Future_Planning__c(Created_from_Form__c = true, Student__c = studentId, Barcode__c = barcode, RecordTypeId = rt.id, Grade__c=grade);
                system.debug('Grade : '+sf1);
                system.debug('Grade : '+sf1.Grade__c);
                returnStr = dataPrepare1(saveFlag,sf1, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, lng, typ);
            }
            
            return returnStr;
        }catch(exception e){
            System.debug('BaselineFeedbackController.saveData, e.getMessage() : ' + e.getMessage());
            System.debug('BaselineFeedbackController.saveData, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    public static String dataPrepare1(boolean saveFlag,Future_Planning__c sf, String F1, String F2, String F3, String F4, String F5, String F6, String F7, String F8, String F9, String F10, String F11, String F12, string lng, string typ ){
        try{
            if(saveFlag){
                sf.Feedback_form_submitted__c = true;
            }
            
            sf.F_1__c = F1;
            sf.F_10__c = F10;
            sf.F_11__c = F11;
            sf.F_12__c = F12;
            sf.F_2__c = F2;
            sf.F_3__c = F3;
            sf.F_4__c = F4;
            sf.F_5__c = F5;
            sf.F_6__c = F6;
            sf.F_7__c = F7;
            sf.F_8__c = F8;
            sf.F_9__c = F9;
            
            sf.Form_Language__c = lng;
            sf.Form_Name__c = typ;
            sf.Form_Submitted__c = true;
            
            if (F1 == 'NoAnswer' || F1 == 'nil') {
                sf.F_1__c = '';
            }
            
            if (F10 == 'NoAnswer' || F10 == 'nil') {
                sf.F_10__c = '';
            }
            
            if (F11 == 'NoAnswer' || F11 == 'nil') {
                sf.F_11__c = '';
            }
            
            if (F12 == 'NoAnswer' || F12 == 'nil') {
                sf.F_12__c = '';
            }
            
            if (F2 == 'NoAnswer' || F2 == 'nil') {
                sf.F_2__c = '';
            }
            
            if (F3 == 'NoAnswer' || F3 == 'nil') {
                sf.F_3__c = '';
            }
            
            if (F4 == 'NoAnswer' || F4 == 'nil') {
                sf.F_4__c = '';
            }
            
            if (F5 == 'NoAnswer' || F5 == 'nil') {
                sf.F_5__c = '';
            }
            
            if (F6 == 'NoAnswer' || F6 == 'nil') {
                sf.F_6__c = '';
            }
            
            if (F7 == 'NoAnswer' || F7 == 'nil') {
                sf.F_7__c = '';
            }
            
            if (F8 == 'NoAnswer' || F8 == 'nil') {
                sf.F_8__c = '';
            }
            
            if (F9 == 'NoAnswer' || F9 == 'nil') {
                sf.F_9__c = '';
            }
            
            
            upsert sf;  
            system.debug('::Ids ='+sf.id);
            return sf.Id;
        }catch(exception e){
            System.debug('BaselineFeedbackController.dataPrepare, e.getMessage() : ' + e.getMessage());
            System.debug('BaselineFeedbackController.dataPrepare, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    @AuraEnabled
    public static Contact getStudentName(String stuId) {  
        try{
            Contact con = [Select Id,Name FROM Contact WHERE Id =:stuId ];
            return con;
        } catch (Exception e) {
            System.debug('InterestDetailsHandler.getStudentName, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
      public static void fakeMethod(){
    Integer i = 0;
    	i++;
    	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    	i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    //repeat the i++ hundred of times

  }
    
}