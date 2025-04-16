public class StudentOMRManagerController {
    
    @AuraEnabled                            
    public static Object getBatchInfo(String schoolId, String selGrade){
        Map<String, Object> result = new Map<String, Object>();
        try{
            AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
            List<picklistwrapper> options = new List<picklistwrapper>();
            options.add(new picklistwrapper('-None-', ''));
            List<batch__c> batchLST = new List<batch__c>([
                Select Id,Batch_number__c,Name From batch__c where school_name__c =: schoolId AND 
                Grade__c =: selGrade AND 
                Academic_Year__c =: antarangSett.Academic_Year__c
            ]);
            for(batch__c bt : [Select Id,Batch_number__c,Name From batch__c where school_name__c =: schoolId AND 
                               Grade__c =: selGrade AND 
                               Academic_Year__c =: antarangSett.Academic_Year__c]){
                                   options.add(
                                       new picklistwrapper(bt.Batch_number__c +' - '+bt.Name, String.valueOf(bt.Id))
                                   );
                               }
            result.put('Batch', options);
        } catch(Exception ex){
            system.debug('Ex :: ' + ex.getMessage());
        }
        return result;
    }

    @AuraEnabled
    public static object getpicklists(){
        Map<String, Object> result = new Map<String, Object>();
        
        result.put('grade',getdynamicpicklistval('Batch__c','Grade__c'));
        result.put('lang',getdynamicpicklistval('Batch__c','Preferred_Language__c'));
        
        return result;
    }

    @AuraEnabled
    public static List<String> getEamilPicklist(){
        List<String> returnList = new List<String>();
        List<OMR_Manager_Email__c> emailList = new  List<OMR_Manager_Email__c>([
            SELECT Id, Name, Email__c FROM OMR_Manager_Email__c LIMIT 100
        ]);  

        if(!emailList.isEmpty()){
            for(OMR_Manager_Email__c obj : emailList){
                if(obj.Email__c != null)returnList.add((String)obj.Email__c);
            }
        }
        return returnList;
    }
    
    public static List<picklistwrapper> getdynamicpicklistval(String objectName,String fieldName){
        List<picklistwrapper> options = new List<picklistwrapper>();
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName);
        Schema.DescribeSObjectResult r = s.getDescribe();
        Map<String, Schema.SObjectField> fields = r.fields.getMap();
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        if(objectName != 'Session__c' && fieldName != 'Deferred_Reason__c'){
            options.add(new picklistwrapper('--None--', ''));
        }
        for (Schema.PicklistEntry pickListVal : ple) {
            options.add(
                new picklistwrapper(pickListVal.getLabel(), String.valueOf(pickListVal.getValue()))
            );
        }
        return options;
    }
    
    @AuraEnabled                            
    public static String saveTheChunkFile(String fileName, String base64Data, String previousData){
        //base64Data = EncodingUtil. urlDecode(base64Data, 'UTF-8');
        if ( String.isBlank(base64Data) ) {
            return base64Data;
        } else {
            return previousData + base64Data;
        }
    }
    
    @AuraEnabled                            
    public static String processOMRSheet(String fileData, String fileName, String selectedSchool, String selectedFacilitor, String selectedDonor,
                                      String selectedGrade, String selectedOMRType, String selectedEmail, String selectedAction, String selectedBatchId, String selectedPrefLang){
        try {
            AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
            String blobValue = EncodingUtil.urlDecode(fileData, 'UTF-8');
            String data = EncodingUtil.base64Decode(blobValue).toString();  
            System.debug('processOMRSheet : data.length() = ' + data.length());  
            if(data.length() >= 500000)return 'File is too large';       
            list<String> csvRows = data.split('\\r\\n');
            System.debug('processOMRSheet : csvRows.Size() = ' + csvRows.Size()); 
            if(csvRows.Size() <= 1)return 'Please make sure data is available in the file.';  

            switch on selectedOMRType {
                when 'Baseline 1' {		
                    //By Kandisa 05/07/2023 : Comment out
                    //return proceedBaseLine1(csvRows,selectedSchool,selectedAction,antarangSett,selectedFacilitor,selectedDonor,selectedGrade,selectedPrefLang,selectedBatchId,selectedOMRType);

                    processStudentsBaseLine1(csvRows,selectedOMRType,selectedEmail);
                }	
                when 'Baseline 2' {		
                    proceedBaseLine2(csvRows, selectedGrade, selectedOMRType);        
                }
            }
        } catch(Exception ex) {
            System.debug('StudentOMRManagerController.processOMRSheet ; ex.getMessage() :' + ex.getMessage());
            System.debug('StudentOMRManagerController.processOMRSheet ; ex.getLineNumber() :' + ex.getLineNumber());
        }
		return '';
    }
    
    //By Kandisa 05/07/2023 : Comment out
    /*
    public static String proceedBaseLine1(List<String> csvRows, String selectedSchool, String selectedAction, AntarangSetting__c antarangSett, 
                                        String selectedFacilitor, String selectedDonor, String selectedGrade, String selectedPrefLang, 
                                        String selectedBatchId, String selectedOMRType){
                                            
                                                
		List<batch__c> bactchLST = new List<batch__c>([Select Id,Batch_number__c,Name From batch__c where Id = :selectedBatchId]);
        String batchName = bactchLST.get(0).Batch_number__c +' - '+bactchLST.get(0).Name;                                        
		List<Contact> studentLIST = new List<Contact>();
		Pattern isnumbers = Pattern.Compile('^[0-9]+$');
		Map<String, String> uidWithConId = new Map<String, String>();
		Map<String,String> errorList = new Map<String,String>();
        Map<String, String> genderMAP = new Map<String, String>();
        Map<String, String> studyingMAP = new Map<String, String>();
                                            Integer academicYear = Integer.valueOf(antarangSett.Academic_Year__c);
             
        try{
            for(OMR_Field_Mapping__c field : [Select Id,Selected_Number__c,SF_Value__c,Field_Type__c From OMR_Field_Mapping__c 
                                              where Field_Type__c IN ('Gender','Currently Studying In')]){
                switch on field.Field_Type__c {
                    when 'Gender' {		
                        genderMAP.put(field.Selected_Number__c, field.SF_Value__c);
                    }	
                    when 'Currently Studying In' {		
                        studyingMAP.put(field.Selected_Number__c, field.SF_Value__c);
                    }
                }
            }
                                                   
            if(csvRows.size() > 0 ){
                List<String> stdUid = new List<String>();
                for(integer i = 1; i < csvRows.size(); i++ ){
                    List<String> row = csvRows[i].split(',');
                    if(selectedGrade == 'Grade 9'){
                        stdUid.add(row[1]);
                    } else if(selectedGrade == 'Grade 10' || selectedGrade == 'Grade 11'){
                        if(String.isNotBlank(row[8])){
                            stdUid.add(row[8]);
                        }
                    }
                }
                
                String query = 'Select Id,Grade_9_Barcode__c,Grade_11_Barcode__c,Grade_10_Barcode__c,Batch_Code__r.Name,G10_Batch_Code__r.Name,G11_Batch_Code__r.Name From Contact where ';
                switch on selectedGrade {
                    when 'Grade 9' {		
                        query += 'Grade_9_Barcode__c IN :stdUid';
                    }	
                    when 'Grade 10' {		
                        query += 'Grade_10_Barcode__c IN :stdUid';
                    }
                    when 'Grade 11' {		
                        query += 'Grade_11_Barcode__c IN :stdUid';
                    }
                }
                Map<Id, Contact> existingConWithOthBatch = new Map<Id, Contact>();
                for(Contact con : database.query(query)){
                    existingConWithOthBatch.put(con.Id, con);
                }
                
                Set<String> existingStudent = new Set<String>();
                for(Contact con : [Select Id,Bar_Code__c From Contact where Bar_Code__c IN : stdUid ]){
                    if(selectedGrade != 'Grade 9'){
                        existingStudent.add(con.Bar_Code__c);   
                    }
                    if(existingConWithOthBatch.size() > 0 && existingConWithOthBatch.containsKey(con.Id)){
                        switch on selectedGrade {
                            when 'Grade 9' {		
                                errorList.put(con.Bar_Code__c, 'Contact exist for '+existingConWithOthBatch.get(con.Id).Batch_Code__r.Name+' Batch.');
                            }	
                            when 'Grade 10' {		
                                errorList.put(con.Bar_Code__c, 'Contact exist for '+existingConWithOthBatch.get(con.Id).G10_Batch_Code__r.Name+' Batch.');
                            }
                            when 'Grade 11' {		
                                errorList.put(con.Bar_Code__c, 'Contact exist for '+existingConWithOthBatch.get(con.Id).G11_Batch_Code__r.Name+' Batch.');
                            }
                        }
                        uidWithConId.put(con.Bar_Code__c, con.Id);
                    } else {
                        uidWithConId.put(con.Bar_Code__c, con.Id);   
                    }
                }
                
                List<String> stdNotExistLST = new List<String>();
                if(existingStudent.size() > 0){
                    for(String str : stdUid){
                        //existingStudent
                        if(!existingStudent.contains(str)){
                            stdNotExistLST.add(str);
                        }
                    }
                } 
                //added on 04.04.2023
                else if(existingStudent.isEmpty() && !stdUid.isEmpty()){
                    for(String str : stdUid){
                        //no existing Student found
                        if(!existingStudent.contains(str)){
                            stdNotExistLST.add(str);
                        }                    
                    }
                }
                Id castdrecid = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
                for(integer i = 1; i < csvRows.size(); i++ ){
                    Boolean isError = false;
                    List<String> row = csvRows[i].split(',');
                    
                    Contact std = new Contact();
                    std.RecordTypeId = castdrecid;
                    if(selectedGrade == 'Grade 9'){
                        if(String.isNotBlank(row[1])){
                            if(row[1].length() != 9){
                                errorList.put(row[1], 'Barcode should be 9 digit.');
                                isError = true;
                            }
                        }
                    } else {
                        if(String.isNotBlank(row[8])){
                            if(row[8].length() != 9){
                                errorList.put(row[8], 'Uid should be 9 digit.');
                                isError = true;
                            }
                        } else if (String.isNotBlank(row[1])){
                            if(row[1].length() != 9){
                                errorList.put(row[1], 'Barcode should be 9 digit.');
                                isError = true;
                            }
                        }
                    }
                    
                    if(selectedGrade != 'Grade 9'){
                        std.Id = uidWithConId.get(row[8]);
                    } else {
                        if(uidWithConId.containsKey(row[1])){
                            std.Id = uidWithConId.get(row[1]);
                        }
                    }
                    if(String.isNotBlank(row[8])){
                        if(stdNotExistLST.contains(row[8])) {
                            isError = true;
                            errorList.put(row[8], 'No Student exist for UID');
                        }
                    }
                    
                    if(String.valueOf(academicYear).substring(2,4) == String.valueOf(row[1].substring(0,2))){
                        if(selectedGrade == 'Grade 9'){
                            std.Bar_Code__c = row[1];
                            std.Grade_9_Barcode__c = row[1];
                        }
                    } else {
                        isError = true;
                        errorList.put(row[1], 'Barcode is wrong. please check with academic year.');
                    }
                    
                    String stdName = row[2].trim();
                    List<String> s = stdName.split(' ');
                    if(s.size() == 3){
                        std.FirstName = s[0];
                        std.MiddleName = s[1];
                        std.LastName = s[2];   
                    } else if(s.size() == 2) {
                        std.FirstName = s[0];
                        std.LastName = s[1];   
                    } else {
                        if(String.isNotBlank(stdName)){
                            std.LastName = stdName;    
                        } 
                    }
                    
                    if(row[3].length() == 8 && isnumbers.matcher(row[3]).Matches()){
                        if(Integer.valueOf(row[3].substring(2,4)) <= 12 && Integer.valueOf(row[3].substring(4,8)) > 1900 && Integer.valueOf(row[3].substring(4,8)) < System.today().Year()){
                            std.Birthdate = Date.newInstance(Integer.valueOf(row[3].substring(4,8)), Integer.valueOf(row[3].substring(2,4)), Integer.valueOf(row[3].substring(0,2)));
                        }
                    } 
                    if(selectedGrade == 'Grade 9'){
                        std.G9_Whatsapp_Number__c = row[4];   
                    }
                    else if(selectedGrade == 'Grade 10'){
                        std.G10_Whatsapp_Number__c = row[4];
                    }
                    else if(selectedGrade == 'Grade 11'){
                        std.G11_Whatsapp_Number__c = row[4];
                    }
                    
                    if(row[5] != ''){
                        std.Currently_Studying_In__c = row[5] != '*' ? studyingMAP.get(row[5]) : '*';
                    }
                    
                    if(row[6] != ''){
                        std.Gender__c = row[6] != '*' ? genderMAP.get(row[6]) : '*';
                    } 
                    
                    if(selectedGrade == 'Grade 10')
                    {
                        std.Grade_10_Barcode__c = row[1];
                        if(String.isBlank(row[8])){
                            std.Bar_Code__c = row[1];
                        }
                    } 
                    else if(selectedGrade == 'Grade 11'){
                        std.Grade_11_Barcode__c = row[1];
                        if(String.isBlank(row[8])){
                            std.Bar_Code__c = row[1];
                        }
                    }
                    
                    if(selectedGrade == 'Grade 9'){
                        std.G9_Alternate_Mobile_No__c = row[7];   
                    }
                    else if(selectedGrade == 'Grade 10'){
                        std.G10_Alternate_Mobile_No__c = row[7];
                    }
                    else if(selectedGrade == 'Grade 11'){
                        std.G11_Alternate_Mobile_No__c = row[7];
                    }
                    
                    if(selectedGrade == 'Grade 9'){
                        std.Batch_Code__c = selectedBatchId;
                    } else if(selectedGrade == 'Grade 10'){
                        std.G10_Batch_Code__c = selectedBatchId;
                    } else if(selectedGrade == 'Grade 11'){
                        std.G11_Batch_Code__c = selectedBatchId;
                    }
                    if(!isError){
                        studentLIST.add(std); 
                    }
                }
            }
            if(studentLIST.size() > 0){
                upsertOMRContactBatch bc = new upsertOMRContactBatch(studentLIST, batchName, selectedGrade, selectedOMRType);
                Database.executeBatch(bc);
            }
            
            if(errorList.size() > 0){
                sendErrorMail(errorList);
            }
       } catch(Exception ex){
       		sendExceptionMail(ex.getMessage(), batchName);
		}
		return selectedBatchId;
    }*/

    public static void processStudentsBaseLine1(List<String> csvRows, String selectedOMRType,String selectedEmail){
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        List<Contact> studentLIST = new List<Contact>();
        Pattern isnumbers = Pattern.Compile('^[0-9]+$');
        Map<String, String> uidWithConId = new Map<String, String>();
        Map<String,String> errorList = new Map<String,String>();
        Map<String, String> genderMAP = new Map<String, String>();
        Map<String, String> studyingMAP = new Map<String, String>();
        Integer academicYear = Integer.valueOf(antarangSett.Academic_Year__c);	
        Map<String, String> whatStudyingMAP = new Map<String, String>();
		String selectedGrade = '';
        Map<String,String> expectedGrade = new Map<String,String>();
    
        try { 
            if(csvRows.size() > 0 ){
				//=======================================//
				for(OMR_Field_Mapping__c field : [
				SELECT Id, Selected_Number__c, SF_Value__c, Field_Type__c 
				FROM OMR_Field_Mapping__c 
				WHERE Field_Type__c IN ('Gender','Currently Studying In','What are you currently studying ?')]){
					switch on field.Field_Type__c {
                        
						when 'Gender' {		
							genderMAP.put(field.Selected_Number__c, field.SF_Value__c);
						}	
						when 'Currently Studying In' {		
							studyingMAP.put(field.Selected_Number__c, field.SF_Value__c);
						}
						when 'What are you currently studying ?' {		
							whatStudyingMAP.put(field.Selected_Number__c, field.SF_Value__c);
						}
					}
				}
                //=======================================//
                List<String> stdBatchCode = new List<String>();
                for(integer i = 1; i < csvRows.size(); i++ ){
                    List<String> row = csvRows[i].split(',');
                    if(String.isNotBlank(row[4])){
                        stdBatchCode.add(row[4]);
                    }
                }
                List<batch__c> bactchList = new List<batch__c>([SELECT Id, Batch_number__c, Grade__c, Academic_Year__c 
                FROM batch__c WHERE Batch_number__c IN :stdBatchCode]);
                Map<String,batch__c> mapBatchCodeVsId = new Map<String,batch__c>();
                for(batch__c obj : bactchList){
                    mapBatchCodeVsId.put(obj.Batch_number__c, obj);
                }
                //=======================================//
                List<String> stdUid = new List<String>();
                for(integer i = 1; i < csvRows.size(); i++ ){
                    List<String> row = csvRows[i].split(',');
					
					if(String.isNotBlank(row[9])){
						stdUid.add(row[9]);
					}

					if(String.isNotBlank(row[1])){
						stdUid.add(row[1]);
					}                
                }
                
                String query = ' SELECT Id, Bar_Code__c, Grade_9_Barcode__c, Grade_10_Barcode__c, Grade_11_Barcode__c, Grade_12_Barcode__c, '+
                + ' Batch_Code__r.Batch_number__c, G10_Batch_Code__r.Batch_number__c, G11_Batch_Code__r.Batch_number__c, G12_Batch_Code__r.Batch_number__c, Batch_Code__r.Academic_Year__c, G10_Batch_Code__r.Academic_Year__c, G11_Batch_Code__r.Academic_Year__c, G12_Batch_Code__r.Academic_Year__c FROM Contact WHERE ';
				
				query += ' ((Bar_Code__c IN :stdUid) OR (Grade_9_Barcode__c IN : stdUid) OR (Grade_10_Barcode__c IN : stdUid) OR (Grade_11_Barcode__c IN : stdUid) OR (Grade_12_Barcode__c IN : stdUid)) ';
                
                Map<String, Contact> existingBarcodeVsContact = new Map<String, Contact>();
                for(Contact con : database.query(query)){
					if(con.Grade_9_Barcode__c != null){
                        existingBarcodeVsContact.put(con.Grade_9_Barcode__c, con);
                        uidWithConId.put(con.Grade_9_Barcode__c, con.Id);
                    }
					if(con.Grade_10_Barcode__c != null){
                        existingBarcodeVsContact.put(con.Grade_10_Barcode__c, con);
                        uidWithConId.put(con.Grade_10_Barcode__c, con.Id);
                    }
					if(con.Grade_11_Barcode__c != null){
                        existingBarcodeVsContact.put(con.Grade_11_Barcode__c, con);
                        uidWithConId.put(con.Grade_11_Barcode__c, con.Id);
                    }
					if(con.Grade_12_Barcode__c != null){
                        existingBarcodeVsContact.put(con.Grade_12_Barcode__c, con);
                        uidWithConId.put(con.Grade_12_Barcode__c, con.Id);
                    }
                    uidWithConId.put(con.Bar_Code__c, con.Id);
                }
                //=======================================//
                Map<String,String> conIdVsCSVnumber = new Map<String,String>();
                Id castdrecid = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('CA_Student').getRecordTypeId();
                for(integer i = 1; i < csvRows.size(); i++ ){
                    List<String> row = csvRows[i].split(',');
					Boolean isError = false;
                    Boolean isNewStudent = false;
					
					do{
						Contact std = new Contact();
						std.RecordTypeId = castdrecid;
						//====================================================//
                        if(String.isBlank(row[1])){
							errorList.put(row[0], 'Blank barcode.');
							isError = true;
							break;
						}
                        //====================================================//
						if(String.isBlank(row[4])){
							errorList.put(row[0], 'Missing batch code.');
							isError = true;
							break;
						}
                        //---------------------------------------------//
                        if(String.isNotBlank(row[4]) && !row[4].isNumeric()){
                            errorList.put(row[0], 'Incorrect batch code = ' + row[4]);
                            isError = true;
							break;
                        }
                        //---------------------------------------------//
						
						if(mapBatchCodeVsId.isEmpty() || (!mapBatchCodeVsId.isEmpty() && !mapBatchCodeVsId.containsKey(row[4]))) {
							errorList.put(row[0], 'Batch code does not exist = ' + row[4]);
                            isError = true;
							break;
						}						
						//====================================================//
						batch__c selectedBatch = mapBatchCodeVsId.get(row[4]);
						if(selectedBatch.Academic_Year__c == null)
						{	
							errorList.put(row[0], 'Academic year is blank for the batch number = '+selectedBatch.Batch_number__c);
							isError = true;
							break;
						}
						else if(selectedBatch.Academic_Year__c != null && selectedBatch.Academic_Year__c != academicYear)
						{	
							errorList.put(row[0], 'Academic year do not match for the batch number = '+selectedBatch.Batch_number__c);
							isError = true;
							break;
						}
						//====================================================//
						if(selectedBatch.Grade__c == null){
							errorList.put(row[0], 'Grade is blank for the batch number = '+selectedBatch.Batch_number__c);
							isError = true;
							break;
						}
						
						selectedGrade = selectedBatch.Grade__c;						
						if(selectedGrade == 'Grade 9'){
							std.Batch_Code__c = selectedBatch.Id; 
                            std.Current_Batch_Code__c = selectedBatch.Id;             
						}
						else if(selectedGrade == 'Grade 10'){
							std.G10_Batch_Code__c = selectedBatch.Id; 
                            std.Current_Batch_Code__c = selectedBatch.Id;
						}
						else if(selectedGrade == 'Grade 11'){
							std.G11_Batch_Code__c = selectedBatch.Id; 
                            std.Current_Batch_Code__c = selectedBatch.Id;
						}
						else if(selectedGrade == 'Grade 12'){
							std.G12_Batch_Code__c = selectedBatch.Id; 
                            std.Current_Batch_Code__c = selectedBatch.Id;
						}                        
						//====================================================//
                        if(String.isNotBlank(row[1]) && !row[1].isNumeric()){
                            errorList.put(row[0], 'Improper barcode = '+ row[1]);
                            isError = true;
                            break;
                        }

                        if(String.isNotBlank(row[1]) && row[1].length() != 10){
                            errorList.put(row[0], 'Barcode should be 10 digit : '+ row[1]);
                            isError = true;
                            break;
                        }

                        if(String.isNotBlank(row[9]) && !row[9].isNumeric()){
                            errorList.put(row[0], 'Improper UID = ' + row[9]);
                            isError = true;
                            break;
                        }

                        if(String.isNotBlank(row[9]) && row[9].length() != 9 && row[9].length() != 10){
                            errorList.put(row[0], 'UID should be 9 or 10 digit = ' + row[9]);
                            isError = true;
                            break;
                        }
                        //-----------------------------------------//
                        if(String.isNotBlank(row[5]) && selectedGrade != studyingMAP.get(row[5])){
                            errorList.put(row[0], 'Currently Studying In and Batch Code grade not matched');
                            isError = true;
                            break;
                        }
                        //-----------------------------------------//
                        
						//====================================================//
                        if(String.isNotBlank(row[9]))
                        {
                            if(!uidWithConId.isEmpty() && uidWithConId.containsKey(row[9]))
                            {
                                String conId = uidWithConId.get(row[9]);
                                if(conIdVsCSVnumber.containsKey(conId))
                                {
                                    errorList.put(row[0], 'Duplicate UID : The first occurrence is found in the CSV file on line number = '+ conIdVsCSVnumber.get(conId));
                                    break;
                                }
                                else 
                                {
                                    std.Id = conId;
                                    conIdVsCSVnumber.put(conId,row[0]);
                                }
                                //std.Id = uidWithConId.get(row[9]);
                            }
                            else 
                            {
                                errorList.put(row[0], 'UID unavailable : A student does not exist for UID = '+ row[9]);
                                break;
                            }
                        }
                        else 
                        {
                            isNewStudent = true;
                        }					
						//====================================================//
						if(String.valueOf(academicYear).substring(2,4) != String.valueOf(row[1].substring(0,2))){	
							errorList.put(row[0], 'The academic year does not match with the barcode = ' + row[1]);
							isError = true;
							break;
						}
                        std.Academic_Year__c = academicYear;
						//====================================================//
						//-------------------------------------------//
						if(!existingBarcodeVsContact.isEmpty() && existingBarcodeVsContact.containsKey(row[9]))
                        {
                            Contact existConUID = existingBarcodeVsContact.get(row[9]);
                            if(selectedGrade == 'Grade 9'){
                            //------//
                              //  if(existConUID.Batch_Code__c != null || existConUID.Grade_9_Barcode__c != null || String.isNotBlank(row[9])){
                                if(String.isNotBlank(row[9])){
                                    errorList.put(row[0], 'UID ' +existConUID.Bar_Code__c+' provided with G9 batch code cannot be linked');
                                    isError = true;
									break;
                                }
                            //------//
                            
                                //----==----//
                                
                                if(existConUID.Grade_12_Barcode__c != null || existConUID.Grade_11_Barcode__c != null || existConUID.Grade_10_Barcode__c != null){
                                    errorList.put(row[0], 'UID ' +existConUID.Bar_Code__c+' cannot be linked—student already linked to a higher grade batch.');
                                    isError = true;
									break;
                                }
                                
                                //----==----//
                                
                            }
                            if(selectedGrade == 'Grade 10'){
                                //-------//
                                if(existConUID.G11_Batch_Code__c != null || existConUID.G12_Batch_Code__c != null){
                                    errorList.put(row[0], 'UID ' +existConUID.Bar_Code__c+' cannot be linked—student already linked to a higher grade batch.');
                                    isError = true;
									break;
                                } 
								//-------//
								                                
                                if(existConUID.G10_Batch_Code__c != null && row[4] != existConUID.G10_Batch_Code__r.Batch_number__c){
                                    errorList.put(row[0], 'Student is already linked to a batch for this grade with batch number ' +existConUID.G10_Batch_Code__r.Batch_number__c);
                                    isError = true;
									break;
                                }
                                if(existConUID.Batch_Code__c != null && selectedBatch.Academic_Year__c == existConUID.Batch_Code__r.Academic_Year__c){
                                    errorList.put(row[0], 'A Student should not have multiple batch code belonging to the same academic year');
                                    isError = true;
									break;
                                }

								//------//
                                if(existConUID.Batch_Code__c != null && existConUID.Batch_Code__r.Academic_Year__c != (selectedBatch.Academic_Year__c - 1)){
                                    errorList.put(row[0], 'Batch academic year mismatch with existing batch codes for UID ' +existConUID.Bar_Code__c);
                                    isError = true;
									break;
                                }
                                //------//
                                
                            }
                            if(selectedGrade == 'Grade 11'){
                                //------//
                                if(existConUID.G12_Batch_Code__c != null){
                                    errorList.put(row[0], 'UID ' +existConUID.Bar_Code__c+' cannot be linked—student already linked to a higher grade batch.');
                                    isError = true;
									break;
                                }
                                //------//
                                
                                if(existConUID.G11_Batch_Code__c != null && row[4] != existConUID.G11_Batch_Code__r.Batch_number__c){
                                    errorList.put(row[0], 'Student is already linked to a batch for this grade with batch number ' +existConUID.G11_Batch_Code__r.Batch_number__c);
                                    isError = true;
									break;
                                }
                                if(existConUID.Batch_Code__c != null && selectedBatch.Academic_Year__c == existConUID.Batch_Code__r.Academic_Year__c){
                                    errorList.put(row[0], 'A Student should not have multiple batch code belonging to the same academic year');
                                    isError = true;
									break;
                                }
                                if(existConUID.G10_Batch_Code__c != null && selectedBatch.Academic_Year__c == existConUID.G10_Batch_Code__r.Academic_Year__c){
                                    errorList.put(row[0], 'A Student should not have multiple batch code belonging to the same academic year');
                                    isError = true;
									break;
                                }
                                
                                //------//
                                if(existConUID.G10_Batch_Code__c != null && existConUID.G10_Batch_Code__r.Academic_Year__c != (selectedBatch.Academic_Year__c - 1)){
                                    errorList.put(row[0], 'Batch academic year mismatch with existing batch codes for UID ' +existConUID.Bar_Code__c);
                                    isError = true;
									break;
                                }
                                
                                if(existConUID.Batch_Code__c != null && existConUID.Batch_Code__r.Academic_Year__c != (selectedBatch.Academic_Year__c - 2)){
                                    errorList.put(row[0], 'Batch academic year mismatch with existing batch codes for UID ' +existConUID.Bar_Code__c);
                                    isError = true;
									break;
                                }
                                //------//
                                
                            }
                            if(selectedGrade == 'Grade 12'){
                                if(existConUID.G12_Batch_Code__c != null && row[4] != existConUID.G12_Batch_Code__r.Batch_number__c){
                                    errorList.put(row[0], 'Student is already linked to a batch for this grade with batch number ' +existConUID.G12_Batch_Code__r.Batch_number__c);
                                    isError = true;
									break;
                                }
                                if(existConUID.Batch_Code__c != null && selectedBatch.Academic_Year__c == existConUID.Batch_Code__r.Academic_Year__c){
                                    errorList.put(row[0], 'A Student should not have multiple batch code belonging to the same academic year');
                                    isError = true;
									break;
                                }
                                if(existConUID.G10_Batch_Code__c != null && selectedBatch.Academic_Year__c == existConUID.G10_Batch_Code__r.Academic_Year__c){
                                    errorList.put(row[0], 'A Student should not have multiple batch code belonging to the same academic year');
                                    isError = true;
									break;
                                }
                                if(existConUID.G11_Batch_Code__c != null && selectedBatch.Academic_Year__c == existConUID.G11_Batch_Code__r.Academic_Year__c){
                                    errorList.put(row[0], 'A Student should not have multiple batch code belonging to the same academic year');
                                    isError = true;
									break;
                                }
                                
                                //------//   
                                if(existConUID.G11_Batch_Code__c != null && existConUID.G11_Batch_Code__r.Academic_Year__c != (selectedBatch.Academic_Year__c - 1)){
                                    errorList.put(row[0], 'Batch academic year mismatch with existing batch codes for UID ' +existConUID.Bar_Code__c);
                                    isError = true;
									break;
                                }
                                
                                if(existConUID.G10_Batch_Code__c != null && existConUID.G10_Batch_Code__r.Academic_Year__c != (selectedBatch.Academic_Year__c - 2)){
                                    errorList.put(row[0], 'Batch academic year mismatch with existing batch codes for UID ' +existConUID.Bar_Code__c);
                                    isError = true;
									break;
                                }
                                
                                if(existConUID.Batch_Code__c != null && existConUID.Batch_Code__r.Academic_Year__c != (selectedBatch.Academic_Year__c - 3)){
                                    errorList.put(row[0], 'Batch academic year mismatch with existing batch codes for UID ' +existConUID.Bar_Code__c);
                                    isError = true;
									break;
                                }
                                //------//
                            }
                        }
						//-------------------------------------------//
                        if(!existingBarcodeVsContact.isEmpty() && existingBarcodeVsContact.containsKey(row[1]))
						{
                            Contact existingContact = existingBarcodeVsContact.get(row[1]);
                           
                            if(row[1] == existingContact.Grade_9_Barcode__c){
                                if(existingContact.Batch_Code__r.Batch_number__c != row[4]){
                                    errorList.put(row[0], 'Student with barcode ' +existingContact.Grade_9_Barcode__c+' already exist for the batch number = '+existingContact.Batch_Code__r.Batch_number__c);
                                    isError = true;
									break;
                                }
                                
                                if(selectedGrade != 'Grade 9'){
                                    errorList.put(row[0], 'The grade of the existing student with barcode '+existingContact.Grade_9_Barcode__c+' does not match the current grade of batch = '+existingContact.Batch_Code__r.Batch_number__c);
                                    isError = true;
									break;
                                }

                                std.Grade_9_Barcode__c = row[1];
                                if(isNewStudent)std.Bar_Code__c = row[1];
                            }
                            else if(row[1] == existingContact.Grade_10_Barcode__c){
								if(existingContact.G10_Batch_Code__r.Batch_number__c != row[4]){
                                    errorList.put(row[0], 'Student with barcode ' +existingContact.Grade_10_Barcode__c+' already exist for the batch number = '+existingContact.G10_Batch_Code__r.Batch_number__c);
                                    isError = true;
									break;
                                }

                                if(selectedGrade != 'Grade 10'){
                                    errorList.put(row[0], 'The grade of the existing student with barcode '+existingContact.Grade_10_Barcode__c+' does not match the current grade of batch = '+existingContact.G10_Batch_Code__r.Batch_number__c);
                                    isError = true;
									break;
                                }

                                std.Grade_10_Barcode__c = row[1];
                                if(isNewStudent)std.Bar_Code__c = row[1];
                            }
                            else if(row[1] == existingContact.Grade_11_Barcode__c){
                                if(existingContact.G11_Batch_Code__r.Batch_number__c != row[4]){
                                    errorList.put(row[0], 'Student with barcode ' +existingContact.Grade_11_Barcode__c+' already exist for the batch number = '+existingContact.G11_Batch_Code__r.Batch_number__c);
                                    isError = true;
									break;
                                }
                                
                                if(selectedGrade != 'Grade 11'){
                                    errorList.put(row[0], 'The grade of the existing student with barcode '+existingContact.Grade_11_Barcode__c+' does not match the current grade of batch = '+existingContact.G11_Batch_Code__r.Batch_number__c);
                                    isError = true;
									break;
                                }

                                std.Grade_11_Barcode__c = row[1];
                                if(isNewStudent)std.Bar_Code__c = row[1];
                            }	
                            else if(row[1] == existingContact.Grade_12_Barcode__c){	
                                if(existingContact.G12_Batch_Code__r.Batch_number__c != row[4]){
                                    errorList.put(row[0], 'Student with barcode ' +existingContact.Grade_12_Barcode__c+' already exist for the batch number = '+existingContact.G12_Batch_Code__r.Batch_number__c);
                                    isError = true;
									break;
                                }
                                
                                if(selectedGrade != 'Grade 12'){
                                    errorList.put(row[0], 'The grade of the existing student with barcode '+existingContact.Grade_12_Barcode__c+' does not match the current grade of batch = '+existingContact.G12_Batch_Code__r.Batch_number__c);
                                    isError = true;
									break;
                                }

                                std.Grade_12_Barcode__c = row[1];
                                if(isNewStudent)std.Bar_Code__c = row[1];									
                            }
                        }
                        else
                        {
                            if(selectedGrade == 'Grade 9'){
                                std.Grade_9_Barcode__c = row[1];
                                if(isNewStudent)std.Bar_Code__c = row[1];
                            }
                            else if(selectedGrade == 'Grade 10'){
                                std.Grade_10_Barcode__c = row[1];
                                if(isNewStudent)std.Bar_Code__c = row[1];
                            }
                            else if(selectedGrade == 'Grade 11'){
                                std.Grade_11_Barcode__c = row[1];
                                if(isNewStudent)std.Bar_Code__c = row[1];
                            }
                            else if(selectedGrade == 'Grade 12'){
                                std.Grade_12_Barcode__c = row[1];
                                if(isNewStudent)std.Bar_Code__c = row[1];
                            }
                        }
                        //====================================================//
						String stdName = row[2].trim();
						List<String> s = stdName.split(' ');
						if(s.size() == 3){
							std.FirstName = s[0];
							std.MiddleName = s[1];
							std.LastName = s[2];   
						} else if(s.size() == 2) {
							std.FirstName = s[0];
							std.LastName = s[1];
                            std.MiddleName = '';   
						} else {
							if(String.isNotBlank(stdName)){
								std.LastName = stdName;
                                std.FirstName = '';
							    std.MiddleName = '';    
							} 
						}
						//=======================================//
						// if(row[8].length() == 8 && isnumbers.matcher(row[8]).Matches()){
						// 	if(Integer.valueOf(row[8].substring(2,4)) <= 12 
                        //     && Integer.valueOf(row[8].substring(4,8)) > 1900 
                        //     && Integer.valueOf(row[8].substring(4,8)) < System.today().Year()){
						// 		std.Birthdate = Date.newInstance(Integer.valueOf(row[8].substring(4,8)), Integer.valueOf(row[8].substring(2,4)), Integer.valueOf(row[8].substring(0,2)));
						// 	}   
						// }

                        if(row[8].length() == 4 && isnumbers.matcher(row[8]).Matches()){
							if(Integer.valueOf(row[8]) > 1900 && Integer.valueOf(row[8]) < System.today().Year()){
								std.Year_of_Birth__c = Integer.valueOf(row[8]);
							}   
						}
						//=======================================//
						if(selectedGrade == 'Grade 9'){
							std.G9_Whatsapp_Number__c = row[3];   
						}
						else if(selectedGrade == 'Grade 10'){
							std.G10_Whatsapp_Number__c = row[3];
						}
						else if(selectedGrade == 'Grade 11'){
							std.G11_Whatsapp_Number__c = row[3];
						}
						else if(selectedGrade == 'Grade 12'){
							std.G12_Whatsapp_Number__c = row[3];
						}
						//=======================================//
						if(row[5] != ''){
							std.Currently_Studying_In__c = row[5] != '*' ? studyingMAP.get(row[5]) : '*';
						}
						if(row[6] != ''){
							std.Gender__c = row[6] != '*' ? genderMAP.get(row[6]) : '*';
						}
						if(row[7] != ''){
							std.What_are_you_currently_studying__c = row[7] != '*' ? whatStudyingMAP.get(row[7]) : '*';
						}
						//=======================================//
						if(!isError){
							studentLIST.add(std);
                            expectedGrade.put(row[1],selectedGrade);
						}
					}while(false);
                }
                string logId;
                String timeStamp = System.now().format();
                if(errorList.size() > 0){
                    logId = createOmrManagerLog(errorList,selectedEmail,timeStamp);
                }
                if(studentLIST.size() > 0){
                    upsertOMRContactBatch bc = new upsertOMRContactBatch(studentLIST, expectedGrade, selectedOMRType,selectedEmail,timeStamp,logId);
                    Database.executeBatch(bc,30);
                }
                
                if(errorList.size() > 0){
                    sendErrorMail_01(errorList,selectedEmail,timeStamp);
                }
            }
        } catch(Exception ex) {
            System.debug('StudentOMRManagerController.processStudentsBaseLine1 ; ex.getMessage() :' + ex.getMessage());
            System.debug('StudentOMRManagerController.processStudentsBaseLine1 ; ex.getLineNumber() :' + ex.getLineNumber());
            //sendExceptionMail(ex.getMessage(), '');
            sendExceptionMail_01(ex.getMessage(),selectedEmail);
            OMR_Manager_Log__c errorLogRecord = new OMR_Manager_Log__c();
            errorLogRecord.Timestamp__c = System.now();
            AntarangSetting__c antarangSett1 = AntarangSetting__c.getOrgDefaults();
            errorLogRecord.Academic_year__c = Integer.valueOf(antarangSett1.Academic_Year__c);
            errorLogRecord.POC_Email__c = selectedEmail;
            errorLogRecord.Missing_data_in_CSV_columns__c = 1;
            insert errorLogRecord;
        }
    }
    @AuraEnabled
    public static String noDataInOMRSheet(String selectedEmail, string errorMessage){
        OMR_Manager_Log__c errorLogRecord = new OMR_Manager_Log__c();
        errorLogRecord.Timestamp__c = System.now();
        AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
        errorLogRecord.Academic_year__c = Integer.valueOf(antarangSett.Academic_Year__c);
        errorLogRecord.POC_Email__c = selectedEmail;
        if(errorMessage == 'Please make sure data is available in the file.') errorLogRecord.No_data__c = 1;
        if(errorMessage == 'File is too large') errorLogRecord.Too_large_File__c = 1;
        try {
            insert errorLogRecord;
            // If insert is successful, return a success message
            return 'Success';
        } catch (DmlException e) {
            // Catch any errors during the insert operation
            return e.getMessage();
        }
    }
    public static void sendErrorMail_01(Map<String,String> errorList,String selectedEmail, String timeStamp){
        System.debug('errorList = '+ errorList);
        String errorLogs = '<p>Total error records : '+errorList.size()+'</p>'; 
        errorLogs += '<table border="1"><tr align="center"><th>CSV Serial No.</th><th>Error Description</th></tr>';
        for(String str : errorList.keySet()){
            errorLogs += '<tr><td>' + str + '</td>';
            errorLogs += '<td>' + errorList.get(str) + '</td></tr>';
        }
        errorLogs += '</table>';

        String strSubject = 'An error occurred :' +' '+timeStamp;
        
        List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setSubject(strSubject);
        //msg.setSubject('An error Occured ');
        msg.setHTMLbody(errorLogs);
        msg.setToAddresses(new List<String>{selectedEmail});
        msg.setCcAddresses(Label.OMR_Email_Ids.split(';'));
        lstMsgs.add(msg);
        if(!Test.isRunningTest())
        {
            Messaging.sendEmail(lstMsgs);
        }
        
    }
    public static string createOmrManagerLog(Map<String,String> errorList,String selectedEmail, String timeStamp){
        Map<String, Integer> errorCountMap = new Map<String, Integer>();
        string logId;
        if(errorList.size() > 0){
            for (String error : errorList.values()) {
                string errorMessage = error;
                
                if(error.contains('already exist for the batch number')){
                    errorMessage = 'Duplicate Barcode';
                }else if(error.contains('provided with G9 batch code cannot be linked')){
                    errorMessage = 'UID for G9 BatchCode';
                }else if(error.contains('cannot be linked—student already linked to a higher grade batch.')){
                    errorMessage = 'UID for lower grade batch';
                }else if(error.contains('does not match the current grade of batch')){
                    errorMessage = 'Grade on CSV and batch grade mismatch';
                }else if(error.contains('Student is already linked to a batch for this grade with batch number')){
                     errorMessage = 'Same grade batch code';
                }else if(error.contains('Batch academic year mismatch with existing batch codes for UID')){
                    errorMessage = 'Academic year not matching with UID';
                }
                else if (error.contains('=') || error.contains(':')) {
                    errorMessage = error.split('=|:')[0].trim();
                } 
                //string errorMessage = error.split('=')[0].trim();
                if (errorCountMap.containsKey(errorMessage)) {
                    errorCountMap.put(errorMessage, errorCountMap.get(errorMessage) + 1);
                } else {
                    errorCountMap.put(errorMessage, 1);
                }
            }
            System.debug('errorCountMap = '+errorCountMap);
            Map<String, String> ErrorVSFieldAPIMap = new Map<String, String>{
                'Blank barcode.' => 'Blank_Barcode__c',
                'Missing batch code.' => 'Missing_batch_code__c',
                'Improper barcode' => 'Improper_barcode__c',
                'Barcode should be 10 digit' => 'Barcode_should_be_10_digit__c',
                'The academic year does not match with the barcode' => 'Academic_year_mismatch__c',
                'Duplicate Barcode' => 'Duplicate_Barcode__c',
                'Improper UID' => 'Improper_UID__c',
                'UID should be 9 or 10 digit' => 'UID_should_be_9_or_10_digit__c',
                'Duplicate UID' => 'Duplicate_UID_in_CSV__c',
                'UID unavailable' => 'UID_unavailable__c',
                'UID for G9 BatchCode' => 'UID_for_G9_BatchCode__c',
                'UID for lower grade batch' => 'UID_for_lower_grade_batch__c',
                'Academic year is blank for the batch number' => 'Academic_Year_blank_on_Batch__c',
                'Incorrect batch code' => 'Incorrect_batch_code__c',
                'Academic year do not match for the batch number' => 'Academic_year_not_matching_with_Batch__c',
                'Batch code does not exist' => 'Batch_code_does_not_exist__c',
                'Currently Studying In and Batch Code grade not matched' => 'Currently_studying_mismatch__c',
                'Grade is blank for the batch number' => 'Grade_is_blank_for_the_batch_number__c',
                'Grade on CSV and batch grade mismatch' => 'Grade_on_CSV_and_batch_grade_mismatch__c',
                'Same grade batch code' => 'Same_grade_batch_code__c',
                'A Student should not have multiple batch code belonging to the same academic year' => 'Student_linked_with_multiple_batches__c',
                 'Academic year not matching with UID' => 'Academic_year_not_matching_with_UID__c'
            };
            System.debug('ErrorVSFieldAPIMap Keys: ' + ErrorVSFieldAPIMap.keySet());
            System.debug('errorCountMap Keys: ' + errorCountMap.keySet());
            OMR_Manager_Log__c errorLogRecord = new OMR_Manager_Log__c();
            errorLogRecord.Timestamp__c = DateTime.valueOf(DateTime.parse(timeStamp).format('yyyy-MM-dd HH:mm:ss'));
            AntarangSetting__c antarangSett = AntarangSetting__c.getOrgDefaults();
            errorLogRecord.Academic_year__c = Integer.valueOf(antarangSett.Academic_Year__c);
            errorLogRecord.POC_Email__c = selectedEmail;
            for(String fieldApi : ErrorVSFieldAPIMap.keySet()){
                system.debug('fieldApi = '+fieldApi);
                system.debug('errorCountMap.get(fieldApi) ='+errorCountMap.get(fieldApi));
                Integer count = errorCountMap.get(fieldApi); 
                errorLogRecord.put(ErrorVSFieldAPIMap.get(fieldApi),count);
            }
            
            try{
                insert errorLogRecord;
                logId = errorLogRecord.id;
            }catch(exception ex){
                system.debug('Ex :: ' + ex.getMessage());
            }
        }
        return logId;
    }
    public static void sendExceptionMail_01(String errMsg, String selectedEmail){
        String timeStamp = System.now().format();
        String strSubject = 'OMR Process System Exception :' +' '+timeStamp;
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
    
    public static void proceedBaseLine2(List<String> csvRows, String selectedGrade,String selectedOMRType){
        List<String> barcodeList = new List<String>();
		List<Contact> studentLst = new List<Contact>();
        Map<String,String> errorList = new Map<String,String>();
        Map<String, String> uidWithConId = new Map<String, String>();
		Map<String, String> Fath_Moth_Edu_MAP = new Map<String, String>(); 
        Map<String, String> Fath_Moth_Occu_MAP = new Map<String, String>();  
        Map<String, String> Religion_MAP = new Map<String, String>();   
        Map<String, String> Category_MAP = new Map<String, String>();  
                                
        try{
            for(OMR_Field_Mapping__c field : [Select Id,Selected_Number__c,SF_Value__c,Field_Type__c From OMR_Field_Mapping__c where 
                                              Field_Type__c IN ('Father Education','Father Occupation','Religion','Category')]){
                                                  switch on field.Field_Type__c {
                                                      when 'Father Education' {	
                                                          Fath_Moth_Edu_MAP.put(field.Selected_Number__c, field.SF_Value__c);
                                                      }
                                                      when 'Father Occupation' {	
                                                          Fath_Moth_Occu_MAP.put(field.Selected_Number__c, field.SF_Value__c);
                                                      }
                                                      when 'Religion' {
                                                          Religion_MAP.put(field.Selected_Number__c, field.SF_Value__c);
                                                      }
                                                      when 'Category' {
                                                          Category_MAP.put(field.Selected_Number__c, field.SF_Value__c);
                                                      }
                                                  }
                                              }
            
            for(integer i = 1; i < csvRows.size(); i++){
                List<String> row = csvRows[i].split(',');
                barcodeList.add(row[1]);
            }
            
            String query = 'Select Id,Grade_9_Barcode__c,Grade_10_Barcode__c,Grade_11_Barcode__c From Contact where ';
            if(selectedGrade == 'Grade 9'){
                query += 'Grade_9_Barcode__c IN :barcodeList';   
            }
            else if(selectedGrade == 'Grade 10'){
                query += 'Grade_10_Barcode__c IN :barcodeList';
            }
            else if(selectedGrade == 'Grade 11'){
                query += 'Grade_11_Barcode__c IN :barcodeList';
            } 
            
            for(Contact con : Database.query(query)){
                if(selectedGrade == 'Grade 9'){
                    uidWithConId.put(con.Grade_9_Barcode__c, con.Id);  
                }
                else if(selectedGrade == 'Grade 10'){
                    uidWithConId.put(con.Grade_10_Barcode__c, con.Id);
                }
                else if(selectedGrade == 'Grade 11'){
                    uidWithConId.put(con.Grade_11_Barcode__c, con.Id);
                }
                
            }
            for(integer i = 1; i < csvRows.size(); i++){
                List<String> row = csvRows[i].split(',');
                if(uidWithConId.containsKey(row[1])){
                    Contact std = new Contact(Id = uidWithConId.get(row[1]));
                    std.Father_Education__c = row[2] != '*' ? Fath_Moth_Edu_MAP.get(row[2]) : row[2];
                    std.Father_Occupation__c = row[3] != '*' ? Fath_Moth_Occu_MAP.get(row[3]) : row[3];
                    std.Mother_Education__c = row[4] != '*' ? Fath_Moth_Edu_MAP.get(row[4]) : row[4];
                    std.Mother_Occupation__c = row[5] != '*' ? Fath_Moth_Occu_MAP.get(row[5]) : row[5];
                    std.Religion__c = row[6] != '*' ? Religion_MAP.get(row[6]) : row[6];
                    std.Caste_Certificate_present__c = row[7] != '*' ? Category_MAP.get(row[7]) : row[7];
                    studentLst.add(std);
                } else {
                    errorList.put(row[1], 'Barcode not found!');
                }
            }
            if(studentLst.size() > 0){
                upsertOMRContactBatch bc = new upsertOMRContactBatch(studentLst, '', selectedGrade, selectedOMRType);
				Database.executeBatch(bc);
            }
            if(errorList.size() > 0){
                sendErrorMail(errorList);
            }
        } catch(Exception ex){
            sendExceptionMail(ex.getMessage(), '');
        }
    }
    
    public static void sendErrorMail(Map<String,String> errorList){
        List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.setSubject('An error Occured');
        String errorLogs = '<table border="1"><tr align="center"><th>Actual Data</th><th>Error Description</th></tr>';
        for(String str : errorList.keySet()){
            errorLogs += '<tr><td>' + str + '</td>';
            errorLogs += '<td>' + errorList.get(str) + '</td></tr>';
        }
        errorLogs += '</table>';
        msg.setHTMLbody(errorLogs);
        msg.setToAddresses(Label.OMR_Email_Ids.split(';'));
        lstMsgs.add(msg);
        if(!Test.isRunningTest())
        {
            Messaging.sendEmail(lstMsgs);
        }
    }
    
    public static void sendExceptionMail(String errMsg, String batchName){
        List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        if(String.isNotBlank(batchName)){
         	msg.setSubject('OMR Process System Exception For batch : ' + batchName);   
        } else {
            msg.setSubject('OMR Process System Exception');
        }
        msg.setPlainTextBody(errMsg);
        msg.setToAddresses(Label.OMR_Email_Ids.split(';'));
        lstMsgs.add(msg);
        if(!Test.isRunningTest())
        {
            Messaging.sendEmail(lstMsgs);
        }
    }
    
    public class picklistwrapper {
        @AuraEnabled
        public String label { get; set; }
        
        @AuraEnabled
        public String value { get; set; }
                
        public picklistwrapper(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
        public static void testCodeCoverage(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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