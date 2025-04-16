/********************************************************************************************   
* NAME         : ContentDocumentLinkTriggerHandler 
* DESCRIPTION  : This class is use to Set default visibility.
*   
* @AUTHOR: Dev Team
* @DATE: 5th July 2021 
*   
********************************************************************************************/  

public class ContentDocumentLinkTriggerHandler {

    public static void setFileVisibility(List<ContentDocumentLink> listOfContentDocLinks){
        for (ContentDocumentLink cdl : listOfContentDocLinks){
            if (cdl.LinkedEntityId.getSobjectType() == Student_Feedback_mapping__c.SObjectType && cdl.Visibility != 'AllUsers'){
                cdl.Visibility = 'AllUsers';
            }
        }        
    }
    
}