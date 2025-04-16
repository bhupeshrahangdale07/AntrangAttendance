import { LightningElement, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';    
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import getSessionDataForSupervisor from '@salesforce/apex/VariablePayController.getSessionDataForSupervisor';
import approveRejectPayout from '@salesforce/apex/VariablePayController.approveRejectPayout';

export default class SupervisorVariablePay extends NavigationMixin(LightningElement) {
    @track isLoading;
    @track selectedDate;
    @track sessionData = [];
    @track isSessionDataExist = false;
    @track ApprovalStatus;
    hideBtn = false;
    showTable;
    maxDate;
    fem='';
    connectedCallback() {
        const currentDate = new Date();
        const year = currentDate.getFullYear();
        const month = String(currentDate.getMonth() + 1).padStart(2, '0');
        //console.log('fff');
        const lastDayOfMonth = new Date(year, month, 0);
        //console.log(this.formatDate(lastDayOfMonth));
        this.maxDate = this.formatDate(lastDayOfMonth);
    }
    get hideNShow(){
        if(this.hideBtn || this.isSessionDataExist){
            return false;
        }else return true;
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
    handleChange(event){

        this.selectedDate=event.target.value;

        console.log('Input Date- '+this.selectedDate);
    }
    onShowSessionClick(){
       
        const invoiceDate1 = new Date(this.selectedDate);
        if(this.selectedDate == '' || this.selectedDate === undefined || this.selectedDate === null){
            this.showToast('error','Please select \'Consultancy Bill Date\'');
        }else if(this.maxDate < this.formatDate(invoiceDate1)){
            this.showToast('error','please select current month invoice');
            this.showFacilatorData = false; 
        } else{
            this.getSession();
        }
     }
    formatDate(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }    
    getSession(){
        debugger
        
        console.log('selectedDate = ',this.selectedDate)
        this.isLoading = true;
        getSessionDataForSupervisor({ inputDate:this.selectedDate})
        .then(result =>{
             debugger
            console.log('getFacilitator Result = ',result.sessionData.length);
            //result = result.filter(r=>r.SalaryStatus == 'Proposal Submitted' && r.invoiceMonth == this.selectedMonth); 
            this.sessionData=result.sessionData;
            let proposalrejectedRecord = this.sessionData.filter(r=>r.Status == 'Proposal Rejected');
            let proposalsaveRecord = this.sessionData.filter(r=>r.Status == 'Proposal Saved');
            let proposalgeneratedRecord = this.sessionData.filter(r=>r.Status == 'Invoice Generated');
            console.log('Data--- '+JSON.stringify(result));
            console.log('this.sessionData.length = ',this.sessionData.length)
            this.isLoading = false;
            if(this.sessionData.length > 0){
                 this.showTable = true;
                this.isSessionDataExist = false;
                if(proposalrejectedRecord.length > 0 || proposalsaveRecord.length > 0){
                    this.hideBtn = true;
                }else if(proposalgeneratedRecord.length > 0){
                    this.hideBtn = true;
                }else this.hideBtn = false;
               
 
            }else {
                this.showTable = false;
                    this.hideBtn = false;
                    this.isSessionDataExist = true;
                    this.showToast('error','No Data Found !'); 
                }
        })
        .catch(error =>{
            this.isLoading = false;
            console.log('getFacilitator Error = ',error);
            this.showToast('error',error.body.message);
        });
    }
    handleRejectPayout(event){
        this.isLoading = true;
        this.ApprovalStatus = 'rejected';
        this.approveRejectPayoutfunc();
    }
    handleApprovePayout(event){
        this.isLoading = true;
        this.ApprovalStatus = 'approved';
        this.approveRejectPayoutfunc();
    }
    approveRejectPayoutfunc(){
        approveRejectPayout({ jsonData:JSON.stringify(this.sessionData), status:this.ApprovalStatus,invoiceDate:this.selectedDate, email : this.fem})
        .then(result =>{
            console.log('generateInvoiceData Result = ',result);
            this.isLoading = false;
            if(result == 'success'){
                this.isLoading = false;
               if(this.ApprovalStatus == 'approved') this.showToast('success','Invoice sent successfully');
               if(this.ApprovalStatus == 'rejected') this.showToast('success','Proposal Rejected');
               location.reload();}
            else if(result == 'fail'){
                 this.isLoading = false;
                this.showToast('error','Something went wrong'); }
        })
        .catch(error =>{
            this.isLoading = false;
            console.log('generateInvoiceData Error = ',error);
            this.showToast('error',error.body.message);
        });
    }
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.fem = decodeURI(currentPageReference.state.fem);
        }
    }

}