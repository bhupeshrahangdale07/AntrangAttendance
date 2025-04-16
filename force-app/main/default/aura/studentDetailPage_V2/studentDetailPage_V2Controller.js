({
    init: function (component, event, helper) {

        var label = {
            'StudentDetails': 'Student Details',
            'TitleTagLine1': 'This form is used to link student data from the previous grade to this one, or add new students. ',
            'TitleTagLine2': 'Use "Link" option for students who were in this program last year. Use "Add" to add new students to the system.',
            'SchoolName': 'School Name :',
            'Grade': 'Grade :',
            'BatchCode': 'Batch Code :',
            'TotalStudent': 'Total Students :',
            'SubTagLine': 'Below are the names of students who have already been linked/added to the batch. Use Edit Button to update the Student Data Again.',
        }

        component.set('v.Label', label);

        var queryString = window.location.search;
        var urlParams = new URLSearchParams(queryString);
        var facilitatorEmail = urlParams.get('fem')
        component.set('v.facilitatorEmail', decodeURI(facilitatorEmail));

        //var sURL = window.location.href;
        var batchId = urlParams.get('bid');
        component.set('v.batchId', decodeURI(batchId));

        var grd = urlParams.get('grd');
        console.log(grd);
        component.set('v.selectedGrade1', decodeURI(grd));

        var sch = urlParams.get('sch');
        component.set('v.sch', decodeURI(sch));

        var acid = urlParams.get('acid');
        component.set('v.acid', decodeURI(acid));

        var typ = urlParams.get('typ');
        component.set('v.typ', decodeURI(typ));

        var lng = urlParams.get('lng');
        component.set('v.lng', decodeURI(lng));

        var CurrStuInOptions = [
            // { label: 'Select', value: '' },
            { label: 'Class 11/12: Arts', value: 'Class 11/12: Arts' },
            { label: 'Class 11/12: Science', value: 'Class 11/12: Science' },
            { label: 'Class 11/12: Commerce', value: 'Class 11/12: Commerce' },
            { label: 'Diploma', value: 'Diploma' },
            { label: 'Apprenticeship', value: 'Apprenticeship' },
            { label: 'Vocational Certificate Course', value: 'Vocational Certificate Course' },
            { label: 'Other', value: 'Other' }
            // ,
            // { label: 'Multiple answers selected', value: '*' },
            // { label: 'No Answer', value: 'No' }
        ];
        component.set('v.whatAreYouCurrentlyStudyingOptions', CurrStuInOptions);

        if (decodeURI(lng) == 'Hindi') {
            helper.doTransilations(component, event, helper);
        }

        helper.myAction(component, event, helper);

    },

    baselineHandler: function (component, event, helper) {

        var navService = component.find("navService");
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Baseline01V2__c'
            },
            state: {
                typ: encodeURI(component.get('v.typ')),
                fem: encodeURI(component.get('v.facilitatorEmail')),
                lng: encodeURI(component.get('v.lng')),
                sch: encodeURI(component.get('v.sch')),
                grd: encodeURI(component.get('v.selectedGrade1')),
                bid: encodeURI(component.get('v.batchId')),
                acid: encodeURI(component.get('v.acid'))
            }
        };
        navService.navigate(pageReference);
    },

    handleLinkStudent: function (component, event, helper) {

        var navService = component.find("navService");
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Studentlinkform__c'
            },
            state: {
                typ: encodeURI(component.get('v.typ')),
                fem: encodeURI(component.get('v.facilitatorEmail')),
                lng: encodeURI(component.get('v.lng')),
                sch: encodeURI(component.get('v.sch')),
                grd: encodeURI(component.get('v.selectedGrade1')),
                bid: encodeURI(component.get('v.batchId')),
                acid: encodeURI(component.get('v.acid'))
            }
        };
        navService.navigate(pageReference);
    },

    handleBack: function (component, event, helper) {

        var navService = component.find("navService");
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'DataEntryDetailPageV2__c'
            },
            state: {
                fem: encodeURI(component.get('v.facilitatorEmail')),
                sch: encodeURI(component.get('v.sch')),
                grd: encodeURI(component.get('v.selectedGrade1')),
                bid: encodeURI(component.get('v.batchId')),
                acid: encodeURI(component.get('v.acid')),
                typ: encodeURI(component.get('v.typ')),
                lng: encodeURI(component.get('v.lng'))
            }
        };
        navService.navigate(pageReference);
    },

    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'Edit':
                helper.showEditModal(component, row);
                break;
            default:
                break;
        }
    },

    updateSelectedStudent: function (component, event, helper) {
        component.set("v.showSpinner", true);
        var fields = component.find('field');
        if (!Array.isArray(fields)) {
            fields = [fields]; 
        }

        var allValid = fields.reduce(function (validSoFar, inputCmp) {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if (allValid) {
            //  alert('All form entries look valid. Ready to submit!');
            if(helper.isSelectedRecordUpdated(component, event, helper)){
                helper.updateStudentData(component, event, helper);
            }else{
                helper.resetEditProperties(component, event, helper);
                component.set("v.showSpinner", false);
            }

        } else {
            // alert('Please update the invalid form entries and try again.');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error",
                "message": "Please update the invalid form entries and try again.",
                "type": "error"
            });
            toastEvent.fire();
            component.set("v.showSpinner", false);
        }
    },

    cancelEdit: function (component, event, helper) {
       helper.resetEditProperties(component, event, helper);
    },
})