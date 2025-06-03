import { LightningElement,wire, track,api } from 'lwc';
import getDistrict from '@salesforce/apex/GenerateInvoiceFormController.getDistrict';
import { CurrentPageReference } from 'lightning/navigation';
import generateInvoice from '@salesforce/apex/GenerateInvoiceFormController.generateInvoice';
import showFaciliatorOnEdit from '@salesforce/apex/GenerateInvoiceFormController.showFaciliatorOnEdit';
import getPicklistValues from '@salesforce/apex/GenerateInvoiceFormController.getPicklistValues';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class GenerateInvoiceForm extends NavigationMixin(LightningElement) {
    selectedDistrict='';
    @track typeField='edit';
    @track selectedMonth='';
    @track selectedYear='';
    selectedInvoiceDate;
    districtOptions = [];
    @track editRejectedMode = false;
    @track isErrorMessageVisible = false;
    showFacilatorData = false;
    prf='';
    fem='';
    @track editMode = false;
    @track facilitatorData = [];
    dataNotFound=false;
    
    isLoading = false;

    /*ReasonOptions = [
        {label:'Appreciation/performance bonus',value:'Appreciation/performance bonus'},
        {label:'Only Attedance not submitted',value:'Only Attedance not submitted'},
        {label:'On Leave',value:'On Leave'},
        {label:'Not to be paid',value:'Not to be paid'},
        {label:'Only OMR not submitted',value:'Only OMR not submitted'},
        {label:'Both OMR & Attedance not submitted',value:'Both OMR & Attedance not submitted'}
    ];*/
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
    maxDate;
    getpicklist(){
        this.isLoading = true;
        getPicklistValues().then(result => {
            //console.log('getpicklist Result = ',result);
            this.isLoading = false;    
           this.ReasonOptions = result.map(value => ({ label: value, value }));
           //console.log(' this.picklistValues = ', this.ReasonOptions)
        }).catch(error => {
            this.isLoading = false;  
            console.log('getDistrictOptions Error = ',error);
            this.showToast('error',error.body.message);   
        });
    }
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
        const currentDate = new Date();
        const year = currentDate.getFullYear();
        const month = String(currentDate.getMonth() + 1).padStart(2, '0');
        //console.log('fff');
        const lastDayOfMonth = new Date(year, month, 0);
        //console.log(this.formatDate(lastDayOfMonth));
        this.maxDate = this.formatDate(lastDayOfMonth);
        this.getDistrictOptions();
        this.getpicklist();
    }
    get getSaveBtn(){
        return this.editMode|| this.editRejectedMode;
    }
    formatDate(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }
    handleChange(event){
        if(event.target.name  == 'district')
            this.selectedDistrict = event.target.value;
        else if(event.target.name  == 'invoiceDate'){
            let dt = event.target.value;
            this.selectedInvoiceDate = event.target.value; 
            //console.log( "this.selectedInvoiceDate", typeof(this.selectedInvoiceDate));
            this.selectedMonth = parseInt(this.selectedInvoiceDate.split('-')[1],10).toString();
        }
        else if(event.target.name  == 'reason'){
            this.facilitatorData[event.target.dataset.index]["Reason"] = event.target.value;
        }else if(event.target.name  == 'FacilitatorCheckbox'){
            this.facilitatorData[event.target.dataset.index]['Checkbox'] = event.target.checked;
            if(this.facilitatorData[event.target.dataset.index]['Checkbox'] == false || (this.facilitatorData[event.target.dataset.index]['copyOfAmtToBePaid'] != this.facilitatorData[event.target.dataset.index]['FacilitatorAmtToBePaid'] && this.facilitatorData[event.target.dataset.index]['Checkbox'] == true)){
                this.facilitatorData[event.target.dataset.index]['ReasonStatus'] = false;
            }else this.facilitatorData[event.target.dataset.index]['ReasonStatus'] = true;
            if(this.facilitatorData[event.target.dataset.index]['SalaryStatus'] == 'Proposal Rejected'){
                if(this.facilitatorData[event.target.dataset.index]['Checkbox'] == false || (this.facilitatorData[event.target.dataset.index]['copyAmountPaidToThisMonth'] != this.facilitatorData[event.target.dataset.index]['AmountPaidToThisMonth'] && this.facilitatorData[event.target.dataset.index]['Checkbox'] == true)){
                this.facilitatorData[event.target.dataset.index]['ReasonStatus'] = false;
            }else this.facilitatorData[event.target.dataset.index]['ReasonStatus'] = true;
            }
            
        }else if(event.target.name  == 'AmtToBePaid'){
            //console.log('event.target.value =',event.target.value)
            //console.log('ccc ='+this.facilitatorData[event.target.dataset.index]['copyOfAmtToBePaid']);
            if(event.target.value != this.facilitatorData[event.target.dataset.index]['copyOfAmtToBePaid']){
                this.facilitatorData[event.target.dataset.index]['ReasonStatus'] = false;
            }else this.facilitatorData[event.target.dataset.index]['ReasonStatus'] = true;
            this.facilitatorData[event.target.dataset.index]['FacilitatorAmtToBePaid'] = (event.target.value == '') ? 0 : event.target.value;
        }else if(event.target.name  == 'PreviousAmountPaid'){
            this.facilitatorData[event.target.dataset.index]['PreviousAmountPaid'] = event.target.value;
        }else if(event.target.name  == 'AmountPaidToThisMonth'){
            if(this.facilitatorData[event.target.dataset.index]['SalaryStatus'] == 'Proposal Rejected'){
                if(event.target.value != this.facilitatorData[event.target.dataset.index]['copyAmountPaidToThisMonth']){
                    this.facilitatorData[event.target.dataset.index]['ReasonStatus'] = false;
                }else this.facilitatorData[event.target.dataset.index]['ReasonStatus'] = true;
            }
            this.facilitatorData[event.target.dataset.index]['AmountPaidToThisMonth'] = event.target.value;
        }
        if(this.facilitatorData[event.target.dataset.index]['Reason'] == 'On Leave'){
            this.facilitatorData[event.target.dataset.index]['ReasonStatus'] = false;
        }
    }
    handleShowFacilitator(event){
        this.isErrorMessageVisible = !this.isErrorMessageVisible;
        //console.log(this.isErrorMessageVisible);
        //console.log('selectedDistrict = ',this.selectedDistrict)
        //console.log('selectedInvoiceDate = ',this.selectedInvoiceDate)
        const invoiceDate = new Date(this.selectedInvoiceDate);
        /*if(this.maxDate ){
            this.showToast('error','Please select correct invoice date');
            this.showFacilatorData = false;
        }
        else */if(this.selectedDistrict == '' && (this.selectedInvoiceDate == '' || this.selectedInvoiceDate === undefined || this.selectedInvoiceDate == null)){
            this.showToast('error','Please fill required fields (*)');
            this.showFacilatorData = false;
        }
        else if(this.selectedDistrict != '' && (this.selectedInvoiceDate == '' || this.selectedInvoiceDate === undefined || this.selectedInvoiceDate == null)){
            this.showToast('error','please select invoice date');
            this.showFacilatorData = false;
        }else if(this.selectedDistrict == '' && this.selectedInvoiceDate != ''){
            this.showToast('error','please select district');
            this.showFacilatorData = false;
        } else if(this.maxDate < this.formatDate(invoiceDate)){
            this.showToast('error','please select current month invoice');
                this.showFacilatorData = false; 
        }
        else{   
            this.getFacilitator();
            this.showFacilatorData = true
        }
        

    }
    // getTypeField(){
    //     console.log('selectedMonth = '+this.selectedMonth);
    //     const proposal = checkProposalIsCreated({salaryMonth:this.selectedMonth })
    //     .then(async(result) =>{
    //         console.log('checkProposalIsCreated Result = ',result);
    //         this.typeField = result;
    //     })
    //     .catch(error =>{
    //         this.isLoading = false;
    //         console.log('checkProposalIsCreated Error = ',error);
    //         this.showToast('error',error.body.message);
    //     });
    //     return proposal;
    // }
    getFacilitator(){
        this.isLoading = true;
        this.facilitatorData ='';
        showFaciliatorOnEdit({invoiceDate:this.selectedInvoiceDate, district:this.selectedDistrict})
        //getFacilitatorData({ invoiceDate:this.selectedInvoiceDate,district:this.selectedDistrict,month:this.selectedMonth, userType:'Admin'})
        .then(async (result) =>{
            console.log('getFacilitator Result = ',result);
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
                this.facilitatorData.forEach((arg)=>{
                      let index = this.monthOptions.findIndex(x => x.value ===arg.SalaryMonth);
                      var dt = new Date(this.selectedInvoiceDate);
                      arg.MonthYear=this.monthOptions[index]['label'] +' '+arg.SalaryYear;
                      arg.copyOfAmtToBePaid = arg.FacilitatorAmtToBePaid;
                      //arg.PreviousAmountPaid = arg.AmountPaid;
                      
                });
                this.editRejectedMode =  this.editMode = false;
                let statusIsNull = this.facilitatorData.filter(r=>r.SalaryStatus == '' || r.SalaryStatus == undefined);
                let rejectedRecord = this.facilitatorData.filter(r=>r.SalaryStatus == 'Proposal Rejected');
                
                if(statusIsNull.length > 0){
                    this.editMode = true;
                    //console.log('facilitatorData =',this.facilitatorData);
                    //let copyGetFacilitator = [...this.facilitatorData];
                    //let getFacilitatorWithZeroValue=[];
                    //let matchingIndices = [];
                    this.facilitatorData.forEach((args,i)=>{
                        args.Checkbox = true;
                        if(args.Reason == 'On Leave'){
                          args.ReasonStatus = false;
                      }
                       // if(myMap.has('Group 2'))
                        //myMap.set(args.FacilitatorId,args);
                        // if(args.FacilitatorAmtToBePaid == 0){
                        //     /*const valueIndex = this.facilitatorData.findIndex(item => item.FacilitatorId === args.FacilitatorId && item.MonthYear === args.MonthYear);
                        //     if (valueIndex !== -1) {
                        //         this.facilitatorData.slice(valueIndex);
                        //         console.log('valueIndex =',valueIndex)
                        //     }*/
                        //     copyGetFacilitator.forEach((element, index) => {
                        //         if(element.FacilitatorId === args.FacilitatorId && element.MonthYear === args.MonthYear){
                        //             matchingIndices.push(index);
                        //         }
                        //     });
                        //     //matchingIndices.push(i);

                        // }
                    });
                    // matchingIndices.sort((a, b) => b - a);
                    // matchingIndices.forEach(index => {
                    //     this.facilitatorData.splice(index, 1);
                    // });
                 
                    //this.facilitatorData = this.facilitatorData.filter(r=>r.FacilitatorAmtToBePaid != 0) //next month edit kartanna sagadech yet hote
                }else if(rejectedRecord.length > 0) {
                    this.facilitatorData.forEach((args,i)=>{
                        args.copyAmountPaidToThisMonth = args.AmountPaidToThisMonth;
                        args.copyPreviousAmountPaid = args.PreviousAmountPaid;
                    });
                    this.editRejectedMode = true;
                }else{
                    this.editMode  = false;
                    //let data = await this.getReadOnlyData();
                    //console.log('data = ',data)
                    //this.facilitatorData = data;
                }
                 
            }
            //console.log(this.editMode);
            
            if(this.facilitatorData.length > 0) this.dataNotFound = false;  else this.dataNotFound = true;
            this.isLoading = false;
        })
        .catch(error =>{
            this.isLoading = false;
            console.log('getFacilitator Error = ',error);
            this.showToast('error',error.body.message);
        });
    }
    getReadOnlyData(event){
        //debugger
        const data = showFaciliatorOnEdit({invoiceDate:this.selectedInvoiceDate, district:this.selectedDistrict}).then(async(result) => {
            //console.log('showFaciliatorOnEdit Result = ',result);
            this.isLoading = false;
            this.facilitatorData = result;            
        }).catch(error => {
            this.isLoading = false;  
            console.log('showFaciliatorOnEdit Error = ',error);
            this.showToast('error',error.body.message);   
        });
        return data;
    }
    handlegenerateInvoice(event){
        //console.log('this.facilitatorData =',JSON.stringify(this.facilitatorData));
        debugger
        this.isLoading = true;
        let status = true;
        console.log('this.facilitatorData.length =',this.facilitatorData.length)
        for(var i=0;i<this.facilitatorData.length;i++){
            //exit;   
            var j =i;
            if(this.facilitatorData[i].Checkbox == true){
                //console.log('not in range',this.facilitatorData[i].FacilitatorAmtToBePaid)
                //console.log('not in range',this.facilitatorData[i].copyOfAmtToBePaid)
                if(parseInt(this.facilitatorData[i].FacilitatorAmtToBePaid) >= 0){
                }else{
                    this.isLoading = false;
                    status = false;
                    let reason='Please enter valid Amount To Be Paid on row '+(j+1);
                    this.showToast('error',reason);
                    break;
                }
                if(this.facilitatorData[i].ReasonStatus == false && (this.facilitatorData[i].Reason == '' || !this.facilitatorData[i].Reason)){
                    this.isLoading = false;
                    status = false;
                    let reason = 'Please populate a reason on row '+(j+1);
                    this.showToast('error',reason);
                    break;
                }
                //console.log('dsd = ',this.facilitatorData[i].FacilitatorAmtToBePaid )
                /*if(this.facilitatorData[i].FacilitatorAmtToBePaid == '' || this.facilitatorData[i].FacilitatorAmtToBePaid == null && this.facilitatorData[i].SalaryStatus != 'Proposal Rejected'){
                    this.isLoading = false;
                    status = false;
                    let reason='Please enter Amount To Be Paid on row '+(j+1);
                    this.showToast('error',reason);
                    break;
                } */      
            }else if(this.facilitatorData[i].Checkbox == false && (this.facilitatorData[i].Reason == '' || !this.facilitatorData[i].Reason)){
                this.isLoading = false;
                status = false;
                let reason='Please enter Reason on row '+(j+1);
                this.showToast('error',reason);
                break;
            }
            
            /*if(this.facilitatorData[i].FacilitatorAmtToBePaid == undefined){
                this.facilitatorData[i].FacilitatorAmtToBePaid = this.facilitatorData[i].AmountPaid = 0;
                this.facilitatorData[i].FacilitatorAmtToBePaid = this.facilitatorData[i].copyamountPaidToThisMonth
                this.facilitatorData[i].AmountPaid = this.facilitatorData[i].copyPreviousAmountPaid
            }else this.facilitatorData[i].PreviousAmountPaid = this.facilitatorData[i].AmountPaid;*/
            if(this.facilitatorData[i].Reason === undefined){
                this.facilitatorData[i].Reason = '';    
            }
            if(this.facilitatorData[i].SalaryStatus =='Proposal Rejected'){ 
                this.facilitatorData[i].FacilitatorAmtToBePaid = this.facilitatorData[i].AmountPaidToThisMonth ;
                this.facilitatorData[i].AmountPaid = this.facilitatorData[i].PreviousAmountPaid 
                
                //this.facilitatorData[i].AmountPaid = this.facilitatorData[i].AmountPaidToThisMonth = this.facilitatorData[i].PreviousAmountPaid = 0
                //FacilitatorAmtToBePaid = 
            }else{
                this.facilitatorData[i].PreviousAmountPaid = this.facilitatorData[i].AmountPaid;
            }
            if(/*this.facilitatorData[i].Reason == 'On Leave' || */this.facilitatorData[i].Reason == 'Not to be Paid' || this.facilitatorData[i].Checkbox == false){
                this.facilitatorData[i].FacilitatorAmtToBePaid = 0;
            }
            //this.facilitatorData[i].PreviousAmountPaid = this.facilitatorData[i].AmountPaid;
        }
        //console.log('this.facilitatorData 124 =',JSON.stringify(this.facilitatorData));
        //exit;
        if(status == true) this.generateInvoiceData(); 
        //exit;
        //let nonReason = this.facilitatorData.filter( r => r.Checkbox == true && r.ReasonStatus == false && (r.Reason == '' || !r.Reason));
        //let nonReason = this.facilitatorData.filter( r => r.Checkbox == true && r.copyOfAmtToBePaid != r.FacilitatorAmtToBePaid && r.ReasonStatus == false && (r.Reason == '' || !r.Reason));
        //let ngative = this.facilitatorData.filter( r => r.Checkbox == true && parseInt(r.FacilitatorAmtToBePaid) <= 0 && parseInt(r.FacilitatorAmtToBePaid) >= parseInt(r.copyOfAmtToBePaid));
        //let AmtToBePaid = this.facilitatorData.filter( r => r.Checkbox == true && (r.FacilitatorAmtToBePaid == '' || !r.FacilitatorAmtToBePaid));
        /*console.log('ngative = '+JSON.stringify(ngative));
        exit;
        if(nonReason.length > 0){
            this.isLoading = false;
            this.showToast('error','Please populate a reason for rows where Amount To Be Paid changed');
        }else if(AmtToBePaid.length > 0){
            this.isLoading = false;
            this.showToast('error','Amount To Be Paid should not be empty for checked rows');
        }else if(ngative.length > 0){
            this.isLoading = false;
            this.showToast('error','Please enter valid Amount To Be Paid for checked rows');
        }else{
            this.generateInvoiceData();
        }*/
    }
    generateInvoiceData(){
        generateInvoice({ jsonData:JSON.stringify(this.facilitatorData), salaryMonth:this.selectedMonth, invoiceDate:this.selectedInvoiceDate,
        district:this.selectedDistrict})
        .then(result =>{
            //console.log('generateInvoiceData Result = ',result);
            this.isLoading = false;
            if(result == 'success'){
               this.showToast('success','Payout Proposal generated successfully');
               location.reload();
            }
            else if(result == 'fail')
                this.showToast('error','Something went wrong'); 
        })
        .catch(error =>{
            this.isLoading = false;
            console.log('generateInvoiceData Error = ',error);
            this.showToast('error',error.body.message);
        });
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