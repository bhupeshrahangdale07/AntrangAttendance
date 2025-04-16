import { LightningElement, track } from 'lwc';
import checkApproverEmailExist from '@salesforce/apex/FacilitatorContactEditApprovalController.checkApproverEmailExist';
import pendingRecords from '@salesforce/apex/FacilitatorContactEditApprovalController.pendingRecords';
import mergeContact from '@salesforce/apex/FacilitatorContactEditApprovalController.mergeContact';
//import tttt from '@salesforce/apex/FacilitatorContactEditApprovalController.tttt';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningConfirm from 'lightning/confirm';


export default class StudentApproverPage extends LightningElement {
    startPage = true;
    @track traineremail;
    @track rejectedReason = '';
    @track disablePopUpRejectBtn = true;
    @track showPopUp = false;
    @track isLoading = false;
    tableData = false;
    @track bulkAction = true;
    @track noPendingRecords = false;
    data;
    selectedRecords = [];
    columns = [{'label':'UID', 'value': 'UID'},
                {'label':'First Name', 'value': 'FirstName'},
                {'label':'Last Name', 'value': 'LastName'},
                {'label':'Gender', 'value': 'Gender__c'},
                {'label':'Birthdate', 'value': 'Birthdate'},
                //{'label':'MobilePhone', 'value': 'MobilePhone'},
                {'label':'Currently Studying In', 'value': 'Currently_Studying_In__c'},
                {'label':'Batch Code', 'value': 'BatchCode'},
                {'label':'Whatsapp Number', 'value': 'WhatsappNumber'},
                {'label':'Alternate Mobile No', 'value': 'AlternateMobileNo'}];
 
    handleTrainerEmail(event){
        this.traineremail = event.target.value;
    }

    isInputValid() {
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.validate');
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
           // this.contact[inputField.name] = inputField.value;
        });
        return isValid;
    }

    handleRejectReason(event){
        this.rejectedReason = event.target.value;
        if(this.rejectedReason == undefined || this.rejectedReason == null || this.rejectedReason == ''){
            this.disablePopUpRejectBtn = true;
        }
        if(this.rejectedReason != undefined && this.rejectedReason != null && this.rejectedReason != ''){
            this.disablePopUpRejectBtn = false;
        }
    }

    hideModalBox(event){
        this.rejectedReason = '';
        this.showPopUp = false;
    }

    checkemail(event){
        this.isLoading = true;
        let stremail = this.traineremail;
        let validExpense = true;
        if (stremail == undefined || stremail == null || stremail == "") {
            validExpense = false;
            const event = new ShowToastEvent({
                variant: 'error',
                title: 'ERROR !',
                message: "Enter Approver email address!",
            });
            this.dispatchEvent(event);
        }
        
        if (validExpense) {
            this.checktraineremail(event);
        }
        this.isLoading = false;
    }

    checktraineremail(event){
        this.isLoading = true;
        checkApproverEmailExist({stremail:this.traineremail})
        .then(res => {
            if(res === 'Not Valid'){
                const event = new ShowToastEvent({
                    variant: 'warning',
                    message: 'Matching Approver not found!!',
                });
                this.dispatchEvent(event);
            }
            if(res === 'Valid'){
                this.startPage = false;
                //alert("Valid address")
                
                this.getpendingRecords(event);
                //this.contactEditPage = true;
            }
        })
        .catch(error => {
            console.log(error);
        })
        this.isLoading = false;

    }


    getpendingRecords(event){
        pendingRecords()
        .then(res => {
            if(res.status == 'No records for Pending'){
                const event = new ShowToastEvent({
                    variant: 'error',
                    message: 'There is no Pending records!',
                });
                this.noPendingRecords = true;
                this.dispatchEvent(event);
                //window.location.reload();
            }else if(res.status == 'Success'){
                console.log('Pending data : '+res.data);
                this.data = res.data;

            }
        }).catch(error => {
            console.log(error);
        })
    }


    handleRowAction(event){
        this.isLoading = true;
        var data = this.data;
        console.log('event.target.checked ',event.target.name);
        if(event.target.label == 'Reject'){
            console.log('event.target reject ',event.target.label);
            console.log('eventdata[event.target.dataset.index].clonedContact ',data[event.target.dataset.index].clonedContact);
            var d = [];
            d.push(data[event.target.dataset.index].clonedContact);
            this.updateRecords(d,'Rejected');
            //JSON.stringify(d);
            //tttt({clonedRecords:JSON.stringify(d) , action:"Rejected" });
            


        }else if(event.target.label == 'Approve'){
            var d = [];
            d.push(data[event.target.dataset.index].clonedContact);
            this.updateRecords(d,'Approved');
            console.log('event.target.checked ',event.target.label);
        }
        if(event.target.name == 'Checkbox'){
            console.log('event.target.checked ',event.target.dataset.index);

            if(event.target.checked){
                this.selectedRecords.push(data[event.target.dataset.index].clonedContact);
                if(this.selectedRecords.length >= 1){
                    this.bulkAction = false;
                }
                console.log('this.selectedRecords ',this.selectedRecords);
            }else{
                if(this.selectedRecords.includes(data[event.target.dataset.index].clonedContact)){
                    var index = this.selectedRecords.indexOf(data[event.target.dataset.index].clonedContact);
                    console.log('index ',index);
                    this.selectedRecords.splice(index, 1); 
                    console.log('this.selectedRecords qqq ',this.selectedRecords);
                    if(this.selectedRecords.length >= 1){
                        this.bulkAction = false;
                    }else{
                        this.bulkAction = true;
                    }
                }

                
            }
        }
        this.isLoading = false;
    }

    handleBulkAction(event){
        this.isLoading = true;
        var records = this.selectedRecords;
        var act = event.target.name;
        console.log(act);

        if(act == 'Approved'){
            mergeContact({data:JSON.stringify(records) , action:act, reason:'' })
            .then(res => {
                if(res == 'Success'){
                    const event = new ShowToastEvent({
                        variant: 'Success',
                        message: 'Successfully '+act+'!',
                    });
                    this.dispatchEvent(event);
                    this.data = null;
                    this.bulkAction = true;
                    this.selectedRecords = [];
                    this.getpendingRecords(event);
                    this.isLoading = false;
                // window.location.reload();
                }
            }).catch(error => {
                console.log(error);
                this.bulkAction = true;
                this.selectedRecords = [];
                this.getpendingRecords(event);
                this.isLoading = false;
            })
        }else if(act == 'Rejected'){
            this.disablePopUpRejectBtn = true;
            this.rejectedReason = '';
            this.isLoading = false;
            this.showPopUp = true;
        }
        //Mass_Reject , Mass_Approve
    }

    handlePopUpRejectBtn(event){
        
        var records = this.selectedRecords;
        var act = event.target.name;

        if(this.isInputValid()){
            if(this.rejectedReason.length < 1 ){
                const event = new ShowToastEvent({
                            variant: 'error',
                            mode:'sticky',
                            message: 'Please give a short description for Rejection with minimum of 25 characters !',
                        });
                    // this.dispatchEvent(event);
            }
            else{
                this.isLoading = true;
                mergeContact({data:JSON.stringify(records) , action:act, reason:this.rejectedReason })
                .then(res => {
                    if(res == 'Success'){
                        const event = new ShowToastEvent({
                            variant: 'Success',
                            message: 'Successfully '+act+'!',
                        });
                        this.showPopUp = false; 
                        this.dispatchEvent(event);
                        this.data = null;
                        this.bulkAction = true;
                        this.selectedRecords = [];
                        this.getpendingRecords(event);
                        this.isLoading = false;
                    // window.location.reload();
                    }
                }).catch(error => {
                    console.log(error);
                    this.bulkAction = true;
                    this.selectedRecords = [];
                    this.getpendingRecords(event);
                    this.showPopUp = false;
                    this.isLoading = false;
                })
            }
        }else{
            console.log('test');
            this.disablePopUpRejectBtn = true;
        }
    }

    updateRecords(Records, actn){
        this.isLoading = true;
        console.log('### Records ',Records);
        console.log('### actn ',actn);
        mergeContact({data:JSON.stringify(Records) , action:actn })
        .then(result => {
            if(result == 'Success'){
                const event = new ShowToastEvent({
                    variant: 'Success',
                    message: 'Successfully '+actn+'!',
                });
                this.dispatchEvent(event);
                this.data = null;
                this.getpendingRecords(event);
                this.isLoading = false;
            }
        }).catch(error => {
            console.log(error);
            this.isLoading = false;
        });
    }

    handleMassRejectAction(event){

    }

    handleReload(event){
        window.location.reload();
    }

    async signOut(event){
        const result = await LightningConfirm.open({
            message: 'Are you sure you want Sign Out',
            variant: 'header',
            label: 'Please confirm :',
        });
        //alert(result);
        if (result) {
            this.handleReload(event);
        } else {
            //do something else 
        }
    }

}