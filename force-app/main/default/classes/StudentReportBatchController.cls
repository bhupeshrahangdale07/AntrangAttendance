/*
Description: Class is created for Student Report Batch
*/
public with sharing class StudentReportBatchController {
    
    public List<WrapperStudentReport> lstStudentReports {get; set;}
    public WrapperStudentReport.InterestLabel Interest {get; set;}
    public WrapperStudentReport.AptitudeLabel Aptitude {get; set;}
    
    public Id batchid;
    public StudentReportBatchController (Apexpages.standardcontroller controller) {
        batchid = controller.getId();
        List<Contact> lstBatchStudents = new List<Contact>([select Id,Name,Age__c,Batch_Code__r.Grade__c,Batch_Code__r.Trainer_Name__c,
                                                            Aspiration_1__c,Aspiration_1__r.Name, Aspiration_2__c, Aspiration_2__r.Name, Aspiration_3__c ,Aspiration_3__r.Name, 
                                                            Batch_Code__r.Batch_Number__c,Batch_Code__r.Trainer_Name__r.Name,
                                                            Interest_1__c,Interest_2__c,Interest_3__c,
                                                            toLabel(Interest_1__c) Interest_1_Label, toLabel(Interest_2__c) Interest_2_Label, toLabel(Interest_3__c) Interest_3_Label,
                                                            Personality_1__c,
                                                            Personality_2__c,Personality_3__c,Personality_4__c, 
                                                            Aptitude_1__c, Aptitude_2__c,Aptitude_3__c,
                                                            toLabel(Aptitude_1__c) Aptitude_1_Label, toLabel(Aptitude_2__c) Aptitude_2_Label, toLabel(Aptitude_3__c) Aptitude_3_Label,
                                                            Reality_1__c, Reality_2__c,
                                                            Reality_3__c, Reality_4__c, Reality_5__c, Reality_6__c, Reality_7__c, Reality_8__c,Profession_1__r.Name,
                                                            
                                                            G12_Batch_Code__c, G12_Batch_Code__r.Batch_Number__c, G12_Batch_Code__r.Trainer_Name__c, G12_Batch_Code__r.Trainer_Name__r.Name, G12_Batch_Code__r.Preferred_Language__c, G12_Batch_Code__r.Grade__c, G12_Batch_Code__r.School_Name__c, G12_Batch_Code__r.School_Name__r.Name,
                                                            G11_Batch_Code__c, G11_Batch_Code__r.Batch_Number__c, G11_Batch_Code__r.Trainer_Name__c, G11_Batch_Code__r.Trainer_Name__r.Name, G11_Batch_Code__r.Preferred_Language__c, G11_Batch_Code__r.Grade__c, G11_Batch_Code__r.School_Name__c, G11_Batch_Code__r.School_Name__r.Name,
                                                            G10_Batch_Code__c, G10_Batch_Code__r.Batch_Number__c, G10_Batch_Code__r.Trainer_Name__c, G10_Batch_Code__r.Trainer_Name__r.Name, G10_Batch_Code__r.Preferred_Language__c, G10_Batch_Code__r.Grade__c, G10_Batch_Code__r.School_Name__c, G10_Batch_Code__r.School_Name__r.Name,
                                                            
                                                            Profession_1__c,Profession_1_After_10th__c,Profession_1_After_12th__c,Profession_1_You_could_be_a__c,
                                                            Profession_1_Additional_Info__c,Profession_1_Avg_Salary__c,Profession_1_Famous_Person__c,Profession_1_Fun_Fact__c, 
                                                            Profession_1__r.Icon_Name__c,Profession_1__r.Document_Icon_Id__c, Profession_2__c,Profession_2_After_10th__c, Profession_2_You_could_be_a__c,
                                                            Profession_2_After_12th__c, Profession_2_Additional_Info__c,Profession_2_Avg_Salary__c,Profession_2_Famous_Person__c,
                                                            Profession_2_Fun_Fact__c, Profession_2__r.Icon_Name__c,Profession_2__r.Document_Icon_Id__c, Profession_2__r.Name,Batch_Code__r.Preferred_Language__c,
                                                            Batch_Code__c,Batch_Code__r.School_Name__c,Batch_Code__r.School_Name__r.Name from Contact Where (G12_Batch_Code__c =: batchid OR G11_Batch_Code__c =: batchid OR G10_Batch_Code__c =: batchid OR Batch_Code__c =: batchid) AND
                                                            Recommendation_Report_Status__c != 'Incomplete profile' AND Recommedation_Status__c = 'Processed']);
        
        map<string,Explanations__c> mapofInterest = new map<string,Explanations__c>();
        for(Explanations__c objEx: [select Id,Name,Code__c,Icon_Name__c,Particulars__c,Particulars_Hindi__c,Particulars_Marathi__c,Document_Icon_Id__c from Explanations__c Where Name = 'Interest']){
            mapofInterest.put(objEx.Code__c, objEx);
        }
        
        system.debug('**Test'+lstBatchStudents.size());
        /*map<string,Explanations__c> mapofPersonality = new map<string,Explanations__c>();
for(Explanations__c objEx: [select Id,Name,Code__c,Icon_Name__c,Particulars__c,Particulars_Hindi__c,Particulars_Marathi__c,Document_Icon_Id__c from Explanations__c Where Name = 'Personality']){
mapofPersonality.put(objEx.Code__c, objEx);
}*/
        
        map<string,Explanations__c> mapofAptitude = new map<string,Explanations__c>();
        for(Explanations__c objEx: [select Id,Name,Code__c,Icon_Name__c,Particulars__c,Particulars_Hindi__c,Particulars_Marathi__c,Document_Icon_Id__c from Explanations__c Where Name = 'Aptitude']){
            mapofAptitude.put(objEx.Code__c, objEx);
        }
        
        /*fill map of explanation*/
        string strPreferredLanguage = lstBatchStudents.size() > 0 ? lstBatchStudents[0].Batch_Code__r.Preferred_Language__c : '';
        map<string,string> mapRealityExplanations = new map<string,string>();
        for (Explanations__c ex: [Select Name,Particulars__c,Realities__c,Code__c,Particulars_Hindi__c,Particulars_Marathi__c,Document_Icon_Id__c from Explanations__c where Name= 'Realities' and Code__c != null Order by Code__c]){
            if(ex.Code__c.startswith('Self 1')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('1Yes',getRealityText(ex, strPreferredLanguage));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('1No',getRealityText(ex, strPreferredLanguage));
                }
            }
            if(ex.Code__c.startswith('Self 2')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('2Yes',getRealityText(ex, strPreferredLanguage));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('2No',getRealityText(ex, strPreferredLanguage));
                }
            }
            if(ex.Code__c.startswith('Self 3')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('3Yes',getRealityText(ex, strPreferredLanguage));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('3No',getRealityText(ex, strPreferredLanguage));
                }
            }
            if(ex.Code__c.startswith('Self 4')) {
                if(ex.Realities__c == 'A') {
                    mapRealityExplanations.put('4A',getRealityText(ex, strPreferredLanguage));
                }
                if(ex.Realities__c == 'B') {
                    mapRealityExplanations.put('4B',getRealityText(ex, strPreferredLanguage));
                }
                if(ex.Realities__c == 'C') {
                    mapRealityExplanations.put('4C',getRealityText(ex, strPreferredLanguage));
                }
            }
            if(ex.Code__c.startswith('Family 1')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('5Yes',getRealityText(ex, strPreferredLanguage));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('5No',getRealityText(ex, strPreferredLanguage));
                }
            }
            if(ex.Code__c.startswith('Family 2')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('6Yes',getRealityText(ex, strPreferredLanguage));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('6No',getRealityText(ex, strPreferredLanguage));
                }
            }
            if(ex.Code__c.startswith('Family 3')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('7Yes',getRealityText(ex, strPreferredLanguage));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('7No',getRealityText(ex, strPreferredLanguage));
                }
            }
            if(ex.Code__c.startswith('Family 4')) {
                if(ex.Realities__c == 'A') {
                    mapRealityExplanations.put('8A',getRealityText(ex, strPreferredLanguage));
                }
                if(ex.Realities__c == 'B') {
                    mapRealityExplanations.put('8B',getRealityText(ex, strPreferredLanguage));
                }
                if(ex.Realities__c == 'C') {
                    mapRealityExplanations.put('8C',getRealityText(ex, strPreferredLanguage));
                }
            }
        }
        //system.debug('mapRealityExplanations ::: '+mapRealityExplanations);
        lstStudentReports = new List<WrapperStudentReport>();
        
        //query on documents
        /*map<string, Id> mapOfPersonalityDocumentIds = new map<string, Id>();
set<string> setOfDocNames = new set<string>{'personality_2introverted', 'personality_1Extroverted', 'personality_sensing', 'personality_intuition', 'personality_4thinking', 'personality_5feeling', 'personality_6judging', 'personality_7perceiving'};

for(Document  objDoc: [select Id, DeveloperName from Document Where DeveloperName in: setOfDocNames]){
if(objDoc.DeveloperName  == 'personality_2introverted'){
mapOfPersonalityDocumentIds.put('Introvert', objDoc.Id);

} else if(objDoc.DeveloperName  == 'personality_1Extroverted'){
mapOfPersonalityDocumentIds.put('Extrovert', objDoc.Id);

} else if(objDoc.DeveloperName  == 'personality_sensing'){
mapOfPersonalityDocumentIds.put('Sensing', objDoc.Id);

} else if(objDoc.DeveloperName  == 'personality_intuition'){
mapOfPersonalityDocumentIds.put('Intuition', objDoc.Id);

} else if(objDoc.DeveloperName  == 'personality_4thinking'){
mapOfPersonalityDocumentIds.put('Thinking', objDoc.Id);

} else if(objDoc.DeveloperName  == 'personality_5feeling'){
mapOfPersonalityDocumentIds.put('Feeling', objDoc.Id);

} else if(objDoc.DeveloperName  == 'personality_6judging'){
mapOfPersonalityDocumentIds.put('Judging', objDoc.Id);

} else if(objDoc.DeveloperName  == 'personality_7perceiving'){
mapOfPersonalityDocumentIds.put('Perceiving', objDoc.Id);

}
}*/
        
        string strMiddleIconDocId = '';
        List<Document> lstDoc = new List<Document>([select Id from Document Where DeveloperName = 'Middle_Icon']);
        if(lstDoc.size() > 0) {
            strMiddleIconDocId = lstDoc[0].Id;
        }
        
        try {
            for(Contact objCon: lstBatchStudents){
                WrapperStudentReport objWrap = new WrapperStudentReport();
                objWrap.objContact = objCon;
                
                Aptitude = new WrapperStudentReport.AptitudeLabel();
                Interest = new WrapperStudentReport.InterestLabel();
                
                Interest.Interest_1_Label = (String) objCon.get('Interest_1_Label');
                Interest.Interest_2_Label = (String) objCon.get('Interest_2_Label');
                Interest.Interest_3_Label = (String) objCon.get('Interest_3_Label');
                
                Aptitude.Aptitude_1_Label = (String) objCon.get('Aptitude_1_Label');
                Aptitude.Aptitude_2_Label = (String) objCon.get('Aptitude_2_Label');
                Aptitude.Aptitude_3_Label = (String) objCon.get('Aptitude_3_Label');
                
                objWrap.InterestLabels = Interest;
                objWrap.AptitudeLabels = Aptitude;
                system.debug('**Test Interest '+Interest);
                system.debug('**Test Aptitude '+Aptitude);
                
                List<string> lstAspiration = new List<string>();
                if(objCon.Aspiration_1__c != null) {
                    lstAspiration.add(objCon.Aspiration_1__r.Name);
                }
                if(objCon.Aspiration_2__c != null) {
                    lstAspiration.add(objCon.Aspiration_2__r.Name);
                }
                if(objCon.Aspiration_3__c != null) {
                    lstAspiration.add(objCon.Aspiration_3__r.Name);
                }
                string strAspiration = string.join(lstAspiration,',');
                objWrap.strAspiration = strAspiration;
                
                //get interest
                List<Explanations__c> lstInterests = new List<Explanations__c>();
                if(objCon.Interest_1__c != null && mapofInterest.containskey(objCon.Interest_1__c+' - ' +objCon.Interest_1__c.left(1))) {
                    lstInterests.add(mapofInterest.get(objCon.Interest_1__c+' - ' +objCon.Interest_1__c.left(1)));
                }
                if(objCon.Interest_2__c != null && mapofInterest.containskey(objCon.Interest_2__c+' - ' +objCon.Interest_2__c.left(1))) {
                    lstInterests.add(mapofInterest.get(objCon.Interest_2__c+' - ' +objCon.Interest_2__c.left(1)));
                }
                if(objCon.Interest_3__c != null && mapofInterest.containskey(objCon.Interest_3__c+' - ' +objCon.Interest_3__c.left(1))) {
                    lstInterests.add(mapofInterest.get(objCon.Interest_3__c+' - ' +objCon.Interest_3__c.left(1)));
                }
                objWrap.lstInterests = lstInterests;
                
                //get personality
                /*List<Explanations__c> lstPersonality = new List<Explanations__c>();
if(objCon.Personality_1__c != null && objCon.Personality_1__c != 'Any' && mapofPersonality.containskey(objCon.Personality_1__c)) {
lstPersonality.add(mapofPersonality.get(objCon.Personality_1__c));
}
if(objCon.Personality_2__c != null && objCon.Personality_2__c != 'Any' && mapofPersonality.containskey(objCon.Personality_2__c)) {
lstPersonality.add(mapofPersonality.get(objCon.Personality_2__c));
}
if(lstPersonality.size() < 2 && objCon.Personality_3__c != null && objCon.Personality_3__c != 'Any' && mapofPersonality.containskey(objCon.Personality_3__c)) {
lstPersonality.add(mapofPersonality.get(objCon.Personality_3__c));
}
if(lstPersonality.size() < 2 && objCon.Personality_4__c != null && objCon.Personality_4__c != 'Any' && mapofPersonality.containskey(objCon.Personality_4__c)) {
lstPersonality.add(mapofPersonality.get(objCon.Personality_4__c));
}*/
                //get personality
                string strPersonality = '';
                List<string> lstStrPersonality = new List<string>();
                List<string> lstPesonalityIcons = new List<string>();
                /*if(objCon.Personality_1__c != null){
lstStrPersonality.add(objCon.Personality_1__c);
if(mapOfPersonalityDocumentIds.containskey(objCon.Personality_1__c)){
lstPesonalityIcons.add(mapOfPersonalityDocumentIds.get(objCon.Personality_1__c));
}
}
if(objCon.Personality_2__c != null){
lstStrPersonality.add(objCon.Personality_2__c);
if(mapOfPersonalityDocumentIds.containskey(objCon.Personality_2__c)){
lstPesonalityIcons.add(mapOfPersonalityDocumentIds.get(objCon.Personality_2__c));
}
}
if(objCon.Personality_3__c != null){
lstStrPersonality.add(objCon.Personality_3__c);
if(mapOfPersonalityDocumentIds.containskey(objCon.Personality_3__c)){
lstPesonalityIcons.add(mapOfPersonalityDocumentIds.get(objCon.Personality_3__c));
}
}
if(objCon.Personality_4__c != null){
lstStrPersonality.add(objCon.Personality_4__c);
if(mapOfPersonalityDocumentIds.containskey(objCon.Personality_4__c)){
lstPesonalityIcons.add(mapOfPersonalityDocumentIds.get(objCon.Personality_4__c));
}
}
string strPersonalityCombination = string.join(lstStrPersonality,',');
if(mapofPersonality.containskey(strPersonalityCombination)){
strPersonality = mapofPersonality.get(strPersonalityCombination).Particulars__c;
if(strPreferredLanguage == 'Hindi'){
strPersonality = mapofPersonality.get(strPersonalityCombination).Particulars_Hindi__c;
} else if(strPreferredLanguage == 'Marathi'){
strPersonality = mapofPersonality.get(strPersonalityCombination).Particulars_Marathi__c;
}
}*/
                objWrap.strPersonality = strPersonality;
                objWrap.lstPesonalityIcons = lstPesonalityIcons;
                
                //get interest
                List<Explanations__c> lstAptitude = new List<Explanations__c>();
                if(objCon.Aptitude_1__c != null && mapofAptitude.containskey(objCon.Aptitude_1__c + ' Ability')) {
                    lstAptitude.add(mapofAptitude.get(objCon.Aptitude_1__c + ' Ability'));
                }
                if(objCon.Aptitude_2__c != null && mapofAptitude.containskey(objCon.Aptitude_2__c + ' Ability')) {
                    lstAptitude.add(mapofAptitude.get(objCon.Aptitude_2__c + ' Ability'));
                }
                if(objCon.Aptitude_3__c != null && mapofAptitude.containskey(objCon.Aptitude_3__c + ' Ability')) {
                    lstAptitude.add(mapofAptitude.get(objCon.Aptitude_3__c + ' Ability'));
                }
                objWrap.lstAptitude = lstAptitude;
                
                /*change logic for reality */
                map<Integer, List<string>> mapAllRealities = new map<Integer, List<string>>();
                if (objCon.Reality_1__c == 'Yes' && mapRealityExplanations.containskey('1Yes')){
                    mapAllRealities.put(1, new List<string>{mapRealityExplanations.get('1Yes')});
                } else if(objCon.Reality_1__c == 'No' && mapRealityExplanations.containskey('1No')) { 
                    mapAllRealities.put(1, new List<string>{mapRealityExplanations.get('1No')});
                }
                if (objCon.Reality_2__c=='Yes' && mapRealityExplanations.containskey('2Yes')){
                    if(mapAllRealities.containskey(1)){
                        mapAllRealities.get(1).add(mapRealityExplanations.get('2Yes'));
                    } else {
                        mapAllRealities.put(1,new List<string>{mapRealityExplanations.get('2Yes')});
                    }
                } else if(objCon.Reality_2__c=='No' && mapRealityExplanations.containskey('2No')){ 
                    if(mapAllRealities.containskey(1)){
                        mapAllRealities.get(1).add(mapRealityExplanations.get('2No'));
                    } else {
                        mapAllRealities.put(1,new List<string>{mapRealityExplanations.get('2No')});
                    }
                }
                if (objCon.Reality_3__c=='Yes' && mapRealityExplanations.containskey('3Yes')){
                    mapAllRealities.put(2, new List<string>{mapRealityExplanations.get('3Yes')});
                } else if(objCon.Reality_3__c=='No' && mapRealityExplanations.containskey('3No')) { 
                    mapAllRealities.put(2, new List<string>{mapRealityExplanations.get('3No')});
                }
                if(objCon.Reality_4__c=='B' && mapRealityExplanations.containskey('4B')) { 
                    if(mapAllRealities.containskey(2)){
                        mapAllRealities.get(2).add(mapRealityExplanations.get('4B'));
                    } else {
                        mapAllRealities.put(2,new List<string>{mapRealityExplanations.get('4B')});
                    }
                } else  if(objCon.Reality_4__c=='C' && mapRealityExplanations.containskey('4C')) { 
                    if(mapAllRealities.containskey(2)){
                        mapAllRealities.get(2).add(mapRealityExplanations.get('4C'));
                    } else {
                        mapAllRealities.put(2,new List<string>{mapRealityExplanations.get('4C')});
                    }
                } else if (objCon.Reality_4__c=='A' && mapRealityExplanations.containskey('4A')){
                    if(mapAllRealities.containskey(2)){
                        mapAllRealities.get(2).add(mapRealityExplanations.get('4A'));
                    } else {
                        mapAllRealities.put(2,new List<string>{mapRealityExplanations.get('4A')});
                    }
                }
                if (objCon.Reality_5__c=='Yes' && mapRealityExplanations.containskey('5Yes')){
                    mapAllRealities.put(3, new List<string>{mapRealityExplanations.get('5Yes')});
                } else  if(objCon.Reality_5__c=='No' && mapRealityExplanations.containskey('5No')) { 
                    mapAllRealities.put(3, new List<string>{mapRealityExplanations.get('5No')});
                }
                if (objCon.Reality_6__c=='Yes' && mapRealityExplanations.containskey('6Yes')){
                    if(mapAllRealities.containskey(3)){
                        mapAllRealities.get(3).add(mapRealityExplanations.get('6Yes'));
                    } else {
                        mapAllRealities.put(3,new List<string>{mapRealityExplanations.get('6Yes')});
                    }
                } else  if(objCon.Reality_6__c=='No' && mapRealityExplanations.containskey('6No')) { 
                    if(mapAllRealities.containskey(3)){
                        mapAllRealities.get(3).add(mapRealityExplanations.get('6No'));
                    } else {
                        mapAllRealities.put(3,new List<string>{mapRealityExplanations.get('6No')});
                    }
                }
                if (objCon.Reality_7__c=='Yes' && mapRealityExplanations.containskey('7Yes')){
                    mapAllRealities.put(4, new List<string>{mapRealityExplanations.get('7Yes')});
                } else  if(objCon.Reality_7__c=='No' && mapRealityExplanations.containskey('7No')) { 
                    mapAllRealities.put(4, new List<string>{mapRealityExplanations.get('7No')});
                }
                if(objCon.Reality_8__c=='B' && mapRealityExplanations.containskey('8B')) { 
                    //mapAllRealities.get(4).add(mapRealityExplanations.get('8B'));
                    if(mapAllRealities.containskey(4)){
                        mapAllRealities.get(4).add(mapRealityExplanations.get('8B'));
                    } else {
                        mapAllRealities.put(4,new List<string>{mapRealityExplanations.get('8B')});
                    }
                } else  if(objCon.Reality_8__c=='C' && mapRealityExplanations.containskey('8C')) { 
                    if(mapAllRealities.containskey(4)){
                        mapAllRealities.get(4).add(mapRealityExplanations.get('8C'));
                    } else {
                        mapAllRealities.put(4,new List<string>{mapRealityExplanations.get('8C')});
                    }
                } else if (objCon.Reality_8__c=='A' && mapRealityExplanations.containskey('8A')){
                    if(mapAllRealities.containskey(4)){
                        mapAllRealities.get(4).add(mapRealityExplanations.get('8A'));
                    } else {
                        mapAllRealities.put(4,new List<string>{mapRealityExplanations.get('8A')});
                    }
                }
                
                objWrap.mapAllRealities = mapAllRealities;
                objWrap.strMiddleIconDocId = strMiddleIconDocId;
                lstStudentReports.add(objWrap); 
                system.debug('lstStudentReports ::: '+lstStudentReports.size());
            }
        } catch (Exception ex) {
            system.debug(ex.getMessage () + ' at '+ex.getLineNumber());
            
        }
    }
    
    public string getRealityText(Explanations__c ex, string Language){
        string strParticulars = ex.Particulars__c;
        if(Language == 'Hindi') {
            strParticulars = ex.Particulars_Hindi__c;
        } else if(Language == 'Marathi'){
            strParticulars = ex.Particulars_Marathi__c;
        }
        return strParticulars;
    }
    
    /*public string getPersonalityIcon(string Personality){
string iconname = '';
if(Personality == 'Introvert'){
iconname = 'personality_2introverted.png';
} else if(Personality == 'Extrovert') {
iconname = 'personality_1Extroverted.png';
} else if(Personality == 'Sensing') {
iconname = 'personality_sensing.png';    
} else if(Personality == 'Intuition') {
iconname = 'personality_intuition.png';
} else if(Personality == 'Thinking') {
iconname = 'personality_4thinking.png';
} else if(Personality == 'Feeling') {
iconname = 'personality_5feeling.png';
} else if(Personality == 'Judging') {
iconname = 'personality_6judging.png';
} else if(Personality == 'Perceiving') {
iconname = 'personality_7perceiving.png';
}
return iconname;
}*/
    
}