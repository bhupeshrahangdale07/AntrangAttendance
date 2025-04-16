/*
    // ## 1 --- Commented below code to Stop Save for every question
*/

import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getRecordCDM1 from '@salesforce/apex/careerDecisionMaking_01.getRecordCDM1';
import saveQuestion01 from '@salesforce/apex/careerDecisionMaking_01.saveQuestion01';
import saveQuestion02 from '@salesforce/apex/careerDecisionMaking_01.saveQuestion02';
import saveQuestion03 from '@salesforce/apex/careerDecisionMaking_01.saveQuestion03';
import saveQuestion04 from '@salesforce/apex/careerDecisionMaking_01.saveQuestion04';
import saveAllQA from '@salesforce/apex/careerDecisionMaking_01.saveAllQA';
import submitAndCalculate from '@salesforce/apex/careerDecisionMaking_01.submitAndCalculate';
import searchStudentRecords from '@salesforce/apex/careerDecisionMaking_01.searchStudentRecordsV2';
import getBatchInfo from '@salesforce/apex/careerDecisionMaking_01.getBatchInfo';
import getAssesmentQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';
import getObjectId from '@salesforce/apex/BaseLineFuturePlanningController.getObjectId';
import getBaselineRecord from '@salesforce/apex/BaselineAssessmentController.getBaselineRecord';

export default class CareerDecisionMaking_01V2 extends NavigationMixin(LightningElement) {
    lng;
    isEnglish;
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';
    typ;
    //=========================================================//
    tempVar = true;
    //=========================================================//
    fem = null;
    sch = null;
    grd = null;
    bid = null;
    acid = null;
    //=========================================================//
    //rxAccount = null;
    //rxGrade = null;
    rxBatch = null;
    rxGrade = null;
    schoolName = null;
    batchName = null;
    batchNumber = null;
    //rxRecordTypeCDM1 = null;
    rxStudentId = null;
    //=========================================================// 
    rxStudentBarcode = null;    
    rxRecordIdCMD1 = null;
    //=========================================================//
    flag = '';
    antarangImage = logo_01;
    isLoading = true;
    studentName = null;
    //studentGrade = null;
    //=========================================================//
    @track freeze = true;
    
    // ## 1 Start
    // delayTimeOut01;
    // delayTimeOut02;
    // delayTimeOut03;
    // delayTimeOut04;
    // ## 1 Stop
        

    delay = 5000;   //Delay = 5 sec
    //=========================================================//
    //@track studentPresent = false;
    @track studentPresent = true;
    delayTimeOut05;
    studentSearchText = '';
    @track studentSearchResult = '';
    @track studentDisplay = [];
    @track showStudentList = false;
    submittedStudentMapKeys = [];
    //=========================================================//
    question01 = '';
    initAnswer01 = '';
    @track q01_Options = [];
    //=========================================================//
    question02 = '';
    initAnswer02 = [];

    @track q02_Options = [];
    //=========================================================//
    question03 = '';
    initAnswer03 = [];
    @track q03_Options = [];
    //=========================================================//
    @track initMultiPickListValues = false;
    @track fieldValueFCC = '';
    @track arrFieldValueFCC = [];
    prevArrayFCC = [];

    @track fieldValueSCC = '';
    @track arrFieldValueSCC = [];
    prevArraySCC = [];

    question04 = '';
    initAnswer04 = {};

    pickListValues = [];
    //=========================================================//

    @wire(CurrentPageReference)
    getCurrentPageReference(currentPageReference) {
        if(currentPageReference) 
        {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.rxStudentId = rxCurrentPageReference.state.studentId;
            // this.rxBatch = rxCurrentPageReference.state.batchId;
            // this.rxGrade = rxCurrentPageReference.state.grade;
            this.fem = decodeURI(rxCurrentPageReference.state.fem);
            this.sch = decodeURI(rxCurrentPageReference.state.sch);
            this.grd = decodeURI(rxCurrentPageReference.state.grd);
            this.bid = decodeURI(rxCurrentPageReference.state.bid);
            this.acid = decodeURI(rxCurrentPageReference.state.acid);
            this.typ = decodeURI(rxCurrentPageReference.state.typ);
            this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;
            this.rxBatch = this.bid;
            this.rxGrade = this.grd;
            if(this.isEnglish){
                this.title = 'Baseline Career Decision Making-1 Data';
                this.errorTitle = 'Error';
                this.successMsg ='Baseline Career Decision Making-1 - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'आधारभूत करियर के निर्णय - 1 डेटा';
                this.errorTitle = 'गलती!';
                this.successMsg ='छात्र डेटा सहेजा गया है';
                this.successTitle = 'Success'
            }
        }

        this.flag = 'getCurrentPageReference';
        console.log('this.flag : ' + this.flag);
    }

    //Standard JavaScript connectedCallback() method called on page load
    connectedCallback() 
    {
        this.getBatchInformation();
        this.getAssesmentQuestionFunc();
        if(this.rxStudentId !== undefined && this.rxStudentId !== null)
        {
            this.getApexRecordCDM1();
        }
        
        
        this.flag = 'connectedCallback';
    }

    //This method is called to get all questions
    getAssesmentQuestionFunc(){
        getAssesmentQuestion({
            objectName : 'CDM1',
            formType : 'Form V2',
            grade : ''
        }).then(result => {
            console.log('getAssesmentQuestion Result = '+JSON.stringify(result));
            if(result){
                this.assesmentQuestionAndLabel = result;
                let que1 = this.getQuestionsAndOptions(1);
                if(que1){
                    this.question01 = que1.question;
                    this.q01_Options = que1.options;
                }
                let que2 = this.getQuestionsAndOptions(2);
                if(que2){
                    this.question02 = que2.question;
                    this.q02_Options = que2.options;
                }
                let que3 = this.getQuestionsAndOptions(3);
                if(que3){
                    this.question03 = que3.question;
                    this.q03_Options = que3.options;
                }
                let que4 = this.getQuestionsAndOptions(4);
                if(que4){
                    this.question04 = que4.question;
                    this.pickListValues = que4.options;
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
                let optionNames = ['A', 'B', 'C', 'D', 'E','F','G','H','I'];
                let i=0;
                for (let opt of que.Assessment_Question_Options__r) {
                    let optionValue =  (this.lng === 'Hindi') ? opt.Option_Label_Hindi__c :opt.Option_Label_English__c;
                    let optionName = (opt.Option_Label_English__c === 'No Answer') ? 'nil' : (opt.Option_Label_English__c === 'Multiple answers selected') ? '*' : (seqNumber === 4) ? 'Q4_'+i+'__c' : optionNames[i];
                    let option = (seqNumber === 4) ? {apiName: optionName , value: optionValue} :{optionName:optionName, answer: false,optionValue:optionValue }
                    options.push(option);
                    i++;
                }
            }
        }
        return {question,options};
    }

    //This method is called after the triggered event is handled completely
    renderedCallback()
    {
        if(this.studentDisplay.length > 0)this.showStudentList = true;
        else
        {
            this.showStudentList = false;
        }

        this.flag = 'renderedCallback';
        console.log('this.flag : ' + this.flag);
    }

    getApexRecordCDM1(){

        getRecordCDM1({
            studentId : this.rxStudentId,
            grade : this.grd
        }).then(result => {
            console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const singleRecordWrapper = JSON.parse(JSON.stringify(result));
            if(singleRecordWrapper.studentBarcode !== undefined)
            {
                this.rxStudentBarcode = singleRecordWrapper.studentBarcode;
            }
            else this.rxStudentBarcode = null;
            
            if(singleRecordWrapper.studentName !== undefined)this.studentName = singleRecordWrapper.studentName;
            //if(singleRecordWrapper.studentGrade !== undefined)this.studentGrade = singleRecordWrapper.studentGrade;
            //===========================================================//
            do{
                if(singleRecordWrapper.recordCDM1 === undefined || 
                    singleRecordWrapper.recordCDM1 === null)
                {
                    //console.log('CDM1 record does not exist');

                    this.freeze = false;
                    this.isLoading = false;
                    break;
                }

                const record = singleRecordWrapper.recordCDM1;

                if(record.Form_Submitted__c)this.freeze = true;
                else this.freeze = false;

                this.rxRecordIdCMD1 = record.Id;
                
                //Place init for Question01 here
                this.initAnswer01 = record.Q_1__c;

                let foundAns1 = false;
                for(let key in this.q01_Options){
                    if(this.q01_Options[key].optionName === record.Q_1__c)
                    {
                        this.q01_Options[key].answer = true;
                        foundAns1 = true;
                    }
                }

                if(!foundAns1)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q01_Options){
                            if(this.q01_Options[key].optionName === 'nil')
                            {
                                this.q01_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }  
                //Place init for Question02 here
                this.initAnswer02.push(record.Q_2_1__c);
                this.initAnswer02.push(record.Q_2_2__c);
                this.initAnswer02.push(record.Q_2_3__c);
                this.initAnswer02.push(record.Q_2_4__c);
                this.initAnswer02.push(record.Q_2_5__c);
                this.initAnswer02.push(record.Q_2_6__c);
                this.initAnswer02.push(record.Q_2_7__c);

                let foundAns2 = false;
                for(let x = 0; x < this.initAnswer02.length; x++) { //this.initAnswer02.length is important here
                    if(this.initAnswer02[x] === this.q02_Options[x].optionName)
                    {
                        this.q02_Options[x].answer = true;
                        foundAns2 = true;
                    }
                }

                if(!foundAns2)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let x = 0; x < this.q02_Options.length; x++) {
                            if(this.q02_Options[x].optionName === 'nil')
                            {
                                this.q02_Options[x].answer = true;
                                break;
                            }
                        }
                    }
                }
                
                //Place init for Question03 here
                this.initAnswer03.push(record.Q3_1__c);
                this.initAnswer03.push(record.Q3_2__c);
                this.initAnswer03.push(record.Q3_3__c);
                this.initAnswer03.push(record.Q3_4__c);
                this.initAnswer03.push(record.Q3_5__c);
                this.initAnswer03.push(record.Q3_6__c);
                this.initAnswer03.push(record.Q3_7__c);

                // for(let x = 0; x < this.initAnswer03.length; x++) {
                //     if(this.initAnswer03[x] === 'A')
                //     {
                //         this.q03_Options[x].answer01 = true;
                //     }
                //     else if(this.initAnswer03[x] === 'B')
                //     {
                //         this.q03_Options[x].answer02 = true;
                //     }
                //     else if(this.initAnswer03[x] === '*')
                //     {
                //         this.q03_Options[x].answer01 = true;
                //         this.q03_Options[x].answer02 = true;
                //     }
                // }

                let foundAns3 = false;
                for(let x = 0; x < this.initAnswer03.length; x++) { //this.initAnswer02.length is important here
                    if(this.initAnswer03[x] === this.q03_Options[x].optionName)
                    {
                        this.q03_Options[x].answer = true;
                        foundAns3 = true;
                    }
                }

                if(!foundAns3)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let x = 0; x < this.q03_Options.length; x++) {
                            if(this.q03_Options[x].optionName === 'nil')
                            {
                                this.q03_Options[x].answer = true;
                                break;
                            }
                        }
                    }
                }

                //Place init for Question04 here
                const recordKeys = Object.keys(record);

                for(let x in this.pickListValues){
                    let key = this.pickListValues[x].apiName;
                    if(key === 'nil')continue;
                    if(recordKeys.includes(key))
                    {
                        this.initAnswer04[key] = record[key];
                    } 
                    else
                    {
                        this.initAnswer04[key] = '';
                    }
                }

                // for(let x = 0; x < this.pickListValues.length; x++)
                // {
                //     let key = this.pickListValues[x].apiName;
                //     if(recordKeys.includes(key) && (record[key] === '1' || record[key] === '*'))
                //     {
                //         this.arrFieldValueFCC.push(this.pickListValues[x].value);
                //         if(this.fieldValueFCC === '')
                //         {
                //             this.fieldValueFCC = this.pickListValues[x].value;
                //         }
                //         else
                //         {
                //             this.fieldValueFCC += ',' + this.pickListValues[x].value;
                //         }
                //     }

                //     if(recordKeys.includes(key) && (record[key] === '2' || record[key] === '*'))
                //     {
                //         this.arrFieldValueSCC.push(this.pickListValues[x].value);
                //         if(this.fieldValueSCC === '')
                //         {
                //             this.fieldValueSCC = this.pickListValues[x].value;
                //         }
                //         else
                //         {
                //             this.fieldValueSCC += ',' + this.pickListValues[x].value;
                //         }
                //     }
                // }

                for(let x = 0; x < this.pickListValues.length; x++)
                {
                    let key = this.pickListValues[x].apiName;
                    if(recordKeys.includes(key)

					&& (record[key] === '1' || record[key] === '2'))
                    {
                        this.arrFieldValueFCC.push(this.pickListValues[x].value);
                        if(this.fieldValueFCC === '')
                        {
                            this.fieldValueFCC = this.pickListValues[x].value;
                        }
                        else
                        {
                            this.fieldValueFCC += ',' + this.pickListValues[x].value;
                        }
                    }
				}

                if(this.arrFieldValueFCC.length == 0)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        this.arrFieldValueFCC.push(this.pickListValues[0].value);
                        this.fieldValueFCC = this.pickListValues[0].value;
                    }
                }

                if(this.arrFieldValueSCC.length == 0)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        this.arrFieldValueSCC.push(this.pickListValues[0].value);
                        this.fieldValueSCC = this.pickListValues[0].value;
                    }
                }

                this.isLoading = false;
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Career Decision Making-1',
                    message: 'Career Decision Making-1 record fields received successfuly',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
            }while(false);
            this.flag = 'getApexRecordCDM1';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError ;
            if(this.isEnglish){
                this.rxError = 'Error while recieving record fields: Career Decision Making-1';
            }else{
                this.rxError = 'रिकॉर्ड फ़ील्ड प्राप्त करते समय त्रुटि: करियर के निर्णय - 1';
            }
            console.log('error getApexRecordCDM1 =',error)
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

    reInitializeRecordCDM1(){
        getRecordCDM1({
            studentId : this.rxStudentId,
            grade : this.grd
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const singleRecordWrapper = JSON.parse(JSON.stringify(result));
            //===========================================================//
            const record = singleRecordWrapper.recordCDM1;

            if(record.Form_Submitted__c)this.freeze = true;
            else this.freeze = false;
            
            //Place init for Question01 here
            this.initAnswer01 = record.Q_1__c;

            //Place init for Question02 here
            this.initAnswer02 = [];
            this.initAnswer02.push(record.Q_2_1__c);
            this.initAnswer02.push(record.Q_2_2__c);
            this.initAnswer02.push(record.Q_2_3__c);
            this.initAnswer02.push(record.Q_2_4__c);
            this.initAnswer02.push(record.Q_2_5__c);
            this.initAnswer02.push(record.Q_2_6__c);
            this.initAnswer02.push(record.Q_2_7__c);

            //Place init for Question03 here
            this.initAnswer03 = [];
            this.initAnswer03.push(record.Q3_1__c);
            this.initAnswer03.push(record.Q3_2__c);
            this.initAnswer03.push(record.Q3_3__c);
            this.initAnswer03.push(record.Q3_4__c);
            this.initAnswer03.push(record.Q3_5__c);
            this.initAnswer03.push(record.Q3_6__c);
            this.initAnswer03.push(record.Q3_7__c);

            //Place init for Question04 here
            const recordKeys = Object.keys(record);
            this.initAnswer04 = {};

            for(let x in this.pickListValues){
                let key = this.pickListValues[x].apiName;
                if(recordKeys.includes(key))
                {
                    this.initAnswer04[key] = record[key];
                } 
                else
                {
                    this.initAnswer04[key] = '';
                }
            }

            this.flag = 'reInitializeRecordCDM1';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while recieving record fields: Career Decision Making-1 (reInit)';
            }else{
                this.rxError = 'रिकॉर्ड फ़ील्ड प्राप्त करते समय त्रुटि: करियर के निर्णय - 1 (रीइनिट)';
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

    get freezeCareerChoiceComponent(){
        return !this.freeze;
    }

    get nowStudentPresent(){
        return !this.studentPresent;
    }

    q01GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q01_Options){
            if(this.q01_Options[key].answer)
            {
                if(this.q01_Options[key].optionName === 'nil')continue;
                finalAnswer = this.q01_Options[key].optionName;
                break;
            }
        }

        if(finalAnswer === this.initAnswer01)finalAnswer = 'return';
        // console.log('q01GetFinalAnswer : ' + finalAnswer);
        // console.log('initAnswer01 : ' + this.initAnswer01);
        return finalAnswer;
    }

    saveQ01(){
        const finalAnswer = this.q01GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question01, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question01, Please proceed');
        // }

        //this.rxRecordIdCMD1 = null; //For temperary purpose delete afterwards

        saveQuestion01({
            recordIdCMD1 : this.rxRecordIdCMD1,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD1 = result;
            this.reInitializeRecordCDM1();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-1',
                message: 'Question01 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion01';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question01 answer';
            }else{
                this.rxError = 'प्रश्न01 का उत्तर डालते समय त्रुटि हुई';
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

    handleQ01(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q01_Options){
            if(this.q01_Options[key].optionName === targetId)
            {
                this.q01_Options[key].answer = targetValue;
            }
            else
            {
                this.q01_Options[key].answer = false;
            }
        } 

        // ## 1 Start
        // if (this.delayTimeOut01) {
        //     window.clearTimeout(this.delayTimeOut01);
        // }

        // this.delayTimeOut01 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ01();
        // }, this.delay);
        // ## 1 Stop
        
        this.flag = 'handleQ01';
        console.log('this.flag : ' + this.flag);
    }

    q02GetFinalAnswer(){
        let finalAnswer = [];

        // for(let key in this.q02_Options){
        //     if(this.q02_Options[key].answer01 && this.q02_Options[key].answer02)
        //     {
        //         finalAnswer.push('*');
        //     }
        //     else if(this.q02_Options[key].answer01 && !this.q02_Options[key].answer02)
        //     {
        //         finalAnswer.push('A');
        //     }
        //     else if(!this.q02_Options[key].answer01 && this.q02_Options[key].answer02)
        //     {
        //         finalAnswer.push('B');
        //     }
        //     else
        //     {
        //         finalAnswer.push(undefined);
        //     }
        // }

        for(let key in this.q02_Options){
            if(this.q02_Options[key].optionName === 'nil')continue;
            
            if(this.q02_Options[key].answer)
            {
                finalAnswer.push(this.q02_Options[key].optionName);
            }
            else
            {
                finalAnswer.push(undefined);
            }
        }

        let matchCount = 0;
        for(; matchCount < finalAnswer.length; matchCount++)
        {
            if(finalAnswer[matchCount] !== this.initAnswer02[matchCount])break;
        }
        if(matchCount === finalAnswer.length)
        {
            //console.log('No change in answer of Question02, Please return');
            return ['return'];
        }

        return finalAnswer;
    }

    saveQ02(){
        const finalAnswer = this.q02GetFinalAnswer();
        if(finalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question02, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question02, Please proceed');
        // }

        const q02Answer = {
            answer_2_1 : finalAnswer[0],
            answer_2_2 : finalAnswer[1],
            answer_2_3 : finalAnswer[2],
            answer_2_4 : finalAnswer[3],
            answer_2_5 : finalAnswer[4],
            answer_2_6 : finalAnswer[5],
            answer_2_7 : finalAnswer[6]
        };
        console.log('this.lng =',this.lng)
        console.log('this.typ = ',this.typ)
        //this.rxRecordIdCMD1 = null; //For temperary purpose delete afterwards

        saveQuestion02({
            recordIdCMD1 : this.rxRecordIdCMD1,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : q02Answer,
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD1 = result;
            this.reInitializeRecordCDM1();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-1',
                message: 'Question02 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion02';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question0 answer';
            }else{
                this.rxError = 'प्रश्न0 का उत्तर डालते समय त्रुटि हुई';
            }
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);
            //let errorTitle = '';
            
            const event = new ShowToastEvent({
                title : this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    handleQ02(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        /*
        for(let key in this.q02_Options){
            if(this.q02_Options[key].optionName01 === targetId)
            {
                this.q02_Options[key].answer01 = targetValue;
            }
            else if(this.q02_Options[key].optionName02 === targetId)
            {
                this.q02_Options[key].answer02 = targetValue;
            }
        }*/

        if(targetId === 'nil')
        {
            for(let key in this.q02_Options){
                if(this.q02_Options[key].optionName === 'nil')
                {
                    this.q02_Options[key].answer = targetValue;
                }
                else
                {
                    this.q02_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q02_Options){
                if(this.q02_Options[key].optionName === targetId)
                {
                    this.q02_Options[key].answer = targetValue;
                }
                else if(this.q02_Options[key].optionName === 'nil')
                {
                    this.q02_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut02) {
        //     window.clearTimeout(this.delayTimeOut02);
        // }

        // this.delayTimeOut02 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ02();
        // }, this.delay);
        // ## 1 Stop
        
        this.flag = 'handleQ02';
        console.log('this.flag : ' + this.flag);
    }

    q03GetFinalAnswer(){
        let finalAnswer = [];

        // for(let key in this.q03_Options){
        //     if(this.q03_Options[key].answer01 && this.q03_Options[key].answer02)
        //     {
        //         finalAnswer.push('*');
        //     }
        //     else if(this.q03_Options[key].answer01 && !this.q03_Options[key].answer02)
        //     {
        //         finalAnswer.push('A');
        //     }
        //     else if(!this.q03_Options[key].answer01 && this.q03_Options[key].answer02)
        //     {
        //         finalAnswer.push('B');
        //     }
        //     else
        //     {
        //         finalAnswer.push(undefined);
        //     }
        // }

        for(let key in this.q03_Options){
            if(this.q03_Options[key].optionName === 'nil')continue;
            
            if(this.q03_Options[key].answer)
            {
                finalAnswer.push(this.q03_Options[key].optionName);
            }
            else
            {
                finalAnswer.push(undefined);
            }
        }

        let matchCount = 0;
        for(; matchCount < finalAnswer.length; matchCount++)
        {
            if(finalAnswer[matchCount] !== this.initAnswer03[matchCount])break;
        }
        if(matchCount === finalAnswer.length)
        {
            //console.log('No change in answer of Question03, Please return');
            return ['return'];
        }

        return finalAnswer;
    }

    saveQ03(){
        const finalAnswer = this.q03GetFinalAnswer();
        if(finalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question03, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question03, Please proceed');
        // }

        const q03Answer = {
            answer_3_1 : finalAnswer[0],
            answer_3_2 : finalAnswer[1],
            answer_3_3 : finalAnswer[2],
            answer_3_4 : finalAnswer[3],
            answer_3_5 : finalAnswer[4],
            answer_3_6 : finalAnswer[5],
            answer_3_7 : finalAnswer[6]
        };

        //this.rxRecordIdCMD1 = null; //For temperary purpose delete afterwards

        saveQuestion03({
            recordIdCMD1 : this.rxRecordIdCMD1,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : q03Answer,
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD1 = result;
            this.reInitializeRecordCDM1();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-1',
                message: 'Question03 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion03';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question03 answer';
            }else{
                this.rxError = 'प्रश्न03 का उत्तर डालते समय त्रुटि हुई';
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

    handleQ03(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        /*
        for(let key in this.q03_Options){
            if(this.q03_Options[key].optionName01 === targetId)
            {
                this.q03_Options[key].answer01 = targetValue;
            }
            else if(this.q03_Options[key].optionName02 === targetId)
            {
                this.q03_Options[key].answer02 = targetValue;
            }
        }*/

        if(targetId === 'nil')
        {
            for(let key in this.q03_Options){
                if(this.q03_Options[key].optionName === 'nil')
                {
                    this.q03_Options[key].answer = targetValue;
                }
                else
                {
                    this.q03_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q03_Options){
                if(this.q03_Options[key].optionName === targetId)
                {
                    this.q03_Options[key].answer = targetValue;
                }
                else if(this.q03_Options[key].optionName === 'nil')
                {
                    this.q03_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut03) {
        //     window.clearTimeout(this.delayTimeOut03);
        // }

        // this.delayTimeOut03 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ03();
        // }, this.delay);
        // ## 1 Stop
        
        this.flag = 'handleQ03';
        console.log('this.flag : ' + this.flag);
    }
    //old code
    // q04GetFinalAnswer() {
    //     let finalAnswer = {};
    //     for(let key in this.pickListValues){

    //         if(this.pickListValues[key].apiName === 'nil')continue;

    //         let op1 = false, op2 = false;         
    //         if(this.arrFieldValueFCC.includes(this.pickListValues[key].value))
    //         {
    //             op1 = true;
    //         }

    //         if(this.arrFieldValueSCC.includes(this.pickListValues[key].value))
    //         {
    //             op2 = true;
    //         }

    //         if(op1 && op2)finalAnswer[this.pickListValues[key].apiName] = '*';
    //         else if(op1 && !op2)finalAnswer[this.pickListValues[key].apiName] = '1';
    //         else if(!op1 && op2)finalAnswer[this.pickListValues[key].apiName] = '2';
    //         else finalAnswer[this.pickListValues[key].apiName] = '';
    //     }

    //     let matchCount = 0;
    //     for(let key in finalAnswer)
    //     {
    //         if(finalAnswer[key] !== this.initAnswer04[key])break;
    //         matchCount++;
    //     }

    //     if(matchCount === Object.keys(finalAnswer).length)
    //     {
    //         console.log('No change in answer of Question04, Please return');
    //         return {return : 'No change in answer'};
    //     }

    //     return finalAnswer;
    // }
    
    q04GetFinalAnswer() {
        let finalAnswer = {};
		let count = 0;
        for(let key in this.pickListValues){

            if(this.pickListValues[key].apiName === 'nil')continue;       
            if(this.arrFieldValueFCC.includes(this.pickListValues[key].value))
            {
                finalAnswer[this.pickListValues[key].apiName] = ++count;
            }
			else finalAnswer[this.pickListValues[key].apiName] = '';
        }
		
		if(count > 2)
		{
			for(let key in finalAnswer)
			{
				if(finalAnswer[key] > 1)finalAnswer[key] = 1;
			}
		}

        let matchCount = 0;
        for(let key in finalAnswer)
        {
            if(finalAnswer[key] !== this.initAnswer04[key])break;
            matchCount++;
        }

        if(matchCount === Object.keys(finalAnswer).length)
        {
            //console.log('No change in answer of Question04, Please return');
            return {return : 'No change in answer'};
        }

        return finalAnswer;
    }

    saveQ04(){
        const finalAnswer = this.q04GetFinalAnswer();
        if(finalAnswer.return !== undefined && finalAnswer.return === 'No change in answer')
        {
            // console.log('No change in answer of Question04, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question04, Please proceed');
        // }
        
        const q04Answer = {};
        for(let key in finalAnswer)
        {
            let str = key;
            str = str.replace("__c","");
            str = str.replace("Q","answer_");
            q04Answer[str] = finalAnswer[key];
        }

        saveQuestion04({
            recordIdCMD1 : this.rxRecordIdCMD1,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : q04Answer,
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD1 = result;
            this.reInitializeRecordCDM1();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-1',
                message: 'Question04 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion04';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question04 answer';
            }else{
                this.rxError = 'प्रश्न04 का उत्तर डालते समय त्रुटि हुई';
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

    multipicklistgenericevent(event){
        const pickListEvent = event.detail;
        // console.log('event.detail.fieldName : ' + pickListEvent.fieldName);
        // console.log('event.detail.value : ' + pickListEvent.value); 

        // this.template.querySelectorAll('c-multi-pick-list-generic-component').forEach(comp => {
        //     console.log('comp : ' + comp.fieldApiName);
        // });

        if(pickListEvent.fieldName === 'FirstCareerChoice__c')
        {
            let arr = []; 
            arr.push.apply(arr,pickListEvent.value);

            if(arr.includes('No Answer') && !this.prevArrayFCC.includes('No Answer'))
            {
                this.fieldValueFCC = ['No Answer'];       //This is mandatory 
                this.arrFieldValueFCC = ['No Answer'];
                //Below is call to method 'preSelectedValuesDisplay' from the component 'MultiPickListGenericComponent'
                this.template.querySelectorAll('c-multi-pick-list-generic-component').forEach(comp => {
                    if(comp.fieldApiName === 'FirstCareerChoice__c')
                    {
                        comp.preSelectedValuesDisplay(this.fieldValueFCC);
                    }
                });
            }
            else if(arr.includes('No Answer') && this.prevArrayFCC.includes('No Answer'))
            {
                let arrSorted = [];
                let i = 0;
                for(let x = 0; x < arr.length ; x++)
                {
                    if(arr[x] === 'No Answer')continue;
                    arrSorted[i++] = arr[x];
                }
                this.fieldValueFCC = arrSorted;       //This is mandatory 
                this.arrFieldValueFCC = arrSorted;
                //Below is call to method 'preSelectedValuesDisplay' from the component 'MultiPickListGenericComponent'
                this.template.querySelectorAll('c-multi-pick-list-generic-component').forEach(comp => {
                    if(comp.fieldApiName === 'FirstCareerChoice__c')
                    {
                        comp.preSelectedValuesDisplay(this.fieldValueFCC);
                    }
                });
            }
            else
            {
                this.fieldValueFCC = pickListEvent.value;       //This is mandatory 
                this.arrFieldValueFCC = pickListEvent.value;
            }
        }
        else if(pickListEvent.fieldName === 'SecondCareerChoice__c')
        {
            let arr = []; 
            arr.push.apply(arr,pickListEvent.value);

            if(arr.includes('No Answer') && !this.prevArraySCC.includes('No Answer'))
            {
                this.fieldValueSCC = ['No Answer'];       //This is mandatory 
                this.arrFieldValueSCC = ['No Answer'];
                //Below is call to method 'preSelectedValuesDisplay' from the component 'MultiPickListGenericComponent'
                this.template.querySelectorAll('c-multi-pick-list-generic-component').forEach(comp => {
                    if(comp.fieldApiName === 'SecondCareerChoice__c')
                    {
                        comp.preSelectedValuesDisplay(this.fieldValueSCC);
                    }
                });
            }
            else if(arr.includes('No Answer') && this.prevArraySCC.includes('No Answer'))
            {
                let arrSorted = [];
                let i = 0;
                for(let x = 0; x < arr.length ; x++)
                {
                    if(arr[x] === 'No Answer')continue;
                    arrSorted[i++] = arr[x];
                }
                this.fieldValueSCC = arrSorted;       //This is mandatory 
                this.arrFieldValueSCC = arrSorted;
                //Below is call to method 'preSelectedValuesDisplay' from the component 'MultiPickListGenericComponent'
                this.template.querySelectorAll('c-multi-pick-list-generic-component').forEach(comp => {
                    if(comp.fieldApiName === 'SecondCareerChoice__c')
                    {
                        comp.preSelectedValuesDisplay(this.fieldValueSCC);
                    }
                });
            }
            else
            {
                this.fieldValueSCC = pickListEvent.value;       //This is mandatory 
                this.arrFieldValueSCC = pickListEvent.value;
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut04) {
        //     window.clearTimeout(this.delayTimeOut04);
        // }

        // this.delayTimeOut04 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ04();
        // }, this.delay);
        // ## 1 Stop
        
        this.prevArrayFCC = [];
        this.prevArrayFCC = [...this.arrFieldValueFCC];
        this.prevArraySCC = [];
        this.prevArraySCC = [...this.arrFieldValueSCC];

        this.flag = 'multipicklistgenericevent';
        console.log('this.flag : ' + this.flag);
    }

    allQuestionsAttempted(){
        let rxError = '';
        //===============================================//
        let foundans1 = false;
        for(let key in this.q01_Options){
            if(this.q01_Options[key].answer)
            {
                foundans1 = true;
                break;
            }
        }
        if(!foundans1)
        {
            if(rxError !== '')rxError += ', ' + 'Q1';
            else rxError = 'Q1';
        }
        //===============================================//
        let foundans2 = false;
        for(let key in this.q02_Options){
            if(this.q02_Options[key].answer)
            {
                foundans2 = true;
                break;
            }
        }
        if(!foundans2)
        {
            if(rxError !== '')rxError += ', ' + 'Q2';
            else rxError = 'Q2';
        }
        //===============================================//
        let foundans3 = false;
        for(let key in this.q03_Options){
            if(this.q03_Options[key].answer)
            {
                foundans3 = true;
                break;
            }
        }
        if(!foundans3)
        {
            if(rxError !== '')rxError += ', ' + 'Q3';
            else rxError = 'Q3';
        }
        //===============================================//
        let foundans4FCC = false;
        if(this.arrFieldValueFCC.length > 0)foundans4FCC = true;
        else
        {
            let errorQ4;
            if(this.isEnglish){
                errorQ4 = 'Q4 First Career Choice';
            }else{
                errorQ4 = 'Q4 पहला करियर विकल्प';
            }
            if(rxError !== '')rxError += ', ' + errorQ4;
            else rxError = errorQ4;
        }

        // let foundans4SCC = false;
        // if(this.arrFieldValueSCC.length > 0)foundans4SCC = true;
        // else
        // {
        //     if(rxError !== '')rxError += ', ' + 'Q4 Second Career Choice';
        //     else rxError = 'Q4 Second Career Choice';
        // }
        //===============================================//
        if(foundans1 && foundans2 && foundans3 && foundans4FCC /*&& foundans4SCC*/)
        {
            return 'All available';
        }
        
        if(this.isEnglish){
            //return ('Please choose answers for questions: ' + rxError);
            return ('Please choose answers for questions: ' + rxError);
        }else{
            return ('कृपया प्रश्नों के उत्तर चुनें: ' + rxError);
        }
        //return ('Please choose answers for questions: ' + rxError);
    }

    restrictIndividualUpdate(){
        
        // ## 1 Start
        // if (this.delayTimeOut01) {
        //     window.clearTimeout(this.delayTimeOut01);
        // }

        // if (this.delayTimeOut02) {
        //     window.clearTimeout(this.delayTimeOut02);
        // }

        // if (this.delayTimeOut03) {
        //     window.clearTimeout(this.delayTimeOut03);
        // }
		
		// if (this.delayTimeOut04) {
        //     window.clearTimeout(this.delayTimeOut04);
        // }
        // ## 1 Stop
        
    }

    saveAll(){
        this.restrictIndividualUpdate();
        //===================================================================================//
        const q01FinalAnswer = this.q01GetFinalAnswer();
        let q01Answer = {};
        if(q01FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question01, Please return : saveAll()');
            q01Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question01, Please proceed : saveAll()');
            q01Answer.answer = q01FinalAnswer;
        }
        //===================================================================================//
        const q02FinalAnswer = this.q02GetFinalAnswer();
        let q02Answer = {};
        if(q02FinalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question02, Please return : saveAll()');
            q02Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question02, Please proceed : saveAll()');
            q02Answer.answer_2_1 = q02FinalAnswer[0];
            q02Answer.answer_2_2 = q02FinalAnswer[1];
            q02Answer.answer_2_3 = q02FinalAnswer[2];
            q02Answer.answer_2_4 = q02FinalAnswer[3];
            q02Answer.answer_2_5 = q02FinalAnswer[4];
            q02Answer.answer_2_6 = q02FinalAnswer[5];
            q02Answer.answer_2_7 = q02FinalAnswer[6];
        }
        //===================================================================================//
        const q03FinalAnswer = this.q03GetFinalAnswer();
        let q03Answer = {};
        if(q03FinalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question03, Please return : saveAll()');
            q03Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question03, Please proceed : saveAll()');
            q03Answer.answer_3_1 = q03FinalAnswer[0];
            q03Answer.answer_3_2 = q03FinalAnswer[1];
            q03Answer.answer_3_3 = q03FinalAnswer[2];
            q03Answer.answer_3_4 = q03FinalAnswer[3];
            q03Answer.answer_3_5 = q03FinalAnswer[4];
            q03Answer.answer_3_6 = q03FinalAnswer[5];
            q03Answer.answer_3_7 = q03FinalAnswer[6];
        }
        //===================================================================================//
        const q04FinalAnswer = this.q04GetFinalAnswer();
        let q04Answer = {};
        if(q04FinalAnswer.return !== undefined && q04FinalAnswer.return === 'No change in answer')
        {
            // console.log('No change in answer of Question04, Please return : saveAll()');
            q04Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question04, Please proceed : saveAll()');
            for(let key in q04FinalAnswer)
            {
                let str = key;
                str = str.replace("__c","");
                str = str.replace("Q","answer_");
                q04Answer[str] = q04FinalAnswer[key];
            }
        }
        //===================================================================================//
        //if(q01Answer !== null || q02Answer !== null || q03Answer !== null || q04Answer !== null)
        //{
            this.isLoading = true;   //Turn ON the spinner

            const allQA = {
                q01 : q01Answer,
                q02 : q02Answer,
                q03 : q03Answer,
                q04 : q04Answer
            };

            //this.rxRecordIdCMD1 = null; //For temperary purpose delete afterwards

            saveAllQA({
                recordIdCMD1 : this.rxRecordIdCMD1,
                studentId : this.rxStudentId,
                barCode : this.rxStudentBarcode,
                ans : allQA,
                lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
            }).then(result => {
                console.log('result : ' + JSON.stringify(result));
                //===========================================================//
                this.rxRecordIdCMD1 = result;
                this.reInitializeRecordCDM1();
                this.isLoading = false;   //Turn OFF the spinner
                //===========================================================//
                debugger;
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
        //}
        //===================================================================================//
        this.flag = 'saveAllQA';
        console.log('this.flag : ' + this.flag);
        console.log('rxRecordIdCMD1 = ',this.rxRecordIdCMD1)
        
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

    submit(){    
        //this.rxRecordIdCMD1 = null; //For temperary purpose delete afterwards
        if(this.rxRecordIdCMD1 == null)
        {
            confirm('Please save the record before submit');
            return;
        }

        this.isLoading = true;   //Turn ON the spinner
        submitAndCalculate({
            recordIdCMD1 : this.rxRecordIdCMD1
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            if(result === 'success')
            {
                this.reInitializeRecordCDM1();           
            }           
            this.isLoading = false;   //Turn OFF the spinner
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-1',
                message: 'Record submit successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */
        }).catch(error => {
            this.isLoading = false;   //Turn OFF the spinner
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while submitting the record';
            }else{
                this.rxError = 'रिकॉर्ड सबमिट करते समय त्रुटि';
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

        this.flag = 'submit';
        console.log('this.flag : ' + this.flag);
    }

    handleContinueButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'continueButton')
        {
            if(this.freeze)
            {
                this.backNavigateToInternalPage();
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
                    getBaselineRecord({
                        studentId : this.rxStudentId,
                        grade : this.grd,
                        type : 'CDM1',
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
                            this.errorTitle = 'Baseline CDM1 Assessment';
                            this.rxError = 'Error while receiving student records';
                        }else{
                            this.errorTitle = 'बेसलाइन सीडीएम1 मूल्यांकन';
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
        }

        this.flag = 'handleContinueButton';
        console.log('this.flag : ' + this.flag);
    }

    

    handleBackButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'backButton')
        {
            this.backNavigateToInternalPage();
        }

        this.flag = 'handleBackButton';
        console.log('this.flag : ' + this.flag);
    }

    backNavigateToInternalPage() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'baseline_cdm1_assesment_V2__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd),
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid),
                typ :  encodeURI(this.typ),
                lng : encodeURI(this.lng)
            }
        });
    }
    //==========================================================//
    getBatchInformation(){           
        getBatchInfo({
            batchId : this.rxBatch
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const batchWrapper = JSON.parse(JSON.stringify(result));
            if(batchWrapper.batchName !== undefined)this.batchName = batchWrapper.batchName;
            if(batchWrapper.batchNumber !== undefined)this.batchNumber = batchWrapper.batchNumber;
            if(batchWrapper.schoolName !== undefined)this.schoolName = batchWrapper.schoolName;
            this.isLoading = false;
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-1',
                message: 'Batch information received',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'getBatchInformation';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            this.isLoading = false;
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while receiving batch information';
            }else{
                this.rxError = 'बैच सूचना प्राप्त करते समय त्रुटि';
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


   
}