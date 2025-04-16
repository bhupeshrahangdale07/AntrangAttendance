public without sharing class StudentLinkController {
    public StudentLinkController() {
        
    }
    
    @AuraEnabled
    public static Map<String, Object> getUnLinkedStudents(String grade, String batchId){
        
        AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
        Batch__c bt = new Batch__c();
        try {
            bt = [SELECT Name, School_Name__c, School_Name__r.name, Grade__c, Batch_Number__c, Academic_Year__c FROM Batch__c WHERE id=: batchId];
        } catch (Exception e) {
            throw new AuraHandledException('Batch Not Found');
            // throw new CustomException('Error', 'Batch Not Found', 12 );
        }
        
        Integer previousAcademicYear = Integer.valueOf(bt.Academic_Year__c) - 1;
        String schoolId = bt.School_Name__c;
        String query = 'Select Id, Name, G9_Whatsapp_Number__c, G10_Whatsapp_Number__c, G11_Whatsapp_Number__c From Contact Where createdDate != null';
        
        if(grade == 'Grade 10'){
            query += ' AND Currently_Studying_In__c =\'Grade 9\' AND G10_Batch_Code__c  = null ';
            query += ' AND Batch_Code__r.School_Name__c = :schoolId AND Batch_Code__r.Academic_Year__c = :previousAcademicYear';
        }else if(grade == 'Grade 11'){
            query += ' AND Currently_Studying_In__c =\'Grade 10\' AND G11_Batch_Code__c  = null ';
            query += ' AND (G10_Batch_Code__c != null AND G10_Batch_Code__r.School_Name__c = :schoolId AND G10_Batch_Code__r.Academic_Year__c = :previousAcademicYear ) ';
        }else if(grade == 'Grade 12'){
            query += ' AND Currently_Studying_In__c =\'Grade 11\' AND G12_Batch_Code__c  = null  ';
            query += ' AND (G11_Batch_Code__c != null AND  G11_Batch_Code__r.School_Name__c = :schoolId AND G11_Batch_Code__r.Academic_Year__c = :previousAcademicYear ) ';
        }else{
            throw new AuraHandledException('Invalid Grade : '+grade);
        }
        
        String recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
        // And Form_Name__c = \'Form V2\' AND (Batch_Code__r.School_Name__r.District__c =: districtId OR G10_Batch_Code__r.School_Name__r.District__c =: districtId OR G11_Batch_Code__r.School_Name__r.District__c =: districtId OR G12_Batch_Code__r.School_Name__r.District__c =: districtId)';
        
        // And Form_Name__c = \'Form V2\'
        query += ' AND RecordTypeId =: recordTypeId ORDER BY Name '; 
        
        List<Contact> contacts = new List<Contact>();
        try {
            contacts = Database.query(query);
            
            
            Map<String, Object> response = new Map<String, Object>();
            response.put('contacts', contacts);
            response.put('contacts_count', contacts.size());
            response.put('batch', bt);
            
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Contact> saveLinkStudents(list<String> selectedContactIds, String batchId, String grade){
        if(String.isNotBlank(batchId)){
            
            batch__c bt = [ SELECT Id, Academic_Year__c, School_Name__c, School_Name__r.Name, Grade__c, School_Name__r.State__r.State_Code__c, School_Name__r.District__c, School_Name__r.District__r.Academic_Year__c, School_Name__r.District__r.Barcode_starts_with__c FROM Batch__c WHERE id =:batchId LIMIT 1];
            String barcodeBenchMark = getBarcodeStartNumber(bt);
            if(String.isBlank(barcodeBenchMark) || barcodeBenchMark.length() != 10){
                throw new AuraHandledException('Failed while generating bulk Barcode');
            }
            
            Integer previousAcademicYear = Integer.valueOf(bt.Academic_Year__c) - 1;
            Integer barcodeIndex = Integer.valueOf(barcodeBenchMark.right(6));
            String barcodePrefix = barcodeBenchMark.left(4);
            
            String schoolId = bt.School_Name__c;
            String query = 'Select Id, G9_Whatsapp_Number__c, G10_Whatsapp_Number__c, G11_Whatsapp_Number__c From Contact Where Id IN :selectedContactIds ';
            if(grade == 'Grade 10'){
                query += ' AND Currently_Studying_In__c =\'Grade 9\' AND G10_Batch_Code__c  = null ';
                query += ' AND Batch_Code__r.School_Name__c = :schoolId AND Batch_Code__r.Academic_Year__c = :previousAcademicYear ';
            }else if(grade == 'Grade 11'){
                query += ' AND Currently_Studying_In__c =\'Grade 10\' AND G11_Batch_Code__c  = null ';
                query += ' AND (G10_Batch_Code__c != null AND G10_Batch_Code__r.School_Name__c = :schoolId AND G10_Batch_Code__r.Academic_Year__c = :previousAcademicYear ) ';
            }else if(grade == 'Grade 12'){
                query += ' AND Currently_Studying_In__c =\'Grade 11\' AND G12_Batch_Code__c  = null  ';
                query += ' AND (G11_Batch_Code__c != null AND  G11_Batch_Code__r.School_Name__c = :schoolId AND G11_Batch_Code__r.Academic_Year__c = :previousAcademicYear ) ';
            }
            String recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
            query += ' AND RecordTypeId =: recordTypeId ORDER BY Name '; 

            Map<Id, sObject> contactMap = new Map<Id, sObject>(Database.query(query));
            List<Contact> contacts = new List<Contact>();
            for(String recId : selectedContactIds){
                if(contactMap.containsKey(recId)){
                    Contact con = new Contact();
                    con.Id = recId;
                    Contact conRef = (Contact) contactMap.get(recId);
                    // AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
                    // con.Academic_Year__c = setting.Next_Academic_Year__c;

                    // con.Academic_Year__c = bt.School_Name__r.District__r.Academic_Year__c;

                    // con.Bar_Code__c = barcodePrefix + String.valueOf(barcodeIndex);
                    
                    if(grade == 'Grade 10'){
                        // Commented Barcode (UUID) not to Override as this code will only generated when the student is Created.
                        // con.Bar_Code__c = 
                        //con.Grade_10_Barcode__c = barcodePrefix +  String.valueOf(barcodeIndex).leftPad(6, '0');
                        con.G10_Batch_Code__c = bt.Id;
                        con.Currently_Studying_In__c = 'Grade 10';
                        con.G10_Whatsapp_Number__c = conRef.G9_Whatsapp_Number__c;
                    }else  if(grade == 'Grade 11'){
                        // Commented Barcode (UUID) not to Override as this code will only generated when the student is Created.
                        // con.Bar_Code__c = 
                        //con.Grade_11_Barcode__c = barcodePrefix +  String.valueOf(barcodeIndex).leftPad(6, '0');
                        con.G11_Batch_Code__c = bt.Id;
                        con.Currently_Studying_In__c = 'Grade 11';
                        con.G11_Whatsapp_Number__c = conRef.G10_Whatsapp_Number__c;
                    }else  if(grade == 'Grade 12'){
                        // Commented Barcode (UUID) not to Override as this code will only generated when the student is Created.
                        // con.Bar_Code__c =
                        //con.Grade_12_Barcode__c = barcodePrefix +  String.valueOf(barcodeIndex).leftPad(6, '0');
                        con.G12_Batch_Code__c = bt.Id;
                        con.Currently_Studying_In__c = 'Grade 12';
                        con.G12_Whatsapp_Number__c = conRef.G11_Whatsapp_Number__c;
                    }
                    system.debug('Barcode : '+ barcodePrefix +  String.valueOf(barcodeIndex).leftPad(6, '0'));
                    contacts.add(con);
                    barcodeIndex++;  
                }                  
            }

            try{
                
                if(contacts.size() > 0){
                    update contacts;
                    List<AsyncApexJob> runningJobs = [
                        SELECT Id, Status, JobType, ApexClass.Name
                        FROM AsyncApexJob
                        WHERE Status = 'Processing' 
                          AND JobType = 'Queueable'
                          AND ApexClass.Name = 'BarcodeGenerationQueueable'
                    ];
                    system.debug('runningJobs = '+runningJobs.size());
                    if (runningJobs.size() > 0) {
                        system.debug('After 1 min');
                        Integer delayInMinutes = 1;
                        System.enqueueJob(new BarcodeGenerationQueueable(contacts, grade, bt, 'Form V2', true), delayInMinutes);
    
                    }else{
                        system.debug('Scheduled');
                         System.enqueueJob(new BarcodeGenerationQueueable(contacts, grade, bt, 'Form V2', true));
                    }
                }

                contacts = [Select Id, Name, G9_Whatsapp_Number__c, G10_Whatsapp_Number__c, G11_Whatsapp_Number__c, G12_Whatsapp_Number__c, What_are_you_currently_studying__c From Contact Where Id IN :selectedContactIds  ORDER BY Name ];
                return contacts;
            }catch(Exception e){
                throw new AuraHandledException('Failed While Generating Barcode : '+e.getMessage());
            }
        }else{
            throw new AuraHandledException('Batch Not Found'); 
        }
    }
    
    
    @AuraEnabled
    public static String getBarcodeStartNumber(batch__c bt){
        try {
            AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
            
            // batch__c bt =  new batch__c();
            //bt = BaselineController.getBatchCodeName(batchId);
            string startChar = String.valueOf(Integer.valueOf(setting.Next_Academic_Year__c)).right(2) + String.valueOf(bt.School_Name__r.State__r.State_Code__c).leftPad(2, '0');
            String startCharFromDistict = String.valueOf(Integer.valueOf(bt.School_Name__r.District__r.Academic_Year__c)).right(2) + String.valueOf(bt.School_Name__r.State__r.State_Code__c).leftPad(2, '0');
            string districtId = bt.School_Name__r.District__c;
            
            Integer barcode;
            String generatedBarcode; 
            
            contact maxBarcode =  new contact();
            String recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();

            String startCharacCondition = startCharFromDistict+'%';
            // AND Form_Name__c = 'Form V2' 
            for(contact cn : [Select Id, Bar_Code__c, Latest_Barcode__c From Contact Where RecordTypeId =:recordTypeId AND Latest_Barcode__c != '0' AND Latest_Barcode__c LIKE :startCharacCondition AND Bar_Code__c != NULL AND (Batch_Code__r.School_Name__r.District__c =: districtId OR G10_Batch_Code__r.School_Name__r.District__c =: districtId OR G11_Batch_Code__r.School_Name__r.District__c =: districtId OR G12_Batch_Code__r.School_Name__r.District__c =: districtId) Order By Latest_Barcode__c desc Nulls last limit 1 ]){
                system.debug(cn.Bar_Code__c);
                system.debug(cn.Latest_Barcode__c);
                system.debug(startChar);
                // if( (cn.Bar_Code__c.startsWithIgnoreCase(startChar) || cn.Bar_Code__c.startsWithIgnoreCase(startCharFromDistict) )&& cn.Bar_Code__c.length() == 10) {
                if( cn.Latest_Barcode__c.startsWithIgnoreCase(startCharFromDistict) && cn.Latest_Barcode__c.length() == 10) {
                    system.debug(cn.Bar_Code__c);
                    maxBarcode = cn;
                    break;
                } 
            }
            
            if(maxBarcode.id != null && bt.School_Name__r.District__r.Barcode_starts_with__c != null){
                barcode =  Integer.ValueOf(maxBarcode.Latest_Barcode__c.right(maxBarcode.Latest_Barcode__c.length()-4)) + 1;
                // generatedBarcode = String.valueOf(Integer.valueOf(setting.Next_Academic_Year__c)).right(2) + String.valueOf(bt.School_Name__r.State__r.State_Code__c).leftPad(2, '0') + String.valueOf(barcode).leftPad(6, '0');
                generatedBarcode = String.valueOf(Integer.valueOf(bt.School_Name__r.District__r.Academic_Year__c)).right(2) + String.valueOf(bt.School_Name__r.State__r.State_Code__c).leftPad(2, '0') + String.valueOf(barcode).leftPad(6, '0');
            }else if(bt.School_Name__r.District__r.Barcode_starts_with__c != null){
                barcode = Integer.ValueOf(bt.School_Name__r.District__r.Barcode_starts_with__c);
                // generatedBarcode = String.valueOf(Integer.valueOf(setting.Next_Academic_Year__c)).right(2) + String.valueOf(bt.School_Name__r.State__r.State_Code__c).leftPad(2, '0') + String.valueOf(barcode).leftPad(6, '0');
                generatedBarcode = String.valueOf(Integer.valueOf(bt.School_Name__r.District__r.Academic_Year__c)).right(2) + String.valueOf(bt.School_Name__r.State__r.State_Code__c).leftPad(2, '0') + String.valueOf(barcode).leftPad(6, '0');
            }else{
                generatedBarcode = '';
            }
            return generatedBarcode;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static void updateLinkedStudents(List<Contact> contacts){
        try{
            system.debug(string.valueOf(contacts[0]));
            update contacts;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
}