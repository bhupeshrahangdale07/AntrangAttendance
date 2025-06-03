import { LightningElement } from 'lwc';
import Antarang_logo from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
import checkEmail from '@salesforce/apex/SessionLoginController.checkEmail'
export default class SessionLogin extends NavigationMixin(LightningElement) {

    antarangLogo = Antarang_logo;
    enteredEmail = '';
    //userEmail = '';
    conRecordId;
    showLoading = false;
    handleInputChange(event) {
        this.enteredEmail = event.detail.value.trim();
    }

    loginHandler() {
        this.showLoading = true;
        console.log('Value2- ' + this.enteredEmail);
        if (this.enteredEmail == undefined || this.enteredEmail == null || this.enteredEmail == "") {
            debugger;
            this.showToastMessage('Please enter Email address', 'error');
            this.showLoading = false;
        } else {
            checkEmail({ strEmail: this.enteredEmail })
                .then((result) => {
                    console.log('Result1- ' + JSON.stringify(result));
                    if (result.hasOwnProperty('contact')) {
                        if (Object.keys(result.contact).length == 0) {
                            this.showToastMessage('Entered wrong Email ID!', 'error');
                            
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
                                    name: 'SessionMainMenu__c'
                                 },
                                 state: {
                                     code: encodeURI(secretCode),
                                     facilitorId: encodeURI(this.conRecordId)
                                 }
                             };
                             this[NavigationMixin.Navigate](pageReference);
                            this.showToastMessage('Logged In successfully!', 'success');
                        console.log('Redirect Page');
                        this.showLoading = false;
                        }
                    } else if (result.hasOwnProperty('Already Logged In')) {
                       this.showToastMessage('User is already Logged In!', 'error');
                            this.showLoading = false;
                    } else if('error'){
                        this.showToastMessage('Matching trainer not found!', 'error');
                            this.showLoading = false;
                    }
                })
                .catch((error) => {
                    console.log('Error- ' + JSON.stringify(error));
                });
        }
    }

    showToastMessage(message,variant){
        const event = new ShowToastEvent({
                title : 'Session Login',
                message : message,
                variant : variant
            });
            this.dispatchEvent(event);
    }

}