import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import generateFinanceFileNSend from '@salesforce/apex/VariablePayController.financeVariablePayoutFile';
export default class FinanceVariablePay extends NavigationMixin(LightningElement) {
    @track fem;
    @track selectedInvoiceDate;
    @track isLoading;
    handleChange(event){
        if(event.target.name  == 'invoiceDate'){
            let dt = event.target.value;
            this.selectedInvoiceDate = event.target.value; //console.log( event.target.value);
        }
    }
    generatefinanaceFile(event){
       
        if(this.selectedInvoiceDate == null){
            this.showToast('error','Please enter Invoice Date');
        }else{
            this.isLoading = true;
            generateFinanceFileNSend({invoiceDate:this.selectedInvoiceDate,email:this.fem}).then(result => {
                console.log('generateFinanceFileNSend Result = ',result);
                this.isLoading = false; 
                //console.log('generateFinanceFileNSend Result = ',result);   
                if(result == 'success'){
                    this.showToast('success','Payout File send to finance team');
                    location.reload();
                }
                else if(result == ''){
                    this.showToast('error','Something went wrong');   }
                else{
                     this.showToast('error',result);   }
            }).catch(error => {
                this.isLoading = false;  
                console.log('generateFinanceFileNSend Error = ',error);
                this.showToast('error',error.body.message);   
            });
        }
    }
    showToast(type,message){
        const evt = new ShowToastEvent({
            message: message,
            variant: type,
        });
        this.dispatchEvent(evt);
    }
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
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.fem = decodeURI(currentPageReference.state.fem);
            this.prf = decodeURI(currentPageReference.state.prf);
        }
    }
}