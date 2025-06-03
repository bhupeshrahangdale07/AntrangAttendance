public Without Sharing class BarcodeGenerationQueueable implements Queueable{
    public list<Contact> contact;
    public String grade;
    Integer count=1;
    public Boolean isStudentLinking = false;
    
    public batch__c batch;
    public string formType;
    public static List<String> failedContactDetails = new List<String>();
    public Map<Id, Integer> retryCountMap = new Map<Id, Integer>();
    List<Contact> failedContactsToRetry = new List<Contact>();
	public BarcodeGenerationQueueable(list<Contact> contact,string grade,Batch__c batch, string formType, Boolean isStudentLinking,Map<Id, Integer> retryCountMap) {
        this.contact = contact;
        this.grade = grade;
        this.batch = batch;
        this.formType = formType;
        this.isStudentLinking = isStudentLinking;
        this.retryCountMap = retryCountMap;
    }
    
    public BarcodeGenerationQueueable(list<Contact> contact,string grade,Batch__c batch, string formType,Map<Id, Integer> retryCountMap) {
        this.contact = contact;
        this.grade = grade;
        this.batch = batch;
        this.formType = formType;
        this.retryCountMap = retryCountMap;
    }
    
    public void execute(QueueableContext context) {
        try {
       
             Integer barcode;
            AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
            String startChar = String.valueOf(Integer.valueOf(setting.Next_Academic_Year__c)).right(2) + 
                                String.valueOf(batch.School_Name__r.State__r.State_Code__c).leftPad(2, '0');
            String startCharFromDistrict = String.valueOf(Integer.valueOf(batch.School_Name__r.District__r.Academic_Year__c)).right(2) + 
                                           String.valueOf(batch.School_Name__r.State__r.State_Code__c).leftPad(2, '0');

            String startCharCondition = startCharFromDistrict + '%';
            String zero = '0';
            String districtId = batch.School_Name__r.District__c;
			//Query to get latest barocode
            string query = 'select Latest_Barcode__c, Batch_Code__r.School_Name__r.Barcode_ends_with__c,G10_Batch_Code__r.School_Name__r.Barcode_ends_with__c,G11_Batch_Code__r.School_Name__r.Barcode_ends_with__c,G10_Batch_Code__r.School_Name__r.Barcode_starts_with__c,G11_Batch_Code__r.School_Name__r.Barcode_starts_with__c,G10_Batch_Code__r.School_Name__c,G11_Batch_Code__r.School_Name__c,id,Bar_Code__c,Batch_Code__r.School_Name__c,Batch_Code__r.School_Name__r.Barcode_starts_with__c,G10_Batch_Code__c,G11_Batch_Code__c,G12_Batch_Code__c from contact where Bar_Code__c != NULL ';
            query += ' AND Latest_Barcode__c != :zero AND Latest_Barcode__c LIKE :startCharCondition ';
            
            if(formType == 'Form V2'){
                query += ' And (Batch_Code__r.School_Name__r.District__c =: districtId OR G10_Batch_Code__r.School_Name__r.District__c =: districtId OR G11_Batch_Code__r.School_Name__r.District__c =: districtId OR G12_Batch_Code__r.School_Name__r.District__c =: districtId)';
            }else{
                query += 'AND (Batch_Code__r.School_Name__r.id =: schoolId OR G10_Batch_Code__r.School_Name__r.id =: schoolId OR G11_Batch_Code__r.School_Name__r.id =: schoolId OR G12_Batch_Code__r.School_Name__r.id =: schoolId)';
            }
            
            query += ' order by Latest_Barcode__c desc ';
			list<Contact> barcodeList = Database.query(query);
            
            Contact maxBarcode =  new contact();
            for (Contact cn : barcodeList) {
                if (cn.Latest_Barcode__c.startsWithIgnoreCase(startCharFromDistrict) && cn.Latest_Barcode__c.length() == 10) {
                    //get latest barcode
                    maxBarcode = cn;
                    break;
                }
            }
            //add +1 to the latest barcode
            if(formType == 'Form V2'){
                if(maxBarcode.id != null && batch.School_Name__r.District__r.Barcode_starts_with__c != null){
                    barcode =  Integer.ValueOf(maxBarcode.Latest_Barcode__c.right(maxBarcode.Latest_Barcode__c.length()-4)) + 1;
                }else if(batch.School_Name__r.District__r.Barcode_starts_with__c != null){
                    barcode = Integer.ValueOf(batch.School_Name__r.District__r.Barcode_starts_with__c);
                }
            }
            if(barcode != null){
                String generatedBarcode = startCharFromDistrict + String.valueOf(barcode).leftPad(6, '0');
                //check barcode is present in system or not 
                String query1 = ' SELECT Id, Bar_Code__c, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c, '+
                + ' Batch_Code__r.Batch_number__c, G10_Batch_Code__r.Batch_number__c, G11_Batch_Code__r.Batch_number__c, G12_Batch_Code__r.Batch_number__c, Batch_Code__r.Academic_Year__c, G10_Batch_Code__r.Academic_Year__c, G11_Batch_Code__r.Academic_Year__c, G12_Batch_Code__r.Academic_Year__c FROM Contact WHERE ';
				
				query1 += ' ((Bar_Code__c = :generatedBarcode) OR (Grade_9_Barcode__c = : generatedBarcode) OR (Grade_10_Barcode__c = : generatedBarcode) OR (Grade_11_Barcode__c = : generatedBarcode) OR (Grade_12_Barcode__c = : generatedBarcode)) ';
            	list<contact> checkDupBarcode = Database.query(query1);
                if(checkDupBarcode.size() != 0){
                    //If barcode present in system then increment barcode by 1
                    Long numericBarcode = Long.valueOf(generatedBarcode);
                    numericBarcode += 1; 
                    generatedBarcode = String.valueOf(numericBarcode);
                }
                List<Contact> contactsToUpdate = new List<Contact>();
                for (Contact contact : contact) {
                   //assign generated barcode and grade wise barcode field 
                    switch on grade {
                        when 'Grade 9' {
                            if(isStudentLinking) {
                                contact.Grade_9_Barcode__c = generatedBarcode;
                            } else {
                                contact.Bar_Code__c = generatedBarcode;
                                contact.Grade_9_Barcode__c = generatedBarcode;
                            }
                        }
                        when 'Grade 10' {
                            if(isStudentLinking) {
                                contact.Grade_10_Barcode__c = generatedBarcode;
                            } else {
                                contact.Bar_Code__c = generatedBarcode;
                                contact.Grade_10_Barcode__c = generatedBarcode;
                            }
                        }
                        when 'Grade 11' {
                            if(isStudentLinking) {
                                contact.Grade_11_Barcode__c = generatedBarcode;
                            } else {
                                contact.Bar_Code__c = generatedBarcode;
                                contact.Grade_11_Barcode__c = generatedBarcode;
                            }
                        }
                        when 'Grade 12' {
                            if(isStudentLinking) {
                                contact.Grade_12_Barcode__c = generatedBarcode;
                            } else {  
                                contact.Bar_Code__c = generatedBarcode;
                                contact.Grade_12_Barcode__c = generatedBarcode;
                            }
                        }
                    }
                    
                    //  updating Latest Grade Barcode field to populate unique Barcode value overall org to avoid duplicate Barcodes
    				contact.Latest_Grade_Barcode__c = generatedBarcode;
                    
                    contactsToUpdate.add(contact);
                    Long numericBarcode = Long.valueOf(generatedBarcode);
                    numericBarcode += 1; 
                    generatedBarcode = String.valueOf(numericBarcode);
                }
                //update contact
                if (contactsToUpdate.size() > 0) {
                    update contactsToUpdate;
                }
                
            }

        } catch (Exception e) {
            
            Batch__c bt = [SELECT Name, School_Name__c, School_Name__r.name, Grade__c, Batch_Number__c, Academic_Year__c,
                                    School_Name__r.District__r.Academic_Year__c, School_Name__r.State__r.State_Code__c, 
                                   School_Name__r.District__r.Barcode_starts_with__c FROM Batch__c WHERE id=: batch.id];
            //If exception occurs then store in Map<Id,Integer>
            if (retryCountMap.containsKey(contact[0].id)) {
                //If ContactId present then made +1 of that contact
                retryCountMap.put(contact[0].id, retryCountMap.get(contact[0].id) + 1);
            } else {
                //otherwise simply put contactId into Map
                retryCountMap.put(contact[0].id, 1);
            }
            
            for (Id contactId : retryCountMap.keySet()) {
                Integer count = retryCountMap.get(contactId);
                if (count >= 5) {
                    //If value of contact is greater than 5 then send email
                    List<String> contactIds = new List<String>();
                    for (Contact con : Contact) {
                        contactIds.add(con.Id);
                    }
                    String contactIdString = String.join(contactIds, ',');
                    failedContactDetails.add(' Counter - ' + count + '\n No. of failed Contact - ' + contactIds.size() + '\n Contact Ids - ' + contactIds + '\n Batch Number - '+bt.Batch_Number__c +'\n Line Number - '+e.getLineNumber()+'\n Reason: ' + e.getMessage());
                    if (!failedContactDetails.isEmpty()) {
                        String emailBody = 'The following contact failed during barcode generation:\n\n';
                        emailBody += String.join(failedContactDetails, '\n');
                        List<OrgWideEmailAddress> owea = [SELECT Id FROM OrgWideEmailAddress LIMIT 1];
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        email.setOrgWideEmailAddressId(owea[0].Id);
                        email.setToAddresses(Label.Data_Entry_Email.split(';')); // Replace with actual admin email
                        email.setSubject('Contact Failed for Barcode Generation - BarcodeGenerationQueueable');
                        email.setPlainTextBody(emailBody);
                        try {
                            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
                        } catch(Exception ex) {
                            System.debug('Email send error: ' + ex.getMessage() + ' at line ' + ex.getLineNumber());
                        }
                        System.debug('Email sent with failed contact details.');
                        retryCountMap.remove(contactId);
                    }
                }else{
                    //Otherwise Reschedule batch
                    List<AsyncApexJob> runningJobs = [
                        SELECT Id, Status, JobType, ApexClass.Name
                        FROM AsyncApexJob
                        WHERE Status IN ('Processing', 'Preparing') 
                          AND JobType = 'Queueable'
                          AND ApexClass.Name = 'BarcodeGenerationQueueable'
                    ];
                    
                    //Check BarcodeGenerationQueueable is running
                    if (runningJobs.size() > 0  && !Test.isRunningTest()) {
                        //If yes then Reschedule batch after 2 min
                        Integer delayInMinutes = 2;
                        System.enqueueJob(new BarcodeGenerationQueueable(contact,grade, bt, formType,retryCountMap));
    
                    }else if(!Test.isRunningTest()){
                        //Otherwise Reschedule batch
                         System.enqueueJob(new BarcodeGenerationQueueable(contact,grade, bt, formType,retryCountMap));
                    } 
                }
            }
         
        }
    }
    public void finish(QueueableContext context) {
    }
}