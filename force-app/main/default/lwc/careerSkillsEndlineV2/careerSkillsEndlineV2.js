import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getApexRecord from '@salesforce/apex/careerSkillsEndline.getApexRecord';
import saveQuestion11 from '@salesforce/apex/careerSkillsEndline.saveQuestion11';
import saveQuestion15 from '@salesforce/apex/careerSkillsEndline.saveQuestion15';
import saveSingle from '@salesforce/apex/careerSkillsEndline.saveSingle';
import saveQuestion12 from '@salesforce/apex/careerSkillsEndline.saveQuestion12';
import saveAllQA from '@salesforce/apex/careerSkillsEndline.saveAllQA';
import submitAndCalculate from '@salesforce/apex/careerSkillsEndline.submitAndCalculate';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import getEndlineRecord from '@salesforce/apex/EndlineAssessmentController.getEndlineRecord';

import getAssesmentQuestion from '@salesforce/apex/AssesementQuestionController.getAssesmentQuestion';

export default class CareerSkillsEndlineV2 extends NavigationMixin(LightningElement) {
    lng;
    typ;
    isEnglish;
    msg = '';
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';

    //=======================================================//
    fem = null;
    sch = null;
    grd = null;
    bid = null;
    acid = null;
    rxStudentId = null;
    cdm1Id = null;
    cdm2Id = null;
    cpId = null;
    batchNumber=null;
    //=======================================================//
    flag = '';
    antarangImage = logo_01;
    isLoading = true;
    studentName = null;
    studentBarcode = null;
    @track freeze = true;
    csRecordId = null;
    //=======================================================//
    delay = 5000;   //Delay = 5 sec
    delayTimeOut11;
    delayTimeOut12;
    delayTimeOut13;
    delayTimeOut14;
    delayTimeOut15;
    delayTimeOut16;

    delayTimeOut15_01;
    delayTimeOut15_02;
    delayTimeOut15_03;
    delayTimeOut15_04;
    delayTimeOut15_05;
    delayTimeOut15_06;
    delayTimeOut15_07;
    delayTimeOut15_08;
    delayTimeOut15_09;

    delayTimeOut11_01;
    delayTimeOut11_02;
    delayTimeOut11_03;
    delayTimeOut11_04;
    delayTimeOut11_05;
    delayTimeOut11_06;
    delayTimeOut11_07;
    delayTimeOut11_08;
    delayTimeOut11_09;
    //=======================================================//
    //=======================================================//
    /*
    get q11PicklistOptions() {
        return [
            { label: ' ', value: '' },
            { label: 'Yes', value: 'A' },
            { label: 'No', value: 'B' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'nil' },
        ];
    }

    question11 = '11. For each question, tick Yes if you have done the activity to learn about a career. If you have not done the activity, tick No';
    initAnswer11 = [];
    @track q11_Options = [
        {
            optionName:'1', 
            answer: '',
            optionValue:'(a) I have spoken to a person working in the career'          
        },
        {
            optionName:'2',
            answer: '',
            optionValue:'(b) I completed a project/participated in a competition related to the career'
        },
        {
            optionName:'3',
            answer: '',
            optionValue:'(c) I have attended a training program in which I learnt to do activities related to the career'
        },
        {
            optionName:'4', 
            answer: '',
            optionValue:'(d) I have spoken to a career counsellor/teacher about my career'          
        },
        {
            optionName:'5',
            answer: '',
            optionValue:'(e) I have done interest/aptitude test'
        },
        {
            optionName:'6',
            answer: '',
            optionValue:'(f) I visited the workplace/observed people at work'
        },
        {
            optionName:'7',
            answer: '',
            optionValue:'(g) I read/ watched videos on the career on the internet/book/magazine'
        },
        {
            optionName:'8',
            answer: '',
            optionValue:'(h) I volunteered with an organisation'
        },
        {
            optionName:'9',
            answer: '',
            optionValue:'(i) I did a job/internship - part time or full time'
        }
    ];*/

    question11 = '';
    
    question11_01 = '';
    initAnswer11_01 = '';
    @track q11_01_Options = [];

    question11_02 = '';
    initAnswer11_02 = '';
    @track q11_02_Options = [];

    question11_03 = '';
    initAnswer11_03 = '';
    @track q11_03_Options = [];

    question11_04 = '';
    initAnswer11_04 = '';
    @track q11_04_Options = [];

    question11_05 = '';
    initAnswer11_05 = '';
    @track q11_05_Options = [];

    question11_06 = '';
    initAnswer11_06 = '';
    @track q11_06_Options = [];

    question11_07 = '';
    initAnswer11_07 = '';
    @track q11_07_Options = [];

    question11_08 = '';
    initAnswer11_08 = '';
    @track q11_08_Options = [];

    question11_09 = '';
    initAnswer11_09 = '';
    @track q11_09_Options = [];
    //=======================================================//
    question12 = '';
    initAnswer12 = [];

    @track q12_Options = [];

    // question11 = '11. For each question, tick Yes if you have done the activity to learn about a career. If you have not done the activity, tick No';
    
    // question11_01 = '11(a). I have spoken to a person working in the career';
    // initAnswer11_01 = '';
    // @track q11_01_Options = [
    //     {
    //         optionName:'A', 
    //         answer: false,
    //         optionValue:'(a) Yes'          
    //     },
    //     {
    //         optionName:'B',
    //         answer: false,
    //         optionValue:'(b) No'
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question11_02 = '11(b). I completed a project/participated in a competition related to the career';
    // initAnswer11_02 = '';
    // @track q11_02_Options = [
    //     {
    //         optionName:'A', 
    //         answer: false,
    //         optionValue:'(a) Yes'          
    //     },
    //     {
    //         optionName:'B',
    //         answer: false,
    //         optionValue:'(b) No'
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question11_03 = '11(c). I have attended a training program in which I learnt to do activities related to the career';
    // initAnswer11_03 = '';
    // @track q11_03_Options = [
    //     {
    //         optionName:'A', 
    //         answer: false,
    //         optionValue:'(a) Yes'          
    //     },
    //     {
    //         optionName:'B',
    //         answer: false,
    //         optionValue:'(b) No'
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question11_04 = '11(d). I have spoken to a career counsellor/teacher about my career';
    // initAnswer11_04 = '';
    // @track q11_04_Options = [
    //     {
    //         optionName:'A', 
    //         answer: false,
    //         optionValue:'(a) Yes'          
    //     },
    //     {
    //         optionName:'B',
    //         answer: false,
    //         optionValue:'(b) No'
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question11_05 = '11(e). I have done interest/aptitude test';
    // initAnswer11_05 = '';
    // @track q11_05_Options = [
    //     {
    //         optionName:'A', 
    //         answer: false,
    //         optionValue:'(a) Yes'          
    //     },
    //     {
    //         optionName:'B',
    //         answer: false,
    //         optionValue:'(b) No'
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question11_06 = '11(f). I visited the workplace/observed people at work';
    // initAnswer11_06 = '';
    // @track q11_06_Options = [
    //     {
    //         optionName:'A', 
    //         answer: false,
    //         optionValue:'(a) Yes'          
    //     },
    //     {
    //         optionName:'B',
    //         answer: false,
    //         optionValue:'(b) No'
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question11_07 = '11(g). I read/ watched videos on the career on the internet/book/magazine';
    // initAnswer11_07 = '';
    // @track q11_07_Options = [
    //     {
    //         optionName:'A', 
    //         answer: false,
    //         optionValue:'(a) Yes'          
    //     },
    //     {
    //         optionName:'B',
    //         answer: false,
    //         optionValue:'(b) No'
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question11_08 = '11(h). I volunteered with an organisation';
    // initAnswer11_08 = '';
    // @track q11_08_Options = [
    //     {
    //         optionName:'A', 
    //         answer: false,
    //         optionValue:'(a) Yes'          
    //     },
    //     {
    //         optionName:'B',
    //         answer: false,
    //         optionValue:'(b) No'
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question11_09 = '11(i). I did a job/internship - part time or full time';
    // initAnswer11_09 = '';
    // @track q11_09_Options = [
    //     {
    //         optionName:'A', 
    //         answer: false,
    //         optionValue:'(a) Yes'          
    //     },
    //     {
    //         optionName:'B',
    //         answer: false,
    //         optionValue:'(b) No'
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];
    // //=======================================================//
    // question12 = '12. Which 2 sentences best describe good teamwork? (Mark all the answers the student has selected)';
    // initAnswer12 = [];

    // @track q12_Options = [
    //     {
    //         optionName:'A', 
    //         answer: false,
    //         optionValue:'(a) Making sure that everyone gets a chance to participate'
    //     },
    //     {
    //         optionName:'B',
    //         answer: false,
    //         optionValue:'(b) Doing only the things you are interested in/ good at in the project'
    //     },
    //     {
    //         optionName:'C',
    //         answer: false,
    //         optionValue:'(c) Giving feedback to your team members about their work'
    //     },
    //     {
    //         optionName:'D',
    //         answer: false,
    //         optionValue:'(d) Making others agree to your point of view'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];
    //=======================================================//
    /*
    get q15PicklistOptions() {
        return [
            { 
                label: ' ', 
                value: '' 
            },
            { 
                label: 'I do not know', 
                value: '1'
            },
            { 
                label: 'Not good at all', 
                value: '2' 
            },
			{ 
                label: 'Good', 
                value: '3' 
            },
            { 
                label: 'Very good', 
                value: '4' 
            },
            { 
                label: 'Excellent', 
                value: '5' 
            },
            { 
                label: 'Multiple answers selected', 
                value: '*' 
            },
            { 
                label: 'No Answer', 
                value: 'nil' 
            }
        ];
    }

    question15 = '15. How good are you at the following skills? (Tick ONLY 1 option for each statement)'
    initAnswer15 = [];
    @track q15_Options = [
        {
            optionName:'1', 
            answer: '',
            optionValue:'(i) Giving a job interview'          
        },
        {
            optionName:'2',
            answer: '',
            optionValue:'(ii) Searching for a job'
        },
        {
            optionName:'3',
            answer: '',
            optionValue:'(iii) Speaking and writing in English'
        },
        {
            optionName:'4', 
            answer: '',
            optionValue:'(iv) Writing emails'          
        },
        {
            optionName:'5',
            answer: '',
            optionValue:'(v) Making a CV'
        },
        {
            optionName:'6',
            answer: '',
            optionValue:'(vi) Finding out information on careers that you may be interested in'
        },
        {
            optionName:'7',
            answer: '',
            optionValue:'(vii) Working in teams'
        },
        {
            optionName:'8',
            answer: '',
            optionValue:'(viii) Communicating your ideas'
        },
        {
            optionName:'9',
            answer: '',
            optionValue:'(ix) Thinking critically and solving problems'
        }
    ];*/

    // question15 = '15. How good are you at the following skills? (Tick ONLY 1 option for each statement)'
    // question15_01 = '15(i). Giving a job interview';
    // initAnswer15_01 = '';
    // @track q15_01_Options = [
    //     {
    //         optionName:'1', 
    //         answer: false,
    //         optionValue:'(a) I do not know'          
    //     },
    //     {
    //         optionName:'2',
    //         answer: false,
    //         optionValue:'(b) Not good at all'
    //     },
    //     {
    //         optionName:'3',
    //         answer: false,
    //         optionValue:'(c) Good'
    //     },
    //     {
    //         optionName:'4',
    //         answer: false,
    //         optionValue:'(d) Very good' 
    //     },
	// 	{
    //         optionName:'5',
    //         answer: false,
    //         optionValue:'(e) Excellent' 
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question15_02 = '15(ii). Searching for a job';
    // initAnswer15_02 = '';
    // @track q15_02_Options = [
    //     {
    //         optionName:'1', 
    //         answer: false,
    //         optionValue:'(a) I do not know'          
    //     },
    //     {
    //         optionName:'2',
    //         answer: false,
    //         optionValue:'(b) Not good at all'
    //     },
    //     {
    //         optionName:'3',
    //         answer: false,
    //         optionValue:'(c) Good'
    //     },
    //     {
    //         optionName:'4',
    //         answer: false,
    //         optionValue:'(d) Very good' 
    //     },
	// 	{
    //         optionName:'5',
    //         answer: false,
    //         optionValue:'(e) Excellent' 
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question15_03 = '15(iii). Speaking and writing in English';
    // initAnswer15_03 = '';
    // @track q15_03_Options = [
    //     {
    //         optionName:'1', 
    //         answer: false,
    //         optionValue:'(a) I do not know'          
    //     },
    //     {
    //         optionName:'2',
    //         answer: false,
    //         optionValue:'(b) Not good at all'
    //     },
    //     {
    //         optionName:'3',
    //         answer: false,
    //         optionValue:'(c) Good'
    //     },
    //     {
    //         optionName:'4',
    //         answer: false,
    //         optionValue:'(d) Very good' 
    //     },
	// 	{
    //         optionName:'5',
    //         answer: false,
    //         optionValue:'(e) Excellent' 
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question15_04 = '15(iv). Writing emails';
    // initAnswer15_04 = '';
    // @track q15_04_Options = [
    //     {
    //         optionName:'1', 
    //         answer: false,
    //         optionValue:'(a) I do not know'          
    //     },
    //     {
    //         optionName:'2',
    //         answer: false,
    //         optionValue:'(b) Not good at all'
    //     },
    //     {
    //         optionName:'3',
    //         answer: false,
    //         optionValue:'(c) Good'
    //     },
    //     {
    //         optionName:'4',
    //         answer: false,
    //         optionValue:'(d) Very good' 
    //     },
	// 	{
    //         optionName:'5',
    //         answer: false,
    //         optionValue:'(e) Excellent' 
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question15_05 = '15(v). Making a CV';
    // initAnswer15_05 = '';
    // @track q15_05_Options = [
    //     {
    //         optionName:'1', 
    //         answer: false,
    //         optionValue:'(a) I do not know'          
    //     },
    //     {
    //         optionName:'2',
    //         answer: false,
    //         optionValue:'(b) Not good at all'
    //     },
    //     {
    //         optionName:'3',
    //         answer: false,
    //         optionValue:'(c) Good'
    //     },
    //     {
    //         optionName:'4',
    //         answer: false,
    //         optionValue:'(d) Very good' 
    //     },
	// 	{
    //         optionName:'5',
    //         answer: false,
    //         optionValue:'(e) Excellent' 
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question15_06 = '15(vi). Finding out information on careers that you may be interested in';
    // initAnswer15_06 = '';
    // @track q15_06_Options = [
    //     {
    //         optionName:'1', 
    //         answer: false,
    //         optionValue:'(a) I do not know'          
    //     },
    //     {
    //         optionName:'2',
    //         answer: false,
    //         optionValue:'(b) Not good at all'
    //     },
    //     {
    //         optionName:'3',
    //         answer: false,
    //         optionValue:'(c) Good'
    //     },
    //     {
    //         optionName:'4',
    //         answer: false,
    //         optionValue:'(d) Very good' 
    //     },
	// 	{
    //         optionName:'5',
    //         answer: false,
    //         optionValue:'(e) Excellent' 
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question15_07 = '15(vii). Working in teams';
    // initAnswer15_07 = '';
    // @track q15_07_Options = [
    //     {
    //         optionName:'1', 
    //         answer: false,
    //         optionValue:'(a) I do not know'          
    //     },
    //     {
    //         optionName:'2',
    //         answer: false,
    //         optionValue:'(b) Not good at all'
    //     },
    //     {
    //         optionName:'3',
    //         answer: false,
    //         optionValue:'(c) Good'
    //     },
    //     {
    //         optionName:'4',
    //         answer: false,
    //         optionValue:'(d) Very good' 
    //     },
	// 	{
    //         optionName:'5',
    //         answer: false,
    //         optionValue:'(e) Excellent' 
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question15_08 = '15(viii). Communicating your ideas';
    // initAnswer15_08 = '';
    // @track q15_08_Options = [
    //     {
    //         optionName:'1', 
    //         answer: false,
    //         optionValue:'(a) I do not know'          
    //     },
    //     {
    //         optionName:'2',
    //         answer: false,
    //         optionValue:'(b) Not good at all'
    //     },
    //     {
    //         optionName:'3',
    //         answer: false,
    //         optionValue:'(c) Good'
    //     },
    //     {
    //         optionName:'4',
    //         answer: false,
    //         optionValue:'(d) Very good' 
    //     },
	// 	{
    //         optionName:'5',
    //         answer: false,
    //         optionValue:'(e) Excellent' 
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];

    // question15_09 = '15(ix). Thinking critically and solving problems';
    // initAnswer15_09 = '';
    // @track q15_09_Options = [
    //     {
    //         optionName:'1', 
    //         answer: false,
    //         optionValue:'(a) I do not know'          
    //     },
    //     {
    //         optionName:'2',
    //         answer: false,
    //         optionValue:'(b) Not good at all'
    //     },
    //     {
    //         optionName:'3',
    //         answer: false,
    //         optionValue:'(c) Good'
    //     },
    //     {
    //         optionName:'4',
    //         answer: false,
    //         optionValue:'(d) Very good' 
    //     },
	// 	{
    //         optionName:'5',
    //         answer: false,
    //         optionValue:'(e) Excellent' 
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];
    // //=======================================================//
    // question13 = '13. Tina works in an office. She needs a holiday to attend a family event. But she is worried that her boss may not give her permission to take a holiday. What should Tina do? (Tick ONLY 1 option)';
    // initAnswer13 = '';
    // @track q13_Options = [
    //     {
    //         optionName:'A', 
    //         answer: false,
    //         optionValue:'(a) Tina should take the holiday, and ask her office friend to inform the boss for her.'          
    //     },
    //     {
    //         optionName:'B',
    //         answer: false,
    //         optionValue:'(b) Tina should send an email to her boss one week before asking for permission for the holiday.'
    //     },
    //     {
    //         optionName:'C',
    //         answer: false,
    //         optionValue:'(c) Tina should take the holiday, and inform her boss on WhatsApp that same morning.'
    //     },
    //     {
    //         optionName:'D',
    //         answer: false,
    //         optionValue:'(d) Tina should not ask for a holiday, as her boss will anyway say no.' 
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];
    // //=======================================================//
    // question14 = '14. Sahil and Naz are running a hotel. But their business is in loss because raw materials like vegetables etc have become very expensive. They are not in a position to increase the price of dishes due to competition from other hotels. What should they do to increase their profit? (Tick ONLY 1 option)';
    // initAnswer14 = '';
    // @track q14_Options = [
    //     {
    //         optionName:'A', 
    //         answer: false,
    //         optionValue:'(a) Reduce the amount of raw materials needed - Ex. use lesser vegetables in pizza'          
    //     },
    //     {
    //         optionName:'B',
    //         answer: false,
    //         optionValue:'(b) Buy same raw materials in bulk (wholesale) - so that they get it at cheaper prices'
    //     },
    //     {
    //         optionName:'C',
    //         answer: false,
    //         optionValue:'(c) Use low quality raw materials which will be lower in price (ex. Use old onions)'
    //     },
    //     {
    //         optionName:'D',
    //         answer: false,
    //         optionValue:'(d) Find out which dishes are in demand, and start online delivery for these - increasing its sales.' 
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];
    // //=======================================================//
    // question16 = '16. If you had the opportunity to take up a project, job or internship outside of school/college while you were studying , would you take it up? (Tick ONLY 1 option)';
    // initAnswer16 = '';
    // @track q16_Options = [
    //     {
    //         optionName:'A', 
    //         answer: false,
    //         optionValue:'(a) Yes, because I will have something to do in my free time'          
    //     },
    //     {
    //         optionName:'B',
    //         answer: false,
    //         optionValue:'(b) Yes, because it will give me experience of my career choice'
    //     },
    //     {
    //         optionName:'C',
    //         answer: false,
    //         optionValue:'(c) Yes because my school/college/professional course require me to do it'
    //     },
    //     {
    //         optionName:'D',
    //         answer: false,
    //         optionValue:'(d) Yes because my family wants me to work along with my studies' 
    //     },
    //     {
    //         optionName:'E',
    //         answer: false,
    //         optionValue:'(e) No because I will not have the time after school/college/tuitions' 
    //     },
    //     {
    //         optionName:'F', 
    //         answer: false,
    //         optionValue:'(f) No because my family may not allow me to'          
    //     },
    //     {
    //         optionName:'G',
    //         answer: false,
    //         optionValue:'(g) No because I would prefer focussing on my studies'
    //     },
    //     {
    //         optionName:'H',
    //         answer: false,
    //         optionValue:'(h) I am currently doing an internship/job'
    //     },
    //     {
    //         optionName:'I',
    //         answer: false,
    //         optionValue:'(i) I have completed atleast one internship/job' 
    //     },
    //     {
    //         optionName:'*',
    //         answer: false,
    //         optionValue:'Multiple answers selected'
    //     },
    //     {
    //         optionName:'nil',
    //         answer: false,
    //         optionValue:'No Answer'
    //     }
    // ];
    //=======================================================//
    //=======================================================//
    
    question15 = ''
    question15_01 = '';
    initAnswer15_01 = '';
    @track q15_01_Options = [ ];

    question15_02 = '';
    initAnswer15_02 = '';
    @track q15_02_Options = [];

    question15_03 = '';
    initAnswer15_03 = '';
    @track q15_03_Options = [ ];

    question15_04 = '';
    initAnswer15_04 = '';
    @track q15_04_Options = [ ];

    question15_05 = '';
    initAnswer15_05 = '';
    @track q15_05_Options = [];

    question15_06 = '';
    initAnswer15_06 = '';
    @track q15_06_Options = [];

    question15_07 = '';
    initAnswer15_07 = '';
    @track q15_07_Options = [];

    question15_08 = '';
    initAnswer15_08 = '';
    @track q15_08_Options = [];

    question15_09 = '';
    initAnswer15_09 = '';
    @track q15_09_Options = [];
    //=======================================================//
    question13 = '';
    initAnswer13 = '';
    @track q13_Options = [];
    //=======================================================//
    question14 = '';
    initAnswer14 = '';
    @track q14_Options = [];
    //=======================================================//
    question16 = '';
    initAnswer16 = '';
    @track q16_Options = [];

    @wire(CurrentPageReference)
    getCurrentPageReference(currentPageReference) {
        if(currentPageReference) 
        {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            if(rxCurrentPageReference.state.studentId !== undefined)
            {
                this.rxStudentId = decodeURI(rxCurrentPageReference.state.studentId);
            }
            if(rxCurrentPageReference.state.cdm1Id !== undefined)
            {
                this.cdm1Id = decodeURI(rxCurrentPageReference.state.cdm1Id);
            }
            if(rxCurrentPageReference.state.cdm2Id !== undefined)
            {
                this.cdm2Id = decodeURI(rxCurrentPageReference.state.cdm2Id);
            }
            if(rxCurrentPageReference.state.cpId !== undefined)
            {
                this.cpId = decodeURI(rxCurrentPageReference.state.cpId);
            }

            if(rxCurrentPageReference.state.fem !== undefined)this.fem = decodeURI(rxCurrentPageReference.state.fem);
            if(rxCurrentPageReference.state.sch !== undefined)this.sch = decodeURI(rxCurrentPageReference.state.sch);
            if(rxCurrentPageReference.state.grd !== undefined)this.grd = decodeURI(rxCurrentPageReference.state.grd);
            if(rxCurrentPageReference.state.bid !== undefined)this.bid = decodeURI(rxCurrentPageReference.state.bid);
            if(rxCurrentPageReference.state.acid !== undefined)this.acid = decodeURI(rxCurrentPageReference.state.acid);

            if(rxCurrentPageReference.state.studentName !== undefined)this.studentName = decodeURI(rxCurrentPageReference.state.studentName);
            this.typ = decodeURI(rxCurrentPageReference.state.typ);
            this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;
            if(this.isEnglish){
                this.title = 'Endline Career Skills Data';
                this.errorTitle = 'Error';
                this.successMsg ='Endline Career Skills - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'एंडलाइन कैरियर कौशल मूल्यांकन डेटा';
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
        this.getApexRecordCS();

        this.flag = 'connectedCallback';
        console.log('this.flag : ' + this.flag);
    }

    getAssesmentQuestionFunc(){
        getAssesmentQuestion({
            objectName : 'Career Skill Endline',
            formType : 'Form V2',
            grade : ''
        }).then(result => {
            console.log('getAssesmentQuestion Result = '+JSON.stringify(result));
            if(result){
                this.assesmentQuestionAndLabel = result;
                let que11 = this.getQuestionsAndOptions(30);
                if(que11){
                    this.question11 = que11.question;
                }
                
                let que11_1 = this.getQuestionsAndOptions(31);
                if(que11_1){
                    this.question11_01 = que11_1.question;
                    this.q11_01_Options = que11_1.options;
                }
                let que11_2 = this.getQuestionsAndOptions(32);
                if(que11_2){
                    this.question11_02 = que11_2.question;
                    this.q11_02_Options = que11_2.options;
                }
                let que11_3 = this.getQuestionsAndOptions(33);
                if(que11_3){
                    this.question11_03 = que11_3.question;
                    this.q11_03_Options = que11_3.options;
                }
                let que11_4 = this.getQuestionsAndOptions(34);
                if(que11_4){
                    this.question11_04 = que11_4.question;
                    this.q11_04_Options = que11_4.options;
                }
                let que11_5 = this.getQuestionsAndOptions(35);
                if(que11_5){
                    this.question11_05 = que11_5.question;
                    this.q11_05_Options = que11_5.options;
                }
                let que11_6 = this.getQuestionsAndOptions(36);
                if(que11_6){
                    this.question11_06 = que11_6.question;
                    this.q11_06_Options = que11_6.options;
                }
                let que11_7 = this.getQuestionsAndOptions(37);
                if(que11_7){
                    this.question11_07 = que11_7.question;
                    this.q11_07_Options = que11_7.options;
                }
                let que11_8 = this.getQuestionsAndOptions(38);
                if(que11_8){
                    this.question11_08 = que11_8.question;
                    this.q11_08_Options = que11_8.options;
                }
                let que11_9 = this.getQuestionsAndOptions(39);
                if(que11_9){
                    this.question11_09 = que11_9.question;
                    this.q11_09_Options = que11_9.options;
                }
                let que12 = this.getQuestionsAndOptions(40);
                if(que12){
                    this.question12 = que12.question;
                    this.q12_Options = que12.options;
                }
                let que13 = this.getQuestionsAndOptions(41);
                if(que13){
                    this.question13 = que13.question;
                    this.q13_Options = que13.options;
                }
                let que14 = this.getQuestionsAndOptions(42);
                if(que14){
                    this.question14 = que14.question;
                    this.q14_Options = que14.options;
                }
                let que15 = this.getQuestionsAndOptions(43);
                if(que15){
                    this.question15 = que15.question;
                }
                let que15_1 = this.getQuestionsAndOptions(44);
                if(que15_1){
                    this.question15_01 = que15_1.question;
                    this.q15_01_Options = que15_1.options;
                }
                console.log('q15_01_Options =',this.q15_01_Options)
                let que15_2 = this.getQuestionsAndOptions(45);
                if(que15_2){
                    this.question15_02 = que15_2.question;
                    this.q15_02_Options = que15_2.options;
                }
                let que15_3 = this.getQuestionsAndOptions(46);
                if(que15_3){
                    this.question15_03 = que15_3.question;
                    this.q15_03_Options = que15_3.options;
                }
                let que15_4 = this.getQuestionsAndOptions(47);
                if(que15_4){
                    this.question15_04 = que15_4.question;
                    this.q15_04_Options = que15_4.options;
                }
                let que15_5 = this.getQuestionsAndOptions(48);
                if(que15_5){
                    this.question15_05 = que15_5.question;
                    this.q15_05_Options = que15_5.options;
                }
                let que15_6 = this.getQuestionsAndOptions(49);
                if(que15_6){
                    this.question15_06 = que15_6.question;
                    this.q15_06_Options = que15_6.options;
                }
                let que15_7 = this.getQuestionsAndOptions(50);
                if(que15_7){
                    this.question15_07 = que15_7.question;
                    this.q15_07_Options = que15_7.options;
                }
                let que15_8 = this.getQuestionsAndOptions(51);
                if(que15_8){
                    this.question15_08 = que15_8.question;
                    this.q15_08_Options = que15_8.options;
                }
                let que15_9 = this.getQuestionsAndOptions(52);
                if(que15_9){
                    this.question15_09 = que15_9.question;
                    this.q15_09_Options = que15_9.options;
                }
                let que16 = this.getQuestionsAndOptions(53);
                if(que16){
                    this.question16 = que16.question;
                    this.q16_Options = que16.options;
                }
                
            }
            console.log('q12_Options = ',this.q12_Options)
            console.log('question11_09 = ',this.question11_09)
            console.log('q13_Options = ',this.q13_Options)
            console.log('q14_Options = ',this.q14_Options)
            console.log('q16_Options = ',this.q16_Options)
            

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
                    //let optionName = (opt.Option_Label_English__c === 'No Answer') ? 'nil' : (opt.Option_Label_English__c === 'Multiple answers selected') ? '*' : (seqNumber >= 44  && seqNumber <= 52 ) ? (i+1) : optionNames[i];
                    let optionName = (opt.Option_Label_English__c === 'No Answer') ? 'nil' : (opt.Option_Label_English__c === 'Multiple answers selected') ? '*' : optionNames[i];
                    let option = {optionName:optionName,answer:false,optionValue:optionValue }
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

    initCheckBox(qOptions, recordFieldValue, formSubmitStatus){
        let foundAns = false;
        for(let key in qOptions){
            if(qOptions[key].optionName === recordFieldValue)
            {
                qOptions[key].answer = true;
                foundAns = true;
            }
        }

        if(!foundAns)
        {
            if(formSubmitStatus !== undefined && formSubmitStatus)
            {
                for(let key in qOptions){
                    if(qOptions[key].optionName === 'nil')
                    {
                        qOptions[key].answer = true;
                        break;
                    }
                }
            }
        }
    }

    getApexRecordCS(){
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

                this.csRecordId = record.Id;
                /*
                //Place init for question11 here 
                if(record.Q_11_1__c === undefined)this.initAnswer11.push('');
                else this.initAnswer11.push(record.Q_11_1__c);

                if(record.Q_11_2__c === undefined)this.initAnswer11.push('');
                else this.initAnswer11.push(record.Q_11_2__c);

                if(record.Q_11_3__c === undefined)this.initAnswer11.push('');
                else this.initAnswer11.push(record.Q_11_3__c);

                if(record.Q_11_4__c === undefined)this.initAnswer11.push('');
                else this.initAnswer11.push(record.Q_11_4__c);

                if(record.Q_11_5__c === undefined)this.initAnswer11.push('');
                else this.initAnswer11.push(record.Q_11_5__c);

                if(record.Q_11_6__c === undefined)this.initAnswer11.push('');
                else this.initAnswer11.push(record.Q_11_6__c);

                if(record.Q_11_7__c === undefined)this.initAnswer11.push('');
                else this.initAnswer11.push(record.Q_11_7__c);

                if(record.Q_11_8__c === undefined)this.initAnswer11.push('');
                else this.initAnswer11.push(record.Q_11_8__c);

                if(record.Q_11_9__c === undefined)this.initAnswer11.push('');
                else this.initAnswer11.push(record.Q_11_9__c);

                let validAns11 = ['A','B','*'];
                let foundAns11 = [];
                for(let x = 0; x < this.initAnswer11.length; x++) { //this.initAnswer11.length is important here
                    if(this.initAnswer11[x] !== '' && validAns11.includes(this.initAnswer11[x]))
                    {
                        this.q11_Options[x].answer = this.initAnswer11[x];
                        foundAns11[x] = true;
                    }
                    else 
                    {
                        foundAns11[x] = false;
                    }
                }

                if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                {
                    for(let x = 0; x < foundAns11.length; x++)
                    {
                        if(!foundAns11[x])
                        {
                            this.q11_Options[x].answer = 'nil';
                        }
                    }
                }*/
                //Place init for question11_01 here
                this.initAnswer11_01 = record.Q_11_1__c;
                this.initCheckBox(this.q11_01_Options, this.initAnswer11_01, record.Form_Submitted__c); 
                //Place init for question11_02 here
                this.initAnswer11_02 = record.Q_11_2__c;
                this.initCheckBox(this.q11_02_Options, this.initAnswer11_02, record.Form_Submitted__c);
                //Place init for question11_03 here
                this.initAnswer11_03 = record.Q_11_3__c;
                this.initCheckBox(this.q11_03_Options, this.initAnswer11_03, record.Form_Submitted__c); 
                //Place init for question11_04 here
                this.initAnswer11_04 = record.Q_11_4__c;
                this.initCheckBox(this.q11_04_Options, this.initAnswer11_04, record.Form_Submitted__c);  
                //Place init for question11_05 here
                this.initAnswer11_05 = record.Q_11_5__c;
                this.initCheckBox(this.q11_05_Options, this.initAnswer11_05, record.Form_Submitted__c); 
                //Place init for question11_06 here
                this.initAnswer11_06 = record.Q_11_6__c;
                this.initCheckBox(this.q11_06_Options, this.initAnswer11_06, record.Form_Submitted__c); 
                //Place init for question11_07 here
                this.initAnswer11_07 = record.Q_11_7__c;
                this.initCheckBox(this.q11_07_Options, this.initAnswer11_07, record.Form_Submitted__c); 
                //Place init for question11_08 here
                this.initAnswer11_08 = record.Q_11_8__c;
                this.initCheckBox(this.q11_08_Options, this.initAnswer11_08, record.Form_Submitted__c); 
                //Place init for question11_09 here
                this.initAnswer11_09 = record.Q_11_9__c;
                this.initCheckBox(this.q11_09_Options, this.initAnswer11_09, record.Form_Submitted__c); 
                //Place init for Question12 here
                this.initAnswer12.push(record.Q_12_1__c);
                this.initAnswer12.push(record.Q_12_2__c);
                this.initAnswer12.push(record.Q_12_3__c);
                this.initAnswer12.push(record.Q_12_4__c);

                let foundAns12 = false;
                for(let x = 0; x < this.initAnswer12.length; x++) { //this.initAnswer12.length is important here
                    if(this.initAnswer12[x] === this.q12_Options[x].optionName)
                    {
                        this.q12_Options[x].answer = true;
                        foundAns12 = true;
                    }
                }

                if(!foundAns12)
                {
                    if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                    {
                        for(let x = 0; x < this.q12_Options.length; x++) {
                            if(this.q12_Options[x].optionName === 'nil')
                            {
                                this.q12_Options[x].answer = true;
                                break;
                            }
                        }
                    }
                }
                //Place init for question13 here
                this.initAnswer13 = record.Q_13__c;
                this.initCheckBox(this.q13_Options, this.initAnswer13, record.Form_Submitted__c); 
                //Place init for question14 here
                this.initAnswer14 = record.Q_14__c;
                this.initCheckBox(this.q14_Options, this.initAnswer14, record.Form_Submitted__c); 
                //Place init for question15 here 
                /*
                if(record.Q_15_1__c === undefined)this.initAnswer15.push('');
                else this.initAnswer15.push(record.Q_15_1__c);

                if(record.Q_15_2__c === undefined)this.initAnswer15.push('');
                else this.initAnswer15.push(record.Q_15_2__c);

                if(record.Q_15_3__c === undefined)this.initAnswer15.push('');
                else this.initAnswer15.push(record.Q_15_3__c);

                if(record.Q_15_4__c === undefined)this.initAnswer15.push('');
                else this.initAnswer15.push(record.Q_15_4__c);

                if(record.Q_15_5__c === undefined)this.initAnswer15.push('');
                else this.initAnswer15.push(record.Q_15_5__c);

                if(record.Q_15_6__c === undefined)this.initAnswer15.push('');
                else this.initAnswer15.push(record.Q_15_6__c);

                if(record.Q_15_7__c === undefined)this.initAnswer15.push('');
                else this.initAnswer15.push(record.Q_15_7__c);

                if(record.Q_15_8__c === undefined)this.initAnswer15.push('');
                else this.initAnswer15.push(record.Q_15_8__c);

                if(record.Q_15_9__c === undefined)this.initAnswer15.push('');
                else this.initAnswer15.push(record.Q_15_9__c);
                
                let validAns15 = ['1','2','3','4','5','*'];
                let foundAns15 = [];
                for(let x = 0; x < this.initAnswer15.length; x++) { //this.initAnswer15.length is important here
                    if(this.initAnswer15[x] !== '' && validAns15.includes(this.initAnswer15[x]))
                    {
                        this.q15_Options[x].answer = this.initAnswer15[x];
                        foundAns15[x] = true;
                    }
                    else 
                    {
                        foundAns15[x] = false;
                    }
                }

                if(record.Form_Submitted__c !== undefined && record.Form_Submitted__c)
                {
                    for(let x = 0; x < foundAns15.length; x++)
                    {
                        if(!foundAns15[x])
                        {
                            this.q15_Options[x].answer = 'nil';
                        }
                    }
                }*/

                /* commented to accept the Ans as number for Question 15
                //Place init for question15_01 here
                this.initAnswer15_01 = record.Q_15_1__c;
                this.initCheckBox(this.q15_01_Options, this.initAnswer15_01, record.Form_Submitted__c); 
                //Place init for question15_02 here
                this.initAnswer15_02 = record.Q_15_2__c;
                this.initCheckBox(this.q15_02_Options, this.initAnswer15_02, record.Form_Submitted__c);
                //Place init for question15_03 here
                this.initAnswer15_03 = record.Q_15_3__c;
                this.initCheckBox(this.q15_03_Options, this.initAnswer15_03, record.Form_Submitted__c); 
                //Place init for question15_04 here
                this.initAnswer15_04 = record.Q_15_4__c;
                this.initCheckBox(this.q15_04_Options, this.initAnswer15_04, record.Form_Submitted__c);  
                //Place init for question15_05 here
                this.initAnswer15_05 = record.Q_15_5__c;
                this.initCheckBox(this.q15_05_Options, this.initAnswer15_05, record.Form_Submitted__c); 
                //Place init for question15_06 here
                this.initAnswer15_06 = record.Q_15_6__c;
                this.initCheckBox(this.q15_06_Options, this.initAnswer15_06, record.Form_Submitted__c); 
                //Place init for question15_07 here
                this.initAnswer15_07 = record.Q_15_7__c;
                this.initCheckBox(this.q15_07_Options, this.initAnswer15_07, record.Form_Submitted__c); 
                //Place init for question15_08 here
                this.initAnswer15_08 = record.Q_15_8__c;
                this.initCheckBox(this.q15_08_Options, this.initAnswer15_08, record.Form_Submitted__c); 
                //Place init for question15_09 here
                this.initAnswer15_09 = record.Q_15_9__c;
                this.initCheckBox(this.q15_09_Options, this.initAnswer15_09, record.Form_Submitted__c); 
                */
               //Place init for question15_01 here
               this.initAnswer15_01 = (record.Q_15_1__c == '1') ? 'A' : (record.Q_15_1__c == '2') ? 'B' : (record.Q_15_1__c == '3') ? 'C' : (record.Q_15_1__c == '4') ? 'D' : (record.Q_15_1__c == '5') ? 'E' : record.Q_15_1__c ;
               this.initCheckBox(this.q15_01_Options, this.initAnswer15_01, record.Form_Submitted__c); 
               //Place init for question15_02 here
               this.initAnswer15_02 = (record.Q_15_2__c == '1') ? 'A' : (record.Q_15_2__c == '2') ? 'B' : (record.Q_15_2__c == '3') ? 'C' : (record.Q_15_2__c == '4') ? 'D' : (record.Q_15_2__c == '5') ? 'E' : record.Q_15_2__c ;

               this.initCheckBox(this.q15_02_Options, this.initAnswer15_02, record.Form_Submitted__c);
               //Place init for question15_03 here
               this.initAnswer15_03 = (record.Q_15_3__c == '1') ? 'A' : (record.Q_15_3__c == '2') ? 'B' : (record.Q_15_3__c == '3') ? 'C' : (record.Q_15_3__c == '4') ? 'D' : (record.Q_15_3__c == '5') ? 'E' : record.Q_15_3__c ;

               this.initCheckBox(this.q15_03_Options, this.initAnswer15_03, record.Form_Submitted__c); 
               //Place init for question15_04 here
               this.initAnswer15_04 = (record.Q_15_4__c == '1') ? 'A' : (record.Q_15_4__c == '2') ? 'B' : (record.Q_15_4__c == '3') ? 'C' : (record.Q_15_4__c == '4') ? 'D' : (record.Q_15_4__c == '5') ? 'E' : record.Q_15_4__c ;

               this.initCheckBox(this.q15_04_Options, this.initAnswer15_04, record.Form_Submitted__c);  
               //Place init for question15_05 here
               this.initAnswer15_05 = (record.Q_15_5__c == '1') ? 'A' : (record.Q_15_5__c == '2') ? 'B' : (record.Q_15_5__c == '3') ? 'C' : (record.Q_15_5__c == '4') ? 'D' : (record.Q_15_5__c == '5') ? 'E' : record.Q_15_5__c ;

               this.initCheckBox(this.q15_05_Options, this.initAnswer15_05, record.Form_Submitted__c); 
               //Place init for question15_06 here
               this.initAnswer15_06 = (record.Q_15_6__c == '1') ? 'A' : (record.Q_15_6__c == '2') ? 'B' : (record.Q_15_6__c == '3') ? 'C' : (record.Q_15_6__c == '4') ? 'D' : (record.Q_15_6__c == '5') ? 'E' : record.Q_15_6__c ;

               this.initCheckBox(this.q15_06_Options, this.initAnswer15_06, record.Form_Submitted__c); 
               //Place init for question15_07 here
               this.initAnswer15_07 = (record.Q_15_7__c == '1') ? 'A' : (record.Q_15_7__c == '2') ? 'B' : (record.Q_15_7__c == '3') ? 'C' : (record.Q_15_7__c == '4') ? 'D' : (record.Q_15_7__c == '5') ? 'E' : record.Q_15_7__c ;

               this.initCheckBox(this.q15_07_Options, this.initAnswer15_07, record.Form_Submitted__c); 
               //Place init for question15_08 here
               this.initAnswer15_08 = (record.Q_15_8__c == '1') ? 'A' : (record.Q_15_8__c == '2') ? 'B' : (record.Q_15_8__c == '3') ? 'C' : (record.Q_15_8__c == '4') ? 'D' : (record.Q_15_8__c == '5') ? 'E' : record.Q_15_8__c ;

               this.initCheckBox(this.q15_08_Options, this.initAnswer15_08, record.Form_Submitted__c); 
               //Place init for question15_09 here
               this.initAnswer15_09 = (record.Q_15_9__c == '1') ? 'A' : (record.Q_15_9__c == '2') ? 'B' : (record.Q_15_9__c == '3') ? 'C' : (record.Q_15_9__c == '4') ? 'D' : (record.Q_15_9__c == '5') ? 'E' : record.Q_15_9__c ;

               this.initCheckBox(this.q15_09_Options, this.initAnswer15_09, record.Form_Submitted__c); 

                //Place init for question16 here
                this.initAnswer16 = record.Q_16__c;
                this.initCheckBox(this.q16_Options, this.initAnswer16, record.Form_Submitted__c); 
                //===========================================================//
                this.isLoading = false;
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Career Skills',
                    message: 'Career Skills record fields received successfuly',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
            }while(false);
            this.flag = 'getApexRecordCS';
            console.log('this.flag : ' + this.flag);
        }).catch(error => {
            this.isLoading = false;
            // let rxError = 'Error while recieving record fields: Career Skills';

            let rxError;
            if(isEnglish){
                this.rxError = 'Error while recieving record fields: Career Skills';
            }else{
                this.rxError = 'रिकॉर्ड फ़ील्ड प्राप्त करते समय त्रुटि: कैरियर कौशल';
            }
            
            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                // title : 'Career Skills',
                title : this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    reInitializeRecordCS(){
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
            /*
            //Place init for question11 here 
            this.initAnswer11 = [];
            if(record.Q_11_1__c === undefined)this.initAnswer11.push('');
            else this.initAnswer11.push(record.Q_11_1__c);

            if(record.Q_11_2__c === undefined)this.initAnswer11.push('');
            else this.initAnswer11.push(record.Q_11_2__c);

            if(record.Q_11_3__c === undefined)this.initAnswer11.push('');
            else this.initAnswer11.push(record.Q_11_3__c);

            if(record.Q_11_4__c === undefined)this.initAnswer11.push('');
            else this.initAnswer11.push(record.Q_11_4__c);

            if(record.Q_11_5__c === undefined)this.initAnswer11.push('');
            else this.initAnswer11.push(record.Q_11_5__c);

            if(record.Q_11_6__c === undefined)this.initAnswer11.push('');
            else this.initAnswer11.push(record.Q_11_6__c);

            if(record.Q_11_7__c === undefined)this.initAnswer11.push('');
            else this.initAnswer11.push(record.Q_11_7__c);

            if(record.Q_11_8__c === undefined)this.initAnswer11.push('');
            else this.initAnswer11.push(record.Q_11_8__c);

            if(record.Q_11_9__c === undefined)this.initAnswer11.push('');
            else this.initAnswer11.push(record.Q_11_9__c);*/

            //Place init for question11_01 here
            this.initAnswer11_01 = record.Q_11_1__c;
            //Place init for question11_02 here
            this.initAnswer11_02 = record.Q_11_2__c;
            //Place init for question11_03 here
            this.initAnswer11_03 = record.Q_11_3__c;
            //Place init for question11_04 here
            this.initAnswer11_04 = record.Q_11_4__c; 
            //Place init for question11_05 here
            this.initAnswer11_05 = record.Q_11_5__c;
            //Place init for question11_06 here
            this.initAnswer11_06 = record.Q_11_6__c; 
            //Place init for question11_07 here
            this.initAnswer11_07 = record.Q_11_7__c; 
            //Place init for question11_08 here
            this.initAnswer11_08 = record.Q_11_8__c; 
            //Place init for question11_09 here
            this.initAnswer11_09 = record.Q_11_9__c;
            //Place init for Question12 here
            this.initAnswer12 = [];
            this.initAnswer12.push(record.Q_12_1__c);
            this.initAnswer12.push(record.Q_12_2__c);
            this.initAnswer12.push(record.Q_12_3__c);
            this.initAnswer12.push(record.Q_12_4__c);
            //Place init for question13 here
            this.initAnswer13 = record.Q_13__c;
            //Place init for question14 here
            this.initAnswer14 = record.Q_14__c;
            //Place init for question15 here 
            /*
            this.initAnswer15 = [];
            if(record.Q_15_1__c === undefined)this.initAnswer15.push('');
            else this.initAnswer15.push(record.Q_15_1__c);

            if(record.Q_15_2__c === undefined)this.initAnswer15.push('');
            else this.initAnswer15.push(record.Q_15_2__c);

            if(record.Q_15_3__c === undefined)this.initAnswer15.push('');
            else this.initAnswer15.push(record.Q_15_3__c);

            if(record.Q_15_4__c === undefined)this.initAnswer15.push('');
            else this.initAnswer15.push(record.Q_15_4__c);

            if(record.Q_15_5__c === undefined)this.initAnswer15.push('');
            else this.initAnswer15.push(record.Q_15_5__c);

            if(record.Q_15_6__c === undefined)this.initAnswer15.push('');
            else this.initAnswer15.push(record.Q_15_6__c);

            if(record.Q_15_7__c === undefined)this.initAnswer15.push('');
            else this.initAnswer15.push(record.Q_15_7__c);

            if(record.Q_15_8__c === undefined)this.initAnswer15.push('');
            else this.initAnswer15.push(record.Q_15_8__c);

            if(record.Q_15_9__c === undefined)this.initAnswer15.push('');
            else this.initAnswer15.push(record.Q_15_9__c);*/

            //Place init for question15_01 here
            this.initAnswer15_01 = record.Q_15_1__c;
            //Place init for question15_02 here
            this.initAnswer15_02 = record.Q_15_2__c;
            //Place init for question15_03 here
            this.initAnswer15_03 = record.Q_15_3__c;
            //Place init for question15_04 here
            this.initAnswer15_04 = record.Q_15_4__c; 
            //Place init for question15_05 here
            this.initAnswer15_05 = record.Q_15_5__c;
            //Place init for question15_06 here
            this.initAnswer15_06 = record.Q_15_6__c; 
            //Place init for question15_07 here
            this.initAnswer15_07 = record.Q_15_7__c; 
            //Place init for question15_08 here
            this.initAnswer15_08 = record.Q_15_8__c; 
            //Place init for question15_09 here
            this.initAnswer15_09 = record.Q_15_9__c;
            //Place init for question16 here
            this.initAnswer16 = record.Q_16__c;
            //===========================================================//
            this.flag = 'reInitializeRecordCS';
            console.log('this.flag : ' + this.flag);
        }).catch(error => {
            this.isLoading = false;
            // let rxError = 'Error while recieving record fields: Career Skills';
            if(isEnglish){
                this.rxError = 'Error while recieving record fields: Career Skills';
            }else{
                this.rxError = 'रिकॉर्ड फ़ील्ड प्राप्त करते समय त्रुटि: कैरियर कौशल';
            }

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                // title : 'Career Skills',
                title : this.errorTitle,
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }
    /*
    q11GetFinalAnswer(){
        let finalAnswer = []; 

        for(let key in this.q11_Options){
            let ans = this.q11_Options[key].answer;
            if(ans === 'nil')ans = '';
            finalAnswer.push(ans);
        }

        let matchCount = 0;
        for(; matchCount < finalAnswer.length; matchCount++)
        {
            if(finalAnswer[matchCount] !== this.initAnswer11[matchCount])break;
        }

        if(matchCount === finalAnswer.length)
        {
            //console.log('No change in answer of Question11, Please return');
            return ['return'];
        }

        return finalAnswer;
    }

    saveQ11(){
        const finalAnswer = this.q11GetFinalAnswer();
        if(finalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question11, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question11, Please proceed');
        // }

        const q11Answer = {
            answer1 : finalAnswer[0],
            answer2 : finalAnswer[1],
            answer3 : finalAnswer[2],
            answer4 : finalAnswer[3],
            answer5 : finalAnswer[4],
            answer6 : finalAnswer[5],
            answer7 : finalAnswer[6],
            answer8 : finalAnswer[7],
            answer9 : finalAnswer[8]
        };

        saveQuestion11({
            recordId : this.csRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            ans : q11Answer
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.csRecordId = result;
            this.reInitializeRecordCS();
            //===========================================================//
            
            // const event = new ShowToastEvent({
            //     title: 'Career Skills',
            //     message: 'Question11 answer upsert successful',
            //     variant: 'success'
            // });                
            // this.dispatchEvent(event);

            this.flag = 'saveQ11';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while upserting Question11 answer';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Career Skills',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    handleQ11(event) {
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.value;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q11_Options){
            if(this.q11_Options[key].optionName === targetId)
            {
                this.q11_Options[key].answer = targetValue;
            }
        }

        if (this.delayTimeOut11) {
            window.clearTimeout(this.delayTimeOut11);
        }

        this.delayTimeOut11 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            this.saveQ11();
        }, this.delay);

        this.flag = 'handleQ11';
        console.log('this.flag : ' + this.flag);
    }*/

    qXXGetFinalAnswer(qOptions,initAnswerXX){
        debugger;
        let finalAnswer; 

        for(let key in qOptions){
            if(qOptions[key].answer)
            {
                if(qOptions[key].optionName === 'nil')continue;
                finalAnswer = qOptions[key].optionName;
                break;
            }
        }

        if(finalAnswer === initAnswerXX)finalAnswer = 'return';
        // console.log('qXXGetFinalAnswer : ' + finalAnswer);
        // console.log('initAnswerXX : ' + initAnswerXX);
        return finalAnswer;
    }
	
	saveQXX(qIndex,qOptions,initAnswerXX){
        const finalAnswer = this.qXXGetFinalAnswer(qOptions,initAnswerXX);
        if(finalAnswer === 'return')
        {
            // console.log('Please return, No change in answer of QuestionXX: ' + qIndex);
            return;
        }
        // else
        // {
        //     console.log('Please proceed, Change in answer of QuestionXX: ' + qIndex);
        // }

        saveSingle({
            recordId : this.csRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            qNo : qIndex,
            ans : {answer : finalAnswer}
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.csRecordId = result;
            this.reInitializeRecordCS();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Skills',
                message: 'QuestionXX answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQXX: ' + qIndex;
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while upserting answer, QuestionXX: ' + qIndex;

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

    checkBoxEventHandler(event, qOptions){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);
        
        for(let key in qOptions){
            if(qOptions[key].optionName === targetId)
            {
                qOptions[key].answer = targetValue;
            }
            else
            {
                qOptions[key].answer = false;
            }
        }
    }
    
    handleQ11_01(event){
        this.checkBoxEventHandler(event,this.q11_01_Options);

        if (this.delayTimeOut11_01) {
            window.clearTimeout(this.delayTimeOut11_01);
        }

        this.delayTimeOut11_01 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('11_01',this.q11_01_Options,this.initAnswer11_01);
        }, this.delay);

        this.flag = 'handleQ11_01';
        console.log('this.flag : ' + this.flag);
    }
    
    handleQ11_02(event){
        this.checkBoxEventHandler(event,this.q11_02_Options);

        if (this.delayTimeOut11_02) {
            window.clearTimeout(this.delayTimeOut11_02);
        }

        this.delayTimeOut11_02 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('11_02',this.q11_02_Options,this.initAnswer11_02);
        }, this.delay);

        this.flag = 'handleQ11_02';
        console.log('this.flag : ' + this.flag);
    }

    handleQ11_03(event){
        this.checkBoxEventHandler(event,this.q11_03_Options);

        if (this.delayTimeOut11_03) {
            window.clearTimeout(this.delayTimeOut11_03);
        }

        this.delayTimeOut11_03 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('11_03',this.q11_03_Options,this.initAnswer11_03);
        }, this.delay);

        this.flag = 'handleQ11_03';
        console.log('this.flag : ' + this.flag);
    }

    handleQ11_04(event){
        this.checkBoxEventHandler(event,this.q11_04_Options);

        if (this.delayTimeOut11_04) {
            window.clearTimeout(this.delayTimeOut11_04);
        }

        this.delayTimeOut11_04 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('11_04',this.q11_04_Options,this.initAnswer11_04);
        }, this.delay);

        this.flag = 'handleQ11_04';
        console.log('this.flag : ' + this.flag);
    }

    handleQ11_05(event){
        this.checkBoxEventHandler(event,this.q11_05_Options);

        if (this.delayTimeOut11_05) {
            window.clearTimeout(this.delayTimeOut11_05);
        }

        this.delayTimeOut11_05 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('11_05',this.q11_05_Options,this.initAnswer11_05);
        }, this.delay);

        this.flag = 'handleQ11_05';
        console.log('this.flag : ' + this.flag);
    }

    handleQ11_06(event){
        this.checkBoxEventHandler(event,this.q11_06_Options);

        if (this.delayTimeOut11_06) {
            window.clearTimeout(this.delayTimeOut11_06);
        }

        this.delayTimeOut11_06 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('11_06',this.q11_06_Options,this.initAnswer11_06);
        }, this.delay);

        this.flag = 'handleQ11_06';
        console.log('this.flag : ' + this.flag);
    }

    handleQ11_07(event){
        this.checkBoxEventHandler(event,this.q11_07_Options);

        if (this.delayTimeOut11_07) {
            window.clearTimeout(this.delayTimeOut11_07);
        }

        this.delayTimeOut11_07 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('11_07',this.q11_07_Options,this.initAnswer11_07);
        }, this.delay);

        this.flag = 'handleQ11_07';
        console.log('this.flag : ' + this.flag);
    }

    handleQ11_08(event){
        this.checkBoxEventHandler(event,this.q11_08_Options);

        if (this.delayTimeOut11_08) {
            window.clearTimeout(this.delayTimeOut11_08);
        }

        this.delayTimeOut11_08 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('11_08',this.q11_08_Options,this.initAnswer11_08);
        }, this.delay);

        this.flag = 'handleQ11_08';
        console.log('this.flag : ' + this.flag);
    }

    handleQ11_09(event){
        this.checkBoxEventHandler(event,this.q11_09_Options);

        if (this.delayTimeOut11_09) {
            window.clearTimeout(this.delayTimeOut11_09);
        }

        this.delayTimeOut11_09 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('11_09',this.q11_09_Options,this.initAnswer11_09);
        }, this.delay);

        this.flag = 'handleQ11_09';
        console.log('this.flag : ' + this.flag);
    }

    q12GetFinalAnswer(){
        let finalAnswer = [];

        for(let key in this.q12_Options){
            if(this.q12_Options[key].optionName === 'nil')continue;
            
            if(this.q12_Options[key].answer)
            {
                finalAnswer.push(this.q12_Options[key].optionName);
            }
            else
            {
                finalAnswer.push(undefined);
            }
        }

        let matchCount = 0;
        for(; matchCount < finalAnswer.length; matchCount++)
        {
            if(finalAnswer[matchCount] !== this.initAnswer12[matchCount])break;
        }
        if(matchCount === finalAnswer.length)
        {
            //console.log('No change in answer of Question12, Please return');
            return ['return'];
        }

        return finalAnswer;
    }

    saveQ12(){
        const finalAnswer = this.q12GetFinalAnswer();
        if(finalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question12, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question12, Please proceed');
        // }

        const q12Answer = {
            answer_2_1 : finalAnswer[0],
            answer_2_2 : finalAnswer[1],
            answer_2_3 : finalAnswer[2],
            answer_2_4 : finalAnswer[3]
        };

        //this.rxRecordIdCMD1 = null; //For temperary purpose delete afterwards

        saveQuestion12({
            recordId : this.csRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            ans : q12Answer
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.csRecordId = result;
            this.reInitializeRecordCS();
            //===========================================================//
            /*
            const event = new ShowToastEvent({
                title: 'Career Skills',
                message: 'Question12 answer upsert successful',
                variant: 'success'
            });                
            this.dispatchEvent(event);
            */

            this.flag = 'saveQuestion12';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while upserting Question12 answer';

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

    handleQ12(event){
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.checked;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        if(targetId === 'nil')
        {
            for(let key in this.q12_Options){
                if(this.q12_Options[key].optionName === 'nil')
                {
                    this.q12_Options[key].answer = targetValue;
                }
                else
                {
                    this.q12_Options[key].answer = false;
                }
            }
        }
        else
        {
            for(let key in this.q12_Options){
                if(this.q12_Options[key].optionName === targetId)
                {
                    this.q12_Options[key].answer = targetValue;
                }
                else if(this.q12_Options[key].optionName === 'nil')
                {
                    this.q12_Options[key].answer = false;
                }
            }
        }

        if (this.delayTimeOut12) {
            window.clearTimeout(this.delayTimeOut12);
        }

        this.delayTimeOut12 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQ12();
        }, this.delay);

        this.flag = 'handleQ12';
        console.log('this.flag : ' + this.flag);
    }

    handleQ13(event){
        this.checkBoxEventHandler(event,this.q13_Options);

        if (this.delayTimeOut13) {
            window.clearTimeout(this.delayTimeOut13);
        }

        this.delayTimeOut13 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('13',this.q13_Options,this.initAnswer13);
        }, this.delay);

        this.flag = 'handleQ13';
        console.log('this.flag : ' + this.flag);
    }
	
	handleQ14(event){
        this.checkBoxEventHandler(event,this.q14_Options);

        if (this.delayTimeOut14) {
            window.clearTimeout(this.delayTimeOut14);
        }

        this.delayTimeOut14 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('14',this.q14_Options,this.initAnswer14);
        }, this.delay);

        this.flag = 'handleQ14';
        console.log('this.flag : ' + this.flag);
    }

    /*
    q15GetFinalAnswer(){
        let finalAnswer = []; 

        for(let key in this.q15_Options){
            let ans = this.q15_Options[key].answer;
            if(ans === 'nil')ans = '';
            finalAnswer.push(ans);
        }

        let matchCount = 0;
        for(; matchCount < finalAnswer.length; matchCount++)
        {
            if(finalAnswer[matchCount] !== this.initAnswer15[matchCount])break;
        }

        if(matchCount === finalAnswer.length)
        {
            //console.log('No change in answer of Question15, Please return');
            return ['return'];
        }

        return finalAnswer;
    }

    saveQ15(){
        const finalAnswer = this.q15GetFinalAnswer();
        if(finalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question15, Please return');
            return;
        }
        // else
        // {
        //     console.log('Change in answer of Question15, Please proceed');
        // }

        const q15Answer = {
            answer1 : finalAnswer[0],
            answer2 : finalAnswer[1],
            answer3 : finalAnswer[2],
            answer4 : finalAnswer[3],
            answer5 : finalAnswer[4],
            answer6 : finalAnswer[5],
            answer7 : finalAnswer[6],
            answer8 : finalAnswer[7],
            answer9 : finalAnswer[8]
        };

        saveQuestion15({
            recordId : this.csRecordId,
            studentId : this.rxStudentId,
            barCode : this.studentBarcode,
            ans : q15Answer
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            this.csRecordId = result;
            this.reInitializeRecordCS();
            //===========================================================//
            
            // const event = new ShowToastEvent({
            //     title: 'Career Skills',
            //     message: 'Question15 answer upsert successful',
            //     variant: 'success'
            // });                
            // this.dispatchEvent(event);
            // 

            this.flag = 'saveQ15';
            console.log('this.flag : ' + this.flag);

        }).catch(error => {
            let rxError = 'Error while upserting Question15 answer';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'Career Skills',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    handleQ15(event) {
        let targetId = event.target.dataset.id;
        //console.log('contactLookuphandler, targetId : '+ targetId);
        let targetValue = event.target.value;
        //console.log('contactLookuphandler, targetValue : '+ targetValue);

        for(let key in this.q15_Options){
            if(this.q15_Options[key].optionName === targetId)
            {
                this.q15_Options[key].answer = targetValue;
            }
        }

        if (this.delayTimeOut15) {
            window.clearTimeout(this.delayTimeOut15);
        }

        this.delayTimeOut15 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            this.saveQ15();
        }, this.delay);

        this.flag = 'handleQ15';
        console.log('this.flag : ' + this.flag);
    }*/

    handleQ15_01(event){
        this.checkBoxEventHandler(event,this.q15_01_Options);

        if (this.delayTimeOut15_01) {
            window.clearTimeout(this.delayTimeOut15_01);
        }

        this.delayTimeOut15_01 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('15_01',this.q15_01_Options,this.initAnswer15_01);
        }, this.delay);

        this.flag = 'handleQ15_01';
        console.log('this.flag : ' + this.flag);
    }
    
    handleQ15_02(event){
        this.checkBoxEventHandler(event,this.q15_02_Options);

        if (this.delayTimeOut15_02) {
            window.clearTimeout(this.delayTimeOut15_02);
        }

        this.delayTimeOut15_02 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('15_02',this.q15_02_Options,this.initAnswer15_02);
        }, this.delay);

        this.flag = 'handleQ15_02';
        console.log('this.flag : ' + this.flag);
    }

    handleQ15_03(event){
        this.checkBoxEventHandler(event,this.q15_03_Options);

        if (this.delayTimeOut15_03) {
            window.clearTimeout(this.delayTimeOut15_03);
        }

        this.delayTimeOut15_03 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('15_03',this.q15_03_Options,this.initAnswer15_03);
        }, this.delay);

        this.flag = 'handleQ15_03';
        console.log('this.flag : ' + this.flag);
    }

    handleQ15_04(event){
        this.checkBoxEventHandler(event,this.q15_04_Options);

        if (this.delayTimeOut15_04) {
            window.clearTimeout(this.delayTimeOut15_04);
        }

        this.delayTimeOut15_04 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('15_04',this.q15_04_Options,this.initAnswer15_04);
        }, this.delay);

        this.flag = 'handleQ15_04';
        console.log('this.flag : ' + this.flag);
    }

    handleQ15_05(event){
        this.checkBoxEventHandler(event,this.q15_05_Options);

        if (this.delayTimeOut15_05) {
            window.clearTimeout(this.delayTimeOut15_05);
        }

        this.delayTimeOut15_05 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('15_05',this.q15_05_Options,this.initAnswer15_05);
        }, this.delay);

        this.flag = 'handleQ15_05';
        console.log('this.flag : ' + this.flag);
    }

    handleQ15_06(event){
        this.checkBoxEventHandler(event,this.q15_06_Options);

        if (this.delayTimeOut15_06) {
            window.clearTimeout(this.delayTimeOut15_06);
        }

        this.delayTimeOut15_06 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('15_06',this.q15_06_Options,this.initAnswer15_06);
        }, this.delay);

        this.flag = 'handleQ15_06';
        console.log('this.flag : ' + this.flag);
    }

    handleQ15_07(event){
        this.checkBoxEventHandler(event,this.q15_07_Options);

        if (this.delayTimeOut15_07) {
            window.clearTimeout(this.delayTimeOut15_07);
        }

        this.delayTimeOut15_07 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('15_07',this.q15_07_Options,this.initAnswer15_07);
        }, this.delay);

        this.flag = 'handleQ15_07';
        console.log('this.flag : ' + this.flag);
    }

    handleQ15_08(event){
        this.checkBoxEventHandler(event,this.q15_08_Options);

        if (this.delayTimeOut15_08) {
            window.clearTimeout(this.delayTimeOut15_08);
        }

        this.delayTimeOut15_08 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('15_08',this.q15_08_Options,this.initAnswer15_08);
        }, this.delay);

        this.flag = 'handleQ15_08';
        console.log('this.flag : ' + this.flag);
    }

    handleQ15_09(event){
        this.checkBoxEventHandler(event,this.q15_09_Options);

        if (this.delayTimeOut15_09) {
            window.clearTimeout(this.delayTimeOut15_09);
        }

        this.delayTimeOut15_09 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('15_09',this.q15_09_Options,this.initAnswer15_09);
        }, this.delay);

        this.flag = 'handleQ15_09';
        console.log('this.flag : ' + this.flag);
    }

    handleQ16(event){
        this.checkBoxEventHandler(event,this.q16_Options);

        if (this.delayTimeOut16) {
            window.clearTimeout(this.delayTimeOut16);
        }

        this.delayTimeOut16 = setTimeout(() => {
            //filter dropdown list based on search key parameter
            // this.saveQXX('16',this.q16_Options,this.initAnswer16);
        }, this.delay);

        this.flag = 'handleQ16';
        console.log('this.flag : ' + this.flag);
    }

    validateSingleSelectCheckBox(qOptions){
        let foundans = false;
        for(let key in qOptions){
            if(qOptions[key].answer)
            {
                foundans = true;
                break;
            }
        }
        return foundans;
    }

    allQuestionsAttempted(){
        let rxError = '';
        //===============================================//
        /*
        let foundans11 = [];
        for(let x = 0; x < this.q11_Options.length ; x++)
        {
            if(this.q11_Options[x].answer === '')
            {
                foundans11[x] = false;
            }
            else foundans11[x] = true;
        }

        let foundans11All = true;
        for(let x = 0; x < foundans11.length ; x++)
        {
            if(!foundans11[x])
            {
                if(rxError !== '')rxError += ', ' + 'Q11.' + + (x+1);
                else rxError = 'Q11.' + (x+1);

                foundans11All = false;
            }
        }*/
        //===============================================//
        let foundans11_01 = this.validateSingleSelectCheckBox(this.q11_01_Options);
        if(!foundans11_01)
        {
            if(rxError !== '')rxError += ', ' + 'Q11(a)';
            else rxError = 'Q11(a)';
        }
        //===============================================//
        let foundans11_02 = this.validateSingleSelectCheckBox(this.q11_02_Options);
        if(!foundans11_02)
        {
            if(rxError !== '')rxError += ', ' + 'Q11(b)';
            else rxError = 'Q11(b)';
        }
        //===============================================//
        let foundans11_03 = this.validateSingleSelectCheckBox(this.q11_03_Options);
        if(!foundans11_03)
        {
            if(rxError !== '')rxError += ', ' + 'Q11(c)';
            else rxError = 'Q11(c)';
        }
        //===============================================//
        let foundans11_04 = this.validateSingleSelectCheckBox(this.q11_04_Options);
        if(!foundans11_04)
        {
            if(rxError !== '')rxError += ', ' + 'Q11(d)';
            else rxError = 'Q11(d)';
        }
        //===============================================//
        let foundans11_05 = this.validateSingleSelectCheckBox(this.q11_05_Options);
        if(!foundans11_05)
        {
            if(rxError !== '')rxError += ', ' + 'Q11(e)';
            else rxError = 'Q11(e)';
        }
        //===============================================//
        let foundans11_06 = this.validateSingleSelectCheckBox(this.q11_06_Options);
        if(!foundans11_06)
        {
            if(rxError !== '')rxError += ', ' + 'Q11(f)';
            else rxError = 'Q11(f)';
        }
        //===============================================//
        let foundans11_07 = this.validateSingleSelectCheckBox(this.q11_07_Options);
        if(!foundans11_07)
        {
            if(rxError !== '')rxError += ', ' + 'Q11(g)';
            else rxError = 'Q11(g)';
        }
        //===============================================//
        let foundans11_08 = this.validateSingleSelectCheckBox(this.q11_08_Options);
        if(!foundans11_08)
        {
            if(rxError !== '')rxError += ', ' + 'Q11(h)';
            else rxError = 'Q11(h)';
        }
        //===============================================//
        let foundans11_09 = this.validateSingleSelectCheckBox(this.q11_09_Options);
        if(!foundans11_09)
        {
            if(rxError !== '')rxError += ', ' + 'Q11(i)';
            else rxError = 'Q11(i)';
        }
        //===============================================// 
        let foundans12 = false;
        for(let key in this.q12_Options){
            if(this.q12_Options[key].answer)
            {
                foundans12 = true;
                break;
            }
        }
        if(!foundans12)
        {
            if(rxError !== '')rxError += ', ' + 'Q12';
            else rxError = 'Q12';
        }
        //===============================================//
        let foundans13 = this.validateSingleSelectCheckBox(this.q13_Options);;
        if(!foundans13)
        {
            if(rxError !== '')rxError += ', ' + 'Q13';
            else rxError = 'Q13';
        }
        //===============================================//
        let foundans14 = this.validateSingleSelectCheckBox(this.q14_Options);;
        if(!foundans14)
        {
            if(rxError !== '')rxError += ', ' + 'Q14';
            else rxError = 'Q14';
        }  
        //===============================================//  
        /*  
        let foundans15 = [];
        for(let x = 0; x < this.q15_Options.length ; x++)
        {
            if(this.q15_Options[x].answer === '')
            {
                foundans15[x] = false;
            }
            else foundans15[x] = true;
        }

        let foundans15All = true;
        for(let x = 0; x < foundans15.length ; x++)
        {
            if(!foundans15[x])
            {
                if(rxError !== '')rxError += ', ' + 'Q15.' + + (x+1);
                else rxError = 'Q15.' + (x+1);

                foundans15All = false;
            }
        }*/
        //===============================================//
        /*let foundans15_01 = this.validateSingleSelectCheckBox(this.q15_01_Options);
        if(!foundans15_01)
        {
            if(rxError !== '')rxError += ', ' + 'Q15(a)';
            else rxError = 'Q15(a)';
        }
        //===============================================//
        let foundans15_02 = this.validateSingleSelectCheckBox(this.q15_02_Options);
        if(!foundans15_02)
        {
            if(rxError !== '')rxError += ', ' + 'Q15(b)';
            else rxError = 'Q15(b)';
        }
        //===============================================//
        let foundans15_03 = this.validateSingleSelectCheckBox(this.q15_03_Options);
        if(!foundans15_03)
        {
            if(rxError !== '')rxError += ', ' + 'Q15(c)';
            else rxError = 'Q15(c)';
        }
        //===============================================//
        let foundans15_04 = this.validateSingleSelectCheckBox(this.q15_04_Options);
        if(!foundans15_04)
        {
            if(rxError !== '')rxError += ', ' + 'Q15(d)';
            else rxError = 'Q15(d)';
        }
        //===============================================//
        let foundans15_05 = this.validateSingleSelectCheckBox(this.q15_05_Options);
        if(!foundans15_05)
        {
            if(rxError !== '')rxError += ', ' + 'Q15(e)';
            else rxError = 'Q15(e)';
        }
        //===============================================//
        let foundans15_06 = this.validateSingleSelectCheckBox(this.q15_06_Options);
        if(!foundans15_06)
        {
            if(rxError !== '')rxError += ', ' + 'Q15(f)';
            else rxError = 'Q15(f)';
        }
        //===============================================//
        let foundans15_07 = this.validateSingleSelectCheckBox(this.q15_07_Options);
        if(!foundans15_07)
        {
            if(rxError !== '')rxError += ', ' + 'Q15(g)';
            else rxError = 'Q15(g)';
        }
        //===============================================//
        let foundans15_08 = this.validateSingleSelectCheckBox(this.q15_08_Options);
        if(!foundans15_08)
        {
            if(rxError !== '')rxError += ', ' + 'Q15(h)';
            else rxError = 'Q15(h)';
        }
        //===============================================//
        let foundans15_09 = this.validateSingleSelectCheckBox(this.q15_09_Options);
        if(!foundans15_09)
        {
            if(rxError !== '')rxError += ', ' + 'Q15(i)';
            else rxError = 'Q15(i)';
        }
        */ 
        let foundans15_01 = this.validateSingleSelectCheckBox(this.q15_01_Options);
        if(!foundans15_01)
        {
            if(rxError !== '')rxError += ', ' + '15(i)';
            else rxError = '15(i)';
        }
        //===============================================//
        let foundans15_02 = this.validateSingleSelectCheckBox(this.q15_02_Options);
        if(!foundans15_02)
        {
            if(rxError !== '')rxError += ', ' + '15(ii)';
            else rxError = '15(ii)';
        }
        //===============================================//
        let foundans15_03 = this.validateSingleSelectCheckBox(this.q15_03_Options);
        if(!foundans15_03)
        {
            if(rxError !== '')rxError += ', ' + '15(iii)';
            else rxError = '15(iii)';
        }
        //===============================================//
        let foundans15_04 = this.validateSingleSelectCheckBox(this.q15_04_Options);
        if(!foundans15_04)
        {
            if(rxError !== '')rxError += ', ' + '15(iv)';
            else rxError = '15(iv)';
        }
        //===============================================//
        let foundans15_05 = this.validateSingleSelectCheckBox(this.q15_05_Options);
        if(!foundans15_05)
        {
            if(rxError !== '')rxError += ', ' + '15(v)';
            else rxError = '15(v)';
        }
        //===============================================//
        let foundans15_06 = this.validateSingleSelectCheckBox(this.q15_06_Options);
        if(!foundans15_06)
        {
            if(rxError !== '')rxError += ', ' + '15(vi)';
            else rxError = '15(vi)';
        }
        //===============================================//
        let foundans15_07 = this.validateSingleSelectCheckBox(this.q15_07_Options);
        if(!foundans15_07)
        {
            if(rxError !== '')rxError += ', ' + '15(vii)';
            else rxError = '15(vii)';
        }
        //===============================================//
        let foundans15_08 = this.validateSingleSelectCheckBox(this.q15_08_Options);
        if(!foundans15_08)
        {
            if(rxError !== '')rxError += ', ' + '15(viii)';
            else rxError = '15(viii)';
        }
        //===============================================//
        let foundans15_09 = this.validateSingleSelectCheckBox(this.q15_09_Options);
        if(!foundans15_09)
        {
            if(rxError !== '')rxError += ', ' + '15(ix)';
            else rxError = '15(ix)';
        }
        //===============================================//
        let foundans16 = this.validateSingleSelectCheckBox(this.q16_Options);
        if(!foundans16)
        {
            if(rxError !== '')rxError += ', ' + 'Q16';
            else rxError = 'Q16';
        }
        //===============================================//
        if(foundans11_01 && foundans11_02 && foundans11_03 &&
            foundans11_04 && foundans11_05 && foundans11_06 &&
            foundans11_07 && foundans11_08 && foundans11_09 &&
            /*foundans11All && */foundans12 && foundans13 && foundans14 /*&& foundans15All*/ && foundans16 &&
            foundans15_01 && foundans15_02 && foundans15_03 &&
            foundans15_04 && foundans15_05 && foundans15_06 &&
            foundans15_07 && foundans15_08 && foundans15_09)
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
        //===============================================//
        // if (this.delayTimeOut11) {
        //     window.clearTimeout(this.delayTimeOut11);
        // }

        if (this.delayTimeOut11_01) {
            window.clearTimeout(this.delayTimeOut11_01);
        }

        if (this.delayTimeOut11_02) {
            window.clearTimeout(this.delayTimeOut11_02);
        }

        if (this.delayTimeOut11_03) {
            window.clearTimeout(this.delayTimeOut11_03);
        }

        if (this.delayTimeOut11_04) {
            window.clearTimeout(this.delayTimeOut11_04);
        }

        if (this.delayTimeOut11_05) {
            window.clearTimeout(this.delayTimeOut11_05);
        }

        if (this.delayTimeOut11_06) {
            window.clearTimeout(this.delayTimeOut11_06);
        }

        if (this.delayTimeOut11_07) {
            window.clearTimeout(this.delayTimeOut11_07);
        }

        if (this.delayTimeOut11_08) {
            window.clearTimeout(this.delayTimeOut11_08);
        }

        if (this.delayTimeOut11_09) {
            window.clearTimeout(this.delayTimeOut11_09);
        }
        //===============================================//
        if (this.delayTimeOut12) {
            window.clearTimeout(this.delayTimeOut12);
        }

        if (this.delayTimeOut13) {
            window.clearTimeout(this.delayTimeOut13);
        }

        if (this.delayTimeOut14) {
            window.clearTimeout(this.delayTimeOut14);
        }
        //===============================================//
        // if (this.delayTimeOut15) {
        //     window.clearTimeout(this.delayTimeOut15);
        // }

        if (this.delayTimeOut15_01) {
            window.clearTimeout(this.delayTimeOut15_01);
        }

        if (this.delayTimeOut15_02) {
            window.clearTimeout(this.delayTimeOut15_02);
        }

        if (this.delayTimeOut15_03) {
            window.clearTimeout(this.delayTimeOut15_03);
        }

        if (this.delayTimeOut15_04) {
            window.clearTimeout(this.delayTimeOut15_04);
        }

        if (this.delayTimeOut15_05) {
            window.clearTimeout(this.delayTimeOut15_05);
        }

        if (this.delayTimeOut15_06) {
            window.clearTimeout(this.delayTimeOut15_06);
        }

        if (this.delayTimeOut15_07) {
            window.clearTimeout(this.delayTimeOut15_07);
        }

        if (this.delayTimeOut15_08) {
            window.clearTimeout(this.delayTimeOut15_08);
        }

        if (this.delayTimeOut15_09) {
            window.clearTimeout(this.delayTimeOut15_09);
        }
        //===============================================//
        if (this.delayTimeOut16) {
            window.clearTimeout(this.delayTimeOut16);
        }
    }

    saveAll(){
        this.restrictIndividualUpdate();
        //===================================================================================//
        /*
        const q11FinalAnswer = this.q11GetFinalAnswer();
        let q11Answer = {};
        if(q11FinalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question11, Please return : saveAll()');
            q11Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question11, Please proceed : saveAll()');
            q11Answer.answer1 = q11FinalAnswer[0];
            q11Answer.answer2 = q11FinalAnswer[1];
            q11Answer.answer3 = q11FinalAnswer[2];
            q11Answer.answer4 = q11FinalAnswer[3];
            q11Answer.answer5 = q11FinalAnswer[4];
            q11Answer.answer6 = q11FinalAnswer[5];
            q11Answer.answer7 = q11FinalAnswer[6];
			q11Answer.answer8 = q11FinalAnswer[7];
            q11Answer.answer9 = q11FinalAnswer[8];
        }*/
        //===================================================================================//
        //'NUR' === No Update Required
        const q11_xxAnswer = {
            answer1 : 'NUR',
            answer2 : 'NUR',
            answer3 : 'NUR',
            answer4 : 'NUR',
            answer5 : 'NUR',
            answer6 : 'NUR',
            answer7 : 'NUR',
            answer8 : 'NUR',
            answer9 : 'NUR'
        };
        let q11UpdateRequired = false;

        const q11_01FinalAnswer = this.qXXGetFinalAnswer(this.q11_01_Options,this.initAnswer11_01);
        if(q11_01FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question11_01, Please proceed : saveAll()');
            q11_xxAnswer.answer1 = q11_01FinalAnswer;
            q11UpdateRequired = true;
        }

        const q11_02FinalAnswer = this.qXXGetFinalAnswer(this.q11_02_Options,this.initAnswer11_02);
        if(q11_02FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question11_02, Please proceed : saveAll()');
            q11_xxAnswer.answer2 = q11_02FinalAnswer;
            q11UpdateRequired = true;
        }

        const q11_03FinalAnswer = this.qXXGetFinalAnswer(this.q11_03_Options,this.initAnswer11_03);
        if(q11_03FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question11_03, Please proceed : saveAll()');
            q11_xxAnswer.answer3 = q11_03FinalAnswer;
            q11UpdateRequired = true;
        }

        const q11_04FinalAnswer = this.qXXGetFinalAnswer(this.q11_04_Options,this.initAnswer11_04);
        if(q11_04FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question11_04, Please proceed : saveAll()');
            q11_xxAnswer.answer4 = q11_04FinalAnswer;
            q11UpdateRequired = true;
        }

        const q11_05FinalAnswer = this.qXXGetFinalAnswer(this.q11_05_Options,this.initAnswer11_05);
        if(q11_05FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question11_05, Please proceed : saveAll()');
            q11_xxAnswer.answer5 = q11_05FinalAnswer;
            q11UpdateRequired = true;
        }

        const q11_06FinalAnswer = this.qXXGetFinalAnswer(this.q11_06_Options,this.initAnswer11_06);
        if(q11_06FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question11_06, Please proceed : saveAll()');
            q11_xxAnswer.answer6 = q11_06FinalAnswer;
            q11UpdateRequired = true;
        }

        const q11_07FinalAnswer = this.qXXGetFinalAnswer(this.q11_07_Options,this.initAnswer11_07);
        if(q11_07FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question11_07, Please proceed : saveAll()');
            q11_xxAnswer.answer7 = q11_07FinalAnswer;
            q11UpdateRequired = true;
        }

        const q11_08FinalAnswer = this.qXXGetFinalAnswer(this.q11_08_Options,this.initAnswer11_08);
        if(q11_08FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question11_08, Please proceed : saveAll()');
            q11_xxAnswer.answer8 = q11_08FinalAnswer;
            q11UpdateRequired = true;
        }

        const q11_09FinalAnswer = this.qXXGetFinalAnswer(this.q11_09_Options,this.initAnswer11_09);
        if(q11_09FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question11_09, Please proceed : saveAll()');
            q11_xxAnswer.answer9 = q11_09FinalAnswer;
            q11UpdateRequired = true;
        }
        //===================================================================================//
        const q12FinalAnswer = this.q12GetFinalAnswer();
        let q12Answer = {};
        if(q12FinalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question12, Please return : saveAll()');
            q12Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question12, Please proceed : saveAll()');
            q12Answer.answer_2_1 = q12FinalAnswer[0];
            q12Answer.answer_2_2 = q12FinalAnswer[1];
            q12Answer.answer_2_3 = q12FinalAnswer[2];
            q12Answer.answer_2_4 = q12FinalAnswer[3];
        }
        //===================================================================================//
        const q13FinalAnswer = this.qXXGetFinalAnswer(this.q13_Options,this.initAnswer13);
        let q13Answer = {};
        if(q13FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question13, Please return : saveAll()');
            q13Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question13, Please proceed : saveAll()');
            q13Answer.answer = q13FinalAnswer;
        }
        //===================================================================================//
        const q14FinalAnswer = this.qXXGetFinalAnswer(this.q14_Options,this.initAnswer14);
        let q14Answer = {};
        if(q14FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question14, Please return : saveAll()');
            q14Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question14, Please proceed : saveAll()');
            q14Answer.answer = q14FinalAnswer;
        }
        //===================================================================================//
        /*
        const q15FinalAnswer = this.q15GetFinalAnswer();
        let q15Answer = {};
        if(q15FinalAnswer[0] === 'return')
        {
            // console.log('No change in answer of Question15, Please return : saveAll()');
            q15Answer = null;
        }
        else
        {
            // console.log('Change in answer of Question15, Please proceed : saveAll()');
            q15Answer.answer1 = q15FinalAnswer[0];
            q15Answer.answer2 = q15FinalAnswer[1];
            q15Answer.answer3 = q15FinalAnswer[2];
            q15Answer.answer4 = q15FinalAnswer[3];
            q15Answer.answer5 = q15FinalAnswer[4];
            q15Answer.answer6 = q15FinalAnswer[5];
            q15Answer.answer7 = q15FinalAnswer[6];
			q15Answer.answer8 = q15FinalAnswer[7];
            q15Answer.answer9 = q15FinalAnswer[8];
        }*/
        //===================================================================================//
        //'NUR' === No Update Required
        const q15_xxAnswer = {
            answer1 : 'NUR',
            answer2 : 'NUR',
            answer3 : 'NUR',
            answer4 : 'NUR',
            answer5 : 'NUR',
            answer6 : 'NUR',
            answer7 : 'NUR',
            answer8 : 'NUR',
            answer9 : 'NUR'
        };
        let q15UpdateRequired = false;

        const q15_01FinalAnswer = this.qXXGetFinalAnswer(this.q15_01_Options,this.initAnswer15_01);
        if(q15_01FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question15_01, Please proceed : saveAll()');
            q15_xxAnswer.answer1 = q15_01FinalAnswer;
            q15UpdateRequired = true;
        }

        const q15_02FinalAnswer = this.qXXGetFinalAnswer(this.q15_02_Options,this.initAnswer15_02);
        if(q15_02FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question15_02, Please proceed : saveAll()');
            q15_xxAnswer.answer2 = q15_02FinalAnswer;
            q15UpdateRequired = true;
        }

        const q15_03FinalAnswer = this.qXXGetFinalAnswer(this.q15_03_Options,this.initAnswer15_03);
        if(q15_03FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question15_03, Please proceed : saveAll()');
            q15_xxAnswer.answer3 = q15_03FinalAnswer;
            q15UpdateRequired = true;
        }

        const q15_04FinalAnswer = this.qXXGetFinalAnswer(this.q15_04_Options,this.initAnswer15_04);
        if(q15_04FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question15_04, Please proceed : saveAll()');
            q15_xxAnswer.answer4 = q15_04FinalAnswer;
            q15UpdateRequired = true;
        }

        const q15_05FinalAnswer = this.qXXGetFinalAnswer(this.q15_05_Options,this.initAnswer15_05);
        if(q15_05FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question15_05, Please proceed : saveAll()');
            q15_xxAnswer.answer5 = q15_05FinalAnswer;
            q15UpdateRequired = true;
        }

        const q15_06FinalAnswer = this.qXXGetFinalAnswer(this.q15_06_Options,this.initAnswer15_06);
        if(q15_06FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question15_06, Please proceed : saveAll()');
            q15_xxAnswer.answer6 = q15_06FinalAnswer;
            q15UpdateRequired = true;
        }

        const q15_07FinalAnswer = this.qXXGetFinalAnswer(this.q15_07_Options,this.initAnswer15_07);
        if(q15_07FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question15_07, Please proceed : saveAll()');
            q15_xxAnswer.answer7 = q15_07FinalAnswer;
            q15UpdateRequired = true;
        }

        const q15_08FinalAnswer = this.qXXGetFinalAnswer(this.q15_08_Options,this.initAnswer15_08);
        if(q15_08FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question15_08, Please proceed : saveAll()');
            q15_xxAnswer.answer8 = q15_08FinalAnswer;
            q15UpdateRequired = true;
        }

        const q15_09FinalAnswer = this.qXXGetFinalAnswer(this.q15_09_Options,this.initAnswer15_09);
        if(q15_09FinalAnswer !== 'return')
        {
            // console.log('Change in answer of Question15_09, Please proceed : saveAll()');
            q15_xxAnswer.answer9 = q15_09FinalAnswer;
            q15UpdateRequired = true;
        }
        //===================================================================================//
        const q16FinalAnswer = this.qXXGetFinalAnswer(this.q16_Options,this.initAnswer16);
        let q16Answer = {};
        if(q16FinalAnswer === 'return')
        {
            // console.log('No change in answer of Question16, Please return : saveAll()');
            q16Answer = null;
        }
        else 
        {
            // console.log('Change in answer of Question16, Please proceed : saveAll()');
            q16Answer.answer = q16FinalAnswer;
        }
        //===================================================================================//
        if(/*q11Answer !== null || */q12Answer !== null || q13Answer !== null 
            || q14Answer !== null /*|| q15Answer !== null*/ || q16Answer !== null 
            || q15UpdateRequired || q11UpdateRequired)
        {
            this.isLoading = true;   //Turn ON the spinner

            const allQA = {/*
                q11 : q11Answer,*/ 
                q11 : q11_xxAnswer, 
                q12 : q12Answer,
                q13 : q13Answer,
                q14 : q14Answer,/*
                q15 : q15Answer,*/
                q15 : q15_xxAnswer,
                q16 : q16Answer
            };

            //console.log('q15_xxAnswer : ' + JSON.stringify(q15_xxAnswer));

            saveAllQA({
                recordId : this.csRecordId,
                studentId : this.rxStudentId,
                barCode : this.studentBarcode,
                ans : allQA,
                lng : this.lng,
                typ : (this.typ == 'v2' || this.typ == 'Form V2') ? 'Form V2' : 'Form V1',
                batchId : this.bid
            }).then(result => {
                //console.log('result : ' + JSON.stringify(result));
                //===========================================================//
                this.csRecordId = result;
                this.reInitializeRecordCS();
                this.isLoading = false;   //Turn OFF the spinner
                //===========================================================//
                /*
                const event = new ShowToastEvent({
                    title: 'Career Skills',
                    message: 'All answers upsert successful',
                    variant: 'success'
                });                
                this.dispatchEvent(event);
                */
                //this.fpNavigateToInternalPage(); 
                this.submit();
            }).catch(error => {
                this.isLoading = false;   //Turn OFF the spinner
                // let rxError = 'Error while upserting all answers';

                let rxError;
                if(isEnglish){
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
                    // title : 'Career Skills',
                    title : this.errorTitle,
                    message : rxError,
                    variant : 'error'
                });
                this.dispatchEvent(event);
            });
        }else{
            this.fpNavigateToInternalPage(); 
        }
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
                        // title : 'Career Skills',
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
        if(this.csRecordId == null)
        {
            confirm('Please save the record before submit');
            return;
        }

        this.isLoading = true;   //Turn ON the spinner
        submitAndCalculate({
            recordId : this.csRecordId
        }).then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            if(result === 'success')
            {
                this.reInitializeRecordCS();
            }           
            this.isLoading = false;   //Turn OFF the spinner
            //===========================================================//
            const event = new ShowToastEvent({
                title: this.successTitle,
                message: this.successMsg,
                variant: 'success'
            });                
            this.dispatchEvent(event);
            this.cpNavigateToInternalPage();
        }).catch(error => {
            this.isLoading = false;   //Turn OFF the spinner
            // let rxError = 'Error while submitting the record';

            let rxError ;
            if(isEnglish){
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
                // title : 'Career Skills',
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
        let eventButton = event.target.dataset.name;

        if(eventButton === 'submitButton')
        {
            do{
                let returnStr = this.allQuestionsAttempted();
                if(returnStr != 'All available')
                {
                    const event = new ShowToastEvent({
                        // title : 'Career Skills',
                        title : this.errorTitle,
                        message : returnStr,
                        variant : 'error'
                    });
                    this.dispatchEvent(event);
                    break;
                }
                this.saveAll();
                //this.submit(); 
                // delay of 1second is added so that record changes done by "this.saveAll();" appears in "this.submit();"
                setTimeout(() => {
                    this.submit();
                }, 1000);     
            }while(false);
        }

        this.flag = 'handleSubmitButton';
        console.log('this.flag : ' + this.flag);
    }

    handleContinueButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'continueButton')
        {
            /*if(this.freeze)
            {
                this.fpNavigateToInternalPage();
            }
            else
            {*/
                do{
                    let returnStr = this.allQuestionsAttempted();
                    if(returnStr !== 'All available')
                    {
                        const event = new ShowToastEvent({
                            // title : 'Career Planning',
                            title : this.errorTitle,
                            message : returnStr,
                            variant : 'error'
                        });
                        this.dispatchEvent(event);
                        break;
                    }
                    //this.saveAll(); 
                    getEndlineRecord({
                        studentId : this.rxStudentId,
                        grade : this.grd,
                        type : 'CS',
                        batchId : this.bid,
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
                            this.cpNavigateToInternalPage();
                        }else{
                            this.saveAll(); 
                        }
                    }).catch(error => {
                        console.log(error);
                        
                        this.showLoading = false;
                        let rxError;
                        let errorTitle;
                        if(this.isEnglish){
                            errorTitle = 'Endline Career Skills';
                            rxError = 'Error while receiving student records';
                        }else{
                            errorTitle = 'एंडलाइन कैरियर कौशल';
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
                    // this.fpNavigateToInternalPage();                
                }while(false);
            /*}*/
        }

        this.flag = 'handleContinueButton'; 
        console.log('this.flag : ' + this.flag);
    }

    fpNavigateToInternalPage() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Endline_Future_Planning_V2__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd),
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid),
                studentId : encodeURI(this.rxStudentId),
                studentName : encodeURI(this.studentName),
                cdm1Id : encodeURI(this.cdm1Id),
                cdm2Id : encodeURI(this.cdm2Id),
                cpId : encodeURI(this.cpId),
                csId : encodeURI(this.csRecordId),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)
            }
        });
    }

    handleBackButton(event){
        let eventButton = event.target.dataset.name;

        if(eventButton === 'backButton')
        {
            this.cpNavigateToInternalPage();
        }

        this.flag = 'handleBackButton';
        console.log('this.flag : ' + this.flag);
    }

    cpNavigateToInternalPage() {
        // Use the basePath from the Summer '20 module to construct the URL
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'endline_cs_assesment_V2__c'
            },
            state: {
                fem : encodeURI(this.fem),
                sch : encodeURI(this.sch),
                grd : encodeURI(this.grd),
                bid : encodeURI(this.bid),
                acid : encodeURI(this.acid),
                studentId : encodeURI(this.rxStudentId),
                studentName : encodeURI(this.studentName),
                cdm1Id : encodeURI(this.cdm1Id),
                cdm2Id : encodeURI(this.cdm2Id),
                cpId : encodeURI(this.cpId),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)
            }
        }); 
    }
}