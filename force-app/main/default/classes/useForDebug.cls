public without sharing class useForDebug {

    private static Id csRecordTypeId = Schema.SObjectType.Career_Skill__c.getRecordTypeInfosByDeveloperName()
    .get('Endline').getRecordTypeId();

    public useForDebug() {

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

                List<Career_Skill__c> csList = [
                    SELECT Name, Student__r.Name, Barcode__c,
                    Form_Submitted__c, Created_from_Form__c,    
                    Q_11_1__c, Q_11_2__c, Q_11_3__c, Q_11_4__c, Q_11_5__c, Q_11_6__c, Q_11_7__c, Q_11_8__c, Q_11_9__c,
                    Q_12_1__c, Q_12_2__c, Q_12_3__c, Q_12_4__c,
                    Q_13__c, 
                    Q_14__c,
                    Q_15_1__c, Q_15_2__c, Q_15_3__c, Q_15_4__c, Q_15_5__c, Q_15_6__c, Q_15_7__c, Q_15_8__c, Q_15_9__c,
                    Q_16__c
                    FROM Career_Skill__c 
                    WHERE Created_from_Form__c = true
                    AND Student__c = :studentId
                    AND Barcode__c = :studentBarcode
                    AND RecordTypeId = :csRecordTypeId
                    LIMIT 1
                ];

                if(csList.isEmpty())break;
                
                rsp.apexRecord = csList[0];
                //System.debug('rsp.recordCDM2 : '+ rsp.apexRecord);
            }while(false);
            return rsp;
        } catch (Exception e) {
            System.debug('careerSkillsEndline.getApexRecord, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class singleRecordWrapper{
        @AuraEnabled 
        public Career_Skill__c apexRecord {get;set;}

        @AuraEnabled 
        public String studentBarcode {get;set;}

        @AuraEnabled 
        public String studentName {get;set;}
        /*
        @AuraEnabled 
        public String studentGrade {get;set;}*/
    }

    @AuraEnabled
    public static String saveQuestion11(String recordId, String studentId, String barCode, object ans){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            comboAnswer q11 = (comboAnswer) System.JSON.deserialize(jsonString, comboAnswer.class);

            // System.debug('q11 : ' + q11);  

            // System.debug('recordId : ' + recordId); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            Career_Skill__c upsertObj = new Career_Skill__c();
            if(recordId != null)
            {
                upsertObj.Id = recordId;
                rspId = recordId;
            }
            else 
            {
                List<Career_Skill__c> existing = new List<Career_Skill__c>([
                    SELECT Id 
                    FROM Career_Skill__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :csRecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }     
            upsertObj.RecordTypeId = csRecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;

            upsertObj.Q_11_1__c = q11.answer1;
            upsertObj.Q_11_2__c = q11.answer2;
            upsertObj.Q_11_3__c = q11.answer3;
            upsertObj.Q_11_4__c = q11.answer4;
            upsertObj.Q_11_5__c = q11.answer5;
            upsertObj.Q_11_6__c = q11.answer6;
            upsertObj.Q_11_7__c = q11.answer7; 
            upsertObj.Q_11_8__c = q11.answer8;
            upsertObj.Q_11_9__c = q11.answer9;        

            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('careerSkillsEndline.saveQuestion11, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String saveQuestion15(String recordId, String studentId, String barCode, object ans){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            comboAnswer q15 = (comboAnswer) System.JSON.deserialize(jsonString, comboAnswer.class);

            // System.debug('q15 : ' + q15);  

            // System.debug('recordId : ' + recordId); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            Career_Skill__c upsertObj = new Career_Skill__c();
            if(recordId != null)
            {
                upsertObj.Id = recordId;
                rspId = recordId;
            }
            else 
            {
                List<Career_Skill__c> existing = new List<Career_Skill__c>([
                    SELECT Id 
                    FROM Career_Skill__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :csRecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }     
            upsertObj.RecordTypeId = csRecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;

            upsertObj.Q_15_1__c = q15.answer1;
            upsertObj.Q_15_2__c = q15.answer2;
            upsertObj.Q_15_3__c = q15.answer3;
            upsertObj.Q_15_4__c = q15.answer4;
            upsertObj.Q_15_5__c = q15.answer5;
            upsertObj.Q_15_6__c = q15.answer6;
            upsertObj.Q_15_7__c = q15.answer7; 
            upsertObj.Q_15_8__c = q15.answer8;
            upsertObj.Q_15_9__c = q15.answer9;        

            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('careerSkillsEndline.saveQuestion15, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class comboAnswer{
        String answer1;
        String answer2;
        String answer3; 
        String answer4;
        String answer5;
        String answer6; 
        String answer7;
        String answer8; 
        String answer9;
    }

    @AuraEnabled
    public static String saveSingle(String recordId, String studentId, String barCode, String qNo, object ans){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            qAnswer qS = (qAnswer) System.JSON.deserialize(jsonString, qAnswer.class);

            // System.debug('qS.answer : ' + qS.answer); 
            // System.debug('qNo : ' + qNo);  

            // System.debug('recordId : ' + recordId); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            Career_Skill__c upsertObj = new Career_Skill__c();
            if(recordId != null)
            {
                upsertObj.Id = recordId;
                rspId = recordId;
            }
            else 
            {
                List<Career_Skill__c> existing = new List<Career_Skill__c>([
                    SELECT Id 
                    FROM Career_Skill__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :csRecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }     
            upsertObj.RecordTypeId = csRecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;

            if(qNo == '13')upsertObj.Q_13__c = qS.answer; 
            else if(qNo == '14')upsertObj.Q_14__c = qS.answer;
            else if(qNo == '16')upsertObj.Q_16__c = qS.answer;
            else if(qNo == '11_01')upsertObj.Q_11_1__c = qS.answer; 
            else if(qNo == '11_02')upsertObj.Q_11_2__c = qS.answer;
            else if(qNo == '11_03')upsertObj.Q_11_3__c = qS.answer;
            else if(qNo == '11_04')upsertObj.Q_11_4__c = qS.answer;
            else if(qNo == '11_05')upsertObj.Q_11_5__c = qS.answer; 
            else if(qNo == '11_06')upsertObj.Q_11_6__c = qS.answer;
            else if(qNo == '11_07')upsertObj.Q_11_7__c = qS.answer;
            else if(qNo == '11_08')upsertObj.Q_11_8__c = qS.answer;
            else if(qNo == '11_09')upsertObj.Q_11_9__c = qS.answer;
            else if(qNo == '15_01')upsertObj.Q_15_1__c = qS.answer; 
            else if(qNo == '15_02')upsertObj.Q_15_2__c = qS.answer;
            else if(qNo == '15_03')upsertObj.Q_15_3__c = qS.answer;
            else if(qNo == '15_04')upsertObj.Q_15_4__c = qS.answer;
            else if(qNo == '15_05')upsertObj.Q_15_5__c = qS.answer; 
            else if(qNo == '15_06')upsertObj.Q_15_6__c = qS.answer;
            else if(qNo == '15_07')upsertObj.Q_15_7__c = qS.answer;
            else if(qNo == '15_08')upsertObj.Q_15_8__c = qS.answer;
            else if(qNo == '15_09')upsertObj.Q_15_9__c = qS.answer;         

            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('careerSkillsEndline.saveSingle, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class qAnswer{
        String answer;
    }

    @AuraEnabled
    public static String saveQuestion12(String recordId, String studentId, String barCode, object ans){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            q12Answer q12 = (q12Answer) System.JSON.deserialize(jsonString, q12Answer.class);

            // System.debug('q12.answer_2_1 : ' + q12.answer_2_1);  
            // System.debug('q12.answer_2_2 : ' + q12.answer_2_2); 
            // System.debug('q12.answer_2_3 : ' + q12.answer_2_3); 
            // System.debug('q12.answer_2_4 : ' + q12.answer_2_4);   
 
            // System.debug('recordId : ' + recordId); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            Career_Skill__c upsertObj = new Career_Skill__c();
            if(recordId != null)
            {
                upsertObj.Id = recordId;
                rspId = recordId;
            } 
            else 
            {
                List<Career_Skill__c> existing = new List<Career_Skill__c>([
                    SELECT Id 
                    FROM Career_Skill__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :csRecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }     
            upsertObj.RecordTypeId = csRecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;

            upsertObj.Q_12_1__c = q12.answer_2_1;
            upsertObj.Q_12_2__c = q12.answer_2_2;
            upsertObj.Q_12_3__c = q12.answer_2_3;
            upsertObj.Q_12_4__c = q12.answer_2_4;

            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('careerSkillsEndline.saveQuestion12, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class q12Answer{
        String answer_2_1;
        String answer_2_2;
        String answer_2_3; 
        String answer_2_4;
    }

    @AuraEnabled
    public static String saveAllQA(String recordId, String studentId, String barCode, object ans){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            qAnswerAll qAll = (qAnswerAll) System.JSON.deserialize(jsonString, qAnswerAll.class); 

            // System.debug('recordId : ' + recordId); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            // System.debug('qAll.q11 : ' + qAll.q11);
            // System.debug('qAll.q12 : ' + qAll.q12);
            // System.debug('qAll.q13 : ' + qAll.q13);
            // System.debug('qAll.q14 : ' + qAll.q14);
            // System.debug('qAll.q15 : ' + qAll.q15);
            // System.debug('qAll.q16 : ' + qAll.q16);

            Career_Skill__c upsertObj = new Career_Skill__c();
            if(recordId != null)
            {
                upsertObj.Id = recordId;
                rspId = recordId;
            } 
            else 
            {
                List<Career_Skill__c> existing = new List<Career_Skill__c>([
                    SELECT Id 
                    FROM Career_Skill__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :csRecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }     
            upsertObj.RecordTypeId = csRecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;

            //=======================================================//
            /*
            if(qAll.q11 != null)
            {
                upsertObj.Q_11_1__c = qAll.q11.answer1;
                upsertObj.Q_11_2__c = qAll.q11.answer2;
                upsertObj.Q_11_3__c = qAll.q11.answer3;
                upsertObj.Q_11_4__c = qAll.q11.answer4;
                upsertObj.Q_11_5__c = qAll.q11.answer5;
                upsertObj.Q_11_6__c = qAll.q11.answer6;
                upsertObj.Q_11_7__c = qAll.q11.answer7; 
                upsertObj.Q_11_8__c = qAll.q11.answer8;
                upsertObj.Q_11_9__c = qAll.q11.answer9;
            }*/
            if(qAll.q11 != null)
            {
                if(qAll.q11.answer1 != 'NUR')upsertObj.Q_11_1__c = qAll.q11.answer1;
                if(qAll.q11.answer2 != 'NUR')upsertObj.Q_11_2__c = qAll.q11.answer2;
                if(qAll.q11.answer3 != 'NUR')upsertObj.Q_11_3__c = qAll.q11.answer3;
                if(qAll.q11.answer4 != 'NUR')upsertObj.Q_11_4__c = qAll.q11.answer4;
                if(qAll.q11.answer5 != 'NUR')upsertObj.Q_11_5__c = qAll.q11.answer5;
                if(qAll.q11.answer6 != 'NUR')upsertObj.Q_11_6__c = qAll.q11.answer6;
                if(qAll.q11.answer7 != 'NUR')upsertObj.Q_11_7__c = qAll.q11.answer7; 
                if(qAll.q11.answer8 != 'NUR')upsertObj.Q_11_8__c = qAll.q11.answer8;
                if(qAll.q11.answer9 != 'NUR')upsertObj.Q_11_9__c = qAll.q11.answer9;
            }
            //=======================================================//
            if(qAll.q12 != null)
            {
                upsertObj.Q_12_1__c = qAll.q12.answer_2_1;
                upsertObj.Q_12_2__c = qAll.q12.answer_2_2;
                upsertObj.Q_12_3__c = qAll.q12.answer_2_3;
                upsertObj.Q_12_4__c = qAll.q12.answer_2_4;
            }
            //=======================================================//
            if(qAll.q13 != null)upsertObj.Q_13__c = qAll.q13.answer; 
            if(qAll.q14 != null)upsertObj.Q_14__c = qAll.q14.answer;
            if(qAll.q16 != null)upsertObj.Q_16__c = qAll.q16.answer; 
            //=======================================================//
            /*
            if(qAll.q15 != null)
            {
                upsertObj.Q_15_1__c = qAll.q15.answer1;
                upsertObj.Q_15_2__c = qAll.q15.answer2;
                upsertObj.Q_15_3__c = qAll.q15.answer3;
                upsertObj.Q_15_4__c = qAll.q15.answer4;
                upsertObj.Q_15_5__c = qAll.q15.answer5;
                upsertObj.Q_15_6__c = qAll.q15.answer6;
                upsertObj.Q_15_7__c = qAll.q15.answer7; 
                upsertObj.Q_15_8__c = qAll.q15.answer8;
                upsertObj.Q_15_9__c = qAll.q15.answer9;
            }*/
            if(qAll.q15 != null)
            {
                if(qAll.q15.answer1 != 'NUR')upsertObj.Q_15_1__c = qAll.q15.answer1;
                if(qAll.q15.answer2 != 'NUR')upsertObj.Q_15_2__c = qAll.q15.answer2;
                if(qAll.q15.answer3 != 'NUR')upsertObj.Q_15_3__c = qAll.q15.answer3;
                if(qAll.q15.answer4 != 'NUR')upsertObj.Q_15_4__c = qAll.q15.answer4;
                if(qAll.q15.answer5 != 'NUR')upsertObj.Q_15_5__c = qAll.q15.answer5;
                if(qAll.q15.answer6 != 'NUR')upsertObj.Q_15_6__c = qAll.q15.answer6;
                if(qAll.q15.answer7 != 'NUR')upsertObj.Q_15_7__c = qAll.q15.answer7; 
                if(qAll.q15.answer8 != 'NUR')upsertObj.Q_15_8__c = qAll.q15.answer8;
                if(qAll.q15.answer9 != 'NUR')upsertObj.Q_15_9__c = qAll.q15.answer9;
            }
            //=======================================================//
            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('careerSkillsEndline.saveAllQA, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class qAnswerAll{
        comboAnswer q11;
        q12Answer q12;
        qAnswer q13;
        qAnswer q14;
        comboAnswer q15;
        qAnswer q16;

        public qAnswerAll(){
            q11 = new comboAnswer();
            q12 = new q12Answer();
            q13 = new qAnswer();
            q14 = new qAnswer();
            q15 = new comboAnswer();
            q16 = new qAnswer();
        }
    }

    @AuraEnabled
    public static String submitAndCalculate(String recordId){   
        Savepoint sp = Database.setSavepoint();
        try{
            List<Career_Skill__c> csList = new List<Career_Skill__c>([
                SELECT Name, Student__r.Name, Barcode__c,
                Form_Submitted__c, Created_from_Form__c,    
                Q_11_1__c, Q_11_2__c, Q_11_3__c, Q_11_4__c, Q_11_5__c, Q_11_6__c, Q_11_7__c, Q_11_8__c, Q_11_9__c,
                Q_12_1__c, Q_12_2__c, Q_12_3__c, Q_12_4__c,
                Q_13__c, 
                Q_14__c,
                Q_15_1__c, Q_15_2__c, Q_15_3__c, Q_15_4__c, Q_15_5__c, Q_15_6__c, Q_15_7__c, Q_15_8__c, Q_15_9__c,
                Q_16__c
                FROM Career_Skill__c
                WHERE Id = :recordId
            ]);

            Career_Skill__c recSubmitStatus = new Career_Skill__c(Id = recordId);
            recSubmitStatus.Form_Submitted__c = true;
            recSubmitStatus.Q_11_Ans__c = 0;
            recSubmitStatus.Q_12_Ans__c = 0;
            recSubmitStatus.Q_13_Ans__c = 0;
            recSubmitStatus.Q_14_Ans__c = 0;
            recSubmitStatus.Q_15_Ans__c = 0;
            recSubmitStatus.Q_16_Ans__c = 0;
            update recSubmitStatus;

            CareerSkillTriggerHandler.populateStudentAndMarksCalculation(csList);

            return 'success';
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug('careerSkillsEndline.submitAndCalculate, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
}