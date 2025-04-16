public without sharing class careerDecisionMaking_02 {

    private static Id cdm2RecordTypeId = Schema.SObjectType.CDM2__c.getRecordTypeInfosByDeveloperName()
    .get('Baseline').getRecordTypeId();

    public careerDecisionMaking_02() {

    }

    @AuraEnabled
    public static singleRecordWrapper getRecordCDM2(String studentId, String grade) {
        try{
            singleRecordWrapper rsp = new singleRecordWrapper();
            String studentBarcode = '';
            do{
                List<Contact> studentContact = new List<Contact>([
                    SELECT Id, Name, Bar_Code__c, 
                    Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c,
                    Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c, G12_Batch_Code__c
                    FROM Contact 
                    WHERE Id = :studentId
                    LIMIT 1
                ]);
                if(studentContact.isEmpty())break;

                rsp.studentName = studentContact[0].Name;
                //rsp.studentBarcode  = studentContact[0].Bar_Code__c;

                if(grade == 'Grade 9'){
                    studentBarcode = studentContact[0].Grade_9_Barcode__c;
                }
                else if(grade == 'Grade 10'){
                    studentBarcode = studentContact[0].Grade_10_Barcode__c;
                }
                else if(grade == 'Grade 11'){
                    studentBarcode = studentContact[0].Grade_11_Barcode__c;
                }
                else if(grade == 'Grade 12'){
                    studentBarcode = studentContact[0].Grade_12_Barcode__c;
                }
                rsp.studentBarcode = studentBarcode;

                /*
                if(String.isNotBlank(studentContact[0].Grade_11_Barcode__c))
                {
                    rsp.studentGrade = 'Grade 11';
                }
                else if(String.isNotBlank(studentContact[0].Grade_10_Barcode__c))
                {
                    rsp.studentGrade = 'Grade 10';
                }
                else if(String.isNotBlank(studentContact[0].Grade_9_Barcode__c))
                {
                    rsp.studentGrade = 'Grade 9';
                }*/
                //=======================================================//

                List<CDM2__c> cdm2List = [
                    SELECT Name, Student__r.Name, Barcode__c,
                    Form_Submitted__c, Created_from_Form__c,    
                    Q5__c,
                    Q6_1__c, Q6_2__c, Q6_3__c, Q6_4__c, Q6_5__c, Q6_6__c, 
                    Q6_7__c, Q6_8__c, Q6_9__c, Q6_10__c, Q6_11__c, Q6_12__c
                    FROM CDM2__c 
                    WHERE Created_from_Form__c = true
                    AND Student__c = :studentId
                    AND Barcode__c = :studentBarcode
                    AND RecordTypeId = :cdm2RecordTypeId
                    LIMIT 1
                ];

                if(cdm2List.isEmpty())break;
                
                rsp.recordCDM2 = cdm2List[0];
                //System.debug('rsp.recordCDM2 : '+ rsp.recordCDM2);
            }while(false);
            return rsp;
        } catch (Exception e) {
            System.debug('getRecordCDM2, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class singleRecordWrapper{
        @AuraEnabled 
        public CDM2__c recordCDM2 {get;set;}

        @AuraEnabled 
        public String studentBarcode {get;set;}

        @AuraEnabled 
        public String studentName {get;set;}
        /*
        @AuraEnabled 
        public String studentGrade {get;set;}*/
    }

    @AuraEnabled
    public static String saveQuestion05(String recordIdCMD2, String studentId, String barCode, object ans, string lng, string typ){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            q05Answer q05 = (q05Answer) System.JSON.deserialize(jsonString, q05Answer.class);

            // System.debug('q05.answer : ' + q05.answer);  

            // System.debug('recordIdCMD2 : ' + recordIdCMD2); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            CDM2__c upsertObj = new CDM2__c();
            if(recordIdCMD2 != null)
            {
                upsertObj.Id = recordIdCMD2;
                rspId = recordIdCMD2;
            } 
            else 
            {
                List<CDM2__c> existing = new List<CDM2__c>([
                    SELECT Id 
                    FROM CDM2__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :cdm2RecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }     
            upsertObj.RecordTypeId = cdm2RecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;
            upsertObj.Form_Language__c = lng;
            upsertObj.Form_Name__c = typ;

            upsertObj.Q5__c = q05.answer;

            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('saveQuestion05, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class q05Answer{
        String answer;
    }

    @AuraEnabled
    public static String saveQuestion06(String recordIdCMD2, String studentId, String barCode, 
                                        object ans, String subIndex, string lng, string typ){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            q06Answer q06 = (q06Answer) System.JSON.deserialize(jsonString, q06Answer.class);

            // System.debug('subIndex : ' + subIndex);  
            // System.debug('q06.answer : ' + q06.answer);  

            // System.debug('recordIdCMD2 : ' + recordIdCMD2); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            CDM2__c upsertObj = new CDM2__c();
            if(recordIdCMD2 != null)
            {
                upsertObj.Id = recordIdCMD2;
                rspId = recordIdCMD2;
            } 
            else 
            {
                List<CDM2__c> existing = new List<CDM2__c>([
                    SELECT Id 
                    FROM CDM2__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :cdm2RecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }      
            upsertObj.RecordTypeId = cdm2RecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;
            upsertObj.Form_Language__c = lng;
            upsertObj.Form_Name__c = typ;

            if(subIndex == '1')upsertObj.Q6_1__c = q06.answer;
            if(subIndex == '2')upsertObj.Q6_2__c = q06.answer;
            if(subIndex == '3')upsertObj.Q6_3__c = q06.answer;
            if(subIndex == '4')upsertObj.Q6_4__c = q06.answer;
            if(subIndex == '5')upsertObj.Q6_5__c = q06.answer;
            if(subIndex == '6')upsertObj.Q6_6__c = q06.answer;
            if(subIndex == '7')upsertObj.Q6_7__c = q06.answer;
            if(subIndex == '8')upsertObj.Q6_8__c = q06.answer;
            if(subIndex == '9')upsertObj.Q6_9__c = q06.answer;
            if(subIndex == '10')upsertObj.Q6_10__c = q06.answer;
            if(subIndex == '11')upsertObj.Q6_11__c = q06.answer;
            if(subIndex == '12')upsertObj.Q6_12__c = q06.answer;

            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('saveQuestion06, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class q06Answer{
        String answer;
    }

    @AuraEnabled
    public static String saveAllQA(String recordIdCMD2, String studentId, String barCode, object ans, string lng, string typ){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            qAnswerAll qAll = (qAnswerAll) System.JSON.deserialize(jsonString, qAnswerAll.class); 

            // System.debug('recordIdCMD2 : ' + recordIdCMD2); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            // System.debug('qAll.q05 : ' + qAll.q05);
            // System.debug('qAll.q06_01 : ' + qAll.q06_01);
            // System.debug('qAll.q06_02 : ' + qAll.q06_02);

            CDM2__c upsertObj = new CDM2__c();
            if(recordIdCMD2 != null){
                upsertObj.Id = recordIdCMD2;
                rspId = recordIdCMD2;
            }  
            else {
                List<CDM2__c> existing = new List<CDM2__c>([
                    SELECT Id 
                    FROM CDM2__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :cdm2RecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }     
            upsertObj.RecordTypeId = cdm2RecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;
            upsertObj.Form_Language__c = lng;
            upsertObj.Form_Name__c = typ;
            upsertObj.Form_Submitted__c=true;

            //=======================================================//
            if(qAll.q05 != null)upsertObj.Q5__c = qAll.q05.answer;
            //=======================================================//
            if(qAll.q06_01 != null)upsertObj.Q6_1__c = qAll.q06_01.answer;
            if(qAll.q06_02 != null)upsertObj.Q6_2__c = qAll.q06_02.answer;
            if(qAll.q06_03 != null)upsertObj.Q6_3__c = qAll.q06_03.answer;
            if(qAll.q06_04 != null)upsertObj.Q6_4__c = qAll.q06_04.answer;
            if(qAll.q06_05 != null)upsertObj.Q6_5__c = qAll.q06_05.answer;
            if(qAll.q06_06 != null)upsertObj.Q6_6__c = qAll.q06_06.answer;
            if(qAll.q06_07 != null)upsertObj.Q6_7__c = qAll.q06_07.answer;
            if(qAll.q06_08 != null)upsertObj.Q6_8__c = qAll.q06_08.answer;
            if(qAll.q06_09 != null)upsertObj.Q6_9__c = qAll.q06_09.answer;
            if(qAll.q06_10 != null)upsertObj.Q6_10__c = qAll.q06_10.answer;
            if(qAll.q06_11 != null)upsertObj.Q6_11__c = qAll.q06_11.answer;
            if(qAll.q06_12 != null)upsertObj.Q6_12__c = qAll.q06_12.answer;
            //=======================================================//
            upsert upsertObj;

            if(String.isBlank(rspId)){
                rspId = upsertObj.Id;
                submitAndCalculate(rspId);
            }
            return rspId;
        } catch (Exception e) {
            System.debug('saveAllQA, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class qAnswerAll{
        q05Answer q05;
        q06Answer q06_01;
        q06Answer q06_02;
        q06Answer q06_03;
        q06Answer q06_04;
        q06Answer q06_05;
        q06Answer q06_06;
        q06Answer q06_07;
        q06Answer q06_08;
        q06Answer q06_09;
        q06Answer q06_10;
        q06Answer q06_11;
        q06Answer q06_12;

        public qAnswerAll(){
            q05 = new q05Answer();
            q06_01 = new q06Answer();
            q06_02 = new q06Answer();
            q06_03 = new q06Answer();
            q06_04 = new q06Answer();
            q06_05 = new q06Answer();
            q06_06 = new q06Answer();
            q06_07 = new q06Answer();
            q06_08 = new q06Answer();
            q06_09 = new q06Answer();
            q06_10 = new q06Answer();
            q06_11 = new q06Answer();
            q06_12 = new q06Answer();
        }
    }

    @AuraEnabled
    public static String submitAndCalculate(String recordIdCMD2){
        Savepoint sp = Database.setSavepoint();
        try{
            List<CDM2__c> cdm2List = [
                SELECT Name, Student__r.Name, Barcode__c,
                Form_Submitted__c, Created_from_Form__c,    
                Q5__c,
                Q6_1__c, Q6_2__c, Q6_3__c, Q6_4__c, Q6_5__c, Q6_6__c, 
                Q6_7__c, Q6_8__c, Q6_9__c, Q6_10__c, Q6_11__c, Q6_12__c
                FROM CDM2__c 
                WHERE Id = :recordIdCMD2
                LIMIT 1
            ];

            CDM2__c recSubmitStatus = new CDM2__c(Id = recordIdCMD2);
            recSubmitStatus.Form_Submitted__c = true;

            recSubmitStatus.X5_Confident_about_chosen_career__c = null;
            recSubmitStatus.Q6_1_Marks__c = null;
            recSubmitStatus.Q6_2_Marks__c = null;
            recSubmitStatus.Q6_3_Marks__c = null;
            recSubmitStatus.Q6_4_Marks__c = null;
            recSubmitStatus.Q6_5_Marks__c = null;
            recSubmitStatus.Q6_6_Marks__c = null;
            recSubmitStatus.Q6_7_Marks__c = null;
            recSubmitStatus.Q6_8_Marks__c = null;
            recSubmitStatus.Q6_9_Marks__c = null;
            recSubmitStatus.Q6_10_Marks__c = null;
            recSubmitStatus.Q6_11_Marks__c = null;
            recSubmitStatus.Q6_12_Marks__c = null;

            update recSubmitStatus;

            cdm2TriggerHandler.populateStudentOnCDM2(cdm2List);

            return 'success';
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug('submitAndCalculate, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
}