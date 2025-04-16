public with sharing class studentLoginByMangesh {

    @AuraEnabled(Cacheable=true)
    public static Map<string,string> fetchMediumFieldValues(){
        Map<string,string> labelValueMap = new Map<string,string>();

        Schema.SObjectType accountType = Schema.getGlobalDescribe().get('Account');
        Map<String, Schema.SObjectField> fieldsData= accountType.getDescribe().fields.getMap();
        Schema.DescribeFieldResult industry = fieldsData.get('Medium_Language_of_Instruction__c').getDescribe();
        List<Schema.PicklistEntry> pickList = industry.getPicklistValues();
        
        for(Schema.PicklistEntry pc : pickList){
            if(pc.isActive()==true){
                labelValueMap.put(pc.getLabel(),pc.getValue());
            }
        }
        System.debug(labelValueMap.keySet()); 
        
        RETURN labelValueMap;   
    }


    @AuraEnabled(Cacheable=true)
    public static List<Account>  fetchSchools(WrapperForStudentLogin parameterObject){
       
    string school = parameterObject.school;
    string city = parameterObject.city;
    string medium = parameterObject.medium;

    System.debug('ParameterObject Value  : '+parameterObject);

    String Query='';

    List<String> namesList =  new List<String>();
    namesList.add(school+'%');
    namesList.add('%'+school+'%');
    namesList.add('%'+school);

    List<String> citiesList =  new List<String>();
    citiesList.add(city+'%');
    citiesList.add('%'+city+'%');
    citiesList.add('%'+city);

    if(String.isNotBlank(school)){
            Query+='SELECT Id,Name FROM Account WHERE Name LIKE :namesList';
    }

    if(String.isNotBlank(city)){
        
        if(Query == ''){
            Query+='SELECT Id,Name FROM Account WHERE District__r.Name LIKE :citiesList';
        }else{
            Query+=' AND District__r.Name LIKE :citiesList';
        }
    }

    if(String.isNotBlank(medium)){
        if(Query == ''){
            Query+='SELECT Id,Name FROM Account WHERE Medium_Language_of_Instruction__c = :medium';
        }else{
            Query+=' AND Medium_Language_of_Instruction__c = :medium';
        }
    }

    if(String.isNotBlank(query)){
        Query+=' AND RecordType.Name=\'School\'';
    }

    System.debug('Final query : '+Query);

    if(String.isNotBlank(Query)){
        List<Account> acctsList = Database.query(Query);
        RETURN acctsList;
    }
    RETURN new List<Account>();

}



    @AuraEnabled(Cacheable=true)    
    public static List<Contact> fetchRelatedStudents(String Id,String StudentName){
        //1. Barcode Starting with 'Custom setting' i.e. 20;
        //2. Related to the School we selected.


        AntarangSetting__c antrang_Cs = AntarangSetting__c.getInstance();
        String barcodeIntials=  antrang_Cs.Bar_Code_Initial_for_Grade_10__c;
        System.debug('barcode Intials for student 10th Passed out : '+barcodeIntials);

        String likeStringForBarcodeIntials = barcodeIntials+'%';


        List<String> namesList =  new List<String>();
        namesList.add(StudentName+'%');
        namesList.add('%'+StudentName+'%');
        namesList.add('%'+StudentName);

        String Query = '';
        if(String.isNotBlank(Id)){
            if(Query==''){
                Query = 'SELECT Id,Name FROM CONTACT WHERE Grade_10_Barcode__c LIKE :likeStringForBarcodeIntials AND G10_Batch_Code__r.School_Name__c = :Id';
            }
        }

        if(String.isNotBlank(StudentName)){
            if(Query==''){
                Query = 'SELECT Id,Name FROM CONTACT WHERE Grade_10_Barcode__c LIKE :likeStringForBarcodeIntials AND Name LIKE :namesList';
            }else{
                Query +=' AND Name LIKE :namesList';
            } 
        }

        System.debug('Final Query String Of Student Contacts : '+Query);
        
        if(String.isNotBlank(Query)){
            List<Contact> students = Database.query(Query);
            RETURN students;
        }
        RETURN null;
    }




    
}














/*

TEST The Methods using below code in Anonymous window of developer console.
-----------------------------------------------------------------------------

//Method 2:
WrapperForStudentLogin wp =new WrapperForStudentLogin();
wp.school='Ak';
wp.city='Mumbai';
wp.medium='English';

List<Account> accts = studentLoginByMangesh.fetchSchools(wp);
System.debug('Schools :'+accts);
system.debug('Count :'+accts.size());

//Method 3:
List<Contact> students = studentLoginByMangesh.fetchRelatedStudents('0011m00000ZqDjmAAF');
System.debug('students :'+students);
system.debug('Count :'+students.size());

*/