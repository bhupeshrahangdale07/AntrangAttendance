/* for calculating the count of career track based on 'CareerAwarences' csv file data*/
global class CareerAware{ 
    global  void getCareerData(Contact a){ 
        String checkString='',ans='',choices;
        Integer count=0,careerTracks1=0;
        String[] stringCharacters,stringCharacters1,stringCharacters2,stringCharacters3,stringCharacters4,stringCharacters5,stringCharacters6,stringCharacters7,stringCharacters8,stringCharacters9,stringCharacters10,stringCharacters11,stringCharacters12; 
        Map<String,Integer> mp = new Map<String,Integer>();
        List<Question_Bank__c> conDesign=[select Category__c from Question_Bank__c where Category1__c =:'Design'];
        List<Question_Bank__c> conPerform=[select Category__c from Question_Bank__c where Category1__c =:'Performance Arts'];
        List<Question_Bank__c> conMedi=[select Category__c from Question_Bank__c where Category1__c =:'Media and communication'];
        List<Question_Bank__c> conBeauty=[select Category__c from Question_Bank__c where Category1__c =:'Beauty and Wellness'];
        List<Question_Bank__c> conEdu=[select Category__c from Question_Bank__c where Category1__c =:'Education'];
        List<Question_Bank__c> conSport=[select Category__c from Question_Bank__c where Category1__c =:'Sports and fitness'];
        List<Question_Bank__c> conFinance=[select Category__c from Question_Bank__c where Category1__c =:'Finance'];
        List<Question_Bank__c> conHospi=[select Category__c from Question_Bank__c where Category1__c =:'Hospitality'];
        List<Question_Bank__c> conMedical=[select Category__c from Question_Bank__c where Category1__c =:'Medical'];
        List<Question_Bank__c> conPubser=[select Category__c from Question_Bank__c where Category1__c =:'Public services'];
        List<Question_Bank__c> conEngg=[select Category__c from Question_Bank__c where Category1__c =:'Engineering'];
        List<Question_Bank__c> conTrade=[select Category__c from Question_Bank__c where Category1__c =:'Trades'];
        List<Question_Bank__c> conEnv=[select Category__c from Question_Bank__c where Category1__c =:'Environmental and biological'];
        //FetchAllData fetchData=new FetchAllData();
        
        if (a.Design__c == null && a.Performance_Arts__c == null && a.Media_Communication__c == null && a.Beauty_Wellness__c == null && a.Education__c ==null && a.Sports_Fitness__c == null && a.Finance__c ==null && a.Hospitality_Tourism__c== null && a.Medical__c==null && a.Public_Services__c==null && a.Enginnering_technologies__c==null && a.Trades__c==null && a.Enviomental_and_Biological_Sciences__c==null){
            count=-1;
             a.Career_Tracks__c=count;
             a.Status__c='Processed';
             update a;
        }
        else {
        choices = a.Design__c;
        if (choices !=null){
            stringCharacters = choices.split('');
            ans = conDesign.get(0).Category__c;
            for (Integer j=0;j<=stringCharacters.size()-1;j++){
                if (ans.contains(stringCharacters[j]) && stringCharacters[j]!=','){
                    count++;
                }
            }
        }
        mp.put('Design',count);
        count=0;choices='';ans='';
        choices = a.Performance_Arts__c;
        if (choices !=null){
            stringCharacters1 = choices.split('');
            ans = conPerform.get(0).Category__c;
            for (Integer j=0;j<=stringCharacters1.size()-1;j++){
                if (ans.contains(stringCharacters1[j]) && stringCharacters1[j]!=','){
                    count++;
                }
            }
        }
        mp.put('Performance and Arts',count);
        count=0;choices='';ans='';
        choices = a.Media_Communication__c;
        if (choices !=null){
            stringCharacters2 = choices.split('');
            ans = conMedi.get(0).Category__c;
            for (Integer j=0;j<=stringCharacters2.size()-1;j++){
                if (ans.contains(stringCharacters2[j]) && stringCharacters2[j]!=','){
                    count++;
                }
            }
        }
        mp.put('Media and Communication',count);
        count=0;choices='';ans='';
        choices = a.Beauty_Wellness__c;
        if (choices !=null){
            stringCharacters3 = choices.split('');
            ans = conBeauty.get(0).Category__c;
            for (Integer j=0;j<=stringCharacters3.size()-1;j++){
                if (ans.contains(stringCharacters3[j]) && stringCharacters3[j]!=','){
                    count++;
                }
            }
        }
        mp.put('Beauty and Wellness',count);
        count=0;choices='';ans='';
        choices = a.Education__c;
        if (choices !=null){
            stringCharacters4 = choices.split('');
            ans = conEdu.get(0).Category__c;
            for (Integer j=0;j<=stringCharacters4.size()-1;j++){
                if (ans.contains(stringCharacters4[j]) && stringCharacters4[j]!=','){
                    count++;
                }
            }
        }
        mp.put('Education',count);
        count=0;choices='';ans='';
        
        choices = a.Sports_Fitness__c;
        if (choices !=null){
            stringCharacters5 = choices.split('');
            ans = conSport.get(0).Category__c;
            for (Integer j=0;j<=stringCharacters5.size()-1;j++){
                if (ans.contains(stringCharacters5[j]) && stringCharacters5[j]!=','){
                    count++;
                }
            }
        }
        mp.put('Sports and Fitness',count);
        count=0;choices='';ans='';
        choices = a.Finance__c;
        if (choices !=null){
            stringCharacters6 = choices.split('');
            ans = conFinance.get(0).Category__c;
            for (Integer j=0;j<=stringCharacters6.size()-1;j++){
                if (ans.contains(stringCharacters6[j]) && stringCharacters6[j]!=','){
                    count++;
                }
            }
        }
        mp.put('Finance',count);
        count=0;choices='';ans='';
        choices = a.Hospitality_Tourism__c;
        if (choices !=null){
            stringCharacters7 = choices.split('');
            ans = conHospi.get(0).Category__c;
            for (Integer j=0;j<=stringCharacters7.size()-1;j++){
                if (ans.contains(stringCharacters7[j]) && stringCharacters7[j]!=','){
                    count++;
                }
            }
        }
        mp.put('Hospitality',count);
        count=0;choices='';ans='';
        
        choices = a.Medical__c;
        if (choices !=null){
            stringCharacters8 = choices.split('');
            ans = conMedical.get(0).Category__c;
            for (Integer j=0;j<=stringCharacters8.size()-1;j++){
                if (ans.contains(stringCharacters8[j]) && stringCharacters8[j]!=','){
                    count++;
                }
            }
        }
        mp.put('Medical',count);
        count=0;choices='';ans='';
        choices = a.Public_Services__c;
        if (choices !=null){
            stringCharacters9 = choices.split('');
            ans = conPubser.get(0).Category__c;
            for(Integer j=0;j<=stringCharacters9.size()-1;j++){
                if(ans.contains(stringCharacters9[j]) && stringCharacters9[j]!=','){
                    count++;
                }
            }
        }
        mp.put('Public Service',count);
        count=0;choices='';ans='';
        choices = a.Enginnering_technologies__c;
        if (choices !=null){
            stringCharacters10 = choices.split('');
            ans = conEngg.get(0).Category__c;
            for (Integer j=0;j<=stringCharacters10.size()-1;j++){
                if (ans.contains(stringCharacters10[j]) && stringCharacters10[j]!=','){
                    count++;
                }
            }
        }
        mp.put('Engineering Technologies',count);
        count=0;choices='';ans='';
        choices = a.Trades__c;
        if (choices !=null){
            stringCharacters11 = choices.split('');
            ans = conTrade.get(0).Category__c;
            for (Integer j=0;j<=stringCharacters11.size()-1;j++){
                if (ans.contains(stringCharacters11[j]) && stringCharacters11[j]!=','){
                    count++;
                }
            }
        }
        mp.put('Trades',count);
        count=0;choices='';ans='';
        choices =a.Enviomental_and_Biological_Sciences__c;
        if (choices !=null){
            stringCharacters12 = choices.split('');
            ans = conEnv.get(0).Category__c;
            for (Integer j=0;j<=stringCharacters12.size()-1;j++){
                if (ans.contains(stringCharacters12[j]) && stringCharacters12[j]!=','){
                    count++;
                }
            }
        }
        mp.put('Enviroment and Biological Science',count);
        for (String s1 : mp.keySet()) {
            if (mp.get(s1)>=5){
                careerTracks1=careerTracks1+1; 
            }
        }   
            
        a.Career_Tracks__c=careerTracks1;
        a.Status__c='Processed';
        update a;
        }
    }       
}