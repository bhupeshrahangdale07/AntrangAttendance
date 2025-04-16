({
    myAction: function (component, event, helper) {

        //     component.set('v.columns',[
        //     {label: 'Name', fieldName: 'Full_Name__c', type: 'text' },
        //     {label: 'Edit', type: 'button', initialWidth: 135, typeAttributes: { label: 'Edit', name: 'Edit', variant: 'brand', title: 'Click to Edit Student'}}
        // ]);

        helper.setColumns(component, event, helper);

        var BatchId = component.get('v.batchId');
        var selectedGrade = component.get('v.selectedGrade1');
        var action = component.get("c.totalStudentInBatch");
        action.setParams({
            batchId: BatchId,
            grade: selectedGrade
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                component.set("v.showSpinner", false);
                console.log('a = ', response);
                component.set('v.data', response.getReturnValue().studentList);
                component.set('v.totalStudents', response.getReturnValue()['countStudent']);
                component.set('v.selectedSchool', response.getReturnValue()['SchoolName']);
                component.set('v.selectedGrade', response.getReturnValue()['GradeName']);
                component.set('v.selectedBatchNumber', response.getReturnValue()['BatchNumber']);
                component.set('v.selectedBatchName', response.getReturnValue()['BatchName']);
                component.set('v.isDisableStudentLinking', response.getReturnValue()['isDisableStudentLinking']);
            } else if (state === 'ERROR') {
                component.set("v.showSpinner", false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // Show toast message with the error message
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error",
                            "message": errors[0].message,
                            "type": "error"
                        });
                        toastEvent.fire();
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },

    setColumns: function (component, event, helper) {
        var grade = component.get('v.selectedGrade1');
        if (grade === 'Grade 9') {
            component.set('v.columns', [
                { label: 'Name', fieldName: 'Full_Name__c', type: 'text'}
                // ,
                // { label: 'G9 Whatsapp Number', fieldName: 'G9_Whatsapp_Number__c', type: 'text'},
                // { label: '', type: 'button', initialWidth: 100, typeAttributes: { label: 'Edit', name: 'Edit', variant: 'brand', title: 'Click to Edit Student' }}
            ]);
        } else if (grade === 'Grade 10') {
            component.set('v.columns', [
                { label: 'Name', fieldName: 'Full_Name__c', type: 'text'},
                { label: 'G10 Whatsapp Number', fieldName: 'G10_Whatsapp_Number__c', type: 'text'},
                { label: 'Action', type: 'button', initialWidth: 150, typeAttributes: { label: 'Edit', name: 'Edit', variant: 'brand', title: 'Click to Edit Student' } }
            ]);
        } else if (grade === 'Grade 11') {
            component.set('v.columns', [
                { label: 'Name', fieldName: 'Full_Name__c', type: 'text'},
                { label: 'G11 Whatsapp Number', fieldName: 'G11_Whatsapp_Number__c', type: 'text'},
                // { label: 'What are you currently studying ?', fieldName: 'What_are_you_currently_studying__c', type: 'text'},
                { label: 'Action', type: 'button', initialWidth: 150, typeAttributes: { label: 'Edit', name: 'Edit', variant: 'brand', title: 'Click to Edit Student' } }
            ]);
        } else if (grade === 'Grade 12') {
            component.set('v.columns', [
                { label: 'Name', fieldName: 'Full_Name__c', type: 'text'},
                { label: 'G12 Whatsapp Number', fieldName: 'G12_Whatsapp_Number__c', type: 'text'},
                // { label: 'What are you currently studying ?',fieldName: 'What_are_you_currently_studying__c', type: 'text'},
                { label: 'Action', type: 'button', initialWidth: 150, typeAttributes: { label: 'Edit', name: 'Edit', variant: 'brand', title: 'Click to Edit Student' } }
            ]);
        } else {
            component.set('v.columns', [
                { label: 'Name', fieldName: 'Full_Name__c', type: 'text'},
                // { label: '', type: 'button', initialWidth: 100, typeAttributes: { label: 'Edit', name: 'Edit', variant: 'brand', title: 'Click to Edit Student' } }
            ]);
        }

    },

    doTransilations: function (component, event, helper) {
        var label = {
            'StudentDetails': 'छात्र की जानकारी',
            'TitleTagLine': 'इस फॉर्म का उपयोग किसी नए छात्र को जोड़ने या पहले से ही बैच में जोड़े गए छात्रों के नाम देखने के लिए किया जाता है।',
            'SchoolName': 'स्कूल के नाम :',
            'Grade': 'श्रेणी :',
            'BatchCode': 'बैच कोड :',
            'TotalStudent': 'कुल छात्र :',
            'SubTagLine': 'नीचे उन छात्रों के नाम दिए गए हैं जिन्हें पहले ही बैच में जोड़ा जा चुका है',
        }

        var CurrStuInOptions = [
            // { label: 'Select', value: '' },
            { label: 'कक्षा ११/१२: कला', value: 'Class 11/12: Arts' },
            { label: 'कक्षा ११/१२: विज्ञान', value: 'Class 11/12: Science' },
            { label: 'कक्षा ११/१२: वाणिज्य', value: 'Class 11/12: Commerce' },
            { label: 'डिप्लोमा', value: 'Diploma' },
            { label: 'अप्रेन्टस्शिप ', value: 'Apprenticeship' },
            { label: 'वोकेशनल सर्टिफिकेट कोर्स', value: 'Vocational Certificate Course' },
            { label: 'अन्य', value: 'Other' }
            // ,
            // { label: 'Multiple answers selected', value: '*' },
            // { label: 'No Answer', value: 'No' }
        ];

        component.set('v.whatAreYouCurrentlyStudyingOptions', CurrStuInOptions);
        component.set('v.Label', label);
    },

    showEditModal: function (component, row) {
        component.set('v.selectedRawStudent', JSON.parse(JSON.stringify(row)));
        component.set('v.selectedStudent', row);
        component.set('v.showEditModal', true);
    },

    updateStudentData: function (component, event, helper) {

        // const oldObj = component.get('v.selectedRawStudent');
        // const newObj = component.get('v.selectedStudent');
        
        // var isUpdated = false;
        // // Iterate over the keys of oldObj
        // Object.keys(oldObj)?.forEach(function(key) {
        //     // Check if the value of the key in oldObj is different from the value in newObj
        //     if (oldObj[key] !== newObj[key]) {
        //         isUpdated = true;
        //     }
        // });

        // if(!isUpdated){
        //     helper.resetEditProperties(component, event, helper);
        //     return;
        // }

        var action = component.get("c.updateStudentData");
        action.setParams({
            selectedStudentrecord: JSON.stringify(component.get("v.selectedStudent"))
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                component.set('v.selectedRawStudent', undefined);
                component.set('v.selectedStudent', undefined);
                component.set('v.showEditModal', false);
				
                var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success",
                            "message": "Student Data is Updated Successfully",
                            "type": "success"
                        });
                        toastEvent.fire();
                
                helper.myAction(component, event, helper);
            } else if (state === 'ERROR') {
                component.set("v.showSpinner", false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // Show toast message with the error message
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error",
                            "message": errors[0].message,
                            "type": "error"
                        });
                        toastEvent.fire();
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },

    isSelectedRecordUpdated: function (component, event, helper){
        const oldObj = component.get('v.selectedRawStudent');
        const newObj = component.get('v.selectedStudent');
        
        var isUpdated = false;
        // Iterate over the keys of oldObj
        Object.keys(newObj).forEach(function(key) {
            // Check if the value of the key in oldObj is different from the value in newObj
            if ((!oldObj[key] && newObj[key] && newObj[key] != '') || (oldObj[key] && oldObj[key] !== newObj[key]) ) {
                isUpdated = true;
                return isUpdated;
            }
        });

        return isUpdated;
    },

    resetEditProperties: function (component, event, helper){
        component.set("v.showEditModal", false);
        component.set('v.selectedStudent', undefined);
        component.set('v.selectedRawStudent', undefined);
    }
})