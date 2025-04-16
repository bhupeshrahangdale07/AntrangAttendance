import { LightningElement, track, wire, api } from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import getStudentData from '@salesforce/apex/ApptitudeController.getStudentData';
import { NavigationMixin } from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class ApptitudeDetails extends NavigationMixin(LightningElement) {
    totalStudentsOfBatchCount = 0;
    studentCompletedFormCount = 0;
    @api grade = null;
    @api batchCode = null;
    @api batchId = null;
    @api schoolName = null;
    batchNumber='';
    @api schoolId = null;
    @api facilatorEmail = null;
    @api acid = null;
    @track error;
    @track stuList ;
    rowOffset = 0;
    showLoading = true;
    @track columns = [
        {label : 'Sr No', fieldName : 'rowNumber',type : 'number',fixedWidth: 90,cellAttributes: { alignment: 'left' }},
        {
            label: 'Name',
            fieldName: 'Name',
            type: 'text',wrapText: true,
            sortable: true
        },
        {
            label: 'Submission', 
            fieldName: 'aptSubmitted', wrapText: true,
            type: 'boolean', 
            sortable: true 
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
                this.batchNumber = result.Batch_Number__c;
                this.batchCode = result.Name;
            }).catch(error => {
                console.log('error 123 = ', error);
            });
        }   
    }

    connectedCallback() {
        this.getAptitudeSummary();
    }

    getAptitudeSummary(){
        this.showLoading = true;
        getStudentData({
            batchId : this.batchId
        }).then(result => {
            const studentDataWrapper = JSON.parse(JSON.stringify(result));
            
            // for(var i=0; i<studentDataWrapper.studentList.length; i++){
            //     studentDataWrapper.studentList[i].rowNumber = i+1;
            // }
            // this.stuList = studentDataWrapper.studentList;
            
            this.totalStudentsOfBatchCount = studentDataWrapper.countStudent;
            this.studentCompletedFormCount = studentDataWrapper.studentList.length;

            this.stuList = [];
            if(studentDataWrapper.totalStudentList !== undefined)
            {
                if(studentDataWrapper.studentList.length > 0)
                {
                    let ids = [];
                    let index = 0;
                    studentDataWrapper.studentList.forEach(item => {
                        item.rowNumber = ++index;
                        item.aptSubmitted = true;
                        ids.push(item.Id);
                    });
                    this.stuList = [...studentDataWrapper.studentList];

                    let totalStudents = studentDataWrapper.totalStudentList;                 
                    totalStudents.forEach(item => {                       
                        if(!ids.includes(item.Id))
                        {
                            item.rowNumber = ++index;
                            item.aptSubmitted = false;
                            this.stuList.push(item);
                        }
                    });
                }
                else
                {
                    this.stuList = studentDataWrapper.totalStudentList;
                    let index = 0;
                    this.stuList.forEach(item => {
                        item.rowNumber = ++index;
                        item.aptSubmitted = false;
                    });
                }
            }
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
                name: 'Aptitude_Form__c'
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
        const cloneData = [...this.stuList];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.stuList = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;

        //Below logic is added by Sunny
        let index = 0;
        this.stuList.forEach(item => {
            item.rowNumber = ++index;
        });
    }
}