import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import saveData from '@salesforce/apex/EndlineFeedbackController.saveData';
import getRecordApt from '@salesforce/apex/EndlineFeedbackController.getRecordApt';
import submitAndCalculate from '@salesforce/apex/careerPlanning_A_Endline.submitAndCalculate';
import submitAndCalculateA from '@salesforce/apex/careerSkillsEndline.submitAndCalculate';

export default class EndlineFeedback extends NavigationMixin(LightningElement) {
    saveFlag = false;
    antarangImage = logo_01;
    showForm = false;
    selectedBatchId = '';
    selectedGrade = '';
    logedInFacilitatorEmail = '';
    seletedSchoolName = '';
    selectedSchoolAccountId = '';
    selectedBatchCode='';
    studentId = '';
    cdm1Id='';
    cdm2Id = '';
    cpId = '';
    csId = '';
    selectedBatchNumber = '';

    feedback1Value='';
    feedback2Value='';
    feedback3Value='';
    feedback4Value='';
    feedback5Value='';
    feedback6Value='';
    feedback7Value='';
    feedback8Value='';
    feedback9Value='';
    feedback10Value='';
    feedback11Value='';
    feedback12Value='';
    showLoading = true;
    isShowModal=false;
   
    connectedCallback(){
        if(this.studentId != null){
            this.getRecordAptFun();
        }
        this.delayTimeOut05 = setTimeout(() => {
            this.showLoading=false;
        }, 800);
    
    }
    getRecordAptFun(){
        getRecordApt({
            studentId : this.studentId
        }).then(result => {
            if(result){
                this.showLoading = false;
                this.feedback1Value = result.F_1__c;
                this.feedback2Value = result.F_2__c;
                this.feedback3Value = result.F_3__c;
                this.feedback4Value = result.F_4__c;
                this.feedback5Value = result.F_5__c;
                this.feedback6Value = result.F_6__c;
                this.feedback7Value = result.F_7__c;
                this.feedback8Value = result.F_8__c;
                this.feedback9Value = result.F_9__c;
                this.feedback10Value = result.F_10__c;
                this.feedback11Value = result.F_11__c;
                this.feedback12Value = result.F_12__c;
                this.studentName =  result.Student__r.Name;
                setTimeout(() => {
                    this.checkHandler('lightning-input.Feedback1',this.feedback1Value);
                    this.checkHandler('lightning-input.Feedback2',this.feedback2Value);
                    this.checkHandler('lightning-input.Feedback3',this.feedback3Value);
                    this.checkHandler('lightning-input.Feedback4',this.feedback4Value);
                    this.checkHandler('lightning-input.Feedback5',this.feedback5Value);
                    this.checkHandler('lightning-input.Feedback6',this.feedback6Value);
                    this.checkHandler('lightning-input.Feedback7',this.feedback7Value);
                    this.checkHandler('lightning-input.Feedback8',this.feedback8Value);
                    this.checkHandler('lightning-input.Feedback9',this.feedback9Value);
                    this.checkHandler('lightning-input.Feedback10',this.feedback10Value);
                    this.checkHandler('lightning-input.Feedback11',this.feedback11Value);
                    this.checkHandler('lightning-input.Feedback12',this.feedback12Value);
                }, 1000);
            }
        }).catch(error => {
            this.showForm = true;
            this.showLoading = false;
            console.log('error123=', error);
            this.showToastPopMessage(error,'error')

        });
    }
    checkHandler(queString, dataValue){
        Array.from(this.template.querySelectorAll(queString))
            .forEach(element => {
                element.checked=false;
            });
            const checkbox1 = this.template.querySelector(queString+'[data-value="'+dataValue+'"]');
            if(checkbox1){
                checkbox1.checked=true; 
                return true;
            }
    }
    feedbackHandler(event){
        console.log('enter');
        let feedbackName = event.target.name;
        let value = event.target.value;
        console.log(feedbackName);
        console.log(value);

        if(feedbackName === 'Feedback1'){
            let isChecked = this.checkHandler('lightning-input.Feedback1',event.target.dataset.value);
            if(isChecked)this.feedback1Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback2'){
            let isChecked = this.checkHandler('lightning-input.Feedback2',event.target.dataset.value);
            if(isChecked)this.feedback2Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback3'){
            let isChecked = this.checkHandler('lightning-input.Feedback3',event.target.dataset.value);
            if(isChecked)this.feedback3Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback4'){
            let isChecked = this.checkHandler('lightning-input.Feedback4',event.target.dataset.value);
            if(isChecked)this.feedback4Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback5'){
            let isChecked = this.checkHandler('lightning-input.Feedback5',event.target.dataset.value);
            if(isChecked)this.feedback5Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback6'){
            let isChecked = this.checkHandler('lightning-input.Feedback6',event.target.dataset.value);
            if(isChecked)this.feedback6Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback7'){
            let isChecked = this.checkHandler('lightning-input.Feedback7',event.target.dataset.value);
            if(isChecked)this.feedback7Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback8'){
            let isChecked = this.checkHandler('lightning-input.Feedback8',event.target.dataset.value);
            if(isChecked)this.feedback8Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback9'){
            let isChecked = this.checkHandler('lightning-input.Feedback9',event.target.dataset.value);
            if(isChecked)this.feedback9Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback10'){
            let isChecked = this.checkHandler('lightning-input.Feedback10',event.target.dataset.value);
            if(isChecked)this.feedback10Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback11'){
            let isChecked = this.checkHandler('lightning-input.Feedback11',event.target.dataset.value);
            if(isChecked)this.feedback11Value = event.target.dataset.value;
        }
        else if(feedbackName === 'Feedback12'){
            let isChecked = this.checkHandler('lightning-input.Feedback12',event.target.dataset.value);
            if(isChecked)this.feedback12Value = event.target.dataset.value;
        }
        
        clearTimeout(this.timeoutId);
        this.timeoutId = setTimeout(this.saveData.bind(this,false), 5000); 
    }
    saveData(){
        debugger;
        console.log('this.studentId=',this.studentId);
        saveData({
            studentId : this.studentId,
            fd1:this.feedback1Value,
            fd2:this.feedback2Value,
            fd3:this.feedback3Value,
            fd4:this.feedback4Value,
            fd5:this.feedback5Value,
            fd6:this.feedback6Value,
            fd7:this.feedback7Value,
            fd8:this.feedback8Value,
            fd9:this.feedback9Value,
            fd10:this.feedback10Value,
            fd11:this.feedback11Value,
            fd12:this.feedback12Value,
            saveFlag : this.saveFlag,
            grade : this.selectedGrade
        }).then(result => {
           console.log('res = ',result);
        }).catch(error => {
            console.log('error1=', error);
            this.showToastPopMessage(error,'error')
        });
    }
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
       if (currentPageReference) {
          this.selectedBatchId = decodeURI(currentPageReference.state.bid);
          this.selectedGrade = decodeURI(currentPageReference.state.grd);
          this.logedInFacilitatorEmail = decodeURI(currentPageReference.state.fem);
          this.seletedSchoolName = decodeURI(currentPageReference.state.sch);
          this.selectedSchoolAccountId = decodeURI(currentPageReference.state.acid); 
          this.studentId = decodeURI(currentPageReference.state.studentId);
          this.cdm1Id = decodeURI(currentPageReference.state.cdm1Id);
          this.cdm2Id = decodeURI(currentPageReference.state.cdm2Id);
          this.cpId = decodeURI(currentPageReference.state.cpId);
          this.csId = decodeURI(currentPageReference.state.csId);
          console.log('this.studentId = '+this.studentId);
          console.log('this.cdm1Id = '+this.cdm1Id);
          console.log('this.cpId = '+this.cpId);
          console.log('this.csId = '+this.csId);
          if(this.selectedBatchId){
                getBatchCodeName({
                    batchId : this.selectedBatchId
                }).then(result => {
                    this.selectedBatchCode = result.Name;
                    this.selectedBatchNumber = result.Batch_Number__c;
                    // this.schoolName = result.School_Name__r.Name;        
                }).catch(error => {
                    console.log('error 123 = ', error);
                    this.showToastPopMessage(error,'error')
                });
            }

       }
    }

    
    //Button Handler Functionalities :
    backBtnHandler(event){
        console.log('dd');
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Endline_Future_Planning_V2__c'
            },
            state:{
                fem : encodeURI(this.logedInFacilitatorEmail),
                sch : encodeURI(this.seletedSchoolName),
                grd : encodeURI(this.selectedGrade), 
                bid : encodeURI(this.selectedBatchId),
                acid : encodeURI(this.selectedSchoolAccountId),
                cdm1Id :  encodeURI(this.cdm1Id),
                cdm2Id :  encodeURI(this.cdm2Id),
                cpId :  encodeURI(this.cpId),
                csId :  encodeURI(this.csId),
                studentId : encodeURI(this.studentId)
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }

    showToastPopMessage(messageParam,variantParam){
        const evt = new ShowToastEvent({
            title: 'Endline Student Data',
            message:messageParam,
            variant: variantParam,
        });
        this.dispatchEvent(evt);
    }
    backBtnNavigationHelper(){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Endline_Summary_V2__c'
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
    get feedbackOptions() {
        return [
            { label: 'Strongly Disagree', value: '1' },
            { label: 'Disagree', value: '2' },
            { label: 'Neither Agree nor Disagree', value: '3' },
            { label: 'Agree', value: '4' },
            { label: 'Strongly Agree', value: '5' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
    SubmitBtnHandler(){
        if(this.feedback1Value && this.feedback2Value && this.feedback3Value && this.feedback4Value && this.feedback5Value && this.feedback6Value && this.feedback7Value && this.feedback8Value && this.feedback9Value && this.feedback10Value && this.feedback11Value && this.feedback12Value){
            this.saveFlag = true;
            this.saveData();
            submitAndCalculate({
                recordIdCP : this.cpId,
                cdm1Id : this.cdm1Id,
                cdm2Id : this.cdm2Id
            }).then(result => {
                if(result){
                    console.log(result);
                }
            }).catch(error => {
                console.log('error2=', error);
                this.showToastPopMessage(error,'error')
    
            });
            submitAndCalculateA({
                recordId : this.csId
            }).then(result => {
                if(result){
                    console.log(result);
                }
            }).catch(error => {
                console.log('error3=', error);
                this.showToastPopMessage(error,'error')
    
            });
            this.showToastPopMessage('Student Data is saved','success');
            setTimeout(() => {
                this.backBtnNavigationHelper();
            }, 1000);
        }else{
            this.showToastPopMessage('Please fill all the mandatory(*) fields','error');
        }
    }
}