public with sharing class SendEmailToFollowupTrainer {
    public id AccountId;
    public boolean isError {get;set;}
    public boolean showSuccessMsg {get;set;}
    
    public SendEmailToFollowupTrainer(ApexPages.StandardController controller) {
        AccountId = controller.getId();
        isError = false;
        showSuccessMsg =false;
    }
    public PageReference sendEmailToOneFollowTrainer() {
        List <Account> lstAccount = [SELECT Id FROM Account WHERE Id =: AccountId Limit 1];
        if (lstAccount.size() > 0) {
            List <Messaging.SingleEmailMessage> lstEmailMesages = sendMail(AccountId);
            if (lstEmailMesages.size() > 0) {
                Messaging.sendEmail(lstEmailMesages);
            }
            if (isError) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Trainer is not available or Email is not populated.'));
                return null;
            } else {
                showSuccessMsg = true;
                /*ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Email sent'));
                PageReference pg = new PageReference('/' + AccountId);
                pg.setRedirect(true);
                return null;*/
            }
        }
        return null;
    }
    
    public pageReference backToAccount(){
        PageReference pg = new PageReference('/' + AccountId);
        pg.setRedirect(true);
        return pg;
    }
    
    public List<Messaging.SingleEmailMessage> sendMail(id Accid) {
        List<Messaging.SingleEmailMessage> lstEmailMesages = new List<Messaging.SingleEmailMessage>();
        try { 
            String BatchList = '';
            string strBatchDetails = '';
            List<String> childBatchList = New List<String>();
            map<id, list <batch__c>> mapofBatchesTrainerWise = new map <id, list<batch__c>>();
            map<String, String> childBatchMap = new map<String, String>();
            Boolean hasCombinedBatch = false;
            List<AggregateResult> contactCountList = [Select count(id) contCount
                                    From Contact
                                    Where Batch_Code__r.School_Name__c =: Accid];
            Integer contactCount = (Integer) contactCountList[0].get('contCount');
            List<Batch__c> lstBatch = [SELECT Id, Trainer_Name__c, Trainer_Name__r.Email, Trainer_Name__r.FirstName, Trainer_Name__r.LastName, Followup_1_Trainer_Name__r.MobilePhone,
                                       School_Name__r.Medium_Language_of_Instruction__c, Preferred_Language__c, Date_of_facilitation_starting__c, Date_of_facilitation_completion__c,School_Name__r.No_of_Students_for_Fup_20_21__c,
                                       School_Name__r.Est_Number_of_Students_in_Grade_9_19_20__c, Batch_Number__c, School_Name__c, Followup_1_Trainer_Name__r.id, Followup_1_Trainer_Name__r.name, Number_of_students_facilitated1__c,
                                       School_Name__r.School_Location__c, School_Name__r.Principal_Name__c, School_Name__r.Name, Date_of_1st_Follow_up_session__c, Followup_1_Trainer_Name__r.Email,
                                       School_Name__r.Phone, School_Name__r.Principal_Contact_2__c, School_Name__r.Principal_Contact_3__c, School_Name__r.Estimated_Number_Of_Students__c,
                                       Extra_Followup_1_Trainer_Name__c, Extra_Followup_1_Trainer_Name__r.Name, Extra_Followup_1_Trainer_Name__r.Email,Combined_Batch_no_for_G10__c
                                       FROM Batch__c
                                       WHERE School_Name__c =: Accid AND Followup_1_Trainer_Name__c != null AND 
                                       Followup_1_Trainer_Name__r.Email != null AND Date_of_1st_Follow_up_session__c != null AND Date_of_1st_Follow_up_session__c >: system.today() Order by Date_of_1st_Follow_up_session__c Asc ];
            for (Batch__c bcth: lstBatch) {
                BatchList+=bcth.Batch_Number__c+', ';
                system.debug('inside Batch '+bcth.Batch_Number__c);
                if (mapofBatchesTrainerWise.containsKey(bcth.Followup_1_Trainer_Name__c)) {
                    List <batch__c> Listbcth = mapofBatchesTrainerWise.get(bcth.Followup_1_Trainer_Name__c);
                    Listbcth.add(bcth);
                    mapofBatchesTrainerWise.put(bcth.Followup_1_Trainer_Name__c, Listbcth);
                } else {
                    mapofBatchesTrainerWise.put(bcth.Followup_1_Trainer_Name__c, new List<batch__c>{bcth});
                }
                /*if(bcth.Extra_Followup_1_Trainer_Name__c != null) {
                    if (mapofBatchesTrainerWise.containsKey(bcth.Extra_Followup_1_Trainer_Name__c)) {
                        List <batch__c> Listbcth = mapofBatchesTrainerWise.get(bcth.Extra_Followup_1_Trainer_Name__c);
                        Listbcth.add(bcth);
                        mapofBatchesTrainerWise.put(bcth.Extra_Followup_1_Trainer_Name__c, Listbcth);
                    } else {
                        mapofBatchesTrainerWise.put(bcth.Extra_Followup_1_Trainer_Name__c, new List<batch__c>{bcth});
                    }
                }*/
                if(bcth.Combined_Batch_no_for_G10__c != null && bcth.Combined_Batch_no_for_G10__c != '' ) {
                    //childBatchList = bcth.Combined_Batch_no_for_G10__c.split(','); 
                    childBatchList.addAll(bcth.Combined_Batch_no_for_G10__c.split(','));
                }
            }
            if(childBatchList.size()>0) {
                List<Batch__c> lstChildBatch = [Select Id,Name,School_Name__c,Batch_Number__c,School_Name__r.Name
                                                From Batch__c
                                                Where Batch_Number__c IN: childBatchList];    
                if(lstChildBatch.size()>0) {
                    for(Batch__c b: lstChildBatch) {
                        childBatchMap.put(b.Batch_Number__c, b.School_Name__r.Name);
                    }                    
                }
            }       
            BatchList = BatchList.removeEndIgnoreCase(', ');
            string strSchoolDetails = '';
            string betweenline ='';
            string betweenline1 ='';
            if(lstBatch.size() > 0) {
                string[] Phone = new string[] {};
                if(lstBatch[0].School_Name__r.Phone != null){
                    Phone.add(lstBatch[0].School_Name__r.Phone);
                }
                if(lstBatch[0].School_Name__r.Principal_Contact_2__c != null){
                    Phone.add(lstBatch[0].School_Name__r.Principal_Contact_2__c);
                    }
                if(lstBatch[0].School_Name__r.Principal_Contact_3__c != null){
                    Phone.add(lstBatch[0].School_Name__r.Principal_Contact_3__c );
                }
                //betweenline = '<p><b>Please find below the details of your Follow-up Conference Call sessions:</b></p>';
                betweenline = '<p><b>Please find below the details of your Grade 10 sessions :</b></p>';
                
                strSchoolDetails= '<br/><table border="1" style ="border-collapse: collapse; width: 600px;"><tr><td align="left"><b>School</b></td><td align="left">&nbsp;&nbsp;' + (lstBatch[0].School_Name__r.Name != null ? lstBatch[0].School_Name__r.Name : '') + '</td>';
                //strSchoolDetails += '<tr><td align="left"><b> Antarangs Point of Contact</b> </td><td align="left">&nbsp;&nbsp;' + (lstBatch[0].School_Name__r.Principal_Name__c != null ? lstBatch[0].School_Name__r.Principal_Name__c : '') + '</td></tr>';
                strSchoolDetails += '<tr><td align="left"> <b>Principals Contact</b></td><td align="left">&nbsp;&nbsp;' + (lstBatch[0].School_Name__r.Principal_Name__c != null ? lstBatch[0].School_Name__r.Principal_Name__c : '')+' '+ '-' +' '+ Phone + '</td></tr>';
                strSchoolDetails += '<tr><td align="left"><b>School Medium</b></td><td align="left">&nbsp;&nbsp;' + (lstBatch[0].School_Name__r.Medium_Language_of_Instruction__c != null ? lstBatch[0].School_Name__r.Medium_Language_of_Instruction__c : '') + '</td></tr>';
                strSchoolDetails += '<tr><td align="left"><b>Enrolled Students</b></td><td align="left">&nbsp;&nbsp;' + contactCount + '</td></tr>';
                //strSchoolDetails += '<tr><td align="left"><b>Number of Students</b></td><td align="left">&nbsp;&nbsp;'+(lstBatch[0].School_Name__r.No_of_Students_for_Fup_20_21__c != null ? String.valueof(lstBatch[0].School_Name__r.No_of_Students_for_Fup_20_21__c) : '')+'</td></tr>';
                strSchoolDetails += '<tr><td align="left"><b>Batch Code</b></td><td align="left">&nbsp;&nbsp;'+BatchList+'</td></tr>';
                strSchoolDetails += '</table><br>';               
              //  betweenline1 = '<p><b>Please find your batch details below:</b></p>';
            }
            for (Id TrainerId: mapofBatchesTrainerWise.keyset()) {
                strBatchDetails = '';
                strBatchDetails += '<table border="1" style ="border-collapse: collapse; width: 600px;"><caption>Combined Batch Details</caption><tr><th>Main Batch</th><th>Combined Batch</th><th>School Name</th></tr>';            
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                //email.setSubject('School Details for Follow-up Conference Calls');
                email.setSubject('School Details for grade 10 sessions');
                string TrainerName = '';
                List<string> TrainerEmail = new List<string>();
              //  string BatchDetails = '';
                
              //  BatchDetails = '<table border="1" style ="border-collapse: collapse; width: 600px;"><tr><th align="left">Batch Code</th><th align="left">Start Date</th><th align="left">End Date</th><th align="left">Trainer Name</th><th align="left">Extra Trainer Name*</th></tr>';
                //Decimal NumberofStudentsForEachTrainer = 0;
                Integer BatchSrNo = 1;                
                for (Batch__c bcth: mapofBatchesTrainerWise.get(TrainerId)) {
                    if(string.isblank(TrainerName)){
                        TrainerName = 'Dear' + ' ' + bcth.Followup_1_Trainer_Name__r.name + ',';
                    }
                    
                   // BatchDetails += '<tr><td align="left">' + (bcth.Batch_Number__c != null ? bcth.Batch_Number__c : '') + '</td>';
                  //  BatchDetails += '<td align="left">' + (String.valueof(bcth.Date_of_1st_Follow_up_session__c) != null ? convertdate(bcth.Date_of_1st_Follow_up_session__c) : '') + '</td>';
                 //   BatchDetails += '<td align="left"> Within 3 working days (including start date)</td>';
                 //   BatchDetails += '<td align="left">' + (bcth.Followup_1_Trainer_Name__r.name != null ? bcth.Followup_1_Trainer_Name__r.name : '') + '</td>';
                 //   BatchDetails += '<td align="left">' + (bcth.Extra_Followup_1_Trainer_Name__r.Name != null ? bcth.Extra_Followup_1_Trainer_Name__r.Name : '') + '</td>';
                    //batchdetail  +='</tr></table>';
                    if (String.IsNotBlank(bcth.Followup_1_Trainer_Name__r.Email)) {
                        TrainerEmail.add(bcth.Followup_1_Trainer_Name__r.Email);
                    }
                    if (bcth.Extra_Followup_1_Trainer_Name__c != null && String.IsNotBlank(bcth.Extra_Followup_1_Trainer_Name__r.Email)) {
                        TrainerEmail.add(bcth.Extra_Followup_1_Trainer_Name__r.Email);
                    }                    
                    if(bcth.Combined_Batch_no_for_G10__c != null) {
                        hasCombinedBatch = true;
                        List<String> combineBatchList = bcth.Combined_Batch_no_for_G10__c.split(',');
                        Integer childBatchSrNo = 1;
                        for(String childBatch: combineBatchList) {System.debug('strBatchDetails first '+strBatchDetails);
                            if(childBatchMap.containsKey(childBatch)) {
                                String child = childBatch;
                                String school = childBatchMap.get(childBatch);
                                strBatchDetails += '<tr><td align="center">' + 'Main Batch-'+BatchSrNo+' ('+bcth.Batch_Number__c +' )'+ '</td><td align="center">' + 'Combined Batch-'+childBatchSrNo+' ('+childBatch + ' )' +'</td><td align="center">' + school + '</td></tr>';                                
                                childBatchSrNo++;
                            }
                        }                        
                    }
                    BatchSrNo++;
                }
                strBatchDetails += '</table>';
              //  BatchDetails += '</tr></table>';
                //strSchoolDetails = strSchoolDetails.replace('{NumberofStudents}',string.valueof(NumberofStudentsForEachTrainer));
                string EmailBody = '';
                if(hasCombinedBatch == true) {
                    EmailBody = TrainerName + betweenline +strSchoolDetails + betweenline1 + strBatchDetails + staticEmailContent();
                }
                else {
                    EmailBody = TrainerName + betweenline +strSchoolDetails + betweenline1 /*+BatchDetails*/ + staticEmailContent();
                }                
                String[] sendingTo = TrainerEmail;
                string ccEmails = System.Label.Follow_up_Email_cc;
                List<String> sendingTocAdd = new List<String>();
                if(String.isNotBlank(ccEmails))
                {
                    sendingTocAdd = ccEmails.split(';');
                }
                if(sendingTocAdd.size() > 0)
                {
                email.setCcAddresses(sendingTocAdd);   
                }
                email.setToAddresses(sendingTo);
                email.setHtmlBody(EmailBody);
                lstEmailMesages.add(email);
            }
            
        } catch (Exception ex){
            apexpages.addmessages(ex);
            return null;
        }
        return lstEmailMesages;
    }
    public string convertdate(date dt) {
        String dateFormatString = 'dd MMM YYYY';
        Date d = dt;
        Datetime dtt = Datetime.newInstance(d.year(), d.month(), d.day());
        String dateString = dtt.format(dateFormatString);
        System.debug(dateString);
        return dateString;
    }
    
    public string staticEmailContent(){
        string docid ='';
        
        list<Document> doc = [select Id, DeveloperName from Document Where DeveloperName = 'Antarang_Logos' LIMIT 1];
        if(doc.size() > 0){
          docid = doc[0].id;
        }
        string strOrgId = UserInfo.getOrganizationId();
        String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm();

        //System.debug('body'+body);
        /*string staticlines = '<p><b><i>*If your name is also mentioned as Extra Trainer Name in the above table, consider two batches for the same batch code.</i></b></p><br/>';
        staticlines += '<p><b>You are requested to:</b></p>';
        staticlines += '<ul>';
        staticlines += '<li>Find the Student Contact List for all the batches assigned to you <a href="https://drive.google.com/drive/folders/1H-TbpcJmTUiR2uAY2OFil01tkUsDpCtX?usp=sharing">in this folder.</a></li>';
        staticlines += '<li>Contact the Principal after you are assigned a batch, to initiate communication with the school</li>';
        staticlines += '<li>Contact all students in advance using individual calls and ensure each student has been assigned a Conference Call slot</li>';
        staticlines += '<li>Before the Conference Calls, share the list of unreachable students with the Principal, and request him/her to share valid phone numbers (if any).</li>';
        staticlines += '<li>Invite the Principal and/or School Teachers to observe any of the conference calls by sharing the schedule with them.</li>';
        staticlines += '<li>Keep in mind that you may be contacted by the Antarang Team for observation of your session, to support you.</li>';
        staticlines += '<li>In case of any changes in your schedule, immediately inform the Operations Team and the Principal.</li>';
        staticlines += '<li>After all the batches assigned to you on this email are completed, use <a href="https://docs.google.com/forms/d/e/1FAIpQLSfXr2c1s0NMR5WJVKbfTumf_f9CRYqpxDR_hcdAEYVehVdFVA/viewform">this form.</a>to submit the Student Responses Excel file as well as the Consultancy Bill(s). Please do this within 3 days from your last conference call of the school.</li>';
        staticlines += '<li>Refer to <a href="https://drive.google.com/drive/folders/1YTl8znn8yWhXqSycq1IvdRpdSep9Ef0F">this folder.</a> for Follow-up Resources</li>';
        
        staticlines += '</ul>';*/
        
        string staticlines = '<p><b><i>**This is an auto-generated email. Please do not reply to it. In case of any concerns, challenges, or queries, please contact the Operations Team directly.**</i></b></p>';
        staticlines += '<br/><br/>Wishing you a great week,<br/>CareerAware Operations Team';
        staticlines += '<br/><br/><img src="'+fullRecordURL+'/servlet/servlet.ImageServer?id='+docid+'&'+'oid='+strOrgId+'"/><hr/>';
        
        return staticlines;
        
    }
}