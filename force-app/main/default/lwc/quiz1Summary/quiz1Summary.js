import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getStudentRecords from '@salesforce/apex/quiz1Summary.getStudentRecords';

const columns = [
    { label: 'Sr No', fieldName: 'rowNumber',fixedWidth: 90},
    { label: 'Name', fieldName: 'Name',wrapText: true},
    {
        label: 'Submission',
        fieldName: 'submission',
        type: 'boolean',wrapText: true
    }
];

export default class Quiz1Summary extends NavigationMixin(LightningElement) {
    fem = null;
    sch = null;
    grd = null;
    bid = null;
    acid = null;
    realityCount=0;
    //=======================================================//
    flag = '';
    antarangImage = logo_01;
    isLoading = false;
    schoolName = null;
    batchName = null;
    batchNumber=null;
    batchTotalStudents = 0;
    countSubmittedStudents = 0;
    //=======================================================//
    @track tableData = [];
    tableColumns = columns;
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
            console.log('batch ',this.bid);
            console.log('responseWrapper ='+JSON.stringify(result));
            if(responseWrapper.submittedStudentList !== undefined)
            {
                this.tableData = responseWrapper.submittedStudentList;
                console.log('tableData',this.tableData);
                // let index = 0;
                // apexList.forEach(item => {
                //     item.serialNumber = ++index;
                // });
                // this.tableData = apexList;
                if(this.grd == 'Grade 9')
                {this.tableData.forEach(item => {
                    item.submission = false;
                    if(item.Self_Awareness_and_Feedbacks__r && item.Self_Awareness_and_Feedbacks__r.length > 0){
                        item.submission = item.Self_Awareness_and_Feedbacks__r[0].Grade9_Quiz1_Submitted__c;
                        if(item.submission == true){
                            this.realityCount++; 
                        }
                    }
                });}
                if(this.grd == 'Grade 10')
                {this.tableData.forEach(item => {
                    item.submission = false;
                    if(item.Self_Awareness_and_Feedbacks__r && item.Self_Awareness_and_Feedbacks__r.length > 0){
                        item.submission = item.Self_Awareness_and_Feedbacks__r[0].Grade10_Quiz1_Submitted__c;
                        if(item.submission == true){
                            this.realityCount++; 
                        }
                    }
                });}
                this.tableData.sort((a, b) => b.submission - a.submission || a.Name - b.Name);
                for(var i=0; i<this.tableData.length; i++){
                    this.tableData[i].rowNumber = i+1;
                }
            }
            else 
            {
                this.tableData = [];
            }

            this.countSubmittedStudents = this.tableData.length;

            if(responseWrapper.batchTotalStudents !== undefined)this.batchTotalStudents = responseWrapper.batchTotalStudents;
            if(responseWrapper.batchName !== undefined)this.batchName = responseWrapper.batchName;
            if(responseWrapper.batchNumber !== undefined)this.batchNumber = responseWrapper.batchNumber;
            if(responseWrapper.schoolName !== undefined)this.schoolName = responseWrapper.schoolName;

            this.isLoading = false;
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Quiz 1 : Summary',
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
                title : 'Quiz 1 : Summary',
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
                name: 'Quiz_1_Student_details__c'
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
}