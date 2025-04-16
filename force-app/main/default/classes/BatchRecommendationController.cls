/*
    Description: Class to generate for Batch
*/
public with sharing class BatchRecommendationController {
    
    public string pdf {get; set;}
    
    public List<WrapperContactDetails> lstWrapperDetails {get; set;}
    
    public BatchRecommendationController(ApexPages.StandardController controller){
        Id batchId = controller.getId();
         /* removed Batch_Number__c from this for logic change */
        List<Contact> lstContacts = new List<Contact>([select id,name,Current_Aspiration__c,Age__c,Batch_Code__c,Interest_1__c,Interest_2__c,
                Batch_Code__r.Batch_Number__c,Aptitude_1__c,Aptitude_2__c,Personality_1__c,Personality_2__c,Personality_3__c,Personality_4__c,
                Batch_Code__r.Grade__c,Batch_Code__r.Trainer_Name__r.Name,
                Batch_Code__r.School_Name__r.Name,Profession_1__r.Name,Profession_2__r.Name,
                Personality_5__c,Personality_6__c,Personality_7__c,Personality_8__c,Reality_1__c,Reality_2__c,
                Reality_3__c,Reality_4__c,Reality_5__c,Reality_6__c,Reality_7__c,Reality_8__c,Profession_1__c,
                Profession_1_Next_steps__c,Profession_1_Recommendation__c,Profession_2__c,Profession_2_Next_steps__c,
                Profession_2_Recommendation__c from Contact Where Batch_Code__c =: batchId and
                Recommedation_Status__c = 'Processed']);
        
        lstWrapperDetails = new List<WrapperContactDetails>();
        
        List<Explanations__c> explanationList  = [select Name,Particulars__c,Realities__c,Code__c from Explanations__c];
        
        List<Explanations__c> explanationRealityList = [Select Name,Particulars__c,Realities__c,Code__c from Explanations__c where Name=: 'Realities' and Code__c != null Order by Code__c];
        
        /*fill map of explanation*/
        map<string,string> mapRealityExplanations = new map<string,string>();
        for (Explanations__c ex: explanationRealityList){
            if(ex.Code__c.startswith('Self 1')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('1Yes',ex.Particulars__c);
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('1No',ex.Particulars__c);
                }
            }
            if(ex.Code__c.startswith('Self 2')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('2Yes',ex.Particulars__c);
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('2No',ex.Particulars__c);
                }
            }
            if(ex.Code__c.startswith('Self 3')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('3Yes',ex.Particulars__c);
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('3No',ex.Particulars__c);
                }
            }
            if(ex.Code__c.startswith('Self 4')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('4Yes',ex.Particulars__c);
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('4No',ex.Particulars__c);
                }
            }
            if(ex.Code__c.startswith('Family 1')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('5Yes',ex.Particulars__c);
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('5No',ex.Particulars__c);
                }
            }
            if(ex.Code__c.startswith('Family 2')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('6Yes',ex.Particulars__c);
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('6No',ex.Particulars__c);
                }
            }
            if(ex.Code__c.startswith('Family 3')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('7Yes',ex.Particulars__c);
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('7No',ex.Particulars__c);
                }
            }
            if(ex.Code__c.startswith('Family 4')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('8Yes',ex.Particulars__c);
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('8No',ex.Particulars__c);
                }
            }
        }
        
        for(Contact objCon: lstContacts){
            WrapperContactDetails objWrapper = new WrapperContactDetails();
            objWrapper.objcontact = objCon;
            if(objCon.Batch_Code__c != null) {
                if(objCon.Batch_Code__r.Batch_Number__c != null) {
                    objWrapper.batchNumber = objCon.Batch_Code__r.Batch_Number__c;  
                }
                if(objCon.Batch_Code__r.Grade__c != null) {
                    objWrapper.grade = objCon.Batch_Code__r.Grade__c;  
                }
            }
            if(objCon.Batch_Code__c != null && objCon.Batch_Code__r.Trainer_Name__c != null) {
                objWrapper.trainerName = objCon.Batch_Code__r.Trainer_Name__r.Name;
            }
            if(objCon.Batch_Code__c != null && objCon.Batch_Code__r.School_Name__c != null){
                objWrapper.schoolName = objCon.Batch_Code__r.School_Name__r.Name;
            }
            for(Explanations__c ex: explanationList){
                String interestCheck1='';
                String interestCheck2='';
                String aptitudeCheck1='';
                String aptitudeCheck2='';
                
                /* Explanation of interest */
                if(objWrapper.objcontact.Interest_1__c != null){
                    interestCheck1 = objWrapper.objcontact.Interest_1__c;
                    interestCheck1 +=' '+'-'+' '+ interestCheck1.substring(0,1);
                }
                
                if(objWrapper.objcontact.Interest_2__c != null){
                    interestCheck2 = objWrapper.objcontact.Interest_2__c;
                    interestCheck2 += ' '+'-'+' '+ interestCheck2.substring(0,1);
                }
                
                if(ex.Name =='Interest' && ex.Code__c == interestCheck1){
                    objWrapper.interest1 = ex.Particulars__c;
                }
                if(ex.Name =='Interest' && ex.Code__c == interestCheck2){
                    objWrapper.interest2 = ex.Particulars__c;
                }
                
                /* Explanation of Aptitude */
                if(objWrapper.objcontact.Aptitude_1__c != null){
                    aptitudeCheck1 = objWrapper.objcontact.Aptitude_1__c;
                    aptitudeCheck1 += ' '+'Ability';
                }
                
                if(objWrapper.objcontact.Aptitude_2__c != null){
                    aptitudeCheck2 = objWrapper.objcontact.Aptitude_2__c;
                    aptitudeCheck2 += ' '+'Ability';
                }
                
                if(ex.Name =='Aptitude' && ex.Code__c == aptitudeCheck1) {
                    objWrapper.aptitude1 = ex.Particulars__c; 
                }
                
                if(ex.Name =='Aptitude' && ex.Code__c == aptitudeCheck2) {
                    objWrapper.aptitude2 = ex.Particulars__c;
                }
                
                if(ex.Name =='Personality' && ex.Code__c == objWrapper.objcontact.Personality_1__c){
                    objWrapper.personality1 = ex.Particulars__c;
                }
                if(ex.Name =='Personality' && ex.Code__c == objWrapper.objcontact.Personality_2__c){
                    objWrapper.personality2 = ex.Particulars__c;
                }
                if(ex.Name =='Personality' && ex.Code__c == objWrapper.objcontact.Personality_3__c){
                    objWrapper.personality3 = ex.Particulars__c;
                }
                if(ex.Name =='Personality' && ex.Code__c == objWrapper.objcontact.Personality_4__c){
                    objWrapper.personality4 = ex.Particulars__c;
                }
                if(ex.Name =='Personality' && ex.Code__c == objWrapper.objcontact.Personality_5__c){
                    objWrapper.personality5 = ex.Particulars__c;
                }
                if(ex.Name =='Personality' && ex.Code__c == objWrapper.objcontact.Personality_6__c){
                    objWrapper.personality6 = ex.Particulars__c;
                }
                if(ex.Name =='Personality' && ex.Code__c == objWrapper.objcontact.Personality_7__c) {
                    objWrapper.personality7 = ex.Particulars__c;
                }
                if(ex.Name =='Personality' && ex.Code__c == objWrapper.objcontact.Personality_8__c){
                    objWrapper.personality8 = ex.Particulars__c;
                }
            }
            /* Explanation of Personality */
            List<String> personalityList = new List<String>();
            personalityList.clear();
            if(objWrapper.objcontact.Personality_1__c !=null){
                personalityList.add(objWrapper.objcontact.Personality_1__c);
            }
            if(objWrapper.objcontact.Personality_2__c !=null){
                personalityList.add(objWrapper.objcontact.Personality_2__c);
            }
            if(objWrapper.objcontact.Personality_3__c !=null){
                personalityList.add(objWrapper.objcontact.Personality_3__c);
            }
            if(objWrapper.objcontact.Personality_4__c !=null){
                personalityList.add(objWrapper.objcontact.Personality_4__c);
            }
            if(objWrapper.objcontact.Personality_5__c !=null){
                personalityList.add(objWrapper.objcontact.Personality_5__c);
            }
            if(objWrapper.objcontact.Personality_6__c !=null) {
                personalityList.add(objWrapper.objcontact.Personality_6__c);
            }
            if(objWrapper.objcontact.Personality_7__c !=null) {
                personalityList.add(objWrapper.objcontact.Personality_7__c);
            }
            if(objWrapper.objcontact.Personality_8__c !=null){
                personalityList.add(objWrapper.objcontact.Personality_8__c);
            }
            objWrapper.commaSepratedList = '';
            for(Integer i=0; i < personalityList.size(); i++){
                if(personalityList.get(i) != null && personalityList.get(i) != 'Any') {
                    if(i==personalityList.size()-1)
                        objWrapper.commaSepratedList +=personalityList.get(i);
                    else
                        objWrapper.commaSepratedList +=personalityList.get(i)+ ',' ;
                }
            }
            objWrapper.commaSepratedList = objWrapper.commaSepratedList.subString(0,objWrapper.commaSepratedList.length());
            
            /*change logic for reality */
            if (objWrapper.objcontact.Reality_1__c == 'Yes' && mapRealityExplanations.containskey('1Yes')){
                objWrapper.reality1 = mapRealityExplanations.get('1Yes');
            } else if(mapRealityExplanations.containskey('1No')) { 
                objWrapper.reality1 = mapRealityExplanations.get('1No');
            }
            if (objWrapper.objcontact.Reality_2__c=='Yes' && mapRealityExplanations.containskey('2Yes')){
                objWrapper.reality2 = mapRealityExplanations.get('2Yes');
            } else if(mapRealityExplanations.containskey('2No')){ 
                objWrapper.reality2 = mapRealityExplanations.get('2No');
            }
            if (objWrapper.objcontact.Reality_3__c=='Yes' && mapRealityExplanations.containskey('3Yes')){
                objWrapper.reality3 = mapRealityExplanations.get('3Yes');
            } else if(mapRealityExplanations.containskey('3No')) { 
                objWrapper.reality3 = mapRealityExplanations.get('3No');
            }
            if (objWrapper.objcontact.Reality_4__c=='Yes' && mapRealityExplanations.containskey('4Yes')){
                objWrapper.reality4 = mapRealityExplanations.get('4Yes');
            } else if(mapRealityExplanations.containskey('4No')) { 
                objWrapper.reality4 = mapRealityExplanations.get('4No');
            }
            if (objWrapper.objcontact.Reality_5__c=='Yes' && mapRealityExplanations.containskey('5Yes')){
                objWrapper.reality5 = mapRealityExplanations.get('5Yes');
            } else  if(mapRealityExplanations.containskey('5No')) { 
                objWrapper.reality5 = mapRealityExplanations.get('5No');
            }
            if (objWrapper.objcontact.Reality_6__c=='Yes' && mapRealityExplanations.containskey('6Yes')){
                objWrapper.reality6 = mapRealityExplanations.get('6Yes');
            } else  if(mapRealityExplanations.containskey('6No')) { 
                objWrapper.reality6 = mapRealityExplanations.get('6No');
            }
            if (objWrapper.objcontact.Reality_7__c=='Yes' && mapRealityExplanations.containskey('7Yes')){
                objWrapper.reality7 = mapRealityExplanations.get('7Yes');
            } else  if(mapRealityExplanations.containskey('7No')) { 
                objWrapper.reality7 = mapRealityExplanations.get('7No');
            }
            
            if (objWrapper.objcontact.Reality_8__c=='Yes' && mapRealityExplanations.containskey('8Yes')){
                objWrapper.reality8 = mapRealityExplanations.get('8Yes');
            } else  if(mapRealityExplanations.containskey('8No')) { 
                objWrapper.reality8 = mapRealityExplanations.get('8No');
            }
            
            if(objCon.Profession_1__c != null){
                objWrapper.profession1 = objCon.Profession_1__r.Name;
                objWrapper.professionshowContent1 = true;
            }else{
                objWrapper.professionshowContent1 = false;
            }
            
            if(objCon.Profession_2__c != null){
                objWrapper.profession2 = objCon.Profession_2__r.Name;
                objWrapper.professionshowContent2 = true;
            }else{
                objWrapper.professionshowContent2 = false;
            }
            
            lstWrapperDetails.add(objWrapper);
        }    
    }
    
    public PageReference redirect(){
        pdf='pdf';
        return null;
    }
}