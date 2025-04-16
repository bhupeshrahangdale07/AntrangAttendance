/*
    Description: Class is created for Student Report
*/
public with sharing class StudentReportController {
    
    public Contact objContact {get; set;}
    
    public String Interest_1_Label {get; set;}
    public String Interest_2_Label {get; set;}
    public String Interest_3_Label {get; set;}
    
     public String Aptitude_1_Label {get; set;}
    public String Aptitude_2_Label {get; set;}
    public String Aptitude_3_Label {get; set;}
    
    
    public string strAspiration {get; set;}
    
    public List<Explanations__c> lstInterests {get; set;}
    
    //public string strPersonality {get; set;}
    //public List<string> lstPesonalityIcons {get; set;}
    public List<Explanations__c> lstAptitude {get; set;}
    
    public map<Integer, List<string>> mapAllRealities {get; set;}
    public boolean blnRealityFound {get; set;}
    public string strMiddleIconDocId {get; set;}
    public string strOrgId {get; set;}
    
    public map<string,Explanations__c> mapofInterest;
    public map<string,Explanations__c> mapofPersonality;
    public map<string,Explanations__c> mapofAptitude;
    public map<string,string> mapRealityExplanations;
    
    public StudentReportController (Apexpages.standardcontroller controller) {
        Id conid = controller.getId();
        List<Contact> lstContact = new List<Contact>([select Id,Name,Age__c,Batch_Code__r.Grade__c,Batch_Code__r.Trainer_Name__c,
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
                Profession_1__c,Profession_1_After_10th__c,Profession_1_After_12th__c,Profession_1_You_could_be_a__c,
                Profession_1_Additional_Info__c,Profession_1_Avg_Salary__c,Profession_1_Famous_Person__c,Profession_1_Fun_Fact__c, 
                Profession_1__r.Icon_Name__c,Profession_1__r.Document_Icon_Id__c, Profession_2__c,Profession_2_After_10th__c, Profession_2_You_could_be_a__c,
                Profession_2_After_12th__c, Profession_2_Additional_Info__c,Profession_2_Avg_Salary__c,Profession_2_Famous_Person__c,
                Profession_2_Fun_Fact__c, Profession_2__r.Icon_Name__c,Profession_2__r.Document_Icon_Id__c,Profession_2__r.Name,Batch_Code__r.Preferred_Language__c,
                Batch_Code__c,Batch_Code__r.School_Name__c,Batch_Code__r.School_Name__r.Name from Contact Where Id =: conid
                and Recommendation_Report_Status__c != 'Incomplete profile' AND Recommedation_Status__c = 'Processed']);
        
        if(lstContact.size() > 0){
            objContact = lstContact[0];
            
            Interest_1_Label = (String) objContact.get('Interest_1_Label');
            Interest_2_Label = (String) objContact.get('Interest_2_Label');
            Interest_3_Label = (String) objContact.get('Interest_3_Label');
            
            Aptitude_1_Label = (String) objContact.get('Aptitude_1_Label');
            Aptitude_2_Label = (String) objContact.get('Aptitude_2_Label');
            Aptitude_3_Label = (String) objContact.get('Aptitude_3_Label');
        }
        
        FillDefaultDetails();
        
        BindDetails();
    }
    
    public void FillDefaultDetails(){
        mapofInterest = new map<string,Explanations__c>();
        for(Explanations__c objEx: [select Id,Name,Code__c,Icon_Name__c,Particulars__c,Particulars_Hindi__c,Particulars_Marathi__c,Document_Icon_Id__c from Explanations__c Where Name = 'Interest']){
            mapofInterest.put(objEx.Code__c, objEx);
        }
        
        /*mapofPersonality = new map<string,Explanations__c>();
        for(Explanations__c objEx: [select Id,Name,Code__c,Icon_Name__c,Particulars__c,Particulars_Hindi__c,Particulars_Marathi__c,Document_Icon_Id__c from Explanations__c Where Name = 'Personality']){
            mapofPersonality.put(objEx.Code__c, objEx);
        }*/
        
        mapofAptitude = new map<string,Explanations__c>();
        for(Explanations__c objEx: [select Id,Name,Code__c,Icon_Name__c,Particulars__c,Particulars_Hindi__c,Particulars_Marathi__c,Document_Icon_Id__c from Explanations__c Where Name = 'Aptitude']){
            mapofAptitude.put(objEx.Code__c, objEx);
        }
        
        /*fill map of explanation*/
        mapRealityExplanations = new map<string,string>();
        for (Explanations__c ex: [Select Name,Particulars__c,Realities__c,Code__c,Particulars_Hindi__c,Particulars_Marathi__c,Document_Icon_Id__c from Explanations__c where Name= 'Realities' and Code__c != null Order by Code__c]){
            if(ex.Code__c.startswith('Self 1')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('1Yes',getRealityText(ex));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('1No',getRealityText(ex));
                }
            }
            if(ex.Code__c.startswith('Self 2')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('2Yes',getRealityText(ex));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('2No',getRealityText(ex));
                }
            }
            if(ex.Code__c.startswith('Self 3')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('3Yes',getRealityText(ex));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('3No',getRealityText(ex));
                }
            }
            if(ex.Code__c.startswith('Self 4')) {
                if(ex.Realities__c == 'A') {
                    mapRealityExplanations.put('4A',getRealityText(ex));
                }
                if(ex.Realities__c == 'B') {
                    mapRealityExplanations.put('4B',getRealityText(ex));
                }
                if(ex.Realities__c == 'C') {
                    mapRealityExplanations.put('4C',getRealityText(ex));
                }
            }
            if(ex.Code__c.startswith('Family 1')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('5Yes',getRealityText(ex));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('5No',getRealityText(ex));
                }
            }
            if(ex.Code__c.startswith('Family 2')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('6Yes',getRealityText(ex));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('6No',getRealityText(ex));
                }
            }
            if(ex.Code__c.startswith('Family 3')) {
                if(ex.Realities__c == 'Yes') {
                    mapRealityExplanations.put('7Yes',getRealityText(ex));
                }
                if(ex.Realities__c == 'No') {
                    mapRealityExplanations.put('7No',getRealityText(ex));
                }
            }
            if(ex.Code__c.startswith('Family 4')) {
                if(ex.Realities__c == 'A') {
                    mapRealityExplanations.put('8A',getRealityText(ex));
                }
                if(ex.Realities__c == 'B') {
                    mapRealityExplanations.put('8B',getRealityText(ex));
                }
                if(ex.Realities__c == 'C') {
                    mapRealityExplanations.put('8C',getRealityText(ex));
                }
            }
        }
    }
    
    public string getRealityText(Explanations__c ex){
        string strParticulars = ex.Particulars__c;
        if(objContact.Batch_Code__c != null && objContact.Batch_Code__r.Preferred_Language__c != null && objContact.Batch_Code__r.Preferred_Language__c == 'Hindi') {
            strParticulars = ex.Particulars_Hindi__c;
        } else if(objContact.Batch_Code__c != null && objContact.Batch_Code__r.Preferred_Language__c != null && objContact.Batch_Code__r.Preferred_Language__c == 'Marathi'){
            strParticulars = ex.Particulars_Marathi__c;
        }
        return strParticulars;
    }
    
    public void BindDetails(){
        if(objContact.Id != null) {
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
            List<string> lstAspiration = new List<string>();
            if(objContact.Aspiration_1__c != null) {
                lstAspiration.add(objContact.Aspiration_1__r.Name);
            }
            if(objContact.Aspiration_2__c != null) {
                lstAspiration.add(objContact.Aspiration_2__r.Name);
            }
            if(objContact.Aspiration_3__c != null) {
                lstAspiration.add(objContact.Aspiration_3__r.Name);
            }
            strAspiration = string.join(lstAspiration,',');
            
            //get interest
            lstInterests = new List<Explanations__c>();
            if(objContact.Interest_1__c != null && mapofInterest.containskey(objContact.Interest_1__c+' - ' +objContact.Interest_1__c.left(1))) {
                lstInterests.add(mapofInterest.get(objContact.Interest_1__c+' - ' +objContact.Interest_1__c.left(1)));
            }
            if(objContact.Interest_2__c != null && mapofInterest.containskey(objContact.Interest_2__c+' - ' +objContact.Interest_2__c.left(1))) {
                lstInterests.add(mapofInterest.get(objContact.Interest_2__c+' - ' +objContact.Interest_2__c.left(1)));
            }
            if(objContact.Interest_3__c != null && mapofInterest.containskey(objContact.Interest_3__c+' - ' +objContact.Interest_3__c.left(1))) {
                lstInterests.add(mapofInterest.get(objContact.Interest_3__c+' - ' +objContact.Interest_3__c.left(1)));
            }
            
            //get personality
            /*strPersonality = '';
            List<string> lstStrPersonality = new List<string>();
            lstPesonalityIcons = new List<string>();
            if(objContact.Personality_1__c != null){
                lstStrPersonality.add(objContact.Personality_1__c);
                if(mapOfPersonalityDocumentIds.containskey(objContact.Personality_1__c)){
                    lstPesonalityIcons.add(mapOfPersonalityDocumentIds.get(objContact.Personality_1__c));
                }
            }
            if(objContact.Personality_2__c != null){
                lstStrPersonality.add(objContact.Personality_2__c);
                if(mapOfPersonalityDocumentIds.containskey(objContact.Personality_2__c)){
                    lstPesonalityIcons.add(mapOfPersonalityDocumentIds.get(objContact.Personality_2__c));
                }
            }
            if(objContact.Personality_3__c != null){
                lstStrPersonality.add(objContact.Personality_3__c);
                if(mapOfPersonalityDocumentIds.containskey(objContact.Personality_3__c)){
                    lstPesonalityIcons.add(mapOfPersonalityDocumentIds.get(objContact.Personality_3__c));
                }
            }
            if(objContact.Personality_4__c != null){
                lstStrPersonality.add(objContact.Personality_4__c);
                if(mapOfPersonalityDocumentIds.containskey(objContact.Personality_4__c)){
                    lstPesonalityIcons.add(mapOfPersonalityDocumentIds.get(objContact.Personality_4__c));
                }
            }
            string strPersonalityCombination = string.join(lstStrPersonality,',');
            if(mapofPersonality.containskey(strPersonalityCombination)){
                strPersonality = mapofPersonality.get(strPersonalityCombination).Particulars__c;
                if(objContact.Batch_Code__c != null && objContact.Batch_Code__r.Preferred_Language__c != null && objContact.Batch_Code__r.Preferred_Language__c == 'Hindi'){
                    strPersonality = mapofPersonality.get(strPersonalityCombination).Particulars_Hindi__c;
                } else if(objContact.Batch_Code__c != null && objContact.Batch_Code__r.Preferred_Language__c != null && objContact.Batch_Code__r.Preferred_Language__c == 'Marathi'){
                    strPersonality = mapofPersonality.get(strPersonalityCombination).Particulars_Marathi__c;
                }
            }*/
            /*lstPersonality = new List<Explanations__c>();
            if(objContact.Personality_1__c != null && objContact.Personality_1__c != 'Any' && mapofPersonality.containskey(objContact.Personality_1__c)) {
                lstPersonality.add(mapofPersonality.get(objContact.Personality_1__c));
            }
            if(objContact.Personality_2__c != null && objContact.Personality_2__c != 'Any' && mapofPersonality.containskey(objContact.Personality_2__c)) {
                lstPersonality.add(mapofPersonality.get(objContact.Personality_2__c));
            }
            if(lstPersonality.size() < 2 && objContact.Personality_3__c != null && objContact.Personality_3__c != 'Any' && mapofPersonality.containskey(objContact.Personality_3__c)) {
                lstPersonality.add(mapofPersonality.get(objContact.Personality_3__c));
            }
            if(lstPersonality.size() < 2 && objContact.Personality_4__c != null && objContact.Personality_4__c != 'Any' && mapofPersonality.containskey(objContact.Personality_4__c)) {
                lstPersonality.add(mapofPersonality.get(objContact.Personality_4__c));
            }*/
               
            //get interest
            lstAptitude = new List<Explanations__c>();
            if(objContact.Aptitude_1__c != null && mapofAptitude.containskey(objContact.Aptitude_1__c + ' Ability')) {
                lstAptitude.add(mapofAptitude.get(objContact.Aptitude_1__c + ' Ability'));
            }
            if(objContact.Aptitude_2__c != null && mapofAptitude.containskey(objContact.Aptitude_2__c + ' Ability')) {
                lstAptitude.add(mapofAptitude.get(objContact.Aptitude_2__c + ' Ability'));
            }
            if(objContact.Aptitude_3__c != null && mapofAptitude.containskey(objContact.Aptitude_3__c + ' Ability')) {
                lstAptitude.add(mapofAptitude.get(objContact.Aptitude_3__c + ' Ability'));
            }
            
            /*change logic for reality */
            blnRealityFound = false;
            mapAllRealities = new map<Integer, List<string>>();
            if (objContact.Reality_1__c == 'Yes' && mapRealityExplanations.containskey('1Yes')){
                mapAllRealities.put(1, new List<string>{mapRealityExplanations.get('1Yes')});
            } else if(objContact.Reality_1__c == 'No' && mapRealityExplanations.containskey('1No')) { 
                mapAllRealities.put(1, new List<string>{mapRealityExplanations.get('1No')});
            }
            if (objContact.Reality_2__c=='Yes' && mapRealityExplanations.containskey('2Yes')){
                if(mapAllRealities.containskey(1)){
                    mapAllRealities.get(1).add(mapRealityExplanations.get('2Yes'));
                } else {
                    mapAllRealities.put(1,new List<string>{mapRealityExplanations.get('2Yes')});
                }
            } else if(objContact.Reality_2__c=='No' && mapRealityExplanations.containskey('2No')){ 
                if(mapAllRealities.containskey(1)){
                    mapAllRealities.get(1).add(mapRealityExplanations.get('2No'));
                } else {
                    mapAllRealities.put(1,new List<string>{mapRealityExplanations.get('2No')});
                }
            }
            if (objContact.Reality_3__c=='Yes' && mapRealityExplanations.containskey('3Yes')){
                mapAllRealities.put(2, new List<string>{mapRealityExplanations.get('3Yes')});
            } else if(objContact.Reality_3__c=='No' && mapRealityExplanations.containskey('3No')) { 
                mapAllRealities.put(2, new List<string>{mapRealityExplanations.get('3No')});
            }
            if(objContact.Reality_4__c=='B' && mapRealityExplanations.containskey('4B')) { 
                if(mapAllRealities.containskey(2)){
                    mapAllRealities.get(2).add(mapRealityExplanations.get('4B'));
                } else {
                    mapAllRealities.put(2,new List<string>{mapRealityExplanations.get('4B')});
                }
            } else  if(objContact.Reality_4__c=='C' && mapRealityExplanations.containskey('4C')) { 
                if(mapAllRealities.containskey(2)){
                    mapAllRealities.get(2).add(mapRealityExplanations.get('4C'));
                } else {
                    mapAllRealities.put(2,new List<string>{mapRealityExplanations.get('4C')});
                }
            } else if (objContact.Reality_4__c=='A' && mapRealityExplanations.containskey('4A')){
                if(mapAllRealities.containskey(2)){
                    mapAllRealities.get(2).add(mapRealityExplanations.get('4A'));
                } else {
                    mapAllRealities.put(2,new List<string>{mapRealityExplanations.get('4A')});
                }
            }
            if (objContact.Reality_5__c=='Yes' && mapRealityExplanations.containskey('5Yes')){
                mapAllRealities.put(3, new List<string>{mapRealityExplanations.get('5Yes')});
            } else  if(objContact.Reality_5__c=='No' && mapRealityExplanations.containskey('5No')) { 
                mapAllRealities.put(3, new List<string>{mapRealityExplanations.get('5No')});
            }
            if (objContact.Reality_6__c=='Yes' && mapRealityExplanations.containskey('6Yes')){
                if(mapAllRealities.containskey(3)){
                    mapAllRealities.get(3).add(mapRealityExplanations.get('6Yes'));
                } else {
                    mapAllRealities.put(3,new List<string>{mapRealityExplanations.get('6Yes')});
                }
            } else  if(objContact.Reality_6__c=='No' && mapRealityExplanations.containskey('6No')) { 
                if(mapAllRealities.containskey(3)){
                    mapAllRealities.get(3).add(mapRealityExplanations.get('6No'));
                } else {
                    mapAllRealities.put(3,new List<string>{mapRealityExplanations.get('6No')});
                }
            }
            if (objContact.Reality_7__c=='Yes' && mapRealityExplanations.containskey('7Yes')){
                mapAllRealities.put(4, new List<string>{mapRealityExplanations.get('7Yes')});
            } else  if(objContact.Reality_7__c=='No' && mapRealityExplanations.containskey('7No')) { 
                mapAllRealities.put(4, new List<string>{mapRealityExplanations.get('7No')});
            }
            if(objContact.Reality_8__c=='B' && mapRealityExplanations.containskey('8B')) { 
                //mapAllRealities.get(4).add(mapRealityExplanations.get('8B'));
                if(mapAllRealities.containskey(4)){
                    mapAllRealities.get(4).add(mapRealityExplanations.get('8B'));
                } else {
                    mapAllRealities.put(4,new List<string>{mapRealityExplanations.get('8B')});
                }
            } else  if(objContact.Reality_8__c=='C' && mapRealityExplanations.containskey('8C')) { 
                if(mapAllRealities.containskey(4)){
                    mapAllRealities.get(4).add(mapRealityExplanations.get('8C'));
                } else {
                    mapAllRealities.put(4,new List<string>{mapRealityExplanations.get('8C')});
                }
            } else if (objContact.Reality_8__c=='A' && mapRealityExplanations.containskey('8A')){
                if(mapAllRealities.containskey(4)){
                    mapAllRealities.get(4).add(mapRealityExplanations.get('8A'));
                } else {
                    mapAllRealities.put(4,new List<string>{mapRealityExplanations.get('8A')});
                }
            } 
            
            List<Document> lstDoc = new List<Document>([select Id from Document Where DeveloperName = 'Middle_Icon']);
            if(lstDoc.size() > 0) {
                strMiddleIconDocId = lstDoc[0].Id;
            }
            strOrgId = UserInfo.getOrganizationId();

        }
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