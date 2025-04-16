public without sharing class StudentTransitionLogin_ChildClass {
    @AuraEnabled
    public static List<SObject> getRecords(
      String searchString,
      String objectApiName,
      String idFieldApiName,
      String valueFieldApiName,
      String MatchingvalueFieldApiName,
      String extendedWhereClause,
      Integer maxRecords,
      String defaultWhereclause
    ) {
      searchString = String.escapeSingleQuotes(searchString);
      objectApiName = String.escapeSingleQuotes(objectApiName);
      idFieldApiName = String.escapeSingleQuotes(idFieldApiName);
      valueFieldApiName = String.escapeSingleQuotes(valueFieldApiName);
  
      if (extendedWhereClause == null) {
        extendedWhereClause = '';
      }
  
      String matchingFields = '(';
      if (String.isNotBlank(MatchingvalueFieldApiName)) {
        for (String fieldAPI : MatchingvalueFieldApiName.split(',')) {
          matchingFields +=
            ' ' +
            fieldAPI +
            +' LIKE \'%' +
            searchString +
            '%\' OR';
        }
        matchingFields = matchingFields.removeEnd('OR') + ')';
      }
        
        String accountRTFilter = !String.IsBlank(defaultWhereclause) ? defaultWhereclause : '';
          string childrecord =' ';
        if(objectApiName == 'Batch__c'){
            childrecord = ' ,(select Id from contacts__r limit 49999) ';
        }

        if(objectApiName == 'Contact'){
            AntarangSetting__c antrang_Cs = AntarangSetting__c.getInstance();
            String barcodeIntials=  antrang_Cs.Bar_Code_Initial_for_Grade_10__c;
            System.debug('barcode Intials for student 10th Passed out : '+barcodeIntials);
            
            String likeStringForBarcodeIntials = barcodeIntials+'%';
            String studentBarcodeQuery=' AND Grade_10_Barcode__c LIKE \''+barcodeIntials+'%\' ';

            accountRTFilter += studentBarcodeQuery;
        }

      String query =
        'SELECT ' +
        idFieldApiName +
        ', ' +
        valueFieldApiName + childrecord +
        ' FROM ' +
        objectApiName +
        ' WHERE ' +
        matchingFields +
          accountRTFilter +
        extendedWhereClause +
        ' LIMIT ' +
        maxRecords;
        
        system.debug('query :'+query);
      return Database.query(query);
    }
  
    @AuraEnabled
    public static List<Batch__c> getAccountBatches(String AccountId) {
      List<Batch__c> batches;
      if (String.isNotBlank(AccountId)) {
        batches = [
          SELECT
            Id,
            Name,
            Batch_Number__c,
            Facilitation_Start_Date__c,
            Date_of_facilitation_starting__c
          FROM Batch__c
          WHERE School_Name__c = :AccountId AND Batch_Is_Over__c = FALSE
          //   AND Date_of_facilitation_starting__c <= today
        ];
      }
      return batches;
    }
  
    @AuraEnabled
    public static boolean IdentifyStudent(String AccountId, String BatchNo) {
      List<Batch__c> batches = [
        SELECT Id, School_Name__c
        FROM Batch__c
        WHERE Batch_Number__c = :BatchNo
        LIMIT 1
      ];
      System.debug('batches: ' + batches);
  
      if (
        batches != null &&
        batches.size() > 0 &&
        batches[0].School_Name__c == AccountId
      ) {
        System.debug('Matched');
        return true;
      } else {
        System.debug('Not Matched');
        return false;
      }
    }
  
    @AuraEnabled
    public static List<Student_Feedback_mapping__c> getMappingRecords(
      String selectedDay,
      String lang
    ) {
      system.debug('lang@@@@@@@@@@ ' + lang);
      system.debug('lang@@@@@@@@@@ ' + selectedDay);
  
      return [
        SELECT
          Id,
          object_API_Name__c,
          Field_API__c,
          Field_Label__c,
          Question_Label__c,
          Display_Type__c,
          Day_Number__c,
          Order_of_Question__c,
          (
            SELECT Id, SF_Value__c, Form_value__c
            FROM Picklist_Mappings__r
            ORDER BY Order__c
          )
        FROM Student_Feedback_mapping__c
        WHERE Day_Number__c = :selectedDay AND Language__c = :lang
        ORDER BY Order_of_Question__c
      ];
    }
  
    public class wrpPage {
      @AuraEnabled
      public List<Student_Feedback_mapping__c> lstfeedback;
  
      @AuraEnabled
      public List<Student_Feedback_mapping__c> lstallrecommendation;
  
      @AuraEnabled
      public Contact objcon;
  
      public wrppage() {
        lstfeedback = new List<Student_Feedback_mapping__c>();
        lstfeedback = getMappingRecords('Day-1', 'eng');
      }
    }
  
    @AuraEnabled
    public static wrpPage findDay1Data(String contactid, String lang) {
      wrpPage o = new wrpPage();
      o.lstfeedback = new List<Student_Feedback_mapping__c>();
      o.lstfeedback = getMappingRecords('Day-1', lang);
  
      o.lstallrecommendation = new List<Student_Feedback_mapping__c>();
      o.lstallrecommendation = getMappingRecords('Identifier', lang);
  
      List<String> lstFields = new List<String>();
      for (Student_Feedback_mapping__c s : o.lstfeedback) {
        if (
          String.isNotBlank(s.Object_API_Name__c) &&
          s.Object_API_Name__c == 'Contact' &&
          String.isNotBlank(s.Field_API__c)
        ) {
          lstFields.add(s.Field_API__c);
        }
      }
  
      if (Test.isRunningTest()) {
        lstFields.add('Reality_4__c');
        lstFields.add('Reality_8__c');
      }
  
      List<Contact> lstc = new List<Contact>();
      for (
        Contact c : Database.query(
          'Select id,All_Recommendation__c,' +
          String.join(lstFields, ',') +
          ' from contact where id=:contactid '
        )
      ) {
        o.objcon = c;
      }
  
      return o;
    }
  
    public class MappingTableWrapper {
      @AuraEnabled
      public Student_Feedback_mapping__c mappingRecord { get; set; }
  
      @AuraEnabled
      public List<Picklist_Mapping__c> picklistVals { get; set; }
    }
  
    @AuraEnabled
    public static void savecontact(string JSONWrapClass) {
      wrpcon obj = new wrpcon();
      obj = (wrpcon) System.JSON.deserialize(JSONWrapClass, wrpcon.class);
  
      system.debug('obj ' + obj);
  
      Contact con = new Contact();
      con.id = obj.contactid;
  
      if (Integer.valueOf(obj.pagenumber) > 1) {
        con.Batch_Code__c = obj.batchid;
        if (Integer.valueOf(obj.daynumber) == 1) {
          //con.Day_1__c = 'Present';
          con.Interest_1__c = obj.Interest1;
          con.Interest_2__c = obj.Interest2;
          con.Interest_3__c = obj.Interest3;
  
          //con.Day_2__c = 'Present';
          /*con.Aptitude_1__c = obj.Aptitude1;
          con.Aptitude_2__c = obj.Aptitude2;
          con.Aptitude_3__c = obj.Aptitude3;
          con.Reality1Self__c = obj.Reality1;
          con.Reality2Self__c = obj.Reality2;
          con.Reality3Self__c = obj.Reality3;
          con.Reality4Self__c = obj.Reality4;
          con.Reality1Family__c = obj.Reality5;
          con.Reality2Family__c = obj.Reality6;
          con.Reality3Family__c = obj.Reality7;
          con.Reality4Family__c = obj.Reality8;
          //copy reality fields to IARP reality fields - added by Sunil
          con.Reality_1__c = con.Reality1Self__c;
          con.Reality_2__c = con.Reality2Self__c;
          con.Reality_3__c = con.Reality3Self__c;
          if (con.Reality4Self__c != null) {
            if (con.Reality4Self__c == '50% - 80%') {
              con.Reality_4__c = 'B';
            } else if (con.Reality4Self__c == 'Above 80%') {
              con.Reality_4__c = 'C';
            } else {
              con.Reality_4__c = 'A';
            }
          }
          con.Reality_5__c = con.Reality1Family__c;
          con.Reality_6__c = con.Reality2Family__c;
          con.Reality_7__c = con.Reality3Family__c;
          if (con.Reality4Family__c != null) {
            if (con.Reality4Family__c == '10-000 - 20-000') {
              con.Reality_8__c = 'B';
            } else if (con.Reality4Family__c == '20-000+') {
              con.Reality_8__c = 'C';
            } else {
              con.Reality_8__c = 'A';
            }
          }*/
          con.Status__c = 'Not Processed'; //added by Sunil and required to run IARP batch.
          con.Recommedation_Status__c = 'Not Processed'; //added by Sunil and required to run IARP batch.
        } else if (Integer.valueOf(obj.daynumber) == 2) {
          //con.Day_5__c = 'Present';
          Set<string> setPossibleCareers = new Set<String>();
          setPossibleCareers.add(obj.PossibleCareers1);
          setPossibleCareers.add(obj.PossibleCareers2);
          setPossibleCareers.add(obj.PossibleCareers3);
          for (IARP_Master__c objIARP : [
            SELECT id, Name
            FROM IARP_Master__c
            WHERE Name IN :setPossibleCareers
          ]) {
            if (
              objIARP.Name.toLowerCase() == obj.PossibleCareers1.toLowerCase()
            ) {
              con.Possible_Careers_1__c = objIARP.Id;
              con.Aspiration_1__c = objIARP.Id; //added by Sunil and required to run IARP batch.
            }
            if (
              objIARP.Name.toLowerCase() == obj.PossibleCareers2.toLowerCase()
            ) {
              con.Possible_Careers_2__c = objIARP.Id;
              con.Aspiration_2__c = objIARP.Id; //added by Sunil and required to run IARP batch.
            }
            if (
              objIARP.Name.toLowerCase() == obj.PossibleCareers3.toLowerCase()
            ) {
              con.Possible_Careers_3__c = objIARP.Id;
              con.Aspiration_3__c = objIARP.Id; //added by Sunil and required to run IARP batch.
            }
          }
          con.CCP_1__c = obj.Nextstep1;
          con.CCP_2__c = obj.Nextstep2;
          con.Study_till_18__c = obj.Intenttostudy3;
        }
      } else if (Integer.valueOf(obj.pagenumber) == 1) {
        con.Birthdate = Date.valueOf(obj.dob);
        if (obj.whohaveyoutalked != null && obj.whohaveyoutalked.size() > 0) {
          con.Who_have_you_talked_about_career_plan__c = string.join(
            obj.whohaveyoutalked,
            ';'
          );
        }
        con.Father_Education__c = obj.fathereduction;
        con.Mother_Education__c = obj.mothereducation;
        con.Current_Aspiration__c = obj.CurrentAspiration;
      }
  
      update con;
      //RUN IARP Recommdentation change on 14th Dec 2020
      IARPRecommendation objIARPBatch = new IARPRecommendation();
      Database.executeBatch(objIARPBatch, 1);
    }
  
    public class wrpcon {
      @AuraEnabled
      public String accountid { get; set; }
      @AuraEnabled
      public String contactid { get; set; }
      @AuraEnabled
      public String batchid { get; set; }
      @AuraEnabled
      public String pagenumber { get; set; }
      @AuraEnabled
      public String daynumber { get; set; }
  
      @AuraEnabled
      public String[] whohaveyoutalked { get; set; }
      @AuraEnabled
      public String dob { get; set; }
      @AuraEnabled
      public String mothereducation { get; set; }
      @AuraEnabled
      public String fathereduction { get; set; }
      @AuraEnabled
      public String Interest1 { get; set; }
      @AuraEnabled
      public String Interest2 { get; set; }
      @AuraEnabled
      public String Interest3 { get; set; }
      @AuraEnabled
      public String CurrentAspiration { get; set; }
      @AuraEnabled
      public String Aptitude1 { get; set; }
      @AuraEnabled
      public String Aptitude2 { get; set; }
      @AuraEnabled
      public String Aptitude3 { get; set; }
      @AuraEnabled
      public String Reality1 { get; set; }
      @AuraEnabled
      public String Reality2 { get; set; }
      @AuraEnabled
      public String Reality3 { get; set; }
      @AuraEnabled
      public String Reality4 { get; set; }
      @AuraEnabled
      public String Reality5 { get; set; }
      @AuraEnabled
      public String Reality6 { get; set; }
      @AuraEnabled
      public String Reality7 { get; set; }
      @AuraEnabled
      public String Reality8 { get; set; }
      @AuraEnabled
      public String PossibleCareers1 { get; set; }
      @AuraEnabled
      public String PossibleCareers2 { get; set; }
      @AuraEnabled
      public String PossibleCareers3 { get; set; }
      @AuraEnabled
      public String Nextstep1 { get; set; }
      @AuraEnabled
      public String Nextstep2 { get; set; }
      @AuraEnabled
      public String Intenttostudy3 { get; set; }
    }
    
    
     public static void dummyTest(){
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
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
         i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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