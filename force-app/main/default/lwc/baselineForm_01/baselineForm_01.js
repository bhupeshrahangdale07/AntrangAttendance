import {LightningElement, api, wire, track} from 'lwc';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import createContact from '@salesforce/apex/BaselineController.createContact';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';

export default class BaselineForm_01 extends NavigationMixin(LightningElement) {
    firstName = '';
    lastName = '';
    yrOfBirth = '';
    currStudyIn = '';
    gender = '';
    whatCurrStuIn = '';
    wuppNo = '';
    alterWuppNo = '';
    cuurrValue;
    batchNumber;
    showLoading = true;
    @api grade = null;
    @api batchCode = null;
    @api batchId = null;
    @api schoolName = null;
    @api schoolId = null;
    @api facilatorEmail = null;
    @api acid = null;
    //@api schoolId = null;
    @track isShowModal = false;
    yearOfBirth= [];
    antarangImage = logo_01;
    
    get genderOptions(){
        return [
            { label: 'Male', value: 'Male' },
            { label: 'Female', value: 'Female' },
            { label: 'Transgender', value: 'Transgender' },
            { label: 'Other', value: 'Other' }        ];
    }
    get whatCurrStuInOptions(){
        return [
            { label: 'Class 11/12: Arts', value: 'Class 11/12: Arts' },
            { label: 'Class 11/12: Science', value: 'Class 11/12: Science' },
            { label: 'Class 11/12: Commerce', value: 'Class 11/12: Commerce' },
            { label: 'Diploma', value: 'Diploma' },
            { label: 'Apprenticeship', value: 'Apprenticeship' },
            { label: 'Vocational Certificate Course', value: 'Vocational Certificate Course' },
            { label: 'Other', value: 'Other' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'No' }
        ];
    }
    get currStuInOptions(){
        return [
            { label: '8TH', value: 'Grade 8' },
            { label: '9TH', value: 'Grade 9' },
            { label: '10TH', value: 'Grade 10' },
            { label: '11TH', value: 'Grade 11' },
            { label: '12TH', value: 'Grade 12' },           
            { label: 'Other', value: 'Other' },
            { label: 'Multiple answers selected', value: '*' }
        ];
    }
    get yrOfBirthOptions(){
        for(var i=1998; i<=2012;i++){
            var r = i.toString();
            this.yearOfBirth.push({label:r,value:r});
        }
        return this.yearOfBirth;
    }
    @wire(CurrentPageReference)
    getCurrentPageRefxerence(currentPageReference) {
        if(currentPageReference) 
        {
            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.grade = decodeURI(rxCurrentPageReference.state.grd);
            this.batchId = decodeURI(rxCurrentPageReference.state.bid);
            this.cuurrValue =  decodeURI(this.grade);
            this.schoolId = decodeURI(rxCurrentPageReference.state.sch);
            this.facilatorEmail = decodeURI(rxCurrentPageReference.state.fem);
            this.acid = decodeURI(rxCurrentPageReference.state.acid);
            getBatchCodeName({
                batchId : decodeURI(rxCurrentPageReference.state.bid)
            }).then(result => {
                
                this.batchCode = result.Name;
                console.log('batchCode = ',this.batchCode)
                this.batchNumber = result.Batch_Number__c;
                this.schoolName = result.School_Name__r.Name;
                //this.schoolId = result.School_Name__r.Id;
    
            }).catch(error => {
                console.log('error 123 = ', error);
            });
        }
        
    }
    contactChangeVal(event) {
        if(event.target.label=='First Name:'){
            this.firstName = event.target.value;
        }
        if(event.target.label=='Last Name:'){
            this.lastName = event.target.value;
        }
        if(event.target.label=='What are you currently studying ?'){
            this.whatCurrStuIn = event.target.value;
        }
        if(event.target.label=='WhatsApp Number:'){
            this.wuppNo = event.target.value;
        }
        if(event.target.label=='Alternate WhatsApp Number:'){
            this.alterWuppNo = event.target.value;
        }
    }
    onchangeGender(event){
            this.gender = event.detail.value;
    }
    onchangewhatCurrStuIn(event){
        this.whatCurrStuIn = event.detail.value;
    }
    onchangeCurrStuIn(event){
        this.currStudyIn = event.detail.label;
    }
    onchangeyrOfBirth(event){
        this.yrOfBirth = event.detail.value;
    }
    toastErrorMsg(msg){
        const event = new ShowToastEvent({
            message : msg,
            variant : 'error'
        });
        this.dispatchEvent(event);
    }
    toastSuccessMsg(msg){
        const event = new ShowToastEvent({
            message : msg,
            variant : 'success'
        });
        this.dispatchEvent(event);
    }
    toastWarningMsg(msg){
        const event = new ShowToastEvent({
            message : msg,
            variant : 'warning'
        });
        this.dispatchEvent(event);
    }
    handleView(){
        const errFlag = false;
        var phoneno = /^\d{10}$/;
        this.showLoading = true;
        this.showLoading = false;
        if(this.firstName=='' || this.yrOfBirth=='' || this.gender=='' || this.lastName==''){
            this.toastErrorMsg('Please fill all the mandatory(*) fields');
            errFlag = true;
        }
        if(this.wuppNo!=''){
            if(!this.wuppNo.match(phoneno)){
                this.toastErrorMsg('The WhatsApp Number should be of 10 digits.');
                errFlag = true;
            }
        }
        if(this.alterWuppNo!=''){
            if(!this.alterWuppNo.match(phoneno)){
                this.toastErrorMsg('The Alternate WhatsApp Number should be of 10 digits.');
                errFlag = true;
            }
        }
        if(errFlag == false){
            this.isShowModal = true;
        }
    }
    
    get displayFieldAccGrade(){
        return this.grade == 'Grade 11' || this.grade == 'Grade 12';
    }
    get getCurrStuIn(){
        return this.currStudyIn == '';

    }
    hideModalBox() {  
        this.isShowModal = false;
    }
    handleBackButton(event){
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'StudentDetails__c'
            },
            state: {
                bid : encodeURI(this.batchId),
                grd : encodeURI(this.grade),
                fem :encodeURI(this.facilatorEmail),
                sch :encodeURI(this.schoolId),
                acid :encodeURI(this.acid)
            }
        });
    }
    submitData(event){
        this.hideModalBox();
        this.showLoading = true;
        const finalObj = {
            firstname : this.firstName,
            lastname: this.lastName,
            yrOfBirth: this.yrOfBirth,
            gender: this.gender,
            whatCurrStuIn: this.whatCurrStuIn,
            currStudyIn: this.grade
            //school: this.schoolId,
        }
        if(this.grade == 'Grade 9'){
            finalObj['batchCodeG9']= this.batchId;
            finalObj['wuppNoG9']= this.wuppNo;
            finalObj['AlterWuppNoG9']= this.alterWuppNo;
        }else{
            finalObj['batchCodeG9']= null;
            finalObj['wuppNoG9']= null;
            finalObj['AlterWuppNoG9']= null;
        } 
        if(this.grade == 'Grade 10'){
            finalObj['batchCodeG10']= this.batchId;
            finalObj['wuppNoG10']= this.wuppNo;
            finalObj['AlterWuppNoG10']= this.alterWuppNo;
        }else{
            finalObj['batchCodeG10']= null;
            finalObj['wuppNoG10']= null;
            finalObj['AlterWuppNoG10']= null;
        }  

        if(this.grade == 'Grade 11'){
            finalObj['batchCodeG11']= this.batchId;
            finalObj['wuppNoG11']= this.wuppNo;
            finalObj['AlterWuppNoG11']= this.alterWuppNo;
        }else{
            finalObj['batchCodeG11']= null;
            finalObj['wuppNoG11']= null;
            finalObj['AlterWuppNoG11']= null;
        }

        if(this.grade == 'Grade 12'){
            finalObj['batchCodeG12']= this.batchId;
            finalObj['wuppNoG12']= this.wuppNo;
            finalObj['AlterWuppNoG12']= this.alterWuppNo;
        }else{
            finalObj['batchCodeG12']= null;
            finalObj['wuppNoG12']= null;
            finalObj['AlterWuppNoG12']= null;
        } 
				console.log('garde',this.grade);
				console.log('schoolId',this.schoolId);
        console.log(finalObj);
        createContact({
                contactData : finalObj,
                grade : this.grade,
                schoolId : this.acid,
								batchId : this.batchId
            }).then(result => {
                console.log('result = ', result);
                this.showLoading = false;
                if(result == 'duplicate'){
                    this.toastWarningMsg('Student name already exist. Please check the details')
                }else if(result == 'barcode'){
										this.toastWarningMsg('Error with barcode generation. Check school details from backend.')
								}
								else if(result == 'saved'){
                    this.toastSuccessMsg('Student Data is saved.');
                    this[NavigationMixin.Navigate]({
                        type: 'comm__namedPage',
                        attributes: {
                            name: 'StudentDetails__c'
                        },
                        state: {
                            bid : encodeURI(this.batchId),
                            grd : encodeURI(this.grade),
                            fem :encodeURI(this.facilatorEmail),
                            sch :encodeURI(this.schoolId),
                            acid :encodeURI(this.acid)
                        }
                    });
                }else if(result == 'batchFull'){
                    this.toastWarningMsg('Current batch is full')
                }
                else{
                    this.toastErrorMsg(result);
                }

            }).catch(error => {
                console.log('error = ', error);
                this.showLoading = false;
                this.toastErrorMsg(error.message);
            });
    }
    editData(event){
        this.hideModalBox();
    }
    connectedCallback() {
        this.showLoading = false;
    }
}