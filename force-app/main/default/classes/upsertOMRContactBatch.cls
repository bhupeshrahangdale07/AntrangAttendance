public class upsertOMRContactBatch implements Database.Batchable<sObject>, Database.stateful {
    
    List<Contact> conLST = new List<Contact>();
    String Batchname = '';
    String selectedGrade = '';
    String selectedOMRType = '';
    String successTBL = '<table border="1"><tr align="center"><th>Barcode</th><th>Status</th></tr>';
    String errorTBL = '<table border="1"><tr align="center"><th>Barcode</th><th>Error Message</th></tr>';
    Boolean isAnyException = false;
    Boolean isAnySuccess = false;
    Integer successRecords = 0;
    Integer failedRecords = 0;
    Map<String,String> expectedGrade = new Map<String,String>();    //By Kandisa 11/07/2023 : Added
    String selectedEmail = '';
    String timeStamp;
    Integer lastNameCount =0;
    string logId;
    Integer duplicateIdCount=0;
    public upsertOMRContactBatch(List<Contact> conLST, String Batchname, String selectedGrade, String selectedOMRType){
        this.conLST = conLST;
        this.Batchname = Batchname;
        this.selectedGrade = selectedGrade;
        this.selectedOMRType = selectedOMRType;
        
    }

    public upsertOMRContactBatch(List<Contact> conLST, Map<String,String> expectedGrade, String selectedOMRType, String selectedEmail,String timeStamp, string logId){
        this.conLST = conLST;
        this.expectedGrade = expectedGrade;
        this.selectedOMRType = selectedOMRType;
        this.selectedEmail = selectedEmail;
        this.timeStamp = timeStamp;
        this.logId = logId;
    }

    public List<Contact> start(Database.BatchableContext BC){
        return conLST;
    }
    
    public void execute(Database.BatchableContext BC, List<Contact> conLST){
        try{

        if(conLST.size() > 0){
            Database.UpsertResult[] results = Database.upsert(conLST, false);
            if(selectedOMRType == 'Baseline 1' && !expectedGrade.isEmpty())
            {
                for(Integer index = 0, size = results.size(); index < size; index++) {
                    String processedBarCode = '';
                    if(conLST[index].Grade_9_Barcode__c != null && expectedGrade.containsKey(conLST[index].Grade_9_Barcode__c))
                    {
                        processedBarCode = conLST[index].Grade_9_Barcode__c;
                    }
                    else if(conLST[index].Grade_10_Barcode__c != null && expectedGrade.containsKey(conLST[index].Grade_10_Barcode__c))
                    {
                        processedBarCode = conLST[index].Grade_10_Barcode__c;
                    }
                    else if(conLST[index].Grade_11_Barcode__c != null && expectedGrade.containsKey(conLST[index].Grade_11_Barcode__c))
                    {
                        processedBarCode = conLST[index].Grade_11_Barcode__c;
                    }
                    else if(conLST[index].Grade_12_Barcode__c != null && expectedGrade.containsKey(conLST[index].Grade_12_Barcode__c))
                    {
                        processedBarCode = conLST[index].Grade_12_Barcode__c;
                    }

                    if(results[index].isSuccess()) {  
                        successRecords++;
                        isAnySuccess = true;               
                        if(processedBarCode != '')
                        {
                            successTBL += '<tr><td>' + processedBarCode + '</td><td>SUCCESS</td></tr>';
                        }
                    } else {
                        failedRecords++;
                        
                        for(Database.Error err : results[index].getErrors()) {
                            isAnyException = true;                 
                            if(processedBarCode != '')
                            {
                                errorTBL += '<tr><td>' + processedBarCode + '</td><td>'+err.getFields() + ' : '+ err.getMessage() +'</td></tr>';
                                if(err.getMessage().contains('LastName')){
                                    lastNameCount++;
                                }
                                if(err.getMessage().contains('duplicates value on record with id')){
                                    duplicateIdCount++;
                                }
                                
                            }
                        }
                    }   
                }
            }
            
            // if(selectedOMRType == 'Baseline 1'){
            //     for(Integer index = 0, size = results.size(); index < size; index++) {
            //         if(results[index].isSuccess()) {
            //             if(selectedGrade == 'Grade 9'){
            //                 successTBL += '<tr><td>' + conLST[index].Grade_9_Barcode__c + '</td><td>SUCCESS</td></tr>';   
            //             } else if(selectedGrade == 'Grade 10'){
            //                 successTBL += '<tr><td>' + conLST[index].Grade_10_Barcode__c + '</td><td>SUCCESS</td></tr>';
            //             } else if(selectedGrade == 'Grade 11'){
            //                 successTBL += '<tr><td>' + conLST[index].Grade_11_Barcode__c + '</td><td>SUCCESS</td></tr>';
            //             } else if(selectedGrade == 'Grade 12'){
            //                 successTBL += '<tr><td>' + conLST[index].Grade_12_Barcode__c + '</td><td>SUCCESS</td></tr>';
            //             }
            //         } else {
            //             for(Database.Error err : results[index].getErrors()) {
            //                 isAnyException = true;
            //                 if(selectedGrade == 'Grade 9'){
            //                     errorTBL += '<tr><td>' + conLST[index].Grade_9_Barcode__c + '</td><td>'+err.getFields() + ' : '+ err.getMessage() +'</td></tr>';   
            //                 } else if(selectedGrade == 'Grade 10'){
            //                     errorTBL += '<tr><td>' + conLST[index].Grade_10_Barcode__c + '</td><td>'+err.getFields() + ' : '+ err.getMessage() +'</td></tr>';
            //                 } else if(selectedGrade == 'Grade 11'){
            //                     errorTBL += '<tr><td>' + conLST[index].Grade_11_Barcode__c + '</td><td>'+err.getFields() + ' : '+ err.getMessage() +'</td></tr>';
            //                 } else if(selectedGrade == 'Grade 12'){
            //                     errorTBL += '<tr><td>' + conLST[index].Grade_12_Barcode__c + '</td><td>'+err.getFields() + ' : '+ err.getMessage() +'</td></tr>';
            //                 }
            //             }
            //         }
            //     }    
            // }
        }

        } catch(Exception ex) {
            System.debug('upsertOMRContactBatch.execute ; ex.getMessage() :' + ex.getMessage());
            System.debug('upsertOMRContactBatch.execute ; ex.getLineNumber() :' + ex.getLineNumber());
            sendExceptionMail(ex.getMessage(),selectedEmail,timeStamp);
        }
    }
    
    public void finish(Database.BatchableContext BC){
        try{
            if(selectedOMRType == 'Baseline 1' && isAnySuccess){
                successTBL += '</table>';
    
                String finalMessage = '';
                finalMessage = '<p>Total records succeeded : '+successRecords+'</p>';        
                finalMessage += successTBL;
    
                String strSubject = Label.Baseline_1_Email_Success_Msg +' ';
                if(timeStamp != null)strSubject += timeStamp;
                else strSubject += System.now().format();
    
                List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setSubject(strSubject);
                //msg.setSubject(Label.Baseline_1_Email_Success_Msg + Batchname + ' (' + selectedGrade + ')');   
                //msg.setHTMLbody(successTBL);
                msg.setHTMLbody(finalMessage);
                msg.setToAddresses(new List<String>{selectedEmail});
                msg.setCcAddresses(Label.OMR_Email_Ids.split(';'));
                lstMsgs.add(msg);
                if(!Test.isRunningTest())
                {
                    Messaging.sendEmail(lstMsgs);
                }
            }
            
            if(selectedOMRType == 'Baseline 1' && isAnyException){
                errorTBL += '</table>';
    
                String finalMessage = '';
                finalMessage = '<p>Total records failed : '+failedRecords+'</p>';        
                finalMessage += errorTBL;
    
                String strSubject = 'OMR Process Exception : ';
                if(timeStamp != null)strSubject += timeStamp;
                else strSubject += System.now().format();
    
                List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
                Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
                msg.setSubject(strSubject);
                //msg.setSubject('OMR Process Exception');
                //msg.setHTMLbody(errorTBL);
                msg.setHTMLbody(finalMessage);
                msg.setToAddresses(new List<String>{selectedEmail});
                msg.setCcAddresses(Label.OMR_Email_Ids.split(';'));
                lstMsgs.add(msg);
                if(!Test.isRunningTest())
                {
                    Messaging.sendEmail(lstMsgs);
                }
                system.debug('logId ='+logId);
                /*if((lastNameCount != 0 || duplicateIdCount != 0) && (logId != null)){
                    if(!Test.isRunningTest()){
                        OMR_Manager_Log__c errorLogRecord = [select id,Last_Name_Missing__c,Duplicate_Barcode_found__c from OMR_Manager_Log__c where 
                        id = : logId limit 1];
                        errorLogRecord.Last_Name_Missing__c = lastNameCount;
                        errorLogRecord.Duplicate_Barcode_found__c = duplicateIdCount;
                        update errorLogRecord;
                    }
                }else if(logId == null && (lastNameCount != 0 || duplicateIdCount != 0)){
                    if(!Test.isRunningTest()){
                        OMR_Manager_Log__c errorLogRecord = new OMR_Manager_Log__c();
                        errorLogRecord.Last_Name_Missing__c = lastNameCount;
                        errorLogRecord.Duplicate_Barcode_found__c = duplicateIdCount;
                        insert errorLogRecord;
                    }
                }*/
                if (!Test.isRunningTest() && (lastNameCount != 0 || duplicateIdCount != 0)) {
                     AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
                    OMR_Manager_Log__c errorLogRecord = new OMR_Manager_Log__c(
                        Id = logId, 
                        Last_Name_Missing__c = lastNameCount, 
                        Duplicate_Barcode_found__c = duplicateIdCount,
                        Timestamp__c = System.now(),
                        Academic_year__c = Integer.valueOf(antarangSett.Academic_Year__c),
                        POC_Email__c = selectedEmail
                        
                    );
                
                    upsert errorLogRecord;
                }
              
            }
        } catch(Exception ex) {
            System.debug('upsertOMRContactBatch.finish ; ex.getMessage() :' + ex.getMessage());
            System.debug('upsertOMRContactBatch.finish ; ex.getLineNumber() :' + ex.getLineNumber());
            sendExceptionMail(ex.getMessage(),selectedEmail,timeStamp);
        }
        
    }

    public static void sendExceptionMail(String errMsg, String selectedEmail, String timeStamp){
        //String timeStamp = System.now().format();
        String strSubject = 'DML Exception OMR Batch:' +' '+timeStamp;
        List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setSubject(strSubject);
        //msg.setSubject('OMR Process System Exception');     
        msg.setPlainTextBody(errMsg);
        msg.setToAddresses(new List<String>{selectedEmail});
        msg.setCcAddresses(Label.OMR_Email_Ids.split(';'));
        lstMsgs.add(msg);
        if(!Test.isRunningTest())
        {
            Messaging.sendEmail(lstMsgs);
        }
    }
   
}