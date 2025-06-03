/*
    // ## 1 --- Commented below code to Stop Save for every question
*/

import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getRecordCDM2 from '@salesforce/apex/careerDecisionMaking_02.getRecordCDM2';
import saveQuestion05 from '@salesforce/apex/careerDecisionMaking_02.saveQuestion05';
import saveQuestion06 from '@salesforce/apex/careerDecisionMaking_02.saveQuestion06';
import saveAllQA from '@salesforce/apex/careerDecisionMaking_02.saveAllQA';
import submitAndCalculate from '@salesforce/apex/careerDecisionMaking_02.submitAndCalculate';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import getAssesmentQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';
import getBaselineRecord from '@salesforce/apex/BaselineAssessmentController.getBaselineRecord';

export default class CarrerDecisionMaking02V2 extends NavigationMixin(LightningElement) {
    lng;
    isEnglish;
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';
    typ;
    //=======================================================//
    rxStudentId = null;
    cdm1Id = null;
    rxStudentBarcode = null;    
    rxRecordIdCMD2 = null;
    //=======================================================//
    fem = null;
    sch = null;
    grd = null;
    bid = null;
    acid = null;
    batchNumber = null;
    //=======================================================//
    flag = '';
    antarangImage = logo_01;
    isLoading = true;
    studentName = null;
    //studentGrade = null;
    @track freeze = true;
    //=======================================================//
    
    // ## 1 Start
    // delay = 5000;   //Delay = 5 sec
    // delayTimeOut00;

    // delayTimeOut01;
    // delayTimeOut02;
    // delayTimeOut03;
    // delayTimeOut04;
    // delayTimeOut05;
    // delayTimeOut06;
    // delayTimeOut07;
    // delayTimeOut08;
    // delayTimeOut09;
    // delayTimeOut10;
    // delayTimeOut11;
    // delayTimeOut12;
    // ## 1 Stop

    //=======================================================//
    question05 = '';
    initAnswer05 = '';
    @track q05_Options = [];
    //=======================================================//
    question06 = '6. Mark all the options that fit into the industry';

    block_06_01 = '';
    block_06_02 = '';
    block_06_03 = '';
    block_06_04 = '';
    //=======================================================//
    question06_01 = '';
    initAnswer06_01 = '';
    @track q06_01_Options = [];
    //=======================================================//
    question06_02 = '';
    initAnswer06_02 = '';
    @track q06_02_Options = [];

    question06_03 = '';
    initAnswer06_03 = '';
    @track q06_03_Options = [];
	
	question06_04 = '(IV) Public Services';
    initAnswer06_04 = '';
    @track q06_04_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Social Worker'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Army'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Beautician'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Air Force' 
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) Navy' 
        },
        {
            optionName:'F',
            answer: false,
            optionValue:'(f) Teacher'
        },
        {
            optionName:'G',
            answer: false,
            optionValue:'(g) Indian Administrative Services'
        },
        {
            optionName:'H',
            answer: false,
            optionValue:'(h) Logistics Worker'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:' No Answer'
        }
    ];
	
    question06_05 = '(V) Finance';
    initAnswer06_05 = '';
    @track q06_05_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Horticulturist'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Banks'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Computer'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Insurance' 
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) Investment' 
        },
        {
            optionName:'F',
            answer: false,
            optionValue:'(f) Bachelor of Accounting & Finance'
        },
        {
            optionName:'G',
            answer: false,
            optionValue:'(g) Gym Trainer'
        },
        {
            optionName:'H',
            answer: false,
            optionValue:'(h) Financial Analyst'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:' No Answer'
        }
    ];
	
    question06_06 = '(VI) Tourism and Hospitality';
    initAnswer06_06 = '';
    @track q06_06_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Hotel'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Chef'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Hospital'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Customer' 
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) Travel Planner' 
        },
        {
            optionName:'F',
            answer: false,
            optionValue:'(f) Architect'
        },
        {
            optionName:'G',
            answer: false,
            optionValue:'(g) Commercial Pilot'
        },
        {
            optionName:'H',
            answer: false,
            optionValue:'(h) Journalist'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:' No Answer'
        }
    ];
	
    question06_07 = '(VII) Art, Design & Architecture';
    initAnswer06_07 = '';
    @track q06_07_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Bachelors in Architecture'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Sales'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Police Officer'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Fashion Designer' 
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) Clothes' 
        },
        {
            optionName:'F',
            answer: false,
            optionValue:'(f) Hotels'
        },
        {
            optionName:'G',
            answer: false,
            optionValue:'(g) Make Logos'
        },
        {
            optionName:'H',
            answer: false,
            optionValue:'(h) Creative'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:' No Answer'
        }
    ];
	
    question06_08 = '(VIII) Media and Entertainment';
    initAnswer06_08 = '';
    @track q06_08_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Film/Audio Visual'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Lawyer'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Performing Artist'
        },	
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Investment' 
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) Bachelors in Mass Media' 
        },
        {
            optionName:'F',
            answer: false,
            optionValue:'(f) Event Planner'
        },
        {
            optionName:'G',
            answer: false,
            optionValue:'(g) Editor'
        },
        {
            optionName:'H',
            answer: false,
            optionValue:'(h) Artificial Intelligence'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:' No Answer'
        }
    ];
	
    question06_09 = '(IX) Information Technology';
    initAnswer06_09 = '';
    @track q06_09_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Coding'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Application Developer'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Data Analyst'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Artist' 
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) Cyber Security Specialist' 
        },
        {
            optionName:'F',
            answer: false,
            optionValue:'(f) The Times Group'
        },
        {
            optionName:'G',
            answer: false,
            optionValue:'(g) Fire-Fighter'
        },
        {
            optionName:'H',
            answer: false,
            optionValue:'(h) Computer'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:' No Answer'
        }
    ];
	
    question06_10 = '(X) Engineering & Trades';
    initAnswer06_10 = '';
    @track q06_10_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Bachelor of Technology'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Plumber'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Mechanic'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Repair' 
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) Artificial Intelligence' 
        },
        {
            optionName:'F',
            answer: false,
            optionValue:'(f) Photographer'
        },
        {
            optionName:'G',
            answer: false,
            optionValue:'(g) Building Machines'
        },
        {
            optionName:'H',
            answer: false,
            optionValue:'(h) Accountant'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:' No Answer'
        }
    ];
	
    question06_11 = '(XI) Industry Independent';
    initAnswer06_11 = '';
    @track q06_11_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Accountant'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Tourists'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Entrepreneur'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Delivering goods' 
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) Office Administrator' 
        },
        {
            optionName:'F',
            answer: false,
            optionValue:'(f) Firefighter'
        },
        {
            optionName:'G',
            answer: false,
            optionValue:'(g) Lawyer'
        },
        {
            optionName:'H',
            answer: false,
            optionValue:'(h) Sports Coach'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:' No Answer'
        }
    ];
	
    question06_12 = '(XII) Environment and Bioscience';
    initAnswer06_12 = '';
    @track q06_12_Options = [
        {
            optionName:'A', 
            answer: false,
            optionValue:'(a) Pharmacist'          
        },
        {
            optionName:'B',
            answer: false,
            optionValue:'(b) Agriculturist'
        },
        {
            optionName:'C',
            answer: false,
            optionValue:'(c) Plumber'
        },
        {
            optionName:'D',
            answer: false,
            optionValue:'(d) Horticulturist' 
        },
        {
            optionName:'E',
            answer: false,
            optionValue:'(e) Food Scientist' 
        },
        {
            optionName:'F',
            answer: false,
            optionValue:'(f) City Planner'
        },
        {
            optionName:'G',
            answer: false,
            optionValue:'(g) Botanical Garden'
        },
        {
            optionName:'H',
            answer: false,
            optionValue:'(h) Coach'
        },
        {
            optionName:'nil',
            answer: false,
            optionValue:' No Answer'
        }
    ];
    //=======================================================//

    @wire(CurrentPageReference)
    getCurrentPageReference(currentPageReference) {
        if(currentPageReference) 
        {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.rxStudentId = rxCurrentPageReference.state.studentId;
            this.cdm1Id = rxCurrentPageReference.state.cdm1Id;

            this.fem = decodeURI(rxCurrentPageReference.state.fem);
            this.sch = decodeURI(rxCurrentPageReference.state.sch);
            this.grd = decodeURI(rxCurrentPageReference.state.grd);
            this.bid = decodeURI(rxCurrentPageReference.state.bid);
            this.acid = decodeURI(rxCurrentPageReference.state.acid);
            this.typ = decodeURI(rxCurrentPageReference.state.typ);
            this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;
            if(this.isEnglish){
                this.title = 'Baseline Career Decision Making-2 Data';
                this.errorTitle = 'Error';
                this.successMsg ='Baseline Career Decision Making-2 - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'आधारभूत करियर के निर्णय - 2 डेटा';
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
        this.getApexRecordCDM2();
        this.flag = 'connectedCallback';
        console.log('this.flag : ' + this.flag);
    }
    //This method is called to get all questions
    getAssesmentQuestionFunc(){
        getAssesmentQuestion({
            objectName : 'CDM2',
            formType : 'Form V2',
            grade : ''
        }).then(result => {
            console.log('getAssesmentQuestion Result = '+JSON.stringify(result));
            if(result){
                this.assesmentQuestionAndLabel = result;
                let que5 = this.getQuestionsAndOptions(5);
                if(que5){
                    this.question05 = que5.question;
                    this.q05_Options = que5.options;
                }
                let que6_1 = this.getQuestionsAndOptions(6);
                if(que6_1){
                    this.block_06_01 =que6_1.question;
                }
                let que6_1_1 = this.getQuestionsAndOptions(7);
                if(que6_1_1){
                    this.question06_01 = que6_1_1.question;
                    this.q06_01_Options = que6_1_1.options;
                }
                let que6_1_2 = this.getQuestionsAndOptions(8);
                if(que6_1_2){
                    this.question06_02 = que6_1_2.question;
                    this.q06_02_Options = que6_1_2.options;
                }
                let que6_1_3 = this.getQuestionsAndOptions(9);
                if(que6_1_3){
                    this.question06_03 = que6_1_3.question;
                    this.q06_03_Options = que6_1_3.options;
                }
                let que6_1_4 = this.getQuestionsAndOptions(10);
                if(que6_1_4){
                    this.question06_04 = que6_1_4.question;
                    this.q06_04_Options = que6_1_4.options;
                }
                let que6_1_5 = this.getQuestionsAndOptions(11);
                if(que6_1_5){
                    this.question06_05 = que6_1_5.question;
                    this.q06_05_Options = que6_1_5.options;
                }
                let que6_1_6 = this.getQuestionsAndOptions(12);
                if(que6_1_6){
                    this.question06_06 = que6_1_6.question;
                    this.q06_06_Options = que6_1_6.options;
                }
                let que6_1_7 = this.getQuestionsAndOptions(13);
                if(que6_1_7){
                    this.question06_07 = que6_1_7.question;
                    this.q06_07_Options = que6_1_7.options;
                }
                let que6_1_8 = this.getQuestionsAndOptions(14);
                if(que6_1_8){
                    this.question06_08 = que6_1_8.question;
                    this.q06_08_Options = que6_1_8.options;
                }
                let que6_1_9 = this.getQuestionsAndOptions(15);
                if(que6_1_9){
                    this.question06_09 = que6_1_9.question;
                    this.q06_09_Options = que6_1_9.options;
                }
                let que6_1_10 = this.getQuestionsAndOptions(16);
                if(que6_1_10){
                    this.question06_10 = que6_1_10.question;
                    this.q06_10_Options = que6_1_10.options;
                }
                let que6_1_11 = this.getQuestionsAndOptions(17);
                if(que6_1_11){
                    this.question06_11 = que6_1_11.question;
                    this.q06_11_Options = que6_1_11.options;
                }
                let que6_1_12 = this.getQuestionsAndOptions(18);
                if(que6_1_12){
                    this.question06_12 = que6_1_12.question;
                    this.q06_12_Options = que6_1_12.options;
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
            question =(this.lng === 'Hindi') ? que.Question_Label_Hindi__c :que.Question_Label_English__c;
            if(que.Assessment_Question_Options__r){
                let optionNames = ['A', 'B', 'C', 'D', 'E','F','G','H','I'];
                let i=0;
                for (let opt of que.Assessment_Question_Options__r) {
                    let optionValue =  (this.lng === 'Hindi') ? opt.Option_Label_Hindi__c :opt.Option_Label_English__c;
                    let optionName = (opt.Option_Label_English__c === 'No Answer') ? 'nil' : (opt.Option_Label_English__c === 'Multiple answers selected') ? '*' :  optionNames[i];
                    let option = (seqNumber === 4) ? {apiName: optionName , value: optionValue} :{optionName:optionName, answer: false,optionValue:optionValue }
                    options.push(option);
                    i++;
                }
            }
        }
        return {question,options};
    }
    renderedCallback()
    {

        this.flag = 'renderedCallback';
        console.log('this.flag : ' + this.flag);
    }

    getApexRecordCDM2(){
        getRecordCDM2({
            studentId : this.rxStudentId,
            grade : this.grd,
            batchId : this.bid
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
                if(singleRecordWrapper.recordCDM2 === undefined || 
                    singleRecordWrapper.recordCDM2 === null)
                {
                    //console.log('CDM2 record does not exist');
                    this.freeze = false;
                    this.isLoading = false;
                    break;
                }

                const record = singleRecordWrapper.recordCDM2;

                if(record.Form_Submitted__c)this.freeze = true;
                else this.freeze = false;

                this.rxRecordIdCMD2 = record.Id;
                
                //Place init for question05 here
                this.initAnswer05 = record.Q5__c;

                let foundAns5 = false;
                for(let key in this.q05_Options){
                    if(this.q05_Options[key].optionName === record.Q5__c)
                    {
                        this.q05_Options[key].answer = true;
                        foundAns5 = true;
                    }
                }

                if(!foundAns5)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q05_Options){
                            if(this.q05_Options[key].optionName === 'nil')
                            {
                                this.q05_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }               
                //Place init for question06_01 here
                this.initAnswer06_01 = record.Q6_1__c;
                let foundAns6_01 = false;

                if(record.Q6_1__c !== undefined && record.Q6_1__c !== null)
                {
                    for(let key in this.q06_01_Options){
                        let option = this.q06_01_Options[key].optionName;
                        if(record.Q6_1__c.includes(option))
                        {
                            this.q06_01_Options[key].answer = true;
                            foundAns6_01 = true;
                        }
                    }
                }

                if(!foundAns6_01)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q06_01_Options){
                            if(this.q06_01_Options[key].optionName === 'nil')
                            {
                                this.q06_01_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question06_02 here
                this.initAnswer06_02 = record.Q6_2__c;
                let foundAns6_02 = false;
                if(record.Q6_2__c !== undefined && record.Q6_2__c !== null)
                {
                    for(let key in this.q06_02_Options){
                        let option = this.q06_02_Options[key].optionName;
                        if(record.Q6_2__c.includes(option))
                        {
                            this.q06_02_Options[key].answer = true;
                            foundAns6_02 = true;
                        }
                    }
                }

                if(!foundAns6_02)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q06_02_Options){
                            if(this.q06_02_Options[key].optionName === 'nil')
                            {
                                this.q06_02_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question06_03 here
                this.initAnswer06_03 = record.Q6_3__c;
                let foundAns6_03 = false;
                if(record.Q6_3__c !== undefined && record.Q6_3__c !== null)
                {
                    for(let key in this.q06_03_Options){
                        let option = this.q06_03_Options[key].optionName;
                        if(record.Q6_3__c.includes(option))
                        {
                            this.q06_03_Options[key].answer = true;
                            foundAns6_03 = true;
                        }
                    }
                }
                
                if(!foundAns6_03)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q06_03_Options){
                            if(this.q06_03_Options[key].optionName === 'nil')
                            {
                                this.q06_03_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question06_04 here
                this.initAnswer06_04 = record.Q6_4__c;
                let foundAns6_04 = false;
                if(record.Q6_4__c !== undefined && record.Q6_4__c !== null)
                {
                    for(let key in this.q06_04_Options){
                        let option = this.q06_04_Options[key].optionName;
                        if(record.Q6_4__c.includes(option))
                        {
                            this.q06_04_Options[key].answer = true;
                            foundAns6_04 = true;
                        }
                    }
                }
                
                if(!foundAns6_04)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q06_04_Options){
                            if(this.q06_04_Options[key].optionName === 'nil')
                            {
                                this.q06_04_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question06_05 here
                this.initAnswer06_05 = record.Q6_5__c;
                let foundAns6_05 = false;
                if(record.Q6_5__c !== undefined && record.Q6_5__c !== null)
                {
                    for(let key in this.q06_05_Options){
                        let option = this.q06_05_Options[key].optionName;
                        if(record.Q6_5__c.includes(option))
                        {
                            this.q06_05_Options[key].answer = true;
                            foundAns6_05 = true;
                        }
                    }
                }
                
                if(!foundAns6_05)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q06_05_Options){
                            if(this.q06_05_Options[key].optionName === 'nil')
                            {
                                this.q06_05_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question06_06 here
                this.initAnswer06_06 = record.Q6_6__c;
                let foundAns6_06 = false;
                if(record.Q6_6__c !== undefined && record.Q6_6__c !== null)
                {
                    for(let key in this.q06_06_Options){
                        let option = this.q06_06_Options[key].optionName;
                        if(record.Q6_6__c.includes(option))
                        {
                            this.q06_06_Options[key].answer = true;
                            foundAns6_06 = true;
                        }
                    }
                }
                
                if(!foundAns6_06)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q06_06_Options){
                            if(this.q06_06_Options[key].optionName === 'nil')
                            {
                                this.q06_06_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question06_07 here
                this.initAnswer06_07 = record.Q6_7__c;
                let foundAns6_07 = false;
                if(record.Q6_7__c !== undefined && record.Q6_7__c !== null)
                {
                    for(let key in this.q06_07_Options){
                        let option = this.q06_07_Options[key].optionName;
                        if(record.Q6_7__c.includes(option))
                        {
                            this.q06_07_Options[key].answer = true;
                            foundAns6_07 = true;
                        }
                    }
                }
                
                if(!foundAns6_07)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q06_07_Options){
                            if(this.q06_07_Options[key].optionName === 'nil')
                            {
                                this.q06_07_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question06_08 here
                this.initAnswer06_08 = record.Q6_8__c;
                let foundAns6_08 = false;
                if(record.Q6_8__c !== undefined && record.Q6_8__c !== null)
                {
                    for(let key in this.q06_08_Options){
                        let option = this.q06_08_Options[key].optionName;
                        if(record.Q6_8__c.includes(option))
                        {
                            this.q06_08_Options[key].answer = true;
                            foundAns6_08 = true;
                        }
                    }
                }
                
                if(!foundAns6_08)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q06_08_Options){
                            if(this.q06_08_Options[key].optionName === 'nil')
                            {
                                this.q06_08_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question06_09 here
                this.initAnswer06_09 = record.Q6_9__c;
                let foundAns6_09 = false;
                if(record.Q6_9__c !== undefined && record.Q6_9__c !== null)
                {
                    for(let key in this.q06_09_Options){
                        let option = this.q06_09_Options[key].optionName;
                        if(record.Q6_9__c.includes(option))
                        {
                            this.q06_09_Options[key].answer = true;
                            foundAns6_09 = true;
                        }
                    }
                }
                
                if(!foundAns6_09)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q06_09_Options){
                            if(this.q06_09_Options[key].optionName === 'nil')
                            {
                                this.q06_09_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question06_10 here
                this.initAnswer06_10 = record.Q6_10__c;
                let foundAns6_10 = false;
                if(record.Q6_10__c !== undefined && record.Q6_10__c !== null)
                {
                    for(let key in this.q06_10_Options){
                        let option = this.q06_10_Options[key].optionName;
                        if(record.Q6_10__c.includes(option))
                        {
                            this.q06_10_Options[key].answer = true;
                            foundAns6_10 = true;
                        }
                    }
                }
                
                if(!foundAns6_10)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q06_10_Options){
                            if(this.q06_10_Options[key].optionName === 'nil')
                            {
                                this.q06_10_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question06_11 here
                this.initAnswer06_11 = record.Q6_11__c;
                let foundAns6_11 = false;
                if(record.Q6_11__c !== undefined && record.Q6_11__c !== null)
                {
                    for(let key in this.q06_11_Options){
                        let option = this.q06_11_Options[key].optionName;
                        if(record.Q6_11__c.includes(option))
                        {
                            this.q06_11_Options[key].answer = true;
                            foundAns6_11 = true;
                        }
                    }
                }

                if(!foundAns6_11)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q06_11_Options){
                            if(this.q06_11_Options[key].optionName === 'nil')
                            {
                                this.q06_11_Options[key].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question06_12 here
                this.initAnswer06_12 = record.Q6_12__c;
                let foundAns6_12 = false;
                if(record.Q6_12__c !== undefined && record.Q6_12__c !== null)
                {
                    for(let key in this.q06_12_Options){
                        let option = this.q06_12_Options[key].optionName;
                        if(record.Q6_12__c.includes(option))
                        {
                            this.q06_12_Options[key].answer = true;
                            foundAns6_12 = true;
                        }
                    }
                }

                if(!foundAns6_12)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let key in this.q06_12_Options){
                            if(this.q06_12_Options[key].optionName === 'nil')
                            {
                                this.q06_12_Options[key].answer = true;
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
                    title: 'Career Decision Making-2',
                    message: 'Career Decision Making-2 record fields received successfuly',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
            }while(false);
            this.flag = 'getApexRecordCDM2';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError ;
            if(this.isEnglish){
            this.rxError = 'Error while recieving record fields: Career Decision Making-2';
            }else{
                this.rxError = 'रिकॉर्ड फ़ील्ड प्राप्त करते समय त्रुटि: करियर के निर्णय - 2';
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

    reInitializeRecordCDM2(){
        getRecordCDM2({
            studentId : this.rxStudentId,
            grade : this.grd
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            const singleRecordWrapper = JSON.parse(JSON.stringify(result));
            //===========================================================//
            const record = singleRecordWrapper.recordCDM2;

            if(record.Form_Submitted__c)this.freeze = true;
            else this.freeze = false;
            
            //Place init for question05 here
            this.initAnswer05 = record.Q5__c;

            //Place init for question06_01 here
            this.initAnswer06_01 = record.Q6_1__c;

            //Place init for question06_02 here
            this.initAnswer06_02 = record.Q6_2__c;

            //Place init for question06_03 here
            this.initAnswer06_03 = record.Q6_3__c;

            //Place init for question06_04 here
            this.initAnswer06_04 = record.Q6_4__c;

            //Place init for question06_05 here
            this.initAnswer06_05 = record.Q6_5__c;

            //Place init for question06_06 here
            this.initAnswer06_06 = record.Q6_6__c;

            //Place init for question06_07 here
            this.initAnswer06_07 = record.Q6_7__c;

            //Place init for question06_08 here
            this.initAnswer06_08 = record.Q6_8__c;

            //Place init for question06_09 here
            this.initAnswer06_09 = record.Q6_9__c;

            //Place init for question06_10 here
            this.initAnswer06_10 = record.Q6_10__c;

            //Place init for question06_11 here
            this.initAnswer06_11 = record.Q6_11__c;

            //Place init for question06_12 here
            this.initAnswer06_12 = record.Q6_12__c;

            this.flag = 'reInitializeRecordCDM2';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while recieving record fields: Career Decision Making-2 (reInit)';
            }else{
                this.rxError = 'रिकॉर्ड फ़ील्ड प्राप्त करते समय त्रुटि: करियर के निर्णय - 2 (रीइनिट)';
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

    q05GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q05_Options){
            if(this.q05_Options[key].answer)
            {
                if(this.q05_Options[key].optionName === 'nil')continue;
                finalAnswer = this.q05_Options[key].optionName;
                break;
            }
        }

        if(finalAnswer === this.initAnswer05)finalAnswer = 'return';
        //console.log('q05GetFinalAnswer : ' + finalAnswer);
        // console.log('initAnswer05 : ' + this.initAnswer05);
        return finalAnswer;
    }

    saveQ05(){
        const finalAnswer = this.q05GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question05, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question05, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveQuestion05({
            recordIdCMD2 : this.rxRecordIdCMD2,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD2 = result;
            this.reInitializeRecordCDM2();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-2',
                message: 'Question05 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion05';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question05 answer';
            }else{
                this.rxError = 'प्रश्न05 का उत्तर डालते समय त्रुटि हुई';
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

    handleQ05(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q05_Options){
            if(this.q05_Options[key].optionName === targetId)
            {
                this.q05_Options[key].answer = targetValue;
            }
            else
            {
                this.q05_Options[key].answer = false;
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut00) {
        //     window.clearTimeout(this.delayTimeOut00);
        // }

        // this.delayTimeOut00 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ05();
        // }, this.delay);
        // ## 1 Stop

        this.flag = 'handleQ05';
        console.log('this.flag : ' + this.flag);
    }

    q06_01GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q06_01_Options){
            if(this.q06_01_Options[key].answer)
            {
                if(this.q06_01_Options[key].optionName === 'nil')continue;
                if(finalAnswer !== undefined)finalAnswer += ',' + this.q06_01_Options[key].optionName;
                else finalAnswer = this.q06_01_Options[key].optionName;
            }
        }

        // console.log('initAnswer06_01 : ' + this.initAnswer06_01);
        // console.log('q06_01GetFinalAnswer : ' + finalAnswer);
        if(finalAnswer === this.initAnswer06_01)finalAnswer = 'return';
        return finalAnswer;
    }

    saveQ06_01(){
        const finalAnswer = this.q06_01GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_01, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question06_01, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveQuestion06({
            recordIdCMD2 : this.rxRecordIdCMD2,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            subIndex : '1',
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD2 = result;
            this.reInitializeRecordCDM2();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-2',
                message: 'Question06_01 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion06_01';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question06_01 answer';
            }else{
                this.rxError = 'प्रश्न06_01 उत्तर डालते समय त्रुटि';
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

    handleQ06_01(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        /*
        for(let key in this.q06_01_Options){
            if(this.q06_01_Options[key].optionName === targetId)
            {
                this.q06_01_Options[key].answer = targetValue;
            }
        }*/ 

        if(targetId === 'nil')
        {
            for(let key in this.q06_01_Options){
                if(this.q06_01_Options[key].optionName === 'nil')
                {
                    this.q06_01_Options[key].answer = targetValue;
                }
                else
                {
                    this.q06_01_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q06_01_Options){
                if(this.q06_01_Options[key].optionName === targetId)
                {
                    this.q06_01_Options[key].answer = targetValue;
                }
                else if(this.q06_01_Options[key].optionName === 'nil')
                {
                    this.q06_01_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut01) {
        //     window.clearTimeout(this.delayTimeOut01);
        // }

        // this.delayTimeOut01 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ06_01();
        // }, this.delay);
        // ## 1 Stop

        this.flag = 'handleQ06_01';
        console.log('this.flag : ' + this.flag);
    }

    q06_02GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q06_02_Options){
            if(this.q06_02_Options[key].answer)
            {
                if(this.q06_02_Options[key].optionName === 'nil')continue;
                if(finalAnswer !== undefined)finalAnswer += ',' + this.q06_02_Options[key].optionName;
                else finalAnswer = this.q06_02_Options[key].optionName;
            }
        }

        // console.log('initAnswer06_02 : ' + this.initAnswer06_02);
        // console.log('q06_02GetFinalAnswer : ' + finalAnswer);
        if(finalAnswer === this.initAnswer06_02)finalAnswer = 'return';
        return finalAnswer;
    }

    saveQ06_02(){
        const finalAnswer = this.q06_02GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_02, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question06_02, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveQuestion06({
            recordIdCMD2 : this.rxRecordIdCMD2,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            subIndex : '2',
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD2 = result;
            this.reInitializeRecordCDM2();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-2',
                message: 'Question06_02 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion06_02';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question06_02 answer';
            }else{
                this.rxError = 'प्रश्न06_02 उत्तर सम्मिलित करते समय त्रुटि';
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

    handleQ06_02(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        /*
        for(let key in this.q06_02_Options){
            if(this.q06_02_Options[key].optionName === targetId)
            {
                this.q06_02_Options[key].answer = targetValue;
            }
        }*/
        
        if(targetId === 'nil')
        {
            for(let key in this.q06_02_Options){
                if(this.q06_02_Options[key].optionName === 'nil')
                {
                    this.q06_02_Options[key].answer = targetValue;
                }
                else
                {
                    this.q06_02_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q06_02_Options){
                if(this.q06_02_Options[key].optionName === targetId)
                {
                    this.q06_02_Options[key].answer = targetValue;
                }
                else if(this.q06_02_Options[key].optionName === 'nil')
                {
                    this.q06_02_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut02) {
        //     window.clearTimeout(this.delayTimeOut02);
        // }

        // this.delayTimeOut02 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ06_02();
        // }, this.delay);
        // ## 1 Stop

        this.flag = 'handleQ06_02';
        console.log('this.flag : ' + this.flag);
    }

    q06_03GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q06_03_Options){
            if(this.q06_03_Options[key].answer)
            {
                if(this.q06_03_Options[key].optionName === 'nil')continue;
                if(finalAnswer !== undefined)finalAnswer += ',' + this.q06_03_Options[key].optionName;
                else finalAnswer = this.q06_03_Options[key].optionName;
            }
        }

        // console.log('initAnswer06_03 : ' + this.initAnswer06_03);
        // console.log('q06_03GetFinalAnswer : ' + finalAnswer);
        if(finalAnswer === this.initAnswer06_03)finalAnswer = 'return';
        return finalAnswer;
    }

    saveQ06_03(){
        const finalAnswer = this.q06_03GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_03, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question06_03, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveQuestion06({
            recordIdCMD2 : this.rxRecordIdCMD2,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            subIndex : '3',
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD2 = result;
            this.reInitializeRecordCDM2();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-2',
                message: 'Question06_03 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion06_03';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question06_03 answer';
            }else{
                this.rxError = 'प्रश्न06_03 उत्तर सम्मिलित करते समय त्रुटि';
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

    handleQ06_03(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        /*
        for(let key in this.q06_03_Options){
            if(this.q06_03_Options[key].optionName === targetId)
            {
                this.q06_03_Options[key].answer = targetValue;
            }
        }*/

        if(targetId === 'nil')
        {
            for(let key in this.q06_03_Options){
                if(this.q06_03_Options[key].optionName === 'nil')
                {
                    this.q06_03_Options[key].answer = targetValue;
                }
                else
                {
                    this.q06_03_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q06_03_Options){
                if(this.q06_03_Options[key].optionName === targetId)
                {
                    this.q06_03_Options[key].answer = targetValue;
                }
                else if(this.q06_03_Options[key].optionName === 'nil')
                {
                    this.q06_03_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut03) {
        //     window.clearTimeout(this.delayTimeOut03);
        // }

        // this.delayTimeOut03 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ06_03();
        // }, this.delay);
        // ## 1 Stop

        this.flag = 'handleQ06_03';
        console.log('this.flag : ' + this.flag);
    }
	
    q06_04GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q06_04_Options){
            if(this.q06_04_Options[key].answer)
            {
                if(this.q06_04_Options[key].optionName === 'nil')continue;
                if(finalAnswer !== undefined)finalAnswer += ',' + this.q06_04_Options[key].optionName;
                else finalAnswer = this.q06_04_Options[key].optionName;
            }
        }

        // console.log('initAnswer06_04 : ' + this.initAnswer06_04);
        // console.log('q06_04GetFinalAnswer : ' + finalAnswer);
        if(finalAnswer === this.initAnswer06_04)finalAnswer = 'return';
        return finalAnswer;
    }

    saveQ06_04(){
        const finalAnswer = this.q06_04GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_04, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question06_04, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveQuestion06({
            recordIdCMD2 : this.rxRecordIdCMD2,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            subIndex : '4',
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD2 = result;
            this.reInitializeRecordCDM2();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-2',
                message: 'Question06_04 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion06_04';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question06_04 answer';
            }else{
                this.rxError = 'प्रश्न06_04 उत्तर सम्मिलित करते समय त्रुटि';
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

    handleQ06_04(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        /*
        for(let key in this.q06_04_Options){
            if(this.q06_04_Options[key].optionName === targetId)
            {
                this.q06_04_Options[key].answer = targetValue;
            }
        }*/ 

        if(targetId === 'nil')
        {
            for(let key in this.q06_04_Options){
                if(this.q06_04_Options[key].optionName === 'nil')
                {
                    this.q06_04_Options[key].answer = targetValue;
                }
                else
                {
                    this.q06_04_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q06_04_Options){
                if(this.q06_04_Options[key].optionName === targetId)
                {
                    this.q06_04_Options[key].answer = targetValue;
                }
                else if(this.q06_04_Options[key].optionName === 'nil')
                {
                    this.q06_04_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut04) {
        //     window.clearTimeout(this.delayTimeOut04);
        // }

        // this.delayTimeOut04 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ06_04();
        // }, this.delay);
        // ## 1 Stop
        
        this.flag = 'handleQ06_04';
        console.log('this.flag : ' + this.flag);
    }
	
	q06_05GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q06_05_Options){
            if(this.q06_05_Options[key].answer)
            {
                if(this.q06_05_Options[key].optionName === 'nil')continue;
                if(finalAnswer !== undefined)finalAnswer += ',' + this.q06_05_Options[key].optionName;
                else finalAnswer = this.q06_05_Options[key].optionName;
            }
        }

        // console.log('initAnswer06_05 : ' + this.initAnswer06_05);
        // console.log('q06_05GetFinalAnswer : ' + finalAnswer);
        if(finalAnswer === this.initAnswer06_05)finalAnswer = 'return';
        return finalAnswer;
    }

    saveQ06_05(){
        const finalAnswer = this.q06_05GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_05, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question06_05, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveQuestion06({
            recordIdCMD2 : this.rxRecordIdCMD2,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            subIndex : '5',
            lng : this.lng,
            typ : (this.typ == 'v2' ||  this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD2 = result;
            this.reInitializeRecordCDM2();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-2',
                message: 'Question06_05 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion06_05';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError  = 'Error while upserting Question06_05 answer';
            }else{
                this.rxError = 'प्रश्न06_05 उत्तर सम्मिलित करते समय त्रुटि';
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

    handleQ06_05(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        /*
        for(let key in this.q06_05_Options){
            if(this.q06_05_Options[key].optionName === targetId)
            {
                this.q06_05_Options[key].answer = targetValue;
            }
        }*/

        if(targetId === 'nil')
        {
            for(let key in this.q06_05_Options){
                if(this.q06_05_Options[key].optionName === 'nil')
                {
                    this.q06_05_Options[key].answer = targetValue;
                }
                else
                {
                    this.q06_05_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q06_05_Options){
                if(this.q06_05_Options[key].optionName === targetId)
                {
                    this.q06_05_Options[key].answer = targetValue;
                }
                else if(this.q06_05_Options[key].optionName === 'nil')
                {
                    this.q06_05_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut05) {
        //     window.clearTimeout(this.delayTimeOut05);
        // }

        // this.delayTimeOut05 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ06_05();
        // }, this.delay);
        // ## 1 Stop
        
        this.flag = 'handleQ06_05';
        console.log('this.flag : ' + this.flag);
    }
	
	q06_06GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q06_06_Options){
            if(this.q06_06_Options[key].answer)
            {
                if(this.q06_06_Options[key].optionName === 'nil')continue;
                if(finalAnswer !== undefined)finalAnswer += ',' + this.q06_06_Options[key].optionName;
                else finalAnswer = this.q06_06_Options[key].optionName;
            }
        }

        // console.log('initAnswer06_06 : ' + this.initAnswer06_06);
        // console.log('q06_06GetFinalAnswer : ' + finalAnswer);
        if(finalAnswer === this.initAnswer06_06)finalAnswer = 'return';
        return finalAnswer;
    }

    saveQ06_06(){
        const finalAnswer = this.q06_06GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_06, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question06_06, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveQuestion06({
            recordIdCMD2 : this.rxRecordIdCMD2,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            subIndex : '6',
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD2 = result;
            this.reInitializeRecordCDM2();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-2',
                message: 'Question06_06 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion06_06';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError  = 'Error while upserting Question06_06 answer';
            }else{
                this.rxError = 'प्रश्न06_06 उत्तर सम्मिलित करते समय त्रुटि';
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

    handleQ06_06(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        /*
        for(let key in this.q06_06_Options){
            if(this.q06_06_Options[key].optionName === targetId)
            {
                this.q06_06_Options[key].answer = targetValue;
            }
        }*/

        if(targetId === 'nil')
        {
            for(let key in this.q06_06_Options){
                if(this.q06_06_Options[key].optionName === 'nil')
                {
                    this.q06_06_Options[key].answer = targetValue;
                }
                else
                {
                    this.q06_06_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q06_06_Options){
                if(this.q06_06_Options[key].optionName === targetId)
                {
                    this.q06_06_Options[key].answer = targetValue;
                }
                else if(this.q06_06_Options[key].optionName === 'nil')
                {
                    this.q06_06_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut06) {
        //     window.clearTimeout(this.delayTimeOut06);
        // }

        // this.delayTimeOut06 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ06_06();
        // }, this.delay);
        // ## 1 Stop
        
        this.flag = 'handleQ06_06';
        console.log('this.flag : ' + this.flag);
    }
	
    q06_07GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q06_07_Options){
            if(this.q06_07_Options[key].answer)
            {
                if(this.q06_07_Options[key].optionName === 'nil')continue;
                if(finalAnswer !== undefined)finalAnswer += ',' + this.q06_07_Options[key].optionName;
                else finalAnswer = this.q06_07_Options[key].optionName;
            }
        }

        // console.log('initAnswer06_07 : ' + this.initAnswer06_07);
        // console.log('q06_07GetFinalAnswer : ' + finalAnswer);
        if(finalAnswer === this.initAnswer06_07)finalAnswer = 'return';
        return finalAnswer;
    }

    saveQ06_07(){
        const finalAnswer = this.q06_07GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_07, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question06_07, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveQuestion06({
            recordIdCMD2 : this.rxRecordIdCMD2,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            subIndex : '7',
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD2 = result;
            this.reInitializeRecordCDM2();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-2',
                message: 'Question06_07 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion06_07';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question06_07 answer';
            }else{
                this.rxError = 'प्रश्न06_07 उत्तर सम्मिलित करते समय त्रुटि';
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

    handleQ06_07(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        /*
        for(let key in this.q06_07_Options){
            if(this.q06_07_Options[key].optionName === targetId)
            {
                this.q06_07_Options[key].answer = targetValue;
            }
        }*/

        if(targetId === 'nil')
        {
            for(let key in this.q06_07_Options){
                if(this.q06_07_Options[key].optionName === 'nil')
                {
                    this.q06_07_Options[key].answer = targetValue;
                }
                else
                {
                    this.q06_07_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q06_07_Options){
                if(this.q06_07_Options[key].optionName === targetId)
                {
                    this.q06_07_Options[key].answer = targetValue;
                }
                else if(this.q06_07_Options[key].optionName === 'nil')
                {
                    this.q06_07_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut07) {
        //     window.clearTimeout(this.delayTimeOut07);
        // }

        // this.delayTimeOut07 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ06_07();
        // }, this.delay);
        // ## 1 Stop
        
        this.flag = 'handleQ06_07';
        console.log('this.flag : ' + this.flag);
    }
	
    q06_08GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q06_08_Options){
            if(this.q06_08_Options[key].answer)
            {
                if(this.q06_08_Options[key].optionName === 'nil')continue;
                if(finalAnswer !== undefined)finalAnswer += ',' + this.q06_08_Options[key].optionName;
                else finalAnswer = this.q06_08_Options[key].optionName;
            }
        }

        // console.log('initAnswer06_08 : ' + this.initAnswer06_08);
        // console.log('q06_08GetFinalAnswer : ' + finalAnswer);
        if(finalAnswer === this.initAnswer06_08)finalAnswer = 'return';
        return finalAnswer;
    }

    saveQ06_08(){
        const finalAnswer = this.q06_08GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_08, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question06_08, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveQuestion06({
            recordIdCMD2 : this.rxRecordIdCMD2,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            subIndex : '8',
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD2 = result;
            this.reInitializeRecordCDM2();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-2',
                message: 'Question06_08 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion06_08';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question06_08 answer';
            }else{
                this.rxError = 'प्रश्न06_08 उत्तर सम्मिलित करते समय त्रुटि';
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

    handleQ06_08(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        /*
        for(let key in this.q06_08_Options){
            if(this.q06_08_Options[key].optionName === targetId)
            {
                this.q06_08_Options[key].answer = targetValue;
            }
        }*/

        if(targetId === 'nil')
        {
            for(let key in this.q06_08_Options){
                if(this.q06_08_Options[key].optionName === 'nil')
                {
                    this.q06_08_Options[key].answer = targetValue;
                }
                else
                {
                    this.q06_08_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q06_08_Options){
                if(this.q06_08_Options[key].optionName === targetId)
                {
                    this.q06_08_Options[key].answer = targetValue;
                }
                else if(this.q06_08_Options[key].optionName === 'nil')
                {
                    this.q06_08_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut08) {
        //     window.clearTimeout(this.delayTimeOut08);
        // }

        // this.delayTimeOut08 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ06_08();
        // }, this.delay);
        // ## 1 Stop
        
        this.flag = 'handleQ06_08';
        console.log('this.flag : ' + this.flag);
    }
	
    q06_09GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q06_09_Options){
            if(this.q06_09_Options[key].answer)
            {
                if(this.q06_09_Options[key].optionName === 'nil')continue;
                if(finalAnswer !== undefined)finalAnswer += ',' + this.q06_09_Options[key].optionName;
                else finalAnswer = this.q06_09_Options[key].optionName;
            }
        }

        // console.log('initAnswer06_09 : ' + this.initAnswer06_09);
        // console.log('q06_09GetFinalAnswer : ' + finalAnswer);
        if(finalAnswer === this.initAnswer06_09)finalAnswer = 'return';
        return finalAnswer;
    }

    saveQ06_09(){
        const finalAnswer = this.q06_09GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_09, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question06_09, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveQuestion06({
            recordIdCMD2 : this.rxRecordIdCMD2,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            subIndex : '9',
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD2 = result;
            this.reInitializeRecordCDM2();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-2',
                message: 'Question06_09 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion06_09';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError ;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question06_09 answer';
            }else{
                this.rxError = 'प्रश्न06_09 उत्तर सम्मिलित करते समय त्रुटि';
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

    handleQ06_09(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        /*
        for(let key in this.q06_09_Options){
            if(this.q06_09_Options[key].optionName === targetId)
            {
                this.q06_09_Options[key].answer = targetValue;
            }
        }*/

        if(targetId === 'nil')
        {
            for(let key in this.q06_09_Options){
                if(this.q06_09_Options[key].optionName === 'nil')
                {
                    this.q06_09_Options[key].answer = targetValue;
                }
                else
                {
                    this.q06_09_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q06_09_Options){
                if(this.q06_09_Options[key].optionName === targetId)
                {
                    this.q06_09_Options[key].answer = targetValue;
                }
                else if(this.q06_09_Options[key].optionName === 'nil')
                {
                    this.q06_09_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut09) {
        //     window.clearTimeout(this.delayTimeOut09);
        // }

        // this.delayTimeOut09 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ06_09();
        // }, this.delay);
        // ## 1 Stop
        
        this.flag = 'handleQ06_09';
        console.log('this.flag : ' + this.flag);
    }
	
	q06_10GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q06_10_Options){
            if(this.q06_10_Options[key].answer)
            {
                if(this.q06_10_Options[key].optionName === 'nil')continue;
                if(finalAnswer !== undefined)finalAnswer += ',' + this.q06_10_Options[key].optionName;
                else finalAnswer = this.q06_10_Options[key].optionName;
            }
        }

        // console.log('initAnswer06_10 : ' + this.initAnswer06_10);
        // console.log('q06_10GetFinalAnswer : ' + finalAnswer);
        if(finalAnswer === this.initAnswer06_10)finalAnswer = 'return';
        return finalAnswer;
    }

    saveQ06_10(){
        const finalAnswer = this.q06_10GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_10, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question06_10, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveQuestion06({
            recordIdCMD2 : this.rxRecordIdCMD2,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            subIndex : '10',
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD2 = result;
            this.reInitializeRecordCDM2();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-2',
                message: 'Question06_10 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion06_10';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question06_10 answer';
            }else{
                this.rxError = 'प्रश्न06_10 उत्तर सम्मिलित करते समय त्रुटि';
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

    handleQ06_10(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        /*
        for(let key in this.q06_10_Options){
            if(this.q06_10_Options[key].optionName === targetId)
            {
                this.q06_10_Options[key].answer = targetValue;
            }
        }*/

        if(targetId === 'nil')
        {
            for(let key in this.q06_10_Options){
                if(this.q06_10_Options[key].optionName === 'nil')
                {
                    this.q06_10_Options[key].answer = targetValue;
                }
                else
                {
                    this.q06_10_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q06_10_Options){
                if(this.q06_10_Options[key].optionName === targetId)
                {
                    this.q06_10_Options[key].answer = targetValue;
                }
                else if(this.q06_10_Options[key].optionName === 'nil')
                {
                    this.q06_10_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut10) {
        //     window.clearTimeout(this.delayTimeOut10);
        // }

        // this.delayTimeOut10 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ06_10();
        // }, this.delay);
        // ## 1 Stop
        
        this.flag = 'handleQ06_10';
        console.log('this.flag : ' + this.flag);
    }
	
    q06_11GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q06_11_Options){
            if(this.q06_11_Options[key].answer)
            {
                if(this.q06_11_Options[key].optionName === 'nil')continue;
                if(finalAnswer !== undefined)finalAnswer += ',' + this.q06_11_Options[key].optionName;
                else finalAnswer = this.q06_11_Options[key].optionName;
            }
        }

        // console.log('initAnswer06_11 : ' + this.initAnswer06_11);
        // console.log('q06_11GetFinalAnswer : ' + finalAnswer);
        if(finalAnswer === this.initAnswer06_11)finalAnswer = 'return';
        return finalAnswer;
    }

    saveQ06_11(){
        const finalAnswer = this.q06_11GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_11, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question06_11, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveQuestion06({
            recordIdCMD2 : this.rxRecordIdCMD2,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            subIndex : '11',
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD2 = result;
            this.reInitializeRecordCDM2();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-2',
                message: 'Question06_11 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion06_11';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question06_11 answer';
            }else{
                this.rxError = 'प्रश्न06_11 उत्तर सम्मिलित करते समय त्रुटि';
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

    handleQ06_11(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        /*
        for(let key in this.q06_11_Options){
            if(this.q06_11_Options[key].optionName === targetId)
            {
                this.q06_11_Options[key].answer = targetValue;
            }
        }*/

        if(targetId === 'nil')
        {
            for(let key in this.q06_11_Options){
                if(this.q06_11_Options[key].optionName === 'nil')
                {
                    this.q06_11_Options[key].answer = targetValue;
                }
                else
                {
                    this.q06_11_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q06_11_Options){
                if(this.q06_11_Options[key].optionName === targetId)
                {
                    this.q06_11_Options[key].answer = targetValue;
                }
                else if(this.q06_11_Options[key].optionName === 'nil')
                {
                    this.q06_11_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut11) {
        //     window.clearTimeout(this.delayTimeOut11);
        // }

        // this.delayTimeOut11 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ06_11();
        // }, this.delay);
        // ## 1 Stop
        
        this.flag = 'handleQ06_11';
        console.log('this.flag : ' + this.flag);
    }
	
    q06_12GetFinalAnswer(){
        let finalAnswer; 

        for(let key in this.q06_12_Options){
            if(this.q06_12_Options[key].answer)
            {
                if(this.q06_12_Options[key].optionName === 'nil')continue;
                if(finalAnswer !== undefined)finalAnswer += ',' + this.q06_12_Options[key].optionName;
                else finalAnswer = this.q06_12_Options[key].optionName;
            }
        }

        // console.log('initAnswer06_12 : ' + this.initAnswer06_12);
        // console.log('q06_12GetFinalAnswer : ' + finalAnswer);
        if(finalAnswer === this.initAnswer06_12)finalAnswer = 'return';
        return finalAnswer;
    }

    saveQ06_12(){
        const finalAnswer = this.q06_12GetFinalAnswer();
        if(finalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_12, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question06_12, Please proceed');
        // }

        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards

        saveQuestion06({
            recordIdCMD2 : this.rxRecordIdCMD2,
            studentId : this.rxStudentId,
            barCode : this.rxStudentBarcode,
            ans : {answer : finalAnswer},
            subIndex : '12',
            lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? this.typ = 'Form V2' : 'Form V1'
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.rxRecordIdCMD2 = result;
            this.reInitializeRecordCDM2();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Decision Making-2',
                message: 'Question06_12 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion06_12';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError;
            if(this.isEnglish){
                this.rxError = 'Error while upserting Question06_12 answer';
            }else{
                this.rxError = 'प्रश्न06_12 उत्तर सम्मिलित करते समय त्रुटि';
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

    handleQ06_12(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        /*
        for(let key in this.q06_12_Options){
            if(this.q06_12_Options[key].optionName === targetId)
            {
                this.q06_12_Options[key].answer = targetValue;
            }
        }*/

        if(targetId === 'nil')
        {
            for(let key in this.q06_12_Options){
                if(this.q06_12_Options[key].optionName === 'nil')
                {
                    this.q06_12_Options[key].answer = targetValue;
                }
                else
                {
                    this.q06_12_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q06_12_Options){
                if(this.q06_12_Options[key].optionName === targetId)
                {
                    this.q06_12_Options[key].answer = targetValue;
                }
                else if(this.q06_12_Options[key].optionName === 'nil')
                {
                    this.q06_12_Options[key].answer = false;
                }
            }
        }

        // ## 1 Start
        // if (this.delayTimeOut12) {
        //     window.clearTimeout(this.delayTimeOut12);
        // }

        // this.delayTimeOut12 = setTimeout(() => {
        //     //filter dropdown list based on search key parameter
        //     this.saveQ06_12();
        // }, this.delay);
        // ## 1 Stop
        
        this.flag = 'handleQ06_12';
        console.log('this.flag : ' + this.flag);
    }
    
    allQuestionsAttempted(){
        debugger;
        let rxError = '';
        //===============================================//
        let foundans5 = false;
        for(let key in this.q05_Options){
            if(this.q05_Options[key].answer)
            {
                foundans5 = true;
                break;
            }
        }
        if(!foundans5)
        {
            if(rxError !== '')rxError += ', ' + 'Q5';
            else rxError = 'Q5';
        }
        //===============================================//
        let foundans6_01 = false;
        for(let key in this.q06_01_Options){
            if(this.q06_01_Options[key].answer)
            {
                foundans6_01 = true;
                break;
            }
        }
        if(!foundans6_01)
        {
            if(rxError !== '')rxError += ', ' + 'Q6.1';
            else rxError = 'Q6.1';
        }
        //===============================================//
        let foundans6_02 = false;
        for(let key in this.q06_02_Options){
            if(this.q06_02_Options[key].answer)
            {
                foundans6_02 = true;
                break;
            }
        }
        if(!foundans6_02)
        {
            if(rxError !== '')rxError += ', ' + 'Q6.2';
            else rxError = 'Q6.2';
        }
        //===============================================//
        let foundans6_03 = false;
        for(let key in this.q06_03_Options){
            if(this.q06_03_Options[key].answer)
            {
                foundans6_03 = true;
                break;
            }
        }
        if(!foundans6_03)
        {
            if(rxError !== '')rxError += ', ' + 'Q6.3';
            else rxError = 'Q6.3';
        }
        //===============================================//
        let foundans6_04 = false;
        for(let key in this.q06_04_Options){
            if(this.q06_04_Options[key].answer)
            {
                foundans6_04 = true;
                break;
            }
        }
        if(!foundans6_04)
        {
            if(rxError !== '')rxError += ', ' + 'Q6.4';
            else rxError = 'Q6.4';
        }
        //===============================================//
        let foundans6_05 = false;
        for(let key in this.q06_05_Options){
            if(this.q06_05_Options[key].answer)
            {
                foundans6_05 = true;
                break;
            }
        }
        if(!foundans6_05)
        {
            if(rxError !== '')rxError += ', ' + 'Q6.5';
            else rxError = 'Q6.5';
        }
        //===============================================//
        let foundans6_06 = false;
        for(let key in this.q06_06_Options){
            if(this.q06_06_Options[key].answer)
            {
                foundans6_06 = true;
                break;
            }
        }
        if(!foundans6_06)
        {
            if(rxError !== '')rxError += ', ' + 'Q6.6';
            else rxError = 'Q6.6';
        }
        //===============================================//
        let foundans6_07 = false;
        for(let key in this.q06_07_Options){
            if(this.q06_07_Options[key].answer)
            {
                foundans6_07 = true;
                break;
            }
        }
        if(!foundans6_07)
        {
            if(rxError !== '')rxError += ', ' + 'Q6.7';
            else rxError = 'Q6.7';
        }
        //===============================================//
        let foundans6_08 = false;
        for(let key in this.q06_08_Options){
            if(this.q06_08_Options[key].answer)
            {
                foundans6_08 = true;
                break;
            }
        }
        if(!foundans6_08)
        {
            if(rxError !== '')rxError += ', ' + 'Q6.8';
            else rxError = 'Q6.8';
        }
        //===============================================//
        let foundans6_09 = false;
        for(let key in this.q06_09_Options){
            if(this.q06_09_Options[key].answer)
            {
                foundans6_09 = true;
                break;
            }
        }
        if(!foundans6_09)
        {
            if(rxError !== '')rxError += ', ' + 'Q6.9';
            else rxError = 'Q6.9';
        }
        //===============================================//
        let foundans6_10 = false;
        for(let key in this.q06_10_Options){
            if(this.q06_10_Options[key].answer)
            {
                foundans6_10 = true;
                break;
            }
        }
        if(!foundans6_10)
        {
            if(rxError !== '')rxError += ', ' + 'Q6.10';
            else rxError = 'Q6.10';
        }
        //===============================================//
        let foundans6_11 = false;
        for(let key in this.q06_11_Options){
            if(this.q06_11_Options[key].answer)
            {
                foundans6_11 = true;
                break;
            }
        }
        if(!foundans6_11)
        {
            if(rxError !== '')rxError += ', ' + 'Q6.11';
            else rxError = 'Q6.11';
        }
        //===============================================//
        let foundans6_12 = false;
        for(let key in this.q06_12_Options){
            if(this.q06_12_Options[key].answer)
            {
                foundans6_12 = true;
                break;
            }
        }
        if(!foundans6_12)
        {
            if(rxError !== '')rxError += ', ' + 'Q6.12';
            else rxError = 'Q6.12';
        }
        //===============================================//
        if(foundans5 && 
            foundans6_01 && foundans6_02 && foundans6_03 && 
            foundans6_04 && foundans6_05 && foundans6_06 && 
            foundans6_07 && foundans6_08 && foundans6_09 && 
            foundans6_10 && foundans6_11 && foundans6_12)
        {
            return 'All available';
        }
        if(this.isEnglish){
            return ('Please choose answers for questions: ' + rxError);
        }else{
            return ('कृपया प्रश्नों के उत्तर चुनें: ' + rxError);
        }
    }

    restrictIndividualUpdate(){
        
        // ## 1 Start
        // if (this.delayTimeOut00) {
        //     window.clearTimeout(this.delayTimeOut00);
        // }

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

        // if (this.delayTimeOut05) {
        //     window.clearTimeout(this.delayTimeOut05);
        // }

        // if (this.delayTimeOut06) {
        //     window.clearTimeout(this.delayTimeOut06);
        // }

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
      
        // if (this.delayTimeOut11) {
        //     window.clearTimeout(this.delayTimeOut11);
        // }

        // if (this.delayTimeOut12) {
        //     window.clearTimeout(this.delayTimeOut12);
        // }  
        // ## 1 Stop
             
    }

    saveAll(){
        console.log('Entered in saveAll()');
        // this.restrictIndividualUpdate();
        //===================================================================================//
        const q05FinalAnswer = this.q05GetFinalAnswer();
        let q05Answer = {};
        if(q05FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question05, Please return : saveAll()');
            q05Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question05, Please proceed : saveAll()');
            q05Answer.answer = q05FinalAnswer;
        }
        //===================================================================================//
        const q06_01FinalAnswer = this.q06_01GetFinalAnswer();
        let q06_01Answer = {};
        if(q06_01FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_01, Please return : saveAll()');
            q06_01Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question06_01, Please proceed : saveAll()');
            q06_01Answer.answer = q06_01FinalAnswer;
        }
        //===================================================================================//
        const q06_02FinalAnswer = this.q06_02GetFinalAnswer();
        let q06_02Answer = {};
        if(q06_02FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_02, Please return : saveAll()');
            q06_02Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question06_02, Please proceed : saveAll()');
            q06_02Answer.answer = q06_02FinalAnswer;
        }
        //===================================================================================//
        const q06_03FinalAnswer = this.q06_03GetFinalAnswer();
        let q06_03Answer = {};
        if(q06_03FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_03, Please return : saveAll()');
            q06_03Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question06_03, Please proceed : saveAll()');
            q06_03Answer.answer = q06_03FinalAnswer;
        }
        //===================================================================================//
        const q06_04FinalAnswer = this.q06_04GetFinalAnswer();
        let q06_04Answer = {};
        if(q06_04FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_04, Please return : saveAll()');
            q06_04Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question06_04, Please proceed : saveAll()');
            q06_04Answer.answer = q06_04FinalAnswer;
        }
        //===================================================================================//
        const q06_05FinalAnswer = this.q06_05GetFinalAnswer();
        let q06_05Answer = {};
        if(q06_05FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_05, Please return : saveAll()');
            q06_05Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question06_05, Please proceed : saveAll()');
            q06_05Answer.answer = q06_05FinalAnswer;
        }
        //===================================================================================//
        const q06_06FinalAnswer = this.q06_06GetFinalAnswer();
        let q06_06Answer = {};
        if(q06_06FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_06, Please return : saveAll()');
            q06_06Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question06_06, Please proceed : saveAll()');
            q06_06Answer.answer = q06_06FinalAnswer;
        }
        //===================================================================================//
        const q06_07FinalAnswer = this.q06_07GetFinalAnswer();
        let q06_07Answer = {};
        if(q06_07FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_07, Please return : saveAll()');
            q06_07Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question06_07, Please proceed : saveAll()');
            q06_07Answer.answer = q06_07FinalAnswer;
        }
        //===================================================================================//
        const q06_08FinalAnswer = this.q06_08GetFinalAnswer();
        let q06_08Answer = {};
        if(q06_08FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_08, Please return : saveAll()');
            q06_08Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question06_08, Please proceed : saveAll()');
            q06_08Answer.answer = q06_08FinalAnswer;
        }
        //===================================================================================//
        const q06_09FinalAnswer = this.q06_09GetFinalAnswer();
        let q06_09Answer = {};
        if(q06_09FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_09, Please return : saveAll()');
            q06_09Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question06_09, Please proceed : saveAll()');
            q06_09Answer.answer = q06_09FinalAnswer;
        }
        //===================================================================================//
        const q06_10FinalAnswer = this.q06_10GetFinalAnswer();
        let q06_10Answer = {};
        if(q06_10FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_10, Please return : saveAll()');
            q06_10Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question06_10, Please proceed : saveAll()');
            q06_10Answer.answer = q06_10FinalAnswer;
        }
        //===================================================================================//
        const q06_11FinalAnswer = this.q06_11GetFinalAnswer();
        let q06_11Answer = {};
        if(q06_11FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_11, Please return : saveAll()');
            q06_11Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question06_11, Please proceed : saveAll()');
            q06_11Answer.answer = q06_11FinalAnswer;
        }
        //===================================================================================//
        const q06_12FinalAnswer = this.q06_12GetFinalAnswer();
        let q06_12Answer = {};
        if(q06_12FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question06_12, Please return : saveAll()');
            q06_12Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question06_12, Please proceed : saveAll()');
            q06_12Answer.answer = q06_12FinalAnswer;
        }
        //===================================================================================//
        if(q05Answer !== null
            || q06_01Answer !== null || q06_02Answer !== null || q06_03Answer !== null || q06_04Answer !== null
            || q06_05Answer !== null || q06_06Answer !== null || q06_07Answer !== null || q06_08Answer !== null
            || q06_09Answer !== null || q06_10Answer !== null || q06_11Answer !== null || q06_12Answer !== null)
        {
            this.isLoading = true;   //Turn ON the spinner
            debugger;
            const allQA = {
                q05 : q05Answer,
                q06_01 : q06_01Answer,
                q06_02 : q06_02Answer,
                q06_03 : q06_03Answer,
                q06_04 : q06_04Answer,
                q06_05 : q06_05Answer,
                q06_06 : q06_06Answer,
                q06_07 : q06_07Answer,
                q06_08 : q06_08Answer,
                q06_09 : q06_09Answer,
                q06_10 : q06_10Answer,
                q06_11 : q06_11Answer,
                q06_12 : q06_12Answer              
            };

            //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards
            console.log('$$$ Before saveAllQA');
            console.log('$$$ rxRecordIdCMD2: ',this.rxRecordIdCMD2);
            console.log('$$$ rxStudentId: ',this.rxStudentId);
            console.log('$$$ rxStudentBarcode: ',this.rxStudentBarcode);
            console.log('$$$ allQA: ',allQA);
            console.log('$$$ lng: ',this.lng);
            console.log('$$$ typ: ',this.typ);
            saveAllQA({
                batchId : this.bid,
                recordIdCMD2 : this.rxRecordIdCMD2,
                studentId : this.rxStudentId,
                barCode : this.rxStudentBarcode,
                ans : allQA,
                lng : this.lng,
            typ : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1'
            }).then(result => {
                console.log('result 1: ' + JSON.stringify(result));
                //===========================================================//
                this.rxRecordIdCMD2 = result;
                //this.reInitializeRecordCDM2();
                //this.cdm1NavigateToInternalPage(); 
                this.isLoading = false;   //Turn OFF the spinner
                //===========================================================//
                 
                this.submit();
                
            }).catch(error => {
                this.isLoading = false;   //Turn OFF the spinner
                let rxError = 'Error while upserting all answers';
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
        }else{
            this.cdm1NavigateToInternalPage(); 
        }
        //===================================================================================//
        this.flag = 'saveAllQA';
        console.log('this.flag : ' + this.flag);
    }

    handleSaveButton(event){
        debugger;
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
                getBaselineRecord({
                    studentId : this.rxStudentId,
                    grade : this.grd,
                    type : 'CDM2',
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
                        this.cdm1NavigateToInternalPage();
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

        this.flag = 'handleSaveButton';
        console.log('this.flag : ' + this.flag);
    }

    submit(){    
        //this.rxRecordIdCMD2 = null; //For temperary purpose delete afterwards
        if(this.rxRecordIdCMD2 == null)
        {
            confirm('Please save the record before submit');
            return;
        }

        this.isLoading = true;   //Turn ON the spinner
        submitAndCalculate({
            recordIdCMD2 : this.rxRecordIdCMD2
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            if(result === 'success')
            {
                this.reInitializeRecordCDM2();
            }           
            this.isLoading = false;   //Turn OFF the spinner
            //===========================================================//
            const event = new ShowToastEvent({
                title: this.successTitle,
                message: this.successMsg,
                variant: 'success'
            });                
            this.dispatchEvent(event);
            this.cdm1NavigateToInternalPage();
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

    handleSubmitButton(event){
        debugger;
        let eventButton = event.target.dataset.name;

        if(eventButton === 'submitButton')
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
                this.submit();            
            }while(false);        
        }

        this.flag = 'handleSubmitButton';
        console.log('this.flag : ' + this.flag);
    }

    handleBackButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'backButton')
        {
            this.cdm1NavigateToInternalPage();
        }

        this.flag = 'handleBackButton';
        console.log('this.flag : ' + this.flag);
    }

    cdm1NavigateToInternalPage() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'baseline_cdm2_assesment_V2__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd),
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid),
                studentId : this.rxStudentId,
                typ : this.typ,
                lng : this.lng
            }
        });
    }

    handleContinueButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'continueButton')
        {
            if(this.freeze)
            {
                this.cdm1NavigateToInternalPage();
            }
            else
            {
                do{
                    console.log('rrrr');
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
                    
                }while(false);
            }
        }

        this.flag = 'handleContinueButton'; 
        console.log('this.flag : ' + this.flag);
    }

    
}