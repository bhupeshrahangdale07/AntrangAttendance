import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getStudentRecords from '@salesforce/apex/idSummary.getStudentRecords';
import interestFormType from '@salesforce/apex/idSummary.interestFormType';
import Resource from '@salesforce/resourceUrl/Standard_Icons';
import getInterestRecord from '@salesforce/apex/idSummary.getInterestRecord';

const COLS = [
    { label : 'Sr No', fieldName : 'serialNumber',type : 'number', class: ''},
    { label: 'Name',fieldName: 'Name',type: 'text',wrapText: true, class: 'slds-m-left_large'},
    { label: 'Add Assessment Data',fieldName: 'addAssessment',type: 'boolean',wrapText: true, class: 'slds-m-left_large'},
    { label: 'Submission',fieldName: 'intSubmitted',type: 'boolean',wrapText: true, class: 'slds-m-left_large'},
    
];

// const COLS = [
//     { label : 'Sr No', fieldName : 'serialNumber',type : 'number'},
//     { label: 'Name',fieldName: 'Name',type: 'text',wrapText: true },
//     { label: 'Submission',fieldName: 'intSubmitted',type: 'boolean',wrapText: true },
//     { label: 'Action',fieldName: 'addAssessment',type: 'boolean',wrapText: true }
// ];

export default class InterestAssesment_V2 extends NavigationMixin(LightningElement) {
    NEWICON = Resource+'/icons/utility-sprite/svg/symbols.svg#new';

    lng;
    typ;
    fem = null;
    sch = null;
    grd = null;
    bid = null;
    acid = null;
    //=======================================================//
    antarangImage = logo_01;
    isLoading = false;
    schoolName = null;
    batchName = null;
    batchNumber = '';
    batchTotalStudents = 0;
    countSubmittedStudents = 0;
    //=======================================================//
    @track tableData = [];
    columns = COLS;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;
    isEnglish;
    @track rowData=[];
    interestForm;
    //=======================================================//
     get getStudentCount(){
        if(this.batchTotalStudents == 0 && this.countSubmittedStudents == this.batchTotalStudents) return true; else return false;
    }
    @wire(CurrentPageReference)
    getCurrentPageReference(currentPageReference) {
        if(currentPageReference) {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.fem = decodeURI(rxCurrentPageReference.state.fem);
            this.sch = decodeURI(rxCurrentPageReference.state.sch);
            this.grd = decodeURI(rxCurrentPageReference.state.grd);
            this.bid = decodeURI(rxCurrentPageReference.state.bid);
            this.acid = decodeURI(rxCurrentPageReference.state.acid);
            this.typ = decodeURI(rxCurrentPageReference.state.typ);
            this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;
        }
    }

    //Standard JavaScript connectedCallback() method called on page load
    connectedCallback() {
        this.isLoading = true;
        this.getStudentRecords();
        this.getInterestFormType();
    }

    handleSearchKeyChange(event) {
        debugger;
        this.searchKey = event.target.value.toLowerCase()?.trim();
        var dt = this.filteredContacts();
        this.tableData = dt && dt.length > 0 ? dt : undefined;
    }

    filteredContacts() {
        return this.rowData.filter(contact =>
            contact?.Name?.toLowerCase().includes(this.searchKey)
        );
    }

    getStudentRecords(){
        this.isLoading = true;
        getStudentRecords({
            batchId : this.bid,
            grade : this.grd
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const responseWrapper = JSON.parse(JSON.stringify(result));
            let submittedStudentList = [];
            
            this.countSubmittedStudents = 0;
            if(responseWrapper.submittedStudentList !== undefined)
            {
                this.countSubmittedStudents = responseWrapper.submittedStudentList.length;
                submittedStudentList = responseWrapper.submittedStudentList;
            }

            this.tableData = [];
            if(responseWrapper.gradeStudentList !== undefined)
            {
                if(submittedStudentList.length > 0)
                {
                    let ids = [];
                    let index = 0;
                    submittedStudentList.forEach(item => {
                        item.serialNumber = ++index;
                        item.intSubmitted = true;
                        ids.push(item.Id);
                    });
                    this.tableData = [...submittedStudentList];

                    let totalStudents = responseWrapper.gradeStudentList;                 
                    totalStudents.forEach(item => {                       
                        if(!ids.includes(item.Id))
                        {
                            item.serialNumber = ++index;
                            item.intSubmitted = false;
                            this.tableData.push(item);
                        }
                    });
                    console.log('$$$ If Condition this.tableData: ' + JSON.stringify(this.tableData));
                    this.rowData = this.tableData && this.tableData.length > 0 ? this.tableData : undefined;
                }
                else{
                    this.tableData = responseWrapper.gradeStudentList;
                    let index = 0;
                    this.tableData.forEach(item => {
                        item.serialNumber = ++index;
                        item.intSubmitted = false;
                    });
                    this.rowData = this.tableData && this.tableData.length > 0 ? this.tableData : undefined;
                    console.log('$$$ Else Condition this.tableData: ' + JSON.stringify(this.tableData));
                }
            }

            if(responseWrapper.batchTotalStudents !== undefined)this.batchTotalStudents = responseWrapper.batchTotalStudents;
            if(responseWrapper.batchName !== undefined)this.batchName = responseWrapper.batchName;
            if(responseWrapper.batchNumber !== undefined)this.batchNumber = responseWrapper.batchNumber;
            if(responseWrapper.schoolName !== undefined)this.schoolName = responseWrapper.schoolName;

           
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Interest Summary',
                message: 'Student records received',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */
            this.isLoading = false;

        }).catch(error => {
            this.isLoading = false;
            let rxError = 'Error while receiving student records';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Interest Summary',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    getInterestFormType(){
        interestFormType({
            schoolId : this.acid
        }).then(result => {
            console.log('$$$ Interrest Assessment getInterestFormType: ', result);
            this.interestForm = result;
            if((this.interestForm.Show_Interest_for_G9__c === 'Interest Questions' && this.grd ==='Grade 9') || 
            (this.interestForm.Show_Interest_for_G10__c === 'Interest Questions' && this.grd ==='Grade 10') || 
            (this.interestForm.Show_Interest_for_G11__c === 'Interest Questions' && this.grd ==='Grade 11') || 
            (this.interestForm.Show_Interest_for_G12__c === 'Interest Questions' && this.grd ==='Grade 12')){
                console.log('$$$ Interest_Data_Student_Details_V2__c');
                this.interestFormType = 'Interest_Data_Student_Details_V2__c';
            }else{
                console.log('$$$ ng_form_interest_data_student_details_V2__c');
                this.interestFormType = 'ng_form_interest_data_student_details_V2__c';
            }
            }).catch(error => {
            this.isLoading = false;
            let rxError = 'Error while receiving student records';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Interest Assessment',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    backBtnHandler() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'DataEntryDetailPageV2__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd), 
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng) 
            }
        });
    }

    addAssementHandler(event) {
        // Use the basePath from the Summer '20 module to construct the URL
        /*this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: this.interestFormType
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd), 
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng),
                studentId :   encodeURI(event.target.value) 
            }
        });*/
        var studentId = encodeURI(event.target.value);
        this.showLoading = true;
        getInterestRecord({
            studentId : studentId,
            grade : this.grd,
            batchId : this.bid,
        })
        .then(result => {
            this.showLoading = false;
            if(result === 'found'){
                if(this.isEnglish){
                    const event = new ShowToastEvent({
                        title : 'Error!',
                        message : 'Student data already submitted',
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                    //this.showToastPopMessage('Error!','Student data already submitted','error')
                }else{
                    const event = new ShowToastEvent({
                        title : 'गलती!',
                        message : 'छात्र का डेटा पहले ही जमा किया जा चुका है',
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                    //this.showToastPopMessage('गलती!','छात्र का डेटा पहले ही जमा किया जा चुका है','success');
                }
                location.reload();
            }else{
                if(this.bid && this.grd){
                    let pageReference = {
                        type: 'comm__namedPage',
                        attributes: {
                            name: this.interestFormType
                        }, 
                        state:{
                            fem : encodeURI(this.fem),
                            sch : encodeURI(this.sch),
                            grd : encodeURI(this.grd), 
                            bid : encodeURI(this.bid),
                            acid : encodeURI(this.acid),
                            typ : encodeURI(this.typ),
                            lng : encodeURI(this.lng),
                            studentId :   studentId            
                        }
                    };
                    this[NavigationMixin.Navigate](pageReference);
                }
            }
        }).catch(error => {
            console.log(error);
            
            this.showLoading = false;
            let rxError;
            if(this.isEnglish){
                this.errorTitle = 'Baseline CDM1 Assessment';
                this.rxError = 'Error while receiving student records';
            }else{
                this.errorTitle = 'बेसलाइन सीडीएम1 मूल्यांकन';
                this.rxError = 'छात्र रिकॉर्ड प्राप्त करते समय त्रुटि';
            }
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }

            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : this.rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.tableData];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.tableData = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;

        //Below logic is added by Sunny
        let index = 0;
        this.tableData.forEach(item => {
            item.serialNumber = ++index;
        });
    }
}