import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import autoSaveData from '@salesforce/apex/EndlineFuturePlanningController.autoSaveData';
import SaveAllData from '@salesforce/apex/EndlineFuturePlanningController.SaveAllData';
import calculateForms from '@salesforce/apex/EndlineFuturePlanningController.calculateForms';
import getRecordApt from '@salesforce/apex/EndlineFuturePlanningController.getRecordApt';
import getStudentName from '@salesforce/apex/EndlineFuturePlanningController.getStudentName';
import getAssesmentQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';
import getEndlineRecord from '@salesforce/apex/EndlineAssessmentController.getEndlineRecord';

export default class EndlineFuturePlanning extends NavigationMixin(LightningElement) {
    futurePlanningRecordId;
    lng;
    isEnglish;
    typ;
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';

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
    studentName;



    getRecordAptFun(){
        console.log('$$$ this.studentId: ', this.studentId);
        getRecordApt({
            studentId : this.studentId,
            batchId : this.selectedBatchId
        }).then(result => {
            if(result){
                console.log('$$$ Endline Future Plannning getRecordApt: ', result);

                this.showForm = true;
                this.isLoading = false;
                this.futuerPlanningRecordId = result.Id;
                
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
                //this.studentName = result.Student__r.Name;

                // this.queF1Value = result.F_1__c;
                // this.queF2Value = result.F_2__c;
                // this.queF3Value = result.F_3__c;
                // this.queF4Value = result.F_4__c;
                // this.queF5Value = result.F_5__c;
                // this.queF6Value = result.F_6__c;
                // this.queF7Value = result.F_7__c;
                // this.queF8Value = result.F_8__c;
                // this.queF9Value = result.F_9__c;
                // this.queF10Value = result.F_10__c;
                // this.queF11Value = result.F_11__c;
                // this.queF12Value = result.F_12__c;
                // console.log('result = ',result);
                // console.log('result?.Student__r?.Name =',result.Student__r.name)
                // this.studentName = result?.Student__r?.Name;
                
                /*Array.from(this.template.querySelectorAll('lightning-input'))
                    .forEach(element => {
                        element.checked=false;
                });
                const checkbox = this.template.querySelector('lightning-input[data-value="'+this.que17Value+'"]');
                if(checkbox){
                    checkbox.checked=true;
                }*/
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

                    // this.checkHandler('lightning-input.queF1', this.queF1Value);
                    // this.checkHandler('lightning-input.queF2', this.queF2Value);
                    // this.checkHandler('lightning-input.queF3', this.queF3Value);
                    // this.checkHandler('lightning-input.queF4', this.queF4Value);
                    // this.checkHandler('lightning-input.queF5', this.queF5Value);
                    // this.checkHandler('lightning-input.queF6', this.queF6Value);
                    // this.checkHandler('lightning-input.queF7', this.queF7Value);
                    // this.checkHandler('lightning-input.queF8', this.queF8Value);
                    // this.checkHandler('lightning-input.queF9', this.queF9Value);
                    // this.checkHandler('lightning-input.queF10', this.queF10Value);
                    // this.checkHandler('lightning-input.queF11', this.queF11Value);
                    // this.checkHandler('lightning-input.queF12', this.queF12Value);
                }, 1500);
            }
        }).catch(error => {
            this.showForm = true;
            this.isLoading = false;
            console.log('error123=', error);
            //this.showToastPopMessage(error,'error')

        });
    }
    connectedCallback(){
        if(this.studentId != null){
            this.getAssesmentQuestionFunc();
            this.getRecordAptFun();
            this.delayTimeOut05 = setTimeout(() => {
                this.isLoading=false;
            }, 1500);
        }

        if(this.isEnglish){
            this.feedbackFormTitle = 'Please help us improve this program by giving us honest feedback. To what extent do you agree with each of the following statements :' ;
        }else{
            this.feedbackFormTitle = 'कृपया हमें ईमानदार फीडबेक देकर इस कार्यक्रम को बेहतर बनाने में हमारी सहायता करें। आप निचे दिए गए कथनों से किस हद तक सहमत हैं';
        }
    }

    question17='';
    @track que17Options = [];
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
    @track que18Options = [];
    @track que19Options = [];
    @track que20Options = [];
    @track que21Options = [];
    @track que22Options = [];
    question19 = '';
    question20 = '';
    question21 = '';
    question22 = '';

    // question_F1 = ''
    // question_F2 = ''
    // question_F3 = ''
    // question_F4 = ''
    // question_F5 = ''
    // question_F6 = ''
    // question_F7 = ''
    // question_F8 = ''
    // question_F9 = ''
    // question_F10 = ''
    // question_F11 = ''
    // question_F12 = ''

    // @track queF1Options = [];
    // @track queF2Options = [];
    // @track queF3Options = [];
    // @track queF4Options = [];
    // @track queF5Options = [];
    // @track queF6Options = [];
    // @track queF7Options = [];
    // @track queF8Options = [];
    // @track queF9Options = [];
    // @track queF10Options = [];
    // @track queF11Options = [];
    // @track queF12Options = [];

    // queF1Value = '';
    // queF2Value = '';
    // queF3Value = '';
    // queF4Value = '';
    // queF5Value = '';
    // queF6Value = '';
    // queF7Value = '';
    // queF8Value = '';
    // queF9Value = '';
    // queF10Value = '';
    // queF11Value = '';
    // queF12Value = '';   

    @track feedbackFormTitle = '';

    //This method is called to get all questions
    getAssesmentQuestionFunc(){
        getAssesmentQuestion({
            objectName : 'Future Plannings Endline',
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

                // let queF1 = this.getQuestionsAndOptionsForF(71);
                // if (queF1) {
                //     this.question_F1 = queF1.question;
                //     this.queF1Options = queF1.options;
                // }

                // let queF2 = this.getQuestionsAndOptionsForF(72);
                // if (queF2) {
                //     this.question_F2 = queF2.question;
                //     this.queF2Options = queF2.options;
                // }

                // let queF3 = this.getQuestionsAndOptionsForF(73);
                // if (queF3) {
                //     this.question_F3 = queF3.question;
                //     this.queF3Options = queF3.options;
                // }

                // let queF4 = this.getQuestionsAndOptionsForF(74);
                // if (queF4) {
                //     this.question_F4 = queF4.question;
                //     this.queF4Options = queF4.options;
                // }

                // let queF5 = this.getQuestionsAndOptionsForF(75);
                // if (queF5) {
                //     this.question_F5 = queF5.question;
                //     this.queF5Options = queF5.options;
                // }

                // let queF6 = this.getQuestionsAndOptionsForF(76);
                // if (queF6) {
                //     this.question_F6 = queF6.question;
                //     this.queF6Options = queF6.options;
                // }

                // let queF7 = this.getQuestionsAndOptionsForF(77);
                // if (queF7) {
                //     this.question_F7 = queF7.question;
                //     this.queF7Options = queF7.options;
                // }

                // let queF8 = this.getQuestionsAndOptionsForF(78);
                // if (queF8) {
                //     this.question_F8 = queF8.question;
                //     this.queF8Options = queF8.options;
                // }

                // let queF9 = this.getQuestionsAndOptionsForF(79);
                // if (queF9) {
                //     this.question_F9 = queF9.question;
                //     this.queF9Options = queF9.options;
                // }

                // let queF10 = this.getQuestionsAndOptionsForF(80);
                // if (queF10) {
                //     this.question_F10 = queF10.question;
                //     this.queF10Options = queF10.options;
                // }

                // let queF11 = this.getQuestionsAndOptionsForF(81);
                // if (queF11) {
                //     this.question_F11 = queF11.question;
                //     this.queF11Options = queF11.options;
                // }

                // let queF12 = this.getQuestionsAndOptionsForF(82);
                // if (queF12) {
                //     this.question_F12 = queF12.question;
                //     this.queF12Options = queF12.options;
                // }

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

    getQuestionsAndOptionsForF(seqNumber){
        let que = this.assesmentQuestionAndLabel.find(question => question.Sequence_Number__c === seqNumber);
        let question = '';
        let options = [];
        if(que){
            question = ((this.lng === 'Hindi') ? que.Question_Label_Hindi__c :que.Question_Label_English__c);
            if(que.Assessment_Question_Options__r){
                let optionNames = ['1', '2', '3', '4', '5'];
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
        // else if (futurePlanName === 'queF1') {
        //     let isChecked = this.checkHandler('lightning-input.queF1', event.target.dataset.value);
        //     if (isChecked) this.queF1Value = event.target.dataset.value;
        // } else if (futurePlanName === 'queF2') {
        //     let isChecked = this.checkHandler('lightning-input.queF2', event.target.dataset.value);
        //     if (isChecked) this.queF2Value = event.target.dataset.value;
        // } else if (futurePlanName === 'queF3') {
        //     let isChecked = this.checkHandler('lightning-input.queF3', event.target.dataset.value);
        //     if (isChecked) this.queF3Value = event.target.dataset.value;
        // } else if (futurePlanName === 'queF4') {
        //     let isChecked = this.checkHandler('lightning-input.queF4', event.target.dataset.value);
        //     if (isChecked) this.queF4Value = event.target.dataset.value;
        // } else if (futurePlanName === 'queF5') {
        //     let isChecked = this.checkHandler('lightning-input.queF5', event.target.dataset.value);
        //     if (isChecked) this.queF5Value = event.target.dataset.value;
        // } else if (futurePlanName === 'queF6') {
        //     let isChecked = this.checkHandler('lightning-input.queF6', event.target.dataset.value);
        //     if (isChecked) this.queF6Value = event.target.dataset.value;
        // } else if (futurePlanName === 'queF7') {
        //     let isChecked = this.checkHandler('lightning-input.queF7', event.target.dataset.value);
        //     if (isChecked) this.queF7Value = event.target.dataset.value;
        // } else if (futurePlanName === 'queF8') {
        //     let isChecked = this.checkHandler('lightning-input.queF8', event.target.dataset.value);
        //     if (isChecked) this.queF8Value = event.target.dataset.value;
        // } else if (futurePlanName === 'queF9') {
        //     let isChecked = this.checkHandler('lightning-input.queF9', event.target.dataset.value);
        //     if (isChecked) this.queF9Value = event.target.dataset.value;
        // } else if (futurePlanName === 'queF10') {
        //     let isChecked = this.checkHandler('lightning-input.queF10', event.target.dataset.value);
        //     if (isChecked) this.queF10Value = event.target.dataset.value;
        // } else if (futurePlanName === 'queF11') {
        //     let isChecked = this.checkHandler('lightning-input.queF11', event.target.dataset.value);
        //     if (isChecked) this.queF11Value = event.target.dataset.value;
        // } else if (futurePlanName === 'queF12') {
        //     let isChecked = this.checkHandler('lightning-input.queF12', event.target.dataset.value);
        //     if (isChecked) this.queF12Value = event.target.dataset.value;
        // }
        

        
        // clearTimeout(this.timeoutId);
        // this.timeoutId = setTimeout(this.autoSaveData.bind(this,false), 5000); 
    }
    /*autoSaveData(){
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
            saveFlag : this.saveFlag,
            grade : this.selectedGrade
        }).then(result => {
           console.log('res = ',result);
           var title = 'Endline Planning for Future';
                var msg ='Data is saved for the student';
                if(this.isEnglish === false) {
                    title = 'एंडलाइन भविष्य का नियोजन';
                    msg ='छात्र डेटा सहेजा गया है';
                }
                const event = new ShowToastEvent({
                    title: title,
                    message: msg,
                    variant: 'success'
                });                
                this.dispatchEvent(event);
        }).catch(error => {
            console.log('error=', error);
            var err = error?.body?.message ? error?.body?.message : '';
            this.showToastPopMessage(err,'error')
        });
    }*/
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

            if(currentPageReference.state.studentName !== undefined){
                this.studentName = decodeURI(currentPageReference.state.studentName);
            }else{
                if(this.studentId){
                    getStudentName({
                        stuId : this.studentId
                    }).then(result => {
                        if(result){
                            this.studentName = result.Name;
                        }
                    }).catch(error => {
                        this.showLoading = false;
                        console.log('getStudentName error: ', error);
                    });
                }
            }
          this.typ = decodeURI(currentPageReference.state.typ);
          this.lng = decodeURI(currentPageReference.state.lng);
          this.isEnglish = (this.lng == 'English') ? true : false;
          if(this.isEnglish){
                this.title = 'Endline Planning of Future Data';
                this.errorTitle = 'Error';
                this.successMsg ='Endline Planning of Future - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'एंडलाइन भविष्य का नियोजन डेटा';
                this.errorTitle = 'गलती!';
                this.successMsg ='छात्र डेटा सहेजा गया है';
                this.successTitle = 'Success'
            }
            // console.log('this.studentId = '+this.studentId);
            // console.log('this.cdm1Id = '+this.cdm1Id);
            // console.log('this.cpId = '+this.cpId);
            // console.log('this.csId = '+this.csId);

          if(this.selectedBatchId){
                getBatchCodeName({
                    batchId : this.selectedBatchId
                }).then(result => {
                    this.selectedBatchCode = result.Name;
                    this.selectedBatchNumber = result.Batch_Number__c;
                    // this.schoolName = result.School_Name__r.Name;        
                }).catch(error => {
                    console.log('error 123 = ', error);
                    var err = error?.body?.message ? error?.body?.message : '';
                    this.showToastPopMessage(this.errorTitle,err,'error')
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
                name: 'endline_pff_assesment_V2__c'
            },
            state:{
                fem : encodeURI(this.logedInFacilitatorEmail),
                sch : encodeURI(this.seletedSchoolName),
                grd : encodeURI(this.selectedGrade), 
                bid : encodeURI(this.selectedBatchId),
                acid : encodeURI(this.selectedSchoolAccountId),
                studentId : encodeURI(this.studentId),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }

    // get que22Options(){
    //     return [
    //         {label:'Yes',value:'A'},
    //         {label:'No',value:'B'},
    //         {label:'Not Sure',value:'C'}, 
    //         { label: 'Multiple answers selected', value: '*' },
    //         { label: 'No Answer', value: 'NoAnswer' }
    //     ];
    // }
    // get que21Options(){
    //     return [
    //         {label:'Diploma',value:'A'},
    //         {label:'Apprenticeship',value:'B'},
    //         {label:'Graduation',value:'C'},
    //         {label:'Vocational Certificate Course',value:'D'},
    //         {label:'Work',value:'E'},
    //         {label:'I do not know',value:'F'},
    //         {label:'Nothing',value:'G'},
    //         {label:'I will not be completing my 12th',value:'H'},
    //         {label:'Other',value:'I'},
    //         { label: 'Multiple answers selected', value: '*' },
    //         { label: 'No Answer', value: 'NoAnswer' }
    //     ];
    // }
    // get que20Options(){
    //     return [
    //         {label:'Not required (when you start work you will automatically learn)',value:'A'},
    //         {label:'A few times a year',value:'B'},
    //         {label:'About once a month',value:'C'},
    //         {label:'Many times a month',value:'D'},
    //         {label:'Many times a week/Ongoing basis',value:'E'},
    //         { label: 'Multiple answers selected', value: '*' },
    //         { label: 'No Answer', value: 'NoAnswer' }
    //     ];
    // }
    // get que19Options(){
    //     return [
    //         {label:'I do not know/Not sure',value:'A'},
    //         {label:'It is a homework/assignment for school/college',value:'B'},
    //         {label:'I could get information about my career',value:'C'},
    //         {label:'I could get jobs/internships opportunities',value:'D'},
    //         {label:'Other',value:'E'},
    //         { label: 'Multiple answers selected', value: '*' },
    //         { label: 'No Answer', value: 'NoAnswer' }
    //     ];
    // }
    // get que18Options(){
    //     return [
    //         {label:'Yes',value:'A'},
    //         {label:'No',value:'B'},
    //         {label:'I don’t know/Not sure',value:'C'},
    //         { label: 'Multiple answers selected', value: '*' },
    //         { label: 'No Answer', value: 'NoAnswer' }
    //     ];
    // }
    // get que17Options() {
    //     return [
    //         { label: 'I will be studying because I do not know what I would like to do yet', value: 'A' },
    //         { label: 'I will be studying because the career I want requires a study degree (e.g., diploma /degree).', value: 'B' },
    //         { label: 'I will be studying because my family/friends want me to study', value: 'C' },
    //         { label: 'I will be working because I need to earn for my family', value: 'D' },
    //         { label: 'I will be working because I am not interested in studying further', value: 'E' },
    //         { label: 'I will be working to get some work experience', value: 'F' },
    //         { label: 'I will be both working and studying to earn money', value: 'G' },
    //         { label: 'I will be neither studying nor working as I am not interested in both', value: 'H' },
    //         { label: 'I will be neither studying nor working because my family may not allow me to', value: 'I' },
    //         { label: 'I will be neither studying nor working as I am not sure about my ability to get good marks or a job', value: 'J' },
    //         { label: 'I have not decided what I will do', value: 'K' },
    //         { label: 'Multiple answers selected', value: '*' },
    //         { label: 'No Answer', value: 'NoAnswer' }
    //     ];
    // }

    SaveData(){
        this.isLoading = true;
        console.log('SaveData');
        var formType = {'lng' : this.lng, 'typ' : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1'};

        SaveAllData({
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
            F1 : this.queF1Value,
            F2 : this.queF2Value,
            F3 : this.queF3Value,
            F4 : this.queF4Value,
            F5 : this.queF5Value,
            F6 : this.queF6Value,
            F7 : this.queF7Value,
            F8 : this.queF8Value,
            F9 : this.queF9Value,
            F10 : this.queF10Value,
            F11 : this.queF11Value,
            F12 :  this.queF12Value,
            saveFlag : true, //this.saveFlag,
            grade : this.selectedGrade,
            formType : JSON.stringify(formType),
            batchId : this.selectedBatchId
        }).then(result => {
            this.futuerPlanningRecordId = result;
            console.log('result = ',result)
                const event = new ShowToastEvent({
                    title: this.successTitle,
                    message: this.successMsg,
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                this.backBtnHandler();

        }).catch(error => {
            console.log('error=', error);
            var err = error?.body?.message ? error?.body?.message : '';
            this.showToastPopMessage(this.errorTitle,err,'error')
            this.isLoading=false;
        });
    }

    /*runCalculate(){
        console.log('dddsss=',this.que18_1Value);
        calculateForms({
            studentId : this.studentId,
            CDM1Id : this.cdm1Id,
            CDM2Id : this.cdm2Id,
            cpId : this.cpId,
            csId : this.csId,
            fpId : this.futuerPlanningRecordId
        }).then(result => {
            let saved;
            if(this.isEnglish){
                this.saved = 'Endline Assessment Student Data is saved';
            }else{
                this.saved = 'एंडलाइन मूल्यांकन छात्र डेटा सहेजा गया है';
            }
            //this.showToastPopMessage(this.saved,'success');
            const evt = new ShowToastEvent({
                title: this.successTitle,
                message: this.saved,
                variant: 'success',
            });
            this.dispatchEvent(evt);

            this.isLoading=false;
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
                    acid : encodeURI(this.selectedSchoolAccountId),
                    typ : encodeURI(this.typ),
                    lng : encodeURI(this.lng)
                }
            };
            this[NavigationMixin.Navigate](pageReference);

        }).catch(error => {
            console.log('error=', error);
            var err = error?.body?.message ? error?.body?.message : '';
            this.showToastPopMessage('Calculation Error : '+err,'error')
            this.isLoading=false;
        });
    }*/


    SubmitBtnHandler(){
        if(this.que17Value && this.que18_1Value && this.que18_2Value && this.que18_3Value && this.que18_4Value && this.que18_5Value && this.que18_6Value && this.que18_7Value && this.que18_8Value && this.que18_9Value && this.que18_10Value && this.que18_11Value && this.que19Value && this.que20Value && this.que21Value && this.que22Value){
            
            //this.SaveData();
            getEndlineRecord({
                        studentId : this.studentId,
                        grade : this.selectedGrade,
                        type : 'PFF',
                        batchId : this.selectedBatchId,
                    })
                    .then(result => {
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
                            this.SaveData(); 
                        }
                    }).catch(error => {
                        console.log(error);
                        
                        this.showLoading = false;
                        let rxError;
                        let errorTitle;
                        if(this.isEnglish){
                            errorTitle = 'Endline Planning for Future';
                            rxError = 'Error while receiving student records';
                        }else{
                            errorTitle = 'एंडलाइन भविष्य का नियोजन';
                            rxError = 'छात्र रिकॉर्ड प्राप्त करते समय त्रुटि';
                        }
                        if (Array.isArray(error.body)) {
                            rxError = error.body.map(e => e.message).join(', ');
                        } else if (typeof error.body.message === 'string') {
                            rxError = error.body.message;
                        }
            
                        const event = new ShowToastEvent({
                            title : errorTitle,
                            message : rxError,
                            variant : 'error'
                        });
                        this.dispatchEvent(event);
                    }); 
            
        }else{
            // Create an array to track unanswered questions
            let unansweredQuestions = [];
            let unansweredDFeedbackQuestions = [];

            // Check que17Value
            if (!this.que17Value) {
                unansweredQuestions.push('Q.17');
            }

            // Check que18_1Value to que18_11Value
            if (!this.que18_1Value || !this.que18_2Value || !this.que18_3Value || !this.que18_4Value || !this.que18_5Value || !this.que18_6Value || !this.que18_7Value || !this.que18_8Value || !this.que18_9Value || !this.que18_10Value || !this.que18_11Value) {
                if (!this.que18_1Value) {
                    unansweredQuestions.push('Q.18-i');
                }
                if (!this.que18_2Value) {
                    unansweredQuestions.push('Q.18-ii');
                }
                if (!this.que18_3Value) {
                    unansweredQuestions.push('Q.18-iii');
                }
                if (!this.que18_4Value) {
                    unansweredQuestions.push('Q.18-iv');
                }
                if (!this.que18_5Value) {
                    unansweredQuestions.push('Q.18-v');
                }
                if (!this.que18_6Value) {
                    unansweredQuestions.push('Q.18-vi');
                }
                if (!this.que18_7Value) {
                    unansweredQuestions.push('Q.18-vii');
                }
                if (!this.que18_8Value) {
                    unansweredQuestions.push('Q.18-viii');
                }
                if (!this.que18_9Value) {
                    unansweredQuestions.push('Q.18-ix');
                }
                if (!this.que18_10Value) {
                    unansweredQuestions.push('Q.18-x');
                }
                if (!this.que18_11Value) {
                    unansweredQuestions.push('Q.18-xi');
                }
            }

            // Check que19Value
            if (!this.que19Value) {
                unansweredQuestions.push('Q.19');
            }

            // Check que20Value
            if (!this.que20Value) {
                unansweredQuestions.push('Q.20');
            }

            // Check que21Value
            if (!this.que21Value) {
                unansweredQuestions.push('Q.21');
            }

            // Check que22Value
            if (!this.que22Value) {
                unansweredQuestions.push('Q.22');
            }

            // Repeat the above checks for queF1Value to queF12Value
            // if (!this.queF1Value) {
            //     unansweredDFeedbackQuestions.push('Q.1');
            // }
            // if (!this.queF2Value) {
            //     unansweredDFeedbackQuestions.push('Q.2');
            // }
            // if (!this.queF3Value) {
            //     unansweredDFeedbackQuestions.push('Q.3');
            // }
            // if (!this.queF4Value) {
            //     unansweredDFeedbackQuestions.push('Q.4');
            // }
            // if (!this.queF5Value) {
            //     unansweredDFeedbackQuestions.push('Q.5');
            // }
            // if (!this.queF6Value) {
            //     unansweredDFeedbackQuestions.push('Q.6');
            // }
            // if (!this.queF7Value) {
            //     unansweredDFeedbackQuestions.push('Q.7');
            // }
            // if (!this.queF8Value) {
            //     unansweredDFeedbackQuestions.push('Q.8');
            // }
            // if (!this.queF9Value) {
            //     unansweredDFeedbackQuestions.push('Q.9');
            // }
            // if (!this.queF10Value) {
            //     unansweredDFeedbackQuestions.push('Q.10');
            // }
            // if (!this.queF11Value) {
            //     unansweredDFeedbackQuestions.push('Q.11');
            // }
            // if (!this.queF12Value) {
            //     unansweredDFeedbackQuestions.push('Q.12');
            // }

            var rxError = '';
            if(this.isEnglish){
                rxError = 'Please choose answers for questions: ' + unansweredQuestions.join(', ') ;
                if(unansweredDFeedbackQuestions.length > 0 ){
                    rxError += '; Feedback : '+unansweredDFeedbackQuestions.join(', ')
                }
            }else{
                rxError = 'कृपया प्रश्नों के उत्तर चुनें: ' + unansweredQuestions.join(', ') ;
                if(unansweredDFeedbackQuestions.length > 0 ){
                    rxError += '; फीडबेक : '+ unansweredDFeedbackQuestions.join(', ');
                } 
            }
             this.showToastPopMessage(this.errorTitle,rxError , 'error');
            // this.showToastPopMessage('Please fill all the mandatory(*) fields','error');
        }
    }

    showToastPopMessage(title,messageParam,variantParam){
        const evt = new ShowToastEvent({
            title: title,
            message:messageParam,
            variant: variantParam,
        });
        this.dispatchEvent(evt);
    }
}