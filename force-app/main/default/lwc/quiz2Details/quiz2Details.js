import { LightningElement, track, wire, api } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import getStudentData from '@salesforce/apex/Quiz2Controller.getStudentData';
import { NavigationMixin } from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class Quiz2Details extends NavigationMixin(LightningElement) {
    realityCount=0;
    totalStudentsOfBatchCount = 0;
    studentCompletedFormCount = 0;
    batchNumber='';
    @api grade = null;
    @api batchCode = null;
    @api batchId = null;
    @api schoolName = null;
    @api schoolId = null;
    @api facilatorEmail = null;
    @api acid = null;
    @track error;
    @track stuList ;
    rowOffset = 0;
    showLoading = true;
    @track columns = [{label : 'Sr No', fieldName : 'rowNumber',type : 'number',cellAttributes: { alignment: 'left' },fixedWidth: 90},{
        label: 'Name',
        fieldName: 'Name',
        type: 'text',wrapText: true
    },{
        label: 'Submission',
        fieldName: 'submission',
        type: 'boolean',wrapText: true
    }
];
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
            getBatchCodeName({
                batchId : decodeURI(rxCurrentPageReference.state.bid)
            }).then(result => {
                this.batchCode = result.Name;
                this.batchNumber=result.Batch_Number__c;
            }).catch(error => {
                console.log('error 123 = ', error);
            });
        }
        
    }
    connectedCallback() {
        this.showLoading = true;
        getStudentData({
            batchId : this.batchId
        }).then(result => {
            const studentDataWrapper = JSON.parse(JSON.stringify(result));
            this.stuList = studentDataWrapper.studentList;
            
            this.stuList.forEach(item => {
            item.submission = false;
            if(item.Self_Awareness_Realities__r && item.Self_Awareness_Realities__r.length > 0){
                item.submission = item.Self_Awareness_Realities__r[0].Quiz_2_Form_Submitted__c;
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
    backBtnHandler(event){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'DataEntryDetailPage__c'
            },
            state:{
                fem : encodeURI(this.facilatorEmail),
                sch : encodeURI(this.schoolId),
                grd : encodeURI(this.grade), 
                bid : encodeURI(this.batchId),
                acid : encodeURI(this.acid) 
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }
    addAssementHandler(event){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Quiz_2_Form__c'
            },
            state:{
                fem : encodeURI(this.facilatorEmail),
                sch : encodeURI(this.schoolId),
                grd : encodeURI(this.grade), 
                bid : encodeURI(this.batchId),
                acid : encodeURI(this.acid) 
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }
}