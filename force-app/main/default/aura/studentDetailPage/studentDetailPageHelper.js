({
     myAction : function(component, event, helper) {
		
        component.set('v.columns',[{label: 'Name', fieldName: 'Full_Name__c', type: 'text'}]);
        
        var BatchId = component.get('v.batchId');
        var action = component.get("c.totalStudentInBatch");
        action.setParams({
            batchId : BatchId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('n0 =',response.getReturnValue().studentList);
            if(state == 'SUCCESS') {
                console.log('a = ',response);
                component.set('v.data', response.getReturnValue().studentList);
                component.set('v.totalStudents', response.getReturnValue()['countStudent']);
                component.set('v.selectedSchool', response.getReturnValue()['SchoolName']);
                component.set('v.selectedGrade', response.getReturnValue()['GradeName']);
                component.set('v.selectedBatchNumber',response.getReturnValue()['BatchNumber']);
                component.set('v.selectedBatchName',response.getReturnValue()['BatchName']);
            }
        });
        $A.enqueueAction(action);
    },
})