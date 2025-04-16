import { LightningElement,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CmdFormStudentDatatable extends NavigationMixin(LightningElement) {
    @api coloumsDataList = [];
    @api rowsDataList = [];
    @api  selectedStudentGrade = '';
    @api  selectedRecordType = '';
    rowDataNotEmpty = false;

    get tableColoums(){
        if(this.coloumsDataList.length > 0){
            return this.coloumsDataList;
        }
    }

    get tableDataList(){
        console.log('@@@ rowsDataList '+this.rowsDataList);
        if(this.rowsDataList.length > 0){
            this.rowDataNotEmpty = true;
            return this.rowsDataList;
        }
        this.rowDataNotEmpty = false;
        return [];
    }

    studentClickHandler(event){
        let selectedStudentId = event.target.dataset.selectedstudent;
        console.log('### selectedstudent : '+selectedStudentId);
        if(selectedStudentId){
            let pageReference = {
                type: 'comm__namedPage',
                attributes: {
                    name: 'cdm1'
                }, 
                state: {
                    batchId : this.selectedStudentId, 
                    // grade :   this.selectedStudentGrade,
                    recordType : 'baseline'
                }
            };
            this[NavigationMixin.Navigate](pageReference);
        }
    }
    
    
}