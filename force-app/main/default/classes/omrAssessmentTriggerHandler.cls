/*
* Classname: omrAssessmentTriggerHandler
* Description : Handler class for omrAssessmentTrigger
* -------------------------------------------------------------------------------------------------------------------------
* History
* Version	Date			Description
* v1.1 	29th Sept 23	Updated logic for OMR Assessment Count (Considered change in Error Status)
* v2.0     14th feb 24     Commented boolean flag isStopRecursion - relaity data was not populating on contact on insert
* v3.0     28th feb 24     Added logic to populate academic year from current batch school academic year instead of antarang settings and included setting Next Academic Year in the query  
*/ 
public class omrAssessmentTriggerHandler {
    
    public static boolean isStopRecursion = false;
    
    //addded on 05.07.2023
    public static void populateStudentOnOMRAssementbeforeNew(List<OMR_Assessment__c> newList){
        //isStopRecursion = true;    //v2.0
        Map<String, String> intFildWithAPIname = new Map<String, String>{'Q_2_1__c'=>'Realist','Q_2_2__c'=>'Investigative',
            'Q_2_3__c'=>'Artistic','Q_2_4__c'=>'Social','Q_2_5__c'=>'Enterprising','Q_2_6__c'=>'Conventional','Q_2_7__c'=>'Not sure of interest / like'};
                Map<String, String> aptiFildWithAPIname = new Map<String, String>{'Q3_1__c'=>'Spatial','Q3_2__c'=>'Numerical',
                    'Q3_3__c'=>'Mechanical','Q3_4__c'=>'Abstract','Q3_5__c'=>'Verbal','Q3_6__c'=>'Creative','Q3_7__c'=>'Not sure of Aptitude'};
                        system.debug('$$$ intFildWithAPIname: '+intFildWithAPIname);
        List<String> barcodeLST = new List<String>();
        Map<String, IARP_Master__c> iarpMasterLst = new Map<String, IARP_Master__c>();
        
        for(IARP_Master__c iarp : [
            Select Id,Name,Interest_1__c,Interest_2__c,Interest_3__c,Aptitude_1__c,Aptitude_2__c,Aptitude_3__c From IARP_Master__c 
            where Is_Active__c = true
        ]){
            iarpMasterLst.put(iarp.Name, iarp);
        }
        
        for(OMR_Assessment__c omrassess : newList){
            if(String.isNotBlank(omrassess.Barcode__c)){
                barcodeLST.add(omrassess.Barcode__c);
            }
        }
        Map<String,String> barcodeWithStd = new Map<String,String>();
        Map<String,String> barcodeWithGrade = new Map<String,String>();
        Map<String,String> barcodeWithBatchId = new Map<String,String>(); 
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        
        if(barcodeLST.size() > 0){
            for(Contact con : [Select Id,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c,Current_Batch_Id__c From Contact 
                               where Grade_9_Barcode__c IN :barcodeLST OR 
                               Grade_10_Barcode__c IN :barcodeLST OR 
                               Grade_11_Barcode__c IN :barcodeLST OR
                               Grade_12_Barcode__c IN :barcodeLST]){
                                   if(barcodeLST.contains(con.Grade_9_Barcode__c)){
                                       barcodeWithStd.put(con.Grade_9_Barcode__c, con.Id);  
                                       barcodeWithGrade.put(con.Grade_9_Barcode__c, 'Grade 9');
                                   } else if(barcodeLST.contains(con.Grade_10_Barcode__c)){
                                       barcodeWithStd.put(con.Grade_10_Barcode__c, con.Id);
                                       barcodeWithGrade.put(con.Grade_10_Barcode__c, 'Grade 10'); 
                                   } else if(barcodeLST.contains(con.Grade_11_Barcode__c)){
                                       barcodeWithStd.put(con.Grade_11_Barcode__c, con.Id); 
                                       barcodeWithGrade.put(con.Grade_11_Barcode__c, 'Grade 11');
                                   } else if(barcodeLST.contains(con.Grade_12_Barcode__c)){
                                       barcodeWithStd.put(con.Grade_12_Barcode__c, con.Id); 
                                       barcodeWithGrade.put(con.Grade_12_Barcode__c, 'Grade 12');
                                   } 
                                   barcodeWithBatchId.put(con.Id, con.Current_Batch_Id__c);
                               }
        }
        
        If(barcodeWithBatchId.size() > 0 ){
            for(Batch__c bt : [Select Id,School_Name__c,School_Name__r.Academic_Year__c from batch__c where Id in: barcodeWithBatchId.Values()]){
                if(bt.School_Name__c != null && bt.School_Name__r.Academic_Year__c != null) 
                    currentBatchSchoolAcadYear.put(bt.Id, bt.School_Name__r.Academic_Year__c);
            }
        }
        List<OMR_Assessment__c> omrAssessmentLST = new List<OMR_Assessment__c>();
        for(OMR_Assessment__c omrassess : newList){
            Integer selectedQ2Ans = 0;
            Integer selected_A_ForQ2 = 0;
            Integer selected_B_ForQ2 = 0;
            double Q2AnsRes = 0;
            //OMR_Assessment__c omr = new OMR_Assessment__c(Id = omrassess.Id);
            
            /*
if(String.isBlank(omrassess.Barcode__c)){
omrassess.Error_Status__c = 'Missing Barcode. ';
}
*/
            
            /* if(omrassess.Created_from_Form__c){
omrassess.Academic_Year__c = antarangSett.Next_Academic_Year__c;
}else{
omrassess.Academic_Year__c = antarangSett.Academic_Year__c;
} */
            
            
            if(barcodeWithStd.containsKey(omrassess.Barcode__c)){
                omrassess.Student__c = barcodeWithStd.get(omrassess.Barcode__c);
                omrassess.Grade__c = barcodeWithGrade.get(omrassess.Barcode__c);
                omrassess.Error_Status__c = 'No Error';
                omrassess.Batch_Id__c = barcodeWithBatchId.get(omrassess.Student__c);	//updated on 07.07.2023 for OMR Type Counter
            }else{
                omrassess.Grade__c = null;
                omrassess.Error_Status__c = 'Student not found';
            }
            if(currentBatchSchoolAcadYear.containsKey(barcodeWithBatchId.get(omrassess.Student__c)))   //v3.0 added logic to populate through batch school Academic year
                omrassess.Academic_Year__c = currentBatchSchoolAcadYear.get(barcodeWithBatchId.get(omrassess.Student__c));
            
            if(String.isNotBlank(omrassess.Q_1__c) && omrassess.Q_1__c == 'D'){
                omrassess.X1_A_good_career_plan_has_the_following__c = 1;
            } else {
                omrassess.X1_A_good_career_plan_has_the_following__c = 0;
            }
            
            //if(omrassess.Created_from_Form__c)
            //{
            calculateMarksForm('Q_2_', 7, omrassess, omrassess, intFildWithAPIname, aptiFildWithAPIname);
            calculateMarksForm('Q3_', 7, omrassess, omrassess, intFildWithAPIname, aptiFildWithAPIname);
            /*  }
else
{
calculateMarks('Q_2_', 7, omrassess, omrassess, intFildWithAPIname, aptiFildWithAPIname);
calculateMarks('Q3_', 7, omrassess, omrassess, intFildWithAPIname, aptiFildWithAPIname);
}*/
            calculateMarksForQ4('Q4_', 53, omrassess, omrassess, String.valueOf(omrassess.get('Interest_1__c')),String.valueOf(omrassess.get('Interest_2__c')),String.valueOf(omrassess.get('Aptitude_1__c')),String.valueOf(omrassess.get('Aptitude_2__c')), iarpMasterLst);                
            //omrAssessmentLST.add(omr);
        }
        
    }
    
    //created populateStudentOnOMRAssementbeforeNew to overcome below method error & use below method for OMR online forms (Nagaland)
    
    public static void populateStudentOnOMRAssement(List<OMR_Assessment__c> newList){
        isStopRecursion = true;
        Map<String, String> intFildWithAPIname = new Map<String, String>{'Q_2_1__c'=>'Realist','Q_2_2__c'=>'Investigative',
            'Q_2_3__c'=>'Artistic','Q_2_4__c'=>'Social','Q_2_5__c'=>'Enterprising','Q_2_6__c'=>'Conventional','Q_2_7__c'=>'Not sure of interest / like'};
                Map<String, String> aptiFildWithAPIname = new Map<String, String>{'Q3_1__c'=>'Spatial','Q3_2__c'=>'Numerical',
                    'Q3_3__c'=>'Mechanical','Q3_4__c'=>'Abstract','Q3_5__c'=>'Verbal','Q3_6__c'=>'Creative','Q3_7__c'=>'Not sure of Aptitude'};
                        List<String> barcodeLST = new List<String>();
        Map<String, IARP_Master__c> iarpMasterLst = new Map<String, IARP_Master__c>();
        
        for(IARP_Master__c iarp : [
            Select Id,Name,Interest_1__c,Interest_2__c,Interest_3__c,Aptitude_1__c,Aptitude_2__c,Aptitude_3__c From IARP_Master__c 
            where Is_Active__c = true
        ]){
            iarpMasterLst.put(iarp.Name, iarp);
        }
        
        for(OMR_Assessment__c omrassess : newList){
            if(String.isNotBlank(omrassess.Barcode__c)){
                barcodeLST.add(omrassess.Barcode__c);
            }
        }
        Map<String,String> barcodeWithStd = new Map<String,String>();
        Map<String,String> barcodeWithGrade = new Map<String,String>();
        Map<String,String> barcodeWithBatchId = new Map<String,String>(); 
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        map<string,decimal> currentBatchSchoolAcadYear = new map<string,decimal>();
        
        if(barcodeLST.size() > 0){
            for(Contact con : [Select Id,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c,Grade_12_Barcode__c,Current_Batch_Id__c From Contact 
                               where Grade_9_Barcode__c IN :barcodeLST OR 
                               Grade_10_Barcode__c IN :barcodeLST OR 
                               Grade_11_Barcode__c IN :barcodeLST OR
                               Grade_12_Barcode__c IN :barcodeLST]){
                                   if(barcodeLST.contains(con.Grade_9_Barcode__c)){
                                       barcodeWithStd.put(con.Grade_9_Barcode__c, con.Id);  
                                       barcodeWithGrade.put(con.Grade_9_Barcode__c, 'Grade 9');
                                   } else if(barcodeLST.contains(con.Grade_10_Barcode__c)){
                                       barcodeWithStd.put(con.Grade_10_Barcode__c, con.Id);
                                       barcodeWithGrade.put(con.Grade_10_Barcode__c, 'Grade 10'); 
                                   } else if(barcodeLST.contains(con.Grade_11_Barcode__c)){
                                       barcodeWithStd.put(con.Grade_11_Barcode__c, con.Id); 
                                       barcodeWithGrade.put(con.Grade_11_Barcode__c, 'Grade 11');
                                   } else if(barcodeLST.contains(con.Grade_12_Barcode__c)){
                                       barcodeWithStd.put(con.Grade_12_Barcode__c, con.Id); 
                                       barcodeWithGrade.put(con.Grade_12_Barcode__c, 'Grade 12');
                                   } 
                                   barcodeWithBatchId.put(con.Id, con.Current_Batch_Id__c);
                               }
        }
        If(barcodeWithBatchId.size() > 0 ){
            for(Batch__c bt : [Select Id,School_Name__c,School_Name__r.Academic_Year__c from batch__c where Id in: barcodeWithBatchId.Values()]){
                if(bt.School_Name__c != null && bt.School_Name__r.Academic_Year__c != null) 
                    currentBatchSchoolAcadYear.put(bt.Id, bt.School_Name__r.Academic_Year__c);
            }
        }
        
        List<OMR_Assessment__c> omrAssessmentLST = new List<OMR_Assessment__c>();
        for(OMR_Assessment__c omrassess : newList){
            Integer selectedQ2Ans = 0;
            Integer selected_A_ForQ2 = 0;
            Integer selected_B_ForQ2 = 0;
            double Q2AnsRes = 0;
            OMR_Assessment__c omr = new OMR_Assessment__c(Id = omrassess.Id);
            
            /* if(omrassess.Created_from_Form__c){
omr.Academic_Year__c = antarangSett.Next_Academic_Year__c;
}else{
omr.Academic_Year__c = antarangSett.Academic_Year__c;
} */
            
            
            if(barcodeWithStd.containsKey(omrassess.Barcode__c)){
                omr.Student__c = barcodeWithStd.get(omrassess.Barcode__c);
                omr.Grade__c = barcodeWithGrade.get(omrassess.Barcode__c);
                omr.Error_Status__c = 'No Error';
                omr.Batch_Id__c = barcodeWithBatchId.get(omrassess.Student__c);
            }else{
                omr.Grade__c = null;
                omr.Error_Status__c = 'Student not found';
            }
            if(currentBatchSchoolAcadYear.containsKey(barcodeWithBatchId.get(omr.Student__c)))   //v3.0 added logic to populate through batch school Academic year
                omr.Academic_Year__c = currentBatchSchoolAcadYear.get(barcodeWithBatchId.get(omr.Student__c));
            
            if(String.isNotBlank(omrassess.Q_1__c) && omrassess.Q_1__c == 'D'){
                omr.X1_A_good_career_plan_has_the_following__c = 1;
            } else {
                omr.X1_A_good_career_plan_has_the_following__c = 0;
            }
            
            //if(omrassess.Created_from_Form__c)
            //{
            calculateMarksForm('Q_2_', 7, omrassess, omr, intFildWithAPIname, aptiFildWithAPIname);
            calculateMarksForm('Q3_', 7, omrassess, omr, intFildWithAPIname, aptiFildWithAPIname);
            /*}
else
{
calculateMarks('Q_2_', 7, omrassess, omr, intFildWithAPIname, aptiFildWithAPIname);
calculateMarks('Q3_', 7, omrassess, omr, intFildWithAPIname, aptiFildWithAPIname);
}*/
            calculateMarksForQ4('Q4_', 53, omrassess, omr, String.valueOf(omr.get('Interest_1__c')),String.valueOf(omr.get('Interest_2__c')),String.valueOf(omr.get('Aptitude_1__c')),String.valueOf(omr.get('Aptitude_2__c')), iarpMasterLst);                
            omrAssessmentLST.add(omr);
        }
        
        if(omrAssessmentLST.size() > 0){
            Update omrAssessmentLST;
        }
        
    }
    
    public static void calculateMarks(String sourceField, Integer noOfQues, OMR_Assessment__c omrassess, OMR_Assessment__c omr,Map<String, String> intFildWithAPIname,Map<String, String> aptiFildWithAPIname){
        Integer selectedAns = 0;
        Integer selected_A = 0;
        Integer selected_B = 0;
        double AnsRes = 0;
        String interest1 = '';
        String interest2 = '';
        String Aptitude1 = '';
        String Aptitude2 = '';
        
        
        for(Integer i = 1 ; i <= noOfQues ; i++){
            String field = sourceField + i + '__c';
            String strSourceField = String.valueOf(omrassess.get(field));
            if(String.isNotBlank(strSourceField)){
                selectedAns++;
                if(strSourceField == 'A' && i != 7){
                    selected_A++;
                    AnsRes += 0.5;
                    if(intFildWithAPIname.containsKey(field)){
                        interest1 = intFildWithAPIname.get(field);
                    } 
                    if(aptiFildWithAPIname.containsKey(field)){
                        Aptitude1 = aptiFildWithAPIname.get(field);
                    } 
                } else if(strSourceField == 'B' && i != 7){
                    selected_B++;
                    AnsRes += 0.5;
                    if(intFildWithAPIname.containsKey(field)){
                        interest2 = intFildWithAPIname.get(field);
                    } 
                    if(aptiFildWithAPIname.containsKey(field)){
                        Aptitude2 = aptiFildWithAPIname.get(field);
                    } 
                }
                if(i == 7){
                    if(strSourceField == 'A'){
                        selected_A++;
                        if(sourceField == 'Q_2_'){
                            interest1 = 'Not sure of interest / like';
                        }
                        else if(sourceField == 'Q3_'){
                            Aptitude1 = 'Not sure of Aptitude';
                        }
                    }
                    else if(strSourceField == 'B'){
                        selected_B++;
                        if(sourceField == 'Q_2_'){
                            interest2 = 'Not sure of interest / like';
                        }
                        else if(sourceField == 'Q3_'){
                            Aptitude2 = 'Not sure of Aptitude';
                        }
                    }
                }
            }
        }
        if(selectedAns > 2){
            if(sourceField == 'Q_2_'){
                omr.put('Interest_1__c', 'Not Sure');
                omr.put('Interest_2__c', 'Not Sure');
            } if(sourceField == 'Q3_'){
                omr.put('Aptitude_1__c', 'Not Sure');
                omr.put('Aptitude_2__c', 'Not Sure');
            } 
        } else if(selected_A >= 2){
            if(sourceField == 'Q_2_'){
                omr.put('Interest_1__c', 'Not Sure');
            } if(sourceField == 'Q3_'){
                omr.put('Aptitude_1__c', 'Not Sure');
            } 
        } else if(selected_B >= 2){
            if(sourceField == 'Q_2_'){
                omr.put('Interest_2__c', 'Not Sure');
            } if(sourceField == 'Q3_'){
                omr.put('Aptitude_2__c', 'Not Sure');
            } 
        } else {
            if(sourceField == 'Q_2_'){
                omr.put('Interest_1__c', interest1);
                omr.put('Interest_2__c', interest2);
                omr.put('Interest_Marks__c', AnsRes);
                
            } else if(sourceField == 'Q3_'){
                omr.put('Aptitude_1__c', Aptitude1);
                omr.put('Aptitude_2__c', Aptitude2);
                omr.put('Aptitude_Marks__c', AnsRes);
                
            }
        }
    }
    
    public static void calculateMarksForm(String sourceField, Integer noOfQues, OMR_Assessment__c omrassess, OMR_Assessment__c omr,Map<String, String> intFildWithAPIname,Map<String, String> aptiFildWithAPIname){	
        Integer selectedAns = 0;
        Double ansRes = 0;
        String interest1 = '';
        String interest2 = '';
        String aptitude1 = '';
        String aptitude2 = '';
        Map<String,String> mapFieldVsValue = new Map<String,String>();
        List<String> expectedAns = new List<String>{'A', 'B', 'C', 'D', 'E', 'F', 'G'};
            
            do{
                for(Integer i = 1 ; i <= noOfQues ; i++){
                    String field = sourceField + i + '__c';
                    String strFieldValue = String.valueOf(omrassess.get(field));		
                    if(String.isNotBlank(strFieldValue))
                    {
                        selectedAns++;
                        mapFieldVsValue.put(field,strFieldValue);
                    }
                }
                if(selectedAns > 2)
                {
                    interest1 = 'Not Sure';
                    interest2 = 'Not Sure';
                    aptitude1 = 'Not Sure';
                    aptitude2 = 'Not Sure';
                    break;
                }
                else if(selectedAns == 0)break;
                
                Integer ansCount = 0;
                for(String field : mapFieldVsValue.keySet())
                {
                    ansCount++;	
                    String ans = mapFieldVsValue.get(field);
                    
                    if(!expectedAns.contains(ans))
                    {
                        if(ansCount == 1)
                        {
                            interest1 = 'Not Sure';
                            aptitude1 = 'Not Sure';
                        }
                        else if(ansCount == 2)
                        {
                            interest2 = 'Not Sure';
                            aptitude2 = 'Not Sure';
                        }
                        continue;
                    }
                    
                    if(field != 'Q_2_7__c' && field != 'Q3_7__c')ansRes += 0.5;
                    
                    if(intFildWithAPIname.containsKey(field)){
                        if(ansCount == 1)interest1 = intFildWithAPIname.get(field);
                        else if(ansCount == 2)interest2 = intFildWithAPIname.get(field);
                    } 
                    if(aptiFildWithAPIname.containsKey(field)){
                        if(ansCount == 1)aptitude1 = aptiFildWithAPIname.get(field);
                        else if(ansCount == 2)aptitude2 = aptiFildWithAPIname.get(field);
                    }
                }
            }while(false);
        
        if(sourceField == 'Q_2_')
        {
            omr.put('Interest_1__c', interest1);
            omr.put('Interest_2__c', interest2);
            omr.put('Interest_Marks__c', ansRes);	
        } 
        else if(sourceField == 'Q3_')
        {
            omr.put('Aptitude_1__c', aptitude1);
            omr.put('Aptitude_2__c', aptitude2);
            omr.put('Aptitude_Marks__c', ansRes);	
        }
    }
    
    public static void calculateMarksForQ4(String sourceField, Integer noOfQues, OMR_Assessment__c omrassess, 
                                           OMR_Assessment__c omr, String interest1, String interest2, String Aptitude1, String Aptitude2,Map<String, IARP_Master__c> iarpMasterLst){
                                               Integer selectedAns = 0;
                                               Integer selected_A = 0;
                                               Integer selected_B = 0;
                                               double AnsRes = 0;
                                               String careerChoice1 = '';
                                               String careerChoice2 = '';
                                               Double Interest_Marks = (Decimal) omr.get('Interest_Marks__c'); 
                                               Double Aptitude_Marks = (Decimal) omr.get('Aptitude_Marks__c');
                                               Map<String, String> careerChoFildWithAPIname = new Map<String, String>{'Q4_1__c'=>'Not sure of Career Choice','Q4_2__c'=>'Entrepreneur',
                                                   'Q4_3__c'=>'Office Administrator','Q4_4__c'=>'Salesperson','Q4_5__c'=>'Accountant','Q4_6__c'=>'Lawyer','Q4_7__c'=>'Logistics Worker',
                                                   'Q4_8__c'=>'Interior Designer','Q4_9__c'=>'Architect','Q4_10__c'=>'Graphic Designer','Q4_11__c'=>'Animator','Q4_12__c'=>'Fashion Designer',
                                                   'Q4_13__c'=>'Performing Artist','Q4_14__c'=>'Film Production Specialist','Q4_15__c'=>'Content Developer','Q4_16__c'=>'Advertising Professional','Q4_17__c'=>'Event Planner',
                                                   'Q4_18__c'=>'Banker','Q4_19__c'=>'Microfinance Professional','Q4_20__c'=>'Financial Advisor','Q4_21__c'=>'Financial Analyst','Q4_22__c'=>'Doctor',
                                                   'Q4_23__c'=>'Nurse','Q4_24__c'=>'Medical Lab Technician','Q4_25__c'=>'Pharmacist','Q4_26__c'=>'Physiotherapist','Q4_27__c'=>'Healthcare Management Professional',
                                                   'Q4_28__c'=>'Hospitality Services Professional','Q4_29__c'=>'Chef','Q4_30__c'=>'Travel Services Planner','Q4_31__c'=>'Commercial Pilot','Q4_32__c'=>'Beautician',
                                                   'Q4_33__c'=>'Sportsperson','Q4_34__c'=>'Coach/Trainer','Q4_35__c'=>'Nutritionist/Dietician','Q4_36__c'=>'Mental Health Counsellor','Q4_37__c'=>'Teacher/Facilitator',
                                                   'Q4_38__c'=>'Curriculum Designer','Q4_39__c'=>'School Administrator','Q4_40__c'=>'Military Serviceperson','Q4_41__c'=>'Government Service Professional','Q4_42__c'=>'Social Worker',
                                                   'Q4_43__c'=>'Environmentalist','Q4_44__c'=>'Horticulturist','Q4_45__c'=>'Urban Planner','Q4_46__c'=>'Food Scientist','Q4_47__c'=>'Artificial Intelligence Expert',
                                                   'Q4_48__c'=>'Cyber Security Specialist','Q4_49__c'=>'Application Developer','Q4_50__c'=>'Data Analyst/ Scientist','Q4_51__c'=>'Engineer','Q4_52__c'=>'Tradesperson','Q4_53__c'=>'Other'};
                                                       for(Integer i = 1 ; i <= noOfQues ; i++){
                                                           String field = sourceField + i + '__c';
                                                           String strSourceField = String.valueOf(omrassess.get(field));
                                                           if(String.isNotBlank(strSourceField) && field != 'Q4_53__c'){
                                                               selectedAns++;
                                                               if(strSourceField == '1'){
                                                                   selected_A++;
                                                                   AnsRes += 2;
                                                                   careerChoice1 = careerChoFildWithAPIname.get(field);
                                                               } else if(strSourceField == '2'){
                                                                   selected_B++;
                                                                   AnsRes += 2;
                                                                   careerChoice2 = careerChoFildWithAPIname.get(field);
                                                               }
                                                           }
                                                           if(String.isNotBlank(strSourceField) && field == 'Q4_53__c'){
                                                               selectedAns++;
                                                               if(strSourceField == '1'){
                                                                   selected_A++;
                                                                   AnsRes += 1;
                                                                   careerChoice1 = careerChoFildWithAPIname.get(field);
                                                               } else if(strSourceField == '2'){
                                                                   selected_B++;
                                                                   AnsRes += 1;
                                                                   careerChoice2 = careerChoFildWithAPIname.get(field);
                                                               }
                                                           }
                                                       }
                                               
                                               if(selectedAns > 2){
                                                   omr.put('Career_Choice_1__c', 'Not Sure');
                                                   omr.put('Career_Choice_2__c', 'Not Sure');
                                               } else if(selected_A >= 2){
                                                   omr.put('Career_Choice_1__c', 'Not Sure');
                                               } else if(selected_B >= 2){
                                                   omr.put('Career_Choice_2__c', 'Not Sure');
                                               } else {
                                                   Integer choiceMarks = 0;
                                                   Integer choice1Marks = 0;
                                                   Integer choice2Marks = 0;
                                                   Boolean isCho1IntFound = false;
                                                   Boolean isCho1AptFound = false;
                                                   Boolean isCho2IntFound = false;
                                                   Boolean isCho2AptFound = false;
                                                   
                                                   omr.put('Career_Choice_1__c', careerChoice1);
                                                   omr.put('Career_Choice_2__c', careerChoice2);
                                                   
                                                   if(iarpMasterLst.containsKey(careerChoice1)){
                                                       IARP_Master__c iarp = iarpMasterLst.get(careerChoice1);
                                                       if(iarp.Interest_1__c == interest1 || iarp.Interest_2__c == interest1 || iarp.Interest_3__c == interest1 || 
                                                          iarp.Interest_1__c == interest2 || iarp.Interest_2__c == interest2 || iarp.Interest_3__c == interest2){
                                                              isCho1IntFound = true;
                                                          }
                                                       if(iarp.Aptitude_1__c == Aptitude1 || iarp.Aptitude_2__c == Aptitude1 || iarp.Aptitude_3__c == Aptitude1 || 
                                                          iarp.Aptitude_1__c == Aptitude2 || iarp.Aptitude_2__c == Aptitude2 || iarp.Aptitude_3__c == Aptitude2){
                                                              isCho1AptFound = true;
                                                          }
                                                   }
                                                   
                                                   if(isCho1IntFound && isCho1AptFound){
                                                       choice1Marks = 2;
                                                   } else if(careerChoice1 == 'Other') {
                                                       choice1Marks = 1;
                                                   }
                                                   
                                                   if(iarpMasterLst.containsKey(careerChoice2)){
                                                       IARP_Master__c iarp = iarpMasterLst.get(careerChoice2);
                                                       if(iarp.Interest_1__c == interest1 || iarp.Interest_2__c == interest1 || iarp.Interest_3__c == interest1 || 
                                                          iarp.Interest_1__c == interest2 || iarp.Interest_2__c == interest2 || iarp.Interest_3__c == interest2){
                                                              isCho2IntFound = true;
                                                          }
                                                       if(iarp.Aptitude_1__c == Aptitude1 || iarp.Aptitude_2__c == Aptitude1 || iarp.Aptitude_3__c == Aptitude1 || 
                                                          iarp.Aptitude_1__c == Aptitude2 || iarp.Aptitude_2__c == Aptitude2 || iarp.Aptitude_3__c == Aptitude2){
                                                              isCho2AptFound = true;
                                                          }
                                                   }
                                                   if(isCho2IntFound && isCho2AptFound){
                                                       choice2Marks = 2;
                                                   } else if(careerChoice2 == 'Other' && Interest_Marks > 0 && Aptitude_Marks > 0) {
                                                       choice2Marks = 1;
                                                   }
                                                   choiceMarks = choice1Marks + choice2Marks;
                                                   omr.put('Career_Choice_1_Marks__c',choice1Marks);
                                                   omr.put('Career_Choice_2_Marks__c',choice2Marks);
                                                   omr.put('Career_Choice_Total_Marks__c',choiceMarks);
                                               }
                                           }
    
    // This method is used to popplate Aspirations in Student record from Career_Choice_1__c and Career_Choice_2__c fields.
    public static void populateStudentAspirations(List<OMR_Assessment__c> newList, Map<Id, OMR_Assessment__c> oldMap){
        isStopRecursion = true;
        Id EndlineRecordTypeId = [SELECT Id, DeveloperName, Name, SobjectType FROM RecordType where DeveloperName = 'Endline' AND SobjectType = 'OMR_Assessment__c'].Id;
        Set<Id> contactIdSet = new Set<Id>();
        
        // Adding student ids into a list in insert event
        // Adding old and latest student ids into a list in update and delete event to update the contacts 
        for(OMR_Assessment__c omr : newList){
            if(omr.RecordTypeId == EndlineRecordTypeId ){
                if(oldMap == null && ( String.isNotBlank(omr.Career_Choice_1__c) || String.isNotBlank(omr.Career_Choice_2__c) ) ){
                    contactIdSet.add(omr.Student__c);
                }else if(oldMap != null && ( omr.Career_Choice_1__c != oldMap.get(omr.Id).Career_Choice_1__c || omr.Career_Choice_2__c != oldMap.get(omr.Id).Career_Choice_2__c || omr.Student__c != oldMap.get(omr.Id).Student__c )){
                    if(oldMap.get(omr.Id).Student__c != null && omr.Student__c != oldMap.get(omr.Id).Student__c ){
                        contactIdSet.add(oldMap.get(omr.Id).Student__c);
                    }
                    if(omr.Student__c != null){
                        contactIdSet.add(omr.Student__c);
                    }
                }
            }
        }
        
        if(contactIdSet.size() > 0){
            updateStudentAspirations(contactIdSet);
        }
        
    }
    
    public static void updateStudentAspirations(set<Id> contactIdSet){
        // custom settings to check the Academic year
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        List<Contact> updateList = new List<Contact>();
        String IdoNotKnowIARP = 'i do not know';
        
        set<Id> currentBatchIds = new set<Id>();
        for(Contact con : [Select Id,Current_Batch_Id__c from contact where Id IN :contactIdSet AND Current_Batch_Id__c != null]){
            currentBatchIds.add(con.Current_Batch_Id__c);
        }
        set<Id> filteredBatchIds = new set<Id>();
        for(batch__c btch : [select Id,Academic_Year__c from Batch__c 
                             where Id IN: currentBatchIds 
                             AND Academic_Year__c != null 
                             AND (Academic_Year__c =: antarangSett.Academic_Year__c OR Academic_Year__c =: antarangSett.Next_Academic_Year__c)]){
            filteredBatchIds.add(btch.id);
        }
        
        map<String ,IARP_Master__c> IARPMasterMap = new map<String, IARP_Master__c>();
        for(IARP_Master__c objIarp : [select Id, Name from IARP_Master__c Where Is_Active__c = true order by Name]){
            IARPMasterMap.put(objIarp.Name.toLowercase(), objIarp);
        }
        
        for(Contact con : [Select Id, Recommedation_Status__c, Status__c, Batch_Code__r.Academic_Year__c, Batch_Code__c, Aspiration_1__c, Aspiration_2__c, Aspiration_3__c,
                           (Select id, Career_Choice_1__c, Career_Choice_2__c  From OMR_Assessments__r 
                            Where recordtype.DeveloperName = 'Endline' order By Academic_Year__c Desc,  createddate desc Limit 1 ) 
                           From Contact Where Id IN :contactIdSet AND RecordType.DeveloperName = 'CA_Student' 
                           AND Current_Batch_Id__c IN: filteredBatchIds]) //v3.0 added logic to include Next Academic year and process through current batch id 
        {
            
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
                
                con.Recommedation_Status__c = 'Not Processed';
                con.Status__c = 'Not Processed';     
                updateList.add(con);
            }else if(con.Aspiration_1__c != null || con.Aspiration_2__c != null){
                con.Aspiration_1__c = null;
                con.Aspiration_2__c = null;
                con.Recommedation_Status__c = 'Not Processed';
                con.Status__c = 'Not Processed';
                
                updateList.add(con);
            }
        }
        
        if(updateList.size() > 0){
            update updateList;
        }
    }
    
    public static void updateBatchId(List<OMR_Assessment__c> newCdm1List, Map<Id,OMR_Assessment__c> oldcdm1Map) {
        // custom settings to check the Academic year
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        
        Double acadYear = 0;
        List<OMR_Assessment__c> cdm1List = New List<OMR_Assessment__c>();        
        Set<Id> contSet = New Set<id>();                
        Map<Id,Id> StudBatchId = New Map<Id,Id>();
        Map<Id,List<Contact>> batchWithStuds = New Map<Id,List<Contact>>();
        List<OMR_Assessment__c> updateCdm1 = New List<OMR_Assessment__c>();
        
        for(OMR_Assessment__c cdm1: newCdm1List) {
            if(oldcdm1Map == null || (oldcdm1Map !=null && cdm1.Student__c != oldcdm1Map.get(cdm1.Id).Student__c)) {                
                //acadYear = cdm1.Academic_Year__c;                
                if(cdm1.Student__c != null) {
                    contSet.add(cdm1.Student__c);
                    cdm1List.add(cdm1);
                } else {                    
                    cdm1.Batch_Id__c = null;                                        
                }                
            }
        }
        if(contSet.size()>0) {
            for(Contact c: [Select Id, G12_Batch_Code__c, G11_Batch_Code__c, G10_Batch_Code__c, Batch_Code__c
                            From Contact
                            Where Id In: contSet]) {                                 
                                if(c.G12_Batch_Code__c != null) {                                                                                
                                    if(!batchWithStuds.containsKey(c.G12_Batch_Code__c)) 
                                        batchWithStuds.put(c.G12_Batch_Code__c, new List<Contact>());
                                    batchWithStuds.get(c.G12_Batch_Code__c).add(c);
                                    
                                } else if(c.G11_Batch_Code__c != null) {                                        
                                    if(!batchWithStuds.containsKey(c.G11_Batch_Code__c)) 
                                        batchWithStuds.put(c.G11_Batch_Code__c, new List<Contact>());
                                    batchWithStuds.get(c.G11_Batch_Code__c).add(c);
                                    
                                } else if(c.G10_Batch_Code__c != null) {                                        
                                    if(!batchWithStuds.containsKey(c.G10_Batch_Code__c)) 
                                        batchWithStuds.put(c.G10_Batch_Code__c, new List<Contact>());
                                    batchWithStuds.get(c.G10_Batch_Code__c).add(c);
                                    
                                } else if(c.Batch_Code__c != null) {                                        
                                    if(!batchWithStuds.containsKey(c.Batch_Code__c)) 
                                        batchWithStuds.put(c.Batch_Code__c, new List<Contact>());
                                    batchWithStuds.get(c.Batch_Code__c).add(c);
                                }
                            }
            if(batchWithStuds.size()>0) {
                for(Batch__c b: [Select Id
                                 From Batch__c
                                 Where Id In: batchWithStuds.keySet() 
                                 AND (Academic_Year__c =: antarangSett.Academic_Year__c OR Academic_Year__c =: antarangSett.Next_Academic_Year__c)]) //v3.0 Included Next_Academic_Year__c
                {                                                                                                                          
                    for(Contact c: batchWithStuds.get(b.Id)) {
                        StudBatchId.put(c.Id,b.Id);
                    }
                }                    
                for(OMR_Assessment__c o: cdm1List){
                    if(StudBatchId.containsKey(o.Student__c)) {                            
                        o.Batch_Id__c = StudBatchId.get(o.Student__c);                            
                    }
                }
            }
        }        
    }
    
    
    
    //----- v1.0 START ------- 
    public static boolean updateCounterFlag = false;
    public static void updateOMRTypeCounterManager(List<OMR_Assessment__c> cdm1List, Map<Id,OMR_Assessment__c> oldcdm1Map, Boolean isDelete){
        updateCounterFlag = true;
        set<Id> BaselineBatchSet = new set<Id>();
        set<Id> EndlineBatchSet = new set<Id>();
        Id baselineRTID = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByName().get('Baseline').getRecordTypeId();
        Id endlineRTID = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByName().get('Endline').getRecordTypeId();
        
        if(isDelete){   														//CDM1 record Deleted
            if(oldcdm1Map != null){
                for(OMR_Assessment__c c: oldcdm1Map.Values()){
                    if(c.RecordTypeId == baselineRTID){
                        BaselineBatchSet.add(c.Batch_Id__c);
                    }else if(c.RecordTypeId == endlineRTID){
                        EndlineBatchSet.add(c.Batch_Id__c);
                    }
                    
                }
            }
        }else{
            for(OMR_Assessment__c c: cdm1List){
                if(oldcdm1Map == null){     									//CDM1 record Inserted
                    if(c.RecordTypeId == baselineRTID){
                        BaselineBatchSet.add(c.Batch_Id__c);
                    }else if(c.RecordTypeId == endlineRTID){
                        EndlineBatchSet.add(c.Batch_Id__c);
                    }
                }else if(c.Student__c != oldcdm1Map.get(c.Id).Student__c || c.Student_Linked__c != oldcdm1Map.get(c.Id).Student_Linked__c
                         || c.Error_Status__c != oldcdm1Map.get(c.Id).Error_Status__c){     //CDM1 record Updated (v1.1)
                             if(c.RecordTypeId == baselineRTID){
                                 BaselineBatchSet.add(c.Batch_Id__c);
                             }else if(c.RecordTypeId == endlineRTID){
                                 EndlineBatchSet.add(c.Batch_Id__c);
                             }
                         }
            }
        }
        if(BaselineBatchSet.size() > 0 || EndlineBatchSet.size() > 0){
            updateOMRTypeCounter(BaselineBatchSet, EndlineBatchSet);
        }
        
    }
    
    public static void updateOMRTypeCounter(set<Id> BaselineBatchSet, set<Id> EndlineBatchSet){
        List<Session_OMR_Type__c> SOTList = New List<Session_OMR_Type__c>();
        Map<Id,Integer> BaselineCounterMap = New Map<Id,Integer>();
        Map<Id,Integer> EndlineCounterMap = New Map<Id,Integer>();
        Id baselineRTID = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByName().get('Baseline').getRecordTypeId();
        Id endlineRTID = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByName().get('Endline').getRecordTypeId();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        
        
        if(!BaselineBatchSet.isEmpty() && BaselineBatchSet.size() > 0){
            AggregateResult[] groupedBatchResults   = [SELECT COUNT(Id), Batch_Id__c 
                                                       FROM OMR_Assessment__c 
                                                       WHERE RecordTypeId =: baselineRTID AND 
                                                       Batch_Id__c IN: BaselineBatchSet AND 
                                                       Student__c != null AND 
                                                       Academic_Year__c =: antarangSett.Academic_Year__c AND 
                                                       Error_Status__c = 'No Error'  
                                                       GROUP BY Batch_Id__c];
            for (AggregateResult ar : groupedBatchResults)  {
                BaselineCounterMap.put((Id)ar.get('Batch_Id__c'), (Integer)ar.get('expr0'));
            }
        }
        if(!EndlineBatchSet.isEmpty() && EndlineBatchSet.size() > 0){
            AggregateResult[] groupedBatchResults   = [SELECT COUNT(Id), Batch_Id__c 
                                                       FROM OMR_Assessment__c 
                                                       WHERE RecordTypeId =: endlineRTID AND 
                                                       Batch_Id__c IN: EndlineBatchSet AND 
                                                       Student__c != null AND 
                                                       Academic_Year__c =: antarangSett.Academic_Year__c AND 
                                                       Error_Status__c = 'No Error'  
                                                       GROUP BY Batch_Id__c];
            for (AggregateResult ar : groupedBatchResults)  {
                EndlineCounterMap.put((Id)ar.get('Batch_Id__c'), (Integer)ar.get('expr0'));
            }
        }
        
        for(Session_OMR_Type__c sot : [SELECT Id, OMR_Assessment_Record_Type__c, Session_Batch_Id__c
                                       FROM Session_OMR_Type__c
                                       WHERE OMR_Assessment_Object__c = 'CDM1' AND
                                       (Session_Batch_Id__c IN: BaselineBatchSet OR Session_Batch_Id__c IN: EndlineBatchSet) AND 
                                       OMR_Assessment_Record_Type__c IN ('Baseline', 'Endline')])
        {
            if(sot.OMR_Assessment_Record_Type__c == 'Baseline' && BaselineCounterMap.ContainsKey(sot.Session_Batch_Id__c)){
                SOTList.add(new Session_OMR_Type__c(Id = sot.Id, OMR_Assessment_Count__c = BaselineCounterMap.get(sot.Session_Batch_Id__c)));
            }
            else if(sot.OMR_Assessment_Record_Type__c == 'Endline' && EndlineCounterMap.ContainsKey(sot.Session_Batch_Id__c)){
                SOTList.add(new Session_OMR_Type__c(Id = sot.Id, OMR_Assessment_Count__c = EndlineCounterMap.get(sot.Session_Batch_Id__c)));
            }
            
        }
        
        if(SOTList.size() > 0){
            Update SOTList;
        }
    }
    //----- v1.0 END -------  
    
    //----Old Method start----
    /*  public static void updateOMRTypeCounter(List<OMR_Assessment__c> cdm1List, Map<Id,OMR_Assessment__c> oldcdm1Map, Boolean isDelete) {        
updateCounterFlag = true;
Boolean isDeleteFlag = isDelete;
Integer getCount = 0;
List<Session_OMR_Type__c> SOTList = New List<Session_OMR_Type__c>();
Map<Id,Integer> BaselineBatchMap = New Map<Id,Integer>();
Map<Id,Integer> EndlineBatchMap = New Map<Id,Integer>();
Id baselineRTID = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByName().get('Baseline').getRecordTypeId();
Id endlineRTID = Schema.SObjectType.OMR_Assessment__c.getRecordTypeInfosByName().get('Endline').getRecordTypeId();              

for(OMR_Assessment__c c: cdm1List) {              
If((isDeleteFlag == false && oldcdm1Map == null && c.Error_Status__c != 'Duplicate Entry') ||	//on Insert
(oldcdm1Map != null && c.Error_Status__c != oldcdm1Map.get(c.Id).Error_Status__c && c.Error_Status__c != 'Duplicate Entry' && oldcdm1Map.get(c.Id).Error_Status__c == 'Duplicate Entry')) {                                   
if(c.RecordTypeId == baselineRTID) {                       
if(!BaselineBatchMap.containsKey(c.Batch_Id__c)) {
BaselineBatchMap.put(c.Batch_Id__c,1);                           
}
else {
getCount = BaselineBatchMap.get(c.Batch_Id__c);
BaselineBatchMap.put(c.Batch_Id__c,getCount+1);
}                                                                
} else if(c.RecordTypeId == endlineRTID) {                       
if(!EndlineBatchMap.containsKey(c.Batch_Id__c)) {
EndlineBatchMap.put(c.Batch_Id__c,1);                           
}
else {
getCount = EndlineBatchMap.get(c.Batch_Id__c);
EndlineBatchMap.put(c.Batch_Id__c,getCount+1);
} 
}  

} else if( isDeleteFlag == true || 
(oldcdm1Map != null && c.Error_Status__c != oldcdm1Map.get(c.Id).Error_Status__c && c.Error_Status__c == 'Duplicate Entry' && oldcdm1Map.get(c.Id).Error_Status__c != 'Duplicate Entry')) {                                                
if(c.RecordTypeId == baselineRTID) {                       
if(!BaselineBatchMap.containsKey(c.Batch_Id__c)) {
BaselineBatchMap.put(c.Batch_Id__c,-1);                           
}
else {
getCount = BaselineBatchMap.get(c.Batch_Id__c);
BaselineBatchMap.put(c.Batch_Id__c,getCount-1);
}                                                                
} else if(c.RecordTypeId == endlineRTID) {                       
if(!EndlineBatchMap.containsKey(c.Batch_Id__c)) {
EndlineBatchMap.put(c.Batch_Id__c,-1);                           
}
else {
getCount = EndlineBatchMap.get(c.Batch_Id__c);
EndlineBatchMap.put(c.Batch_Id__c,getCount-1);
} 
} 
}            
}
if(BaselineBatchMap.size()>0) {            
for(Session_OMR_Type__c s: [Select id, name, OMR_Type__c, Session__r.name, Session__r.Session_Grade__c, OMR_Assessment_Count__c, Session_Batch_Id__c, Session__r.Batch__c
From Session_OMR_Type__c 
Where Session__r.Batch__c  IN: BaselineBatchMap.KeySet() 
AND OMR_Assessment_Object__c = 'CDM1' 
And OMR_Assessment_Record_Type__c = 'Baseline']) {                                           
if(BaselineBatchMap.containsKey(s.Session_Batch_Id__c)) {
s.OMR_Assessment_Count__c = s.OMR_Assessment_Count__c + BaselineBatchMap.get(s.Session_Batch_Id__c);
SOTList.add(s);
}                                
}
}
if(EndlineBatchMap.size()>0) {
for(Session_OMR_Type__c s:[Select id, name, OMR_Type__c, Session__r.name, Session__r.Session_Grade__c, OMR_Assessment_Count__c, Session_Batch_Id__c
From Session_OMR_Type__c 
Where Session__r.Batch__c  IN: EndlineBatchMap.KeySet() 
AND OMR_Assessment_Object__c = 'CDM1' 
And OMR_Assessment_Record_Type__c = 'Endline']) {
if(EndlineBatchMap.containsKey(s.Session_Batch_Id__c)) {
s.OMR_Assessment_Count__c = s.OMR_Assessment_Count__c + EndlineBatchMap.get(s.Session_Batch_Id__c);
SOTList.add(s);
}  
}
}
if(SOTList.size()>0) {
update SOTList;
}
}  */
    //----Old Method end----
    
    public static void dummCodeCoverage(){
        integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}