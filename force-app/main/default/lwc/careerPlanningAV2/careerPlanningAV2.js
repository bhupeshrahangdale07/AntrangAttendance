/*
    * ## 1 --- Commented below code to Stop Save for every question
*/

import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getApexRecord from '@salesforce/apex/CareerPlanning_A.getApexRecord';
import saveSingle from '@salesforce/apex/CareerPlanning_A.saveSingle';
import saveQuestion09 from '@salesforce/apex/CareerPlanning_A.saveQuestion09';
import saveAllQA from '@salesforce/apex/CareerPlanning_A.saveAllQA';
import submitAndCalculate from '@salesforce/apex/CareerPlanning_A.submitAndCalculate';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import getAssesmentQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';
import getBaselineRecord from '@salesforce/apex/BaselineAssessmentController.getBaselineRecord';

export default class CareerPlanningAV2 extends NavigationMixin(LightningElement) {
    lng;
    isEnglish;
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';
    placeHoldervalue = '';
    typ;
    //=======================================================//
    rxStudentId = null;
    rxStudentGrade = null;    
    cdm1Id = null;
    cdm2Id = null;
    fem = null;
    sch = null;
    grd = null;
    bid = null;
    acid = null;
    batchNumber= null;
    //=======================================================//
    flag = '';
    antarangImage = logo_01;
    isLoading = true;
    studentName = null;
    //studentGrade = null;
    studentBarcode = null;
    @track freeze = true;
    cpRecordId = null;
    //=======================================================//
    delay = 5000;   //Delay = 5 sec
    
    
    // ## 1 Start
    // delayTimeOut07;
    // delayTimeOut08;
    // delayTimeOut09;
    // delayTimeOut10;
    // ## 1 Stop

    //=======================================================//
    saveAllDone = false;
    submitDone = false;
    //=======================================================//
    question07 = '';
    initAnswer07 = '';
    @track q07_Options = [];
    //=======================================================//
    question08 = '';
    initAnswer08 = '';
    @track q08_Options = [];
    //=======================================================//
    /*get getGrade(){
        return this.grd === 'Grade 10';
    }*/
   
    q09PicklistOptions = [];
    /*get q09PicklistOptions() {
        return [
            { label: ' ', value: '' },
            { label: 'Yes', value: 'A' },
            { label: 'No', value: 'B' },
            { label: 'I don\'t know', value: 'C' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'nil' },
        ];
    }*/

    question09 = '';
    initAnswer09 = [];
    @track q09_Options = [];
    //=======================================================//
    question10 = '';
    initAnswer10 = '';
    @track q10_Options = [];
    //=======================================================//
    @wire(CurrentPageReference)
    getCurrentPageReference(currentPageReference) {
        if(currentPageReference) 
        {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.rxStudentId = rxCurrentPageReference.state.studentId;
            this.cdm1Id = rxCurrentPageReference.state.cdm1Id;
            this.cdm2Id = rxCurrentPageReference.state.cdm2Id;
            console.log('cdm2Id = ',this.cdm2Id)
            this.fem = decodeURI(rxCurrentPageReference.state.fem);
            this.sch = decodeURI(rxCurrentPageReference.state.sch);
            this.grd = decodeURI(rxCurrentPageReference.state.grd);
            this.bid = decodeURI(rxCurrentPageReference.state.bid);
            this.acid = decodeURI(rxCurrentPageReference.state.acid);
            this.typ = decodeURI(rxCurrentPageReference.state.typ);
            this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;
            if(this.isEnglish){
                this.title = 'Baseline Career Planning Data';
                this.errorTitle = 'Error';
                this.successMsg ='Baseline Career Planning - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'आधारभूत करियर नियोजन डेटा';
                this.errorTitle = 'गलती!';
                this.successMsg ='छात्र डेटा सहेजा गया है';
                this.successTitle = 'Success'
            }
            getBatchCodeName({
                batchId : decodeURI(rxCurrentPageReference.state.bid)
            }).then(result => {
                this.batchCode = result.Name;
                this.batchNumber = result.Batch_Number__c;
            }).catch(error => {
                console.log('error 123 = ', error);
            });
        }

        this.flag = 'getCurrentPageReference';
        console.log('this.flag : ' + this.flag);
    }

    connectedCallback() {
         this.getAssesmentQuestionFunc();
        this.getApexRecordCP();
        if(this.isEnglish){
            this.placeHoldervalue = 'Select an Option';
        }else{
            this.placeHoldervalue = 'कोई विकल्प चुनें';
        }
        this.flag = 'connectedCallback';
        console.log('this.flag : ' + this.flag);
    }
    //This method is called to get all questions
    getAssesmentQuestionFunc(){
        getAssesmentQuestion({
            objectName : 'Career Planning',
            formType : 'Form V2',
            grade : ''
        }).then(result => {
            console.log('getAssesmentQuestion Result = '+JSON.stringify(result));
            if(result){
                this.assesmentQuestionAndLabel = result;
                let que7 = this.getQuestionsAndOptions(19);
                if(que7){
                    this.question07 = que7.question;
                    this.q07_Options = que7.options;
                }
                let que8 = this.getQuestionsAndOptions(20);
                if(que8){
                    this.question08 = que8.question;
                    this.q08_Options = que8.options;
                    console.log('this.q08_Options = ',this.q08_Options)
                }
                let que9 = this.getQuestionsAndOptions(21);
                if(que9){
                    this.question09 = que9.question;
                }
                var j=1;
                let temp = [];
                for(var i=22;i<=28;i++){
                    let que10 = this.getQuestionsAndOptions(i);
                    console.log('que10 = ',que10)
                    if(que10){
                        
                        let opt = {optionName:j, answer: '',optionValue:que10.question};
                        console.log('opt = ',opt)
                        temp = [...temp, opt];
                        j++;
                        if(i===22) {
                            let nil=' ';
                            let opt={label:'',value: ''};
                            this.q09PicklistOptions = que10.options;
                            this.q09PicklistOptions.unshift(opt);
                            //this.q09PicklistOptions = que10.options;
                        }
                    }
                }
                this.q09_Options = [...temp]
                let que11 = this.getQuestionsAndOptions(29);
                if(que11){
                    this.question10 = que11.question;
                    this.q10_Options = que11.options;
                }
            }
            console.log('q09PicklistOptions = ',this.q09PicklistOptions)
            
        }).catch(error => {
            console.log('getAssesmentQuestion Error = ',error);
        });
    }
    getQuestionsAndOptions(seqNumber){
        let que = this.assesmentQuestionAndLabel.find(question => question.Sequence_Number__c === seqNumber);
        let question = '';
        let options = [];
        if(que){
            question =(this.lng === 'Hindi') ? que.Question_Label_Hindi__c :que.Question_Label_English__c;
            if(que.Assessment_Question_Options__r){
                let optionNames = ['A', 'B', 'C', 'D', 'E','F','G','H','I','J','K','L','M','N'];
                let i=0;
                for (let opt of que.Assessment_Question_Options__r) {
                    let optionValue =  (this.lng === 'Hindi') ? opt.Option_Label_Hindi__c :opt.Option_Label_English__c;
                    let optionName = (opt.Option_Label_English__c === 'No Answer') ? 'nil' : (opt.Option_Label_English__c === 'Multiple answers selected') ? '*' :  optionNames[i];
                    let option = (seqNumber === 22) ? {label: optionValue , value: optionName} :{optionName:optionName, answer: false,optionValue:optionValue }
                    options.push(option);
                    i++;
                }
            }
        }
        return {question,options};
    }
    renderedCallback()
    {
        if(this.saveAllDone)
        {
           // this.submit();   
            this.saveAllDone = false;
        }

        if(this.submitDone)
        {
            this.backNavigateToInternalPage();
            this.submitDone = false;
        }

        this.flag = 'renderedCallback';
        console.log('this.flag : ' + this.flag);
    }

    getApexRecordCP(){
        getApexRecord({
            studentId : this.rxStudentId,
            grade : this.grd,
            batchId : this.bid
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const singleRecordWrapper = JSON.parse(JSON.stringify(result));
            if(singleRecordWrapper.studentBarcode !== undefined)
            {
                this.studentBarcode = singleRecordWrapper.studentBarcode;
            }
            else this.studentBarcode = null;

            if(singleRecordWrapper.studentName !== undefined)this.studentName = singleRecordWrapper.studentName;
            //if(singleRecordWrapper.studentGrade !== undefined)this.studentGrade = singleRecordWrapper.studentGrade;
            //===========================================================//
            do{
                if(singleRecordWrapper.apexRecord === undefined || 
                    singleRecordWrapper.apexRecord === null)
                {
                    //console.log('CP record does not exist');
                    this.freeze = false;
                    this.isLoading = false;
                    break;
                }

                const record = singleRecordWrapper.apexRecord;

                if(record.Form_Submitted__c)this.freeze = true;
                else this.freeze = false;

                this.cpRecordId = record.Id;
                
                //Place init for question07 here
                this.initAnswer07 = record.Q_7__c;

                let foundAns07 = false;
                for(let key in this.q07_Options){
                    if(this.q07_Options[key].optionName === record.Q_7__c)
                    {
                        this.q07_Options[key].answer = true;
                        foundAns07 = true;
                    }
                }

                if(!foundAns07)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q07_Options){
                            if(this.q07_Options[key].optionName === 'nil')
                            {
                                this.q07_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                } 
                //Place init for question08 here
                this.initAnswer08 = record.Q_8__c;

                let foundAns08 = false;
                for(let key in this.q08_Options){
                    if(this.q08_Options[key].optionName === record.Q_8__c)
                    {
                        this.q08_Options[key].answer = true;
                        foundAns08 = true;
                    }
                }

                if(!foundAns08)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q08_Options){
                            if(this.q08_Options[key].optionName === 'nil')
                            {
                                this.q08_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                } 
                //Place init for question09 here 
                if(record.Q_9_1__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_1__c);

                if(record.Q_9_2__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_2__c);

                if(record.Q_9_3__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_3__c);

                if(record.Q_9_4__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_4__c);

                if(record.Q_9_5__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_5__c);

                if(record.Q_9_6__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_6__c);

                if(record.Q_9_7__c === undefined)this.initAnswer09.push('');
                else this.initAnswer09.push(record.Q_9_7__c);

                let validAns = ['A','B','C','*'];
                let foundAns09 = [];
                for(let x = 0; x < this.initAnswer09.length; x++) { //this.initAnswer09.length is important here
                    if(this.initAnswer09[x] !== '' && validAns.includes(this.initAnswer09[x]))
                    {
                        this.q09_Options[x].answer = this.initAnswer09[x];
                        foundAns09[x] = true;
                    }
                    else 
                    {
                        foundAns09[x] = false;
                    }
                }

                if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                {
                    for(let x = 0; x < foundAns09.length; x++)
                    {
                        if(!foundAns09[x])
                        {
                            this.q09_Options[x].answer = 'nil';
                        }
                    }
                }
                //Place init for question10 here
                this.initAnswer10 = record.Q_10__c;

                let foundAns10 = false;
                for(let key in this.q10_Options){
                    if(this.q10_Options[key].optionName === record.Q_10__c)
                    {
                        this.q10_Options[key].answer = true;
                        foundAns10 = true;
                    }
                }

                if(!foundAns10)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q10_Options){
                            if(this.q10_Options[key].optionName === 'nil')
                            {
                                this.q10_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                } 
                //===========================================================//
                this.isLoading = false;
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Career Planning',
                    message: 'Career Planning record fields received successfuly',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
            }while(false);
            this.flag = 'getApexRecordCP';
            console.log('this.flag : ' + this.flag);
        }).catch(error => {
            this.isLoading = false;
            let rxError;
            if(this.isEnglish){
            this.rxError = 'Error while recieving record fields: Career Planning';
            }else{
                this.rxError = 'रिकॉर्ड फ़ील्ड प्राप्त करते समय त्रुटि: करियर नियोजन-ए';
            }
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    } 

    reInitializeRecordCP(){
        getApexRecord({
            studentId : this.rxStudentId,
            grade : this.grd
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const singleRecordWrapper = JSON.parse(JSON.stringify(result));
            //===========================================================//
            const record = singleRecordWrapper.apexRecord;

            if(record.Form_Submitted__c)this.freeze = true;
            else this.freeze = false;
            
            //Place init for question07 here
            this.initAnswer07 = record.Q_7__c;
            //Place init for question08 here
            this.initAnswer08 = record.Q_8__c;
            //Place init for question09 here 
            this.initAnswer09 = [];
            if(record.Q_9_1__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_1__c);

            if(record.Q_9_2__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_2__c);

            if(record.Q_9_3__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_3__c);

            if(record.Q_9_4__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_4__c);

            if(record.Q_9_5__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_5__c);

            if(record.Q_9_6__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_6__c);

            if(record.Q_9_7__c === undefined)this.initAnswer09.push('');
            else this.initAnswer09.push(record.Q_9_7__c);
            //Place init for question10 here
            this.initAnswer10 = record.Q_10__c;
            //===========================================================//
            this.flag = 'reInitializeRecordCP';
            console.log('this.flag : ' + this.flag);
        }).catch(error => {
            console.log('error = ',error)
            this.isLoading = false;
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while recieving record fields: Career Planning';
            }else{
                this.rxError = 'रिकॉर्ड फ़ील्ड प्राप्त करते समय त्रुटि: करियर नियोजन-ए';
            }
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    q07GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q07_Options){
            if(this.q07_Options[key].answer)
            {
                if(this.q07_Options[key].optionName === 'nil')continue;
                finalAnswer = this.q07_Options[key].optionName;
                break;
            }
        }

        if(finalAnswer === this.initAnswer07)finalAnswer = 'return';
        // console.log('q07GetFinalAnswer : ' + finalAnswer);
        // console.log('initAnswer07 : ' + this.initAnswer07);
        return finalAnswer;
    }

    saveQ07(){
        const finalAnswer = this.q07GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question07, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question07, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveSingle({
            recordIdCP : this.cpRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            qNo : '07',
            ans : {answer : finalAnswer},
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1'

        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.cpRecordId = result;
            this.reInitializeRecordCP();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Planning',
                message: 'Question07 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQ07';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError ;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question07 answer';
            }else{
                this.rxError = 'प्रश्न07 का उत्तर डालते समय त्रुटि हुई';
            }
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }
    
    handleQ07(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q07_Options){
            if(this.q07_Options[key].optionName === targetId)
            {
                this.q07_Options[key].answer = targetValue;
            }
            else
            {
                this.q07_Options[key].answer = false;
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut07) {
        //     window.clearTimeout(this.delayTimeOut07);
        // }

        // this.delayTimeOut07 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ07();
        // }, this.delay);
        // ## 1 Stop

        this.flag = 'handleQ07';
        console.log('this.flag : ' + this.flag);
    }

    q08GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q08_Options){
            if(this.q08_Options[key].answer)
            {
                if(this.q08_Options[key].optionName === 'nil')continue;
                finalAnswer = this.q08_Options[key].optionName;
                break;
            }
        }

        if(finalAnswer === this.initAnswer08)finalAnswer = 'return';
        // console.log('q08GetFinalAnswer : ' + finalAnswer);
        // console.log('initAnswer08 : ' + this.initAnswer08);
        return finalAnswer;
    }

    saveQ08(){
        console.log('saveQ08')
        const finalAnswer = this.q08GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question08, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question08, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveSingle({
            recordIdCP : this.cpRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            qNo : '08',
            ans : {answer : finalAnswer},
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.cpRecordId = result;
            this.reInitializeRecordCP();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Planning',
                message: 'Question08 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQ08';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question08 answer';
            }else{
                this.rxError = 'प्रश्न08 का उत्तर डालते समय त्रुटि हुई';
            }
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }
    
    handleQ08(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q08_Options){
            if(this.q08_Options[key].optionName === targetId)
            {
                this.q08_Options[key].answer = targetValue;
            }
            else
            {
                this.q08_Options[key].answer = false;
            }
        }
        console.log('this.delayTimeOut08 = ',this.delayTimeOut08)
        
        // ## 1 Start
        // if (this.delayTimeOut08) {
        //     window.clearTimeout(this.delayTimeOut08);
        // }

        // this.delayTimeOut08 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ08();
        // }, this.delay);
        // ## 1 Stop

        this.flag = 'handleQ08';
        console.log('this.flag : ' + this.flag);
    }

    q09GetFinalAnswer(){
        let finalAnswer = []; 

        for(let key in this.q09_Options){
            let ans = this.q09_Options[key].answer;
            if(ans === 'nil')ans = '';
            finalAnswer.push(ans);
        }

        let matchCount = 0;
        for(; matchCount < finalAnswer.length; matchCount++)
        {
            if(finalAnswer[matchCount] !== this.initAnswer09[matchCount])break;
        }

        if(matchCount === finalAnswer.length)
        {
            //console.log('No change in answer of Question09, Please return');
            return ['return'];
        }

        return finalAnswer;
    }

    saveQ09(){
        const finalAnswer = this.q09GetFinalAnswer();
        if(finalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question09, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question09, Please proceed');
        // }

        const q09Answer = {
            answer1 : finalAnswer[0],
            answer2 : finalAnswer[1],
            answer3 : finalAnswer[2],
            answer4 : finalAnswer[3],
            answer5 : finalAnswer[4],
            answer6 : finalAnswer[5],
            answer7 : finalAnswer[6]
        };
        console.log('q09Answer = ',q09Answer)
        saveQuestion09({
            recordIdCP : this.cpRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            ans : q09Answer,
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.cpRecordId = result;
            this.reInitializeRecordCP();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Planning',
                message: 'Question09 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQ09';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question09 answer';
            }else{
                this.rxError = 'प्रश्न09 का उत्तर डालते समय त्रुटि हुई';
            }
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    handleQ09(event) {
        let targetId = event.target.dataset.id;
        let targetValue = event.target.value;

        for(let key in this.q09_Options){
            if(this.q09_Options[key].optionName == targetId)
            {
                this.q09_Options[key].answer = targetValue;
            }
        }
       
        // ## 1 Start
        // if (this.delayTimeOut09) {
        //     window.clearTimeout(this.delayTimeOut09);
        // }

        // this.delayTimeOut09 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ09();
        // }, this.delay);
        // ## 1 Stop

        this.flag = 'handleQ09';
        console.log('this.flag : ' + this.flag);
    }

    q10GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q10_Options){
            if(this.q10_Options[key].answer)
            {
                if(this.q10_Options[key].optionName === 'nil')continue;
                finalAnswer = this.q10_Options[key].optionName;
                break;
            }
        }

        if(finalAnswer === this.initAnswer10)finalAnswer = 'return';
        return finalAnswer;
    }

    saveQ10(){
        const finalAnswer = this.q10GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question10, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question10, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveSingle({
            recordIdCP : this.cpRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            qNo : '10',
            ans : {answer : finalAnswer},
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.cpRecordId = result;
            this.reInitializeRecordCP();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Planning',
                message: 'Question10 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQ10';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question10 answer';
            }else{
                this.rxError = 'प्रश्न10 का उत्तर डालते समय त्रुटि हुई';
            }
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }
    
    handleQ10(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q10_Options){
            if(this.q10_Options[key].optionName === targetId)
            {
                this.q10_Options[key].answer = targetValue;
            }
            else
            {
                this.q10_Options[key].answer = false;
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut10) {
        //     window.clearTimeout(this.delayTimeOut10);
        // }

        // this.delayTimeOut10 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ10();
        // }, this.delay);
        // ## 1 Stop

        this.flag = 'handleQ10';
        console.log('this.flag : ' + this.flag);
    }

    allQuestionsAttempted(){
        let rxError = '';
        //===============================================//
        let foundans07 = false;
        for(let key in this.q07_Options){
            if(this.q07_Options[key].answer)
            {
                foundans07 = true;
                break;
            }
        }
        if(!foundans07)
        {
            if(rxError !== '')rxError += ', ' + 'Q7';
            else rxError = 'Q7';
        }
        //===============================================//
        let foundans08 = false;
        for(let key in this.q08_Options){
            if(this.q08_Options[key].answer)
            {
                foundans08 = true;
                break;
            }
        }
        if(!foundans08)
        {
            if(rxError !== '')rxError += ', ' + 'Q8';
            else rxError = 'Q8';
        }
        //===============================================//
        let foundans09 = [];
        for(let x = 0; x < this.q09_Options.length ; x++)
        {
            if(this.q09_Options[x].answer === '')
            {
                foundans09[x] = false;
            }
            else foundans09[x] = true;
        }

        let foundans09All = true;
        for(let x = 0; x < foundans09.length ; x++)
        {
            if(!foundans09[x])
            {
                if(rxError !== '')rxError += ', ' + 'Q9.' + + (x+1);
                else rxError = 'Q9.' + (x+1);

                foundans09All = false;
            }
        }
        //===============================================//
        let foundans10 = false;
        for(let key in this.q10_Options){
            if(this.q10_Options[key].answer)
            {
                foundans10 = true;
                break;
            }
        }
        if(!foundans10)
        {
            if(rxError !== '')rxError += ', ' + 'Q10';
            else rxError = 'Q10';
        }
        //===============================================// 
        if(foundans07 && foundans08 && foundans09All && foundans10)
        {
            return 'All available';
        }

        if(this.isEnglish){
            return ('Please choose answers for questions: ' + rxError);
        }else{
            return ('कृपया प्रश्नों के उत्तर चुनें: ' + rxError);
        }
        //return ('Please choose answers for questions: ' + rxError);
    }

    restrictIndividualUpdate(){
        
        // ## 1 Start
        // if (this.delayTimeOut07) {
        //     window.clearTimeout(this.delayTimeOut07);
        // }

        // if (this.delayTimeOut08) {
        //     window.clearTimeout(this.delayTimeOut08);
        // }

        // if (this.delayTimeOut09) {
        //     window.clearTimeout(this.delayTimeOut09);
        // }

        // if (this.delayTimeOut10) {
        //     window.clearTimeout(this.delayTimeOut10);
        // }
        // ## 1 Stop

    }

    saveAll(){
        this.restrictIndividualUpdate();
        //===================================================================================//
        const q07FinalAnswer = this.q07GetFinalAnswer();
        let q07Answer = {};
        if(q07FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question07, Please return : saveAll()');
            q07Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question07, Please proceed : saveAll()');
            q07Answer.answer = q07FinalAnswer;
        }
        //===================================================================================//
        const q08FinalAnswer = this.q08GetFinalAnswer();
        let q08Answer = {};
        if(q08FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question08, Please return : saveAll()');
            q08Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question08, Please proceed : saveAll()');
            q08Answer.answer = q08FinalAnswer;
        }
        //===================================================================================//
        const q09FinalAnswer = this.q09GetFinalAnswer();
        let q09Answer = {};
        if(q09FinalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question09, Please return : saveAll()');
            q09Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question09, Please proceed : saveAll()');
            q09Answer.answer1 = q09FinalAnswer[0];
            q09Answer.answer2 = q09FinalAnswer[1];
            q09Answer.answer3 = q09FinalAnswer[2];
            q09Answer.answer4 = q09FinalAnswer[3];
            q09Answer.answer5 = q09FinalAnswer[4];
            q09Answer.answer6 = q09FinalAnswer[5];
            q09Answer.answer7 = q09FinalAnswer[6];
        }
        //===================================================================================//
        const q10FinalAnswer = this.q10GetFinalAnswer();
        let q10Answer = {};
        if(q10FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question10, Please return : saveAll()');
            q10Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question10, Please proceed : saveAll()');
            q10Answer.answer = q10FinalAnswer;
        }
        //===================================================================================//
        // if(q07Answer !== null || q08Answer !== null || q09Answer !== null || q10Answer !== null)
        // {
            this.isLoading = true;   //Turn ON the spinner

            const allQA = {
                q07 : q07Answer,  
                q08 : q08Answer,
                q09 : q09Answer,
                q10 : q10Answer
            };

            //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards
            console.log('$$$ this.cpRecordId: ', this.cpRecordId);
            console.log('$$$ this.rxStudentId: ', this.rxStudentId);
            console.log('$$$ this.studentBarcode: ', this.studentBarcode);
            saveAllQA({
                batchId : this.bid,
                recordIdCP : this.cpRecordId,
                studentId : this.rxStudentId,
                barCode : this.studentBarcode,
                ans : allQA,
                lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1'
            }).then(result => {
                console.log('result saveAllQA: ' + JSON.stringify(result));
                //===========================================================//
                this.cpRecordId = result;
                this.reInitializeRecordCP();
                this.saveAllDone = true;
                const event = new ShowToastEvent({
                    title: this.successTitle,
                    message: this.successMsg,
                    variant: 'success'
                });                 
                this.dispatchEvent(event);
                this.backNavigateToInternalPage();
            }).catch(error => {
                this.isLoading = false;   //Turn OFF the spinner
                let rxError;
                if(this.isEnglish){
                this.rxError = 'Error while upserting all answers';
                }else{
                    this.rxError = 'सभी उत्तरों को सम्मिलित करते समय त्रुटि हुई';
                }
                if (Array.isArray(error.body)) {
                    rxError = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    rxError = error.body.message;
                }
                //console.log('Print error : ' + rxError);

                const event = new ShowToastEvent({
                    title : this.errorTitle,
                    message : rxError,
                    variant : 'error'
                });
                this.dispatchEvent(event);
            });
        // }else{
        //     //this.submit();
        //     this.cpNavigateToInternalPage()
        // }
        //===================================================================================//
        this.flag = 'saveAllQA';
        console.log('this.flag : ' + this.flag);
    }

    handleSaveButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'saveButton')
        {
            do{
                let returnStr = this.allQuestionsAttempted();
                if(returnStr != 'All available')
                {
                    const event = new ShowToastEvent({
                        title : this.errorTitle,
                        message : returnStr,
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                    break;
                }
                this.saveAll();            
            }while(false);
        }

        this.flag = 'handleSaveButton';
        console.log('this.flag : ' + this.flag);
    }

    handleBackButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'backButton')
        {
            this.cdm2NavigateToInternalPage();
        }

        this.flag = 'handleBackButton';
        console.log('this.flag : ' + this.flag);
    }

    cdm2NavigateToInternalPage() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'baseline_cp_assesment_V2__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd),
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid),
                typ : this.typ,
                lng : this.lng
            }
        });
    }

    submit(){ 
        debugger
        console.log('submit');  
        // this.cpRecordId = null;  //For temperary purpose delete afterwards
        // if(this.cpRecordId == null)
        // {
        //     confirm('Please save the record before submit');
        //     return;
        // }

        this.isLoading = true;   //Turn ON the spinner
        submitAndCalculate({
            recordIdCP : this.cpRecordId,
            cdm1Id : this.cdm1Id,
            cdm2Id : this.cdm2Id,
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1'
        }).then(result => {
            console.log('result submitAndCalculate: ' + JSON.stringify(result));
            //===========================================================//
            if(result === 'success')
            {
                this.reInitializeRecordCP();
                const event = new ShowToastEvent({
                    title: this.successTitle,
                    message: this.successMsg,
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                //this.pageRedirect();
                
            }
            this.submitDone = true;           
            this.isLoading = false;   //Turn OFF the spinner
        
        }).catch(error => {
            this.isLoading = false;   //Turn OFF the spinner
            let rxError = 'Error while submitting the record';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });

        this.flag = 'submit';
        console.log('this.flag : ' + this.flag);
    }
    pageRedirect(){
        setTimeout(() => {
                        let pageReference = {
                        type: 'comm__namedPage',
                        attributes: {
                            name: 'omrCdm1Form5V2__c'
                        },
                        state:{
                           fem : encodeURI(this.fem),
                            sch : encodeURI(this.sch),
                            grd : encodeURI(this.grd),
                            bid : encodeURI(this.bid),
                            acid : encodeURI(this.acid),
                            typ : encodeURI(this.typ),
                            lng : encodeURI(this.lng)
                        }
                    };
                    this.isLoading = false;
                    this[NavigationMixin.Navigate](pageReference);
                    }, 1000);
    }
    handleContinueButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'continueButton')
        {
            if(this.freeze)
            {
                this.cpNavigateToInternalPage();
            }
            else
            {
                do{
                    let returnStr = this.allQuestionsAttempted();
                    if(returnStr !== 'All available')
                    {
                        const event = new ShowToastEvent({
                            title : this.errorTitle,
                            message : returnStr,
                            variant : 'error'
                        });
                        this.dispatchEvent(event);
                        break;
                    }
                    this.saveAll(); 
                    // this.cpNavigateToInternalPage();                
                }while(false);
            }
        }

        this.flag = 'handleContinueButton'; 
        console.log('this.flag : ' + this.flag);
    }

    cpNavigateToInternalPage() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',    
            attributes: {
                name: 'baseline_cp_assesment_V2__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd),
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid),
                typ : this.typ,
                lng : this.lng
            }
        });
    }

    handleSubmitButton(event){
        let eventButton = event.target.dataset.name;
        if(eventButton == 'submitButton')
        {
            do{
                let returnStr = this.allQuestionsAttempted();
                if(returnStr != 'All available')
                {
                    const event = new ShowToastEvent({
                        title : this.errorTitle,
                        message : returnStr,
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                    break;
                }
                getBaselineRecord({
                    studentId : this.rxStudentId,
                    grade : this.grd,
                    type : 'CP',
                    batchId : this.bid,
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
                        this.backNavigateToInternalPage();
                    }else{
                        this.saveAll(); 
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
            }while(false);
        }

        this.flag = 'handleSubmitButton';
        console.log('this.flag : ' + this.flag);
    }

    backNavigateToInternalPage() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'baseline_cp_assesment_V2__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd),
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid),
                typ : this.typ,
                lng : this.lng
            }
        });
    }
}