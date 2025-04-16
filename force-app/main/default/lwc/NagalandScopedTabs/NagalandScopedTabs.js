import { LightningElement,api, track, wire } from 'lwc';
import fetchAllFields from '@salesforce/apex/Nagaland_DynamicApex.fetchAllFields';
import fetchOptedQnAns from '@salesforce/apex/Nagaland_DynamicApex.fetchOptedQnAns';

export default class NagalandScopedTabs extends LightningElement {

    
    // @api tabsNames = []ß
    @track tabsNames = ['OMR_Assessment__c','Account'];
    @track fieldsFetchedArr = [];
    studentRecordId = '0031m00000QP5nwAAD';
    activeTabApiName = '';

    @wire(fetchAllFields,{sObjectApiName : '$activeTabApiName'}) fetchedFields({data,error}){
        // debugger;
            if(data){
                this.fieldsFetchedArr = [...data];
                this.fetchExistingQnsAns();
            }else if(error){
                console.log(error);
            }
        };

    tabActiveHandler(event){
        // debugger;
        console.log('### Sobject Api Name : '+event.target.value);
        this.activeTabApiName = event.target.value;
    }

    fetchExistingQnsAns(){
        if(this.fieldsFetchedArr.length > 0 && this.activeTabApiName && this.studentRecordId){
            let customWhereClause = ' WHERE ';
            let testArr = ['Name','Student__c','Barcode__c'];
            if(this.activeTabApiName == 'OMR_Assessment__c'){
                customWhereClause+=` Student__c='${this.studentRecordId}'`;
            }
            fetchOptedQnAns({sObjectApiName:this.activeTabApiName,fieldsToFetch:testArr,whereClause:customWhereClause})
                .then((data)=>{
                    console.log(`### Fetched Record : ${data}`);
                }).catch((error)=>{
                    console.log(`### Error :${JSON.stringify(error)}`);
            })
        }
    }

}