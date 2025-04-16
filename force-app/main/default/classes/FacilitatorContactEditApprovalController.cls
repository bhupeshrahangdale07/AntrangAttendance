public without sharing class FacilitatorContactEditApprovalController {
    
    @AuraEnabled(cacheable=true)
    public static Decimal getAcademicYear(){
        return AntarangSetting__c.getOrgDefaults().Academic_Year__c;
    } 
     
        @AuraEnabled(cacheable=true)
    public static String getRecordTypeId(){
        return Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Trainer').getRecordTypeId();
    }
    
    @AuraEnabled
    public static Map<String, Object> fetchContact(String Barcode, String stremail){
        
        system.debug('stremail 1:'+stremail);
                
        Decimal CurrentAcademicYear = AntarangSetting__c.getOrgDefaults().Academic_Year__c;
        Map<String, Object> result = new Map<String, Object>();
        
        Contact con = new contact();
        objectWrap ob = new objectWrap();
        
        //RecordType.Name ='CA Student' AND  (Grade_9_Barcode__c = '210004050' OR Grade_10_Barcode__c = '210004050' OR Grade_11_Barcode__c = '210004050') AND (Batch_Code__r.Academic_Year__c = 2021 OR G10_Batch_Code__r.Academic_Year__c = 2021  OR G11_Batch_Code__r.Academic_Year__c = 2021 )
        con = [Select Id, UID__c, Current_Academic_Batch__c, Approval_Status__c, Bar_Code__c, FirstName, LastName, Birthdate, MobilePhone, Currently_Studying_In__c, Gender__c,
               Grade_9_Barcode__c, Grade_10_Barcode__c,
               Grade_11_Barcode__c, Batch_Code__c, Batch_Code__r.School_Name__c, Batch_Code__r.School_Name__r.Name, Batch_Code__r.Name, Batch_Code__r.Academic_Year__c,G9_Alternate_Mobile_No__c, G9_Whatsapp_Number__c,
               G10_Batch_Code__c, G10_Batch_Code__r.School_Name__c, G10_Batch_Code__r.School_Name__r.Name,  G10_Batch_Code__r.Academic_Year__c,
               G10_Alternate_Mobile_No__c, G10_Whatsapp_Number__c,  
               G11_Batch_Code__c, G11_Batch_Code__r.School_Name__c, G11_Batch_Code__r.School_Name__r.Name, G11_Batch_Code__r.Academic_Year__c,
               G11_Alternate_Mobile_No__c, G11_Whatsapp_Number__c 
               from Contact 
               Where  
               //(Grade_9_Barcode__c = :Barcode OR Grade_10_Barcode__c = :Barcode OR Grade_11_Barcode__c = :Barcode OR UID__c = :Barcode )
               Bar_Code__c = :Barcode  AND (Bar_Code__c != null OR Bar_Code__c != '')
               AND (Batch_Code__r.Academic_Year__c = :CurrentAcademicYear OR G10_Batch_Code__r.Academic_Year__c = :CurrentAcademicYear  OR G11_Batch_Code__r.Academic_Year__c = :CurrentAcademicYear )
               Limit 1];
        
        if(con != null){
            //Integer c = con.Current_Academic_Batch__c;
            string CurrentBatch = '';
            List<String> sendingToEmailAdd = new List<String>() ;
            system.debug('########c : '+con.Current_Academic_Batch__c);
            
            if(String.isNotBlank(con.Current_Academic_Batch__c)){
                sendingToEmailAdd = con.Current_Academic_Batch__c.split(';');
                system.debug('sendingToEmailAdd : '+sendingToEmailAdd);
            }
            if(sendingToEmailAdd.size() > 1){
                CurrentBatch = sendingToEmailAdd[1];
            }
            List<Batch__c> b = new List<Batch__c>([Select id from Batch__c Where Batch_Number__c =:CurrentBatch AND Trainer_Name__r.npe01__WorkEmail__c = :stremail limit 1]);
            if(b.size() == 0){
                ob.Message = 'Facilitators can add/modify the students only from the schools assigned to them';
                ob.Status = 'error';
                result.put('Status', ob);
            }else{
                ob.Message = 'success';
                ob.Status = 'success';
                result.put('Status', ob);
            }
        }
        
        result.put('Contact', con);
        result.put('Gender__c', StudentOMRManagerController.getdynamicpicklistval('Contact','Gender__c'));
        result.put('Currently_Studying_In__c', StudentOMRManagerController.getdynamicpicklistval('Contact','Currently_Studying_In__c'));
        
        return result;
    }
    
    @AuraEnabled
    public static String createTempContact(formWrap formData, String trainerEmail){
        Contact con = new Contact();
        con.Id = formData.Id;
        
        List<Contact> parentCon = new List<contact>([Select Id,Approval_Status__c from Contact where Id=:con.Id]);
        if(!parentCon.isEmpty()){
            if(parentCon[0].Approval_Status__c == 'Pending'){
                return 'error';
            }
        }
        con.Approval_Status__c = 'Pending';
        
        CA_Stud_Temp__c tempCon = new CA_Stud_Temp__c();
        tempCon.Contact__c = formData.Id;
        //tempCon.Name = formData.FirstName+' '+formData.LastName;
        
        tempCon.UID__c = formData.UID;
        
        tempCon.FirstName__c = formData.FirstName;
        tempCon.LastName__c = formData.LastName;
        tempCon.Gender__c = formData.Gender;
        tempCon.Birthdate__c = formData.Birthdate;
        //tempCon.MobilePhone__c = formData.MobilePhone;
        tempCon.Currently_Studying_In__c = formData.CurrentlyStudyingIn;
        
        if(formData.Current_Grade == 9 ){
            tempCon.Batch_Code__c  = formData.Batch_Code;
            tempCon.G9_Whatsapp_Number__c  = formData.G9_Whatsapp_Number;
            tempCon.G9_Alternate_Mobile_No__c  = formData.G9_Alternate_Mobile_No;
        }
        if(formData.Current_Grade == 10){
            tempCon.G10_Batch_Code__c  = formData.G10_Batch_Code;
            tempCon.G10_Whatsapp_Number__c  = formData.G10_Whatsapp_Number;
            tempCon.G10_Alternate_Mobile_No__c  = formData.G10_Alternate_Mobile_No;
        }
        if(formData.Current_Grade == 11){
            tempCon.G11_Batch_Code__c  = formData.G11_Batch_Code;
            tempCon.G11_Whatsapp_Number__c  = formData.G11_Whatsapp_Number;
            tempCon.G11_Alternate_Mobile_No__c  = formData.G11_Alternate_Mobile_No;
        }
        tempCon.Current_Grade__c = formData.Current_Grade;
        tempCon.SubmitterEmail__c = formData.SubmitterEmail;
        
        try {
            insert tempCon;
            update con;
            sendEmail(tempCon.Id,trainerEmail);
            return 'Success';
            
        } catch (Exception e) {
            System.debug(e);
            return e.getMessage();
        }
        
    }
    
    @AuraEnabled
    public static void sendEmail(Id CAtempConId, String trainerEmail){
        List<String> sendingTocAdd = new List<String>();
        sendingTocAdd.add(trainerEmail);
        
       CA_Stud_Temp__c CAtempCon = [Select Name, Current_Grade__c, UID__c, SubmitterEmail__c, Contact__r.Name, Contact__c, Gender__c, Birthdate__c, MobilePhone__c, Currently_Studying_In__c, LastName__c, FirstName__c,
                                                                              Batch_Code__r.Batch_Number__c, Batch_Code__r.Academic_Year__c,G9_Alternate_Mobile_No__c, G9_Whatsapp_Number__c,
                                                                              G10_Batch_Code__r.Batch_Number__c, G11_Batch_Code__r.Batch_Number__c, G10_Batch_Code__r.Academic_Year__c,
                                                                              G10_Alternate_Mobile_No__c, G10_Whatsapp_Number__c,  G11_Batch_Code__r.Academic_Year__c, G11_Alternate_Mobile_No__c,
                                                                              G11_Whatsapp_Number__c  From CA_Stud_Temp__c Where Id =:CAtempConId ];
        
        integer grade ;
        Contact con = [Select Id, Approval_Status__c, UID__c, FirstName, LastName, Birthdate, MobilePhone, Currently_Studying_In__c, Gender__c, Grade_9_Barcode__c, Grade_10_Barcode__c,
                       Grade_11_Barcode__c, Batch_Code__r.Batch_Number__c, Batch_Code__r.Academic_Year__c,G9_Alternate_Mobile_No__c, G9_Whatsapp_Number__c, G10_Batch_Code__r.Batch_Number__c,
                       G11_Batch_Code__r.Batch_Number__c, G10_Batch_Code__r.Academic_Year__c,
                       G10_Alternate_Mobile_No__c, G10_Whatsapp_Number__c,  G11_Batch_Code__r.Academic_Year__c, G11_Alternate_Mobile_No__c, G11_Whatsapp_Number__c 
                       from Contact 
                       Where  id=:CAtempCon.Contact__c
                       Limit 1];
        
        
        String body = '';
        
        String body1 = 'Hi,<br/>You received an approval request for below student. Click "<a href="https://antarang.force.com/s/contact-approver-page">here</a>" for Approval.';        
        
        String htmlHeader = '<br/><br/><table border="1" style="table-layout: fixed;border-collapse: collapse;"><tr><th align="center"><b> </b></th><th align="center"><b>'+
            'UID'+
            '</b></th><th align="center"><b>'+
            'First Name'+
            '</b></th><th align="center"><b>'+
            'Last Name'+
            '</b></th><th align="center"><b>'+
            'Birthdate'+
            '</b></th>'+
            //<th align="center"><b>Mobile Phone</b></th>
            '<th align="center"><b>'+
            //'Other Phone'+
            //'</b></th><th align="center"><b>'+
            'Gender'+
            '</b></th><th align="center"><b>'+
            'Currently Studying In'+
            '</b></th>';
        if(CAtempCon.Current_Grade__c == 9){
           // htmlHeader += '<th align="center"><b>'+
              //  'G9 Batch Code'+
              //  '</b></th>'+
            htmlHeader +='<th align="center"><b>'+
                'G9 Whatsapp Number'+
                '</b></th><th align="center"><b>'+
                'G9 Alternate Mobile No'+
                '</b></th>';
        }
        if(CAtempCon.Current_Grade__c == 10){
            // htmlHeader += '<th align="center"><b>'+
              //  'G10 Batch Code'+
             //   '</b></th>'+
            htmlHeader += '<th align="center"><b>'+
                'G10 Whatsapp Number'+
                '</b></th><th align="center"><b>'+
                'G10 Alternate Mobile No'+
                '</b></th>';
        }
        if(CAtempCon.Current_Grade__c == 11){
            // htmlHeader += '<th align="center"><b>'+
              //  'G11 Batch Code'+
               // '</b></th>'+
            htmlHeader +='<th align="center"><b>'+
                'G11 Whatsapp Number'+
                '</b></th><th align="center"><b>'+
                'G11 Alternate Mobile No'+
                '</b></th>';
        }
        htmlHeader += '</tr>';
        
        String htmlbody = '<tr><td align="left"><b>Old Record</b></td><td align="center">'+
            +CAtempCon.UID__c+
            ' </td><td align="left"> '+
            +con.FirstName+
            ' </td><td align="left"> '+
            +con.LastName+
            ' </td><td align="center"> ';
        
        if(con.Birthdate != null){
            htmlbody += String.valueOf(con.Birthdate.day()).leftPad(2, '0')+'-'+String.valueOf(con.Birthdate.month()).leftPad(2, '0')+'-'+String.valueOf(con.Birthdate.year());
        }else{
            htmlbody += '';
        }
        //htmlbody += ' </td> <td align="left"> '+
            //+con.MobilePhone+
        htmlbody += ' </td><td align="center"> '+
            +con.Gender__c+
            ' </td><td align="center"> '+
            +con.Currently_Studying_In__c+
            ' </td>';
        if(CAtempCon.Current_Grade__c == 9){
            // htmlbody += '<td align="center"> '+con.Batch_Code__r.Batch_Number__c+
              //  ' </td>'+
            htmlbody += '<td align="center"> '+
                +con.G9_Whatsapp_Number__c+
                ' </td><td align="center"> '+
                +con.G9_Alternate_Mobile_No__c+
                ' </td>';
        }
        if(CAtempCon.Current_Grade__c == 10){
            //htmlbody += '<td align="center"> '+con.G10_Batch_Code__r.Batch_Number__c+
               // ' </td>'+
              htmlbody += '<td align="center"> '+
                +con.G10_Whatsapp_Number__c+
                ' </td><td align="center"> '+
                +con.G10_Alternate_Mobile_No__c+
                ' </td>';
        }
        if(CAtempCon.Current_Grade__c == 11){
            // htmlbody += '<td align="center"> '+con.G11_Batch_Code__r.Batch_Number__c+
               // ' </td>'+
            htmlbody += '<td align="center"> '+
                +con.G11_Whatsapp_Number__c+
                ' </td><td align="center"> '+
                +con.G11_Alternate_Mobile_No__c+
                '</td>';
        }
        htmlbody +='</tr>'+
            '<tr><td align="left"><b>New Record</b></td><td align="center">'+
            +CAtempCon.UID__c+
            ' </td><td align="left"> '+
            +CAtempCon.FirstName__c+
            '</td><td align="left">'+
            +CAtempCon.LastName__c+
            '</td><td align="center">';
        
        if(CAtempCon.Birthdate__c != null){
            htmlbody += String.valueOf(CAtempCon.Birthdate__c.day()).leftPad(2, '0')+'-'+String.valueOf(CAtempCon.Birthdate__c.month()).leftPad(2, '0')+'-'+String.valueOf(CAtempCon.Birthdate__c.year());
        }else{
            htmlbody += '';
        }
        //htmlbody += '</td><td align="left">'+
        //+CAtempCon.MobilePhone__c+
        htmlbody +='</td><td align="center">'+
            //+CAtempCon.OtherPhone__c+
            //'</td><td align="center">'+
            +CAtempCon.Gender__c+
            '</td><td align="center">'+
            +CAtempCon.Currently_Studying_In__c+
            '</td>';
        if(CAtempCon.Current_Grade__c == 9){
           // htmlbody += '<td align="center">'+CAtempCon.Batch_Code__r.Batch_Number__c+
              //  '</td>'+
            htmlbody += '<td align="center">'+
                +CAtempCon.G9_Whatsapp_Number__c+
                '</td><td align="center">'+
                +CAtempCon.G9_Alternate_Mobile_No__c+
                '</td>';
        }
        if(CAtempCon.Current_Grade__c == 10){
           // htmlbody += '<td align="center">'+CAtempCon.G10_Batch_Code__r.Batch_Number__c+
             //   '</td>'+
            htmlbody += '<td align="center">'+
                +CAtempCon.G10_Whatsapp_Number__c+
                '</td><td align="center">'+
                +CAtempCon.G10_Alternate_Mobile_No__c+
                '</td>';
        }
        if(CAtempCon.Current_Grade__c == 11){
            // htmlbody += '<td align="center">'+CAtempCon.G11_Batch_Code__r.Batch_Number__c+
            //   '</td>'+
            htmlbody += '<td align="center">'+
                +CAtempCon.G11_Whatsapp_Number__c+
                '</td><td align="center">'+
                +CAtempCon.G11_Alternate_Mobile_No__c+
                '</td>';
        }
        htmlbody += '</tr> </table> <br/> <br/> Thanks,';
        
        body += body1+htmlHeader+htmlbody;
        
        Messaging.singleEmailMessage Email = new Messaging.singleEmailMessage();
        
        string toEmails = System.Label.Student_Update_Approver;
        List<String> sendingToEmailAdd = new List<String>();
        if(String.isNotBlank(toEmails)){
            sendingToEmailAdd = toEmails.split(';');
        }
        if(sendingToEmailAdd.size() > 0){
            Email.setToaddresses(sendingToEmailAdd);   
        }
        
        String owa = [select id, Address, DisplayName from OrgWideEmailAddress where Address='sfcareeraware@antarangfoundation.org'].Id;
        Email.setOrgWideEmailAddressId(owa);
        String Subject = 'Approval Request for: '+CAtempCon.UID__c+' - {'+CAtempCon.Name+'}';
        
        Email.setCcAddresses(sendingTocAdd);
        
        Email.setSubject(Subject);
        Email.setHtmlBody(body);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {Email});
    }
    
    @AuraEnabled
    public static String checkEmailExist(String stremail) {
        Decimal CurrentAcademicYear = AntarangSetting__c.getOrgDefaults().Academic_Year__c;
        Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
            .get('CA_Trainer')
            .getRecordTypeId();
        
        Contact c = new Contact();
        String st = stremail.split('@').get(1);
        system.debug('stremail.split().get(1) : '+st);
        if((String.isNotBlank(stremail) && stremail.contains('@') && stremail.split('@').get(1) == 'antarangfoundation.org')) {
               for (Contact objcon : [
                   SELECT id, npe01__WorkEmail__c
                   FROM contact
                   WHERE npe01__WorkEmail__c = :stremail AND Academic_Year__c =:CurrentAcademicYear AND recordTypeId =:recordTypeId
                   ORDER BY CreatedDate DESC
                   LIMIT 1
               ]) {
                   c = objcon;
                   return 'Valid';
               }
           }
        return 'Not Valid';
    }
    
    @AuraEnabled
    public static String checkApproverEmailExist(String stremail) {
        system.debug('executed checkApproverEmailExist');
        
        String Emails = System.Label.Student_Update_Approver;
        List<String> sendingToEmailAdd = new List<String>();
        if(String.isNotBlank(Emails)){
            sendingToEmailAdd = Emails.split(';');
        }
        for(String s:sendingToEmailAdd){
            if(s.toLowerCase() == stremail.toLowerCase()){
                return 'Valid';
            }
        }
        return 'Not Valid';
    }
    
    @AuraEnabled
    public static Object pendingRecords(){
        Map<String, Object> result = new Map<String, Object>();
        Map<Id,CA_Stud_Temp__c> clonedRecords = new Map<Id, CA_Stud_Temp__c>([Select Name, UID__c, Current_Grade__c, SubmitterEmail__c, Contact__r.Name, Contact__c, Gender__c, Birthdate__c, MobilePhone__c, Currently_Studying_In__c, LastName__c, FirstName__c,
                                                                              Batch_Code__r.Batch_Number__c, Batch_Code__r.Academic_Year__c,G9_Alternate_Mobile_No__c, G9_Whatsapp_Number__c,
                                                                              G10_Batch_Code__r.Batch_Number__c, G11_Batch_Code__r.Batch_Number__c, G10_Batch_Code__r.Academic_Year__c,
                                                                              G10_Alternate_Mobile_No__c, G10_Whatsapp_Number__c,  G11_Batch_Code__r.Academic_Year__c, G11_Alternate_Mobile_No__c,
                                                                              G11_Whatsapp_Number__c  From CA_Stud_Temp__c ]);
        
        Set<Id> conIds = new Set<Id>();
        for(CA_Stud_Temp__c  c:clonedRecords.values()){
            conIds.add(c.Contact__c);
        }
        
        system.debug('test : 3 '+ clonedRecords);
        
        if(clonedRecords.isEmpty()){
            result.put('status', 'No records for Pending');
            return result;
        }
        
        List<approverWrap> wrap = new List<approverWrap>();
        Map<Id,Contact> contactMap = new  Map<Id,Contact>([Select Id, UID__c, Approval_Status__c, FirstName, LastName, Birthdate, MobilePhone, Currently_Studying_In__c, Gender__c, Grade_9_Barcode__c, Grade_10_Barcode__c,
                                                           Grade_11_Barcode__c, Batch_Code__r.Batch_Number__c, Batch_Code__r.Academic_Year__c,G9_Alternate_Mobile_No__c, G9_Whatsapp_Number__c, G10_Batch_Code__r.Batch_Number__c,
                                                           G11_Batch_Code__r.Batch_Number__c, G10_Batch_Code__r.Academic_Year__c,
                                                           G10_Alternate_Mobile_No__c, G10_Whatsapp_Number__c,  G11_Batch_Code__r.Academic_Year__c, G11_Alternate_Mobile_No__c, G11_Whatsapp_Number__c 
                                                           from Contact WHERE Id IN :conIds ]); //AND Approval_Status__c = 'Pending'
        
        
        for(CA_Stud_Temp__c  c:clonedRecords.values()){
            approverWrap w = new approverWrap();
            w.clonedContact = c;
            system.debug('test : 2 '+ contactMap.get(c.Contact__c));
            w.ContactObj = contactMap.get(c.Contact__c);
            
            if(c.Current_Grade__c == 9){
                w.grade9 = true;
                w.grade10 = false;
                w.grade11 = false;
            }else if(c.Current_Grade__c == 10){
                w.grade9 = false;
                w.grade10 = true;
                w.grade11 = false;
            }else if(c.Current_Grade__c == 11){
                w.grade9 = false;
                w.grade10 = false;
                w.grade11 = true;
            }
            wrap.add(w);
            system.debug('test :v '+w);
  
        }
        system.debug('test : '+wrap);
        result.put('data', wrap);
        result.put('status', 'Success');
        return result;
    } 

    
    @AuraEnabled
    public static String mergeContact(String data, String action, String reason){
        system.debug('data : '+data);
        List<CA_Stud_Temp__c> clonedRecords = (List<CA_Stud_Temp__c>)JSON.deserialize(data, List<CA_Stud_Temp__c>.class);
        system.debug('clonedRecords : '+clonedRecords);
        
        system.debug('action : '+action);
        
        try{
            List<Contact> contactUpdateList = new List<Contact>();
            for(CA_Stud_Temp__c c:clonedRecords){
                contact con = new contact();
                con.Id = c.contact__c;
                con.Approval_Status__c = action;
                if(action == 'Approved'){
                    con.FirstName = c.FirstName__c;
                    con.LastName = c.LastName__c;
                    con.Gender__c = c.Gender__c;
                    con.Birthdate = c.Birthdate__c;
                    //con.MobilePhone = c.MobilePhone__c;
                    con.Currently_Studying_In__c = c.Currently_Studying_In__c;
                    
                    if(c.Current_Grade__c == 9){
                        con.G9_Alternate_Mobile_No__c = c.G9_Alternate_Mobile_No__c;
                        con.G9_Whatsapp_Number__c = c.G9_Whatsapp_Number__c;
                        //con.Batch_Code__c = c.Batch_Code__c;
                    }
                    if(c.Current_Grade__c == 10){
                        //con.G10_Batch_Code__c = c.G10_Batch_Code__c;
                        con.G10_Whatsapp_Number__c = c.G10_Whatsapp_Number__c;
                        con.G10_Alternate_Mobile_No__c = c.G10_Alternate_Mobile_No__c;
                    }
                    if(c.Current_Grade__c == 11){
                        // con.G11_Batch_Code__c = c.G11_Batch_Code__c;
                        con.G11_Whatsapp_Number__c = c.G11_Whatsapp_Number__c;
                        con.G11_Alternate_Mobile_No__c = c.G11_Alternate_Mobile_No__c;
                    }
                    sendApprovedEmail(c);
                    
                }else if(action == 'Rejected'){
                    system.debug('tettt : '+c);
                    sendRejectedEmail(c, reason);
                }
                contactUpdateList.add(con);
                
            }
            system.debug('clonedRecords : '+clonedRecords);
            system.debug('contactUpdateList : '+contactUpdateList);
            
            delete clonedRecords;
            update contactUpdateList;
            return 'Success';
        }catch(Exception e){
            system.debug('e : '+e.getMessage());
            return e.getMessage();
        }
    }
    
    public static void sendRejectedEmail(CA_Stud_Temp__c con, String reason){
        system.debug('tettt : '+con);
        Messaging.singleEmailMessage message = new Messaging.singleEmailMessage();
        
        String body = 'Hi <br/> Your request for updating Student data has been rejected for below reason<b> : '+reason+' </b>';
        
        List<String> sendingToEmailAdd = new List<String>();
        sendingToEmailAdd.add(con.SubmitterEmail__c);
        sendingToEmailAdd.add('bhagyashree.k@kandisatech.com');
        
        message.setToaddresses(sendingToEmailAdd); 
        
        String owa = [select id, Address, DisplayName from OrgWideEmailAddress where Address='sfcareeraware@antarangfoundation.org'].Id;
        message.setOrgWideEmailAddressId(owa);
        
        String Subject = 'Rejected Approval Request for: '+con.UID__c+' - {'+con.Name+ '}';
        
        message.setSubject(Subject);
        message.setHtmlBody(body);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
    }
    
    public static void sendApprovedEmail(CA_Stud_Temp__c con){
        system.debug('tettt : '+con);
        Messaging.singleEmailMessage message = new Messaging.singleEmailMessage();
        
        String body = 'Hi <br/> Your request for updating Student data has been Approved <br/><br/><br/> Thanks,';
        
        List<String> sendingToEmailAdd = new List<String>();
        sendingToEmailAdd.add(con.SubmitterEmail__c);
        //sendingToEmailAdd.add('bhagyashree.k@kandisatech.com');
        
        message.setToaddresses(sendingToEmailAdd); 
        
        String owa = [select id, Address, DisplayName from OrgWideEmailAddress where Address='sfcareeraware@antarangfoundation.org'].Id;
        message.setOrgWideEmailAddressId(owa);
        
        String Subject = 'Approved Approval Request for: '+con.UID__c+' - {'+con.Name+ '}';
        
        message.setSubject(Subject);
        message.setHtmlBody(body);
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
    }
    
    public class objectWrap{
        @AuraEnabled public  String Message 			   			{set;get;}
        @AuraEnabled public  String Status 			   				{set;get;}
        
    }
    
    public class approverWrap{
        @AuraEnabled public Contact ContactObj 						{set;get;}
        @AuraEnabled public CA_Stud_Temp__c clonedContact 			{set;get;}
        
        @AuraEnabled public Boolean grade9				 			{set;get;}
        @AuraEnabled public Boolean grade10				 			{set;get;}
        @AuraEnabled public Boolean grade11				 			{set;get;}
        
        @AuraEnabled public  String status 			   				{set;get;}
    }
    
    public class formWrap{
        @AuraEnabled public  String UID		 			   			{set;get;}
        
        @AuraEnabled public  String Id 								{set;get;}
        @AuraEnabled public  String FirstName 			   			{set;get;}
        @AuraEnabled public  String LastName 			   			{set;get;}
        @AuraEnabled public  String Gender				   			{set;get;}
        @AuraEnabled public  Date Birthdate 			   			{set;get;}
        //@AuraEnabled public  String MobilePhone 			   		{set;get;}
        @AuraEnabled public  String CurrentlyStudyingIn 			{set;get;}
        
        
        
        @AuraEnabled public  String Batch_Code	 					{set;get;}
        @AuraEnabled public  String G9_Whatsapp_Number	 			{set;get;}
        @AuraEnabled public  String G9_Alternate_Mobile_No	 		{set;get;}
        
        @AuraEnabled public  String G10_Batch_Code	 				{set;get;}
        @AuraEnabled public  String G10_Whatsapp_Number	 			{set;get;}
        @AuraEnabled public  String G10_Alternate_Mobile_No 		{set;get;}
        
        @AuraEnabled public  String G11_Batch_Code	 				{set;get;}
        @AuraEnabled public  String G11_Whatsapp_Number				{set;get;}
        @AuraEnabled public  String G11_Alternate_Mobile_No 		{set;get;}
        
        @AuraEnabled public  Integer Current_Grade 					{set;get;} 
        @AuraEnabled public  String SubmitterEmail 					{set;get;}
        
        @AuraEnabled public  Date SessionDate 						{set;get;}
    }
    
}