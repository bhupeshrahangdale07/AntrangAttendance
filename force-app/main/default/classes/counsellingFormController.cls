public without sharing class counsellingFormController {
    
    @AuraEnabled
    public static Object checkEmailExist(String stremail) {
        Map<String, Object> result = new Map<String, Object>();
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();	//updated: 24.02.2023
        result.put('grade', getdynamicpicklistval('Batch__c', 'Grade__c'));
        Contact c = new Contact();
        string labelForDomain = System.Label.Antarang_Domain;
        if((String.isNotBlank(stremail) && stremail.contains('@') && labelForDomain.contains(stremail.split('@').get(1)))) {
            for (Contact objcon : [
            SELECT id, email,Facilitator_Work_Status__c
            FROM contact
            WHERE npe01__WorkEmail__c = :stremail AND RecordTypeId = :recordTypeId
                AND (Academic_Year__c =: antarangSett.Academic_Year__c OR Academic_Year__c =: antarangSett.Next_Academic_Year__c)	// updated: 23.03.2023 - Only Acad year or Next Acad year Fac. can log in the form
            	//AND Facilitator_Work_Status__c = 'Active'	//updated on 18.04.2024
                ORDER BY CreatedDate DESC
            LIMIT 1
        ]) {
            c = objcon;
        }
        
        result.put('contact', c);
        return result;
        }else{
            result.put('contact', c);
        return result;
        }
        
    }
    
    @AuraEnabled
    public static Object fetchbatch(String schoolId, String sessGrade, String facilitatorId){
        Map<String, Object> result = new Map<String, Object>();
        List<picklistwrapper> options = new List<picklistwrapper>();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        options.add(new picklistwrapper('-None-', '', false));
         //added 24-2-23 start
         Double facilatorAcademicYr = 0.0;
        Contact facilatorAcademic = [select id,Academic_Year__c from Contact where id= :facilitatorId];
        if(facilatorAcademic != null){
            facilatorAcademicYr = facilatorAcademic.Academic_Year__c;
        }//added 24-2-23 ends
        system.debug('facilatorAcademic = '+facilatorAcademic);
        //added on 18/4/2024
        set<Decimal> academicYear = new set<Decimal>();
        academicYear.add(antarangSett.Academic_Year__c);
        academicYear.add(antarangSett.Next_Academic_Year__c);
        //added on 18/4/2024 end
        for(Batch__c bc : [select id,Name,Facilitation_Start_Date__c,
                           Batch_number__c,Grade__c,
                           (Select Id,Attendance_Submitted__c From Sessions__r where Session_Type__c = 'Counseling' AND Assigned_Facilitator__c =: facilitatorId) from Batch__c
                           where school_name__c =:schoolId AND
                           Grade__c =: sessGrade 
                           AND Dummy_Batch__c = False	//addded on 28.04.2023
                           AND //Academic_Year__c =: facilatorAcademicYr 
                           //added on 18/4/2024 
                           Academic_Year__c IN :academicYear 
                           ORDER BY Facilitation_Start_Date__c desc ]){ System.debug('----bc ---- ' + bc);
                               if(bc.Sessions__r.size() > 0){
                                   options.add(
                                       new picklistwrapper(bc.Batch_number__c +' - '+bc.Name, String.valueOf(bc.Id), false)
                                   );
                               }
                               
                           }
        result.put('batch', options);
        system.debug('result = '+result);
        return result;
    }
    
    @AuraEnabled
    public static void saveCounselingStaus(String batchId) {
        List<Session__c> readyForPaySess = new List<Session__c>();      
        
        Map<Id,Batch__c> batchMap = new Map<Id,Batch__c>([
            Select Id,Name From Batch__c where Id = :batchId
        ]);        
        if(batchMap.keyset().size() > 0){
            for(Session__c sess : [Select Id,Batch__c,Attendance_Submitted__c from Session__c 
                                   where Session_Type__c = 'Counseling'
                                   and Batch__c IN : batchMap.keyset()
                                  ]){
                                      sess.SessionDate__c = system.today();
                                      sess.Attendance_Submitted__c = true;
                                      sess.Payment_Status__c = 'Ready For Payment';
                                      readyForPaySess.add(sess);
                                  }
        }
        
        if(readyForPaySess.size() > 0){
            update readyForPaySess;
        }
    }
    
    @AuraEnabled
    public static Object fetchStudent(String batchId, String facilitatorId, String sessGrade){        
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();        
        Map<String, Object> result = new Map<String, Object>();
        List<studentWrapper> stdWrapperLST = new List<studentWrapper>();
        List<picklistwrapper> resondata = getdynamicpicklistval('Session_Attendance__c', 'Reason__c');
        
        integer totalStudent = 0;
        string totalStudentPerBatch = '';
        Date d, dt;
        
        Map<Id,Batch__c> batchMap = new Map<Id,Batch__c>([
            Select Id,Name,
            (Select Id,Attendance_Submitted__c From Sessions__r where Session_Type__c = 'Counseling' AND Assigned_Facilitator__c =: facilitatorId) 
            From Batch__c where Id =:batchId
        ]);   
        if(batchMap.size() > 0){
            if(batchMap.get(batchId).Sessions__r.size() > 0){
                if(batchMap.get(batchId).Sessions__r[0].Attendance_Submitted__c){
                    result.put('forsubmitted', true);
                } else {
                    result.put('forsubmitted', false);
                }
            }
        }
       system.debug('batchMap : '+batchMap);
        if(batchMap.keyset().size() > 0){
            Map<Id,Id> batchWithSessionIds = new Map<Id,Id>();
            
            Map<string,Session_Attendance__c> contactInSessionAttendanceMap = new Map<string,Session_Attendance__c>();
            for(Session__c sess : [Select Id,Batch__c,Assigned_Facilitator__c,
                                   (select id,Contact__c,Date__c,First_step_after_Class_10__c,Career_Aspiration__c,
                                    Reason__c,Session__c,Session__r.Attendance_Submitted__c,Status__c,Counseling_Type__c,
                                    Time__c,Attendance__c,Guardian_Parent_Attendance__c from Sessions__r) 
                                   from Session__c 
                                   where Session_Type__c = 'Counseling' And
                                   Assigned_Facilitator__c =: facilitatorId
                                   and Batch__c IN : batchMap.keyset()
                                  ]){
                                      system.debug('sess : ' + sess);
                                      batchWithSessionIds.put(sess.Batch__c,sess.Id);
                                      
                                      for(Session_Attendance__c objSessionAttendance : sess.Sessions__r){
                                          contactInSessionAttendanceMap.put(objSessionAttendance.Contact__c+'_'+objSessionAttendance.Session__c,objSessionAttendance);
                                      }
                                      
                                  }
            
            if(batchWithSessionIds.size() > 0){
                Set<Id> bidS = batchWithSessionIds.keySet();
                                                
				//added on 27.04.2023           
                List<Contact> conList = New List<Contact>();
                 if(sessGrade == 'Grade 9') {
                    for(Contact c: [Select Id,Name,Batch_Code__c,G11_Batch_Code__c,MobilePhone,Phone,OtherPhone 
                                    From Contact 
                                    where Batch_Code__c IN : bidS Order by Name]) {
                        conList.add(c);
                    }                        
                }if(sessGrade == 'Grade 10') {
                    for(Contact c: [Select Id,Name,Batch_Code__c,G10_Batch_Code__c,MobilePhone,Phone,OtherPhone 
                                    From Contact 
                                    where G10_Batch_Code__c IN : bidS Order by Name]) {
                        conList.add(c);
                    }                        
                }if(sessGrade == 'Grade 11') {
                    for(Contact c: [Select Id,Name,Batch_Code__c,G11_Batch_Code__c,MobilePhone,Phone,OtherPhone 
                                    From Contact 
                                    where G11_Batch_Code__c IN : bidS Order by Name]) {
                        conList.add(c);
                    }                        
                } else if(sessGrade == 'Grade 12'){
                    for(Contact c: [Select Id,Name,Batch_Code__c,G12_Batch_Code__c,MobilePhone,Phone,OtherPhone 
                                    From Contact 
                                    Where G12_Batch_Code__c IN : bidS Order by Name]) {
                        conList.add(c);
                    }
                }
                
                /*for(Contact con : [Select Id,Name,Batch_Code__c,MobilePhone,Phone,OtherPhone From Contact where 
                                   Batch_Code__c IN : bidS Order by Name]) */	//commented on 27.04.2023 
                for(Contact con : conList) 
                {
                    //added on 27.04.2023
                    String BatchCode = null;
                    if(sessGrade == 'Grade 9') {
                        BatchCode = con.Batch_Code__c;
                    } else if(sessGrade == 'Grade 10') {
                        BatchCode = con.G10_Batch_Code__c;
                    } else if(sessGrade == 'Grade 11') {
                        BatchCode = con.G11_Batch_Code__c;
                    } else if(sessGrade == 'Grade 12') {
                        BatchCode = con.G12_Batch_Code__c;
                    }
                                                
                    system.debug('con : ' + con+' -- Batchcode : ' + BatchCode);
                    //List<picklistwrapper> tempresondata = new List<picklistwrapper>();
                    //tempresondata.addAll(resondata);
                    totalStudent++;
                    studentWrapper stdWrapp = new studentWrapper();
                    stdWrapp.studentId = con.Id;
                    stdWrapp.studentName = con.Name;
                    stdWrapp.whatsappnum = con.OtherPhone;
                    String stdCon = '';
                    if(String.isNotBlank(con.Phone)){
                        stdCon += con.Phone + ', ';
                    }
                    if(String.isNotBlank(con.MobilePhone)){
                        stdCon += con.MobilePhone;
                    }
                    stdCon = stdCon.removeEnd(', ');
                    stdWrapp.studentContact = stdCon;
                    //stdWrapp.sessionId = batchWithSessionIds.get(con.Batch_Code__c);
                    stdWrapp.sessionId = batchWithSessionIds.get(BatchCode);                    
                    //if(contactInSessionAttendanceMap.containsKey(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c))){
                    if(contactInSessionAttendanceMap.containsKey(con.Id+'_'+batchWithSessionIds.get(BatchCode))){
                        //if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Date__c != null){
                        if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Date__c != null){
                            //stdWrapp.counsellingDate = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Date__c;
                            stdWrapp.counsellingDate = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Date__c;
                        } else {
                            stdWrapp.counsellingDate = null;
                        }
                        
                        //if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Time__c != null){
                        if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Time__c != null){
                            //stdWrapp.counsellingTime = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Time__c;
                            stdWrapp.counsellingTime = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Time__c;
                        } else {
                            stdWrapp.counsellingTime = null;
                        }
                        
                        //if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Status__c != null){
                        if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Status__c != null){
                            //stdWrapp.status = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Status__c;                            
                            stdWrapp.status = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Status__c;                            
                        } else {
                            stdWrapp.status = '';
                        }
                        
                        //if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Counseling_Type__c != null){
                        if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Counseling_Type__c != null){
                            //stdWrapp.counselingType = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Counseling_Type__c;                            
                            stdWrapp.counselingType = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Counseling_Type__c;                            
                        } else {
                            stdWrapp.counselingType = 'In person';
                        }
                        
                        if(stdWrapp.counselingType == 'In person' || stdWrapp.counselingType ==  'Digital'){
                            stdWrapp.isParentVisible = false;
                            stdWrapp.isPhoneFieldsVisible = true;
                        } else if (stdWrapp.counselingType == 'Phone counseling') {
                            stdWrapp.isParentVisible = true;
                            stdWrapp.isPhoneFieldsVisible = false;
                        } else {
                            stdWrapp.isParentVisible = true;
                            stdWrapp.isPhoneFieldsVisible = true;
                        }
                        
                        /*if(String.isNotBlank(stdWrapp.status) && stdWrapp.status == 'Answered'){
                           stdWrapp.isVisible = false; 
                        } else {
                            stdWrapp.isVisible = true; 
                        }*/
                        
                        //if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Session__r.Attendance_Submitted__c){
                        if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Session__r.Attendance_Submitted__c){
                            stdWrapp.isAllVisible = true;   
                        } else {
                            stdWrapp.isAllVisible = false;   
                        }
                        
                        //if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Career_Aspiration__c != null){
                        if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Career_Aspiration__c != null){
                            //stdWrapp.careerAspiration = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Career_Aspiration__c;    
                            stdWrapp.careerAspiration = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Career_Aspiration__c;    
                        } else {
                            stdWrapp.careerAspiration = '';
                        }
                        
                        //stdWrapp.reason = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Reason__c;
                        //string s = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Reason__c;
                        string s = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Reason__c;
                       // system.debug(s);
                        
                        if(String.isNotBlank(s)){
                            //stdWrapp.reason = getSelectedReason(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Reason__c,getdynamicpicklistval('Session_Attendance__c', 'Reason__c'));   
                            stdWrapp.reason = getSelectedReason(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Reason__c,getdynamicpicklistval('Session_Attendance__c', 'Reason__c'));   
                            //system.debug('Selected Reson :: ' + stdWrapp.reason);
                            //stdWrapp.selectedReason = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Reason__c;
                            stdWrapp.selectedReason = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Reason__c;
                            //stdWrapp.seletedReasonList = seletedReasonList(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Reason__c);
                            stdWrapp.seletedReasonList = seletedReasonList(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Reason__c);
                        } else {
                            stdWrapp.reason = getdynamicpicklistval('Session_Attendance__c', 'Reason__c');
                            stdWrapp.seletedReasonList= new List<picklistwrapper>();
                            stdWrapp.selectedReason = '';
                        }
                        //if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).First_step_after_Class_10__c != null){
                        if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).First_step_after_Class_10__c != null){
                            //stdWrapp.firstStepAfter10 = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).First_step_after_Class_10__c;   
                            stdWrapp.firstStepAfter10 = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).First_step_after_Class_10__c;   
                        } else {
                            stdWrapp.firstStepAfter10 = '';
                        }
                        //if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Guardian_Parent_Attendance__c != null){
                        if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Guardian_Parent_Attendance__c != null){
                            //stdWrapp.selGuardianParentAtt = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Guardian_Parent_Attendance__c;   
                            stdWrapp.selGuardianParentAtt = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Guardian_Parent_Attendance__c;   
                        } else {
                            stdWrapp.selGuardianParentAtt = '';
                        }
                        //if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Attendance__c != null){
                        if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Attendance__c != null){
                            //stdWrapp.selStudentAtt = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Attendance__c;   
                            stdWrapp.selStudentAtt = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Attendance__c;   
                        } else {
                            stdWrapp.selStudentAtt = '';
                        }
                        
                        //stdWrapp.sessionAttedenceId = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Id;
                        stdWrapp.sessionAttedenceId = contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Id;
                    }
                    else{
                        stdWrapp.counsellingDate = null;
                        stdWrapp.counsellingTime = null;
                        stdWrapp.status = '';
                        stdWrapp.counselingType = 'In person';
                        //stdWrapp.studentContact = '';
                        
                        stdWrapp.isParentVisible = false;
                        stdWrapp.isPhoneFieldsVisible = true;
                        stdWrapp.isAllVisible = false;
                        //system.debug('%^%^%^%^ :: ' + contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)));
                        system.debug('Con Batch Code :: ' + con.Batch_Code__c + '----BatchCode :: '+BatchCode);
                        //if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)) != null){
                        if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)) != null){
                            //if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(con.Batch_Code__c)).Session__r.Attendance_Submitted__c){
                            if(contactInSessionAttendanceMap.get(con.Id+'_'+batchWithSessionIds.get(BatchCode)).Session__r.Attendance_Submitted__c){
                                stdWrapp.isAllVisible = true;   
                            } else {
                                stdWrapp.isAllVisible = false;   
                            }
                        }
                        stdWrapp.careerAspiration = '';
                        stdWrapp.reason = getdynamicpicklistval('Session_Attendance__c', 'Reason__c');
                        stdWrapp.firstStepAfter10 = '';
                        stdWrapp.selGuardianParentAtt = '';
                        stdWrapp.selStudentAtt = '';
                        stdWrapp.sessionAttedenceId = '';
                        stdWrapp.seletedReasonList= new List<picklistwrapper>();
                        stdWrapp.selectedReason = '';
                        
                    }
                    stdWrapperLST.add(stdWrapp);
                }
            }
        }
        
        String CounselingCount = '';
        
        //CounselingCount = accLST.get(0).X2021_22_Grade_10_counseling_completed__c;        		                    
        //result.put('totalStudent',totalStudent);
        //result.put('totalBatches',stdWrapperLST.size() / antarangSett.Max_Batch_Size__c);
        result.put('StdData',stdWrapperLST);
        //result.put('CounselingCount',CounselingCount);
        result.put('status',getdynamicpicklistval('Session_Attendance__c', 'Status__c'));
        result.put('counselingType',getdynamicpicklistval('Session_Attendance__c', 'Counseling_Type__c'));
        result.put('careerAspiration',getdynamicpicklistval('Session_Attendance__c', 'Career_Aspiration__c'));
        result.put('reason',getdynamicpicklistval('Session_Attendance__c', 'Reason__c'));
        result.put('firstStepAfterClass10',getdynamicpicklistval('Session_Attendance__c', 'First_step_after_Class_10__c'));
        result.put('guardianParentAttend',getdynamicpicklistval('Session_Attendance__c', 'Guardian_Parent_Attendance__c'));
        result.put('studentAttend',getdynamicpicklistval('Session_Attendance__c', 'Attendance__c'));
        return result;
    }
    
    public static List<picklistwrapper> getSelectedReason(String selectedReason,List<picklistwrapper> resondata){
        List<String> selList = selectedReason.split(';');
      //  system.debug('selList : ' + selList);
        for(picklistwrapper pick : resondata){
            for(String str : selList) {
                if(str == pick.value){
                    pick.selected = true;
                }
            }
        }
        return resondata;
    }
    
    
    public static List<picklistwrapper> seletedReasonList(String seletedReason){
        List<picklistwrapper> selectedList = new List<picklistwrapper>();
        if(seletedReason != null){
            
            List<string> tempList = seletedReason.split(';');
            for(string s : tempList){
                //selectedList.add('{"value":'+s+',"label":'+s+'}');
               selectedList.add( new picklistwrapper(s, s, false));
            }
            return selectedList;
        }
        return selectedList;
    }

    
    @AuraEnabled
    public static void saveCounselling(String counsellingWrap){
        
        List<studentWrapper> wrapDataToUpdate = (List<studentWrapper>)System.JSON.deserialize(counsellingWrap, List<studentWrapper>.class);
        
        List<Session_Attendance__c> sessionAttendancesToUpsert = new List<Session_Attendance__c>();
        List<Contact> conLST = new List<Contact>();
        for(studentWrapper objWrap : wrapDataToUpdate){
            if(String.isNotBlank(objWrap.whatsappnum)){
                Contact con = new Contact();
                con.Id = objWrap.studentId;
                con.OtherPhone = objWrap.whatsappnum;
                conLST.add(con);   
            }
            
            Session_Attendance__c objSA = new Session_Attendance__c();
            if(objWrap.sessionAttedenceId != ''){
                objSA.Id = objWrap.sessionAttedenceId;
            }
            objSA.Date__c = objWrap.counsellingDate;
            objSA.Time__c = objWrap.counsellingTime;
            objSA.Counseling_Type__c = objWrap.counselingType;
            if(objWrap.counselingType == 'In person' || objWrap.counselingType == 'Digital'){
                objSA.Guardian_Parent_Attendance__c = objWrap.selGuardianParentAtt;
                objSA.Attendance__c = objWrap.selStudentAtt;
                objSA.Status__c = '';
                objSA.Career_Aspiration__c = '';
                objSA.Reason__c = '';
                objSA.First_step_after_Class_10__c = '';
            } 
            
            if(objWrap.counselingType == 'Phone counseling'){
                objSA.Status__c = objWrap.status;
                objSA.Career_Aspiration__c = objWrap.careerAspiration;
                objSA.Reason__c = objWrap.selectedReason;
                objSA.First_step_after_Class_10__c = objWrap.firstStepAfter10;
                objSA.Guardian_Parent_Attendance__c = '';
            }
            if(objWrap.sessionAttedenceId == ''){
                objSA.Contact__c = objWrap.studentId;
                objSa.Session__c = objWrap.sessionId;
            }
            
            sessionAttendancesToUpsert.add(objSA);
        }
        
        if(sessionAttendancesToUpsert.size()>0){
            try{
            	upsert sessionAttendancesToUpsert;
            }catch(DmlException e) {
    			System.debug('The following exception has occurred: ' + e.getMessage());
			}
            // return fetchStudent();
        }
        
        if(conLST.size() > 0){
            //update conLST;
            updateContactOtherPhoneForCounseling bc = new updateContactOtherPhoneForCounseling(conLST);
            Id batchId = Database.executeBatch(bc, 25);
        }
        //return fetchStudent(schoolId,sessGrade);
    }
    
    public static List<picklistwrapper> getdynamicpicklistval(String objectName,String fieldName){
        List<picklistwrapper> options = new List<picklistwrapper>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult r = s.getDescribe();
        Map<String, Schema.SObjectField> fields = r.fields.getMap();
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        options.add(new picklistwrapper('--None--', '',false));
        for (Schema.PicklistEntry pickListVal : ple) {
            if(objectName == 'Batch__c' && fieldName == 'Grade__c'){
                //enable for all grades 18/4/2024
                //if(String.valueOf(pickListVal.getValue()) != 'Grade 10'){
                    options.add(
                        new picklistwrapper(pickListVal.getLabel(), String.valueOf(pickListVal.getValue()), false)
                    );
                //}
            } else {
                options.add(
                    new picklistwrapper(pickListVal.getLabel(), String.valueOf(pickListVal.getValue()), false)
                );   
            }
        }
        return options;
    }
    
    
    
    public class picklistwrapper {
        @AuraEnabled
        public String label { get; set; }
        
        @AuraEnabled
        public String value { get; set; }
        
        @AuraEnabled
        public boolean selected { get; set; }
        
        public picklistwrapper(String label, String value, Boolean selected) {
            this.label = label;
            this.value = value;
            this.selected = false;
        }
    }
    
    public class studentWrapper {
        @AuraEnabled
        public string studentId;
        
        @AuraEnabled
        public string studentName;
        
        @AuraEnabled
        public string studentContact;
        
        @AuraEnabled
        public string whatsappnum;
        
        @AuraEnabled
        public string sessionId;
        
        @AuraEnabled
        public date counsellingDate;
        
        @AuraEnabled
        public time counsellingTime;
        
        @AuraEnabled
        public string status;
        
        @AuraEnabled
        public string counselingType;
        
        /*@AuraEnabled
        public Boolean isVisible;*/
        
        @AuraEnabled
        public Boolean isAllVisible;
        
        @AuraEnabled
        public Boolean isParentVisible;
        
        @AuraEnabled
        public Boolean isPhoneFieldsVisible;
        
        @AuraEnabled
        public string careerAspiration;
        
        @AuraEnabled
        public List<picklistwrapper> reason;
        
         @AuraEnabled
        public String selectedReason;
        
         @AuraEnabled
        public List<picklistwrapper> seletedReasonList;
        
        @AuraEnabled
        public string firstStepAfter10;
        
        @AuraEnabled
        public string selGuardianParentAtt;
        
        @AuraEnabled
        public string selStudentAtt;
        
        @AuraEnabled
        public string sessionAttedenceId;
        
        
    }
    
}