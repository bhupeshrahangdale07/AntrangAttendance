({
    doInit: function(component, event, helper) {
        debugger;
        helper.initHelper(component);
    },
    
    saveOppAssignment:function(component, event, helper) {
        helper.checkMoreThan3JobsByContact(component);
    },
  
 // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
       // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
   },
    
 // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
     // make Spinner attribute to false for hide loading spinner    
       component.set("v.Spinner", false);
    },
    
    backtoContact: function(component,event,helper){
        var recordId = component.get("v.recordId");
     	window.location.href = '/' + recordId;
    }
})