import { LightningElement, api, wire, track } from 'lwc';
import { getObjectInfo, getPicklistValuesByRecordType, getPicklistValues} from 'lightning/uiObjectInfoApi';
import BATCH_OBJECT from '@salesforce/schema/Batch__c';
import SESSION_OMR_TYPE_OBJECT from '@salesforce/schema/Session_OMR_Type__c';
import OMR_RECEIEVED_BY_FIELD from '@salesforce/schema/Session_OMR_Type__c.OMR_Received_By__c';
import getBatch from '@salesforce/apex/OmrSubmissionController.fetchBatchRecords';
import fetchOmrRecords from '@salesforce/apex/OmrSubmissionController.fetchOmrRecords';
import saveRecords from '@salesforce/apex/OmrSubmissionController.saveRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from 'lightning/confirm';
import { CurrentPageReference, NavigationMixin } from 'lightning/navigation';



export default class OmrSubmissionFrom extends NavigationMixin(LightningElement) {
    @track selectedDistricts = 'Mumbai';
    selectedFacilitatorId = undefined;
    selectedSchoolId = null;
    facilitatorFilterCondition = 'Trainer_Name__c != null and Academic_Year__c = #year# and Trainer_Name__r.Academic_Year__c  = #year# ';//and School_District__c IN ${selectedDistricts}';
    @track schoolFilterCondition = 'School_Name__c != null AND Academic_Year__c = #year# and Trainer_Name__r.Academic_Year__c  = #year# ';//and School_District__c IN ' + JSON.stringify(this.selectedDistricts);
    @track BatchOptions;
    @track selectedGrade = '';
    @track selectedBatch = '';
    @track SelectedBatchId;
    // @track omrSubmissionNotes = '';
    @track showOmrData;
    @track auditRecords;
    @track rawOmrData;
    @track isLoading = false;
    @track omrRecievedByOptions;
    @api loginPageName;

    get maxDate() {
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        return tomorrow.toISOString().split('T')[0];
    }

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        this.isLoading = true;
        if (currentPageReference) {
            try {
                 if(currentPageReference.state){
                    this.selectedDistricts = atob(currentPageReference?.state?.dst);
                    var email = atob(currentPageReference?.state?.un);
                    var cookieString = "; " + document.cookie;
                    var parts = cookieString.split("; " + "OMRSubmissionFormLogin" + "=");
                    var antarangCookie = decodeURIComponent(parts.pop().split(";").shift());
                    if (antarangCookie != email || antarangCookie == '') {
                        this.navigateTo();
                    }else{
                        document.cookie =  "OMRSubmissionFormLogin=; ";
                    }
                }
                this.isLoading = false;
                
            } catch (err) {
                // const myTimeout = setTimeout((d) => {
                //     this.navigateTo();
                // }, 2000);
            }

            console.log(this.selectedDistricts);

        }
    }

    @wire(getObjectInfo, { objectApiName: BATCH_OBJECT })
    batchObjinfo;

    @wire(getObjectInfo, { objectApiName: SESSION_OMR_TYPE_OBJECT })
    omrObjinfo;

    @wire(getPicklistValuesByRecordType, { recordTypeId: '$batchObjinfo.data.defaultRecordTypeId', objectApiName: BATCH_OBJECT })
    wiredGrade({ error, data }) {
        if (data) {
            this.gradeOptions = data?.picklistFieldValues?.Grade__c?.values;
        } else if (error) {
            console.log(error);
        }
    }

    //@wire(getPicklistValuesByRecordType, { recordTypeId: '$omrObjinfo.data.defaultRecordTypeId', objectApiName: SESSION_OMR_TYPE_OBJECT })
    // @wire(getPicklistValues, { recordTypeId: '$omrObjinfo.data.defaultRecordTypeId', fieldApiName: OMR_RECEIEVED_BY_FIELD })
    // wiredOmrRecievedBy({ error, data }) {
    //     if (data) {
    //         this.omrRecievedByOptions = [];
    //         this.omrRecievedByOptions = [...data.values];
    //         this.omrRecievedByOptions.unshift({'label':'Select OMR Recieved By', 'value':''});
            
    //     } else if (error) {
    //         console.log(error);
    //     }
    // }


    renderedCallback() {
        if (!this.SelectedBatchId && this.SelectedBatchId != '') {
            this.showOmrData = null;
        }

        if(!this.showOmrData){
            this.auditRecords = undefined;
        }
    }

    handleLookup(event) {
        this.SelectedBatchId = undefined;
        this.selectedBatch = '';
        if (event.target.label == 'Facilitator Name') {
            this.selectedFacilitatorId = event.detail.selectedRecord ? event.detail.selectedRecord.Id : event.detail.selectedRecord;
            if (this.selectedFacilitatorId) {
                this.schoolFilterCondition += ' and Trainer_Name__c = \'' + this.selectedFacilitatorId + '\'';
            } else {
                this.selectedSchoolId = undefined;
                this.schoolFilterCondition = 'School_Name__c != null AND Academic_Year__c = #year# and Trainer_Name__r.Academic_Year__c  = #year# ';// and School_District__c = \'Mumbai\'';
            }
        }
        if (event.target.label == 'School') {
            this.selectedSchoolId = event.detail.selectedRecord ? event.detail.selectedRecord.Id : event.detail.selectedRecord;
        }
    }

    handleGradeChange(event) {
        this.isLoading = true;
        this.BatchOptions = undefined;
        this.selectedGrade = event.target.value;
        this.SelectedBatchId = undefined;
        this.selectedBatch = '';
        getBatch({ grade: this.selectedGrade, school: this.selectedSchoolId, facilitator: this.selectedFacilitatorId })
            .then((result) => {
                this.BatchOptions = result;
                if (result != null & result.length < 1) {
                    this.showToast('Error', 'No Batches Found.', 'error', '');
                }else if(result == null || result == undefined){
                    this.showToast('Error', 'No Batches Found.', 'error', '');
                }
                this.isLoading = false;
            }).catch((err) => {
                this.BatchOptions = undefined;
                //alert(err);
                this.showToast('Error', 'Error : ' + err, 'error', '');
                this.isLoading = false;
            });
    }

    handleBatchChange(event) {
        debugger;
        this.BatchOptions.forEach(element => {
            if(element && event.target.value == element.value){
                this.selectedBatch = element.label;
            }
        });
        
        this.SelectedBatchId = event.target.value;
        this.showOmrData = undefined;
        this.rawOmrData = undefined;

        this.handleOmrSubmission(event);
    }

    handleOmrSubmission(event) {
        this.isLoading = true;
        fetchOmrRecords({ batchId: this.SelectedBatchId })
            .then((response) => {

                var result = response.OmrRecords;
                this.omrRecievedByOptions = response.omrReceivedByOptions;
                if (!result || (result && result.length < 1) ){
                    this.showToast('Error', 'OMR Records are not available for this Batch.', 'error', '');
                    this.rawOmrData = undefined;
                    this.showOmrData = undefined;
                    this.isLoading = false;
                    return;
                }
                this.rawOmrData = result && result.length > 0 ? result : undefined;
                this.showOmrData = [...this.rawOmrData];


                this.showOmrData.forEach(element => {
                    element['reqired'] = false;
                    element['isUpdated'] = false;
                    if ((element.OMRs_Received_Count__c && element.OMRs_Received_Count__c != '') ||
                        (element.OMR_Received_By__c && element.OMR_Received_By__c != '') ||
                        (element.OMR_Received_Date__c && element.OMR_Received_Date__c != '') ||
                        (element.OMR_Submission_Notes__c && element.OMR_Submission_Notes__c != '')) {
                        element['reqired'] = true;
                    }
                });

                if (result && result.length < 1) {
                    this.showToast('Info', 'No Records found.', 'info', '');
                }
                this.isLoading = false;

            }).catch((err) => {
                this.isLoading = false;
                //alert(err);
                this.showToast('Error', 'Error : ' + err, 'error', '');
            });
    }

    handleSelectedRowChange(event) {
        this.isLoading = true;
        /* Commented the below code, now we are storing OMR_Submission_Notes in Session OMR Type Record only, now this value can be different for each type record.
        if (event.target.name == 'OMR_Submission_Notes__c') {
            this.showOmrData.forEach(element => {
                this.omrSubmissionNotes = event.target.value;
                element.Session__r.Batch__r.OMR_Submission_Notes__c = event.target.value;
            });
        } else {
            this.showOmrData[event.target.dataset.index][event.target.dataset.id] = event.target.value;
            if ((this.showOmrData[event.target.dataset.index].OMRs_Received_Count__c && this.showOmrData[event.target.dataset.index].OMRs_Received_Count__c != '') ||
                (this.showOmrData[event.target.dataset.index].OMR_Received_By__c && this.showOmrData[event.target.dataset.index].OMR_Received_By__c != '') ||
                (this.showOmrData[event.target.dataset.index].OMR_Received_Date__c && this.showOmrData[event.target.dataset.index].OMR_Received_Date__c != '')) {
                this.showOmrData[event.target.dataset.index]['reqired'] = true;
            } else {
                this.showOmrData[event.target.dataset.index]['reqired'] = false;
            }
        }
        */
        
        this.showOmrData[event.target.dataset.index][event.target.dataset.id] = event.target.value;
        if ((this.showOmrData[event.target.dataset.index].OMRs_Received_Count__c && this.showOmrData[event.target.dataset.index].OMRs_Received_Count__c != '') ||
            (this.showOmrData[event.target.dataset.index].OMR_Received_By__c && this.showOmrData[event.target.dataset.index].OMR_Received_By__c != '') ||
            (this.showOmrData[event.target.dataset.index].OMR_Received_Date__c && this.showOmrData[event.target.dataset.index].OMR_Received_Date__c != '') ||
            (this.showOmrData[event.target.dataset.index].OMR_Submission_Notes__c && this.showOmrData[event.target.dataset.index].OMR_Submission_Notes__c != '')) {
            this.showOmrData[event.target.dataset.index]['reqired'] = true;
        } else {
            this.showOmrData[event.target.dataset.index]['reqired'] = false;
        }

        this.showOmrData[event.target.dataset.index].isUpdated = true;

        this.isLoading = false;
    }

    handleSelectedRowValidity(event){
        if(!event.target.value || event.target.value.trim() == ''){
            // Get the data-index value from the changed element
            const dataIndex = event.target.dataset.index;

            // Select all elements with the same data-index value
            const elementsToValidate = [
                ...this.template.querySelectorAll(`lightning-input[data-index="${dataIndex}"]`), ...this.template.querySelectorAll(`lightning-combobox[data-index="${dataIndex}"]`)
            ];

            // Reduce the elements to check validity
            const allValid = elementsToValidate.reduce((validSoFar, inputCmp) => {
                inputCmp.reportValidity();
                if (validSoFar && inputCmp.checkValidity()) {
                    inputCmp.setCustomValidity('');
                }
                return validSoFar && inputCmp.checkValidity();
            }, true);
        }
    }

    async handleSubmitOmrForm(event) {
        this.isLoading = true;
        const allValid = await [
            ...this.template.querySelectorAll('lightning-input'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            if (validSoFar && inputCmp.checkValidity()) {
                inputCmp.setCustomValidity('');
            }
            return validSoFar && inputCmp.checkValidity();
        }, true);

        const allValid1 = await [
            ...this.template.querySelectorAll('lightning-combobox'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            if (validSoFar && inputCmp.checkValidity()) {
                inputCmp.setCustomValidity('');
            }
            return validSoFar && inputCmp.checkValidity();
        }, true);

        if (allValid && allValid1) {

            const result = await LightningConfirm.open({
                message: 'Are you sure you want to save?',
                variant: 'header',
                label: 'Confirmation',
                // setting theme would have no effect
            });

            if (result) {
                await this.submitForm();

            } else {
                this.isLoading = false;
            }

        } else {
            //alert('Please update the invalid form entries and try again.');
            this.showToast('Error', 'Please update the invalid form entries and try again.', 'error', '');
            this.isLoading = false;
        }
    }

    submitForm(event) {
        this.auditRecords = this.showOmrData.filter(record => record.isUpdated === true);
        // updated this.showOmrData to this.auditRecords
        // Removed these parameters ', batchId: this.SelectedBatchId, omrSubmissionNotes : this.omrSubmissionNotes' 
        saveRecords({ records: this.auditRecords})
            .then((result) => {
                this.showToast('Success', 'Updated OMR Types', 'success', '');
                this.isLoading = false;
                this.handleOmrSubmission(event);
            }).catch((err) => {
                this.showToast('Error', ' Error :' + err, 'error', 'sticky');
                this.isLoading = false;
            });
    }

    showToast(title, message, variant, mode) {
        const event = new ShowToastEvent({
            title: title && title != '' ? title : 'title',
            message: message && message != '' ? message : '',
            variant: variant && variant != '' ? variant : 'info',
            mode: mode && mode != '' ? mode : 'dismissible'
        });
        this.dispatchEvent(event);
    }

    signOut(event) {
        let name = 'OMRSubmissionFormLogin';
        let value = '';
        let days = null;
        var expires;
        if (days) {
            const date = new Date();
            date.setTime(date.getTime() + (1 * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = name + "=" + value + "; ";
        this.showToast('Success', 'Sign out successfully', 'success', '');
        this.navigateTo();
    }

    navigateTo() {
        // Navigate to the Account home page
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: this.loginPageName
            }
        });
    }


}