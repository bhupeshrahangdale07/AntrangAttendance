@isTest
public class CareerSkillTriggerHandlerTest {
    @isTest
    public static void TestCarrierSkill(){
        Account acc = New Account();
        acc.Name = 'Test Account';
        Insert acc;
  
        Contact cont = New Contact();
        cont.LastName = 'Test LastName';
        cont.Grade_10_Barcode__c = '1234567890';
        cont.Bar_Code__c = '1234567890';
        cont.AccountId = acc.Id;
        Insert cont;
        
        Contact cont2 = New Contact();
        cont2.LastName = 'Test LastName';
        cont2.Grade_9_Barcode__c = '1234567890';
        cont2.Bar_Code__c = '1234567123';
        cont2.AccountId = acc.Id;
        Insert cont2;
        
        Contact cont3 = New Contact();
        cont3.LastName = 'Test LastName';
        cont3.Grade_11_Barcode__c = '1234567890';
        cont3.Bar_Code__c = '1234567456';
        cont3.AccountId = acc.Id;
        Insert cont3;
        
        Contact cont4 = New Contact();
        cont4.LastName = 'Test LastName';
        cont4.Grade_12_Barcode__c = '1234567890';
        cont4.Bar_Code__c = '1234567789';
        cont4.AccountId = acc.Id;
        Insert cont4;
        
        List<Career_Skill__c> csList = New List<Career_Skill__c>();
        For(Integer i=0;i<10;i++){
            Career_Skill__c cs = New Career_Skill__c();
            cs.Student__c = cont.Id;
            cs.Barcode__c = '123456789'+i;
            cs.Q_11_1__c = 'A';
            cs.Q_11_2__c = 'A';
            cs.Q_11_3__c = 'A';
            cs.Q_11_6__c = 'A';
            cs.Q_11_8__c = 'A';
            cs.Q_11_9__c = 'A';
            cs.Q_11_Ans__c = 1;
            cs.Q_12_1__c = 'A';
            cs.Q_12_2__c = 'A';
            cs.Q_12_3__c = 'A';
            cs.Q_12_4__c = 'A';
            cs.Q_13__c = 'B';
            cs.Q_14__c = 'B';
            cs.Q_15_1__c = '2';
            cs.Q_15_2__c = '2';
            cs.Q_15_3__c = '2'; 
            cs.Q_15_4__c = '2'; 
            cs.Q_15_5__c = '2';
            cs.Q_15_6__c = '2';
            cs.Q_15_7__c = '2';
            cs.Q_15_8__c = '2';
            cs.Q_15_9__c = '2';
            cs.Q_15_Ans__c = 1;
            cs.Q_16__c = '1';
            
            csList.add(cs);
        }
        test.startTest();
        Insert csList;
        CareerSkillTriggerHandler.populateStudentAndMarksCalculation(csList);
        test.stopTest();
    }
}