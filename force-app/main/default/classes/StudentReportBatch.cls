/*
 * This Batch class is used to update the old data onetime process ie., only for one time run 
 * This batch updates the Student records whose Batch_Code__r.Academic_Year__c = Current academic year (which is available in Custom settings)
 * Populates the Aspirations from OMR_Assessment -- Endline -- fields : Career_Choice_1__c, Career_Choice_2__c
 * Populates the Interests and Aptitudes from Self_Awareness_and_Feedbacks -- Baseline 
 * Populates the Realities from Self_Awareness_Realities -- Baseline 
 * 
 * Created Date : 25-05-2023
 * Created By : Kandisa Team
 */ 

public class StudentReportBatch implements Database.Batchable<sObject> {
    
    public string strQuery = '';
    public map<String ,IARP_Master__c> IARPMasterMap = new map<String, IARP_Master__c>();
    public String IdoNotKnowIARP = 'i do not know';
    
    public StudentReportBatch(String query){
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        for(IARP_Master__c objIarp : [select Id, Name from IARP_Master__c Where Is_Active__c = true order by Name]){
            IARPMasterMap.put(objIarp.Name.toLowercase(), objIarp);
        }
        
        if(String.isBlank(query)){
            strQuery = ' Select Id, Batch_Code__r.Academic_Year__c, Batch_Code__c, Interest_1__c, Interest_2__c, Interest_3__c, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c, ';
            strQuery += ' Reality_1__c, Reality_2__c, Reality_3__c, Reality_4__c, Reality_5__c, Reality_6__c, Reality_7__c, Reality_8__c, ';
            strQuery += ' Aspiration_1__c, Aspiration_2__c, Aspiration_3__c, ';
            strQuery += ' (Select id, Career_Choice_1__c, Career_Choice_2__c  From OMR_Assessments__r '; 
            strQuery += '  Where recordtype.DeveloperName = \'Endline\' order By LastModifiedDate Desc Limit 1 ), ';
            strQuery += ' (Select Id, Aptitude_1__c, Aptitude_2__c, Aptitude_3__c, Interest_1__c, Interest_2__c, Interest_3__c ';
            strQuery += ' From Self_Awareness_and_Feedbacks__r ';
            strQuery += ' Where recordtype.DeveloperName = \'Baseline\' order By LastModifiedDate Desc Limit 1 ), ';
            strQuery += ' (Select id, Reality1_Self_1__c, Reality_2_Self_2__c, Reality_3_Self_3__c, Reality_4_Self_4__c, ';
            strQuery += ' Reality_5_Family_1__c, Reality_6_Family_2__c, Reality_7_Family_3__c, Reality_8_Family_4__c  ';
            strQuery += ' From Self_Awareness_Realities__r  ';
            strQuery += ' where recordtype.DeveloperName = \'Baseline\'  ';
            strQuery += ' order By LastModifiedDate Desc Limit 1 ) ';
            strQuery += ' from Contact ';
            strQuery += ' Where RecordType.DeveloperName = \'CA_Student\' AND Batch_Code__c != null AND Batch_Code__r.Academic_Year__c = '+antarangSett.Academic_Year__c+' ' ;
        }else{
            strQuery = query;
        }
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(strQuery);
    }
    
    public void execute(Database.BatchableContext BC, List<Contact> lstContact){
        system.debug(lstContact);
        
        for(Contact con : lstContact){
            con.Recommedation_Status__c = 'Not Processed';
            con.Status__c = 'Not Processed';
            
            system.debug('con.OMR_Assessments__r '+con.OMR_Assessments__r);
            system.debug('con.Self_Awareness_and_Feedbacks__r '+con.Self_Awareness_and_Feedbacks__r);
            system.debug('con.Self_Awareness_Realities__r '+con.Self_Awareness_Realities__r);
            system.debug('con.OMR_Assessments__r '+con);
            
            if(con.OMR_Assessments__r != null && con.OMR_Assessments__r.size() > 0){    
                
                if(String.isNotBlank(con.OMR_Assessments__r[0].Career_Choice_1__c)){
                    if(IARPMasterMap.containsKey(con.OMR_Assessments__r[0].Career_Choice_1__c.toLowercase())){
                        con.Aspiration_1__c = IARPMasterMap.get(con.OMR_Assessments__r[0].Career_Choice_1__c.toLowercase()).Id;
                    }else if(con.OMR_Assessments__r[0].Career_Choice_1__c.toLowercase() == 'not sure' ){
                        con.Aspiration_1__c = IARPMasterMap.containsKey(IdoNotKnowIARP.toLowercase()) ? IARPMasterMap.get(IdoNotKnowIARP.toLowercase()).Id : null;    
                    }
                    
                    //con.Aspiration_1__c = IARPMasterMap.containsKey(con.OMR_Assessments__r[0].Career_Choice_1__c.toLowercase()) ? IARPMasterMap.get(con.OMR_Assessments__r[0].Career_Choice_1__c.toLowercase()).Id : null;
                }                
                
                if(String.isNotBlank(con.OMR_Assessments__r[0].Career_Choice_2__c)){
                    if(IARPMasterMap.containsKey(con.OMR_Assessments__r[0].Career_Choice_2__c.toLowercase())){
                        con.Aspiration_2__c = IARPMasterMap.get(con.OMR_Assessments__r[0].Career_Choice_2__c.toLowercase()).Id;
                    }else if(con.OMR_Assessments__r[0].Career_Choice_2__c.toLowercase() == 'not sure' ){
                        con.Aspiration_2__c = IARPMasterMap.containsKey(IdoNotKnowIARP.toLowercase()) ? IARPMasterMap.get(IdoNotKnowIARP.toLowercase()).Id : null;    
                    }
                    
                }
                
                /*
                 if(String.isNotBlank(con.OMR_Assessments__r[0].Career_Choice_1__c)){
                    con.Aspiration_1__c = IARPMasterMap.containsKey(con.OMR_Assessments__r[0].Career_Choice_1__c.toLowercase()) ? IARPMasterMap.get(con.OMR_Assessments__r[0].Career_Choice_1__c.toLowercase()).Id : null;
                }
                
                if(String.isNotBlank(con.OMR_Assessments__r[0].Career_Choice_2__c)){
                    con.Aspiration_2__c = IARPMasterMap.containsKey(con.OMR_Assessments__r[0].Career_Choice_2__c.toLowercase()) ? IARPMasterMap.get(con.OMR_Assessments__r[0].Career_Choice_2__c.toLowercase()).Id : null;
                }
				*/
                
                //updateList.add(con);
            }else if(con.Aspiration_1__c != null || con.Aspiration_2__c != null){
                con.Aspiration_1__c = null;
                con.Aspiration_2__c = null;
                //updateList.add(con);
            }
            
            if(con.Self_Awareness_and_Feedbacks__r != null && con.Self_Awareness_and_Feedbacks__r.size() > 0){
                con.Aptitude_1__c = con.Self_Awareness_and_Feedbacks__r[0].Aptitude_1__c;
                con.Aptitude_2__c = con.Self_Awareness_and_Feedbacks__r[0].Aptitude_2__c;
                con.Aptitude_3__c = con.Self_Awareness_and_Feedbacks__r[0].Aptitude_3__c;
                con.Interest_1__c = con.Self_Awareness_and_Feedbacks__r[0].Interest_1__c; 
                con.Interest_2__c = con.Self_Awareness_and_Feedbacks__r[0].Interest_2__c; 
                con.Interest_3__c = con.Self_Awareness_and_Feedbacks__r[0].Interest_3__c;                 
                //updateList.add(con);
            }else if( String.isNotBlank(con.Aptitude_1__c) || String.isNotBlank(con.Aptitude_2__c) || String.isNotBlank(con.Aptitude_3__c) || 
                     String.isNotBlank(con.Interest_1__c) || String.isNotBlank(con.Interest_2__c) || String.isNotBlank(con.Interest_3__c) ){
                         con.Interest_1__c = '';
                         con.Interest_2__c = '';
                         con.Interest_3__c = '';
                         con.Aptitude_1__c = '';
                         con.Aptitude_2__c = '';
                         con.Aptitude_3__c = '';
                         // updateList.add(con);
                     }
            
            system.debug('con.Self_Awareness_Realities__r : ' + con.Self_Awareness_Realities__r);
            if(con.Self_Awareness_Realities__r != null && con.Self_Awareness_Realities__r.size() > 0){
                    con.Reality_1__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality1_Self_1__c, false);
                    con.Reality_2__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_2_Self_2__c, false);
                    con.Reality_3__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_3_Self_3__c, false);
                    con.Reality_4__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_4_Self_4__c, true);
                    con.Reality_5__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_5_Family_1__c, false);
                    con.Reality_6__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_6_Family_2__c, false);
                    con.Reality_7__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_7_Family_3__c, false);
                    con.Reality_8__c = fetchReality(con.Self_Awareness_Realities__r[0].Reality_8_Family_4__c, true);            
                //updateList.add(con);
            }else if( String.isNotBlank(con.Reality_1__c) || String.isNotBlank(con.Reality_2__c) || String.isNotBlank(con.Reality_3__c) || 
                    String.isNotBlank(con.Reality_4__c) || String.isNotBlank(con.Reality_5__c) || String.isNotBlank(con.Reality_6__c) || 
                    String.isNotBlank(con.Reality_7__c) || String.isNotBlank(con.Reality_8__c) ){
                con.Reality_1__c = '';
                con.Reality_2__c = '';
                con.Reality_3__c = '';
                con.Reality_4__c = '';
                con.Reality_5__c = '';
                con.Reality_6__c = '';
                con.Reality_7__c = '';
                con.Reality_8__c = ''; 
                //updateList.add(con);
            }
            
        }
        
        update lstContact;
        
        
    }
    
    public void finish(Database.BatchableContext BC){ }
    
    public static String fetchReality(String reality, Boolean isReality4or8){
        String str = '';
        if(reality == null || reality == ''){ return ''; }
        if(!isReality4or8){
            if( reality.equalsIgnoreCase('A')){ str = 'Yes'; }
            else if(reality.equalsIgnoreCase('B')){ str = 'No'; }
        }else{
            if(reality.equalsIgnoreCase('A')){ str = 'A'; }
            else if(reality.equalsIgnoreCase('B')){ str = 'B'; }
            else if(reality.equalsIgnoreCase('c')){ str = 'C'; }
            else if(reality.equalsIgnoreCase('D')){ str = 'I do not know'; }
        }
        return str;
    }
    
}