import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getStudentRecords from '@salesforce/apex/endlineSummary.getStudentRecords';

const columns = [
    { label: 'Sr No', fieldName: 'serialNumber',wrapText: true},
    { 
        label: 'Name',
        fieldName: 'Name',   
        type: 'text',
        sortable: true,wrapText: true
    },
    {
        label: 'Submission', 
        fieldName: 'intSubmitted', 
        type: 'boolean', 
        sortable: true,wrapText: true
    }
];

export default class EndlineSummaryV2 extends NavigationMixin(LightningElement) {
    lng;
    typ;
    isEnglish;
    errorTitle = '';
    fem = null;
    sch = null;
    grd = null;
    bid = null;
    acid = null;
    //=======================================================//
    flag = '';
    antarangImage = logo_01;
    isLoading = false;
    schoolName = null;
    batchName = null;
    batchTotalStudents = 0;
    countSubmittedStudents = 0;
    batchNumber=null;
    //=======================================================//
    @track tableData = [];
    tableColumns = columns;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;
    //=======================================================//
    @wire(CurrentPageReference)
    getCurrentPageReference(currentPageReference) {
        if(currentPageReference) 
        {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.fem = decodeURI(rxCurrentPageReference.state.fem);
            this.sch = decodeURI(rxCurrentPageReference.state.sch);
            this.grd = decodeURI(rxCurrentPageReference.state.grd);
            this.bid = decodeURI(rxCurrentPageReference.state.bid);
            this.acid = decodeURI(rxCurrentPageReference.state.acid);
            this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;
            this.typ = decodeURI(rxCurrentPageReference.state.typ);
        }

        this.flag = 'getCurrentPageReference';
        console.log('this.flag : ' + this.flag);
    }

    //Standard JavaScript connectedCallback() method called on page load
    connectedCallback() 
    {
        this.getStudentRecords();
        if(this.isEnglish){
            this.errorTitle = 'Endline Assessment';
        }else{
            // this.errorTitle = 'समाप्ति गधू';
            this.errorTitle = 'एंडलाइन मूल्यांकन';
        }
        this.flag = 'connectedCallback';
        console.log('this.flag : ' + this.flag);
    }
    get getStudentCount(){
        if(this.batchTotalStudents == 0 || this.countSubmittedStudents == this.batchTotalStudents) return true; else return false;
    }
    //This method is called after the triggered event is handled completely
    renderedCallback()
    {

        this.flag = 'renderedCallback';
        console.log('this.flag : ' + this.flag);
    }

    getStudentRecords(){
        console.log('enter')
        this.isLoading = true;
        getStudentRecords({
            batchId : this.bid,
            grade : this.grd,
            typ : 'Form V2'
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
                }
                else
                {
                    this.tableData = responseWrapper.gradeStudentList;
                    let index = 0;
                    this.tableData.forEach(item => {
                        item.serialNumber = ++index;
                        item.intSubmitted = false;
                    });
                }
            }

            if(responseWrapper.batchTotalStudents !== undefined)this.batchTotalStudents = responseWrapper.batchTotalStudents;
            if(responseWrapper.batchName !== undefined)this.batchName = responseWrapper.batchName;
            if(responseWrapper.batchNumber !== undefined)this.batchNumber = responseWrapper.batchNumber;
            if(responseWrapper.schoolName !== undefined)this.schoolName = responseWrapper.schoolName;

            this.isLoading = false;
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Interest Summary',
                message: 'Student records received',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'getStudentRecords';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            console.log('error student = ',error)
            this.isLoading = false;
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while receiving student records';
            }else{
                this.rxError = 'छात्र रिकॉर्ड प्राप्त करते समय त्रुटि';
            }
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : this.rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    handleBackButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'backButton')
        {
            this.backNavigateToInternalPage();
        }

        this.flag = 'handleBackButton';
        console.log('this.flag : ' + this.flag);
    }

    backNavigateToInternalPage() {
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

    addAssementHandler(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'addAssement')
        {
            this.nextNavigateToInternalPage();
        }

        this.flag = 'addAssementHandler';
        console.log('this.flag : ' + this.flag);
    }

    nextNavigateToInternalPage() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'CDM1_Endline_V2__c'
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