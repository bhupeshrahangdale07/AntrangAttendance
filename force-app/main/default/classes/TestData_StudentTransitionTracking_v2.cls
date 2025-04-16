@istest
public without sharing class TestData_StudentTransitionTracking_v2 {

    public static void generateQnsAndOptions(String language){
        if(language == 'English'){

            List<Transition_Tracking_QnA__c> lstQnAs = new  List<Transition_Tracking_QnA__c>();


            Transition_Tracking_QnA__c objQuestion1=new Transition_Tracking_QnA__c();
            objQuestion1.Section__c = 1;
            objQuestion1.Language__c = 'English';
            objQuestion1.Display_Type__c = 'Label';
            objQuestion1.Display_Number__c = '1';
            objQuestion1.Question_Label__c = 'Student UID';
            objQuestion1.Order_of_Question__c = 1;
            objQuestion1.Is_Required_Answer__c = false;
            objQuestion1.Maximum_Allow_Answer__c = 0;
            objQuestion1.Question_Contact_Api_Name__c = 'Bar_Code__c';
            objQuestion1.Is_Career_Question__c = false;
            objQuestion1.Pull_From_Contact__c = true;
            objQuestion1.Validation_To_Do__c = false;
            objQuestion1.Validation_Regex__c = '';
            objQuestion1.Maximum_Value_To_Enter__c = 0;
            objQuestion1.Validation_Error_Message__c = '';
            objQuestion1.Is_Dependent_Question__c = false;
            objQuestion1.is_Read_Only__c = true;   
            objQuestion1.is_Active__c = true;   
            lstQnAs.add(objQuestion1);
        
        
            Transition_Tracking_QnA__c objQuestion2=new Transition_Tracking_QnA__c();
            objQuestion2.Section__c = 1;
            objQuestion2.Language__c = 'English';
            objQuestion2.Display_Type__c = 'Label';
            objQuestion2.Display_Number__c = '2';
            objQuestion2.Question_Label__c = 'School Name';
            objQuestion2.Order_of_Question__c = 2;
            objQuestion2.Is_Required_Answer__c = false;
            objQuestion2.Maximum_Allow_Answer__c = 0;
            objQuestion2.Question_Contact_Api_Name__c = '';
            objQuestion2.Is_Career_Question__c = false;
            objQuestion2.Pull_From_Contact__c = true;
            objQuestion2.Validation_To_Do__c = false;
            objQuestion2.Validation_Regex__c = '';
            objQuestion2.Maximum_Value_To_Enter__c = 0;
            objQuestion2.Validation_Error_Message__c = '';
            objQuestion2.Is_Dependent_Question__c = false;
            objQuestion2.is_Read_Only__c = true;  
            objQuestion2.is_Active__c = true;  
            lstQnAs.add(objQuestion2);
            
        
        
            Transition_Tracking_QnA__c objQuestion3=new Transition_Tracking_QnA__c();
            objQuestion3.Section__c = 1;
            objQuestion3.Language__c = 'English';
            objQuestion3.Display_Type__c = 'Label';
            objQuestion3.Display_Number__c = '3';
            objQuestion3.Question_Label__c = 'Alternate Phone Number';
            objQuestion3.Order_of_Question__c = 3;
            objQuestion3.Is_Required_Answer__c = false;
            objQuestion3.Maximum_Allow_Answer__c = 0;
            objQuestion3.Question_Contact_Api_Name__c = 'G10_Alternate_Mobile_No__c';
            objQuestion3.Is_Career_Question__c = false;
            objQuestion3.Pull_From_Contact__c = true;
            objQuestion3.Validation_To_Do__c = true;
            objQuestion3.Validation_Regex__c = '^[0-9]{10}$';
            objQuestion3.Maximum_Value_To_Enter__c = 10;
            objQuestion3.Validation_Error_Message__c = 'Please enter Valid Phone Number.';
            objQuestion3.Is_Dependent_Question__c = false;
            objQuestion3.is_Read_Only__c = false;  
            objQuestion3.is_Active__c = true;  
            lstQnAs.add(objQuestion3);
        
            Transition_Tracking_QnA__c objQuestion4=new Transition_Tracking_QnA__c();
            objQuestion4.Section__c = 1;
            objQuestion4.Language__c = 'English';
            objQuestion4.Display_Type__c = 'Label';
            objQuestion4.Display_Number__c = '4';
            objQuestion4.Question_Label__c = 'Age';
            objQuestion4.Order_of_Question__c = 4;
            objQuestion4.Is_Required_Answer__c = false;
            objQuestion4.Maximum_Allow_Answer__c = 0;
            objQuestion4.Question_Contact_Api_Name__c = 'Calculated_Age__c';
            objQuestion4.Is_Career_Question__c = false;
            objQuestion4.Pull_From_Contact__c = true;
            objQuestion4.Validation_To_Do__c = false;
            objQuestion4.Validation_Regex__c = '';
            objQuestion4.Maximum_Value_To_Enter__c = 0;
            objQuestion4.Validation_Error_Message__c = '';
            objQuestion4.Is_Dependent_Question__c = false;
            objQuestion4.is_Read_Only__c = true;  
            objQuestion4.is_Active__c = true;  
            lstQnAs.add(objQuestion4);
        
        
        
            Transition_Tracking_QnA__c objQuestion5=new Transition_Tracking_QnA__c();
            objQuestion5.Section__c = 1;
            objQuestion5.Language__c = 'English';
            objQuestion5.Display_Type__c = 'RadioGroup';
            objQuestion5.Display_Number__c = '5';
            objQuestion5.Question_Label__c = 'Gender';
            objQuestion5.Order_of_Question__c = 5;
            objQuestion5.Is_Required_Answer__c = false;
            objQuestion5.Maximum_Allow_Answer__c = 0;
            objQuestion5.Question_Contact_Api_Name__c = 'Gender__c';
            objQuestion5.Is_Career_Question__c = false;
            objQuestion5.Pull_From_Contact__c = true;
            objQuestion5.Validation_To_Do__c = false;
            objQuestion5.Validation_Regex__c = '';
            objQuestion5.Maximum_Value_To_Enter__c = 0;
            objQuestion5.Validation_Error_Message__c = '';
            objQuestion5.Is_Dependent_Question__c = false;
            objQuestion5.is_Read_Only__c = false;  
            objQuestion5.is_Active__c = false;  
            objQuestion5.is_Active__c = true;  
            lstQnAs.add(objQuestion5);
        
           
        
            //******* CREATED SECTION 1 QNS DATA TILL HERE. *********
        
        
            //Career Question
            Transition_Tracking_QnA__c objQuestion6=new Transition_Tracking_QnA__c();
            objQuestion6.Section__c = 2;
            objQuestion6.Language__c = 'English';
            objQuestion6.Display_Type__c = 'PickList';
            objQuestion6.Display_Number__c = '1';
            objQuestion6.Question_Label__c = 'What do you want to become in life?(or) What is your career choice?';
            objQuestion6.Order_of_Question__c = 1;
            objQuestion6.Is_Required_Answer__c = false;
            objQuestion6.Maximum_Allow_Answer__c = 0;
            objQuestion6.Question_Contact_Api_Name__c = '';
            objQuestion6.Is_Career_Question__c = true;
            objQuestion6.Pull_From_Contact__c = false;
            objQuestion6.Validation_To_Do__c = false;
            objQuestion6.Validation_Regex__c = '';
            objQuestion6.Maximum_Value_To_Enter__c = 0;
            objQuestion6.Validation_Error_Message__c = '';
            objQuestion6.Is_Dependent_Question__c = false;
            objQuestion6.is_Read_Only__c = false;  
            objQuestion6.is_Active__c = true;  
            lstQnAs.add(objQuestion6);
        
            //Question For Show Other Functionality
            Transition_Tracking_QnA__c objQuestion7=new Transition_Tracking_QnA__c();
            objQuestion7.Section__c = 2;
            objQuestion7.Language__c = 'English';
            objQuestion7.Display_Type__c = 'PickList';
            objQuestion7.Display_Number__c = '2';
            objQuestion7.Question_Label__c = 'Why did you choose this career?';
            objQuestion7.Order_of_Question__c = 2;
            objQuestion7.Is_Required_Answer__c = false;
            objQuestion7.Maximum_Allow_Answer__c = 0;
            objQuestion7.Question_Contact_Api_Name__c = '';
            objQuestion7.Is_Career_Question__c = false;
            objQuestion7.Pull_From_Contact__c = false;
            objQuestion7.Validation_To_Do__c = false;
            objQuestion7.Validation_Regex__c = '';
            objQuestion7.Maximum_Value_To_Enter__c = 0;
            objQuestion7.Validation_Error_Message__c = '';
            objQuestion7.Is_Dependent_Question__c = false;
            objQuestion7.is_Read_Only__c = false;  
            objQuestion7.is_Active__c = true;  
            lstQnAs.add(objQuestion7);
                
        
        
            //Question For Dependent Functionality
            Transition_Tracking_QnA__c objQuestion8=new Transition_Tracking_QnA__c();
            objQuestion8.Section__c = 2;
            objQuestion8.Language__c = 'English';
            objQuestion8.Display_Type__c = 'RadioGroup';
            objQuestion8.Display_Number__c = '3';
            objQuestion8.Question_Label__c = 'Have you taken admission in a school/college/course/got a job?';
            objQuestion8.Order_of_Question__c = 3;
            objQuestion8.Is_Required_Answer__c = false;
            objQuestion8.Maximum_Allow_Answer__c = 0;
            objQuestion8.Question_Contact_Api_Name__c = '';
            objQuestion8.Is_Career_Question__c = false;
            objQuestion8.Pull_From_Contact__c = false;
            objQuestion8.Validation_To_Do__c = false;
            objQuestion8.Validation_Regex__c = '';
            objQuestion8.Maximum_Value_To_Enter__c = 0;
            objQuestion8.Validation_Error_Message__c = '';
            objQuestion8.Is_Dependent_Question__c = false;
            objQuestion8.is_Read_Only__c = false;  
            objQuestion8.is_Active__c = true;  
            lstQnAs.add(objQuestion8);
        
        
            Transition_Tracking_QnA__c objQuestion9=new Transition_Tracking_QnA__c();
            objQuestion9.Section__c = 2;
            objQuestion9.Language__c = 'English';
            objQuestion9.Display_Type__c = 'Text';
            objQuestion9.Display_Number__c = '4';
            objQuestion9.Question_Label__c = 'Specify which School/ college/course/job';
            objQuestion9.Order_of_Question__c = 4;
            objQuestion9.Is_Required_Answer__c = false;
            objQuestion9.Maximum_Allow_Answer__c = 0;
            objQuestion9.Question_Contact_Api_Name__c = '';
            objQuestion9.Is_Career_Question__c = false;
            objQuestion9.Pull_From_Contact__c = false;
            objQuestion9.Validation_To_Do__c = false;
            objQuestion9.Validation_Regex__c = '';
            objQuestion9.Maximum_Value_To_Enter__c = 0;
            objQuestion9.Validation_Error_Message__c = '';
            objQuestion9.Is_Dependent_Question__c = true;
            objQuestion9.is_Read_Only__c = false;  
            objQuestion9.is_Active__c = true;  
            lstQnAs.add(objQuestion9);
        
        
        
            //Question For Multi-Select Functionality
            Transition_Tracking_QnA__c objQuestion10=new Transition_Tracking_QnA__c();
            objQuestion10.Section__c = 2;
            objQuestion10.Language__c = 'English';
            objQuestion10.Display_Type__c = 'CheckboxGroup';
            objQuestion10.Display_Number__c = '5';
            objQuestion10.Question_Label__c = 'Do you need help with anything?';
            objQuestion10.Order_of_Question__c = 5;
            objQuestion10.Is_Required_Answer__c = false;
            objQuestion10.Maximum_Allow_Answer__c = 0;
            objQuestion10.Question_Contact_Api_Name__c = '';
            objQuestion10.Is_Career_Question__c = false;
            objQuestion10.Pull_From_Contact__c = false;
            objQuestion10.Validation_To_Do__c = false;
            objQuestion10.Validation_Regex__c = '';
            objQuestion10.Maximum_Value_To_Enter__c = 0;
            objQuestion10.Validation_Error_Message__c = '';
            objQuestion10.Is_Dependent_Question__c = false;
            objQuestion10.is_Read_Only__c = false;  
            objQuestion10.is_Active__c = true;  
            lstQnAs.add(objQuestion10);



            //Question : As Normal Picklist with no OTHER as Option
            Transition_Tracking_QnA__c objQuestion11=new Transition_Tracking_QnA__c();
            objQuestion11.Section__c = 2;
            objQuestion11.Language__c = 'English';
            objQuestion11.Display_Type__c = 'PickList';
            objQuestion11.Display_Number__c = '6';
            objQuestion11.Question_Label__c = 'What is your Step 2 towards your career?';
            objQuestion11.Order_of_Question__c = 6;
            objQuestion11.Is_Required_Answer__c = false;
            objQuestion11.Maximum_Allow_Answer__c = 0;
            objQuestion11.Question_Contact_Api_Name__c = '';
            objQuestion11.Is_Career_Question__c = false;
            objQuestion11.Pull_From_Contact__c = false;
            objQuestion11.Validation_To_Do__c = false;
            objQuestion11.Validation_Regex__c = '';
            objQuestion11.Maximum_Value_To_Enter__c = 0;
            objQuestion11.Validation_Error_Message__c = '';
            objQuestion11.Is_Dependent_Question__c = false;
            objQuestion11.is_Read_Only__c = false;  
            objQuestion11.is_Active__c = true;  
            lstQnAs.add(objQuestion11);

            
        
            //******* CREATED SECTION 2 QNS DATA TILL HERE. *********
        
        
            insert lstQnAs;  //INSERT LIST OF QUESTIONS
        
        
        
            List<Transition_Tracking_QnA_Options__c> lstQnAOptions = new  List<Transition_Tracking_QnA_Options__c>();
        
            //objQuestion5 -> Question Option
            Transition_Tracking_QnA_Options__c objOption1 = new Transition_Tracking_QnA_Options__c();
            objOption1.Question__c = objQuestion5.Id;
            objOption1.Answer_Value__c='Male';
            objOption1.Order_of_Answer__c=1;
            objOption1.Dependent_Question__c=null;
            objOption1.Is_Show_Others__c=false;
            objOption1.is_Active__c=true;
            lstQnAOptions.add(objOption1);
        
            Transition_Tracking_QnA_Options__c objOption2 = new Transition_Tracking_QnA_Options__c();
            objOption2.Question__c = objQuestion5.Id;
            objOption2.Answer_Value__c='Female';
            objOption2.Order_of_Answer__c=2;
            objOption2.Dependent_Question__c=null;
            objOption2.Is_Show_Others__c=false;
            objOption2.is_Active__c=true;
            lstQnAOptions.add(objOption2);
        
            Transition_Tracking_QnA_Options__c objOption3 = new Transition_Tracking_QnA_Options__c();
            objOption3.Question__c = objQuestion5.Id;
            objOption3.Answer_Value__c='Prefer not to say';
            objOption3.Order_of_Answer__c=3;
            objOption3.Dependent_Question__c=null;
            objOption3.Is_Show_Others__c=false;
            objOption3.is_Active__c=true;
            lstQnAOptions.add(objOption3);
        
            
            
            //objQuestion7 -> Question Option
            Transition_Tracking_QnA_Options__c objOption4 = new Transition_Tracking_QnA_Options__c();
            objOption4.Question__c = objQuestion7.Id;
            objOption4.Answer_Value__c='This option is better suited to my interest';
            objOption4.Order_of_Answer__c=1;
            objOption4.Dependent_Question__c=null;
            objOption4.Is_Show_Others__c=false;
            objOption4.is_Active__c=true;
            lstQnAOptions.add(objOption4);
        
            Transition_Tracking_QnA_Options__c objOption5 = new Transition_Tracking_QnA_Options__c();
            objOption5.Question__c = objQuestion7.Id;
            objOption5.Answer_Value__c='Family or friends are in that profession';
            objOption5.Order_of_Answer__c=2;
            objOption5.Dependent_Question__c=null;
            objOption5.Is_Show_Others__c=false;
            objOption5.is_Active__c=true;
            lstQnAOptions.add(objOption5);
        
            Transition_Tracking_QnA_Options__c objOption6 = new Transition_Tracking_QnA_Options__c();
            objOption6.Question__c = objQuestion7.Id;
            objOption6.Answer_Value__c='Other';
            objOption6.Order_of_Answer__c=3;
            objOption6.Dependent_Question__c=null;
            objOption6.Is_Show_Others__c=true;
            objOption6.is_Active__c=true;
            lstQnAOptions.add(objOption6);
        
        
        
            //objQuestion8 -> Question Option
            Transition_Tracking_QnA_Options__c objOption7 = new Transition_Tracking_QnA_Options__c();
            objOption7.Question__c = objQuestion8.Id;
            objOption7.Answer_Value__c='Yes';
            objOption7.Order_of_Answer__c=1;
            objOption7.Dependent_Question__c=objQuestion9.Id;
            objOption7.Is_Show_Others__c=false;
            objOption7.is_Active__c=true;
            lstQnAOptions.add(objOption7);
        
            Transition_Tracking_QnA_Options__c objOption8 = new Transition_Tracking_QnA_Options__c();
            objOption8.Question__c = objQuestion8.Id;
            objOption8.Answer_Value__c='No';
            objOption8.Order_of_Answer__c=2;
            objOption8.Dependent_Question__c=null;
            objOption8.Is_Show_Others__c=false;
            objOption8.is_Active__c=true;
            lstQnAOptions.add(objOption8);
        
        
            //objQuestion10 -> Question Option
            Transition_Tracking_QnA_Options__c objOption9 = new Transition_Tracking_QnA_Options__c();
            objOption9.Question__c = objQuestion10.Id;
            objOption9.Answer_Value__c='Yes, with admissions';
            objOption9.Order_of_Answer__c=1;
            objOption9.Dependent_Question__c=null;
            objOption9.Is_Show_Others__c=false;
            objOption9.is_Active__c=true;
            lstQnAOptions.add(objOption9);
        
            Transition_Tracking_QnA_Options__c objOption10 = new Transition_Tracking_QnA_Options__c();
            objOption10.Question__c = objQuestion10.Id;
            objOption10.Answer_Value__c='Yes, with finding relevant courses';
            objOption10.Order_of_Answer__c=2;
            objOption10.Dependent_Question__c=null;
            objOption10.Is_Show_Others__c=false;
            objOption10.is_Active__c=true;
            lstQnAOptions.add(objOption10);
        
            Transition_Tracking_QnA_Options__c objOption11 = new Transition_Tracking_QnA_Options__c();
            objOption11.Question__c = objQuestion10.Id;
            objOption11.Answer_Value__c='No';
            objOption11.Order_of_Answer__c=3;
            objOption11.Dependent_Question__c=null;
            objOption11.Is_Show_Others__c=false;
            objOption11.is_Active__c=true;
            lstQnAOptions.add(objOption11);
        
            Transition_Tracking_QnA_Options__c objOption12 = new Transition_Tracking_QnA_Options__c();
            objOption12.Question__c = objQuestion10.Id;
            objOption12.Answer_Value__c='Other';
            objOption12.Order_of_Answer__c=4;
            objOption12.Dependent_Question__c=null;
            objOption12.Is_Show_Others__c=true;
            objOption12.is_Active__c=true;
            lstQnAOptions.add(objOption12);



            //objQuestion11 -> Question Option
            Transition_Tracking_QnA_Options__c objOption13 = new Transition_Tracking_QnA_Options__c();
            objOption13.Question__c = objQuestion11.Id;
            objOption13.Answer_Value__c='BA';
            objOption13.Order_of_Answer__c=1;
            objOption13.Dependent_Question__c=null;
            objOption13.Is_Show_Others__c=false;
            objOption13.is_Active__c=true;
            lstQnAOptions.add(objOption13);
        
            Transition_Tracking_QnA_Options__c objOption14 = new Transition_Tracking_QnA_Options__c();
            objOption14.Question__c = objQuestion11.Id;
            objOption14.Answer_Value__c='BSc';
            objOption14.Order_of_Answer__c=2;
            objOption14.Dependent_Question__c=null;
            objOption14.Is_Show_Others__c=false;
            objOption14.is_Active__c=true;
            lstQnAOptions.add(objOption14);

        
        
            insert lstQnAOptions;  //INSERT LIST OF QUESTIONS OPTIONS       

            //******* CREATED SECTION 1 QNS OPTIONS DATA TILL HERE. *********


        }
    }

}