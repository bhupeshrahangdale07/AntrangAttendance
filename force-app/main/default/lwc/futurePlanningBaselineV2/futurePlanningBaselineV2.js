/*
    * ## 1 --- Commented below code to Stop Save for every question
*/

import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import autoSaveData from '@salesforce/apex/BaseLineFuturePlanningController.autoSaveData';
import getRecordApt from '@salesforce/apex/BaseLineFuturePlanningController.getRecordApt';
import getAssesmentQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';
import getStudentName from '@salesforce/apex/AssesementQuestionController.getStudentName';
import submitAndCalculate from '@salesforce/apex/CareerPlanning_A.submitAndCalculate';
import submitAndCalculateA from '@salesforce/apex/careerSkillsEndline.submitAndCalculate';
import submitNCalculate from '@salesforce/apex/BaseLineFuturePlanningController.submitNCalculate';
import submitCDM1ForGrade12 from '@salesforce/apex/careerDecisionMaking_01.submitAndCalculate';
import getObjectId from '@salesforce/apex/BaseLineFuturePlanningController.getObjectId';
import getBaselineRecord from '@salesforce/apex/BaselineAssessmentController.getBaselineRecord';

export default class FuturePlanningBaselineV2 extends NavigationMixin(LightningElement) {
    lng;
    isEnglish;
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';
    typ;
    selectedBatchNumber='';
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
    isLoading = true;
    isShowModal=false;
    cdm1Id='';
    cdm2Id = '';
    cpId = '';
    csId = '';
    fpId = '';

    que17Value = '';
    que18_1Value = '';
    que18_2Value = '';
    que18_3Value = '';
    que18_4Value = '';
    que18_5Value = '';
    que18_6Value = '';
    que18_7Value = '';
    que18_8Value = '';
    que18_9Value = '';
    que18_10Value = '';
    que18_11Value = '';
    que19Value = '';
    que20Value = '';
    que21Value = '';
    que22Value = '';
    studentName='';
    isLoading = true;
    getId(objectApi){
         getObjectId({
            studentId : this.studentId,
            objectApi : objectApi
        }).then(result => {
            if(result)
                if(objectApi == 'OMR_Assessment__c') this.cdm1Id  = result;
                else if(objectApi == 'CDM2__c') this.cdm2Id  = result;
                else if(objectApi == 'Career_Skill__c') this.csId  = result;
                else if(objectApi == 'Future_Planning__c') this.fpId  = result;
                else if(objectApi == 'Career_Planning__c') this.cpId  = result;
         }).catch(error => {
            console.log('objectApi error =', error);
        });
    }
    getRecordAptFun() {
        debugger;

        getRecordApt({
            studentId: this.studentId,
            batchId : this.selectedBatchId,
            grade : this.selectedGrade
        }).then(result => {
            console.log('this.studentId getRecordAptFun = ', this.studentId);
            console.log('getRecordApt result = ', result);
            if (result) {
                this.showForm = true;
                
                this.que17Value = result.Q_17__c;
                this.que18_1Value = result.Q_18_1__c;
                this.que18_2Value = result.Q_18_2__c;
                this.que18_3Value = result.Q_18_3__c;
                this.que18_4Value = result.Q_18_4__c;
                this.que18_5Value = result.Q_18_5__c;
                this.que18_6Value = result.Q_18_6__c;
                this.que18_7Value = result.Q_18_7__c;
                this.que18_8Value = result.Q_18_8__c;
                this.que18_9Value = result.Q_18_9__c;
                this.que18_10Value = result.Q_18_10__c;
                this.que18_11Value = result.Q_18_11__c;
                this.que19Value = result.Q_19__c;
                this.que20Value = result.Q_20__c;
                this.que21Value = result.Q_21__c;
                this.que22Value = result.Q_22__c;
                this.studentName = result.Student__r.Name;
                this.fpId = result.Id;
                setTimeout(() => {
                    this.checkHandler('lightning-input.que17',this.que17Value);
                    this.checkHandler('lightning-input.que18_1',this.que18_1Value);
                    this.checkHandler('lightning-input.que18_2',this.que18_2Value);
                    this.checkHandler('lightning-input.que18_3',this.que18_3Value);
                    this.checkHandler('lightning-input.que18_4',this.que18_4Value);
                    this.checkHandler('lightning-input.que18_5',this.que18_5Value);
                    this.checkHandler('lightning-input.que18_6',this.que18_6Value);
                    this.checkHandler('lightning-input.que18_7',this.que18_7Value);
                    this.checkHandler('lightning-input.que18_8',this.que18_8Value);
                    this.checkHandler('lightning-input.que18_9',this.que18_9Value);
                    this.checkHandler('lightning-input.que18_10',this.que18_10Value);
                    this.checkHandler('lightning-input.que18_11',this.que18_11Value);
                    this.checkHandler('lightning-input.que19',this.que19Value);
                    this.checkHandler('lightning-input.que20',this.que20Value);
                    this.checkHandler('lightning-input.que21',this.que21Value);
                    this.checkHandler('lightning-input.que22',this.que22Value);
                    }, 1000);
                    this.submitFp();
                // if (this.saveFlag === false) {this.isLoading = false;}
                // if (this.saveFlag === true) {
                //     this.isLoading = true;
                //     console.log('this.cpId = ', this.cpId);
                //     console.log('this.cdm1Id = ', this.cdm1Id);
                //     console.log('this.cdm2Id = ', this.cdm2Id);
                //     console.log('this.csId = ', this.csId);
                //     console.log('this.fpId = ', this.fpId);
                //     if (this.cdm1Id == '' || this.cdm1Id == null || this.cdm1Id == undefined) {
                //         this.getId('OMR_Assessment__c');
                //     }
                //     if (this.cdm2Id == '' || this.cdm2Id == null || this.cdm2Id == undefined && this.selectedGrade != 'Grade 12') this.getId('CDM2__c');
                //     if (this.cpId == '' || this.cpId == null || this.cpId == undefined && this.selectedGrade != 'Grade 12') this.getId('Career_Planning__c');
                //     if (this.cdm1Id != '' && this.cdm2Id != '' && this.cpId !='' && this.selectedGrade != 'Grade 12') {
                //         this.submitCDM1();
                //     }else if (this.cdm1Id != '' && this.selectedGrade == 'Grade 12'){
                //         this.submitCDM1ForGrade12();
                //     }
                
                // }

            }
        }).catch(error => {
            this.showForm = true;
            this.isLoading = false;
            console.log('error123=', error);
            //this.showToastPopMessage(error,'error')
        });
    }
    submitCDM1ForGrade12(){
        submitCDM1ForGrade12({
                recordIdCMD1 : this.cdm1Id
            }).then(result => {
                if(result){
                    console.log(result);
                    if(!this.csId)  {
                        this.getId('Career_Skill__c');
                    }
                    if(this.csId)
                        this.submitCS();
                }
            }).catch(error => {
                console.log('error2=', error);
                this.isLoading = false;
                if(this.isEnglish){
                    const evt = new ShowToastEvent({
                        title: this.title,
                        message: 'Error while Saving CDM1, CDM2 and Career Planning Data',
                        variant: 'error',
                    });
                }else{
                    const evt = new ShowToastEvent({
                        title: this.title,
                        message: 'CDM1, CDM2 और कैरियर योजना डेटा सहेजते समय त्रुटि',
                        variant: 'error',
                    });
                }
                this.dispatchEvent(evt);
                this.pageRedirect();
                //this.showToastPopMessage(error,'error')
    
        });
    }
    connectedCallback(){
        if(this.studentId != null){
            this.getAssesmentQuestionFunc();
            this.getRecordAptFun();
            this.delayTimeOut05 = setTimeout(() => {
                this.isLoading=false;
            }, 1000);
        }
    }
    assesmentQuestionAndLabel = [];
    question17='';
    que17Options = [];
    question18='';
    question18_1 = '';
    question18_2 = '';
    question18_3 = '';
    question18_4 = '';
    question18_5 = '';
    question18_6 = '';
    question18_7 = '';
    question18_8 = '';
    question18_9 = '';
    question18_10 = '';
    question18_11 = '';
    que18Options = [];
    que19Options = [];
    que20Options = [];
    que21Options = [];
    que22Options = [];
    question19 = '';
    question20 = '';
    question21 = '';
    question22 = '';
    //This method is called to get all questions
    getAssesmentQuestionFunc(){
        getAssesmentQuestion({
            objectName : 'Future Plannings',
            formType : 'Form V2',
            grade : ''
        }).then(result => {
            console.log('getAssesmentQuestion Result = '+JSON.stringify(result));
            if(result){
                this.assesmentQuestionAndLabel = result;
                let que17 = this.getQuestionsAndOptions(54);
                if(que17){
                    console.log('que17 = ',que17)
                    this.question17 = que17.question;
                    this.que17Options = que17.options;
                }
                let que18 = this.getQuestionsAndOptions(55);
                if(que18){
                    this.question18 = que18.question;
                }
                let que18_1 = this.getQuestionsAndOptions(56);
                if(que18_1){
                    this.question18_1 = que18_1.question;
                    this.que18Options = que18_1.options;
                }

                let que18_2 = this.getQuestionsAndOptions(57);
                if(que18_2){
                    this.question18_2 = que18_2.question;
                }

                let que18_3 = this.getQuestionsAndOptions(58);
                if(que18_3){
                    this.question18_3 = que18_3.question;
                }

                let que18_4 = this.getQuestionsAndOptions(59);
                if(que18_4){
                    this.question18_4 = que18_4.question;
                }
                let que18_5 = this.getQuestionsAndOptions(60);
                if(que18_5){
                    this.question18_5 = que18_5.question;
                }

                let que18_6 = this.getQuestionsAndOptions(61);
                if(que18_6){
                    this.question18_6 = que18_6.question;
                }
                let que18_7 = this.getQuestionsAndOptions(62);
                if(que18_7){
                    this.question18_7 = que18_7.question;
                }
                let que18_8 = this.getQuestionsAndOptions(63);
                if(que18_8){
                    this.question18_8 = que18_8.question;
                }
                let que18_9 = this.getQuestionsAndOptions(64);
                if(que18_9){
                    this.question18_9 = que18_9.question;
                }
                let que18_10 = this.getQuestionsAndOptions(65);
                if(que18_10){
                    this.question18_10 = que18_10.question;
                }
                let que18_11 = this.getQuestionsAndOptions(66);
                if(que18_11){
                    this.question18_11 = que18_11.question;
                }
                let que19 = this.getQuestionsAndOptions(67);
                if(que19){
                    this.question19 = que19.question;
                    this.que19Options = que19.options;
                }
                let que20 = this.getQuestionsAndOptions(68);
                if(que20){
                    this.question20 = que20.question;
                    this.que20Options = que20.options;
                }
                let que21 = this.getQuestionsAndOptions(69);
                if(que21){
                    this.question21 = que21.question;
                    this.que21Options = que21.options;
                }
                let que22 = this.getQuestionsAndOptions(70);
                if(que22){
                    this.question22 = que22.question;
                    this.que22Options = que22.options;
                }


            }
            
        }).catch(error => {
            console.log('getAssesmentQuestion Error = ',error);
        });
    }
    getQuestionsAndOptions(seqNumber){
        let que = this.assesmentQuestionAndLabel.find(question => question.Sequence_Number__c === seqNumber);
        let question = '';
        let options = [];
        if(que){
            question = ((this.lng === 'Hindi') ? que.Question_Label_Hindi__c :que.Question_Label_English__c);
            if(que.Assessment_Question_Options__r){
                let optionNames = ['A', 'B', 'C', 'D', 'E','F','G','H','I','J','K','L','M'];
                let i=0;
                for (let opt of que.Assessment_Question_Options__r) {
                    let optionValue =  (this.lng === 'Hindi') ? opt.Option_Label_Hindi__c :opt.Option_Label_English__c;
                    let optionName = (opt.Option_Label_English__c === 'No Answer') ? 'nil' : (opt.Option_Label_English__c === 'Multiple answers selected') ? '*' : optionNames[i];
                    let option = {label:optionValue,value:optionName }
                    options.push(option);
                    i++;
                }
            }
        }
        return {question,options};
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
    futurePlanningHandler(event){
        debugger;
        console.log('ddd');
        let futurePlanName = event.target.name;
        let value = event.target.value;
        console.log(value);
        if(futurePlanName === 'que17'){
            let isChecked = this.checkHandler('lightning-input.que17',event.target.dataset.value);
            if(isChecked)this.que17Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que18_1') {
            let isChecked = this.checkHandler('lightning-input.que18_1',event.target.dataset.value);
            if(isChecked)this.que18_1Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que18_2') {
            let isChecked = this.checkHandler('lightning-input.que18_2',event.target.dataset.value);
            if(isChecked)this.que18_2Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que18_3') {
            let isChecked = this.checkHandler('lightning-input.que18_3',event.target.dataset.value);
            if(isChecked)this.que18_3Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que18_4') {
            let isChecked = this.checkHandler('lightning-input.que18_4',event.target.dataset.value);
            if(isChecked)this.que18_4Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que18_5') {
            let isChecked = this.checkHandler('lightning-input.que18_5',event.target.dataset.value);
            if(isChecked)this.que18_5Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que18_6') {
            let isChecked = this.checkHandler('lightning-input.que18_6',event.target.dataset.value);
            if(isChecked)this.que18_6Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que18_7') {
            let isChecked = this.checkHandler('lightning-input.que18_7',event.target.dataset.value);
            if(isChecked)this.que18_7Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que18_8') {
            let isChecked = this.checkHandler('lightning-input.que18_8',event.target.dataset.value);
            if(isChecked)this.que18_8Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que18_9') {
            let isChecked = this.checkHandler('lightning-input.que18_9',event.target.dataset.value);
            if(isChecked)this.que18_9Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que18_10') {
            let isChecked = this.checkHandler('lightning-input.que18_10',event.target.dataset.value);
            if(isChecked)this.que18_10Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que18_11') {
            let isChecked = this.checkHandler('lightning-input.que18_11',event.target.dataset.value);
            if(isChecked)this.que18_11Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que19'){
            let isChecked = this.checkHandler('lightning-input.que19',event.target.dataset.value);
            if(isChecked)this.que19Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que20'){
            let isChecked = this.checkHandler('lightning-input.que20',event.target.dataset.value);
            if(isChecked)this.que20Value = event.target.dataset.value;
        } 
        else if(futurePlanName === 'que21'){
            let isChecked = this.checkHandler('lightning-input.que21',event.target.dataset.value);
            if(isChecked)this.que21Value = event.target.dataset.value;
        }
        else if(futurePlanName === 'que22'){
            let isChecked = this.checkHandler('lightning-input.que22',event.target.dataset.value);
            if(isChecked)this.que22Value = event.target.dataset.value;
        }
        
        
        // ## 1 Start
        // clearTimeout(this.timeoutId);
        // this.timeoutId = setTimeout(this.autoSaveData.bind(this,false), 5000); 
        // ## 1 Stop

    }
    
    autoSaveData(){
        console.log('dddsss=',this.que18_1Value);
        autoSaveData({
            studentId : this.studentId,
            fp17:this.que17Value,
            fp18_1:this.que18_1Value,
            fp18_2:this.que18_2Value,
            fp18_3:this.que18_3Value,
            fp18_4:this.que18_4Value,
            fp18_5:this.que18_5Value,
            fp18_6:this.que18_6Value,
            fp18_7:this.que18_7Value,
            fp18_8:this.que18_8Value,
            fp18_9:this.que18_9Value,
            fp18_10:this.que18_10Value,
            fp18_11:this.que18_11Value,
            fp19:this.que19Value,
            fp20:this.que20Value,
            fp21:this.que21Value,
            fp22:this.que22Value,
            saveFlag : true,
            grade : this.selectedGrade,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1',
            lng : this.lng,
            batchId : this.selectedBatchId
        }).then(result => {
            console.log('res = ',result);
             if(this.isEnglish){
                this.saved = 'Baseline Planning For Future - Student data has been saved';
            }else{
                this.saved = 'छात्र डेटा सहेजा गया है';
            }
            var title = 'Success';
            const evt = new ShowToastEvent({
                title: title,
                message: this.saved,
                variant: 'success',
            });
            this.dispatchEvent(evt);
            //this.showToastPopMessage(this.saved,'success');
            this.backBtnHandler();
        }).catch(error => {
            console.log('error=', error);
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
          console.log('studentId = ',this.studentId)
          this.cdm1Id = decodeURI(currentPageReference.state.cdm1Id);
          this.cdm2Id = decodeURI(currentPageReference.state.cdm2Id);
          this.cpId = decodeURI(currentPageReference.state.cpId);
          this.csId = decodeURI(currentPageReference.state.csId);
          this.typ = decodeURI(currentPageReference.state.typ);
          this.lng = decodeURI(currentPageReference.state.lng);
          this.isEnglish = (this.lng == 'English') ? true : false;
            if(this.isEnglish){
                this.title = 'Baseline Planning for Future Data';
                this.errorTitle = 'Error';
                this.successMsg ='Baseline Planning for Future - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'Baseline Planning for Future Data';
                this.errorTitle = 'गलती!';
                this.successMsg ='छात्र डेटा सहेजा गया है';
                this.successTitle = 'Success'
            }
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
            if(this.studentId){
                getStudentName({
                    studId : this.studentId
                }).then(result => {
                    this.studentName = result;       
                }).catch(error => {
                    console.log('error 123 = ', error);
                    this.showToastPopMessage(error,'error')
                });
            }

       }
    }

    
    //Button Handler Functionalities :
    backBtnHandler(event){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'baseline_pff_assesment_V2__c'
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
                studentId : encodeURI(this.studentId),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)

            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }

    showToastPopMessage(title,messageParam,variantParam){
        const evt = new ShowToastEvent({
            title: title,
            message:messageParam,
            variant: variantParam,
        });
        this.dispatchEvent(evt);
    }
    /*get que22Options(){
        return [
            {label:'Yes',value:'A'},
            {label:'No',value:'B'},
            {label:'Not Sure',value:'C'}, 
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }*/
    /*get que21Options(){
        return [
            {label:'Diploma',value:'A'},
            {label:'Apprenticeship',value:'B'},
            {label:'Graduation',value:'C'},
            {label:'Vocational Certificate Course',value:'D'},
            {label:'Work',value:'E'},
            {label:'I do not know',value:'F'},
            {label:'Nothing',value:'G'},
            {label:'I will not be completing my 12th',value:'H'},
            {label:'Other',value:'I'},
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }*>
    /*get que20Options(){
        return [
            {label:'Not required (when you start work you will automatically learn)',value:'A'},
            {label:'A few times a year',value:'B'},
            {label:'About once a month',value:'C'},
            {label:'Many times a month',value:'D'},
            {label:'Many times a week/Ongoing basis',value:'E'},
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }*/
    /*get que19Options(){
        return [
            {label:'I do not know/Not sure',value:'A'},
            {label:'It is a homework/assignment for school/college',value:'B'},
            {label:'I could get information about my career',value:'C'},
            {label:'I could get jobs/internships opportunities',value:'D'},
            {label:'Other',value:'E'},
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }*/
    /*get que18Options(){
        return [
            {label:'Yes',value:'A'},
            {label:'No',value:'B'},
            {label:'I don’t know/Not sure',value:'C'},
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }*/
    /*get que17Options() {
        return [
            { label: 'I will be studying because I do not know what I would like to do yet', value: 'A' },
            { label: 'I will be studying because the career I want requires a study degree (e.g., diploma /degree).', value: 'B' },
            { label: 'I will be studying because my family/friends want me to study', value: 'C' },
            { label: 'I will be working because I need to earn for my family', value: 'D' },
            { label: 'I will be working because I am not interested in studying further', value: 'E' },
            { label: 'I will be working to get some work experience', value: 'F' },
            { label: 'I will be both working and studying to earn money', value: 'G' },
            { label: 'I will be neither studying nor working as I am not interested in both', value: 'H' },
            { label: 'I will be neither studying nor working because my family may not allow me to', value: 'I' },
            { label: 'I will be neither studying nor working as I am not sure about my ability to get good marks or a job', value: 'J' },
            { label: 'I have not decided what I will do', value: 'K' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }*/

    getBlankQuestions(){ 
         const blankQuestions = [];

        if (!this.que17Value) {
            blankQuestions.push("Q-17");
        }

        // Define a function to convert numbers to Roman numerals
        function toRoman(num) {
            const romanNumerals = ["i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x", "xi"];
            return romanNumerals[num-1]; // Subtract 18 to get the correct index
        }

        if (!this.que18_1Value) {
            blankQuestions.push("Q-18." + toRoman(1));
        }

        if (!this.que18_2Value) {
            blankQuestions.push("Q-18." + toRoman(2));
        }

        if (!this.que18_3Value) {
            blankQuestions.push("Q-18." + toRoman(3));
        }

        if (!this.que18_4Value) {
            blankQuestions.push("Q-18." + toRoman(4));
        }

        if (!this.que18_5Value) {
            blankQuestions.push("Q-18." + toRoman(5));
        }

        if (!this.que18_6Value) {
            blankQuestions.push("Q-18." + toRoman(6));
        }

        if (!this.que18_7Value) {
            blankQuestions.push("Q-18." + toRoman(7));
        }

        if (!this.que18_8Value) {
            blankQuestions.push("Q-18." + toRoman(8));
        }

        if (!this.que18_9Value) {
            blankQuestions.push("Q-18." + toRoman(9));
        }

        if (!this.que18_10Value) {
            blankQuestions.push("Q-18." + toRoman(10));
        }

        if (!this.que18_11Value) {
            blankQuestions.push("Q-18." + toRoman(11));
        }

        if (!this.que19Value) {
            blankQuestions.push("Q-19");
        }

        if (!this.que20Value) {
            blankQuestions.push("Q-20");
        }

        if (!this.que21Value) {
            blankQuestions.push("Q-21");
        }

        if (!this.que22Value) {
            blankQuestions.push("Q-22");
        }

        return blankQuestions;
    }

    SubmitBtnHandler(){
        
        this.isLoading = true;
        if(this.que17Value && this.que18_1Value && this.que18_2Value && this.que18_3Value && this.que18_4Value && this.que18_5Value && this.que18_6Value && this.que18_7Value && this.que18_8Value && this.que18_9Value && this.que18_10Value && this.que18_11Value && this.que19Value && this.que20Value && this.que21Value && this.que22Value){
            this.saveFlag = true;
            getBaselineRecord({
                studentId : this.studentId,
                grade : this.selectedGrade ,
                type : 'PFF',
                batchId : this.selectedBatchId,
            })
            .then(result => {
                debugger;
                this.showLoading = false;
                var errorTitle ;
                var rxError;
                console.log('result = '+result);
                if(result === 'found'){
                    if(this.isEnglish){
                        errorTitle = 'Error!';
                        rxError = 'Student data already submitted';
                    }else{
                        errorTitle = 'गलती!';
                        rxError = 'छात्र का डेटा पहले ही जमा किया जा चुका है';
                    }
                    const event = new ShowToastEvent({
                        title : errorTitle,
                        message : rxError,
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                    this.backBtnHandler();
                }else{
                    this.autoSaveData();
                }
            }).catch(error => {
                console.log(error);
                
                this.showLoading = false;
                let rxError;
                if(this.isEnglish){
                    this.errorTitle = 'Baseline CDM2 Assessment';
                    this.rxError = 'Error while receiving student records';
                }else{
                    this.errorTitle = 'बेसलाइन सीडीएम2 मूल्यांकन';
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
            
        }else{
            this.isLoading = false;
            let mandatory;
            var errors = this.getBlankQuestions();
            if(this.isEnglish){
                // this.mandatory = 'Please fill all the mandatory(*) fields';
                this.mandatory = 'Please choose answers for questions: '+errors.join(', ');
            }else{
                // this.mandatory = 'कृपया सभी अनिवार्य(*) फ़ील्ड भरें';
                this.mandatory = 'कृपया प्रश्नों के उत्तर चुनें: '+errors.join(', ');
                
            }
            this.showToastPopMessage(this.errorTitle,this.mandatory,'error');
        }
        //if(this.fpId == '' || this.fpId == null) 
        
    }
    submitFp(){
        console.log('this.fpId test = ',this.fpId)
        submitNCalculate({
                fpId : this.fpId
            }).then(result => {
                if(result){
                    debugger
                    console.log(result);
                    let saved;
                    if(this.isEnglish){
                        this.saved = 'Data is saved for the student';
                    }else{
                        this.saved = 'छात्र डेटा सहेजा गया है';
                    }
                    
                   
                    this.isLoading = false;
                    
                    // //this.showToastPopMessage(this.saved,'success');
                    // const evt = new ShowToastEvent({
                    //     title: this.successTitle,
                    //     message: this.saved,
                    //     variant: 'success',
                    // });
                    // this.dispatchEvent(evt);
                    // //this.showToastPopMessage(this.saved,'success');
                    // this.backBtnHandler();
                }
            }).catch(error => {
                console.log('error3=', error);
                this.showToastPopMessage(this.errorTitle,error,'error')
    
            });
    }
    submitCDM1(){
        submitAndCalculate({
                recordIdCP : this.cpId,
                cdm1Id : this.cdm1Id,
                cdm2Id : this.cdm2Id,
                 lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
            }).then(result => {
                if(result){
                    console.log(result);
                    if(!this.csId)  {
                        this.getId('Career_Skill__c');
                    }
                    if(this.csId)
                        this.submitCS();
                }
            }).catch(error => {
                console.log('error2=', error);
                this.isLoading = false;
                if(this.isEnglish){
                    const evt = new ShowToastEvent({
                        title: this.errorTitle,
                        message: 'Error while Saving CDM1, CDM2 and Career Planning Data',
                        variant: 'error',
                    });
                }else{
                    const evt = new ShowToastEvent({
                        title: this.errorTitle,
                        message: 'CDM1, CDM2 और कैरियर योजना डेटा सहेजते समय त्रुटि',
                        variant: 'error',
                    });
                }
                this.dispatchEvent(evt);
                this.pageRedirect();
                //this.showToastPopMessage(error,'error')
    
            });
    }
    submitCS(){
        submitAndCalculateA({
                recordId : this.csId
            }).then(result => {
                if(result){
                    console.log(result);
                    debugger
                    if(!this.fpId)  {
                        this.getId('Future_Planning__c');
                    }
                    if(this.fpId != '')
                        this.submitFpFunc();
                }
            }).catch(error => {
                this.isLoading=false;
                console.log('error3=', error);
                if(this.isEnglish){
                    const evt = new ShowToastEvent({
                        title: this.errorTitle,
                        message: 'Error while Saving Career Skill Data',
                        variant: 'error',
                    });
                }else{
                    const evt = new ShowToastEvent({
                        title: this.errorTitle,
                        message: 'कैरियर कौशल डेटा सहेजते समय त्रुटि',
                        variant: 'error',
                    });
                }
                
                this.dispatchEvent(evt);
                this.pageRedirect();
    
            });
    }
    submitFpFunc(){
        debugger
        console.log('this.fpId = ',this.fpId)
        submitNCalculate({
                fpId : this.fpId
            }).then(result => {
                //if(result){
                   // console.log(result);
                   let saved;
                    if(this.isEnglish){
                        this.saved = 'Data is saved for the student';
                    }else{
                        this.saved = 'छात्र डेटा सहेजा गया है';
                    }
                    //this.showToastPopMessage(this.saved,'success');
                    const evt = new ShowToastEvent({
                        title: this.successTitle,
                        message: this.successMsg,
                        variant: 'success',
                    });
                    this.dispatchEvent(evt);
                    //this.pageRedirect();
                //}
            }).catch(error => {
                this.isLoading = false;
                console.log('error3=', error);
                //this.showToastPopMessage(error,'error')
                if(this.isEnglish){
                    const evt = new ShowToastEvent({
                        title: this.errorTitle,
                        message: 'Error while Saving Future Planning Data',
                        variant: 'error',
                    });
                }else{
                    const evt = new ShowToastEvent({
                        title: this.errorTitle,
                        message: 'भविष्य योजना डेटा सहेजते समय त्रुटि',
                        variant: 'error',
                    });
                }
                this.dispatchEvent(evt);
                this.pageRedirect();
    
            });
    }
    pageRedirect(){
        setTimeout(() => {
                        let pageReference = {
                        type: 'comm__namedPage',
                        attributes: {
                            name: 'omrCdm1Form5V2__c'
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
                    this.isLoading = false;
                    this[NavigationMixin.Navigate](pageReference);
                    }, 1000);
    }
}