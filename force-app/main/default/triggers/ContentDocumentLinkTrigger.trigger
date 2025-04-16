/********************************************************************************************   
* NAME         : ContentDocumentLinkTrigger
* DESCRIPTION  : This class is use to trigger handler class.
*   
* @AUTHOR: Dev Team
* @DATE: 5th July 2021 
*   
********************************************************************************************/  

trigger ContentDocumentLinkTrigger on ContentDocumentLink (before insert) {

    ContentDocumentLinkTriggerHandler.setFileVisibility(Trigger.New);
}