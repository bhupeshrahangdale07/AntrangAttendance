//Last change : Checking Endline Assessment in Assessment_Marks__c

public class StudentProfession {
    public static void myMethod(){
        //  Id RecTypeEA = Schema.SObjectType.Assessment_Marks__c.getRecordTypeInfosByName().get('Endline Assessment').getRecordTypeId();
        
        List<Contact> UpdatedList = New List<Contact>();
        List<String> QList = New List<String>{'a1V7F000002clKOUAY','a1V7F000002clKPUAY', 'a1V7F000002cpLXUAY', 'a1V7F000002cpLZUAY', 'a1V7F000002cpMCUAY', 'a1V7F000002cpMEUAY', 'a1V7F000002cpMrUAI', 'a1V7F000002cpMtUAI'};
        Set<Id> EndLineRecTypeId = New Set<Id>();
        Map<String, IARP_Master__c> IARPMap = New Map<String, IARP_Master__c>();       
        for(IARP_Master__c ObjIARP : [select id, Is_Active__c, Name from IARP_Master__c where Is_Active__c = true]){
            IARPMap.put(ObjIARP.Name, ObjIARP);
        }
        
        List<Assessment_Detail__c> listProfession1 = [select id, Question__r.Question_Label__c , Career_Answer__c, Student__c, Student__r.Name, Student__r.Aspiration_1__r.Name, Student__r.Aspiration_2__r.Name
                                                      from Assessment_Detail__c where Question__c = 'a1V7F000002cpMtUAI' and (Student__r.Bar_Code__c like '21%' OR Student__r.Bar_Code__c like '20%')  
                                                      and Student__r.Submitted_Page__c = 'I;A;R'and Career_Answer__c != 'I do not know/Not sure' and Assessment_Marks__r.RecordTypeId = '0129C0000004HacQAE'];
        
        If(!listProfession1.isEmpty()){
            For(Assessment_Detail__c Assd : listProfession1){
                If(IARPMap.containsKey(Assd.Career_Answer__c) && Assd.Student__r.Aspiration_1__r.Name != Assd.Career_Answer__c){
                    Assd.Student__r.Aspiration_2__c = IARPMap.get(Assd.Career_Answer__c).Id;                
                    UpdatedList.add(Assd.Student__r);
                    system.debug('Size '+ UpdatedList);
                }
            }
            If(!UpdatedList.isEmpty()){
                update UpdatedList;
            }
        }    
    }
}

/*
for(Assessment_Detail__c ad: [
select id, Question__r.Question_Label__c , Career_Answer__c
from Assessment_Detail__c 
where 
Question__c = 'a1V7F000002clKOUAY'
and (Student__r.Bar_Code__c like '21%' OR Student__r.Bar_Code__c like '20%')  
and Student__r.Submitted_Page__c = 'I;A;R' 
and Career_Answer__c != 'I do not know/Not sure'
and Student__r.Aspiration_1__c = null
]) {
Student__r.Aspiration_1__c = Career_Answer__c;
}
*/