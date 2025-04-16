public class SelfAwarenessandFeedbackBatch implements Database.Batchable<sObject>, Schedulable {
    public void execute(SchedulableContext ctx) {
        SelfAwarenessandFeedbackBatch selfAwar = new SelfAwarenessandFeedbackBatch();
        Database.executeBatch(selfAwar, 200);
    }
    
    public Static String query = '';
    public Set<Id> selfAwareIds = New Set<Id>();
    
    public SelfAwarenessandFeedbackBatch(Set<Id> selfAwareIds){
        this.selfAwareIds = selfAwareIds;
    }
    
    public SelfAwarenessandFeedbackBatch(){}
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
        system.debug('selfAwareIds : ' +selfAwareIds);
        if(String.isBlank(query)){
            query = 'Select Id,Interest_1_Selected_By_Student__c,Interest_2_Selected_By_Student__c,Interest_3_Selected_By_Student__c,Interest_1__c,Interest_2__c,Interest_3__c,Aptitude_1_Selected_By_Student__c,Aptitude_2_Selected_By_Student__c,Aptitude_3_Selected_By_Student__c,Aptitude_1__c,Aptitude_2__c,Aptitude_3__c,';
            for(Integer i = 1 ; i <= 48 ; i++){
                query += 'Interest_Test_'+i+'__c,';
            }
            query += 'Spatial_Ability_Q_1__c,Spatial_Ability_Q_2__c,Spatial_Ability_Q_3__c,Spatial_Ability_Q_4__c,Spatial_Ability_Q_5__c,'+
                'Spatial_Ability_Q_6__c,Spatial_Ability_Q_7__c,Spatial_Ability_Q_8__c,Numerical_1__c,Numerical_2__c,Numerical_3__c,'+
                'Numerical_4__c,Numerical_5__c,Numerical_6__c,Numerical_7__c,Numerical_8__c,Abstract_Reasoning_Q_1__c,Abstract_Reasoning_Q_2__c,'+
                'Abstract_Reasoning_Q_3__c,Abstract_Reasoning_Q_4__c,Abstract_Reasoning_Q_5__c,Abstract_Reasoning_Q_6__c,Abstract_Reasoning_Q_7__c,'+
                'Abstract_Reasoning_Q_8__c,Creative_1__c,Creative_2__c,Creative_3__c,Creative_4__c,Creative_5__c,Creative_6__c,Creative_7__c,'+
                'Creative_8__c,Mechanical_1__c,Mechanical_2__c,Mechanical_3__c,Mechanical_4__c,Mechanical_5__c,Mechanical_6__c,Mechanical_7__c,'+
                'Mechanical_8__c,Verbal_1__c,Verbal_2__c,Verbal_3__c,Verbal_4__c,Verbal_5__c,Verbal_6__c,Verbal_7__c,Verbal_8__c';
            //query = query.removeEnd(',');
            query +=' From Self_Awareness_and_Feedback__c ';
            // updated below condition as part of batch removing from the trigger and this can also run by independent
            //' Where Id IN :selfAwareIds';
            
            if(selfAwareIds.size() > 0){
                query +=' Where Id IN :selfAwareIds';
            }else{
                query +=' Where IsProcessed__c = false';
            }
        }
        system.debug('query ' + query);
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Self_Awareness_and_Feedback__c> selfAwareLIST){
        map<string, List<Question_Bank__c>> mapAllQBCategoryWise = Utility.getAllCategorywiseQuestions();
        for(Self_Awareness_and_Feedback__c selfaware : selfAwareLIST){
            selfaware.IsProcessed__c = true;
            
            map<Integer, List<string>> mapCountWiseInterest = new map<Integer, List<string>>();
            Map<String, Integer> mp = new Map<String, Integer>();
            List<Integer> interestList = new List<Integer>(); 
            List<String> highestInterest = new List<String>();
            
            Boolean anyRealistInterestSeleced = False;
            if(String.isNotBlank(selfaware.Interest_Test_1__c) || String.isNotBlank(selfaware.Interest_Test_2__c) || 
              String.isNotBlank(selfaware.Interest_Test_3__c) || String.isNotBlank(selfaware.Interest_Test_4__c) || 
              String.isNotBlank(selfaware.Interest_Test_5__c) || String.isNotBlank(selfaware.Interest_Test_6__c) || 
              String.isNotBlank(selfaware.Interest_Test_7__c) || String.isNotBlank(selfaware.Interest_Test_8__c)){
                anyRealistInterestSeleced = true;
            }
            List<String> realistInterest = new List<String>();
            realistInterest.add(selfaware.Interest_Test_1__c);
            realistInterest.add(selfaware.Interest_Test_2__c);
            realistInterest.add(selfaware.Interest_Test_3__c);
            realistInterest.add(selfaware.Interest_Test_4__c);
            realistInterest.add(selfaware.Interest_Test_5__c);
            realistInterest.add(selfaware.Interest_Test_6__c);
            realistInterest.add(selfaware.Interest_Test_7__c);
            realistInterest.add(selfaware.Interest_Test_8__c);
            
            Integer realistCount = 0;
            for (String interest : realistInterest) {
                if (String.isNotBlank(interest) && interest == 'A') {
                    realistCount++;
                }
            }
            if (realistCount > 0)
                mp.put('Realist', realistCount); 
            
            Boolean anyInvestigativeInterestSeleced = False;
            if(String.isNotBlank(selfaware.Interest_Test_9__c) || String.isNotBlank(selfaware.Interest_Test_10__c) || 
              String.isNotBlank(selfaware.Interest_Test_11__c) || String.isNotBlank(selfaware.Interest_Test_12__c) || 
              String.isNotBlank(selfaware.Interest_Test_13__c) || String.isNotBlank(selfaware.Interest_Test_14__c) || 
              String.isNotBlank(selfaware.Interest_Test_15__c) || String.isNotBlank(selfaware.Interest_Test_16__c)){
                anyInvestigativeInterestSeleced = true;
            }
            List<String> investigativeInterest = new List<String>();
            investigativeInterest.add(selfaware.Interest_Test_9__c);
            investigativeInterest.add(selfaware.Interest_Test_10__c);
            investigativeInterest.add(selfaware.Interest_Test_11__c);
            investigativeInterest.add(selfaware.Interest_Test_12__c);
            investigativeInterest.add(selfaware.Interest_Test_13__c);
            investigativeInterest.add(selfaware.Interest_Test_14__c);
            investigativeInterest.add(selfaware.Interest_Test_15__c);
            investigativeInterest.add(selfaware.Interest_Test_16__c);
            
            Integer investigativeCount = 0;
            for (String interest : investigativeInterest) {
                if (String.isNotBlank(interest) && interest == 'A') {
                    investigativeCount++;
                }
            }
            if (investigativeCount>0)
                mp.put('Investigative', investigativeCount);
            
            Boolean anyArtisticInterestSeleced = False;
            if(String.isNotBlank(selfaware.Interest_Test_17__c) || String.isNotBlank(selfaware.Interest_Test_18__c) || 
              String.isNotBlank(selfaware.Interest_Test_19__c) || String.isNotBlank(selfaware.Interest_Test_20__c) || 
              String.isNotBlank(selfaware.Interest_Test_21__c) || String.isNotBlank(selfaware.Interest_Test_22__c) || 
              String.isNotBlank(selfaware.Interest_Test_23__c) || String.isNotBlank(selfaware.Interest_Test_24__c)){
                anyArtisticInterestSeleced = true;
            }
            List<String> artisticInterest = new List<String>();
            artisticInterest.add(selfaware.Interest_Test_17__c);
            artisticInterest.add(selfaware.Interest_Test_18__c);
            artisticInterest.add(selfaware.Interest_Test_19__c);
            artisticInterest.add(selfaware.Interest_Test_20__c);
            artisticInterest.add(selfaware.Interest_Test_21__c);
            artisticInterest.add(selfaware.Interest_Test_22__c);
            artisticInterest.add(selfaware.Interest_Test_23__c);
            artisticInterest.add(selfaware.Interest_Test_24__c);
            
            Integer artisticCount = 0;
            for (String interest : artisticInterest) {
                if (String.isNotBlank(interest) && interest == 'A') {
                    artisticCount++;
                }
            }
            if (artisticCount>0)
                mp.put('Artistic', artisticCount);
            
            Boolean anySocialInterestSeleced = False;
            if(String.isNotBlank(selfaware.Interest_Test_25__c) || String.isNotBlank(selfaware.Interest_Test_26__c) || 
              String.isNotBlank(selfaware.Interest_Test_27__c) || String.isNotBlank(selfaware.Interest_Test_28__c) || 
              String.isNotBlank(selfaware.Interest_Test_29__c) || String.isNotBlank(selfaware.Interest_Test_30__c) || 
              String.isNotBlank(selfaware.Interest_Test_31__c) || String.isNotBlank(selfaware.Interest_Test_32__c)){
                anySocialInterestSeleced = true;
            }
            List<String> socialInterest = new List<String>();
            socialInterest.add(selfaware.Interest_Test_25__c);
            socialInterest.add(selfaware.Interest_Test_26__c);
            socialInterest.add(selfaware.Interest_Test_27__c);
            socialInterest.add(selfaware.Interest_Test_28__c);
            socialInterest.add(selfaware.Interest_Test_29__c);
            socialInterest.add(selfaware.Interest_Test_30__c);
            socialInterest.add(selfaware.Interest_Test_31__c);
            socialInterest.add(selfaware.Interest_Test_32__c);
            
            Integer socialCount = 0;
            for (String interest : socialInterest) {
                if (String.isNotBlank(interest) && interest == 'A') {
                    socialCount++;
                }
            }
            if (socialCount>0)
                mp.put('Social', socialCount);
            
            Boolean anyEnterprisingInterestSeleced = False;
            if(String.isNotBlank(selfaware.Interest_Test_33__c) || String.isNotBlank(selfaware.Interest_Test_34__c) || 
              String.isNotBlank(selfaware.Interest_Test_35__c) || String.isNotBlank(selfaware.Interest_Test_36__c) || 
              String.isNotBlank(selfaware.Interest_Test_37__c) || String.isNotBlank(selfaware.Interest_Test_38__c) || 
              String.isNotBlank(selfaware.Interest_Test_39__c) || String.isNotBlank(selfaware.Interest_Test_40__c)){
                anyEnterprisingInterestSeleced = true;
            }
            List<String> enterprisingInterest = new List<String>();
            enterprisingInterest.add(selfaware.Interest_Test_33__c);
            enterprisingInterest.add(selfaware.Interest_Test_34__c);
            enterprisingInterest.add(selfaware.Interest_Test_35__c);
            enterprisingInterest.add(selfaware.Interest_Test_36__c);
            enterprisingInterest.add(selfaware.Interest_Test_37__c);
            enterprisingInterest.add(selfaware.Interest_Test_38__c);
            enterprisingInterest.add(selfaware.Interest_Test_39__c);
            enterprisingInterest.add(selfaware.Interest_Test_40__c);
            
            Integer enterprisingCount = 0;
            for (String interest : enterprisingInterest) {
                if (String.isNotBlank(interest) && interest == 'A') {
                    enterprisingCount++;
                }
            }
            if (enterprisingCount > 0)
                mp.put('Enterprising', enterprisingCount);
            
            Boolean anyConventionalInterestSeleced = False;
            if(String.isNotBlank(selfaware.Interest_Test_41__c) || String.isNotBlank(selfaware.Interest_Test_42__c) || 
              String.isNotBlank(selfaware.Interest_Test_43__c) || String.isNotBlank(selfaware.Interest_Test_44__c) || 
              String.isNotBlank(selfaware.Interest_Test_45__c) || String.isNotBlank(selfaware.Interest_Test_46__c) || 
              String.isNotBlank(selfaware.Interest_Test_47__c) || String.isNotBlank(selfaware.Interest_Test_48__c)){
                anyConventionalInterestSeleced = true;
            }
            List<String> conventionalInterest = new List<String>();
            conventionalInterest.add(selfaware.Interest_Test_41__c);
            conventionalInterest.add(selfaware.Interest_Test_42__c);
            conventionalInterest.add(selfaware.Interest_Test_43__c);
            conventionalInterest.add(selfaware.Interest_Test_44__c);
            conventionalInterest.add(selfaware.Interest_Test_45__c);
            conventionalInterest.add(selfaware.Interest_Test_46__c);
            conventionalInterest.add(selfaware.Interest_Test_47__c);
            conventionalInterest.add(selfaware.Interest_Test_48__c); 
            
            Integer conventionalCount = 0;
            for (String interest : conventionalInterest) {
                if (String.isNotBlank(interest) && interest == 'A') {
                    conventionalCount++;
                }
            }
            if (conventionalCount>0)
                mp.put('Conventional', conventionalCount);
            
            for(string interest: mp.keyset()){
                Integer count = mp.get(interest);
                if(mapCountWiseInterest.containskey(count)){
                    mapCountWiseInterest.get(count).add(interest);
                } else {
                    mapCountWiseInterest.put(count, new List<string>{interest});
                }
            }
            
            interestList.addall(mapCountWiseInterest.keyset());
            interestList.sort();
            
            integer cntRes = 0;
            Map<String, Integer> resultInt = new Map<String, Integer>();
            for(Integer j = interestList.size()-1; j>=0;j--){
                if(cntRes < 3){
                    if(mapCountWiseInterest.get(interestList[j]).size() > 1){
                        for(integer i = 0 ; mapCountWiseInterest.get(interestList[j]).size() > i ; i++){
                            resultInt.put(mapCountWiseInterest.get(interestList[j])[i],interestList[j]);
                            cntRes++;
                        }
                    } else {
                        resultInt.put(mapCountWiseInterest.get(interestList[j])[0],interestList[j]);
                        cntRes++;
                    }
                } else {
                    break;
                }
            }
            
            for(Integer i = interestList.size()-1; i >= 0; i--){
                if(mapCountWiseInterest.containskey(interestList[i])){
                    List<string> lstInterest = mapCountWiseInterest.get(interestList[i]);
                    if(lstInterest.size() > 1){
                        boolean isFound = false;
                        for(string inte: lstInterest){
                            if(inte == selfaware.Interest_1_Selected_By_Student__c || inte == selfaware.Interest_2_Selected_By_Student__c ||
                               inte == selfaware.Interest_3_Selected_By_Student__c){
                                   highestInterest.add(inte);
                                   isFound = true;
                                   break;
                               }
                        }
                        if(!isFound){
                            highestInterest.add(lstInterest[0]);
                        }
                    } else if(lstInterest.size() > 0) {
                        highestInterest.add(lstInterest[0]);
                    }
                }
            }
            
            if(highestInterest.size() < 3){
                for(Integer key: mapCountWiseInterest.keyset()){
                    for(string inte: mapCountWiseInterest.get(key)){
                        if(!highestInterest.contains(inte)){
                            highestInterest.add(inte);
                        }
                    }
                }
            }
            //if(anyRealistInterestSeleced && anyInvestigativeInterestSeleced && anyArtisticInterestSeleced && 
              // anySocialInterestSeleced && anyEnterprisingInterestSeleced && anyConventionalInterestSeleced){
                   Integer cnt = 1;
                   Set<String> strLST = resultInt.keyset();
                   for(String str : resultInt.keyset()){    
                       if(cnt == 1){
                           selfaware.Interest_1__c= str;
                           cnt++;
                       } else if(cnt == 2){
                           selfaware.Interest_2__c= str;
                           cnt++;
                       } else if(cnt == 3){
                           selfaware.Interest_3__c= str;
                           cnt++;
                       }
                   }
               //}
            /*for(String str : highestInterest){    
                if(cnt == 1){
                    selfaware.Interest_1__c= str;
                    cnt++;
                } else if(cnt == 2){
                    selfaware.Interest_2__c= str;
                    cnt++;
                } else if(cnt == 3){
                    selfaware.Interest_3__c= str;
                    cnt++;
                }
            }*/
            system.debug('selfaware.Interest_1__c--'+selfaware.Interest_1__c+'--selfaware.Interest_2__c--'+selfaware.Interest_2__c+'--selfaware.Interest_3__c--'+selfaware.Interest_3__c);
            List<Question_Bank__c> correctAns = new List<Question_Bank__c>();
            List<String> ans = new List<String>();
            List<String> highestApti = new List<String>();
            
            Boolean anySpatialAbilitySeleced = False;
            if(String.isNotBlank(selfaware.Spatial_Ability_Q_1__c) || String.isNotBlank(selfaware.Spatial_Ability_Q_2__c) || 
               String.isNotBlank(selfaware.Spatial_Ability_Q_3__c) || String.isNotBlank(selfaware.Spatial_Ability_Q_4__c) || 
               String.isNotBlank(selfaware.Spatial_Ability_Q_5__c) || String.isNotBlank(selfaware.Spatial_Ability_Q_6__c) || 
               String.isNotBlank(selfaware.Spatial_Ability_Q_7__c) || String.isNotBlank(selfaware.Spatial_Ability_Q_8__c)){
                   anySpatialAbilitySeleced = true;
               }
            
            Map<String, Integer> aptitute = new Map<String, Integer>();
            correctAns = mapAllQBCategoryWise.containskey('Spatial') ? mapAllQBCategoryWise.get('Spatial') : new List<Question_Bank__c>();
            ans.add(selfaware.Spatial_Ability_Q_1__c);
            ans.add(selfaware.Spatial_Ability_Q_2__c);
            ans.add(selfaware.Spatial_Ability_Q_3__c);
            ans.add(selfaware.Spatial_Ability_Q_4__c);
            ans.add(selfaware.Spatial_Ability_Q_5__c);
            ans.add(selfaware.Spatial_Ability_Q_6__c);
            ans.add(selfaware.Spatial_Ability_Q_7__c);
            ans.add(selfaware.Spatial_Ability_Q_8__c);
            
            Integer count = 0;
            for (Integer j = 0; j < ans.size(); j++) {
                if (ans.get(j)!=null) {
                    if (correctAns.get(j).Category__c == ans.get(j)) {
                        count++; }
                }
            }
            if(count > 0)
                aptitute.put('Spatial', count);
            
            correctAns = new List<Question_Bank__c>();
            ans.clear();
            
            Boolean anyNumericalSeleced = False;
            if(String.isNotBlank(selfaware.Numerical_1__c) || String.isNotBlank(selfaware.Numerical_2__c) || 
               String.isNotBlank(selfaware.Numerical_3__c) || String.isNotBlank(selfaware.Numerical_4__c) || 
               String.isNotBlank(selfaware.Numerical_5__c) || String.isNotBlank(selfaware.Numerical_6__c) || 
               String.isNotBlank(selfaware.Numerical_7__c) || String.isNotBlank(selfaware.Numerical_8__c)){
                   anyNumericalSeleced = true;
               }
            correctAns = mapAllQBCategoryWise.containskey('Numerical') ? mapAllQBCategoryWise.get('Numerical') : new List<Question_Bank__c>();
            ans.add(selfaware.Numerical_1__c);
            ans.add(selfaware.Numerical_2__c);
            ans.add(selfaware.Numerical_3__c);
            ans.add(selfaware.Numerical_4__c);
            ans.add(selfaware.Numerical_5__c);
            ans.add(selfaware.Numerical_6__c);
            ans.add(selfaware.Numerical_7__c);
            ans.add(selfaware.Numerical_8__c);
            count = 0;
            
            for (Integer j = 0; j < ans.size(); j++) {
                if (ans.get(j)!=null){
                    if (correctAns.get(j).Category__c == ans.get(j)) {
                        count++;
                    }
                }
            }
            if(count > 0)
                aptitute.put('Numerical', count);
            
            correctAns = new List<Question_Bank__c>();
            ans.clear();
            
            Boolean anyAbstractSeleced = False;
            if(String.isNotBlank(selfaware.Abstract_Reasoning_Q_1__c) || String.isNotBlank(selfaware.Abstract_Reasoning_Q_2__c) || 
               String.isNotBlank(selfaware.Abstract_Reasoning_Q_3__c) || String.isNotBlank(selfaware.Abstract_Reasoning_Q_4__c) || 
               String.isNotBlank(selfaware.Abstract_Reasoning_Q_5__c) || String.isNotBlank(selfaware.Abstract_Reasoning_Q_6__c) || 
               String.isNotBlank(selfaware.Abstract_Reasoning_Q_7__c) || String.isNotBlank(selfaware.Abstract_Reasoning_Q_8__c)){
                   anyAbstractSeleced = true;
               }
            correctAns = mapAllQBCategoryWise.containskey('Abstract') ? mapAllQBCategoryWise.get('Abstract') : new List<Question_Bank__c>();
            ans.add(selfaware.Abstract_Reasoning_Q_1__c);
            ans.add(selfaware.Abstract_Reasoning_Q_2__c);
            ans.add(selfaware.Abstract_Reasoning_Q_3__c);
            ans.add(selfaware.Abstract_Reasoning_Q_4__c);
            ans.add(selfaware.Abstract_Reasoning_Q_5__c);
            ans.add(selfaware.Abstract_Reasoning_Q_6__c);
            ans.add(selfaware.Abstract_Reasoning_Q_7__c);
            ans.add(selfaware.Abstract_Reasoning_Q_8__c);
            count = 0;
            for (Integer j = 0; j < ans.size(); j++) {
                if (ans.get(j)!=null){
                    if (correctAns.get(j).Category__c == ans.get(j)) {
                        count++;
                    }
                }
            }
            if(count > 0)
                aptitute.put('Abstract', count);
            
            correctAns = new List<Question_Bank__c>();
            ans.clear();
            
            Boolean anyCreativeSeleced = False;
            if(String.isNotBlank(selfaware.Creative_1__c) || String.isNotBlank(selfaware.Creative_2__c) || 
               String.isNotBlank(selfaware.Creative_3__c) || String.isNotBlank(selfaware.Creative_4__c) || 
               String.isNotBlank(selfaware.Creative_5__c) || String.isNotBlank(selfaware.Creative_6__c) || 
               String.isNotBlank(selfaware.Creative_7__c) || String.isNotBlank(selfaware.Creative_8__c)){
                   anyCreativeSeleced = true;
               }
            correctAns = mapAllQBCategoryWise.containskey('Creative') ? mapAllQBCategoryWise.get('Creative') : new List<Question_Bank__c>();
            ans.add(selfaware.Creative_1__c);
            ans.add(selfaware.Creative_2__c);
            ans.add(selfaware.Creative_3__c);
            ans.add(selfaware.Creative_4__c);
            ans.add(selfaware.Creative_5__c);
            ans.add(selfaware.Creative_6__c);
            ans.add(selfaware.Creative_7__c);
            ans.add(selfaware.Creative_8__c);
            count = 0;
            for (Integer j = 0; j < ans.size(); j++) {
                if (ans.get(j)!=null){
                    //if (ans.get(j) == 'B' || ans.get(j) == 'C' || ans.get(j) == 'D') {
                    if(correctAns.get(j).Category__c.contains(ans.get(j))) {
                        count=count+1;
                    }
                }
            }
            if(count > 0)
                aptitute.put('Creative', count);
            
            correctAns = new List<Question_Bank__c>();
            ans.clear();
            
            Boolean anyMechanicalSeleced = False;
            if(String.isNotBlank(selfaware.Mechanical_1__c) || String.isNotBlank(selfaware.Mechanical_2__c) || 
               String.isNotBlank(selfaware.Mechanical_3__c) || String.isNotBlank(selfaware.Mechanical_4__c) || 
               String.isNotBlank(selfaware.Mechanical_5__c) || String.isNotBlank(selfaware.Mechanical_6__c) || 
               String.isNotBlank(selfaware.Mechanical_7__c) || String.isNotBlank(selfaware.Mechanical_8__c)){
                   anyMechanicalSeleced = true;
               }
            correctAns = mapAllQBCategoryWise.containskey('Mechanical') ? mapAllQBCategoryWise.get('Mechanical') : new List<Question_Bank__c>();
            ans.add(selfaware.Mechanical_1__c);
            ans.add(selfaware.Mechanical_2__c);
            ans.add(selfaware.Mechanical_3__c);
            ans.add(selfaware.Mechanical_4__c);
            ans.add(selfaware.Mechanical_5__c);
            ans.add(selfaware.Mechanical_6__c);
            ans.add(selfaware.Mechanical_7__c);
            ans.add(selfaware.Mechanical_8__c);
            count = 0;
            for (Integer j = 0; j < ans.size(); j++) {
                if (ans.get(j)!=null){
                    if (correctAns.get(j).Category__c == ans.get(j)) {
                        count++;
                    }
                }
            }
            if(count > 0)
                aptitute.put('Mechanical', count);
            
            correctAns = new List<Question_Bank__c>();
            ans.clear();
            
            Boolean anyVerbalSeleced = False;
            if(String.isNotBlank(selfaware.Verbal_1__c) || String.isNotBlank(selfaware.Verbal_2__c) || 
               String.isNotBlank(selfaware.Verbal_3__c) || String.isNotBlank(selfaware.Verbal_4__c) || 
               String.isNotBlank(selfaware.Verbal_5__c) || String.isNotBlank(selfaware.Verbal_6__c) || 
               String.isNotBlank(selfaware.Verbal_7__c) || String.isNotBlank(selfaware.Verbal_8__c)){
                   anyVerbalSeleced = true;
               }
            correctAns = mapAllQBCategoryWise.containskey('Verbal') ? mapAllQBCategoryWise.get('Verbal') : new List<Question_Bank__c>();
            ans.add(selfaware.Verbal_1__c);
            ans.add(selfaware.Verbal_2__c);
            ans.add(selfaware.Verbal_3__c);
            ans.add(selfaware.Verbal_4__c);
            ans.add(selfaware.Verbal_5__c);
            ans.add(selfaware.Verbal_6__c);
            ans.add(selfaware.Verbal_7__c);
            ans.add(selfaware.Verbal_8__c);
            count = 0;
            for (Integer j = 0; j < ans.size(); j++) {
                if (ans.get(j)!=null){
                    if (correctAns.get(j).Category__c == ans.get(j)) {
                        count++;
                    }
                }
            }
            if(count > 0)
                aptitute.put('Verbal', count);
            
            correctAns = new List<Question_Bank__c>();
            ans.clear();
            
            map<Integer, List<string>> mapCountWiseAptitude = new map<Integer, List<string>>();
            
            for(string apti: aptitute.keyset()){
                Integer countapti = aptitute.get(apti);
                if(mapCountWiseAptitude.containskey(countapti)){
                    mapCountWiseAptitude.get(countapti).add(apti);
                } else {
                    mapCountWiseAptitude.put(countapti, new List<string>{apti});
                }
            }
            List<Integer> aptitudeList = new List<Integer>();
            
            aptitudeList.addall(mapCountWiseAptitude.keyset());
            
            aptitudeList.sort();
            
            integer cntRes2 = 0;
            Map<String, Integer> resultInt2 = new Map<String, Integer>();
            for(Integer j = aptitudeList.size()-1; j>=0;j--){
                if(cntRes2 < 3){
                    if(mapCountWiseAptitude.get(aptitudeList[j]).size() > 1){
                        for(integer i = 0 ; mapCountWiseAptitude.get(aptitudeList[j]).size() > i ; i++){
                            resultInt2.put(mapCountWiseAptitude.get(aptitudeList[j])[i],aptitudeList[j]);
                            cntRes2++;
                        }
                    } else {
                        resultInt2.put(mapCountWiseAptitude.get(aptitudeList[j])[0],aptitudeList[j]);
                        cntRes2++;
                    }
                } else {
                    break;
                }
            }
            
            for(Integer i = aptitudeList.size()-1; i >= 0; i--){
                if(mapCountWiseAptitude.containskey(aptitudeList[i])){
                    List<string> lstAptitude = mapCountWiseAptitude.get(aptitudeList[i]);
                    if(lstAptitude.size() > 1){
                        boolean isFound = false;
                        for(string apti: lstAptitude){
                            if(apti == selfaware.Aptitude_1_Selected_By_Student__c || apti == selfaware.Aptitude_2_Selected_By_Student__c  ||
                               apti == selfaware.Aptitude_3_Selected_By_Student__c){
                                   highestApti.add(apti);
                                   isFound = true;
                                   break;
                               }
                        }
                        if(!isFound){
                            highestApti.add(lstAptitude[0]);
                        }
                    } else if(lstAptitude.size() > 0) {
                        highestApti.add(lstAptitude[0]);
                    }
                }
            }
            if(highestApti.size() < 3){
                for(Integer key: mapCountWiseAptitude.keyset()){
                    for(string apti: mapCountWiseAptitude.get(key)){
                        if(!highestApti.contains(apti)){
                            highestApti.add(apti);
                        }
                    }
                }
            }
            if(anySpatialAbilitySeleced && anyNumericalSeleced && anyAbstractSeleced && 
               anyCreativeSeleced && anyMechanicalSeleced && anyVerbalSeleced){
                   Integer cnt2 = 1;
                   for(String str : resultInt2.keyset()){
                       if(cnt2 == 1){
                           selfaware.Aptitude_1__c= str;
                           cnt2++;
                       } else if(cnt2 == 2){
                           selfaware.Aptitude_2__c= str;
                           cnt2++;
                       } else if(cnt2 == 3){
                           selfaware.Aptitude_3__c= str;
                           cnt2++;
                       }
                   }
               }
            /*for(String str : highestApti){    
                if(cnt2 == 1){
                    selfaware.Aptitude_1__c= str;
                    cnt2++;
                } else if(cnt2 == 2){
                    selfaware.Aptitude_2__c= str;
                    cnt2++;
                } else if(cnt2 == 3){
                    selfaware.Aptitude_3__c= str;
                    cnt2++;
                }
            }*/
            System.debug('selfaware.Aptitude_1__c-->'+selfaware.Aptitude_1__c+'--selfaware.Aptitude_2__c-->'+selfaware.Aptitude_2__c+'--selfaware.Aptitude_3__c-->'+selfaware.Aptitude_3__c);
        }
        
        update selfAwareLIST;
    }
    
    public void finish(Database.BatchableContext BC){
    }
    
}