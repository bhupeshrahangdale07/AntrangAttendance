import { LightningElement, track, wire, api } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import getStudentData from '@salesforce/apex/midProgramFeedbackController.getStudentData';
import { NavigationMixin } from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import Resource from '@salesforce/resourceUrl/Standard_Icons';
import getMidProgramFeedbackRecord from '@salesforce/apex/midProgramFeedbackController.getMidProgramFeedbackRecord';

const COLS = [
    { label : 'Sr No', fieldName : 'serialNumber',type : 'number', class: ''},
    { label: 'Name',fieldName: 'Name',type: 'text',wrapText: true, class: 'slds-m-left_large'},
    { label: 'Add Assessment Data',fieldName: 'addAssessment',type: 'boolean',wrapText: true, class: 'slds-m-left_large'},
    { label: 'Submission',fieldName: 'intSubmitted',type: 'boolean',wrapText: true, class: 'slds-m-left_large'},
    
];

export default class MidProgramFeedbackV2 extends NavigationMixin(LightningElement) {
    NEWICON = Resource+'/icons/utility-sprite/svg/symbols.svg#new';

    lng;
    typ;
    isEnglish;
    errorTitle;
    totalStudentsOfBatchCount = 0;
    studentCompletedFormCount = 0;
    @api grade = null;
    @api batchCode = null;
    @api batchId = null;
    @api schoolName = null;
    @api schoolId = null;
    @api facilatorEmail = null;
    @api acid = null;
    batchNumber = null;
    realityCount=0;
    @track error;
    @track stuList ;
    rowOffset = 0;
    showLoading = true;
//     @track columns = [{label : 'Sr No', fieldName : 'rowNumber',type : 'number',cellAttributes: { alignment: 'left' },fixedWidth: 90},{
//         label: 'Name',
//         fieldName: 'Name',
//         type: 'text',wrapText: true
//     },{
//         label: 'Submission',
//         fieldName: 'submission',
//         type: 'boolean',wrapText: true
//     }
// ];

    @track rawData;
    @track searchKey = '';

    // @track columns = [
    //     { label : 'Sr No', fieldName : 'serialNumber',type : 'number',cellAttributes: { alignment: 'left' },fixedWidth: 90 },
    //     { label: 'Name',fieldName: 'Name',type: 'text',wrapText: true },
    //     { label: 'Submission',fieldName: 'intSubmitted',type: 'boolean',wrapText: true },
    //     { label: 'Action',fieldName: 'addAssessment',type: 'boolean',wrapText: true }
    // ];
    @track columns = COLS;
    
 get getStudentCount(){
        if(this.totalStudentsOfBatchCount == 0 && this.realityCount == this.totalStudentsOfBatchCount) return true; else return false;
    }
    @wire(CurrentPageReference)
    getCurrentPageRefxerence(currentPageReference) {
        if(currentPageReference) 
        {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.grade = decodeURI(rxCurrentPageReference.state.grd);
            this.batchId = decodeURI(rxCurrentPageReference.state.bid);
            this.cuurrValue =  decodeURI(this.grade);
            this.schoolId = decodeURI(rxCurrentPageReference.state.sch);
            this.facilatorEmail = decodeURI(rxCurrentPageReference.state.fem);
            this.acid = decodeURI(rxCurrentPageReference.state.acid);
            this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;
            this.typ = decodeURI(rxCurrentPageReference.state.typ);
            getBatchCodeName({
                batchId : decodeURI(rxCurrentPageReference.state.bid)
            }).then(result => {
                this.batchCode = result.Name;
                this.batchNumber = result.Batch_Number__c;
            }).catch(error => {
                console.log('error 123 = ', error);
            });
        }
    }
    connectedCallback() {
        this.showLoading = true;
        if(this.isEnglish){
            this.errorTitle = 'Mid Program Feedback';
        }else{
            this.errorTitle = 'मध्य कार्यक्रम प्रतिक्रिया';
        }
        getStudentData({
            batchId : this.batchId,
            grade : this.grade
        }).then(result => {
            const studentDataWrapper = JSON.parse(JSON.stringify(result));
            this.stuList = studentDataWrapper.studentList;
            
            this.stuList.forEach(item => {
                item.submission = false;
                if(item.Self_Awareness_and_Feedbacks__r && item.Self_Awareness_and_Feedbacks__r.length > 0){
                    item.submission = item.Self_Awareness_and_Feedbacks__r[0].Feedback_Form_Submitted__c;
                    if(item.submission == true){
                        this.realityCount++; 
                    }
                }
            });
            console.log( this.realityCount)
            this.stuList.sort((a, b) => b.submission - a.submission || a.Name - b.Name);
            for(var i=0; i<this.stuList.length; i++){
                this.stuList[i].rowNumber = i+1;
            }

            this.rawData = this.stuList && this.stuList.length > 0 ? this.stuList :undefined;
            console.log(studentDataWrapper.studentList);

            this.totalStudentsOfBatchCount = studentDataWrapper.countStudent;
            this.studentCompletedFormCount = this.stuList.length;
            this.showLoading = false;
        }).catch(error => {
            console.log('error 123 = ', error);
            this.showLoading = false;
            const event = new ShowToastEvent({
                message : error,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    handleSearchKeyChange(event) {
        debugger;
        this.searchKey = event.target.value.toLowerCase()?.trim();
        var dt = this.filteredContacts();
        this.stuList = dt && dt.length > 0 ? dt : undefined;
    }

    filteredContacts() {
        return this.rawData.filter(contact =>
            contact?.Name?.toLowerCase().includes(this.searchKey)
        );
    }

    backBtnHandler(event){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'DataEntryDetailPageV2__c'
            },
            state:{
                fem : encodeURI(this.facilatorEmail),
                sch : encodeURI(this.schoolId),
                grd : encodeURI(this.grade), 
                bid : encodeURI(this.batchId),
                acid : encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)   
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }
    addAssementHandler(event){
        /*let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Mid_Program_Feedback_Form_V2__c'
            },
            state:{
                fem : encodeURI(this.facilatorEmail),
                sch : encodeURI(this.schoolId),
                grd : encodeURI(this.grade), 
                bid : encodeURI(this.batchId),
                acid : encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng),
                studentId :  event.target.value    
            }
        };
        this[NavigationMixin.Navigate](pageReference);*/
        var studentId = encodeURI(event.target.value);
        getMidProgramFeedbackRecord({
            studentId : studentId,
            grade : this.grade,
            batchId : this.batchId,
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
                if(this.batchId && this.grade){
                    let pageReference = {
                        type: 'comm__namedPage',
                        attributes: {
                            name: 'Mid_Program_Feedback_Form_V2__c'
                        }, 
                        state:{
                            fem : encodeURI(this.facilatorEmail),
                            sch : encodeURI(this.schoolId),
                            grd : encodeURI(this.grade), 
                            bid : encodeURI(this.batchId),
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
                this.errorTitle = 'Mid Program Feedback';
                this.rxError = 'Error while receiving student records';
            }else{
                this.errorTitle = 'मध्य कार्यक्रम प्रतिक्रिया';
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