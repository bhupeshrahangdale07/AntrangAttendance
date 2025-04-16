import { LightningElement, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import omrSubmitterLoginCheck from '@salesforce/apex/OmrLoginFormController.omrSubmitterLoginCheck';

export default class OmrLoginForm extends NavigationMixin(LightningElement) {
    @track trainerEmail ;//= 'srikanth.d@kandisatech.com';
    @track trainerPassword ;//= 'Omr@12345';
    @track pageApi = 'OMR_Submission__c';
    @track isLoading = false;
    dist;
    
    handleEmailChange(event) {
        this.trainerEmail = event.target.value;
    }

    handlePasswordChange(event) {
        this.trainerPassword = event.target.value;
    }

    async checkemail(event) {
        this.isLoading = true;
        if (! await this.validateLoginInfo(event)) {
            this.showToast('Error', 'Please update the invalid entrie(s) and try again.', 'error', '');
            this.isLoading = false;
        } else {
            omrSubmitterLoginCheck({ Email:this.trainerEmail , Password:this.trainerPassword })
            .then((result)=>{
                if(result && result.isValid){
                    this.dist = result.data;
                    this.createCookie('OMRSubmissionFormLogin', encodeURIComponent(this.trainerEmail), 1);
                    this.navigateTo(result.data, this.pageApi);
                    this.isLoading = false;
                }else if( result && !result.isValid){
                    this.showToast('Error', result.error ? result.error : 'Invalid email or password', 'error', '');
                    this.isLoading = false;
                }
            }).catch((error)=>{
                this.showToast('Error', error, 'error', '');
                this.isLoading = false;
            })
        }

    }

    createCookie(name, value, days){
        var expires;
        if (days) {
            const date = new Date();
            date.setTime(date.getTime() + (15* 1000));
            expires = "; expires=" + date.toGMTString();
        } else {
            expires = "";
        }
        document.cookie = name+'='+value+expires+'; ';
        //document.cookie = name + "=" + escape(value)  + expires + "; path=/";
    }

    async validateLoginInfo(event) {
        const allValid = await [
            ...this.template.querySelectorAll('lightning-input'),
        ].reduce((validSoFar, inputCmp) => {
            inputCmp.reportValidity();
            if (validSoFar && inputCmp.checkValidity()) {
                inputCmp.setCustomValidity('');
            }
            return validSoFar && inputCmp.checkValidity();
        }, true);
        return allValid;
    }

    navigateTo(dist, pageName) {
        // Navigate to the Account home page
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: pageName
            },
            state: {
                dst : btoa(dist.toString()),
                un : btoa(this.trainerEmail.toString())
            }

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
}