import { LightningElement, wire, track } from 'lwc';
//import GRADE_FIELD from '@salesforce/schema/Batch__c.Grade__c';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import BATCH_OBJECT from '@salesforce/schema/Batch__c';
import getSessionsList from '@salesforce/apex/PayoutProcessController.getSessions';
import updateSessions from '@salesforce/apex/PayoutProcessController.updateSessions';  
import getFacilitator from '@salesforce/apex/PayoutProcessController.getFacilitator';
import sendInvoiceMailToFacilitator from '@salesforce/apex/PayoutProcessController.generateInvoiceAndSendEmail'; 
import sendInvoiceToFacilitator from '@salesforce/apex/PayoutProcessController.sendInvoiceToFacilitator'; 
import sendInvoiceMailToFinance from '@salesforce/apex/PayoutProcessController.sendInvoicetoFinance';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from 'lightning/confirm';
import getDistrict from '@salesforce/apex/GenerateInvoiceFormController.getDistrict';
import getPicklistValues from '@salesforce/apex/PayoutProcessController.getPicklistValues';

import { NavigationMixin } from 'lightning/navigation';




export default class StudentOMRManager extends NavigationMixin(LightningElement) {
    whereClause = "Trainer_Name__r.RecordType.DeveloperName = 'CA_Trainer' AND Trainer_Name__c != null and (Academic_Year__c = #year# OR Academic_Year__c = #newYear#) AND Trainer_Name__r.Payment_Type__c='Session'";
    selectedFacilitatorId = '';
    districtOptions = [];
    selectedDistrict='';
    selectedDistrictValue='';
    @track isLoading = false;
    invoiceDate;
    @track selectedFacilitator = '';
    @track selectedDonor = '';
    @track selectedSchool = '';
    @track batch1 = '';
    grade = '';
    @track facilitatorEmail;

    @track sessionData = [];
    @track gradeOptions;
    @track showSpinner;
    renderTable = false;
    paymentStatus='';
    PaymentStatusOptions = [{label: 'Ready For Payment', value: 'Ready For Payment'},
                                    {label: 'Deferred for Payment', value: 'Deferred for Payment'}];
    userSelectionOptions = [{label: 'Generate Consultancy Bill & send email', value: 'Generate Consultancy Bill & send email'},
                                {label: 'Send Consultancy Bill to Facilitator', value: 'Send Consultancy Bill to Facilitator'},
                                {label: 'Send Consultancy Bill Data to Finance', value: 'Send Consultancy Bill Data to Finance'}];



    deferredReason='';
    @track DeferredReasonOptions = [];
    @track DummyDeferredReasonOptions = [{label: 'Parent/Main batch attendance is lower than40', value: 'Parent/Main batch attendance is lower than40'}];
    generateInvoice_SendEmail = false;
    isSendInvoToFacilitator=false;
    isSendInvoToFinance = false;
    isSessionDataExist = false;
    saveAndSubmitFlag = false;

    
    connectedCallback(){
        
    }
    // Phase 2 updation
    handleLookup(event) {
        this.selectedFacilitatorId = event.detail.selectedRecord ? event.detail.selectedRecord.Id : event.detail.selectedRecord;
        /*this.SelectedBatchId = undefined;
        this.selectedBatch = '';
        if (event.target.label == 'Facilitator Name') {
            this.selectedFacilitatorId = event.detail.selectedRecord ? event.detail.selectedRecord.Id : event.detail.selectedRecord;
            if (this.selectedFacilitatorId) {
                this.schoolFilterCondition += ' and Trainer_Name__c = \'' + this.selectedFacilitatorId + '\'';
            } else {
                this.selectedSchoolId = undefined;
                this.schoolFilterCondition = 'School_Name__c != null AND Academic_Year__c = #year# and Trainer_Name__r.Academic_Year__c  = #year# and School_District__c = \'Mumbai\'';
            }
        }
        if (event.target.label == 'School') {
            this.selectedSchoolId = event.detail.selectedRecord ? event.detail.selectedRecord.Id : event.detail.selectedRecord;
        }*/
    }
    getPicklist(){
       // this.isLoading = true;
        getPicklistValues().then(result => {
            console.log('getpicklist Result = '+result);
           // this.isLoading = false;    
           this.gradeOptions = result.map(value => ({ label: value, value }));
           console.log(' this.picklistValues = '+ this.gradeOptions)
        }).catch(error => {
            //this.isLoading = false;  
            console.log('getDistrictOptions Error = ',error);
            //this.showToast('error',error.body.message);   
        });
        
    }
    get checkForDistrict(){
        console.log('this.selectedDistrict = ',this.selectedDistrict);
        if(this.selectedDistrict == '' || this.selectedDistrict == null) return false; else return true;
    }
    handleDistrictChange(event){
        console.log('event.target.label = ',event.target.label);
        //this.selectedDistrict = event.target.value;
        let dist = this.districtOptions.find(data => data.value === event.target.value);
        console.log('this.selectedDistrict 1 =',this.selectedDistrict)
        this.selectedDistrictValue = event.target.value;
        this.selectedDistrict = dist.label;
    }
    getDistrictOptions(){
        getDistrict().then(result => {
            //console.log('getDistrictOptions Result = ',result);
            //this.isLoading = false;
            this.districtOptions = result.map(function(district){
                return ({
                    value:district.Id,
                    label:district.Name
                })
            }); 
        }).catch(error => {
            //this.isLoading = false;  
            console.log('getDistrictOptions Error = ',error);
            //this.showToast('error',error.body.message);   
        });
    }
    //end
    @wire( getObjectInfo, { objectApiName: BATCH_OBJECT  } )
    objectInfo;

    @wire( getPicklistValues, { recordTypeId:  '$objectInfo.data.defaultRecordTypeId'/*, fieldApiName: GRADE_FIELD */} )
    wiredData( { error, data } ) {
        if ( data ) {
            var gData = [{
                label: '-- None --',
                value: ''
            }];
            data.values.forEach(g => {
                gData.push({label: g.label, value: g.value});
            });
            this.gradeOptions = gData;
        } else if ( error ) {
            console.error( JSON.stringify( error ) );
        }
    }


    handleDate(event){
        this.invoiceDate = event.target.value;
        console.log('***this.invoiceDate:',this.invoiceDate);
    }
    handlefacilitatorEmail(event){
        //alert(event.target.value);
        this.facilitatorEmail = event.target.value;
    }

    handleEmailChange(event){
        this.facilitatorEmail = event.target.value;
    }
    handleFacilitator(event){
        this.selectedFacilitator = '';
        var facilitator = event.detail.selectedRecord;
        if(facilitator){
            this.selectedFacilitator = facilitator.Id;
        } else {
            this.selectedFacilitator = '';
            this.facilitatorEmail = null;
        }

        getFacilitator({ contactId:this.selectedFacilitator})
        .then(result =>{
            this.facilitatorEmail = result.npe01__WorkEmail__c;
        })
        .catch(error =>{
            console.log('error : ',error);
        });

       // alert(this.selectedFacilitator);
    }
    handleDonor(event){
        this.selectedDonor = '';
        var donor = event.detail.selectedRecord;
        if(donor){
            this.selectedDonor = donor.Id;
        } else {
            this.selectedDonor = '';
        }
    }
    handleSchool(event){
        this.selectedSchool = '';
        var school = event.detail.selectedRecord;
        if(school){
            this.selectedSchool = school.Id;
        } else {
            this.selectedSchool = '';
        }
       // alert( this.selectedSchool);
    }
    handleBatch(event){
        this.batch1= ''; // = event.target.value;
        var btch = event.detail.selectedRecord;
        if(btch){
            this.batch1 = btch.Id;
        } else {
            this.batch1 = '';
        }
    }
    handleGrade(event){
        this.grade = event.target.value;
    }
    handlePaymentStatus(event){
        this.paymentStatus = event.target.value;
    }
    handleDeferredReason(event){
        var data = JSON.parse(JSON.stringify(this.sessionData));
        data[event.target.dataset.index]["DeferredReason"] = event.target.value;
        this.sessionData = data;
        //this.deferredReason = event.target.value;
    }


    getSessions(){
        this.isLoading = true;
        console.log('selectedFacilitatorId =',this.selectedFacilitatorId)
        console.log('selectedDonor = ',this.selectedDonor)
        console.log('selectedSchool = ',this.selectedSchool)
        console.log('this.batch1 =',this.batch1)
        console.log('this.grade =',this.grade)
        console.log(this.selectedDistrictValue)
        getSessionsList({ invoiceDate:this.invoiceDate, Facilitator:this.selectedFacilitatorId, DonorId:this.selectedDonor, SchoolId:this.selectedSchool, BatchId:this.batch1, Grade:this.grade, district : this.selectedDistrictValue})
        .then(result =>{
         console.log('test : ',JSON.stringify(result));
            this.sessionData = result.sessionData;
            this.DeferredReasonOptions = result.deferredReason;
           
            if(this.sessionData.length > 0){
             this.isSessionDataExist = true;
            } else {
             this.isSessionDataExist = false;
            }
            this.renderTable = true;
            this.showSpinner = false;
            this.isLoading = false;

        })
        .catch(error =>{
         console.log('error : ',error);
            this.errorMsg = error;
            this.isLoading = false;
        });
    }

    handleSubmit(evt) {
        this.showSpinner = true;
        console.log('Current value of the input: ' + evt.target.value);

        const allValid = [
            ...this.template.querySelectorAll('lightning-input'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if (allValid) {
            this.getSessions();
           
        } else {
            this.showSpinner = false;
        }

    }



    handleUserSeleOpt(event){
        this.isSessionDataExist = false;

        if(event.target.value == 'Send Consultancy Bill to Facilitator'){
            this.generateInvoice_SendEmail = false;
            this.isSendInvoToFacilitator = true;
            this.isSendInvoToFinance = false;
           
        } else if(event.target.value == 'Send Consultancy Bill Data to Finance'){
            this.generateInvoice_SendEmail = false;
            this.isSendInvoToFacilitator = false;
            this.isSendInvoToFinance = true;
        }else if(event.target.value == 'Generate Consultancy Bill & send email'){
            this.generateInvoice_SendEmail = true;
            this.isSendInvoToFacilitator = false;
            this.isSendInvoToFinance = false;
             this.getDistrictOptions();
             this.getPicklist();
        }
    }

    handleSendInvoToFinance(event){
        this.isLoading = true;
        sendInvoiceMailToFinance({ 
            invoiceDate : this.invoiceDate 
        })
        .then(res => {
            this.isLoading = false;
            const event = new ShowToastEvent({
                variant: 'success',
                title: 'Success!',
                message: 'Succesfully Consultancy Bill Email sent to Finance !',
            });
            this.dispatchEvent(event);
            window.location.reload();
        })
        .catch(error => {
            this.isLoading = false;
            console.log(error);
        })
        .finally(() => {

        })
    }

    handleSelectedRowChange(event){
        var dt = this.sessionData;
        var data = JSON.parse(JSON.stringify(this.sessionData));
        
        console.log('event.target.checked ',event.target.checked);

        if(data[event.target.name]['DummySessionAvailable']){
            data[event.target.name][event.target.dataset.id] = event.target.checked;
            data.forEach(g => {
                console.log('g : ',g);
                if(data[event.target.name]['SessionCode'] && g.SessionCode && g.ParentSessionCode == data[event.target.name]['SessionCode']){
                    g.Checkbox = event.target.checked;
                    //g.DeferredReason = '';
                    

                    if(event.target.checked == true){
                        g.DeferredReason = '';
                        g.showError = false;
                        data[event.target.name]['showError'] = false;
                        data[event.target.name]['DeferredReason'] = '';
                    }
                    console.log('g 52125: '+g);
                }
            })
            this.sessionData = data;
            //this.sessionData = [...dt];
            console.log('test : ',this.sessionData);
        }
        
        if(data[event.target.name]['DummySession']){
            if(event.target.checked == false){
                data[event.target.name]['DeferredReason'] = 'Parent/Main batch attendance is lower than40';
                data[event.target.name]['paymentStatus'] = 'Do not pay';
            }else{
                data[event.target.name]['DeferredReason'] = '';
            }
        }


        if(!data[event.target.name]['DummySessionAvailable']){
            data[event.target.name][event.target.dataset.id] = event.target.checked;
        }

        if(event.target.checked == true){
            data[event.target.name]['showError'] = false;
        }

        

        this.sessionData = data;
        
        console.log('test : ',this.sessionData);
    
    }

    async handleSaveSessionChanges(event){

        //this.isLoading = true;
        var sessionUpdateMap =[];
        var uncheckedCount = 0;
        var checkedCount = 0;
        var count = 0;
        var validatedCount = 0;
        var dt = this.sessionData;
        dt.forEach(g => {
            //if(!g.DummySession){
            count += 1;
            if(g.Checkbox){
                checkedCount += 1;
            }
            if(!g.Checkbox){
                uncheckedCount += 1;
            }
            if(!g.Checkbox && (g.DeferredReason == null || g.DeferredReason == '')){
                
                    g.showError = true;
                
                
                if(this.saveAndSubmitFlag){
                    return 'error';
                }
            }
             if(!g.Checkbox && g.DeferredReason != null && g.DeferredReason != '' ){
                sessionUpdateMap.push(g);
                validatedCount += 1;
                g.showError = false;
            }
            /*if(g.Checkbox){
                const event = new ShowToastEvent({
                    variant: 'error',
                    title: 'ERROR !',
                    message: 'No Records update!',
                });
                this.dispatchEvent(event);
                g.showError = false;
            }*/
        //}
        })

        if(checkedCount == count){
            const event = new ShowToastEvent({
                variant: 'error',
                title: 'Error!',
                message: 'No records to update',
            });
            this.dispatchEvent(event);
        }

        this.sessionData = dt;

        console.log('uncheckedCount ',uncheckedCount);
        console.log('sessionUpdateMap.length ',sessionUpdateMap.length);
        console.log('validatedCount ',validatedCount);
        
        if(uncheckedCount == validatedCount && sessionUpdateMap.length > 0 && sessionUpdateMap.length == uncheckedCount ){
           // this.showSpinner = true;
            updateSessions({ wrapList : sessionUpdateMap})
            .then(result => {
                debugger
                this.contacts = result;
                console.log('result = ',result)
                if(result == 'SUCCESS'){
                    const event = new ShowToastEvent({
                        variant: 'success',
                        title: 'Success!',
                        message: 'Records succesfull updated!',
                    });

                    this.dispatchEvent(event);
                    
                    this.getSessions();
                    
                    //this.showSpinner = false; 
                }else if(result == 'NO RECORDS TO UPDATE'){
                    const event = new ShowToastEvent({
                        variant: 'warning',
                        title: 'Get Help',
                        message: 'No records to update',
                    });
                    this.dispatchEvent(event);
                }else{
                    const event = new ShowToastEvent({
                        variant: 'error',
                        title: 'Error!',
                        message: result,
                    });
                    this.dispatchEvent(event);
                }
            })
            .catch(error => {
                this.error = error;
            });            
           
        }     
       // this.showSpinner = false;
        

    }

    async handleSubmitSessionChanges(event){
        
        //this.isSessionDataExist = false;

        this.isLoading = true;

        var sessionUpdateMap =[];
        var uncheckedCount = 0;
        var checkedCount = 0;
        var count = 0;
        var validatedCount = 0;
        var dt = this.sessionData;
        dt.forEach(g => {
            //if(!g.DummySession){
            count += 1;
            if(g.Checkbox){
                checkedCount += 1;
            }
            if(!g.Checkbox){
                uncheckedCount += 1;
            }
            if(!g.Checkbox && (g.DeferredReason == null || g.DeferredReason == '')){
                
                //if(!g.DummySession){
                    g.showError = true;
                    this.saveAndSubmitFlag = false;
                    this.isLoading = false;
                    return 'error';
                //}
            }
             if(!g.Checkbox && g.DeferredReason != null && g.DeferredReason != '' ){
                sessionUpdateMap.push(g);
                validatedCount += 1;
                g.showError = false;
            }
            /*if(g.Checkbox){
                const event = new ShowToastEvent({
                    variant: 'error',
                    title: 'ERROR !',
                    message: 'No Records update!',
                });
                this.dispatchEvent(event);
                g.showError = false;
            }*/
        //}
        })
        this.sessionData = dt;

        console.log('uncheckedCount ',uncheckedCount);
        console.log('sessionUpdateMap.length ',sessionUpdateMap.length);
        console.log('validatedCount ',validatedCount);
        debugger
        if(uncheckedCount == validatedCount && sessionUpdateMap.length > 0 && sessionUpdateMap.length == uncheckedCount ){
           // this.showSpinner = true;
           await updateSessions({ wrapList : sessionUpdateMap})
            .then(result => {
                this.contacts = result;
                if(result == 'SUCCESS'){
                    const event = new ShowToastEvent({
                        variant: 'success',
                        title: 'Success!',
                        message: 'Records succesfull updated!',
                    });

                    this.dispatchEvent(event);
                    //this.getSessions();
                    this.saveAndSubmitFlag = true;
                    
                    //this.showSpinner = false; 
                }else if(result == 'NO RECORDS TO UPDATE'){
                    const event = new ShowToastEvent({
                        variant: 'warning',
                        title: 'Get Help',
                        message: 'No records to update',
                    });
                    this.dispatchEvent(event);
                    this.isLoading = false;
                }else{
                    const event = new ShowToastEvent({
                        variant: 'error',
                        title: 'Error!',
                        message: result,
                    });
                    this.isLoading = false;
                    this.dispatchEvent(event);
                }
            })
            .catch(error => {
                this.isLoading = false;
                this.error = error;
            });            
           
        }

        if(checkedCount == count){
            this.submitSessionsForEmailGeneration(event);
        }
         if(this.saveAndSubmitFlag){
            this.submitSessionsForEmailGeneration(event);
        }
    }

    submitSessionsForEmailGeneration(event){
        debugger
            //console.log('eee');
            //exit;
                var sessionUpdateMap = this.sessionData;
                this.isLoading = true;

                sendInvoiceMailToFacilitator({ wrapList : sessionUpdateMap, invoiceDate : this.invoiceDate, district:this.selectedDistrictValue})
                .then(result => {
                    this.contacts = result;
                    console.log('result = ',result)
                    if(result == 'SUCCESS'){
                        const event = new ShowToastEvent({
                            variant: 'success',
                            title: 'Success!',
                            message: 'Succesfully Consultancy Bill Email sent to Facilitator !',
                        });
                        this.dispatchEvent(event);
                        window.location.reload();
                    }else if(result.startsWith('INFO :')){
                        const event = new ShowToastEvent({
                            variant: 'info',
                            title: 'Error!',
                            message: result.replace("INFO :", ""),
                        });
                        this.dispatchEvent(event);
                        this.isLoading = false;
                    }
                })
                .catch(error => {
                    //this.error = error;
                    console.log('error submitSessionsForEmailGeneration = ',JSON.stringify(error));
                    this.isLoading = false;
                    const event = new ShowToastEvent({
                        variant: 'error',
                        title: 'Error!',
                        message: error,
                    });
                    this.dispatchEvent(event);
                    this.showSpinner = false; 

                }); 
    }
    handleInvoiceToFacilitator(){
        const allValid = [
            ...this.template.querySelectorAll('lightning-input'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            return validSoFar && inputCmp.checkValidity();
        }, true);
        if (allValid) {
            this.handleConfirmClick();
        }
    }

    async handleConfirmClick() {
        const result = await LightningConfirm.open({
            message: 'Are you sure you want to send Consultancy bills dated '+ this.invoiceDate+ ' to '+this.facilitatorEmail,
            variant: 'header',
            label: 'Please confirm the below details :',
        });
        if (result) {
            this.isLoading = true;
            sendInvoiceToFacilitator({ invoiceDate : this.invoiceDate, facilitatorEmail : this.facilitatorEmail})
            .then(result => {
                this.contacts = result;
                if(result == 'SUCCESS'){
                    this.isLoading = false;
                    const event = new ShowToastEvent({
                        variant: 'success',
                        title: 'Success!',
                        message: 'Succesfully Consultancy Bill Email sent to Facilitator !',
                    });
                    this.dispatchEvent(event);
                    
                    window.location.reload();
                }else{
                    this.isLoading = false;
                    const event = new ShowToastEvent({
                        variant: 'error',
                        title: 'Error!',
                        message: result,
                    });
                    this.dispatchEvent(event);
                }
            })
            .catch(error => {
                this.isLoading = false;
                console.log(error);
            }); 

        } else {
            //do something else 
        }
    }
}