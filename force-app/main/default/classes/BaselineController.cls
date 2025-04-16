public without sharing class BaselineController {
    @AuraEnabled
        public static string createContact(object contactData, string grade, string schoolId, string batchId) {
        try {
            system.debug('batchId='+batchId);
            AntarangSetting__c setting = AntarangSetting__c.getOrgDefaults();
            String contactData1 = Json.serialize(contactData);
            contactDataWrapper dt = (contactDataWrapper) System.JSON.deserialize(contactData1, contactDataWrapper.class);
           
            
            dt.firstname = dt.firstname.trim();
            dt.lastname = dt.lastname.trim();
            
            
            list<Contact> lst = [select id from contact where FirstName =: dt.firstname and LastName =: dt.lastname and (Batch_Code__c  =: batchId OR 
                              G10_Batch_Code__c =:  batchId  OR 
                               G11_Batch_Code__c  =: batchId OR G12_Batch_Code__c  =: batchId)];
            system.debug('lst = '+lst);
            system.debug('lst = '+lst.size());
            batch__c bt =  new batch__c();
            system.debug('grade = '+grade);
            if(grade == 'Grade 9')bt = BaselineController.getBatchCodeName(dt.batchCodeG9);
            if(grade == 'Grade 10')bt = BaselineController.getBatchCodeName(dt.batchCodeG10);
            if(grade == 'Grade 11')bt = BaselineController.getBatchCodeName(dt.batchCodeG11);
            if(grade == 'Grade 12')bt = BaselineController.getBatchCodeName(dt.batchCodeG12);
            if(lst.size() == 0){
                Contact con = new Contact();
                con.FirstName=dt.firstname;
                con.LastName=dt.lastname;
                con.Year_of_Birth__c=dt.yrOfBirth;
                con.Gender__c=dt.gender;
                con.Currently_Studying_In__c = dt.currStudyIn;
                con.Batch_Code__c = dt.batchCodeG9;
                con.G10_Batch_Code__c = dt.batchCodeG10;
                con.G11_Batch_Code__c = dt.batchCodeG11;
                con.G12_Batch_Code__c = dt.batchCodeG12;
                con.G9_Whatsapp_Number__c = dt.wuppNoG9;
                con.G10_Whatsapp_Number__c = dt.wuppNoG10;
                con.G11_Whatsapp_Number__c = dt.wuppNoG11;
                con.G12_Whatsapp_Number__c = dt.wuppNoG12;
                con.G9_Alternate_Mobile_No__c = dt.AlterWuppNoG9;
				con.G10_Alternate_Mobile_No__c = dt.AlterWuppNoG10;
                con.G11_Alternate_Mobile_No__c = dt.AlterWuppNoG11;
                con.G12_Alternate_Mobile_No__c = dt.AlterWuppNoG12;

                con.What_are_you_currently_studying__c = dt.whatCurrStuIn;
                con.Form_Name__c = dt.typ;
                con.Form_Language__c = dt.lng;
                
                insert con;
                list<contact> lstContact = new list<contact>();
                lstContact.add(con);
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
					System.enqueueJob(new BarcodeGenerationQueueable(lstContact, grade, bt, dt.typ), delayInMinutes );

                }else{
                    system.debug('Scheduled');
                     System.enqueueJob(new BarcodeGenerationQueueable(lstContact, grade, bt, dt.typ));
                }
                //System.enqueueJob(new BarcodeGenerationQueueable(con, grade, bt, dt.typ));
                return 'saved';
            }else{
                return 'duplicate';
            }
        }
        catch(DmlException e) {
            system.debug('error='+e.getMessage());
            return('An unexpected error has occurred: ' + e.getMessage());
        }
    }
    @AuraEnabled
    public static Batch__c getBatchCodeName(string batchId) {
        Batch__c bt = [select name, Batch_Number__c,School_Name__r.name, School_Name__r.District__r.Academic_Year__c, 
                        Grade__c,School_Name__c,School_Name__r.State__c,
                       School_Name__r.State__r.State_Code__c,School_Name__r.Barcode_starts_with__c,School_Name__r.Barcode_ends_with__c,
                       School_Name__r.District__c, School_Name__r.District__r.Barcode_starts_with__c from 
                       Batch__c where id=: batchId];
        system.debug('bt = '+bt.School_Name__r.State__r.State_Code__c);
        return bt;
    }

    @AuraEnabled
    public static Batch__c schoolnGradebyBatchId(Id batchId){ 
        Batch__c bt = [ SELECT Id, School_Name__c, School_Name__r.Name, Grade__c 
                                    FROM Batch__c 
                                    WHERE id =:batchId ];
        return bt;
    }
    
    @AuraEnabled
    public static District_Master__c getSchoolDistrictData(Id schoolId){ 
        Account schoolDetails = [ SELECT Id, District__c
                           		  FROM Account 
                                  WHERE id =:schoolId ];
        
        District_Master__c districtDetails = [ SELECT Select_Forms_to_Show_in_Baseline_for_G9__c, Select_Forms_to_Show_in_Endline_for_G9__c, 
                                                      Select_Forms_to_Show_in_Baseline_for_G10__c, Select_Forms_to_Show_in_Endline_for_G10__c, 
                                                      Select_Forms_to_Show_in_Baseline_for_G11__c, Select_Forms_to_Show_in_Endline_for_G11__c, 
                                                      Select_Forms_to_Show_in_Baseline_for_G12__c, Select_Forms_to_Show_in_Endline_for_G12__c 
                                               FROM District_Master__c 
                                               WHERE Id = :schoolDetails.District__c ];
        return districtDetails;
    }

    public class contactDataWrapper{
        public String firstname;
        public String middlename;
        public String lastname; 
        public Integer yrOfBirth;
        public string gender;
        public string whatCurrStuIn;
        public string currStudyIn;
        public string alternateNoG9;
        public string batchCodeG9;
        public string batchCodeG10;
        public string batchCodeG11;
        public string batchCodeG12;
        public string wuppNoG9;
        public string wuppNoG10;
        public string wuppNoG11;
        public string wuppNoG12;
         public string AlterWuppNoG9;
         public string AlterWuppNoG10;
         public string AlterWuppNoG11;
         public string AlterWuppNoG12;

         public string typ;
         public string lng;

    }
}