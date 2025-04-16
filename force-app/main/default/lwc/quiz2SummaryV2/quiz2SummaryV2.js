import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getStudentRecords from '@salesforce/apex/Quiz2Controller.getStudentRecords';
import getQuiz2Record from '@salesforce/apex/Quiz2Controller.getQuiz2Record';
import Resource from '@salesforce/resourceUrl/Standard_Icons';

const COLS = [
    { label : 'Sr No', fieldName : 'serialNumber',type : 'number', class: ''},
    { label: 'Name',fieldName: 'Name',type: 'text',wrapText: true, class: 'slds-m-left_large'},
    { label: 'Add Assessment Data',fieldName: 'addAssessment',type: 'boolean',wrapText: true, class: 'slds-m-left_large'},
    { label: 'Submission',fieldName: 'intSubmitted',type: 'boolean',wrapText: true, class: 'slds-m-left_large'},
    
];
// const columns = [
//     { label : 'Sr No', fieldName : 'serialNumber',type : 'number',cellAttributes: { alignment: 'left' },fixedWidth: 90 },
//     { label: 'Name',fieldName: 'Name',type: 'text',wrapText: true },
//     { label: 'Submission',fieldName: 'intSubmitted',type: 'boolean',wrapText: true },
//     { label: 'Action',fieldName: 'addAssessment',type: 'boolean',wrapText: true }
// ];

export default class Quiz2SummaryV2 extends NavigationMixin(LightningElement) {
    NEWICON = Resource+'/icons/utility-sprite/svg/symbols.svg#new';
    
    lng;
    isEnglish;
    typ;
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

    @track rawData;
    @track searchKey = '';

    @track columns = COLS;
    //=======================================================//
     get getStudentCount(){
        if(this.batchTotalStudents == 0 && this.realityCount == this.batchTotalStudents) return true; else return false;
    }
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
            this.typ = decodeURI(rxCurrentPageReference.state.typ);
            this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;
        }

        this.flag = 'getCurrentPageReference';
        console.log('this.flag : ' + this.flag);
    }

    //Standard JavaScript connectedCallback() method called on page load
    connectedCallback() {
        this.getStudentRecords();
        this.flag = 'connectedCallback';
        console.log('this.flag : ' + this.flag);
    }

    //This method is called after the triggered event is handled completely
    renderedCallback(){
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
                
                
                /* Commented below code as this code is refering the Self_Awareness_and_Feedbacks__r but Quiz 2 is stored in Self_Awareness_Realities__c
                if(this.grd == 'Grade 9'){
                    this.tableData.forEach(item => {
                        item.submission = false;
                        if(item.Self_Awareness_and_Feedbacks__r && item.Self_Awareness_and_Feedbacks__r.length > 0){
                            item.submission = item.Self_Awareness_and_Feedbacks__r[0].Grade9_Quiz1_Submitted__c;
                            if(item.submission == true){
                                this.realityCount++; 
                            }
                        }
                    });
                }
                if(this.grd == 'Grade 10' && this.grd == 'Grade 11' && this.grd == 'Grade 12'){
                    this.tableData.forEach(item => {
                        item.submission = false;
                        if(item.Self_Awareness_and_Feedbacks__r && item.Self_Awareness_and_Feedbacks__r.length > 0){
                            item.submission = item.Self_Awareness_and_Feedbacks__r[0].Grade10_Quiz1_Submitted__c;
                            if(item.submission == true){
                                this.realityCount++; 
                            }
                        }
                    });
                }
                */
                
                this.tableData.forEach(item => {
                    item.submission = false;
                    if(item.Self_Awareness_Realities__r && item.Self_Awareness_Realities__r.length > 0){
                        item.submission = item.Self_Awareness_Realities__r[0].Quiz_2_Form_Submitted__c;
                        if(item.submission == true){
                            this.realityCount++; 
                        }
                    }
                });
                

                this.tableData.sort((a, b) => b.submission - a.submission || a.Name - b.Name);
                for(var i=0; i<this.tableData.length; i++){
                    this.tableData[i].rowNumber = i+1;
                }
            }
            else 
            {
                this.tableData = [];
            }

            this.rawData = this.tableData && this.tableData.length > 0 ? this.tableData : undefined;
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
            let rxError = '';
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

            if(this.isEnglish){
                const event = new ShowToastEvent({
                    title : 'Quiz 1 : Summary',
                    message : rxError,
                    variant : 'error'
                });
                this.dispatchEvent(event);
            }else{
                const event = new ShowToastEvent({
                    title : 'प्रश्नावली 1 : सारांश',
                    message : rxError,
                    variant : 'error'
                });
                this.dispatchEvent(event);
            }
            
        });
    }

    handleSearchKeyChange(event) {
        debugger;
        this.searchKey = event.target.value.toLowerCase()?.trim();
        var dt = this.filteredContacts();
        this.tableData = dt && dt.length > 0 ? dt : undefined;
    }

    filteredContacts() {
        return this.rawData.filter(contact =>
            contact?.Name?.toLowerCase().includes(this.searchKey)
        );
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
        console.log('Add Assement Button clicked !!!!');
        /*if(this.bid && this.grd){
            let pageReference = {
                type: 'comm__namedPage',
                attributes: {
                    name: 'Quiz_2_Form_V2__c'
                }, 
                state:{
                    fem : encodeURI(this.fem),
                    sch : encodeURI(this.sch),
                    grd : encodeURI(this.grd), 
                    bid : encodeURI(this.bid),
                    acid : encodeURI(this.acid),
                    typ : encodeURI(this.typ),
                    lng : encodeURI(this.lng),
                    studentId :   encodeURI(event.target.value),
                    stdName : encodeURI(event.currentTarget?.dataset?.stdname),               
                }
            };
            this[NavigationMixin.Navigate](pageReference);
        }*/
            var studentId = encodeURI(event.target.value);
            var studentName = encodeURI(event.currentTarget?.dataset?.stdname);
            getQuiz2Record({
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
                        //this.showToastPopMessage('गलती!','छात्र का डेटा पहले ही जमा किया जा चुका है','error');
                    }
                    location.reload();
                }else{
                    if(this.bid && this.grd){
                        let pageReference = {
                            type: 'comm__namedPage',
                            attributes: {
                                name: 'Quiz_2_Form_V2__c'
                            }, 
                            state:{
                                fem : encodeURI(this.fem),
                                sch : encodeURI(this.sch),
                                grd : encodeURI(this.grd), 
                                bid : encodeURI(this.bid),
                                acid : encodeURI(this.acid),
                                typ : encodeURI(this.typ),
                                lng : encodeURI(this.lng),
                                studentId :   studentId,
                                stdName : studentName             
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
                    this.errorTitle = 'Quiz 2';
                    this.rxError = 'Error while receiving student records';
                }else{
                    this.errorTitle = 'प्रश्नावली 2';
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
}