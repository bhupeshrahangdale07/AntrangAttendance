import { LightningElement, wire, track } from 'lwc';
import getDistrict from '@salesforce/apex/GenerateInvoiceFormController.getDistrict';
import generateFinanceFileNSend from '@salesforce/apex/GenerateInvoiceFormController.generateFinanceFileNSend';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GeneratePayoutFileForFinance extends NavigationMixin(LightningElement) {

     selectedDistrict='';
    @track selectedMonth=null;
    @track selectedYear='';
    selectedInvoiceDate;
    districtOptions = [];
    showFacilatorData = false;
    fem='';
    @track facilitatorData = [];
    dataNotFound=false;
    isLoading = false;
    
    monthOptions = [
        { label: 'January', value: '1' },
        { label: 'February', value: '2' },
        { label: 'March', value: '3' },
        { label: 'April', value: '4' },
        { label: 'May', value: '5' },
        { label: 'June', value: '6' },
        { label: 'July', value: '7' },
        { label: 'August', value: '8' },
        { label: 'September', value: '9' },
        { label: 'October', value: '10' },
        { label: 'November', value: '11' },
        { label: 'December', value: '12' }
    ];
    
    getDistrictOptions(){
        this.isLoading = true;
        getDistrict().then(result => {
            //console.log('getDistrictOptions Result = ',result);
            this.isLoading = false;    
            this.districtOptions = result.map(function(district){
                return ({
                    value:district.Id,
                    label:district.Name
                })
            }); 
        }).catch(error => {
            this.isLoading = false;  
            console.log('getDistrictOptions Error = ',error);
            this.showToast('error',error.body.message);   
        });
    }
    connectedCallback(){
        this.getDistrictOptions();
    }

    handleChange(event){
        if(event.target.name  == 'district')
            this.selectedDistrict = event.target.value;
        else if(event.target.name  == 'invoiceDate'){
            let dt = event.target.value;
            this.selectedInvoiceDate = event.target.value; //console.log( event.target.value);
            this.selectedMonth = parseInt(this.selectedInvoiceDate.split('-')[1],10).toString();
        }
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
    generatefinanaceFile(event){
        if(this.selectedInvoiceDate == null){
            this.showToast('error','Please enter Invoice Date');
        }else{
            this.isLoading = true;
            //console.log('selectedDistrict =',this.selectedDistrict)
            if(this.selectedDistrict == '' || this.selectedDistrict == null){
                //console.log('ffdwd')
            }else //console.log('fwfwf');
            generateFinanceFileNSend({invoiceDate:this.selectedInvoiceDate,district:this.selectedDistrict}).then(result => {
                //console.log('generateFinanceFileNSend Result = ',result);
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
    handleBack(event){
        this.navigationFunction('FacilitatorSalaryPayment__c');
    }
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.fem = decodeURI(currentPageReference.state.fem);
            this.prf = decodeURI(currentPageReference.state.prf);
        }
    }
}