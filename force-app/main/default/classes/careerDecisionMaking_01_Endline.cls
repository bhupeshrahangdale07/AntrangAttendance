public without sharing class careerDecisionMaking_01_Endline {

    private static Id cdm1RecordTypeId = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByDeveloperName()
    .get('Endline').getRecordTypeId();

    public careerDecisionMaking_01_Endline() {

    }

    @AuraEnabled
    public static singleRecordWrapper getRecordCDM1(String studentId, String grade) {
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

                List<OMR_Assessment__c> cdm1List = [
                    SELECT Name, Student__r.Name, Barcode__c,
                    Form_Submitted__c, Created_from_Form__c,
                    Q_1__c,
                    Q_2_1__c, Q_2_2__c, Q_2_3__c, Q_2_4__c, Q_2_5__c, Q_2_6__c, Q_2_7__c,
                    Q3_1__c, Q3_2__c, Q3_3__c, Q3_4__c, Q3_5__c, Q3_6__c, Q3_7__c,
                    Q4_1__c, Q4_2__c, Q4_3__c , Q4_4__c, Q4_5__c, Q4_6__c, Q4_7__c , Q4_8__c, Q4_9__c, Q4_10__c,
                    Q4_11__c, Q4_12__c, Q4_13__c , Q4_14__c, Q4_15__c, Q4_16__c, Q4_17__c , Q4_18__c, Q4_19__c, Q4_20__c,
                    Q4_21__c, Q4_22__c, Q4_23__c , Q4_24__c, Q4_25__c, Q4_26__c, Q4_27__c , Q4_28__c, Q4_29__c, Q4_30__c,
                    Q4_31__c, Q4_32__c, Q4_33__c , Q4_34__c, Q4_35__c, Q4_36__c, Q4_37__c , Q4_38__c, Q4_39__c, Q4_40__c,
                    Q4_41__c, Q4_42__c, Q4_43__c , Q4_44__c, Q4_45__c, Q4_46__c, Q4_47__c , Q4_48__c, Q4_49__c, Q4_50__c,
                    Q4_51__c, Q4_52__c, Q4_53__c
                    FROM OMR_Assessment__c 
                    WHERE Created_from_Form__c = true
                    AND Student__c = :studentId
                    AND Barcode__c = :studentBarcode
                    AND RecordTypeId = :cdm1RecordTypeId
                    LIMIT 1
                ];

                if(cdm1List.isEmpty())break;
                
                rsp.recordCDM1 = cdm1List[0];
                //System.debug('rsp.recordCDM1 : '+ rsp.recordCDM1);
            }while(false);
            return rsp;
        } catch (Exception e) {
            System.debug('getRecordCDM1, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class singleRecordWrapper{
        @AuraEnabled 
        public OMR_Assessment__c recordCDM1 {get;set;}

        @AuraEnabled 
        public String studentBarcode {get;set;}

        @AuraEnabled 
        public String studentName {get;set;}
        /*
        @AuraEnabled 
        public String studentGrade {get;set;}*/
    }

    @AuraEnabled
    public static String saveQuestion01(String recordIdCMD1, String studentId, String barCode, object ans){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            q01Answer q01 = (q01Answer) System.JSON.deserialize(jsonString, q01Answer.class);

            // System.debug('q01.answer : ' + q01.answer);  

            // System.debug('recordIdCMD1 : ' + recordIdCMD1); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            OMR_Assessment__c upsertObj = new OMR_Assessment__c();
            if(recordIdCMD1 != null)
            {
                upsertObj.Id = recordIdCMD1;
                rspId = recordIdCMD1;
            } 
            else 
            {
                List<OMR_Assessment__c> existing = new List<OMR_Assessment__c>([
                    SELECT Id 
                    FROM OMR_Assessment__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :cdm1RecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }     
            upsertObj.RecordTypeId = cdm1RecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;

            upsertObj.Q_1__c = q01.answer;

            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('saveQuestion01, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class q01Answer{
        String answer;
    }

    @AuraEnabled
    public static String saveQuestion02(String recordIdCMD1, String studentId, String barCode, object ans){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            q02Answer q02 = (q02Answer) System.JSON.deserialize(jsonString, q02Answer.class);

            // System.debug('q02.answer_2_1 : ' + q02.answer_2_1);  
            // System.debug('q02.answer_2_2 : ' + q02.answer_2_2); 
            // System.debug('q02.answer_2_3 : ' + q02.answer_2_3); 
            // System.debug('q02.answer_2_4 : ' + q02.answer_2_4);  
            // System.debug('q02.answer_2_5 : ' + q02.answer_2_5);  
            // System.debug('q02.answer_2_6 : ' + q02.answer_2_6);
            // System.debug('q02.answer_2_7 : ' + q02.answer_2_7); 
 
            // System.debug('recordIdCMD1 : ' + recordIdCMD1); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            OMR_Assessment__c upsertObj = new OMR_Assessment__c();
            if(recordIdCMD1 != null)
            {
                upsertObj.Id = recordIdCMD1;
                rspId = recordIdCMD1;
            } 
            else 
            {
                List<OMR_Assessment__c> existing = new List<OMR_Assessment__c>([
                    SELECT Id 
                    FROM OMR_Assessment__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :cdm1RecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }     
            upsertObj.RecordTypeId = cdm1RecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;

            upsertObj.Q_2_1__c = q02.answer_2_1;
            upsertObj.Q_2_2__c = q02.answer_2_2;
            upsertObj.Q_2_3__c = q02.answer_2_3;
            upsertObj.Q_2_4__c = q02.answer_2_4;
            upsertObj.Q_2_5__c = q02.answer_2_5;
            upsertObj.Q_2_6__c = q02.answer_2_6;
            upsertObj.Q_2_7__c = q02.answer_2_7;

            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('saveQuestion02, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class q02Answer{
        String answer_2_1;
        String answer_2_2;
        String answer_2_3; 
        String answer_2_4;
        String answer_2_5;
        String answer_2_6; 
        String answer_2_7;
    }

    @AuraEnabled
    public static String saveQuestion03(String recordIdCMD1, String studentId, String barCode, object ans){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            q03Answer q03 = (q03Answer) System.JSON.deserialize(jsonString, q03Answer.class);

            // System.debug('q03.answer_3_1 : ' + q03.answer_3_1);  
            // System.debug('q03.answer_3_2 : ' + q03.answer_3_2); 
            // System.debug('q03.answer_3_3 : ' + q03.answer_3_3); 
            // System.debug('q03.answer_3_4 : ' + q03.answer_3_4);  
            // System.debug('q03.answer_3_5 : ' + q03.answer_3_5);  
            // System.debug('q03.answer_3_6 : ' + q03.answer_3_6);
            // System.debug('q03.answer_3_7 : ' + q03.answer_3_7); 
 
            // System.debug('recordIdCMD1 : ' + recordIdCMD1); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            OMR_Assessment__c upsertObj = new OMR_Assessment__c();
            if(recordIdCMD1 != null)
            {
                upsertObj.Id = recordIdCMD1;
                rspId = recordIdCMD1;
            }  
            else 
            {
                List<OMR_Assessment__c> existing = new List<OMR_Assessment__c>([
                    SELECT Id 
                    FROM OMR_Assessment__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :cdm1RecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }    
            upsertObj.RecordTypeId = cdm1RecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;

            upsertObj.Q3_1__c = q03.answer_3_1;
            upsertObj.Q3_2__c = q03.answer_3_2;
            upsertObj.Q3_3__c = q03.answer_3_3;
            upsertObj.Q3_4__c = q03.answer_3_4;
            upsertObj.Q3_5__c = q03.answer_3_5;
            upsertObj.Q3_6__c = q03.answer_3_6;
            upsertObj.Q3_7__c = q03.answer_3_7;

            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('saveQuestion03, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class q03Answer{
        String answer_3_1;
        String answer_3_2;
        String answer_3_3; 
        String answer_3_4;
        String answer_3_5;
        String answer_3_6; 
        String answer_3_7;
    }

    @AuraEnabled
    public static String saveQuestion04(String recordIdCMD1, String studentId, String barCode, object ans){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            q04Answer q04 = (q04Answer) System.JSON.deserialize(jsonString, q04Answer.class);
 
            // System.debug('recordIdCMD1 : ' + recordIdCMD1); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            OMR_Assessment__c upsertObj = new OMR_Assessment__c();
            if(recordIdCMD1 != null)
            {
                upsertObj.Id = recordIdCMD1;
                rspId = recordIdCMD1;
            }  
            else 
            {
                List<OMR_Assessment__c> existing = new List<OMR_Assessment__c>([
                    SELECT Id 
                    FROM OMR_Assessment__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :cdm1RecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }    
            upsertObj.RecordTypeId = cdm1RecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;

            upsertObj.Q4_1__c = q04.answer_4_1;
            upsertObj.Q4_2__c = q04.answer_4_2;
            upsertObj.Q4_3__c = q04.answer_4_3;
            upsertObj.Q4_4__c = q04.answer_4_4;
            upsertObj.Q4_5__c = q04.answer_4_5;
            upsertObj.Q4_6__c = q04.answer_4_6;
            upsertObj.Q4_7__c = q04.answer_4_7;
            upsertObj.Q4_8__c = q04.answer_4_8;
            upsertObj.Q4_9__c = q04.answer_4_9;
            upsertObj.Q4_10__c = q04.answer_4_10;

            upsertObj.Q4_11__c = q04.answer_4_11;
            upsertObj.Q4_12__c = q04.answer_4_12;
            upsertObj.Q4_13__c = q04.answer_4_13;
            upsertObj.Q4_14__c = q04.answer_4_14;
            upsertObj.Q4_15__c = q04.answer_4_15;
            upsertObj.Q4_16__c = q04.answer_4_16;
            upsertObj.Q4_17__c = q04.answer_4_17;
            upsertObj.Q4_18__c = q04.answer_4_18;
            upsertObj.Q4_19__c = q04.answer_4_19;
            upsertObj.Q4_20__c = q04.answer_4_20;

            upsertObj.Q4_21__c = q04.answer_4_21;
            upsertObj.Q4_22__c = q04.answer_4_22;
            upsertObj.Q4_23__c = q04.answer_4_23;
            upsertObj.Q4_24__c = q04.answer_4_24;
            upsertObj.Q4_25__c = q04.answer_4_25;
            upsertObj.Q4_26__c = q04.answer_4_26;
            upsertObj.Q4_27__c = q04.answer_4_27;
            upsertObj.Q4_28__c = q04.answer_4_28;
            upsertObj.Q4_29__c = q04.answer_4_29;
            upsertObj.Q4_30__c = q04.answer_4_30;

            upsertObj.Q4_31__c = q04.answer_4_31;
            upsertObj.Q4_32__c = q04.answer_4_32;
            upsertObj.Q4_33__c = q04.answer_4_33;
            upsertObj.Q4_34__c = q04.answer_4_34;
            upsertObj.Q4_35__c = q04.answer_4_35;
            upsertObj.Q4_36__c = q04.answer_4_36;
            upsertObj.Q4_37__c = q04.answer_4_37;
            upsertObj.Q4_38__c = q04.answer_4_38;
            upsertObj.Q4_39__c = q04.answer_4_39;
            upsertObj.Q4_40__c = q04.answer_4_40;

            upsertObj.Q4_41__c = q04.answer_4_41;
            upsertObj.Q4_42__c = q04.answer_4_42;
            upsertObj.Q4_43__c = q04.answer_4_43;
            upsertObj.Q4_44__c = q04.answer_4_44;
            upsertObj.Q4_45__c = q04.answer_4_45;
            upsertObj.Q4_46__c = q04.answer_4_46;
            upsertObj.Q4_47__c = q04.answer_4_47;
            upsertObj.Q4_48__c = q04.answer_4_48;
            upsertObj.Q4_49__c = q04.answer_4_49;
            upsertObj.Q4_50__c = q04.answer_4_50;

            upsertObj.Q4_51__c = q04.answer_4_51;
            upsertObj.Q4_52__c = q04.answer_4_52;
            upsertObj.Q4_53__c = q04.answer_4_53;

            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('saveQuestion04, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class q04Answer{
        String answer_4_1;
        String answer_4_2;
        String answer_4_3; 
        String answer_4_4;
        String answer_4_5;
        String answer_4_6; 
        String answer_4_7;
        String answer_4_8; 
        String answer_4_9;
        String answer_4_10;
        String answer_4_11;
        String answer_4_12;
        String answer_4_13; 
        String answer_4_14;
        String answer_4_15;
        String answer_4_16; 
        String answer_4_17;
        String answer_4_18; 
        String answer_4_19;
        String answer_4_20;
        String answer_4_21;
        String answer_4_22;
        String answer_4_23; 
        String answer_4_24;
        String answer_4_25;
        String answer_4_26; 
        String answer_4_27;
        String answer_4_28; 
        String answer_4_29;
        String answer_4_30;
        String answer_4_31;
        String answer_4_32;
        String answer_4_33; 
        String answer_4_34;
        String answer_4_35;
        String answer_4_36; 
        String answer_4_37;
        String answer_4_38; 
        String answer_4_39;
        String answer_4_40;
        String answer_4_41;
        String answer_4_42;
        String answer_4_43; 
        String answer_4_44;
        String answer_4_45;
        String answer_4_46; 
        String answer_4_47;
        String answer_4_48; 
        String answer_4_49;
        String answer_4_50;
        String answer_4_51;
        String answer_4_52;
        String answer_4_53; 
    }

    @AuraEnabled
    public static String saveAllQA(String recordIdCMD1, String studentId, String barCode, object ans, string lng, string typ){
        try{
            string rspId = '';
            String jsonString = Json.serialize(ans);
            qAnswerAll qAll = (qAnswerAll) System.JSON.deserialize(jsonString, qAnswerAll.class);
 
            // System.debug('recordIdCMD1 : ' + recordIdCMD1); 
            // System.debug('studentId : ' + studentId); 
            // System.debug('barCode : ' + barCode); 

            // System.debug('qAll.q01 : ' + qAll.q01);
            // System.debug('qAll.q02 : ' + qAll.q02);
            // System.debug('qAll.q03 : ' + qAll.q03);
            // System.debug('qAll.q04 : ' + qAll.q04);

            OMR_Assessment__c upsertObj = new OMR_Assessment__c();
            if(recordIdCMD1 != null)
            {
                upsertObj.Id = recordIdCMD1;
                rspId = recordIdCMD1;
            }  
            else 
            {
                List<OMR_Assessment__c> existing = new List<OMR_Assessment__c>([
                    SELECT Id 
                    FROM OMR_Assessment__c
                    WHERE Created_from_Form__c = true
                    AND RecordTypeId = :cdm1RecordTypeId
                    AND Student__c = :studentId
                    AND Barcode__c = :barCode]);   

                if(!existing.isEmpty())
                {
                    upsertObj.Id = existing[0].Id;
                    rspId = existing[0].Id;
                }
            }    
            upsertObj.RecordTypeId = cdm1RecordTypeId;     
            upsertObj.Student__c = studentId;
            upsertObj.Barcode__c = barCode;
            upsertObj.Created_from_Form__c = true;
            upsertObj.Form_Language__c = lng;
            upsertObj.Form_Name__c = typ;
            //========================================================//
            if(qAll.q01 != null)upsertObj.Q_1__c = qAll.q01.answer;
            //========================================================//
            if(qAll.q02 != null)
            {
                upsertObj.Q_2_1__c = qAll.q02.answer_2_1;
                upsertObj.Q_2_2__c = qAll.q02.answer_2_2;
                upsertObj.Q_2_3__c = qAll.q02.answer_2_3;
                upsertObj.Q_2_4__c = qAll.q02.answer_2_4;
                upsertObj.Q_2_5__c = qAll.q02.answer_2_5;
                upsertObj.Q_2_6__c = qAll.q02.answer_2_6;
                upsertObj.Q_2_7__c = qAll.q02.answer_2_7;
            }
            //========================================================//
            if(qAll.q03 != null)
            {
                upsertObj.Q3_1__c = qAll.q03.answer_3_1;
                upsertObj.Q3_2__c = qAll.q03.answer_3_2;
                upsertObj.Q3_3__c = qAll.q03.answer_3_3;
                upsertObj.Q3_4__c = qAll.q03.answer_3_4;
                upsertObj.Q3_5__c = qAll.q03.answer_3_5;
                upsertObj.Q3_6__c = qAll.q03.answer_3_6;
                upsertObj.Q3_7__c = qAll.q03.answer_3_7;
            }
            //========================================================//
            if(qAll.q04 != null)
            {
                upsertObj.Q4_1__c = qAll.q04.answer_4_1;
                upsertObj.Q4_2__c = qAll.q04.answer_4_2;
                upsertObj.Q4_3__c = qAll.q04.answer_4_3;
                upsertObj.Q4_4__c = qAll.q04.answer_4_4;
                upsertObj.Q4_5__c = qAll.q04.answer_4_5;
                upsertObj.Q4_6__c = qAll.q04.answer_4_6;
                upsertObj.Q4_7__c = qAll.q04.answer_4_7;
                upsertObj.Q4_8__c = qAll.q04.answer_4_8;
                upsertObj.Q4_9__c = qAll.q04.answer_4_9;
                upsertObj.Q4_10__c = qAll.q04.answer_4_10;

                upsertObj.Q4_11__c = qAll.q04.answer_4_11;
                upsertObj.Q4_12__c = qAll.q04.answer_4_12;
                upsertObj.Q4_13__c = qAll.q04.answer_4_13;
                upsertObj.Q4_14__c = qAll.q04.answer_4_14;
                upsertObj.Q4_15__c = qAll.q04.answer_4_15;
                upsertObj.Q4_16__c = qAll.q04.answer_4_16;
                upsertObj.Q4_17__c = qAll.q04.answer_4_17;
                upsertObj.Q4_18__c = qAll.q04.answer_4_18;
                upsertObj.Q4_19__c = qAll.q04.answer_4_19;
                upsertObj.Q4_20__c = qAll.q04.answer_4_20;

                upsertObj.Q4_21__c = qAll.q04.answer_4_21;
                upsertObj.Q4_22__c = qAll.q04.answer_4_22;
                upsertObj.Q4_23__c = qAll.q04.answer_4_23;
                upsertObj.Q4_24__c = qAll.q04.answer_4_24;
                upsertObj.Q4_25__c = qAll.q04.answer_4_25;
                upsertObj.Q4_26__c = qAll.q04.answer_4_26;
                upsertObj.Q4_27__c = qAll.q04.answer_4_27;
                upsertObj.Q4_28__c = qAll.q04.answer_4_28;
                upsertObj.Q4_29__c = qAll.q04.answer_4_29;
                upsertObj.Q4_30__c = qAll.q04.answer_4_30;

                upsertObj.Q4_31__c = qAll.q04.answer_4_31;
                upsertObj.Q4_32__c = qAll.q04.answer_4_32;
                upsertObj.Q4_33__c = qAll.q04.answer_4_33;
                upsertObj.Q4_34__c = qAll.q04.answer_4_34;
                upsertObj.Q4_35__c = qAll.q04.answer_4_35;
                upsertObj.Q4_36__c = qAll.q04.answer_4_36;
                upsertObj.Q4_37__c = qAll.q04.answer_4_37;
                upsertObj.Q4_38__c = qAll.q04.answer_4_38;
                upsertObj.Q4_39__c = qAll.q04.answer_4_39;
                upsertObj.Q4_40__c = qAll.q04.answer_4_40;

                upsertObj.Q4_41__c = qAll.q04.answer_4_41;
                upsertObj.Q4_42__c = qAll.q04.answer_4_42;
                upsertObj.Q4_43__c = qAll.q04.answer_4_43;
                upsertObj.Q4_44__c = qAll.q04.answer_4_44;
                upsertObj.Q4_45__c = qAll.q04.answer_4_45;
                upsertObj.Q4_46__c = qAll.q04.answer_4_46;
                upsertObj.Q4_47__c = qAll.q04.answer_4_47;
                upsertObj.Q4_48__c = qAll.q04.answer_4_48;
                upsertObj.Q4_49__c = qAll.q04.answer_4_49;
                upsertObj.Q4_50__c = qAll.q04.answer_4_50;

                upsertObj.Q4_51__c = qAll.q04.answer_4_51;
                upsertObj.Q4_52__c = qAll.q04.answer_4_52;
                upsertObj.Q4_53__c = qAll.q04.answer_4_53;
            }
            //========================================================//
            upsert upsertObj;

            if(String.isBlank(rspId))rspId = upsertObj.Id;
            return rspId;
        } catch (Exception e) {
            System.debug('saveAllQA, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class qAnswerAll{
        q01Answer q01;
        q02Answer q02;
        q03Answer q03;
        q04Answer q04;

        public qAnswerAll(){
            q01 = new q01Answer();
            q02 = new q02Answer();
            q03 = new q03Answer();
            q04 = new q04Answer();
        }
    }

    @AuraEnabled
    public static String submitAndCalculate(String recordIdCMD1){
        Savepoint sp = Database.setSavepoint();
        try{

            List<OMR_Assessment__c> cdm1List = [
                SELECT Name, Student__r.Name, Barcode__c,
                Form_Submitted__c, Created_from_Form__c,
                Q_1__c,
                Q_2_1__c, Q_2_2__c, Q_2_3__c, Q_2_4__c, Q_2_5__c, Q_2_6__c, Q_2_7__c,
                Q3_1__c, Q3_2__c, Q3_3__c, Q3_4__c, Q3_5__c, Q3_6__c, Q3_7__c,
                Q4_1__c, Q4_2__c, Q4_3__c , Q4_4__c, Q4_5__c, Q4_6__c, Q4_7__c , Q4_8__c, Q4_9__c, Q4_10__c,
                Q4_11__c, Q4_12__c, Q4_13__c , Q4_14__c, Q4_15__c, Q4_16__c, Q4_17__c , Q4_18__c, Q4_19__c, Q4_20__c,
                Q4_21__c, Q4_22__c, Q4_23__c , Q4_24__c, Q4_25__c, Q4_26__c, Q4_27__c , Q4_28__c, Q4_29__c, Q4_30__c,
                Q4_31__c, Q4_32__c, Q4_33__c , Q4_34__c, Q4_35__c, Q4_36__c, Q4_37__c , Q4_38__c, Q4_39__c, Q4_40__c,
                Q4_41__c, Q4_42__c, Q4_43__c , Q4_44__c, Q4_45__c, Q4_46__c, Q4_47__c , Q4_48__c, Q4_49__c, Q4_50__c,
                Q4_51__c, Q4_52__c, Q4_53__c
                FROM OMR_Assessment__c 
                WHERE Id = :recordIdCMD1
                LIMIT 1
            ];

            OMR_Assessment__c recSubmitStatus = new OMR_Assessment__c(Id = recordIdCMD1);
            recSubmitStatus.Form_Submitted__c = true;

            recSubmitStatus.Interest_Marks__c = null;
            recSubmitStatus.Aptitude_Marks__c = null;
            recSubmitStatus.Career_Choice_1_Marks__c = null;
            recSubmitStatus.Career_Choice_2_Marks__c = null;
            recSubmitStatus.Career_Choice_Total_Marks__c = null;
            recSubmitStatus.Interest_1__c = null;
            recSubmitStatus.Interest_2__c = null;
            recSubmitStatus.Aptitude_1__c = null;
            recSubmitStatus.Aptitude_2__c = null;
            recSubmitStatus.Career_Choice_1__c = null;
            recSubmitStatus.Career_Choice_2__c = null;
            update recSubmitStatus;

            //omrAssessmentTriggerHandler.populateStudentOnOMRAssement(cdm1List);
            omrAssessmentTriggerHandler.populateStudentOnOMRAssement(cdm1List);	//updated on 06.07.2023

            return 'success';
        } catch (Exception e) {
            Database.rollback(sp);
            System.debug('submitAndCalculate, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static batchWrapper getBatchInfo(String batchId){ 
        try{
            batchWrapper rsp = new batchWrapper();
            do{
                List<Batch__c> baches = [
                    SELECT Id, Name, School_Name__r.Name, Grade__c, Academic_Year__c, Batch_Number__c
                    FROM Batch__c
                    WHERE Id = :batchId LIMIT 1];

                if(baches.isEmpty())break;
                rsp.batchGrade = baches[0].Grade__c;
                rsp.batchName = baches[0].Name;
                rsp.schoolName = baches[0].School_Name__r.Name;
                rsp.batchNumber = baches[0].Batch_Number__c;
            }while(false);
            return rsp;
        } catch (Exception e) {
            System.debug('getBatchInfo, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class batchWrapper{
        @AuraEnabled 
        public String batchGrade {get;set;}

        @AuraEnabled 
        public String batchName {get;set;}

        @AuraEnabled 
        public String schoolName {get;set;}
        
         @AuraEnabled 
        public String batchNumber {get;set;}


        public batchWrapper(){
            batchGrade = ''; 
            batchName = '';
            schoolName = '';
              batchNumber = '';
        }
    }

    @AuraEnabled
    public static responseWrapper searchStudentRecords(String searchText, String batchId, String grade, string typ){ 
        try{
            responseWrapper rsp = new responseWrapper();
            do{
                String search = '%'+searchText+'%';
                List<Contact> studentList = new List<Contact>([
                    SELECT Id, Name, Batch_Code__c, G10_Batch_Code__c, G11_Batch_Code__c,G12_Batch_Code__c,
                        (SELECT Created_from_Form__c, Future_Planning_form_submitted__c, Feedback_form_submitted__c
                        FROM Planning_for_future__r
                        WHERE Created_from_Form__c = true 
                        AND RecordType.Name = 'Endline') 
                    FROM Contact 
                    WHERE (Batch_Code__c = :batchId OR 
                    G10_Batch_Code__c = :batchId OR
                    G11_Batch_Code__c = :batchId OR G12_Batch_Code__c = :batchId) 
                    AND Name LIKE :search
                ]);

                if(studentList.isEmpty())break;

                Integer batchGradeStudents = 0;
                List<Contact> gradeStudentList = new List<Contact>();
                for(Contact con : studentList)
                {
                    //=========================================================//
                    if(grade == 'Grade 11' && con.G11_Batch_Code__c != null)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con);                     
                    }
                    else if(grade == 'Grade 10' && con.G10_Batch_Code__c != null)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con); 
                    }
                    else if(grade == 'Grade 9' && con.Batch_Code__c != null)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con);
                    }
                    else if(grade == 'Grade 12' && con.G12_Batch_Code__c != null)
                    {
                        batchGradeStudents++;
                        gradeStudentList.add(con);
                    }
                    //=========================================================//
                }

                if(gradeStudentList.isEmpty())break;
                rsp.batchTotalStudents = batchGradeStudents;
                rsp.gradeStudentList = gradeStudentList;

                Map<String,Contact> submittedStudentMap = new Map<String,Contact>();  
                for(Contact con : gradeStudentList)
                {
                    if(!con.Planning_for_future__r.isEmpty())
                    {
                        for(Future_Planning__c cfp : con.Planning_for_future__r)
                        {
                            if((typ == 'Form V2' && cfp.Future_Planning_form_submitted__c) || (cfp.Future_Planning_form_submitted__c && 
                            cfp.Feedback_form_submitted__c && (typ == null || typ == '')))
                            {
                                submittedStudentMap.put(con.Id,con); 
                                break;
                            }
                        }
                    }
                }  
                
                if(submittedStudentMap.isEmpty())break;
                rsp.submittedStudentMap = submittedStudentMap;
            }while(false);
            return rsp;
        } catch (Exception e) {
            System.debug('searchStudentRecords, e.getMessage() : ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class responseWrapper{
        @AuraEnabled 
        public List<Contact> gradeStudentList {get;set;}

        @AuraEnabled 
        public Map<String,Contact> submittedStudentMap {get;set;}

        @AuraEnabled 
        public Integer batchTotalStudents {get;set;}

        public responseWrapper(){
            gradeStudentList = new List<Contact>();
            submittedStudentMap = new Map<String,Contact>();
            batchTotalStudents = 0;
        }
    }
}