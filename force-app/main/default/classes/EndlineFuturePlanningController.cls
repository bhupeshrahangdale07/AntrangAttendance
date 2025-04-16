public without sharing class EndlineFuturePlanningController {
    @AuraEnabled
    public static string autoSaveData(String studentId,string fp17,string fp18_1,string fp18_2,string fp18_3,string fp18_4,string fp18_5,string fp18_6,string fp18_7,string fp18_8,string fp18_9,string fp18_10,string fp18_11,string fp19,string fp20,string fp21,string fp22,boolean saveFlag, string grade) {
        system.debug(':::studentId = '+studentId);
        String returnStr = '';
        try{
            List<Future_Planning__c> sf =  new List<Future_Planning__c>([select id,Created_from_Form__c,Q_17__c,Q_18_1__c,Q_18_2__c,Q_18_3__c,Q_18_4__c,Q_18_5__c,Q_18_6__c,Q_18_7__c,Q_18_8__c,Q_18_9__c,Q_18_10__c,Q_18_11__c,Q_19__c,Q_20__c,Q_21__c,Q_22__c, Student__c from  Future_Planning__c
                                                                         where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Endline' limit 1]);
            if(!sf.isEmpty()){
                returnStr = 'Update';
                system.debug('saveFlag ='+saveFlag);
                dataPrepare(saveFlag,sf[0],fp17,fp18_1,fp18_2,fp18_3,fp18_4,fp18_5,fp18_6,fp18_7,fp18_8,fp18_9,fp18_10,fp18_11,fp19,fp20,fp21,fp22);
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
                RecordType rt = [select id, name, SobjectType from RecordType where SobjectType = 'Future_Planning__c' and name = 'Endline'];
                Future_Planning__c sf1 = new Future_Planning__c(Created_from_Form__c = true, Student__c = studentId, Barcode__c = barcode, RecordTypeId = rt.id);
                dataPrepare(saveFlag,sf1,fp17,fp18_1,fp18_2,fp18_3,fp18_4,fp18_5,fp18_6,fp18_7,fp18_8,fp18_9,fp18_10,fp18_11,fp19,fp20,fp21,fp22);
            }
            
            return returnStr;
        }catch(exception e){
            System.debug('EndlineFuturePlanningController.saveData, e.getMessage() : ' + e.getMessage());
            System.debug('EndlineFuturePlanningController.saveData, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static void dataPrepare(boolean saveFlag,Future_Planning__c sf,string fp17,string fp18_1,string fp18_2,string fp18_3,string fp18_4,string fp18_5,string fp18_6,string fp18_7,string fp18_8,string fp18_9,string fp18_10,string fp18_11,string fp19,string fp20,string fp21,string fp22){
        try{
            if(saveFlag){
                sf.Future_Planning_form_submitted__c = true;
            }
            if(fp17 == 'NoAnswer')fp17='';
            if(fp18_1 == 'NoAnswer')fp18_1='';
            if(fp18_2 == 'NoAnswer')fp18_2='';
            if(fp18_3 == 'NoAnswer')fp18_3='';
            if(fp18_4 == 'NoAnswer')fp18_4='';
            if(fp18_5 == 'NoAnswer')fp18_5='';
            if(fp18_6 == 'NoAnswer')fp18_6='';
            if(fp18_7 == 'NoAnswer')fp18_7='';
            if(fp18_8 == 'NoAnswer')fp18_8='';
            if(fp18_9 == 'NoAnswer')fp18_9='';
            if(fp18_10 == 'NoAnswer')fp18_10='';
            if(fp18_11 == 'NoAnswer')fp18_11='';
            if(fp19 == 'NoAnswer')fp19='';
            if(fp20 == 'NoAnswer')fp20='';
            if(fp21 == 'NoAnswer')fp21='';
            if(fp22 == 'NoAnswer')fp22='';
            
            sf.Q_17__c = fp17;
            sf.Q_18_1__c = fp18_1;
            sf.Q_18_2__c = fp18_2;
            sf.Q_18_3__c = fp18_3;
            sf.Q_18_4__c = fp18_4;
            sf.Q_18_5__c = fp18_5;
            sf.Q_18_6__c = fp18_6;
            sf.Q_18_7__c = fp18_7;
            sf.Q_18_8__c = fp18_8;
            sf.Q_18_9__c = fp18_9;
            sf.Q_18_10__c = fp18_10;
            sf.Q_18_11__c = fp18_11;
            sf.Q_19__c = fp19;
            sf.Q_20__c = fp20;
            sf.Q_21__c = fp21;
            sf.Q_22__c = fp22;
            
            upsert sf;  
            system.debug('::Ids ='+sf.id);
        }catch(exception e){
            System.debug('EndlineFuturePlanningController.dataPrepare, e.getMessage() : ' + e.getMessage());
            System.debug('EndlineFuturePlanningController.dataPrepare, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    @AuraEnabled
    public static Future_Planning__c getRecordApt(String studentId) {
        try{
            List<Future_Planning__c> sf =  new List<Future_Planning__c>([SELECT id,Created_from_Form__c, Barcode__c, Form_Submitted__c, Q_17__c,Q_18_1__c,Q_18_2__c,Q_18_3__c,
                                                                                Q_18_4__c,Q_18_5__c,Q_18_6__c,Q_18_7__c,Q_18_8__c,Q_18_9__c,Q_18_10__c,Q_18_11__c,Q_19__c,Q_20__c,
                                                                                Q_21__c,Q_22__c,F_1__c, F_10__c, F_11__c, F_12__c, F_2__c, F_3__c, F_4__c, F_5__c, F_6__c, F_7__c, 
                                                                                F_8__c, F_9__c, Student__c, Student__r.name 
                                                                         FROM Future_Planning__c
                                                                         WHERE Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Endline' limit 1]);
            if(!sf.isEmpty()){
                system.debug(' sf[0] = '+ sf[0]);
                return sf[0];
            }
            
            return new Future_Planning__c();
        }catch(exception e){
            System.debug('EndlineFuturePlanningController, e.getMessage() : ' + e.getMessage());
            System.debug('EndlineFuturePlanningController, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static string SaveAllData(String studentId,string fp17,string fp18_1,string fp18_2,string fp18_3,string fp18_4,string fp18_5,string fp18_6,string fp18_7,string fp18_8,string fp18_9,string fp18_10,string fp18_11,string fp19,string fp20,string fp21,string fp22, boolean saveFlag, String grade, String formType) {
        //String F1, String F2, String F3, String F4, String F5, String F6, String F7, String F8, String F9, String F10, String F11, String F12,
        Map<String, String> formDetails = ( Map<String, String>)JSON.deserialize(formType,  Map<String, String>.class);
        
        String lng = formDetails.containsKey('lng') ? formDetails.get('lng') : '' ;
        String typ = formDetails.containsKey('typ') ? formDetails.get('typ') : '' ;
        system.debug(':::studentId = '+studentId);
        
        String returnStr = '';
        try{
            List<Future_Planning__c> sf =  new List<Future_Planning__c>([select id,Created_from_Form__c,Q_17__c,Q_18_1__c,Q_18_2__c,Q_18_3__c,Q_18_4__c,Q_18_5__c,Q_18_6__c,Q_18_7__c,Q_18_8__c,Q_18_9__c,Q_18_10__c,Q_18_11__c,Q_19__c,Q_20__c,Q_21__c,Q_22__c, Student__c from  Future_Planning__c
                                                                         where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Endline' limit 1]);
            if(!sf.isEmpty()){
                //returnStr = 'Update';
                returnStr = sf[0].Id;
                system.debug('saveFlag ='+saveFlag);
                if(String.isNotBlank(grade)){
                    sf[0].Grade__c = grade;
                }
                
                dataPrepare1(saveFlag,sf[0],fp17,fp18_1,fp18_2,fp18_3,fp18_4,fp18_5,fp18_6,fp18_7,fp18_8,fp18_9,fp18_10,fp18_11,fp19,fp20,fp21,fp22, lng, typ);
                // F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, 
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
                RecordType rt = [select id, name, SobjectType from RecordType where SobjectType = 'Future_Planning__c' and name = 'Endline'];
                system.debug('Grade : '+grade);
                Future_Planning__c sf1 = new Future_Planning__c(Created_from_Form__c = true, Student__c = studentId, Barcode__c = barcode, RecordTypeId = rt.id, Grade__c=grade);
                system.debug('Grade : '+sf1);
                system.debug('Grade : '+sf1.Grade__c);
                returnStr = dataPrepare1(saveFlag,sf1,fp17,fp18_1,fp18_2,fp18_3,fp18_4,fp18_5,fp18_6,fp18_7,fp18_8,fp18_9,fp18_10,fp18_11,fp19,fp20,fp21,fp22, lng, typ);
                //F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, 
            }
            
            return returnStr;
        }catch(exception e){
            System.debug('EndlineFuturePlanningController.saveData, e.getMessage() : ' + e.getMessage());
            System.debug('EndlineFuturePlanningController.saveData, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    public static String dataPrepare1(boolean saveFlag,Future_Planning__c sf,string fp17,string fp18_1,string fp18_2,string fp18_3,string fp18_4,string fp18_5,string fp18_6,string fp18_7,string fp18_8,string fp18_9,string fp18_10,string fp18_11,string fp19,string fp20,string fp21,string fp22, string lng, string typ ){
        // String F1, String F2, String F3, String F4, String F5, String F6, String F7, String F8, String F9, String F10, String F11, String F12, 
        try{
            if(saveFlag){
                sf.Future_Planning_form_submitted__c = true;
            }
            if(fp17 == 'nil')fp17='';
            if(fp18_1 == 'nil')fp18_1='';
            if(fp18_2 == 'nil')fp18_2='';
            if(fp18_3 == 'nil')fp18_3='';
            if(fp18_4 == 'nil')fp18_4='';
            if(fp18_5 == 'nil')fp18_5='';
            if(fp18_6 == 'nil')fp18_6='';
            if(fp18_7 == 'nil')fp18_7='';
            if(fp18_8 == 'nil')fp18_8='';
            if(fp18_9 == 'nil')fp18_9='';
            if(fp18_10 == 'nil')fp18_10='';
            if(fp18_11 == 'nil')fp18_11='';
            if(fp19 == 'nil')fp19='';
            if(fp20 == 'nil')fp20='';
            if(fp21 == 'nil')fp21='';
            if(fp22 == 'nil')fp22='';
            
            sf.Q_17__c = fp17;
            sf.Q_18_1__c = fp18_1;
            sf.Q_18_2__c = fp18_2;
            sf.Q_18_3__c = fp18_3;
            sf.Q_18_4__c = fp18_4;
            sf.Q_18_5__c = fp18_5;
            sf.Q_18_6__c = fp18_6;
            sf.Q_18_7__c = fp18_7;
            sf.Q_18_8__c = fp18_8;
            sf.Q_18_9__c = fp18_9;
            sf.Q_18_10__c = fp18_10;
            sf.Q_18_11__c = fp18_11;
            sf.Q_19__c = fp19;
            sf.Q_20__c = fp20;
            sf.Q_21__c = fp21;
            sf.Q_22__c = fp22;
            
            // sf.F_1__c = F1;
            // sf.F_10__c = F10;
            // sf.F_11__c = F11;
            // sf.F_12__c = F12;
            // sf.F_2__c = F2;
            // sf.F_3__c = F3;
            // sf.F_4__c = F4;
            // sf.F_5__c = F5;
            // sf.F_6__c = F6;
            // sf.F_7__c = F7;
            // sf.F_8__c = F8;
            // sf.F_9__c = F9;
            
            sf.Form_Language__c = lng;
            sf.Form_Name__c = typ;
            sf.Form_Submitted__c = true;
            
            // if (F1 == 'NoAnswer' || F1 == 'nil') {
            //     sf.F_1__c = '';
            // }
            
            // if (F10 == 'NoAnswer' || F10 == 'nil') {
            //     sf.F_10__c = '';
            // }
            
            // if (F11 == 'NoAnswer' || F11 == 'nil') {
            //     sf.F_11__c = '';
            // }
            
            // if (F12 == 'NoAnswer' || F12 == 'nil') {
            //     sf.F_12__c = '';
            // }
            
            // if (F2 == 'NoAnswer' || F2 == 'nil') {
            //     sf.F_2__c = '';
            // }
            
            // if (F3 == 'NoAnswer' || F3 == 'nil') {
            //     sf.F_3__c = '';
            // }
            
            // if (F4 == 'NoAnswer' || F4 == 'nil') {
            //     sf.F_4__c = '';
            // }
            
            // if (F5 == 'NoAnswer' || F5 == 'nil') {
            //     sf.F_5__c = '';
            // }
            
            // if (F6 == 'NoAnswer' || F6 == 'nil') {
            //     sf.F_6__c = '';
            // }
            
            // if (F7 == 'NoAnswer' || F7 == 'nil') {
            //     sf.F_7__c = '';
            // }
            
            // if (F8 == 'NoAnswer' || F8 == 'nil') {
            //     sf.F_8__c = '';
            // }
            
            // if (F9 == 'NoAnswer' || F9 == 'nil') {
            //     sf.F_9__c = '';
            // }
            
            
            upsert sf;  
            system.debug('::Ids ='+sf.id);
            if(String.isNotBlank(sf.id)){
                    //Future_Planning__c fp = new Future_Planning__c();
                    //fp.Id = fpId;
                    List<Future_Planning__c> fpList = new List<Future_Planning__c>([select id, Barcode__c, Created_from_Form__c, Q_17__c,Q_18_1__c,Q_18_2__c,Q_18_3__c,Q_18_4__c,Q_18_5__c,Q_18_6__c,Q_18_7__c,Q_18_8__c,Q_18_9__c,Q_18_10__c,Q_18_11__c,Q_19__c,Q_20__c,Q_21__c,Q_22__c, Student__c from  Future_Planning__c where id = :sf.id]);
                    //fpList.add(fp);
                    
                    FuturePlanningTriggerHandler.populateStudentAndMarksCalculation(fpList);
            }
            return sf.Id;
        }catch(exception e){
            System.debug('EndlineFuturePlanningController.dataPrepare, e.getMessage() : ' + e.getMessage());
            System.debug('EndlineFuturePlanningController.dataPrepare, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static void calculateForms(String studentId, String CDM1Id, String CDM2Id, String cpId, String csId, String fpId ){
        System.debug('calculateForms : ' );
        try {
            
            try{
                if(String.isNotBlank(csId)){
                    System.debug('calculateForms : csId ' );
                    careerSkillsEndline.submitAndCalculate(csId);
                }
            } catch (Exception e) {
                throw new AuraHandledException('CS '+e.getMessage());
            }
            try{
                if(String.isNotBlank(cpId)){
                    System.debug('calculateForms : cpId ' );
                    careerPlanning_A_Endline.submitAndCalculate(cpId, null, null);
                }
            } catch (Exception e) {
                throw new AuraHandledException('CP '+e.getMessage());
            }
            
            try{
                if(String.isNotBlank(CDM1Id)){
                    System.debug('calculateForms : CDM1Id' +CDM1Id);
                    careerDecisionMaking_01.submitAndCalculate(CDM1Id);
                }
            } catch (Exception e) {
                system.debug('CDM1 '+e.getMessage());
                throw new AuraHandledException('CDM1 '+e.getMessage());
            }
            
            try{
                if(String.isNotBlank(CDM2Id)){
                    System.debug('calculateForms : CDM2Id ' +CDM2Id);
                    careerDecisionMaking_02.submitAndCalculate(CDM2Id);
                }
            } catch (Exception e) {
                throw new AuraHandledException('CDM2 '+e.getMessage());
            }
            
            try{
                if(String.isNotBlank(fpId)){
                    //Future_Planning__c fp = new Future_Planning__c();
                    //fp.Id = fpId;
                    List<Future_Planning__c> fpList = new List<Future_Planning__c>([select id, Barcode__c, Created_from_Form__c, Q_17__c,Q_18_1__c,Q_18_2__c,Q_18_3__c,Q_18_4__c,Q_18_5__c,Q_18_6__c,Q_18_7__c,Q_18_8__c,Q_18_9__c,Q_18_10__c,Q_18_11__c,Q_19__c,Q_20__c,Q_21__c,Q_22__c, Student__c from  Future_Planning__c where id = :fpId]);
                    //fpList.add(fp);
                    
                    FuturePlanningTriggerHandler.populateStudentAndMarksCalculation(fpList);
                }
            } catch (Exception e) {
                throw new AuraHandledException('FP '+e.getMessage());
            }
            
        } catch (Exception e) {
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
}