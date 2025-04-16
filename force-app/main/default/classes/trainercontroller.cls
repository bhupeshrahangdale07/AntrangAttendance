public without sharing class trainercontroller {
  @AuraEnabled
  public static Contact checkEmailExist(String stremail) {
    Id recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName()
      .get('CA_Trainer')
      .getRecordTypeId();

    Contact c = new Contact();
    for (Contact objcon : [
      SELECT id, email
      FROM contact
      WHERE email = :stremail AND RecordTypeId = :recordTypeId
      ORDER BY CreatedDate DESC
      LIMIT 1
    ]) {
      c = objcon;
    }

    return c;
  }

  @AuraEnabled
  public static List<SObject> getRecords(
    String searchString,
    String objectApiName,
    String idFieldApiName,
    String valueFieldApiName,
    String MatchingvalueFieldApiName,
    String extendedWhereClause,
    Integer maxRecords
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

    String query =
      'SELECT ' +
      idFieldApiName +
      ', ' +
      valueFieldApiName +
      ' FROM ' +
      objectApiName +
      ' WHERE ' +
      matchingFields +
      extendedWhereClause +
      ' LIMIT ' +
      maxRecords;
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
  public static Boolean findcontactrecommendation(String contactid) {
    if (String.isNotBlank(contactid)) {
      for (Contact obj : [
        SELECT id, Recommendation_Report_Status__c
        FROM Contact
        WHERE id = :contactid
      ]) {
        if (obj.Recommendation_Report_Status__c == 'Report processed') {
          return true;
        }
      }
    }
    return false;
  }
  
  @AuraEnabled 
  public static Boolean additionalcacalltrue(String contactid) {
    if (String.isNotBlank(contactid)) {
      for (Contact obj : [
        SELECT id, Additional_CA_call_1_attended__c
        FROM Contact
        WHERE id = :contactid
      ]) {
        if (obj.Additional_CA_call_1_attended__c) {
          return true;
        }
      }
    }
    return false;
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
    public Contact objcon;

    public wrppage() {
      lstfeedback = new List<Student_Feedback_mapping__c>();
      lstfeedback = getMappingRecords('Day-1', 'eng');
    }
  }

  @AuraEnabled
  public static wrpPage findDay1Data(String contactid) {
    wrpPage o = new wrpPage();

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
      /*if (c.Reality_4__c == 'B') {
          c.Reality_4__c = '50% - 80%';
        } else if (c.Reality_4__c == 'C') {
          c.Reality_4__c = 'Above 80%';
        } else if (c.Reality_4__c == 'A') {
          c.Reality_4__c = 'Below 50%';
        } else {
          c.Reality_4__c = 'I do not know';
        }
  
        if (c.Reality_8__c == 'B') {
          c.Reality_8__c = 'INR 10,000 - 20,000';
        } else if (c.Reality_8__c == 'C') {
          c.Reality_8__c = 'INR above 20,000';
        } else if (c.Reality_8__c == 'A') {
          c.Reality_8__c = 'Below INR 10,000';
        } else {
          c.Reality_8__c = 'I do not know';
        }*/
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
      //con.Batch_Code__c = obj.batchid;
      if (Integer.valueOf(obj.daynumber) == 1) {
        con.Gender__c = obj.day1gender;

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
        con.Additional_CA_Call_1__c = 'Present';
        con.Additional_CA_call_1_date__c = system.now();
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
        con.Additional_CA_Call_2__c = 'Present';
        con.Additional_CA_call_2_date__c = system.now();
      } else if (Integer.valueOf(obj.daynumber) == 3) {
        con.Gender__c = obj.Gender;
        con.Guardian_Attendance__c = obj.GuardianAttendance;
        con.Counselling_Session_Attended__c = true;

        if (obj.isRecommendationReport) {
          con.I_agree_with_the_recommendation__c = obj.Iagreewiththerecommendation1;
          con.I_agree_with_the_recommendation_2__c = obj.Iagreewiththerecommendation2;
          con.Able_to_use_IAR_to_dis_agree_with_reco__c = obj.AbletouseIARtodisagreewithreco;
          con.I_am_clear_about_what_I_need_to_do_after__c = obj.ClearnextstepforReco1;
          con.Clear_next_step_for_Reco_2__c = obj.ClearnextstepforReco2;
        }
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

    System.debug('contact#### ' + con);

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
    public String day1gender { get; set; }
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

    @AuraEnabled
    public String Gender { get; set; }
    @AuraEnabled
    public String GuardianAttendance { get; set; }
    @AuraEnabled
    public String Iagreewiththerecommendation1 { get; set; }
    @AuraEnabled
    public String Iagreewiththerecommendation2 { get; set; }
    @AuraEnabled
    public String AbletouseIARtodisagreewithreco { get; set; }
    @AuraEnabled
    public String ClearnextstepforReco1 { get; set; }
    @AuraEnabled
    public String ClearnextstepforReco2 { get; set; }
    @AuraEnabled
    public Boolean isRecommendationReport { get; set; }
  }
}