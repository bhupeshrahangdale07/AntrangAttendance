({
    handleProgressBarEvent : function(component, event, helper) {
		var ProgressNumber = event.getParam("CurrentNumber");
        var TotalProgressNumber = event.getParam("TotalSize");
 		var lstOfTotalNumber = [];
        
        if(parseInt(TotalProgressNumber) > 0){
            for(var i = 1 ; i <= parseInt(TotalProgressNumber) ; i++){
            	lstOfTotalNumber.push(i);    
            }
        }
        
        component.set("v.selectedProgressBar", ProgressNumber);
        component.set("v.totalProgressBar", lstOfTotalNumber);
	}
})