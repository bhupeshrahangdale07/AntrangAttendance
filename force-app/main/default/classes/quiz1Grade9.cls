/*Change History
version   Date   	Description
V1.0      14/12/23  To exclude duplicate record from form submission 

*/ 
public without sharing class quiz1Grade9 {
    private static Id safRecordTypeId = Schema.SObjectType.Self_Awareness_and_Feedback__c.getRecordTypeInfosByDeveloperName()
    .get('Baseline').getRecordTypeId();

    public quiz1Grade9() {

    }

    @AuraEnabled
    public static singleRecordWrapper getApexRecord(String studentId, String grade) {
        try{
            singleRecordWrapper rsp = new singleRecordWrapper();
            String studentBarcode = '';
            do{
                List<Contact> studentContact = new List<Contact>([
                    SELECT Id, Name, Bar_Code__c, 
                    Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, 
                    Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c
                    FROM Contact 
                    WHERE Id = :studentId
                    LIMIT 1
                ]);
                if(studentContact.isEmpty())break;

                rsp.studentName = studentContact[0].Name;
                //rsp.studentBarcode  = studentContact[0].Bar_Code__c;

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

                List<Self_Awareness_and_Feedback__c> safList = [
                    SELECT Name, Student__r.Name, Barcode__c,
                    Created_from_Form__c, Grade9_Quiz1_Submitted__c, Grade10_Quiz1_Submitted__c,  
                    Quiz_1_1__c, Quiz_1_2__c, Quiz_1_3__c, Quiz_1_4__c, Quiz_1_5__c,
                    Quiz_1_6__c, Quiz_1_7__c, Quiz_1_8__c, Quiz_1_9__c, Quiz_1_10__c
                    FROM Self_Awareness_and_Feedback__c 
                    WHERE Created_from_Form__c = true
                    AND Student__c = :studentId
                    AND Barcode__c = :studentBarcode
                    AND RecordTypeId = :safRecordTypeId
                    AND Error_Status__c = 'No Error'
                    LIMIT 1
                ]; //V1.0

                if(safList.isEmpty())break;
                
                rsp.apexRecord = safList[0];
            }while(false);
            return rsp;
        } catch (Exception e) {
            System.debug('quiz1Grade9.getApexRecord, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class singleRecordWrapper{
        @AuraEnabled 
        public Self_Awareness_and_Feedback__c apexRecord {get;set;}

        @AuraEnabled 
        public String studentBarcode {get;set;}

        @AuraEnabled 
        public String studentName {get;set;}
        /*
        @AuraEnabled 
        public String studentGrade {get;set;}*/
    }

    @AuraEnabled
    public static String saveSingle(String recordIdSAF, String studentId, String barCode, String qNo, object ans){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            qAnswer qS = (qAnswer) System.JSON.deserialize(jsonString, qAnswer.class);

            // System.debug('qS.answer : ' + qS.answer); 
            // System.debug('qNo : ' + qNo);  

            // System.debug('recordIdSAF : ' + recordIdSAF); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            Self_Awareness_and_Feedback__c upsertObj = new Self_Awareness_and_Feedback__c();
            if(String.isNotBlank(recordIdSAF))
            {
                upsertObj.Id = recordIdSAF;
                rspId = recordIdSAF;
            }   
            else 
            {
                List<Self_Awareness_and_Feedback__c> existing = new List<Self_Awareness_and_Feedback__c>([
                    SELECT Id 
                    FROM Self_Awareness_and_Feedback__c
                    WHERE Created_from_Form__c = true
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }
            upsertObj.RecordTypeId = safRecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;

            if(qNo == '01')upsertObj.Quiz_1_1__c = qS.answer; 
            else if(qNo == '02')upsertObj.Quiz_1_2__c = qS.answer;
            else if(qNo == '03')upsertObj.Quiz_1_3__c = qS.answer;  
            else if(qNo == '04')upsertObj.Quiz_1_4__c = qS.answer;
            else if(qNo == '05')upsertObj.Quiz_1_5__c = qS.answer;         

            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('quiz1Grade9.saveSingle, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class qAnswer{
        String answer;
    }

    @AuraEnabled
    public static String saveAllQA(String recordIdSAF, String studentId, String barCode, object ans, string lng, string typ){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            qAnswerAll qAll = (qAnswerAll) System.JSON.deserialize(jsonString, qAnswerAll.class); 

            // System.debug('recordIdSAF : ' + recordIdSAF); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            // System.debug('qAll.q01 : ' + qAll.q01);
            // System.debug('qAll.q02 : ' + qAll.q02);
            // System.debug('qAll.q03 : ' + qAll.q03);
            // System.debug('qAll.q04 : ' + qAll.q04);
            // System.debug('qAll.q05 : ' + qAll.q05);

            Self_Awareness_and_Feedback__c upsertObj = new Self_Awareness_and_Feedback__c();
            if(String.isNotBlank(recordIdSAF))
            {
                upsertObj.Id = recordIdSAF;
                rspId = recordIdSAF;
            }   
            else 
            {
                List<Self_Awareness_and_Feedback__c> existing = new List<Self_Awareness_and_Feedback__c>([
                    SELECT Id 
                    FROM Self_Awareness_and_Feedback__c
                    WHERE Created_from_Form__c = true
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode and Error_Status__c = 'No Error' limit 1]);   //V1.0

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }     
            upsertObj.RecordTypeId = safRecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;
			upsertObj.Form_Name__c = typ;
            upsertObj.Form_Language__c = lng;
            //=======================================================//
            if(qAll.q01 != null)upsertObj.Quiz_1_1__c = qAll.q01.answer;
            //=======================================================//
            if(qAll.q02 != null)upsertObj.Quiz_1_2__c = qAll.q02.answer;
            //=======================================================//
            if(qAll.q03 != null)upsertObj.Quiz_1_3__c = qAll.q03.answer;
            //=======================================================//
            if(qAll.q04 != null)upsertObj.Quiz_1_4__c = qAll.q04.answer;
            //=======================================================//
            if(qAll.q05 != null)upsertObj.Quiz_1_5__c = qAll.q05.answer;
            //=======================================================//
            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('quiz1Grade9.saveAllQA, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class qAnswerAll{
        qAnswer q01;
        qAnswer q02;
        qAnswer q03;
        qAnswer q04;
        qAnswer q05;

        public qAnswerAll(){
            q01 = new qAnswer();
            q02 = new qAnswer();
            q03 = new qAnswer();
            q04 = new qAnswer();
            q05 = new qAnswer();
        }
    }

    @AuraEnabled
    public static String submitAndCalculate(String recordIdSAF){   
        Savepoint sp = Database.setSavepoint();
        try{
            List<Self_Awareness_and_Feedback__c> safList = new List<Self_Awareness_and_Feedback__c>([
                    SELECT Id, Name, Barcode__c, Created_from_Form__c,
                    Quiz_1_1__c, Quiz_1_2__c, Quiz_1_3__c, Quiz_1_4__c, Quiz_1_5__c, 
                    Quiz_1_6__c, Quiz_1_7__c, Quiz_1_8__c, Quiz_1_9__c, Quiz_1_10__c, student__c
                    FROM Self_Awareness_and_Feedback__c 
                    WHERE Id = :recordIdSAF
                ]);

            Self_Awareness_and_Feedback__c recSubmitStatus = new Self_Awareness_and_Feedback__c(Id = recordIdSAF);
            recSubmitStatus.Grade9_Quiz1_Submitted__c = true;
            update recSubmitStatus;
			system.debug('recSubmitStatus = '+recSubmitStatus);
            SelfAwarenessandFeedbackTriggerHandler.populateStudentAndMarksCalculation(safList);

            return 'success';
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug('quiz1Grade9.submitAndCalculate, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
}