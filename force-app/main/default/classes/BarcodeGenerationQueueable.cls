public class BarcodeGenerationQueueable implements Queueable{
    public list<Contact> contact;
    public String grade;
    
    public Boolean isStudentLinking = false;
    
    public batch__c batch;
    public string formType;
    private static List<String> failedContactDetails = new List<String>();
	public BarcodeGenerationQueueable(list<Contact> contact,string grade,Batch__c batch, string formType, Boolean isStudentLinking) {
        this.contact = contact;
        this.grade = grade;
        this.batch = batch;
        this.formType = formType;
        this.isStudentLinking = isStudentLinking;
    }
    
    public BarcodeGenerationQueueable(list<Contact> contact,string grade,Batch__c batch, string formType) {
        this.contact = contact;
        this.grade = grade;
        this.batch = batch;
        this.formType = formType;
        
        // this.isStudentLinking = false;
    }
    
    public void execute(QueueableContext context) {
        try {
             Integer barcode;
            /*set<id> contactId = new set<id>();
            for(id conId : cont)
            Integer barcode;
            System.debug('Processing contact: ' + contact);
			contact = [SELECT Id, Bar_Code__c, Grade_9_Barcode__c, Grade_10_Barcode__c, 
                              Grade_11_Barcode__c, Grade_12_Barcode__c
                       FROM Contact
                       WHERE Id = :contact.Id];*/

            // Fetch settings for Academic Year
            AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
            String startChar = String.valueOf(Integer.valueOf(setting.Next_Academic_Year__c)).right(2) + 
                                String.valueOf(batch.School_Name__r.State__r.State_Code__c).leftPad(2, '0');
            String startCharFromDistrict = String.valueOf(Integer.valueOf(batch.School_Name__r.District__r.Academic_Year__c)).right(2) + 
                                           String.valueOf(batch.School_Name__r.State__r.State_Code__c).leftPad(2, '0');

            String startCharCondition = startCharFromDistrict + '%';
            String zero = '0';
            String districtId = batch.School_Name__r.District__c;

            // Build query
            string query = 'select Latest_Barcode__c, Batch_Code__r.School_Name__r.Barcode_ends_with__c,G10_Batch_Code__r.School_Name__r.Barcode_ends_with__c,G11_Batch_Code__r.School_Name__r.Barcode_ends_with__c,G10_Batch_Code__r.School_Name__r.Barcode_starts_with__c,G11_Batch_Code__r.School_Name__r.Barcode_starts_with__c,G10_Batch_Code__r.School_Name__c,G11_Batch_Code__r.School_Name__c,id,Bar_Code__c,Batch_Code__r.School_Name__c,Batch_Code__r.School_Name__r.Barcode_starts_with__c,G10_Batch_Code__c,G11_Batch_Code__c,G12_Batch_Code__c from contact where Bar_Code__c != NULL ';
            query += ' AND Latest_Barcode__c != :zero AND Latest_Barcode__c LIKE :startCharCondition ';
            
            if(formType == 'Form V2'){
                // query += ' And Form_Name__c = \'Form V2\' AND (Batch_Code__r.School_Name__r.District__c =: districtId OR G10_Batch_Code__r.School_Name__r.District__c =: districtId OR G11_Batch_Code__r.School_Name__r.District__c =: districtId OR G12_Batch_Code__r.School_Name__r.District__c =: districtId)';
                query += ' And (Batch_Code__r.School_Name__r.District__c =: districtId OR G10_Batch_Code__r.School_Name__r.District__c =: districtId OR G11_Batch_Code__r.School_Name__r.District__c =: districtId OR G12_Batch_Code__r.School_Name__r.District__c =: districtId)';
            }else{
                query += 'AND (Batch_Code__r.School_Name__r.id =: schoolId OR G10_Batch_Code__r.School_Name__r.id =: schoolId OR G11_Batch_Code__r.School_Name__r.id =: schoolId OR G12_Batch_Code__r.School_Name__r.id =: schoolId)';
            }
            
            // query += ' order by Bar_Code__c desc';
            query += ' order by Latest_Barcode__c desc ';
			list<Contact> barcodeList = Database.query(query);
            
            Contact maxBarcode =  new contact();
            for (Contact cn : barcodeList) {
                system.debug(cn.Bar_Code__c);
                if (cn.Latest_Barcode__c.startsWithIgnoreCase(startCharFromDistrict) && cn.Latest_Barcode__c.length() == 10) {
                    maxBarcode = cn;
                    break;
                }
            }
			system.debug('maxBarcode ='+maxBarcode);
            if(formType == 'Form V2'){
                if(maxBarcode.id != null && batch.School_Name__r.District__r.Barcode_starts_with__c != null){
                    // barcode =  Integer.ValueOf(maxBarcode.Bar_Code__c.right(maxBarcode.Bar_Code__c.length()-4)) + 1;
                    barcode =  Integer.ValueOf(maxBarcode.Latest_Barcode__c.right(maxBarcode.Latest_Barcode__c.length()-4)) + 1;
                }else if(batch.School_Name__r.District__r.Barcode_starts_with__c != null){
                    barcode = Integer.ValueOf(batch.School_Name__r.District__r.Barcode_starts_with__c);
                }
            }/*else{
                if(maxBarcode.id != null){
                    system.debug('maxBarcode = '+maxBarcode);
                    Integer barcodeWithoutYrNStateCode;
                    integer startswith;
                    integer endswith;
                    // barcodeWithoutYrNStateCode = Integer.ValueOf(maxBarcode.Bar_Code__c.right(maxBarcode.Bar_Code__c.length()-4));
                    barcodeWithoutYrNStateCode = Integer.ValueOf(maxBarcode.Latest_Barcode__c.right(maxBarcode.Latest_Barcode__c.length()-4));
                    system.debug('barcodeWithoutYrNStateCode = '+barcodeWithoutYrNStateCode);
                    if(maxBarcode.Batch_Code__r.School_Name__c != null && maxBarcode.Batch_Code__r.School_Name__r.Barcode_starts_with__c != null && maxBarcode.Batch_Code__r.School_Name__r.Barcode_ends_with__c != null){
                        startswith = Integer.ValueOf(maxBarcode.Batch_Code__r.School_Name__r.Barcode_starts_with__c);
                        endswith = Integer.ValueOf(maxBarcode.Batch_Code__r.School_Name__r.Barcode_ends_with__c);
                    }
                    if(maxBarcode.G10_Batch_Code__r.School_Name__c != null && maxBarcode.G10_Batch_Code__r.School_Name__r.Barcode_starts_with__c != null && maxBarcode.G10_Batch_Code__r.School_Name__r.Barcode_ends_with__c != null){
                        startswith = Integer.ValueOf(maxBarcode.G10_Batch_Code__r.School_Name__r.Barcode_starts_with__c);
                        endswith = Integer.ValueOf(maxBarcode.G10_Batch_Code__r.School_Name__r.Barcode_ends_with__c);
                    }
                    if(maxBarcode.G11_Batch_Code__r.School_Name__c != null && maxBarcode.G11_Batch_Code__r.School_Name__r.Barcode_starts_with__c != null && maxBarcode.G10_Batch_Code__r.School_Name__r.Barcode_ends_with__c != null){
                        startswith = Integer.ValueOf(maxBarcode.G11_Batch_Code__r.School_Name__r.Barcode_starts_with__c);
                        endswith = Integer.ValueOf(maxBarcode.G11_Batch_Code__r.School_Name__r.Barcode_ends_with__c);
                    }
                    
                    //integer startswith = Integer.ValueOf(maxBarcode.Batch_Code__r.School_Name__r.Barcode_starts_with__c);
                    system.debug('startswith = '+startswith);
                    // integer endswith = Integer.ValueOf(maxBarcode.Batch_Code__r.School_Name__r.Barcode_ends_with__c);
                    system.debug('endswith = '+endswith);
                    if(barcodeWithoutYrNStateCode != null && startswith != null && startswith != null){
                        if(barcodeWithoutYrNStateCode >= endswith){
                            //return 'batchFull';
                            system.debug('batchFull');
                        }else if(barcodeWithoutYrNStateCode < startswith){
                            barcode = startswith;
                            //system.debug('elsss');
                        }
                        else if((barcodeWithoutYrNStateCode >= startswith) && (barcodeWithoutYrNStateCode <= endswith)){ 
                            barcode = barcodeWithoutYrNStateCode + 1;
                            //system.debug('ifff');
                        }else{
                            //return 'barcode';
                        }
                    }
                }else if(batch.School_Name__r.Barcode_starts_with__c != null){
                    system.debug('batch = '+batch);
                    barcode = Integer.ValueOf(batch.School_Name__r.Barcode_starts_with__c);
                }else{
                    //return 'barcode';
                }
            }*/
            system.debug('barcode ='+barcode);
            if(barcode != null){
                String generatedBarcode = startCharFromDistrict + String.valueOf(barcode).leftPad(6, '0');
                system.debug('generatedBarcode ='+generatedBarcode);
                String query1 = ' SELECT Id, Bar_Code__c, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c, '+
                + ' Batch_Code__r.Batch_number__c, G10_Batch_Code__r.Batch_number__c, G11_Batch_Code__r.Batch_number__c, G12_Batch_Code__r.Batch_number__c, Batch_Code__r.Academic_Year__c, G10_Batch_Code__r.Academic_Year__c, G11_Batch_Code__r.Academic_Year__c, G12_Batch_Code__r.Academic_Year__c FROM Contact WHERE ';
				
				query1 += ' ((Bar_Code__c = :generatedBarcode) OR (Grade_9_Barcode__c = : generatedBarcode) OR (Grade_10_Barcode__c = : generatedBarcode) OR (Grade_11_Barcode__c = : generatedBarcode) OR (Grade_12_Barcode__c = : generatedBarcode)) ';
            	list<contact> checkDupBarcode = Database.query(query1);
                if(checkDupBarcode.size() != 0){
                    Long numericBarcode = Long.valueOf(generatedBarcode);
                    numericBarcode += 1; 
                    generatedBarcode = String.valueOf(numericBarcode);
                }
                List<Contact> contactsToUpdate = new List<Contact>();
                for (Contact contact : contact) {
                    /*
                     
                    if(grade == 'Grade 9') contact.Bar_Code__c = contact.Grade_9_Barcode__c = generatedBarcode;
                    if(grade == 'Grade 10') contact.Bar_Code__c = contact.Grade_10_Barcode__c = generatedBarcode;
                    if(grade == 'Grade 11') contact.Bar_Code__c = contact.Grade_11_Barcode__c = generatedBarcode;
                    if(grade == 'Grade 12') contact.Bar_Code__c = contact.Grade_12_Barcode__c = generatedBarcode;
                    */
                    
                    
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
                    
                    contactsToUpdate.add(contact);
                    Long numericBarcode = Long.valueOf(generatedBarcode);
                    numericBarcode += 1; 
                    generatedBarcode = String.valueOf(numericBarcode);
                }
                if (contactsToUpdate.size() > 0) {
                    update contactsToUpdate;
                }
                /*String generatedBarcode = startCharFromDistrict + String.valueOf(barcode).leftPad(6, '0');
                system.debug('generatedBarcode ='+generatedBarcode);
                String query1 = ' SELECT Id, Bar_Code__c, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c, '+
                + ' Batch_Code__r.Batch_number__c, G10_Batch_Code__r.Batch_number__c, G11_Batch_Code__r.Batch_number__c, G12_Batch_Code__r.Batch_number__c, Batch_Code__r.Academic_Year__c, G10_Batch_Code__r.Academic_Year__c, G11_Batch_Code__r.Academic_Year__c, G12_Batch_Code__r.Academic_Year__c FROM Contact WHERE ';
				
				query1 += ' ((Bar_Code__c = :generatedBarcode) OR (Grade_9_Barcode__c = : generatedBarcode) OR (Grade_10_Barcode__c = : generatedBarcode) OR (Grade_11_Barcode__c = : generatedBarcode) OR (Grade_12_Barcode__c = : generatedBarcode)) ';
            	list<contact> checkDupBarcode = Database.query(query1);
                if(checkDupBarcode.size() != 0){
                    generatedBarcode = generatedBarcode + 1;
                }
                if(grade == 'Grade 9') contact.Bar_Code__c = contact.Grade_9_Barcode__c = generatedBarcode;
                if(grade == 'Grade 10') contact.Bar_Code__c = contact.Grade_10_Barcode__c = generatedBarcode;
                if(grade == 'Grade 11') contact.Bar_Code__c = contact.Grade_11_Barcode__c = generatedBarcode;
                if(grade == 'Grade 12') contact.Bar_Code__c = contact.Grade_12_Barcode__c = generatedBarcode;
                system.debug('contact = '+contact);
            	update contact;*/
            }

        } catch (Exception e) {
            List<String> contactIds = new List<String>();
            for (Contact con : Contact) {
                contactIds.add(con.Id);
            }
            String contactIdString = String.join(contactIds, ',');
            failedContactDetails.add('Barcode Generation is Failed for Contacts: ' + contactIds + '. Reason: ' + e.getMessage());
            System.debug('Error during barcode generation: ' + e.getMessage());
            System.debug('Error during barcode generation LineNumber: ' + e.getLineNumber());
        }
    }
    public void finish(QueueableContext context) {
        system.debug('failedContactDetails = '+failedContactDetails);
        if (!failedContactDetails.isEmpty()) {
            String emailBody = 'The following contact failed during barcode generation:\n\n';
            emailBody += String.join(failedContactDetails, '\n');

            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(Label.OMR_Email_Ids.split(';')); // Replace with actual admin email
            email.setSubject('Contact Failed for Barcode Generation - BarcodeGenerationQueueable');
            email.setPlainTextBody(emailBody);

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
            System.debug('Email sent with failed contact details.');
        }
    }
}