public without sharing class CareerPlanning_A {
    private static Id cpRecordTypeId = Schema.SObjectType.Career_Planning__c.getRecordTypeInfosByDeveloperName()
    .get('Baseline').getRecordTypeId();

    public CareerPlanning_A() {

    }

    @AuraEnabled
    public static singleRecordWrapper getApexRecord(String studentId, String grade) {
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
                }else if(grade == 'Grade 10')
                {
                    studentBarcode = studentContact[0].Grade_10_Barcode__c;
                }else if(grade == 'Grade 11')
                {
                    studentBarcode = studentContact[0].Grade_11_Barcode__c;
                }else if(grade == 'Grade 12'){
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

                List<Career_Planning__c> cpList = [
                    SELECT Name, Student__r.Name, Barcode__c,
                    Form_Submitted__c, Created_from_Form__c,    
                    Q_7__c, Q_8__c,
                    Q_9_1__c, Q_9_2__c, Q_9_3__c, Q_9_4__c, Q_9_5__c, Q_9_6__c, Q_9_7__c,
                    Q_10__c
                    FROM Career_Planning__c 
                    WHERE Created_from_Form__c = true
                    AND Student__c = :studentId
                    AND Barcode__c = :studentBarcode
                    AND RecordTypeId = :cpRecordTypeId
                    LIMIT 1
                ];

                if(cpList.isEmpty())break;
                
                rsp.apexRecord = cpList[0];
                //System.debug('rsp.recordCDM2 : '+ rsp.apexRecord);
            }while(false);
            return rsp;
        } catch (Exception e) {
            System.debug('CareerPlanning_A.getApexRecord, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class singleRecordWrapper{
        @AuraEnabled 
        public Career_Planning__c apexRecord {get;set;}

        @AuraEnabled 
        public String studentBarcode {get;set;}

        @AuraEnabled 
        public String studentName {get;set;}
        /*
        @AuraEnabled 
        public String studentGrade {get;set;}*/
    }

    @AuraEnabled
    public static String saveSingle(String recordIdCP, String studentId, String barCode, String qNo, object ans, string lng, string typ){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            qAnswer qS = (qAnswer) System.JSON.deserialize(jsonString, qAnswer.class);

            // System.debug('qS.answer : ' + qS.answer); 
            // System.debug('qNo : ' + qNo);  

            // System.debug('recordIdCP : ' + recordIdCP); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            Career_Planning__c upsertObj = new Career_Planning__c();
            if(recordIdCP != null)
            {
                upsertObj.Id = recordIdCP;
                rspId = recordIdCP;
            }
            else 
            {
                List<Career_Planning__c> existing = new List<Career_Planning__c>([
                    SELECT Id 
                    FROM Career_Planning__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :cpRecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }     
            upsertObj.RecordTypeId = cpRecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;
            upsertObj.Form_Language__c = lng;
            upsertObj.Form_Name__c = typ;

            if(qNo == '07')upsertObj.Q_7__c = qS.answer; 
            else if(qNo == '08')upsertObj.Q_8__c = qS.answer;
            else if(qNo == '10')upsertObj.Q_10__c = qS.answer;          

            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('CareerPlanning_A.saveSingle, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class qAnswer{
        String answer;
    }

    @AuraEnabled
    public static String saveQuestion09(String recordIdCP, String studentId, String barCode, object ans, string lng, string typ){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            q09Answer q09 = (q09Answer) System.JSON.deserialize(jsonString, q09Answer.class);

            // System.debug('q09 : ' + q09);  

            // System.debug('recordIdCP : ' + recordIdCP); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            Career_Planning__c upsertObj = new Career_Planning__c();
            if(recordIdCP != null)
            {
                upsertObj.Id = recordIdCP;
                rspId = recordIdCP;
            }
            else 
            {
                List<Career_Planning__c> existing = new List<Career_Planning__c>([
                    SELECT Id 
                    FROM Career_Planning__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :cpRecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }     
            upsertObj.RecordTypeId = cpRecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;
            upsertObj.Form_Language__c = lng;
            upsertObj.Form_Name__c = typ;

            upsertObj.Q_9_1__c = q09.answer1;
            upsertObj.Q_9_2__c = q09.answer2;
            upsertObj.Q_9_3__c = q09.answer3;
            upsertObj.Q_9_4__c = q09.answer4;
            upsertObj.Q_9_5__c = q09.answer5;
            upsertObj.Q_9_6__c = q09.answer6;
            upsertObj.Q_9_7__c = q09.answer7;        

            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('CareerPlanning_A.saveQuestion09, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class q09Answer{
        String answer1;
        String answer2;
        String answer3; 
        String answer4;
        String answer5;
        String answer6; 
        String answer7;
    }

    @AuraEnabled
    public static String saveAllQA(String recordIdCP, String studentId, String barCode, object ans, string lng, string typ){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            qAnswerAll qAll = (qAnswerAll) System.JSON.deserialize(jsonString, qAnswerAll.class); 

            // System.debug('recordIdCP : ' + recordIdCP); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            // System.debug('qAll.q07 : ' + qAll.q07);
            // System.debug('qAll.q08 : ' + qAll.q08);
            // System.debug('qAll.q09 : ' + qAll.q09);
            // System.debug('qAll.q10 : ' + qAll.q10);

            Career_Planning__c upsertObj = new Career_Planning__c();
            if(recordIdCP != null)
            {
                upsertObj.Id = recordIdCP;
                rspId = recordIdCP;
            } 
            else 
            {
                List<Career_Planning__c> existing = new List<Career_Planning__c>([
                    SELECT Id 
                    FROM Career_Planning__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :cpRecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }     
            upsertObj.RecordTypeId = cpRecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;
            upsertObj.Form_Language__c = lng;
            upsertObj.Form_Name__c = typ;
            upsertObj.Form_Submitted__c=true;

            //=======================================================//
            if(qAll.q07 != null)upsertObj.Q_7__c = qAll.q07.answer;
            //=======================================================//
            if(qAll.q08 != null)upsertObj.Q_8__c = qAll.q08.answer;
            //=======================================================//
            if(qAll.q09 != null)
            {
                upsertObj.Q_9_1__c =  qAll.q09.answer1;
                upsertObj.Q_9_2__c =  qAll.q09.answer2;
                upsertObj.Q_9_3__c =  qAll.q09.answer3;
                upsertObj.Q_9_4__c =  qAll.q09.answer4;
                upsertObj.Q_9_5__c =  qAll.q09.answer5;
                upsertObj.Q_9_6__c =  qAll.q09.answer6;
                upsertObj.Q_9_7__c =  qAll.q09.answer7;
            }
            //=======================================================//
            if(qAll.q10 != null)upsertObj.Q_10__c = qAll.q10.answer;
            //=======================================================//
            upsert upsertObj;

            if(String.isBlank(rspId)){
                rspId = upsertObj.Id;
                List<Career_Planning__c> cpList = [
                        SELECT Name, Student__r.Name, Barcode__c,
                        Form_Submitted__c, Created_from_Form__c,    
                        Q_7__c, Q_8__c,
                        Q_9_1__c, Q_9_2__c, Q_9_3__c, Q_9_4__c, Q_9_5__c, Q_9_6__c, Q_9_7__c,
                        Q_10__c
                        FROM Career_Planning__c 
                        WHERE Id = :rspId
                        LIMIT 1
                    ];
                CareerPlanningTriggerHandler.calculateCareerPlanningMarks(cpList);
            }
            return rspId;
        } catch (Exception e) {
            System.debug('CareerPlanning_A.saveAllQA, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class qAnswerAll{
        qAnswer q07;
        qAnswer q08;
        q09Answer q09;
        qAnswer q10;

        public qAnswerAll(){
            q07 = new qAnswer();
            q08 = new qAnswer();
            q09 = new q09Answer();
            q10 = new qAnswer();
        }
    }

    @AuraEnabled
    public static String submitAndCalculate(String recordIdCP, String cdm1Id, String cdm2Id, string lng, string typ){   
        Savepoint sp = Database.setSavepoint();

        if(cdm1Id != null)careerDecisionMaking_01.submitAndCalculate(cdm1Id);
        if(cdm2Id != null)careerDecisionMaking_02.submitAndCalculate(cdm2Id);

        try{
            List<Career_Planning__c> cpList = [
                SELECT Name, Student__r.Name, Barcode__c,
                Form_Submitted__c, Created_from_Form__c,    
                Q_7__c, Q_8__c,
                Q_9_1__c, Q_9_2__c, Q_9_3__c, Q_9_4__c, Q_9_5__c, Q_9_6__c, Q_9_7__c,
                Q_10__c
                FROM Career_Planning__c 
                WHERE Id = :recordIdCP
                LIMIT 1
            ];

            Career_Planning__c recSubmitStatus = new Career_Planning__c(Id = recordIdCP);
            recSubmitStatus.Form_Submitted__c = true;
			recSubmitStatus.Form_Name__c = typ;
            recSubmitStatus.Form_Language__c = lng;
            recSubmitStatus.Q_7_Marks__c = 0;
            recSubmitStatus.Q_8_Marks__c = 0;
            recSubmitStatus.Q_10_Marks__c = 0;
            recSubmitStatus.Q_9_1_Marks__c = 0;
            recSubmitStatus.Q_9_2_Marks__c = 0;
            recSubmitStatus.Q_9_3_Marks__c = 0;
            recSubmitStatus.Q_9_4_Marks__c = 0;
            recSubmitStatus.Q_9_5_Marks__c = 0;
            recSubmitStatus.Q_9_6_Marks__c = 0;
            recSubmitStatus.Q_9_7_Marks__c = 0;

            update recSubmitStatus;

            CareerPlanningTriggerHandler.calculateCareerPlanningMarks(cpList);

            return 'success';
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug('CareerPlanning_A.submitAndCalculate, e.getMessage() : ' + e.getMessage());
            System.debug('CareerPlanning_A.submitAndCalculate, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
}