global class BatchAllocationEmailToFacilitator {
    
    public id ContactId {get;set;}
    public static boolean isError {get;set;}
    public static string errorMsg {get;set;}
    public boolean showSuccessMsg {get;set;} 
    public List<Batch__c> updateBatchList = new List<Batch__c>();    
    
    public BatchAllocationEmailToFacilitator(ApexPages.StandardController controller) {
        ContactId = controller.getId();
        isError = false;
        showSuccessMsg =false;
    }
    
    public PageReference sendBatchAllocationEmail() {
        //system.debug('t');
        List<Contact> lstContact = [SELECT Id, npe01__WorkEmail__c FROM Contact WHERE Id =: ContactId AND npe01__WorkEmail__c != null Limit 1];
        system.debug('t = '+ContactId);
        system.debug('t = lstContact '+lstContact);
        if (lstContact.size() > 0) {
            
            List<Messaging.SingleEmailMessage> lstEmailMesages = sendMail(ContactId);
            //system.debug('t');
            if (lstEmailMesages != null) {
                system.debug('t');
                Messaging.SendEmailResult[] results = Messaging.sendEmail(lstEmailMesages);
                if (results[0].success) {
                    //system.debug('t');
                    // System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: '
                                 + results[0].errors[0].message);
                }
            }
            if (isError) {
                return null;
            } else {
                showSuccessMsg = true;
            }
        }else{
            isError = true;
            errorMsg = 'Work Email is not Populated.';
        }
        return null;
    }
    
    public pageReference backToContact(){
        PageReference pg = new PageReference('/' + ContactId);
        pg.setRedirect(true);
        return pg;
    }
    
    public static List<Messaging.SingleEmailMessage> sendMail(id ContactId) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Map<Id, Batch__c> updateBatchMap = new Map<Id, Batch__c>();
        Map<Id, Account> schoolMap = new Map<Id, Account>();
        
        Contact lstContact = [SELECT Id, Academic_Year__c, npe01__WorkEmail__c FROM Contact WHERE Id =: ContactId Limit 1];
        Map<Id,List<Batch__c>> accountToBatchLst = new Map<Id,List<Batch__c>>();
        Map<String,List<String>> gradeAccountToBatchNumberLst = new Map<String,List<String>>();
        
        Decimal CurrentAcademicYear = AntarangSetting__c.getOrgDefaults().Academic_Year__c;
        Decimal NextAcadYear = AntarangSetting__c.getOrgDefaults().Next_Academic_Year__c;
        Decimal Acadyear;
        System.debug('CurrentAcademicYear--'+CurrentAcademicYear+' NextAcadYear--'+NextAcadYear+' Cont--'+lstContact.Academic_Year__c);
        if(lstContact.Academic_Year__c != CurrentAcademicYear && lstContact.Academic_Year__c != NextAcadYear){
            isError = true;
            errorMsg = 'Facilitator is inactive for this year.';
            return null;
        } else {
            Acadyear = lstContact.Academic_Year__c;
        }
        system.debug('Academic Year----'+Acadyear);
        Schema.DescribeFieldResult objFieldDescribe = Batch__c.Grade__c.getDescribe();
        Map<String, String> grades = new Map<String, String>(); 
        for (Schema.PicklistEntry objPickList : objFieldDescribe.getPickListValues()) {
            //System.debug('Value = ' +objPickList.getValue() +' , Label = ' +objPickList.getLabel());
            grades.put(objPickList.getValue(), objPickList.getLabel());
        }
        
        try { 
            List<Batch__c> lstBatch = [SELECT Id, Name, Grade__c, Allocation_Email_Sent__c, Trainer_Name__c,  Trainer_Name__r.Name, Trainer_Name__r.Email, Trainer_Name__r.FirstName, Trainer_Name__r.LastName, Followup_1_Trainer_Name__r.MobilePhone,
                                       School_Name__r.Tagged_for_Counselling__c, School_Name__r.School_Timing__c, School_Name__r.Address__c, School_Name__r.Medium_Language_of_Instruction__c, Preferred_Language__c, Date_of_facilitation_starting__c, Date_of_facilitation_completion__c,School_Name__r.No_of_Students_for_Fup_20_21__c,
                                       School_Name__r.Est_Number_of_Students_in_Grade_9_19_20__c, Batch_Number__c, School_Name__c, Followup_1_Trainer_Name__r.id, Followup_1_Trainer_Name__r.name, Number_of_students_facilitated1__c,
                                       School_Name__r.School_Location__c, School_Name__r.Principal_Name__c, School_Name__r.Name, Date_of_1st_Follow_up_session__c, Followup_1_Trainer_Name__r.Email,
                                       School_Name__r.Phone, School_Name__r.Principal_Contact_2__c, School_Name__r.Principal_Contact_3__c, School_Name__r.Estimated_Number_Of_Students__c, 
                                       School_Name__r.Enrolled_Grade_9__c, School_Name__r.Enrolled_Grade_10__c, School_Name__r.Enrolled_Grade_11__c, School_Name__r.Enrolled_Grade_12__c,
                                       Extra_Followup_1_Trainer_Name__c, Extra_Followup_1_Trainer_Name__r.Name, Extra_Followup_1_Trainer_Name__r.Email,Combined_Batch_no_for_G10__c,
                                       School_Name__r.School_Coordinator_Name__c, School_Name__r.School_Coordinator_Contact__c, School_Name__r.College_Coordinator_Name__c, School_Name__r.College_Coordinator_Contact__c
                                       FROM Batch__c
                                       WHERE Allocation_Email_Sent__c = null //AND Academic_Year__c =:CurrentAcademicYear                                       
                                       //AND School_Name__r.Academic_Year__c =:CurrentAcademicYear
                                       //AND Trainer_Name__r.Academic_Year__c =:CurrentAcademicYear
                                       AND Academic_Year__c =: Acadyear
                                       AND School_Name__r.Academic_Year__c =:Acadyear
                                       AND Trainer_Name__r.Academic_Year__c =:Acadyear
                                       AND Trainer_Name__c =: ContactId ];
            
            if (lstBatch.size() < 1) {
                isError = true;
                errorMsg = 'No Batches assigned.';
                return null;
            }
            
            for (Batch__c bcth: lstBatch) {
                bcth.Allocation_Email_Sent__c = system.now();
                if(accountToBatchLst.containsKey(bcth.School_Name__c)){
                    List<Batch__c> b = accountToBatchLst.get(bcth.School_Name__c);
                    b.addAll(new List<Batch__c>{bcth});
                    accountToBatchLst.put(bcth.School_Name__c, b );                    
                }else if(!accountToBatchLst.containsKey(bcth.School_Name__c) ){
                    accountToBatchLst.put(bcth.School_Name__c, new List<Batch__c>{bcth} );
                }
                
                if(gradeAccountToBatchNumberLst.containsKey(bcth.School_Name__c+'_'+bcth.Grade__c)){
                    List<String> b1 = gradeAccountToBatchNumberLst.get(bcth.School_Name__c+'_'+bcth.Grade__c);
                    //system.debug('bn b1 - : '+b1);
                    b1.addAll(new List<String>{bcth.Batch_Number__c});
                    //system.debug('bn b1 - : '+b1);
                    gradeAccountToBatchNumberLst.put(bcth.School_Name__c+'_'+bcth.Grade__c, b1 );
                    //system.debug('bn if : '+bcth.Batch_Number__c);
                }else if(!gradeAccountToBatchNumberLst.containsKey(bcth.School_Name__c+'_'+bcth.Grade__c) ){
                    gradeAccountToBatchNumberLst.put(bcth.School_Name__c+'_'+bcth.Grade__c, new List<String>{bcth.Batch_Number__c} );
                }
            }
            
            
            
            for (Id bcth: accountToBatchLst.keySet()){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                string ccEmails = System.Label.Batch_Details_CC_Emails;
                List<String> sendingTocAdd = new List<String>();
                if(String.isNotBlank(ccEmails))
                {
                    sendingTocAdd = ccEmails.split(';');
                }
                if(sendingTocAdd.size() > 0)
                {
                    email.setCcAddresses(sendingTocAdd);   
                }
                email.toAddresses = new String[] { lstContact.npe01__WorkEmail__c };
                    email.subject = 'Batch Allocation Email for Academic Year - '+Acadyear;
                 String owa = [select id, Address, DisplayName from OrgWideEmailAddress where Address='sfcareeraware@antarangfoundation.org'].Id;
                     email.setOrgWideEmailAddressId(owa);
                string EmailBody = '';
                
                if(EmailBody == ''){
                    EmailBody = EmailBody+'<Div style="font-size: small;">Dear <b>'+accountToBatchLst.get(bcth)[0].Trainer_Name__r.Name+'</b><br/><br/>';
                    EmailBody = EmailBody+'Please find below the school details.<br/><br/>';
                }
                
                String SchoolName = accountToBatchLst.get(bcth)[0].School_Name__r.Name != null?accountToBatchLst.get(bcth)[0].School_Name__r.Name:'';               
                String PrincipalsContact = accountToBatchLst.get(bcth)[0].School_Name__r.Phone == null?'':accountToBatchLst.get(bcth)[0].School_Name__r.Phone;
                String PrincipalName = accountToBatchLst.get(bcth)[0].School_Name__r.Principal_Name__c == null?'':accountToBatchLst.get(bcth)[0].School_Name__r.Principal_Name__c;
                String Address = accountToBatchLst.get(bcth)[0].School_Name__r.School_Location__c == null?'':accountToBatchLst.get(bcth)[0].School_Name__r.School_Location__c;
                String Language = accountToBatchLst.get(bcth)[0].School_Name__r.Medium_Language_of_Instruction__c == null?'':accountToBatchLst.get(bcth)[0].School_Name__r.Medium_Language_of_Instruction__c;
                String SchoolTiming = accountToBatchLst.get(bcth)[0].School_Name__r.School_Timing__c == null?'':accountToBatchLst.get(bcth)[0].School_Name__r.School_Timing__c;
                String EligibleforCounseling = accountToBatchLst.get(bcth)[0].School_Name__r.Tagged_for_Counselling__c == null?'':accountToBatchLst.get(bcth)[0].School_Name__r.Tagged_for_Counselling__c;
                String SchoolCoordinatorName = accountToBatchLst.get(bcth)[0].School_Name__r.School_Coordinator_Name__c == null?'':accountToBatchLst.get(bcth)[0].School_Name__r.School_Coordinator_Name__c;
                String SchoolCoordinatorContact = accountToBatchLst.get(bcth)[0].School_Name__r.School_Coordinator_Contact__c == null?'':accountToBatchLst.get(bcth)[0].School_Name__r.School_Coordinator_Contact__c;
                String CollegeCoordinatorName = accountToBatchLst.get(bcth)[0].School_Name__r.College_Coordinator_Name__c == null?'':accountToBatchLst.get(bcth)[0].School_Name__r.College_Coordinator_Name__c;
                String CollegeCoordinatorContact = accountToBatchLst.get(bcth)[0].School_Name__r.College_Coordinator_Contact__c == null?'':accountToBatchLst.get(bcth)[0].School_Name__r.College_Coordinator_Contact__c;                
                
                EmailBody = EmailBody+ 'Name of the School : '+ SchoolName +'<br/>Principal\'s Contact : '+ PrincipalName +'-'+ PrincipalsContact +'<br/>Address : '+ Address +'<br/>Language : '+ Language +'<br/>School Time : '+ SchoolTiming +'<br/>Eligible for Counseling : '+ EligibleforCounseling 
                    +'<br/>School Coordinator Name : '+ SchoolCoordinatorName +'<br/>School Coordinator Contact : '+ SchoolCoordinatorContact +'<br/>College Coordinator Name : '+ CollegeCoordinatorName +'<br/>College Coordinator Contact : '+ CollegeCoordinatorContact +'<br/>Academic Year : '+ Acadyear ;
                
                if(!gradeAccountToBatchNumberLst.ContainsKey(bcth+'_')){ 
                    EmailBody = EmailBody+'<br/><br/> <table style=" background-repeat:no-repeat; width:450px;margin:0; border-collapse: collapse;" cellspacing="10" cellpadding="0"  border="1"><tr><td align="center"> <b>Grade</b> </td> <td align="center" width="50%"> <b>No. of Enrolled Students</b> </td> <td align="center"> <b>Batch Numbers</b></td> </tr>';
                }
                
                for(String grade :grades.keySet()){
                    String str = gradeAccountToBatchNumberLst.ContainsKey(bcth+'_'+grade)?String.join(gradeAccountToBatchNumberLst.get(bcth+'_'+grade), ', '):''; 
                    //system.debug('tt : '+str);
                    if(gradeAccountToBatchNumberLst.ContainsKey(bcth+'_'+grade) && gradeAccountToBatchNumberLst.get(bcth+'_'+grade).size() > 0 ){ 
                        String enrolledForGrade ='';
                        switch on grade.replaceAll('[^0-9]','') {
                            when '9' {enrolledForGrade = String.valueOf(accountToBatchLst.get(bcth)[0].School_Name__r.Enrolled_Grade_9__c);}	
                            when '10' {enrolledForGrade = String.valueOf(accountToBatchLst.get(bcth)[0].School_Name__r.Enrolled_Grade_10__c);}
                            when '11' {enrolledForGrade = String.valueOf(accountToBatchLst.get(bcth)[0].School_Name__r.Enrolled_Grade_11__c) ; }
                            when '12' {enrolledForGrade = String.valueOf(accountToBatchLst.get(bcth)[0].School_Name__r.Enrolled_Grade_12__c);}
                            when else{
                                enrolledForGrade = '';
                            }
                        }
                        if(enrolledForGrade == null){enrolledForGrade = '';}
                        EmailBody = EmailBody +'<tr><td align="center">'+ grade.replaceAll('[^0-9]', '') +'<td align="center">'+enrolledForGrade+'</td>'+' </td>'+'<td align="center">'+ str+' </td></tr>'; 
                    }
                }
                
                EmailBody = EmailBody+'</table> <br/>';
                EmailBody = EmailBody+'<i><p>(PS:- Final no. of batches to be considered for payment will depend upon the actual number of students attending the sessions and not as per the numbers mentioned above.)</p><p style="color:red"> This is an auto-generated email. Please do not reply to it. In case of any concerns or queries, please contact the Program Team </p></i><br/> Thanks and Regards, <br/>Program Team <br/></Div>';
                email.setHtmlBody(EmailBody);
                emails.add(email);
            }
           
            update lstBatch;
            return emails;
        } catch (Exception ex){
            //system.debug('fdgfg : '+ex);
            apexpages.addmessages(ex);
            return null;
        }
    }
    
}