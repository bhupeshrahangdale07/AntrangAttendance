/* Getting details related to recommendation of the student for creating the recommendation pdf*/
public class RecommendationController {
    public List<String> personalityList{set;get;}
    public String pdf{set;get;}
    public String grade{set;get;}
    public String batchNumber{set;get;}
    public String schoolName{set;get;}
    public String trainerName{set;get;}
    public String interest1{set;get;}
    public String interest2{set;get;}
    public String aptitude1{set;get;}
    public String aptitude2{set;get;}
    public String personality1{set;get;}
    public String personality2{set;get;}
    public String personality3{set;get;}
    public String personality4{set;get;}
    public String personality5{set;get;}
    public String personality6{set;get;}
    public String personality7{set;get;}
    public String personality8{set;get;}
    public String reality1{set;get;}
    public String reality2{set;get;}
    public String reality3{set;get;}
    public String reality4{set;get;}
    public String reality5{set;get;}
    public String reality6{set;get;}
    public String reality7{set;get;}
    public String reality8{set;get;}
    Public String profession1{set;get;}
    Public String profession2{set;get;}
    Public String commaSepratedList{set;get;}
    Contact con;
    Contact contact;
    public Boolean professionshowContent1 { get; set; }
    public Boolean professionshowContent2 { get; set; }
    
    public RecommendationController(ApexPages.StandardController controller){
        this.con = (Contact)controller.getRecord();
        /* removed Batch_Number__c from this for logic change  */
        List<Contact> contactList = [select id,name,Current_Aspiration__c,Age__c,Batch_Code__c,Interest_1__c,Interest_2__c,
                                     Batch_Code__r.Batch_Number__c,Batch_Code__r.Grade__c,Batch_Code__r.Trainer_Name__r.Name,
                                     Batch_Code__r.School_Name__r.Name,
                                     Aptitude_1__c,Aptitude_2__c,Personality_1__c,Personality_2__c,Personality_3__c,Personality_4__c,Personality_5__c,
                                     Personality_6__c,Personality_7__c,Personality_8__c,Reality_1__c,Reality_2__c,Reality_3__c,Reality_4__c,Reality_5__c,
                                     Reality_6__c,Reality_7__c,Reality_8__c,Profession_1__c,Profession_1__r.Name,Profession_1_Next_steps__c,Profession_1_Recommendation__c,
                                     Profession_2__c,Profession_2__r.Name,Profession_2_Next_steps__c,Profession_2_Recommendation__c 
                                     from Contact where Contact.id=: + con.id];
        contact = contactList.get(0);
        
        /* get batch name based on batch id */
        if (contact.Batch_Code__c != null){  
            batchNumber = contact.Batch_Code__r.Batch_Number__c;
            grade = contact.Batch_Code__r.Grade__c;
        }
        
        /* get trainer name based on trainer id   */
        if (contact.Batch_Code__c != null && contact.Batch_Code__r.Trainer_Name__c != null){
            trainerName = contact.Batch_Code__r.Trainer_Name__r.Name;
        }
        
        /* get school name based on school id  */
        if (contact.Batch_Code__c != null && contact.Batch_Code__r.School_Name__c != null){
            schoolName = contact.Batch_Code__r.School_Name__r.Name;
        }
        
        /* get explanation  */
        List<Explanations__c> explanationList = [select Name,Particulars__c,Realities__c,Code__c from Explanations__c];
        for (Explanations__c ex: explanationList){
            String interestCheck1='';
            String interestCheck2='';
            String aptitudeCheck1='';
            String aptitudeCheck2='';
            
            /* Explanation of interest */
            if (contact.Interest_1__c!=null){
                interestCheck1 = contact.Interest_1__c;
                interestCheck1+=' '+'-'+' '+interestCheck1.substring(0,1);
            }
            if (contact.Interest_2__c!=null){
                interestCheck2=contact.Interest_2__c;
                interestCheck2+=' '+'-'+' '+interestCheck2.substring(0,1);
            }
            if (ex.Name =='Interest' && ex.Code__c == interestCheck1){
                interest1=ex.Particulars__c;
            }
            if (ex.Name =='Interest' && ex.Code__c == interestCheck2){
                interest2=ex.Particulars__c;
            }
            
            /* Explanation of Aptitude */
            if (contact.Aptitude_1__c!=null){
                aptitudeCheck1=contact.Aptitude_1__c;
                aptitudeCheck1+=' '+'Ability';
            }
            if (contact.Aptitude_2__c!=null){
                aptitudeCheck2=contact.Aptitude_2__c;
                aptitudeCheck2+=' '+'Ability';
            }
            if (ex.Name =='Aptitude' && ex.Code__c == aptitudeCheck1) {
                aptitude1 =ex.Particulars__c; 
            }
            if (ex.Name =='Aptitude' && ex.Code__c == aptitudeCheck2) {
                aptitude2=ex.Particulars__c;
            }
            if (ex.Name =='Personality' && ex.Code__c == contact.Personality_1__c){
                personality1=ex.Particulars__c;
            }
            if (ex.Name =='Personality' && ex.Code__c == contact.Personality_2__c){
                personality2=ex.Particulars__c;
            }
            if (ex.Name =='Personality' && ex.Code__c == contact.Personality_3__c){
                personality3=ex.Particulars__c;
            }
            if (ex.Name =='Personality' && ex.Code__c == contact.Personality_4__c){
                personality4=ex.Particulars__c;
            }
            if (ex.Name =='Personality' && ex.Code__c == contact.Personality_5__c){
                personality5=ex.Particulars__c;
            }
            if (ex.Name =='Personality' && ex.Code__c == contact.Personality_6__c){
                personality6=ex.Particulars__c;
            }
            if (ex.Name =='Personality' && ex.Code__c == contact.Personality_7__c) {
                personality7=ex.Particulars__c;
            }
            if (ex.Name =='Personality' && ex.Code__c == contact.Personality_8__c){
                personality8=ex.Particulars__c;
            }
        }
        
        /* Explanation of Personality */
        personalityList=new List<String>();
        personalityList.clear();
        if (contact.Personality_1__c !=null){
            personalityList.add(contact.Personality_1__c);
        }
        if (contact.Personality_2__c !=null){
            personalityList.add(contact.Personality_2__c);
        }
        if (contact.Personality_3__c !=null){
            personalityList.add(contact.Personality_3__c);
        }
        if (contact.Personality_4__c !=null){
            personalityList.add(contact.Personality_4__c);
        }
        if (contact.Personality_5__c !=null){
            personalityList.add(contact.Personality_5__c);
        }
        if (contact.Personality_6__c !=null) {
            personalityList.add(contact.Personality_6__c);
        }
        if (contact.Personality_7__c !=null) {
            personalityList.add(contact.Personality_7__c);
        }
        if (contact.Personality_8__c !=null){
            personalityList.add(contact.Personality_8__c);
        }
        
        commaSepratedList='';
        for (Integer i=0; i < personalityList.size();i++){
            if(personalityList.get(i) != null && personalityList.get(i) != 'Any') {
                if (i==personalityList.size()-1){
                    commaSepratedList +=personalityList.get(i);
                }
                else {
                    commaSepratedList +=personalityList.get(i)+ ',' ;
                }}
        }
        commaSepratedList = commaSepratedList.subString(0,commaSepratedList.length());
        explanationList.clear();
        
        /*change logic for reality */
        map<string,string> mapRealityExplanations = new map<string,string>();
        for (Explanations__c ex: [Select Name,Particulars__c,Realities__c,Code__c from Explanations__c where Name=: 'Realities' and Code__c != null Order by Code__c]){
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
        if (contact.Reality_1__c == 'Yes' && mapRealityExplanations.containskey('1Yes')){
            reality1 = mapRealityExplanations.get('1Yes');
        } else if(mapRealityExplanations.containskey('1No')) { 
            reality1 = mapRealityExplanations.get('1No');
        }
        if (contact.Reality_2__c=='Yes' && mapRealityExplanations.containskey('2Yes')){
            reality2 = mapRealityExplanations.get('2Yes');
        } else if(mapRealityExplanations.containskey('2No')){ 
            reality2 = mapRealityExplanations.get('2No');
        }
        if (contact.Reality_3__c=='Yes' && mapRealityExplanations.containskey('3Yes')){
            reality3 = mapRealityExplanations.get('3Yes');
        } else if(mapRealityExplanations.containskey('3No')) { 
            reality3 = mapRealityExplanations.get('3No');
        }
        if (contact.Reality_4__c=='Yes' && mapRealityExplanations.containskey('4Yes')){
            reality4 = mapRealityExplanations.get('4Yes');
        } else if(mapRealityExplanations.containskey('4No')) { 
            reality4 = mapRealityExplanations.get('4No');
        }
        if (contact.Reality_5__c=='Yes' && mapRealityExplanations.containskey('5Yes')){
            reality5 = mapRealityExplanations.get('5Yes');
        } else  if(mapRealityExplanations.containskey('5No')) { 
            reality5 = mapRealityExplanations.get('5No');
        }
        if (contact.Reality_6__c=='Yes' && mapRealityExplanations.containskey('6Yes')){
            reality6 = mapRealityExplanations.get('6Yes');
        } else  if(mapRealityExplanations.containskey('6No')) { 
            reality6 = mapRealityExplanations.get('6No');
        }
        if (contact.Reality_7__c=='Yes' && mapRealityExplanations.containskey('7Yes')){
            reality7 = mapRealityExplanations.get('7Yes');
        } else  if(mapRealityExplanations.containskey('7No')) { 
            reality7 = mapRealityExplanations.get('7No');
        }
        
        if (contact.Reality_8__c=='Yes' && mapRealityExplanations.containskey('8Yes')){
            reality8 = mapRealityExplanations.get('8Yes');
        } else  if(mapRealityExplanations.containskey('8No')) { 
            reality8 = mapRealityExplanations.get('8No');
        }
        /* get profession name  */
        if (contact.Profession_1__c != null){
            profession1 = contact.Profession_1__r.Name;
            professionshowContent1=true;
        }
        else{
            professionshowContent1=false;
        }
        if (contact.Profession_2__c != null){
            profession2 = contact.Profession_2__r.Name;
            professionshowContent2=true;
        }
        else{
            professionshowContent2=false;
        }
    } 
    public void redirect(){
        
    }
}