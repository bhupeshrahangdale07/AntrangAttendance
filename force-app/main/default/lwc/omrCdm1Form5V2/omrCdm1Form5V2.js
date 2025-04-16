import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getStudentData from '@salesforce/apex/OmrCdm1Form5Class.getStudentDataV2';
import { NavigationMixin } from 'lightning/navigation';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';

export default class OmrCdm1Form5V2 extends NavigationMixin(LightningElement){
    
    @track columns = [{label : 'Sr No', fieldName : 'serialNumber',type : 'number',cellAttributes: { alignment: 'left' },fixedWidth: 90},{
        label: 'Name',
        fieldName: 'Name',
        type: 'text',wrapText: true
    },{
        label: 'Submission',
        fieldName: 'intSubmitted',
        type: 'boolean',wrapText: true
    }
];
    @track tableData = [];
    batchTotalStudents = 0;
    showLoading = true;
    selectedRecordTypeValue = 'Baseline';
    selectedBatchId='';
    selectedGrade = '';
    seletedSchoolName='';
    selectedSchoolAccountId='';
    logedInFacilitatorEmail = '';
    selectedBatchCode = '';
    selectedBatchNumber='';
    @track rowData=[];
    studentCompletedFormCount = 0;
    countSubmittedStudents = 0;
    typ;
    lng;
    isEnglish;
    get getStudentCount(){
        if(this.batchTotalStudents == 0 || this.countSubmittedStudents == this.batchTotalStudents) return true; else return false;
    }
    //For Getting Params from the Url.  
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
        //   this.selectedBatchId = currentPageReference.state?.bid;
        //   this.selectedGrade = currentPageReference.state?.grd;
        //   this.logedInFacilitatorEmail = currentPageReference.state?.fem;
        //   this.seletedSchoolName = currentPageReference.state?.sch;
        //   this.selectedSchoolAccountId = currentPageReference.state?.acid;

          this.selectedBatchId = decodeURI(currentPageReference.state.bid);
          this.selectedGrade = decodeURI(currentPageReference.state.grd);
          this.logedInFacilitatorEmail = decodeURI(currentPageReference.state.fem);
          this.seletedSchoolName = decodeURI(currentPageReference.state.sch);
          this.selectedSchoolAccountId = decodeURI(currentPageReference.state.acid);
           this.typ = decodeURI(currentPageReference.state.typ);
          this.lng = decodeURI(currentPageReference.state.lng);
          this.isEnglish = (this.lng == 'English') ? true : false;
            if(this.selectedBatchId){
                getBatchCodeName({
                    batchId : this.selectedBatchId
                }).then(result => {
                    this.selectedBatchNumber =  result.Batch_Number__c;
                    this.selectedBatchCode = result.Name;
                    // this.schoolName = result.School_Name__r.Name;        
                }).catch(error => {
                    console.log('error 123 = ', error);
                    this.showToastPopMessage(error,'error')
                });
            }
          console.log(' ### Batch id from params : '+this.selectedBatchId);
          console.log('### Batch grade from params : '+this.selectedGrade);
       }
    }

    connectedCallback() {
    
        this.flag = 'connectedCallback';
        console.log('this.flag : ' + this.flag);
         this.getStudentRecords();
    }

    getStudentRecords(){
        /*getStudentData({
            batchId: this.selectedBatchId,
            grade:this.selectedGrade
        }).then(result => {
            // let responseData = [];
            // let studentCompletedCount = 0;
            // let totalStudentsCount = 0;
        
            // console.log(' @@@ data : '+JSON.stringify(data));
            // data.forEach(record =>{
            //     if(( record.OMR_Assessments__r!=null || record.OMR_Assessments__r!=undefined)
            //         && ( record.CDM2__r!=null || record.CDM2__r!=undefined)
            //         && ( record.Career_Plannings__r!=null || record.Career_Plannings__r!=undefined)){
            //             let row = {
            //                         serialNumber : studentCompletedCount+1+'',
            //                         studentName :  record.Name
            //                     }
            //             responseData.push(row);
            //             console.log('### responseData : '+responseData);
            //             studentCompletedCount +=1;
            //             totalStudentsCount +=1;
            //     }else{
            //         totalStudentsCount +=1;
            //     }
                
            //     this.rowData = result;
            //     this.studentCompletedFormCount = studentCompletedCount;
            //     this.totalStudentsOfBatchCount = totalStudentsCount;
            // })
            const studentDataWrapper = JSON.parse(JSON.stringify(result));
            this.stuList = studentDataWrapper.studentList;
            
            this.stuList.forEach(item => {
            item.submission = false;
                if(item.OMR_Assessments__r && item.OMR_Assessments__r.length > 0 && item.CDM2__r && item.CDM2__r.length > 0 && item.Career_Plannings__r && item.Career_Plannings__r.length > 0){
                    item.submission = true;
                    this.realityCount++; 
                }
               
            });
           
            console.log( this.realityCount)
            this.stuList.sort((a, b) => b.submission - a.submission || a.Name - b.Name);
            for(var i=0; i<this.stuList.length; i++){
                this.stuList[i].rowNumber = i+1;
            }
            this.totalStudentsOfBatchCount = studentDataWrapper.countStudent;
            console.log(studentDataWrapper.studentList);
            this.showLoading = false;
        }).catch(error => {
            console.log('### Error receieved from apex class : '+JSON.stringify(error));
        });*/
        console.log(this.selectedBatchId);
        getStudentData({
            batchId : this.selectedBatchId,
            grade : this.selectedGrade
        }).then(result => {
            debugger
            console.log('result getStudentDataV2: ' + JSON.stringify(result));
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

            this.showLoading = false;
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
            this.showLoading = false;
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

    // @wire(fetchStudentForCmd1Form,{selBatchIdFromParams:'$selectedBatchId',selectedRecordType:'$selectedRecordTypeValue'})
    // fetchedStudents({data,error}){    
    //     if(data){
    //         let responseData = [];
    //         let studentCompletedCount = 0;
    //         let totalStudentsCount = 0;
        
    //         console.log(' @@@ data : '+JSON.stringify(data));
    //         data.forEach(record =>{
    //             if(( record.OMR_Assessments__r!=null || record.OMR_Assessments__r!=undefined)
    //                 && ( record.CDM2__r!=null || record.CDM2__r!=undefined)
    //                 && ( record.Career_Plannings__r!=null || record.Career_Plannings__r!=undefined)){
    //                     let row = {
    //                                 serialNumber : studentCompletedCount+1+'',
    //                                 studentName :  record.Name
    //                             }
    //                     responseData.push(row);
    //                     console.log('### responseData : '+responseData);
    //                     studentCompletedCount +=1;
    //                     totalStudentsCount +=1;
    //             }else{
    //                 totalStudentsCount +=1;
    //             }
                
    //             this.rowData = [...responseData];
    //             this.studentCompletedFormCount = studentCompletedCount;
    //             this.totalStudentsOfBatchCount = totalStudentsCount;
    //         })
        
    //     }else{
    //         console.log('### Error receieved from apex class : '+JSON.stringify(error)); 
    //     }
    // }    
    
    addAssementHandler(event){
        console.log('Add Assement Button clicked !!!!s');
        if(this.selectedBatchId && this.selectedGrade){
            let pageReference = {
                type: 'comm__namedPage',
                attributes: {
                    name: 'CDM1_V2__c'
                }, 
                state: {
                    fem : encodeURI(this.logedInFacilitatorEmail),
                    sch : encodeURI(this.seletedSchoolName),
                    grd : encodeURI(this.selectedGrade), 
                    bid : encodeURI(this.selectedBatchId), 
                    acid : encodeURI(this.selectedSchoolAccountId),
                    typ : encodeURI(this.typ),
                    lng : encodeURI(this.lng)   
                }
            };
            this[NavigationMixin.Navigate](pageReference);
        }
    }

    backBtnHandler(event){
        console.log('Back Button clicked !!!!');
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'DataEntryDetailPageV2__c'
            },
            state:{
                fem : encodeURI(this.logedInFacilitatorEmail),
                sch : encodeURI(this.seletedSchoolName),
                grd : encodeURI(this.selectedGrade), 
                bid : encodeURI(this.selectedBatchId),
                acid : encodeURI(this.selectedSchoolAccountId),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)  
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }
}