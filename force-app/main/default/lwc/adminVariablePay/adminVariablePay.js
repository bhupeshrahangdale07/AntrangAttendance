import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
//import GRADE_FIELD from '@salesforce/schema/Batch__c.grade__c';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import BATCH_OBJECT from '@salesforce/schema/Batch__c';
import getSessionsList from '@salesforce/apex/VariablePayController.getSessions';
import getPicklistValues from '@salesforce/apex/VariablePayController.getPicklistValues';
import saveSessions from '@salesforce/apex/VariablePayController.saveSessions';  
//import sendInvoiceMailToFacilitator from '@salesforce/apex/VariablePayController.generateInvoiceAndSendEmail'; 
// import getFacilitator from '@salesforce/apex/PayoutProcessController.getFacilitator';
// import sendInvoiceToFacilitator from '@salesforce/apex/PayoutProcessController.sendInvoiceToFacilitator'; 
// import sendInvoiceMailToFinance from '@salesforce/apex/PayoutProcessController.sendInvoicetoFinance';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from 'lightning/confirm';

import { NavigationMixin } from 'lightning/navigation';




export default class StudentOMRManager extends NavigationMixin(LightningElement) {
    @track editRejectedMode = false;
    @track editMode = false;
    @track isLoading = false;
    invoiceDate;
    @track selectedFacilitator = '';
    @track selectedDonor = '';
    @track selectedSchool = '';
    @track batch1 = '';
    grade = '';
    @track facilitatorEmail;
    @track sessionData ;
    @track gradeOptions;
    @track showSpinner = false;
    renderTable = false;
    @track action = '';
    paymentStatus='';
    checkSaveOrSubmit ;
    getCheckboxDisabled;
    hideCheckbox ;
    showTable;
    maxDate;
    hideStatus = true;
    fem;
    PaymentStatusOptions = [{label: 'Ready For Payment', value: 'Ready For Payment'},
                                    {label: 'Deferred for Payment', value: 'Deferred for Payment'}];
    // userSelectionOptions = [{label: 'Generate Consultancy Bill & send email', value: 'Generate Consultancy Bill & send email'},
    //                             {label: 'Send Consultancy Bill to Facilitator', value: 'Send Consultancy Bill to Facilitator'},
    //                             {label: 'Send Consultancy Bill Data to Finance', value: 'Send Consultancy Bill Data to Finance'}];



    deferredReason='';
    @track DeferredReasonOptions = [];
    @track DummyDeferredReasonOptions = [{label: 'Parent/Main batch attendance is lower than40', value: 'Parent/Main batch attendance is lower than40'}];
    generateInvoice_SendEmail = false;
    isSendInvoToFacilitator=false;
    isSendInvoToFinance = false;
    isSessionDataExist = false ;
    saveAndSubmitFlag = false;

    formatDate(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    connectedCallback(){
        const currentDate = new Date();
        const year = currentDate.getFullYear();
        const month = String(currentDate.getMonth() + 1).padStart(2, '0');
        //console.log('fff');
        const lastDayOfMonth = new Date(year, month, 0);
        //console.log(this.formatDate(lastDayOfMonth));
        this.maxDate = this.formatDate(lastDayOfMonth);
         this.getPicklist();
        console.log('Data===='+this.sessionData);
    }
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        console.log('Enter');
        if (currentPageReference) {
            this.fem = decodeURI(currentPageReference.state.fem);
            console.log(this.prf);
        }
    }

    @wire( getObjectInfo, { objectApiName: 'Batch__c'  } )
    objectInfo;

   getPicklist(){
        this.isLoading = true;
        getPicklistValues().then(result => {
            console.log('getpicklist Result = '+result);
            this.isLoading = false;    
           this.gradeOptions = result.map(value => ({ label: value, value }));
           console.log(' this.picklistValues = '+ this.gradeOptions)
        }).catch(error => {
            this.isLoading = false;  
            console.log('getDistrictOptions Error = ',error);
            this.showToast('error',error.body.message);   
        });
        
    }
    handleDate(event){
        this.invoiceDate = event.target.value;
    }
    handlefacilitatorEmail(event){
        //alert(event.target.value);
        this.facilitatorEmail = event.target.value;
    }

    handleEmailChange(event){
        this.facilitatorEmail = event.target.value;
    }
    handleFacilitator(event){
        console.log('In Facilator');
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
        console.log('DeferredReason-',this.sessionData[event.target.dataset.index]);
        //this.deferredReason = event.target.value;
    }
     get getSaveBtn(){
        return this.editMode|| this.editRejectedMode;
    }
    get hideNShow(){
        if(this.hideCheckbox || this.isSessionDataExist){
            return false;
        }else return true;
    }
    getSessions(){
        //this.showSpinner = true;
        getSessionsList({ invoiceDate:this.invoiceDate, Facilitator:this.selectedFacilitator, DonorId:this.selectedDonor, SchoolId:this.selectedSchool, BatchId:this.batch1, Grade:this.grade})
        .then(result =>{
         console.log('test : ',JSON.stringify(result));
            this.sessionData = result.sessionData;
            this.DeferredReasonOptions = result.deferredReason;
            console.log('this.sessionData  = ',this.sessionData )
            this.editRejectedMode =  this.editMode = false;
            let havingThatRec = this.sessionData.filter(r=>r.ProposalDate == this.invoiceDate);
            let statusIsNull = this.sessionData.filter(r=>r.Status == '' || r.Status == undefined);
            let rejectedRecord = this.sessionData.filter(r=>r.Status == 'Proposal Rejected');
            //let invGeneratedRecord = this.sessionData.filter(r=>r.Status == 'Invoice Generated');
            let savedRecord = this.sessionData.filter(r=>r.Status == 'Proposal Saved');
            console.log('getMonth = ',new Date(this.invoiceDate).getMonth())
            if(havingThatRec.length == 0){
                for (let i = this.sessionData.length - 1; i >= 0; i--) {
                    const item = this.sessionData[i];
                    console.log('item.ProposalDate = ',item.ProposalDate)
                    console.log('item.deferredReason = ',item.deferredReason)
                    if ((item.ProposalDate !== undefined || item.ProposalDate != '') && item.ProposalDate !== this.invoiceDate && item.DeferredReason == 'Not to be paid' && (new Date(this.invoiceDate).getMonth()) != (new Date(item.SessionDate).getMonth()) ) {
                        this.sessionData.splice(i, 1);
                    }
                }
                // const newArray = this.sessionData.filter(item => {
                //     return item.ProposalDate !== undefined && item.ProposalDate !== this.invoiceDate;
                // });
                // this.sessionData = newArray;
            }
        
            
            if(statusIsNull.length > 0 || savedRecord.length > 0 || havingThatRec.length == 0){
                this.editMode = true;
                if(savedRecord.length == 0 || statusIsNull.length >0){
                    this.sessionData.forEach((args,i)=>{
                            args.Checkbox = true;
                    });
                }
                if(savedRecord.length > 0) this.hideStatus = false; else this.hideStatus = true;
                if(havingThatRec.length != 0) this.editMode = true;
                if(statusIsNull.length >0) this.hideStatus = true;
            }else if(rejectedRecord.length > 0) {
                this.editMode = true;
                this.editRejectedMode = true;
                this.hideStatus = false;
            }
            // else if(havingThatRec.length == 0){
            //     this.sessionData = this.sessionData.filter(r=>r.deferredReason == 'Not to be paid');
            //     this.editMode = true;
            //     this.hideStatus = true;
            // }
            else{
                this.editMode  = false;
                this.hideStatus = false;
            }

            // let proposalSaveRecord = this.sessionData.filter(r=>r.Status == 'Proposal Saved');
            // let proposalSubmitRecord = this.sessionData.filter(r=>r.Status == 'Proposal Submitted');
            // let proposalrejectedRecord = this.sessionData.filter(r=>r.Status == 'Proposal Rejected');
            // let proposalgeneratedRecord = this.sessionData.filter(r=>r.Status == 'Invoice Generated');
            // console.log('proposalgeneratedRecord = ',proposalgeneratedRecord); 
            // if(proposalSaveRecord.length > 0) {
            //     this.hideStatus = false;
            //      this.hideCheckbox = true;
            // }else if(proposalSubmitRecord.length > 0) {
            //     this.hideCheckbox = false;
            //     this.hideStatus = false;
            // }
            // else if(proposalgeneratedRecord.length != 0){
            //     this.hideCheckbox = false;
            //     this.hideStatus = false;

            // }
            // else{
            //     //editable data (new data)
            //     this.sessionData = this.sessionData.filter(r=>r.DeferredReason != 'Not to be paid' && r.ProposalDate == this.invoiceDate );
            //     this.hideCheckbox = true;
            //     if(proposalrejectedRecord.length == 0){
            //         this.sessionData.forEach((arg)=>{
            //         arg.Checkbox = true;
            //             //arg.PreviousAmountPaid = arg.AmountPaid;
                        
            //         });
            //         this.hideStatus = true;
            //      }else{
            //          this.hideStatus = false;
            //      }
                
            // }
            // console.log('hideCheckbox = ',this.hideCheckbox)
            if(this.sessionData.length > 0){
             this.showTable = true;
             this.isSessionDataExist = false;
            } else {
             this.isSessionDataExist = true;
              const event = new ShowToastEvent({
                        variant: 'error',
                        title: 'Sorry!',
                        message: 'Sorry No Data Found !',
                    });
            this.dispatchEvent(event);

            }
            // this.sessionData.forEach((arg)=>{
            //     if(arg.Checkbox == true)
            //     arg.ReasonStatus = false;
            //     else arg.ReasonStatus = true;
            // });
            //this.renderTable = true;
            this.showSpinner = false;
            console.log('this.sessionData  = ',this.sessionData )
            //this.isLoading = false;

        })
        .catch(error =>{
         console.log('error : ',error);
            this.errorMsg = error;
            this.showSpinner = false;
            const event = new ShowToastEvent({
                        variant: 'error',
                        title: 'Error!',
                        message: error.body.message,
                    });
            this.dispatchEvent(event);
        });
    }

    handleSubmit(evt) {
        const invoiceDate1 = new Date(this.invoiceDate);
        console.log(this.invoiceDate)
        if(this.invoiceDate == null || this.invoiceDate == '' || this.invoiceDate === undefined){
            this.showToast('error','Please fill required fields (*)');
        }else if(this.maxDate < this.formatDate(invoiceDate1)){
            this.showToast('error','please select current month invoice');
            this.showFacilatorData = false; 
        }else{
            this.showSpinner = true;
            this.getSessions();
        }
    }


    handleSelectedRowChange(event){
        this.sessionData[event.target.dataset.index]['Checkbox'] = event.target.checked;
        console.log(this.sessionData[event.target.dataset.index]);
    }

    async handleSaveSessionChanges(event){
        this.action = 'save';
        this.saveSessionFunc();
    }
    saveSessionFunc(){
        let status = true;
        for(var i=0;i<this.sessionData.length;i++){
                var j =i;
               
                if(this.sessionData[i].Checkbox === false && (this.sessionData[i].DeferredReason == '' || this.sessionData[i].DeferredReason == null)){
                     console.log('this.sessionData[i].Checkbox = ',this.sessionData[i].Checkbox)
                    console.log('this.sessionData[i].DeferredReason = ',this.sessionData[i].DeferredReason)
                    status = false;
                    let reason='Please enter valid Reason on row '+(j+1);
                    const event = new ShowToastEvent({
                        variant: 'error',
                        title: 'Error!',
                        message: reason,
                    });
                    this.dispatchEvent(event);
                    break;
                }
            }
        if(status == true){
            this.showSpinner = true;
            saveSessions({ wrapList : this.sessionData, checkAction : this.action, invoiceDate : this.invoiceDate, email : this.fem  })
                .then(result => {
                this.contacts = result;
                    console.log('Result ---'+result);
                    this.showSpinner = false; 
                    if(result == 'SUCCESS'){
                        const event = new ShowToastEvent({
                            variant: 'success',
                            title: 'Success!',
                            message: 'Records succesfully updated!',
                        });

                        this.dispatchEvent(event);
                        window.location.reload(); 
                        //this.getSessions();
                        
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
                    console.log('this.error = ',this.error)
                });    
        }
    }
    async handleSubmitSessionChanges(event){
        this.action = 'submit';
        this.saveSessionFunc();
    }

    submitSessionsForEmailGeneration(event){
                var sessionUpdateMap = this.sessionData;
                this.isLoading = true;

                sendInvoiceMailToFacilitator({ wrapList : sessionUpdateMap, invoiceDate : this.invoiceDate})
                .then(result => {
                    this.contacts = result;
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
    
    // handleInvoiceToFacilitator(){
    //     const allValid = [
    //         ...this.template.querySelectorAll('lightning-input'),
    //     ].reduce((validSoFar, inputCmp) => {
    //         inputCmp.reportValidity();
    //         return validSoFar && inputCmp.checkValidity();
    //     }, true);
    //     if (allValid) {
    //         this.handleConfirmClick();
    //     }
    // }

    // async handleConfirmClick() {
    //     const result = await LightningConfirm.open({
    //         message: 'Are you sure you want to send Consultancy bills dated '+ this.invoiceDate+ ' to '+this.facilitatorEmail,
    //         variant: 'header',
    //         label: 'Please confirm the below details :',
    //     });
    //     if (result) {
    //         this.isLoading = true;
    //         sendInvoiceToFacilitator({ invoiceDate : this.invoiceDate, facilitatorEmail : this.facilitatorEmail})
    //         .then(result => {
    //             this.contacts = result;
    //             if(result == 'SUCCESS'){
    //                 this.isLoading = false;
    //                 const event = new ShowToastEvent({
    //                     variant: 'success',
    //                     title: 'Success!',
    //                     message: 'Succesfully Consultancy Bill Email sent to Facilitator !',
    //                 });
    //                 this.dispatchEvent(event);
                    
    //                 window.location.reload();
    //             }else{
    //                 this.isLoading = false;
    //                 const event = new ShowToastEvent({
    //                     variant: 'error',
    //                     title: 'Error!',
    //                     message: result,
    //                 });
    //                 this.dispatchEvent(event);
    //             }
    //         })
    //         .catch(error => {
    //             this.isLoading = false;
    //             console.log(error);
    //         }); 

    //     } else {
    //         //do something else 
    //     }
    // }
    signOut(event){
        let name = 'AntarangPaymentLogin';
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
        document.cookie = name + "=" + value + expires + "; path=/";
        this.showToast('success','Sign out successfully');
        this.navigationFunction('LoginPage__c');
    }
    showToast(type,message){
        const evt = new ShowToastEvent({
            message: message,
            variant: type,
        });
        this.dispatchEvent(evt);
    }
    navigationFunction(pageApi){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: pageApi
            },
            state:{
                fem : encodeURI(this.fem)
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }
}