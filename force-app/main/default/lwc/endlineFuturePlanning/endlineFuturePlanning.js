import {LightningElement, api, wire, track} from 'lwc';
//import {getRecord} from 'lightning/uiRecordApi';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import autoSaveData from '@salesforce/apex/EndlineFuturePlanningController.autoSaveData';
import getRecordApt from '@salesforce/apex/EndlineFuturePlanningController.getRecordApt';

export default class EndlineFuturePlanning extends NavigationMixin(LightningElement) {
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
    showLoading = true;
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
    studentName='';

    getRecordAptFun(){
        debugger;
        console.log('$$$ this.studentId: ', this.studentId);
        getRecordApt({
            studentId : this.studentId
        }).then(result => {
            if(result){
                console.log('$$$ Endline Future Plannning getRecordApt: ', result);
                this.showForm = true;
                this.showLoading = false;
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
                }, 1000);
            }
        }).catch(error => {
            this.showForm = true;
            this.showLoading = false;
            console.log('error123=', error);
            this.showToastPopMessage(error,'error')

        });
    }
    connectedCallback(){
        if(this.studentId != null){
            this.getRecordAptFun();
            this.delayTimeOut05 = setTimeout(() => {
                this.showLoading=false;
            }, 1000);
        }
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
        clearTimeout(this.timeoutId);
        this.timeoutId = setTimeout(this.autoSaveData.bind(this,false), 5000); 
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
            fp18_9:this.que18_8Value,
            fp18_10:this.que18_10Value,
            fp18_11:this.que18_11Value,
            fp19:this.que19Value,
            fp20:this.que20Value,
            fp21:this.que21Value,
            fp22:this.que22Value,
            saveFlag : this.saveFlag,
            grade : this.selectedGrade
        }).then(result => {
            console.log('ddd')
           console.log('res = ',result);
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
                name: 'Career_Skills_Endline__c'
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
            title: 'Endline Future Planning Data',
            message:messageParam,
            variant: variantParam,
        });
        this.dispatchEvent(evt);
    }
    get que22Options(){
        return [
            {label:'Yes',value:'A'},
            {label:'No',value:'B'},
            {label:'Not Sure',value:'C'}, 
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
    get que21Options(){
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
    }
    get que20Options(){
        return [
            {label:'Not required (when you start work you will automatically learn)',value:'A'},
            {label:'A few times a year',value:'B'},
            {label:'About once a month',value:'C'},
            {label:'Many times a month',value:'D'},
            {label:'Many times a week/Ongoing basis',value:'E'},
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
    get que19Options(){
        return [
            {label:'I do not know/Not sure',value:'A'},
            {label:'It is a homework/assignment for school/college',value:'B'},
            {label:'I could get information about my career',value:'C'},
            {label:'I could get jobs/internships opportunities',value:'D'},
            {label:'Other',value:'E'},
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
    get que18Options(){
        return [
            {label:'Yes',value:'A'},
            {label:'No',value:'B'},
            {label:'I don’t know/Not sure',value:'C'},
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
    }
    get que17Options() {
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
    }

    SubmitBtnHandler(){
        if(this.que17Value && this.que18_1Value && this.que18_2Value && this.que18_3Value && this.que18_4Value && this.que18_5Value && this.que18_6Value && this.que18_7Value && this.que18_8Value && this.que18_9Value && this.que18_10Value && this.que18_11Value && this.que19Value && this.que20Value && this.que21Value && this.que22Value){
            let pageReference = {
                type: 'comm__namedPage',
                attributes: {
                    name: 'Endline_Feedback__c'
                },
                state:{
                    fem : encodeURI(this.logedInFacilitatorEmail),
                    sch : encodeURI(this.seletedSchoolName),
                    grd : encodeURI(this.selectedGrade), 
                    bid : encodeURI(this.selectedBatchId),
                    acid : encodeURI(this.selectedSchoolAccountId),
                    studentId : encodeURI(this.studentId),
                    cdm1Id :  encodeURI(this.cdm1Id),
                    cdm2Id :  encodeURI(this.cdm2Id),
                    cpId :  encodeURI(this.cpId),
                    csId :  encodeURI(this.csId)
                }
            };
            this[NavigationMixin.Navigate](pageReference);
        }else{
            this.showToastPopMessage('Please fill all the mandatory(*) fields','error');
        }
    }
}