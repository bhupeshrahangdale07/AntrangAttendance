import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getStudentData from '@salesforce/apex/OmrCdm1Form5Class.getStudentData';
import { NavigationMixin } from 'lightning/navigation';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';

export default class OmrCdm1Form5 extends NavigationMixin(LightningElement){

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
    totalStudentsOfBatchCount = 0;
    realityCount = 0;

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

        this.getStudentRecords();

        this.flag = 'connectedCallback';
        console.log('this.flag : ' + this.flag);
    }

    getStudentRecords(){
        getStudentData({
            batchId: this.selectedBatchId
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
        }).catch(error => {
            console.log('### Error receieved from apex class : '+JSON.stringify(error));
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
                    name: 'CDM1__c'
                }, 
                state: {
                    fem : encodeURI(this.logedInFacilitatorEmail),
                    sch : encodeURI(this.seletedSchoolName),
                    grd : encodeURI(this.selectedGrade), 
                    bid : encodeURI(this.selectedBatchId), 
                    acid : encodeURI(this.selectedSchoolAccountId) 
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
                name: 'DataEntryDetailPage__c'
            },
            state:{
                fem : encodeURI(this.logedInFacilitatorEmail),
                sch : encodeURI(this.seletedSchoolName),
                grd : encodeURI(this.selectedGrade), 
                bid : encodeURI(this.selectedBatchId),
                acid : encodeURI(this.selectedSchoolAccountId) 
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }
}