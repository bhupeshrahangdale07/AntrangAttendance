import { LightningElement, wire, track } from 'lwc';
import getDistrict from '@salesforce/apex/GenerateInvoiceFormController.getDistrict';
import { CurrentPageReference } from 'lightning/navigation';
import getFacilitatorData from '@salesforce/apex/GenerateInvoiceFormController.showFaciliatorOnEdit';
import approveRejectPayout from '@salesforce/apex/GenerateInvoiceFormController.approveRejectPayout';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class approvePayoutForm extends NavigationMixin(LightningElement) {
    selectedDistrict='';
    @track selectedMonth='';
    @track selectedYear='';
    selectedInvoiceDate;
    readOnlyMode = false;
    districtOptions = [];
    showFacilatorData = false;
    fem='';
    @track facilitatorData = [];
    dataNotFound=false;
    isLoading = false;
    @track ApprovalStatus = '';
    maxDate;
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
        this.getDistrictOptions();
    }
    handleChange(event){
        if(event.target.name  == 'district'){
            this.selectedDistrict = event.target.value;
        }else if(event.target.name  == 'invoiceDate'){
            let dt = event.target.value;
            this.selectedInvoiceDate = event.target.value; //console.log( event.target.value);
            this.selectedMonth = parseInt(this.selectedInvoiceDate.split('-')[1],10).toString();
        }

    }
    handleShowFacilitator(event){
        const invoiceDate = new Date(this.selectedInvoiceDate);
        if(this.selectedDistrict == '' && (this.selectedInvoiceDate == '' || this.selectedInvoiceDate === undefined)){
            this.showToast('error','Please fill required fields (*)');
            this.showFacilatorData = false;
        }
        else if(this.selectedDistrict != '' && (this.selectedInvoiceDate == '' || this.selectedInvoiceDate === undefined)){
            this.showToast('error','please select invoice date');
            this.showFacilatorData = false;
        }else if(this.selectedDistrict == '' && this.selectedInvoiceDate != ''){
            this.showToast('error','please select district');
            this.showFacilatorData = false;
        } 
        else{   
            this.getFacilitator();
            this.showFacilatorData = true
        }
        /*if(!this.selectedDistrict || !this.selectedMonth || (this.selectedInvoiceDate == null || this.selectedInvoiceDate === undefined)){
            this.showToast('error','Please fill required fields');
            this.showFacilatorData = false;
        }else{
            this.facilitatorData = '';
            this.getFacilitator();
            this.showFacilatorData = true;
        }*/
    }
    getFacilitator(){
        this.isLoading = true;
        getFacilitatorData({ invoiceDate:this.selectedInvoiceDate, district:this.selectedDistrict, month:this.selectedMonth,userType:'Supervisor'})
        .then(result =>{
            //console.log('getFacilitator Result = ',result);
            //result = result.filter(r=>r.SalaryStatus == 'Proposal Submitted' && r.invoiceMonth == this.selectedMonth); 
            if(result.length != 0){
                result.sort(function (a, b) {
                if (a.FacilitatorName < b.FacilitatorName) {
                    return -1;
                }
                if (a.FacilitatorName > b.FacilitatorName) {
                    return 1;
                }
                return 0;
                });
                this.facilitatorData = result;  
                //this.facilitatorData = this.facilitatorData.filter(r=>!(r.AmountPaid >= r.FacilitatorFixedAmount))    
                this.facilitatorData.forEach((arg)=>{
                    let index = this.monthOptions.findIndex(x => x.value ===arg.SalaryMonth);
                    var dt = new Date(this.selectedInvoiceDate);
                    arg.MonthYear=this.monthOptions[index]['label'] +' '+arg.SalaryYear;
                });
            }
            let recordHasStatusInvoiceGenerated = this.facilitatorData.filter(r=>(r.SalaryStatus == 'Invoice generated' || r.SalaryStatus == 'Proposal approved' ||  r.SalaryStatus == 'Proposal Rejected') && r.invoiceMonth == this.selectedMonth);
            if(recordHasStatusInvoiceGenerated.length > 0){
                this.readOnlyMode = true;
            }else{
                this.readOnlyMode = false;
                this.facilitatorData = this.facilitatorData.filter(r=>r.SalaryStatus == 'Proposal Submitted' && r.invoiceMonth == this.selectedMonth); 
            }
            if(this.facilitatorData.length > 0)
                this.dataNotFound = false; else this.dataNotFound = true;
            this.isLoading = false;
        })
        .catch(error =>{
            this.isLoading = false;
            console.log('getFacilitator Error = ',error);
            this.showToast('error',error.body.message);
        });
    }
    handleApprovePayout(event){
        this.isLoading = true;
        //this.facilitatorData = this.facilitatorData.filter(r=>r.Reason != 'Not to be paid');
        //console.log('this.facilitatorData =',JSON.stringify(this.facilitatorData));
        this.ApprovalStatus = 'Invoice Generated';
        this.approveRejectPayoutfunc();
    }
    handleRejectPayout(event){
        this.isLoading = true;
        this.ApprovalStatus = '';
        this.approveRejectPayoutfunc();
    }
    approveRejectPayoutfunc(){
        approveRejectPayout({ jsonData:JSON.stringify(this.facilitatorData), salaryMonth:this.selectedMonth,district:this.selectedDistrict, status:this.ApprovalStatus,invoiceDate:this.selectedInvoiceDate})
        .then(result =>{
            //console.log('generateInvoiceData Result = ',result);
            this.isLoading = false;
            if(result == 'success'){
                this.isLoading = false;
               if(this.ApprovalStatus == 'Invoice Generated') this.showToast('success','Invoice sent successfully');
               if(this.ApprovalStatus == '') this.showToast('success','Proposal Rejected');
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
    // handlegenerateInvoice(event){
    //     this.isLoading = true;
    //     this.generateInvoiceData();
    // }
    // generateInvoiceData(){
    //     generateInvoice({ jsonData:JSON.stringify(this.facilitatorData), salaryMonth:this.selectedMonth, invoiceDate:this.selectedInvoiceDate,district:this.selectedDistrict})
    //     .then(result =>{
    //         console.log('generateInvoiceData Result = ',result);
    //         this.isLoading = false;
    //         if(result == 'success')
    //            this.showToast('success','Invoice generated successfully');
    //         else if(result == 'fail')
    //             this.showToast('error','Something went wrong'); 
    //     })
    //     .catch(error =>{
    //         this.isLoading = false;
    //         console.log('generateInvoiceData Error = ',error);
    //         this.showToast('error',error.body.message);
    //     });
    // }

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
                //fem : encodeURI(this.fem)
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

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.fem = decodeURI(currentPageReference.state.fem);
            this.prf = decodeURI(currentPageReference.state.prf);
        }
    }
}