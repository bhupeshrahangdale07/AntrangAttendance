import { LightningElement } from 'lwc';
import Antarang_logo from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from "lightning/navigation";
import checkEmail from '@salesforce/apex/SessionLoginController.checkEmail'
export default class SessionLogin extends NavigationMixin(LightningElement) {

    antarangLogo = Antarang_logo;
    enteredEmail;
    handleInputChange(event) {
        this.enteredEmail = event.detail.value;
    }

    loginHandler() {
        console.log('Value- ' + this.enteredEmail);
        if (this.enteredEmail == undefined || this.enteredEmail == null || this.enteredEmail == "") {
            // alert('Please enter valid Email address!');
            debugger;
            const evt = new ShowToastEvent({
                title: 'Please enter Email address!',
                message: 'Enter trainer\'s email address!',
                variant: 'error'
            });
            this.dispatchEvent(evt);
        } else {
            checkEmail({ strEmail: this.enteredEmail })
                .then((result) => {
                    console.log('Result1- ' + JSON.stringify(result));
                    if (result.hasOwnProperty('Contact')) {
                        if (Object.keys(result.contact).length == 0) {
                            console.log('Not found');
                            const evt = new ShowToastEvent({
                                title: 'Not Found',
                                message: 'Matching trainer not found!',
                                variant: 'error'
                            });
                            this.dispatchEvent(evt);
                        } else {
                            console.log('Success');
                            // let pageReference = {
                            //     type: 'comm__namedPage',
                            //     attributes: {
                            //         name: 'SessionDetail__c'
                            //     },
                            //     state
                            //     fem: encodeURI(this.facilatorEmail),
                            //     sch: encodeURI(this.schoolId),
                            //     grd: encodeURI(this.grade),
                            //     bid: encodeURI(this.batchId),
                            //     acid: encodeURI(this.acid),
                            //     typ: encodeURI(this.typ),
                            //     lng: encodeURI(this.lng),
                            //     studentId: studentId
                            // }
                            // };
                            // this[NavigationMixin.Navigate](pageReference);
                        }
                    } else if (result.hasOwnProperty('Already Logged In')) {
                        console.log('Already Logged In');
                    }
                })
                .catch((error) => {
                    console.log('Error- ' + JSON.stringify(error));
                });
        }
    }

}