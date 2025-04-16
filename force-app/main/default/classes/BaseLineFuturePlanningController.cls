public without sharing class BaseLineFuturePlanningController {
    @AuraEnabled
    public static string getObjectId(String studentId,string objectApi){
    	String query = 'SELECT Id FROM ' + objectApi + ' WHERE Student__c = \'' + studentId + '\' ORDER BY CreatedDate DESC LIMIT 1';
        return database.query(query).id;
    }
	@AuraEnabled
    public static string autoSaveData(String studentId,string fp17,string fp18_1,string fp18_2,string fp18_3,string fp18_4,string fp18_5,string fp18_6,string fp18_7,string fp18_8,string fp18_9,string fp18_10,string fp18_11,string fp19,string fp20,string fp21,string fp22,boolean saveFlag, string grade, string typ, string lng) {
 		system.debug(':::studentId = '+studentId);
		String returnStr = '';
        try{
			List<Future_Planning__c> sf =  new List<Future_Planning__c>([select id,Created_from_Form__c,Q_17__c,Q_18_1__c,Q_18_2__c,Q_18_3__c,Q_18_4__c,Q_18_5__c,Q_18_6__c,Q_18_7__c,Q_18_8__c,Q_18_9__c,Q_18_10__c,Q_18_11__c,Q_19__c,Q_20__c,Q_21__c,Q_22__c, Student__c from  Future_Planning__c
                                                            where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1]);
            if(!sf.isEmpty()){
				returnStr = 'Update';
                system.debug('saveFlag ='+saveFlag);
                dataPrepare(saveFlag,sf[0],fp17,fp18_1,fp18_2,fp18_3,fp18_4,fp18_5,fp18_6,fp18_7,fp18_8,fp18_9,fp18_10,fp18_11,fp19,fp20,fp21,fp22,typ,lng);
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
				Future_Planning__c sf1 = new Future_Planning__c(Created_from_Form__c = true, Student__c = studentId, Barcode__c = barcode, RecordTypeId = rt.id,Form_Language__c=lng,Form_Name__c=typ);
				dataPrepare(saveFlag,sf1,fp17,fp18_1,fp18_2,fp18_3,fp18_4,fp18_5,fp18_6,fp18_7,fp18_8,fp18_9,fp18_10,fp18_11,fp19,fp20,fp21,fp22,typ,lng);
			}
			
			return returnStr;
        }catch(exception e){
			System.debug('BaselineFuturePlanningController.saveData, e.getMessage() : ' + e.getMessage());
            System.debug('BaselineFuturePlanningController.saveData, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
     public static void dataPrepare(boolean saveFlag,Future_Planning__c sf,string fp17,string fp18_1,string fp18_2,string fp18_3,string fp18_4,string fp18_5,string fp18_6,string fp18_7,string fp18_8,string fp18_9,string fp18_10,string fp18_11,string fp19,string fp20,string fp21,string fp22,string typ, string lng){
        try{
             if(saveFlag){
                sf.Future_Planning_form_submitted__c = true;
                 sf.Form_Name__c = typ;
                 sf.Form_Language__c = lng;
            }
            if(fp17 == 'NoAnswer' || fp17 == 'nil')fp17='';
            if(fp18_1 == 'NoAnswer' || fp18_1 == 'nil')fp18_1='';
            if(fp18_2 == 'NoAnswer' || fp18_2 == 'nil')fp18_2='';
            if(fp18_3 == 'NoAnswer' || fp18_3 == 'nil')fp18_3='';
            if(fp18_4 == 'NoAnswer' || fp18_4 == 'nil')fp18_4='';
            if(fp18_5 == 'NoAnswer' || fp18_5 == 'nil')fp18_5='';
            if(fp18_6 == 'NoAnswer' || fp18_6 == 'nil')fp18_6='';
            if(fp18_7 == 'NoAnswer' || fp18_7 == 'nil')fp18_7='';
            if(fp18_8 == 'NoAnswer' || fp18_8 == 'nil')fp18_8='';
            if(fp18_9 == 'NoAnswer' || fp18_9 == 'nil')fp18_9='';
            if(fp18_10 == 'NoAnswer' || fp18_10 == 'nil')fp18_10='';
            if(fp18_11 == 'NoAnswer' || fp18_11 == 'nil')fp18_11='';
            if(fp19 == 'NoAnswer' || fp19 == 'nil')fp19='';
            if(fp20 == 'NoAnswer' || fp20 == 'nil')fp20='';
            if(fp21 == 'NoAnswer' || fp21 == 'nil')fp21='';
            if(fp22 == 'NoAnswer' || fp22 == 'nil')fp22='';
            
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
            submitNCalculate(sf.id);
        }catch(exception e){
            System.debug('BaselineFuturePlanningController.dataPrepare, e.getMessage() : ' + e.getMessage());
            System.debug('BaselineFuturePlanningController.dataPrepare, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    @AuraEnabled
    public static Future_Planning__c getRecordApt(String studentId) {
        try{
            List<Future_Planning__c> sf =  new List<Future_Planning__c>([select id,Created_from_Form__c, Q_17__c,Q_18_1__c,Q_18_2__c,Q_18_3__c,Q_18_4__c,Q_18_5__c,Q_18_6__c,Q_18_7__c,Q_18_8__c,Q_18_9__c,Q_18_10__c,Q_18_11__c,Q_19__c,Q_20__c,Q_21__c,Q_22__c, Student__c, Student__r.name from  Future_Planning__c
                                                            where Student__c =: studentId and Created_from_Form__c = true and RecordType.Name='Baseline' limit 1]);
                if(!sf.isEmpty()){
                    system.debug(' sf[0] = '+ sf[0]);
                    return sf[0];
                }

            return new Future_Planning__c();
        }catch(exception e){
            System.debug('BaselineFuturePlanningController, e.getMessage() : ' + e.getMessage());
            System.debug('BaselineFuturePlanningController, e.getLineNumber() : ' + e.getLineNumber());
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void submitNCalculate(String fpId){
        system.debug('fpId = '+fpId);
        list<Future_Planning__c> lstFut = [select id,Barcode__c,Form_Submitted__c,Created_from_Form__c,Q_17__c,Q_18_1__c,Q_18_2__c,Q_18_3__c,Q_18_4__c,Q_18_5__c,Q_18_6__c,Q_18_7__c,Q_18_8__c,Q_18_9__c,Q_18_10__c,Q_18_11__c,Q_19__c,Q_20__c,Q_21__c,Q_22__c, Student__c,Q_17_Ans__c,Q_18_Ans__c,Q_19_Ans__c,Q_20_Ans__c,Q_21_Ans__c,Q_22_Ans__c from Future_Planning__c where id = :fpId];
		lstFut[0].Form_Submitted__c = true;
        update lstFut;
        FuturePlanningTriggerHandler.populateStudentAndMarksCalculation(lstFut);
    }
    
}