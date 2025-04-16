import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getStudentRecords from '@salesforce/apex/idSummary.getStudentRecords';

const columns = [
    { label: 'Sr No', fieldName: 'serialNumber',wrapText: true,fixedWidth: 90},
    { 
        label: 'Name',
        fieldName: 'Name',   
        type: 'text',
        sortable: true,
        wrapText: true
    },
    {
        label: 'Submission', 
        fieldName: 'intSubmitted', 
        type: 'boolean',
        sortable: true ,wrapText: true
    }
];

export default class IdSummary extends NavigationMixin(LightningElement) {
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
    batchNumber = '';
    batchTotalStudents = 0;
    countSubmittedStudents = 0;
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
        }

        this.flag = 'getCurrentPageReference';
        console.log('this.flag : ' + this.flag);
    }

    //Standard JavaScript connectedCallback() method called on page load
    connectedCallback() 
    {
        this.getStudentRecords();

        this.flag = 'connectedCallback';
        console.log('this.flag : ' + this.flag);
    }

    //This method is called after the triggered event is handled completely
    renderedCallback()
    {

        this.flag = 'renderedCallback';
        console.log('this.flag : ' + this.flag);
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
                name: 'DataEntryDetailPage__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd), 
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid) 
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
                name: 'InterestDataStudentDetails__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd), 
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid) 
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