import { LightningElement } from 'lwc';
import Antarang_logo from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
import checkEmail from '@salesforce/apex/SessionLoginController.checkEmail'
export default class SessionLogin extends NavigationMixin(LightningElement) {

    antarangLogo = Antarang_logo;
    enteredEmail = '';
    conRecordId;
    showLoading = false;
    handleInputChange(event) {
        this.enteredEmail = event.detail.value;
    }

    loginHandler() {
        this.showLoading = true;
        console.log('Value- ' + this.enteredEmail);
        if (this.enteredEmail == undefined || this.enteredEmail == null || this.enteredEmail == "") {
            debugger;
            const evt = new ShowToastEvent({
                title: 'Please enter Email address!',
                message: 'Enter trainer\'s email address!',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
            this.showLoading = false;
        } else {
            checkEmail({ strEmail: this.enteredEmail })
                .then((result) => {
                    console.log('Result1- ' + JSON.stringify(result));
                    if (result.hasOwnProperty('contact')) {
                        if (Object.keys(result.contact).length == 0) {
                            console.log('Not found');
                            const evt = new ShowToastEvent({
                                title: 'Error',
                                message: 'Entered wrong email Id!',
                                variant: 'error'
                            });
                            this.dispatchEvent(evt);
                            this.showLoading = false;
                        } else {
                            
                             //this.contact = JSON.parse(result);
                             this.conRecordId = result.contact["Id"];
                            
                            
                            const secretCode = Math.floor(1000 + Math.random() * 9000).toString();
                           console.log('this.conRecordId- '+this.conRecordId);
                           console.log('secretCode- '+secretCode);
                            window.name = secretCode;
                             let pageReference = {
                                 type: 'comm__namedPage',
                                attributes: {
                                    name: 'SessionDetail__c'
                                 },
                                 state: {
                                     code: encodeURI(secretCode),
                                     facilitorId: encodeURI(this.conRecordId)
                                 }
                             };
                             this[NavigationMixin.Navigate](pageReference);
                            const evt = new ShowToastEvent({
                                title: 'Success',
                                message: 'Logged In Successfully!',
                                variant: 'success'
                            });
                            this.dispatchEvent(evt);
                        console.log('Redirect Page');
                        this.showLoading = false;
                        }
                    } else if (result.hasOwnProperty('Already Logged In')) {
                        console.log('Already Logged In');
                        const evt = new ShowToastEvent({
                                title: 'Error!',
                                message: 'User is already logged in.',
                                variant: 'warning'
                            });
                            this.dispatchEvent(evt);
                            this.showLoading = false;
                    } else if('error'){
                        const evt = new ShowToastEvent({
                                title: 'Not Found',
                                message: 'Matching trainer not found!',
                                variant: 'error'
                            });
                            this.dispatchEvent(evt);
                            this.showLoading = false;
                    }
                })
                .catch((error) => {
                    console.log('Error- ' + JSON.stringify(error));
                });
        }
    }

}