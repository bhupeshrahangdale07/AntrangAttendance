/*
For calculating the student recommendation on the basis of IARP information data.
This class is included in the job which is run after IARP job.

Write whole new logic for IARP.

*/

global class IARPRecommendation implements Schedulable, Database.Batchable<sObject> {
    
    public string strQuery = '';
    public Date previous3DaysDate = system.today().addDays(-3);
    
    //schedule class
    global void execute(SchedulableContext SC){
        IARPRecommendation objIARPBatch = new IARPRecommendation();
        Database.executeBatch(objIARPBatch, 1);
    }
    
    public IARPRecommendation(){
        strQuery = 'select Name,Bar_Code__c,Batch_Code__c,Profession_1__c,Profession_2__c,Aptitude_1__c,Aptitude_2__c,Aptitude_3__c,Batch_Code__r.Date_of_facilitation_completion__c,';
        strQuery += 'Interest_1__c,Interest_2__c,Interest_3__c,Aspiration_1__c,Aspiration_2__c,Aspiration_3__c,Reality_1__c,Reality_2__c,Reality_3__c,';
        strQuery += 'Reality_4__C,Reality_5__C,Reality_6__C,Reality_7__C,Reality_8__c,Personality_1__c,Personality_2__c,Personality_3__c,';
        strQuery += 'Personality_4__c,Personality_5__c,Personality_6__c,Personality_7__c,Personality_8__c,Profession_1_Recommendation__c,';
        strQuery += 'Aspiration_1__r.Industry_links__c,Aspiration_2__r.Industry_links__c,Aspiration_3__r.Industry_links__c,';
        strQuery += 'Aspiration_1__r.Sector__c,Aspiration_2__r.Sector__c,Aspiration_3__r.Sector__c,';
        strQuery += 'Batch_Code__r.School_name__r.City__c,Batch_Code__r.School_name__r.City__r.Recommendation_Location__c,Batch_Code__r.Preferred_Language__c,';
        
        strQuery += 'G10_Batch_Code__c, G10_Batch_Code__r.School_name__c, G10_Batch_Code__r.School_name__r.City__c,G10_Batch_Code__r.School_name__r.City__r.Recommendation_Location__c,G10_Batch_Code__r.Preferred_Language__c, G10_Batch_Code__r.Date_of_facilitation_completion__c,';
        strQuery += 'G11_Batch_Code__c, G11_Batch_Code__r.School_name__c, G11_Batch_Code__r.School_name__r.City__c,G11_Batch_Code__r.School_name__r.City__r.Recommendation_Location__c,G11_Batch_Code__r.Preferred_Language__c, G11_Batch_Code__r.Date_of_facilitation_completion__c,';
        strQuery += 'G12_Batch_Code__c, G12_Batch_Code__r.School_name__c, G12_Batch_Code__r.School_name__r.City__c,G12_Batch_Code__r.School_name__r.City__r.Recommendation_Location__c,G12_Batch_Code__r.Preferred_Language__c, G12_Batch_Code__r.Date_of_facilitation_completion__c,';
        
        strQuery += 'Profession_2_Recommendation__c,Status__c, Attendance__c from Contact WHERE ';//Status__c=\'Processed\' AND '; //Remove Status Proceed condition as it wasn't picking all students 2020
        strQuery += ' Contact.RecordType.DeveloperName=\'CA_Student\' AND Recommedation_Status__c=\'Not Processed\' ';
        strQuery += ' AND (Status__c=\'Not Processed\' OR day_only(Batch_Code__r.Date_of_facilitation_completion__c) <=: previous3DaysDate OR day_only(G10_Batch_Code__r.Date_of_facilitation_completion__c) <=: previous3DaysDate OR day_only(G11_Batch_Code__r.Date_of_facilitation_completion__c) <=: previous3DaysDate OR day_only(G12_Batch_Code__r.Date_of_facilitation_completion__c) <=: previous3DaysDate) '; //added for this 2020 year, IARP should run 3 days after completion date
        strQuery += ' ORDER BY Bar_Code__c';
    }

    public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(strQuery);
    }

    public void execute(Database.BatchableContext BC, List<Contact> lstContact){
        system.debug(lstContact);
        calculateIARPRecomm(lstContact);
    }

    public void finish(Database.BatchableContext BC){
        
    }
    
    /*Calculating Recomm1 and Recomm2 for student */
    public void calculateIARPRecomm(List<Contact> conData){
        
        map<Id,IARP_Master__c> mapAllIARPMaster = new map<Id,IARP_Master__c>([select Id,Industry_links__c,Sector__c,Interest_1__c,Interest_2__c,Interest_3__c,
                            Personality_1__c,Personality_2__c,Personality_3__c,Personality_4__c,Personality_5__c,Personality_6__c,Personality_7__c,Personality_8__c,
                            Name,Aptitude_1__c,Aptitude_2__c,Aptitude_3__c,Reality_1__c,Reality_2__c,Reality_3__c,Reality_4__c,
                            Reality_5__c,Reality_6__c,Reality_7__c,Reality_8__c,Is_Active__c, Is_Risky_Profession__c 
                            from IARP_Master__c Where Is_Active__c = true order by Name]);
                            
        map<string, List<Recommendation__c>> mapRecommProfessionWise = new map<string, List<Recommendation__c>>();
        
        for(Recommendation__c recommendation: [select Recommendation__c,Profession__c,Next_Steps__c,Location__c,Next_Steps_Marathi__c,
            Next_Steps_Hindi__c,You_could_be_a__c,You_could_be_a_Hindi__c,You_could_be_a_Marathi__c,After_10th__c,After_10th_Hindi__c,After_10th_Marathi__c,After_12th__c,
            After_12th_Hindi__c,After_12th_Marathi__c,Additional_Info__c,Additional_Info_Hindi__c,Additional_Info_Marathi__c,
            Avg_Salary__c,Avg_Salary_Hindi__c,Avg_Salary_Marathi__c,Famous_Person__c,Famous_Person_Hindi__c,Famous_Person_Marathi__c,
            Fun_Fact__c,Fun_Fact_Hindi__c,Fun_Fact_Marathi__c from Recommendation__c]){
            if(mapRecommProfessionWise.containskey(recommendation.Profession__c)){
                mapRecommProfessionWise.get(recommendation.Profession__c).add(recommendation);
            } else {
                mapRecommProfessionWise.put(recommendation.Profession__c, new List<Recommendation__c>{recommendation});
            }
            system.debug(mapRecommProfessionWise);
        }
        
        //loop on all contacts
        for(Contact con: conData){
            List<IARP_Master__c> IARPMaster =new List<IARP_Master__c>();
            map<string, List<IARP_Master__c>> mapIARPIndustryWise = new map<string, List<IARP_Master__c>>();
            map<string, List<IARP_Master__c>> mapIARPClubbedIndustryWise = new map<string, List<IARP_Master__c>>();
            List<string>  lstAllRecommedation = new List<string>();
            system.debug(con);
            //first check for it has At least 2 I, 2 A and 8 R.
            if(isValidInterest(con) && isValidAptitude(con) && isValidReality(con)){
                system.debug(con.Profession_1__c);
                con.Profession_1__c = null;
                con.Profession_1_You_could_be_a__c = '';
                con.Profession_1_After_10th__c = '';
                con.Profession_1_After_12th__c = '';
                con.Profession_1_Additional_Info__c = '';
                con.Profession_1_Avg_Salary__c = '';
                con.Profession_1_Famous_Person__c = '';
                con.Profession_1_Fun_Fact__c = '';
                con.Profession_2__c = null;
                con.Profession_2_You_could_be_a__c = '';
                con.Profession_2_After_10th__c = '';
                con.Profession_2_After_12th__c = '';
                con.Profession_2_Additional_Info__c = '';
                con.Profession_2_Avg_Salary__c = '';
                con.Profession_2_Famous_Person__c = '';
                con.Profession_2_Fun_Fact__c = '';
                con.Recommendation_Path__c = '';
                con.Recommendation_Type__c = '';
                con.Recommendation_Report_Status__c = '';
                //con.All_Recommendation__c = '';
                //get all active IARP masters.
                for(IARP_Master__c objIARP: mapAllIARPMaster.values()){                
                    if(!objIARP.Is_Risky_Profession__c || (objIARP.Is_Risky_Profession__c && (objIARP.Id == con.Aspiration_1__c || objIARP.Id == con.Aspiration_2__c ||
                            objIARP.Id == con.Aspiration_3__c))){
                        IARPMaster.add(objIARP);
                         system.debug(objIARP);
                    }
                }
                List<string> lstAllRecommdenations = new List<string>();
                //match Interest, Aptitude, Reality
                List<IARP_Master__c> IARMatching = new List<IARP_Master__c>();
                //check if it matching I or A or R.
                for(IARP_Master__c objIARP: IARPMaster){
                    if ((con.Interest_1__c == objIARP.Interest_1__c || con.Interest_1__c == objIARP.Interest_2__c || con.Interest_1__c == objIARP.Interest_3__c || 
                         con.Interest_2__c == objIARP.Interest_1__c || con.Interest_2__c == objIARP.Interest_2__c || con.Interest_2__c == objIARP.Interest_3__c ||
                         con.Interest_3__c == objIARP.Interest_1__c || con.Interest_3__c == objIARP.Interest_2__c || con.Interest_3__c == objIARP.Interest_3__c) &&
                        (con.Aptitude_1__c == objIARP.Aptitude_1__c || con.Aptitude_1__c == objIARP.Aptitude_2__c || con.Aptitude_1__c == objIARP.Aptitude_3__c || 
                         con.Aptitude_2__c == objIARP.Aptitude_1__c || con.Aptitude_2__c == objIARP.Aptitude_2__c || con.Aptitude_2__c == objIARP.Aptitude_3__c ||
                         con.Aptitude_3__c == objIARP.Aptitude_1__c || con.Aptitude_3__c == objIARP.Aptitude_2__c || con.Aptitude_3__c == objIARP.Aptitude_3__c) &&
                        ((objIARP.Reality_1__c == 'Any' || objIARP.Reality_1__c == con.Reality_1__c) && 
                         (objIARP.Reality_2__c == 'Any' || objIARP.Reality_2__c == con.Reality_2__c) &&
                         (objIARP.Reality_3__c == 'Any' || objIARP.Reality_3__c == con.Reality_3__c) &&
                         (objIARP.Reality_4__c == 'Any' || isMatchReality(con.Reality_4__c, objIARP.Reality_4__c)) &&
                         (objIARP.Reality_5__c == 'Any' || objIARP.Reality_5__c == con.Reality_5__c) &&
                         (objIARP.Reality_6__c == 'Any' || objIARP.Reality_6__c == con.Reality_6__c) &&
                         (objIARP.Reality_7__c == 'Any' || objIARP.Reality_7__c == con.Reality_7__c) &&
                         (objIARP.Reality_8__c == 'Any' || isMatchReality(con.Reality_8__c, objIARP.Reality_8__c)))
                         ) {
                        IARMatching.add(objIARP);
                        lstAllRecommdenations.add(objIARP.Name);
                        system.debug(IARMatching.size());
                        system.debug(con.Profession_1__c);
                         system.debug(lstAllRecommdenations);
                        //fill map industrywise map
                        if(mapIARPIndustryWise.containskey(objIARP.Industry_links__c)){
                            mapIARPIndustryWise.get(objIARP.Industry_links__c).add(objIARP);
                        } else {
                            mapIARPIndustryWise.put(objIARP.Industry_links__c, new List<IARP_Master__c>{objIARP});
                        }
                        //fill map clubbedindustry wise map
                        if(mapIARPClubbedIndustryWise.containskey(objIARP.Sector__c)){
                            mapIARPClubbedIndustryWise.get(objIARP.Sector__c).add(objIARP);
                        } else {
                            mapIARPClubbedIndustryWise.put(objIARP.Sector__c, new List<IARP_Master__c>{objIARP});
                        }
                    }
                }
                //if student have fillout IAR 
                if(con.Status__c == 'Not Processed' || 
                   (con.G12_Batch_Code__c != null && con.G12_Batch_Code__r.Date_of_facilitation_completion__c > previous3DaysDate) || 
                   (con.G12_Batch_Code__c == null && con.G11_Batch_Code__c != null && con.G11_Batch_Code__r.Date_of_facilitation_completion__c > previous3DaysDate) ||
                   (con.G12_Batch_Code__c == null && con.G11_Batch_Code__c == null && con.G10_Batch_Code__c != null && con.G10_Batch_Code__r.Date_of_facilitation_completion__c > previous3DaysDate) ||
                   (con.G12_Batch_Code__c == null && con.G11_Batch_Code__c == null && con.G10_Batch_Code__c == null && con.Batch_Code__r != null && con.Batch_Code__r.Date_of_facilitation_completion__c > previous3DaysDate)){
                    
                    if(lstAllRecommdenations.size() > 0){
                        con.All_Recommendation__c = string.join(lstAllRecommdenations, ', ');
                        system.debug(con.Profession_1__c);
                    }
                    con.Status__c = 'Processed';
                    
                    if(con.G12_Batch_Code__c != null && con.G12_Batch_Code__r.Date_of_facilitation_completion__c > previous3DaysDate){
                        continue;
                    }else if(con.G12_Batch_Code__c == null && con.G11_Batch_Code__c != null && con.G11_Batch_Code__r.Date_of_facilitation_completion__c > previous3DaysDate){
                        continue;
                    }else if(con.G12_Batch_Code__c == null && con.G11_Batch_Code__c == null && con.G10_Batch_Code__c != null && con.G10_Batch_Code__r.Date_of_facilitation_completion__c > previous3DaysDate){
                        continue;
                    }else if(con.G12_Batch_Code__c == null && con.G11_Batch_Code__c == null && con.G10_Batch_Code__c == null && con.Batch_Code__r != null && con.Batch_Code__r.Date_of_facilitation_completion__c > previous3DaysDate){
                        continue;
                    }
                    
                    /* Commented Below code to work with all grades
                    if(con.Batch_Code__r.Date_of_facilitation_completion__c > previous3DaysDate){
                    system.debug('@@@@@@@'+con.Profession_1__c);
                        continue;
                    }
                    system.debug(IARMatching.size());
					*/
                }
                system.debug(IARMatching.size());
                //check how many matches
                if(IARMatching.size() >= 2) {
                system.debug(con.Profession_1__c);
                    //if IAR Matching count is 2
                    if(IARMatching.size() == 2){
                        con.Profession_1__c = IARMatching[0].Id;
                        con.Profession_2__c = IARMatching[1].Id;
                        con.Recommendation_Path__c = 'I + A + R';
                        con.Recommendation_Type__c = 'Exact Match';
                        con.Recommendation_Report_Status__c = 'Report processed';
                    }
                    //if IAR matching count is > 2 
                    else {
                    system.debug(con.Profession_1__c);
                        //check for Aspirtaion 1, 2, 3
                        Integer countAspirationMatch = 0;
                        if(con.Aspiration_1__c != null || con.Aspiration_2__c != null || con.Aspiration_3__c != null) {
                            for(IARP_Master__c objIARP: IARMatching){
                                //if it matches then populate recommdendation 1 and 2
                                if(objIARP.Id == con.Aspiration_1__c || objIARP.Id == con.Aspiration_2__c || objIARP.Id == con.Aspiration_3__c) {
                                    boolean isUpdate = false;
                                    if(con.Profession_1__c == null) {
                                       con.Profession_1__c = objIARP.Id;
                                       countAspirationMatch++;
                                       isUpdate = true; 
                                    } else if(con.Profession_2__c == null) {
                                       con.Profession_2__c = objIARP.Id;
                                       countAspirationMatch++;
                                       isUpdate = true; 
                                    }
                                    if(isUpdate){
                                        con.Recommendation_Path__c = 'I + A + R + Aspiration';
                                        con.Recommendation_Type__c = 'Exact Match';
                                        con.Recommendation_Report_Status__c = 'Report processed';
                                    }
                                    //if both populate then break loop.
                                    if(con.Profession_1__c != null && con.Profession_2__c != null) break;
                                }   
                            }
                            
                            //check count of aspiration matches
                            //check if matches to only 1
                            //if(countAspirationMatch < 2){
                                
                            //}
                            //check if no matches aspiration
                            //else 
                            if(countAspirationMatch < 2) {
                                //check for EA 1 Industry
                                if(con.Aspiration_1__c != null && con.Aspiration_1__r.Industry_links__c != null) {
                                    if(mapIARPIndustryWise.containskey(con.Aspiration_1__r.Industry_links__c)){
                                        //IARP list for EA 1 Industry
                                        List<IARP_Master__c> IAREA1Industry = getIARPWOMAspiration(mapIARPIndustryWise.get(con.Aspiration_1__r.Industry_links__c), con);
                                        
                                        if(IAREA1Industry.size() == 2) {
                                            boolean isUpdate = false;
                                            if(con.Profession_1__c == null) {
                                                con.Profession_1__c = IAREA1Industry[0].Id;
                                                isUpdate = true;
                                            }
                                            if(con.Profession_2__c == null) {
                                                con.Profession_2__c = IAREA1Industry[1].Id;
                                                isUpdate = true;
                                            }
                                            if(isUpdate) {
                                                con.Recommendation_Path__c = 'I + A + R + EA1Industry Exact';
                                                con.Recommendation_Type__c = 'Exact Match';
                                                con.Recommendation_Report_Status__c = 'Report processed';
                                            }
                                        } else if(IAREA1Industry.size() > 0){
                                            boolean isUpdate = false;
                                            if(con.Profession_1__c == null) {
                                                con.Profession_1__c = getRandomIARPfromList(IAREA1Industry);
                                                isUpdate = true;
                                            } else if(con.Profession_2__c == null) {
                                                Id p2 = getRandomIARPfromList(IAREA1Industry);
                                                if(p2 != con.Profession_1__c) {
                                                    con.Profession_2__c = p2;
                                                    isUpdate = true;
                                                }
                                            }
                                            if(isUpdate){
                                                con.Recommendation_Path__c = 'I + A + R + EA1Industry Random';
                                                con.Recommendation_Type__c = 'Random Match';
                                                con.Recommendation_Report_Status__c = 'Report processed';
                                            }
                                        }
                                    }
                                }
                                //check for EA 2 Industry
                                if(con.Aspiration_2__c != null && con.Aspiration_2__r.Industry_links__c != null && (con.Profession_1__c == null || con.Profession_2__c == null)) {
                                    if(mapIARPIndustryWise.containskey(con.Aspiration_2__r.Industry_links__c)){
                                        //IARP list for EA 2 Industry
                                        List<IARP_Master__c> IAREA2Industry = getIARPWOMAspiration(mapIARPIndustryWise.get(con.Aspiration_2__r.Industry_links__c),con);
                                        
                                        if(IAREA2Industry.size() == 2) {
                                            boolean isUpdate = false;
                                            if(con.Profession_1__c == null) {
                                                con.Profession_1__c = IAREA2Industry[0].Id;
                                                isUpdate = true;
                                            }
                                            if(con.Profession_2__c == null) {
                                                con.Profession_2__c = IAREA2Industry[1].Id;
                                                isUpdate = true;
                                            }
                                            if(isUpdate) {
                                                con.Recommendation_Path__c = 'I + A + R + EA2Industry Exact';
                                                con.Recommendation_Type__c = 'Exact Match';
                                                con.Recommendation_Report_Status__c = 'Report processed';
                                            }
                                        } else if(IAREA2Industry.size() > 0){
                                            boolean isUpdate = false;
                                            if(con.Profession_1__c == null) {
                                                con.Profession_1__c = getRandomIARPfromList(IAREA2Industry);
                                                isUpdate = true;
                                            } else if(con.Profession_2__c == null) {
                                                Id p2 = getRandomIARPfromList(IAREA2Industry);
                                                if(p2 != con.Profession_1__c) {
                                                    con.Profession_2__c = p2;
                                                    isUpdate = true;
                                                }
                                            }
                                            if(isUpdate){
                                                con.Recommendation_Path__c = 'I + A + R + EA2Industry Random';
                                                con.Recommendation_Type__c = 'Random Match';
                                                con.Recommendation_Report_Status__c = 'Report processed';
                                            }
                                        }
                                    }
                                }
                                //check for EA 3 Industry
                                if(con.Aspiration_3__c != null && con.Aspiration_3__r.Industry_links__c != null && (con.Profession_1__c == null || con.Profession_2__c == null)) {
                                    if(mapIARPIndustryWise.containskey(con.Aspiration_3__r.Industry_links__c)){
                                        //IARP list for EA 3 Industry
                                        List<IARP_Master__c> IAREA3Industry = getIARPWOMAspiration(mapIARPIndustryWise.get(con.Aspiration_3__r.Industry_links__c),con);
                                        
                                        if(IAREA3Industry.size() == 2) {
                                            boolean isUpdate = false;
                                            if(con.Profession_1__c == null) {
                                                con.Profession_1__c = IAREA3Industry[0].Id;
                                                isUpdate = true;
                                            }
                                            if(con.Profession_2__c == null) {
                                                con.Profession_2__c = IAREA3Industry[1].Id;
                                                isUpdate = true;
                                            }
                                            if(isUpdate) {
                                                con.Recommendation_Path__c = 'I + A + R + EA3Industry Exact';
                                                con.Recommendation_Type__c = 'Exact Match';
                                                con.Recommendation_Report_Status__c = 'Report processed';
                                            }
                                        } else if(IAREA3Industry.size() > 0){
                                            boolean isUpdate = false;
                                            if(con.Profession_1__c == null) {
                                                con.Profession_1__c = getRandomIARPfromList(IAREA3Industry);
                                                isUpdate = true;
                                            } else if(con.Profession_2__c == null) {
                                                Id p2 = getRandomIARPfromList(IAREA3Industry);
                                                if(p2 != con.Profession_1__c) {
                                                    con.Profession_2__c = p2;
                                                    isUpdate = true;
                                                }
                                            }
                                            if(isUpdate){
                                                con.Recommendation_Path__c = 'I + A + R + EA3Industry Random';
                                                con.Recommendation_Type__c = 'Random Match';
                                                con.Recommendation_Report_Status__c = 'Report processed';
                                            }
                                        }
                                    }
                                }
                                //check for EA 1 Clubbed Industry
                                if(con.Aspiration_1__c != null && con.Aspiration_1__r.Sector__c != null && (con.Profession_1__c == null || con.Profession_2__c == null)) {
                                    if(mapIARPClubbedIndustryWise.containskey(con.Aspiration_1__r.Sector__c)){
                                        //IARP list for EA 1 Clubbed Industry
                                        List<IARP_Master__c> IAREA1ClubbedIndustry = getIARPWOMAspiration(mapIARPClubbedIndustryWise.get(con.Aspiration_1__r.Sector__c),con);
                                        
                                        if(IAREA1ClubbedIndustry.size() == 2) {
                                            boolean isUpdate = false;
                                            if(con.Profession_1__c == null) {
                                                con.Profession_1__c = IAREA1ClubbedIndustry[0].Id;
                                                isUpdate = true;
                                            }
                                            if(con.Profession_2__c == null) {
                                                con.Profession_2__c = IAREA1ClubbedIndustry[1].Id;
                                                isUpdate = true;
                                            }
                                            if(isUpdate) {
                                                con.Recommendation_Path__c = 'I + A + R + EA1ClubbedIndustry Exact';
                                                con.Recommendation_Type__c = 'Exact Match';
                                                con.Recommendation_Report_Status__c = 'Report processed';
                                            }
                                        } else if(IAREA1ClubbedIndustry.size() > 0){
                                            boolean isUpdate = false;
                                            if(con.Profession_1__c == null) {
                                                con.Profession_1__c = getRandomIARPfromList(IAREA1ClubbedIndustry);
                                                isUpdate = true;
                                            } else if(con.Profession_2__c == null) {
                                                Id p2 = getRandomIARPfromList(IAREA1ClubbedIndustry);
                                                if(p2 != con.Profession_1__c) {
                                                    con.Profession_2__c = p2;
                                                    isUpdate = true;
                                                }
                                            }
                                            if(isUpdate){
                                                con.Recommendation_Path__c = 'I + A + R + EA1ClubbedIndustry Random';
                                                con.Recommendation_Type__c = 'Random Match';
                                                con.Recommendation_Report_Status__c = 'Report processed';
                                            }
                                        }
                                    }
                                }
                                //check for EA 2 Clubbed Industry
                                if(con.Aspiration_2__c != null && con.Aspiration_2__r.Sector__c != null && (con.Profession_1__c == null || con.Profession_2__c == null)) {
                                    if(mapIARPClubbedIndustryWise.containskey(con.Aspiration_2__r.Sector__c)){
                                        //IARP list for EA 2 Clubbed Industry
                                        List<IARP_Master__c> IAREA2ClubbedIndustry = getIARPWOMAspiration(mapIARPClubbedIndustryWise.get(con.Aspiration_2__r.Sector__c), con);
                                        
                                        if(IAREA2ClubbedIndustry.size() == 2) {
                                            boolean isUpdate = false;
                                            if(con.Profession_1__c == null) {
                                                con.Profession_1__c = IAREA2ClubbedIndustry[0].Id;
                                                isUpdate = true;
                                            }
                                            if(con.Profession_2__c == null) {
                                                con.Profession_2__c = IAREA2ClubbedIndustry[1].Id;
                                                isUpdate = true;
                                            }
                                            if(isUpdate) {
                                                con.Recommendation_Path__c = 'I + A + R + EA2ClubbedIndustry Exact';
                                                con.Recommendation_Type__c = 'Exact Match';
                                                con.Recommendation_Report_Status__c = 'Report processed';
                                            }
                                        } else if(IAREA2ClubbedIndustry.size() > 0){
                                            boolean isUpdate = false;
                                            if(con.Profession_1__c == null) {
                                                con.Profession_1__c = getRandomIARPfromList(IAREA2ClubbedIndustry);
                                                isUpdate = true;
                                            } else if(con.Profession_2__c == null) {
                                                Id p2 = getRandomIARPfromList(IAREA2ClubbedIndustry);
                                                if(p2 != con.Profession_1__c) {
                                                    con.Profession_2__c = p2;
                                                    isUpdate = true;
                                                }
                                            }
                                            if(isUpdate){
                                                con.Recommendation_Path__c = 'I + A + R + EA2ClubbedIndustry Random';
                                                con.Recommendation_Type__c = 'Random Match';
                                                con.Recommendation_Report_Status__c = 'Report processed';
                                            }
                                        }
                                    }
                                }
                                //check for EA 3 Clubbed Industry
                                if(con.Aspiration_3__c != null && con.Aspiration_3__r.Sector__c != null && (con.Profession_1__c == null || con.Profession_2__c == null)) {
                                    if(mapIARPClubbedIndustryWise.containskey(con.Aspiration_3__r.Sector__c)){
                                        //IARP list for EA 3 Clubbed Industry
                                        List<IARP_Master__c> IAREA3ClubbedIndustry = getIARPWOMAspiration(mapIARPClubbedIndustryWise.get(con.Aspiration_3__r.Sector__c), con);
                                        
                                        if(IAREA3ClubbedIndustry.size() == 2) {
                                            boolean isUpdate = false;
                                            if(con.Profession_1__c == null) {
                                                con.Profession_1__c = IAREA3ClubbedIndustry[0].Id;
                                                isUpdate = true;
                                            }
                                            if(con.Profession_2__c == null) {
                                                con.Profession_2__c = IAREA3ClubbedIndustry[1].Id;
                                                isUpdate = true;
                                            }
                                            if(isUpdate) {
                                                con.Recommendation_Path__c = 'I + A + R + EA3ClubbedIndustry Exact';
                                                con.Recommendation_Type__c = 'Exact Match';
                                                con.Recommendation_Report_Status__c = 'Report processed';
                                            }
                                        } else if(IAREA3ClubbedIndustry.size() > 0){
                                            boolean isUpdate = false;
                                            if(con.Profession_1__c == null) {
                                                con.Profession_1__c = getRandomIARPfromList(IAREA3ClubbedIndustry);
                                                isUpdate = true;
                                            } else if(con.Profession_2__c == null) {
                                                Id p2 = getRandomIARPfromList(IAREA3ClubbedIndustry);
                                                if(p2 != con.Profession_1__c) {
                                                    con.Profession_2__c = p2;
                                                    isUpdate = true;
                                                }
                                            }
                                            if(isUpdate){
                                                con.Recommendation_Path__c = 'I + A + R + EA3ClubbedIndustry Random';
                                                con.Recommendation_Type__c = 'Random Match';
                                                con.Recommendation_Report_Status__c = 'Report processed';
                                            }
                                        }
                                    }
                                }
                                
                                //if profession 1 and 2 is null, then check for personality
                                con = getPersonalityMatch(con, IARMatching);
                                system.debug('test');
                            }
                        }
                        //when Aspiration is not present check for personality 
                        else {
                            //check based on personality
                            con = getPersonalityMatch(con, IARMatching);
                            system.debug('test');
                        }
                    }
                }
                //not able to generate report
                else {
                    con.Recommendation_Report_Status__c = 'Insufficient matches';
                }
                
                string Location = '';
                string preferredLanguage = '';
                
                if(con.G12_Batch_Code__c != null && con.G12_Batch_Code__r.School_name__c != null && con.G12_Batch_Code__r.School_name__r.City__c != null){
                    Location = con.G12_Batch_Code__r.School_name__r.City__r.Recommendation_Location__c;
                    preferredLanguage = con.G12_Batch_Code__r.Preferred_Language__c;
                    
                }else if(con.G11_Batch_Code__c != null && con.G11_Batch_Code__r.School_name__c != null && con.G11_Batch_Code__r.School_name__r.City__c != null){
                    Location = con.G11_Batch_Code__r.School_name__r.City__r.Recommendation_Location__c;
                    preferredLanguage = con.G11_Batch_Code__r.Preferred_Language__c;
                    
                }else if(con.G10_Batch_Code__c != null && con.G10_Batch_Code__r.School_name__c != null && con.G10_Batch_Code__r.School_name__r.City__c != null){
                    Location = con.G10_Batch_Code__r.School_name__r.City__r.Recommendation_Location__c;
                    preferredLanguage = con.G10_Batch_Code__r.Preferred_Language__c;
                    
                }else if(con.Batch_Code__c != null && con.Batch_Code__r.School_name__c != null && con.Batch_Code__r.School_name__r.City__c != null) {
                    Location = con.Batch_Code__r.School_name__r.City__r.Recommendation_Location__c;
                    preferredLanguage = con.Batch_Code__r.Preferred_Language__c;
                }
                
                /* commented below code to pick language from latest Batch
                if(con.Batch_Code__c != null) {
                    preferredLanguage = con.Batch_Code__r.Preferred_Language__c;
                }
				*/
                
                //populate other 10th and 12th information for Profession 1
                if(con.Profession_1__c != null && mapAllIARPMaster.containskey(con.Profession_1__c)){
                system.debug(con.Profession_1__c);
                    IARP_Master__c ProfName1 = mapAllIARPMaster.get(con.Profession_1__c);
                    if(mapRecommProfessionWise.containskey(ProfName1.Name)){
                        for(Recommendation__c recommendation: mapRecommProfessionWise.get(ProfName1.Name)){
                            if (recommendation.Location__c == Location && ProfName1.Name == recommendation.Profession__c && preferredLanguage=='Hindi'){
                                con.Profession_1_Recommendation__c = recommendation.Profession__c;
                                con.Profession_1_You_could_be_a__c = recommendation.You_could_be_a_Hindi__c;
                                con.Profession_1_After_10th__c = recommendation.After_10th_Hindi__c;
                                con.Profession_1_After_12th__c = recommendation.After_12th_Hindi__c;
                                con.Profession_1_Additional_Info__c = recommendation.Additional_Info_Hindi__c;
                                con.Profession_1_Avg_Salary__c = recommendation.Avg_Salary_Hindi__c;
                                con.Profession_1_Famous_Person__c = recommendation.Famous_Person_Hindi__c;
                                con.Profession_1_Fun_Fact__c = recommendation.Fun_Fact_Hindi__c;
                                break;
                            } else if(recommendation.Location__c == Location && ProfName1.Name == recommendation.Profession__c && preferredLanguage=='Marathi'){
                                con.Profession_1_Recommendation__c = recommendation.Profession__c;
                                con.Profession_1_You_could_be_a__c = recommendation.You_could_be_a_Marathi__c;
                                con.Profession_1_After_10th__c = recommendation.After_10th_Marathi__c;
                                con.Profession_1_After_12th__c = recommendation.After_12th_Marathi__c;
                                con.Profession_1_Additional_Info__c = recommendation.Additional_Info_Marathi__c;
                                con.Profession_1_Avg_Salary__c = recommendation.Avg_Salary_Marathi__c;
                                con.Profession_1_Famous_Person__c = recommendation.Famous_Person_Marathi__c;
                                con.Profession_1_Fun_Fact__c = recommendation.Fun_Fact_Marathi__c;
                                break;
                            } else if(recommendation.Location__c == Location && ProfName1.Name == recommendation.Profession__c) {
                                con.Profession_1_Recommendation__c = recommendation.Profession__c;
                                con.Profession_1_You_could_be_a__c = recommendation.You_could_be_a__c;
                                con.Profession_1_After_10th__c = recommendation.After_10th__c;
                                con.Profession_1_After_12th__c = recommendation.After_12th__c;
                                con.Profession_1_Additional_Info__c = recommendation.Additional_Info__c;
                                con.Profession_1_Avg_Salary__c = recommendation.Avg_Salary__c;
                                con.Profession_1_Famous_Person__c = recommendation.Famous_Person__c;
                                con.Profession_1_Fun_Fact__c = recommendation.Fun_Fact__c;
                                break;
                            }
                        }
                    }
                }
                //populate other 10th and 12th information for Profession 2
                if(con.Profession_2__c != null && mapAllIARPMaster.containskey(con.Profession_2__c)){
                    IARP_Master__c ProfName2 = mapAllIARPMaster.get(con.Profession_2__c);
                    if(mapRecommProfessionWise.containskey(ProfName2.Name)){
                        for(Recommendation__c recommendation: mapRecommProfessionWise.get(ProfName2.Name)){
                            if (recommendation.Location__c == Location && ProfName2.Name == recommendation.Profession__c && preferredLanguage=='Hindi'){
                                con.Profession_2_Recommendation__c = recommendation.Profession__c;
                                con.Profession_2_You_could_be_a__c = recommendation.You_could_be_a_Hindi__c;
                                con.Profession_2_After_10th__c = recommendation.After_10th_Hindi__c;
                                con.Profession_2_After_12th__c = recommendation.After_12th_Hindi__c;
                                con.Profession_2_Additional_Info__c = recommendation.Additional_Info_Hindi__c;
                                con.Profession_2_Avg_Salary__c = recommendation.Avg_Salary_Hindi__c;
                                con.Profession_2_Famous_Person__c = recommendation.Famous_Person_Hindi__c;
                                con.Profession_2_Fun_Fact__c = recommendation.Fun_Fact_Hindi__c;
                                break;
                            } else if(recommendation.Location__c == Location && ProfName2.Name == recommendation.Profession__c && preferredLanguage=='Marathi'){
                                con.Profession_2_Recommendation__c = recommendation.Profession__c;
                                con.Profession_2_You_could_be_a__c = recommendation.You_could_be_a_Marathi__c;
                                con.Profession_2_After_10th__c = recommendation.After_10th_Marathi__c;
                                con.Profession_2_After_12th__c = recommendation.After_12th_Marathi__c;
                                con.Profession_2_Additional_Info__c = recommendation.Additional_Info_Marathi__c;
                                con.Profession_2_Avg_Salary__c = recommendation.Avg_Salary_Marathi__c;
                                con.Profession_2_Famous_Person__c = recommendation.Famous_Person_Marathi__c;
                                con.Profession_2_Fun_Fact__c = recommendation.Fun_Fact_Marathi__c;
                                break;
                            } else if(recommendation.Location__c == Location && ProfName2.Name == recommendation.Profession__c) {
                                con.Profession_2_Recommendation__c = recommendation.Profession__c;
                                con.Profession_2_You_could_be_a__c = recommendation.You_could_be_a__c;
                                con.Profession_2_After_10th__c = recommendation.After_10th__c;
                                con.Profession_2_After_12th__c = recommendation.After_12th__c;
                                con.Profession_2_Additional_Info__c = recommendation.Additional_Info__c;
                                con.Profession_2_Avg_Salary__c = recommendation.Avg_Salary__c;
                                con.Profession_2_Famous_Person__c = recommendation.Famous_Person__c;
                                con.Profession_2_Fun_Fact__c = recommendation.Fun_Fact__c;
                                break;
                            }
                        }
                    }
                }
                //set recommdentation status
                if(con.Profession_1__c == null && con.Profession_2__c == null) con.Recommendation_Type__c = 'No Match';
                con.Recommedation_Status__c='Processed';
            }
            //not has 2 I  2 A or 8 R. 
            else {
                con.Recommendation_Report_Status__c = 'Incomplete profile';
                con.Recommedation_Status__c='Processed';
            }
        }
        //update contacts
        system.debug(conData);
        update conData;
    }
    
    //get personality match
    public Contact getPersonalityMatch(Contact con, List<IARP_Master__c> IARMatching){
        //match with Personality
        List<IARP_Master__c> PersonalityMatch = new List<IARP_Master__c>();
        for(IARP_Master__c objIARP: IARMatching){
            if(objIARP.Personality_1__c == 'Any' || objIARP.Personality_2__c == 'Any' || objIARP.Personality_3__c == 'Any' ||
                objIARP.Personality_4__c == 'Any' || objIARP.Personality_1__c == con.Personality_1__c ||
                objIARP.Personality_2__c == con.Personality_2__c || objIARP.Personality_3__c == con.Personality_3__c ||
                objIARP.Personality_4__c == con.Personality_4__c){
                PersonalityMatch.add(objIARP);
            }
        }
        //check count of personality match
        if(PersonalityMatch.size() >= 2){
            //if size is 2 then exact match with Personality
            if(PersonalityMatch.size() == 2){
                con.Profession_1__c = IARMatching[0].Id;
                con.Profession_2__c = IARMatching[1].Id;
                con.Recommendation_Path__c = 'I + A + R + Personality';
                con.Recommendation_Type__c = 'Exact Match';
                con.Recommendation_Report_Status__c = 'Report processed';
            }
            //if size is > 2 then random match with Personality 
            else if(PersonalityMatch.size() > 2){
                boolean isUpdate = false;
                if(con.Profession_1__c == null) {
                    con.Profession_1__c = getRandomIARPfromList(PersonalityMatch);
                    isUpdate = true; 
                } 
                if(con.Profession_2__c == null) {
                    Id p2 = getRandomIARPfromList(PersonalityMatch);
                    if(p2 != con.Profession_1__c) {
                        con.Profession_2__c = p2;
                        isUpdate = true;
                    }
                }
                if(isUpdate){
                    con.Recommendation_Path__c = 'I + A + R + Personality';
                    con.Recommendation_Type__c = 'Random Match';
                    con.Recommendation_Report_Status__c = 'Report processed';
                }
                
            }
        }
        //no match on personality so random match from IAR 
        else {
            boolean isUpdate = false;
            if(con.Profession_1__c == null) {
                con.Profession_1__c = getRandomIARPfromList(IARMatching);
                isUpdate = true; 
            } 
            if(con.Profession_2__c == null) {
                Id p2 = getRandomIARPfromList(IARMatching);
                if(p2 != con.Profession_1__c) {
                    con.Profession_2__c = p2;
                    isUpdate = true;
                }
            }
            if(isUpdate){
                con.Recommendation_Path__c = 'I + A + R + Random/Personality';
                con.Recommendation_Type__c = 'Random Match';
                con.Recommendation_Report_Status__c = 'Report processed';
            }  
        }
        return con;
    }
     
    //remove aspiration that matches to Industry Links
    public List<IARP_Master__c> getIARPWOMAspiration(List<IARP_Master__c> lstAllIARP, Contact con){
        List<IARP_Master__c> lstIARP = new List<IARP_Master__c>();
        set<Id> setOfAspirationIDs = new set<Id>();
        if(con.Aspiration_1__c != null) setOfAspirationIDs.add(con.Aspiration_1__c);
        if(con.Aspiration_2__c != null) setOfAspirationIDs.add(con.Aspiration_2__c);
        if(con.Aspiration_3__c != null) setOfAspirationIDs.add(con.Aspiration_3__c);
        for(IARP_Master__c iarp: lstAllIARP){
            if(!setOfAspirationIDs.contains(iarp.Id)){
                lstIARP.add(iarp);
            }
        }
        return lstIARP;
    }
     
    //check reality 4 and 8 is matching
    public static boolean isMatchReality(string conReality, string iarpReality){
        string[] arrIARPReality = iarpReality.split('');
        for(string str: arrIARPReality){
            if(str == conReality){
                return true;
            }
        }
        return false;
    }
    
    //get random IARP Id from list
    public Id getRandomIARPfromList(List<IARP_Master__c> lstIARP){
        Id idIARP = null;
        for (IARP_Master__c iarp : lstIARP){
            /* Srikanth kandisa Team
            *Commented below code as this is returns only two posible values that is 0 or last index of array

            Double randomNumber = Math.round(Math.random());
            Integer arraySize = lstIARP.size();
            Integer randomIndex = (randomNumber *(arraySize-1)).intValue();
            idIARP = lstIARP.get(randomIndex).Id;
            */
           
            // Srikanth kandisa Team
            // added below three lines to pick random element from array
            Integer arraySize = lstIARP.size()-1;
            Integer randomIndex = Math.round(Math.random()*arraySize);
            idIARP = lstIARP.get(randomIndex).Id;
            break;
        }
        
        
        return idIARP;
    }
    
    public boolean isValidInterest(Contact con){
        set<string> setOfInterest = new set<string>{'Interest_1__c','Interest_2__c','Interest_3__c'};
        Integer count = 0;
        for(string str: setOfInterest){
            if(con.get(str) != null){
                count++;
            }
        }
        system.debug(count); 
        return count > 1;
    }
    
    public boolean isValidAptitude(Contact con){
        set<string> setOfAptitude = new set<string>{'Aptitude_1__c','Aptitude_2__c','Aptitude_3__c'};
        Integer count = 0;
        for(string str: setOfAptitude){
            if(con.get(str) != null){
                count++;
            }
        }
        system.debug(count);
        return count > 1;
    }
    
    public boolean isValidReality(Contact con){
        set<string> setOfReality = new set<string>{'Reality_1__c','Reality_2__c','Reality_3__c','Reality_4__c','Reality_5__c','Reality_6__c','Reality_7__c','Reality_8__c'};
        Integer count = 0;
        for(string str: setOfReality){
            if(con.get(str) != null){
                count++;
            }
        }
        system.debug(count); 
        return count > 7;
    }
}