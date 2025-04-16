import {LightningElement, api, wire, track} from 'lwc';
import {NavigationMixin} from "lightning/navigation";
import {CurrentPageReference} from 'lightning/navigation';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import logo_01 from "@salesforce/resourceUrl/Antarang_logo_Asset_1";
import createContact from '@salesforce/apex/BaselineController.createContact';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';

export default class BaselineForm_01 extends NavigationMixin(LightningElement) {
    lng;
    typ;
    isEnglish;

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
    

    @track formTitle = 'New Student : Data Entry';
    @track studentDetailConfirmPageHeader = 'Student Details : Confirmation Page';
    @track submitDialogMessage = 'Please click on Submit Student Data to save student details';
    @track schoolNameLabel = 'School Name';
    @track gradeLabel = 'Grade';
    @track batchCodeLabel = 'Batch Code';
    @track selectPlaceholder = 'Select…';
    @track fieldLabels = {
        'firstName' : 'First Name :',
        'lastName' : 'Last Name :',
        'yearOfBirth' : 'Year of Birth :',
        'currentlyStudyingIn' : 'Currently Studying In :',
        'studying' : 'What are you currently studying ?',
        'gender' : 'Gender :',
        'whatsAppNumber' : 'WhatsApp Number :',
        'alternateWhatsAppNumber' : 'Alternate WhatsApp Number :',
    }
    @track validations = {
        'required' : 'Please fill all the mandatory(*) fields',
        'whatsApp' : 'The WhatsApp Number should be of 10 digits.',
        'altWhatsApp' : 'The Alternate WhatsApp Number should be of 10 digits.',
        'batchFull' : 'Current batch is full.',
        'bacodeGenerationError' : 'Error with barcode generation. Check school details from backend.',
        'studentDupe' : 'Student name already exists. Please use "Link student" option or check their details.',

    }

    doTransilation(){
        if(!this.isEnglish){
            this.selectPlaceholder = 'Select…'; //'चुनना…';
            this.formTitle = 'नये छात्र: डाटा एंट्री';
            this.studentDetailConfirmPageHeader = 'छात्र की जानकारी: पुष्टिकरण पृष्ठ';
            this.submitDialogMessage = 'कृपया छात्र की जानकारी सहेजने के लिए सबमिट छात्र डेटा पर क्लिक करें';
            this.schoolNameLabel = 'स्कूल के नाम';
            this.gradeLabel = 'श्रेणी';
            this.batchCodeLabel = 'बैच कोड';
            this.fieldLabels = {
                'firstName' : 'मूल नाम :',
                'lastName' : 'उपनाम :',
                'yearOfBirth' : 'जन्म वर्ष :',
                'currentlyStudyingIn' : 'आप अभी क्या पढ रहे हैं?',
                'studying' : 'आप अभी क्या पढ रहे हैं?',
                'gender' : 'लिंग :',
                'whatsAppNumber' : 'व्हाट्सऐप नंबर :',
                'alternateWhatsAppNumber' : 'वैकल्पिक व्हाट्सऐप नंबर :',
            }
            this.validations = {
                'required' : 'कृपया सभी अनिवार्य(*) फ़ील्ड भरें',
                'whatsApp' : 'व्हाट्सएप नंबर १० अंकों का होना चाहिए।',
                'altWhatsApp' : 'वैकल्पिक व्हाट्सएप नंबर १० अंकों का होना चाहिए।',
                'batchFull' : 'मौजूदा बैच भरा हुआ है',
                'bacodeGenerationError' : 'बारकोड जनरेशन में गलती. बैकएंड से स्कूल की जानकारी जांचें।',
                'studentDupe' : 'छात्र का नाम पहले से मौजूद है. कृपया छात्र की जानकारी जांचें',

            }
        }
    }

    get genderOptions(){

        var gender = [
            { label: 'Male', value: 'Male' },
            { label: 'Female', value: 'Female' },
            { label: 'Transgender', value: 'Transgender' },
            { label: 'Other', value: 'Other' }        ];

            if(!this.isEnglish){
                gender = [
                    { label: 'पुरुष', value: 'Male' },
                    { label: 'महिला', value: 'Female' },
                    { label: 'ट्रांसजेंडर', value: 'Transgender' },
                    { label: 'अन्य', value: 'Other' }        ];
            }
        return gender;
    }
    get whatCurrStuInOptions(){

        var CurrStuInOptions = [
            { label: 'Class 11/12: Arts', value: 'Class 11/12: Arts' },
            { label: 'Class 11/12: Science', value: 'Class 11/12: Science' },
            { label: 'Class 11/12: Commerce', value: 'Class 11/12: Commerce' },
            { label: 'Diploma', value: 'Diploma' },
            { label: 'Apprenticeship', value: 'Apprenticeship' },
            { label: 'Vocational Certificate Course', value: 'Vocational Certificate Course' },
            { label: 'Other', value: 'Other' }
            // ,
            // { label: 'Multiple answers selected', value: '*' },
            // { label: 'No Answer', value: 'No' }
        ];

            if(!this.isEnglish){
                CurrStuInOptions = [
                    { label: 'कक्षा ११/१२: कला', value: 'Class 11/12: Arts' },
                    { label: 'कक्षा ११/१२: विज्ञान', value: 'Class 11/12: Science' },
                    { label: 'कक्षा ११/१२: वाणिज्य', value: 'Class 11/12: Commerce' },
                    { label: 'डिप्लोमा', value: 'Diploma' },
                    { label: 'अप्रेन्टस्शिप ', value: 'Apprenticeship' },
                    { label: 'वोकेशनल सर्टिफिकेट कोर्स', value: 'Vocational Certificate Course' },
                    { label: 'अन्य', value: 'Other' }
                    // ,
                    // { label: 'Multiple answers selected', value: '*' },
                    // { label: 'No Answer', value: 'No' }
                ];
            }
        return CurrStuInOptions;
    }
    get currStuInOptions(){
        var currStuInOption = [
            { label: '8TH', value: 'Grade 8' },
            { label: '9TH', value: 'Grade 9' },
            { label: '10TH', value: 'Grade 10' },
            { label: '11TH', value: 'Grade 11' },
            { label: '12TH', value: 'Grade 12' },           
            { label: 'Other', value: 'Other' }
            // ,
            // { label: 'Multiple answers selected', value: '*' }
        ];

            if(!this.isEnglish){
                currStuInOption =  [
                    { label: '८वीं', value: 'Grade 8' },
                    { label: '९वीं', value: 'Grade 9' },
                    { label: '१०वीं', value: 'Grade 10' },
                    { label: '११वीं', value: 'Grade 11' },
                    { label: '१२वीं', value: 'Grade 12' },           
                    { label: 'अन्य', value: 'Other' }
                    // ,
                    // { label: 'Multiple answers selected', value: '*' }
                ];
            }
        return currStuInOption;
    }
    get yrOfBirthOptions(){
        for(var i=1980; i<=2012;i++){
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

            if(rxCurrentPageReference.state.typ !== undefined)this.typ = decodeURI(rxCurrentPageReference.state.typ);
            if(rxCurrentPageReference.state.lng !== undefined)this.lng = decodeURI(rxCurrentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;

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
        if(event.target.name=='First Name:'){
            this.firstName = event.target.value;
        }
        if(event.target.name=='Last Name:'){
            this.lastName = event.target.value;
        }
        // if(event.target.name=='What are you currently studying ?'){
        if(event.target.name=='whatCurrStuIn'){
            this.whatCurrStuIn = event.target.value;
        }
        if(event.target.name=='WhatsApp Number:'){
            this.wuppNo = event.target.value;
        }
        if(event.target.name=='Alternate WhatsApp Number:'){
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
        this.currStudyIn = event.detail.name;
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
        if(this.firstName.trim()=='' || this.yrOfBirth=='' || this.gender=='' || this.lastName.trim()=='' || (this.whatCurrStuIn == '' && this.isEnableCurrentlyStudying) ){
            this.toastErrorMsg(this.validations.required);
            errFlag = true;
        }
        if(this.wuppNo!=''){
            if(!this.wuppNo.match(phoneno)){
                this.toastErrorMsg(this.validations.whatsApp);
                errFlag = true;
            }
        }
        if(this.alterWuppNo!=''){
            if(!this.alterWuppNo.match(phoneno)){
                this.toastErrorMsg(this.validations.altWhatsApp);
                errFlag = true;
            }
        }
        if(errFlag == false){
            this.isShowModal = true;
        }
    }
    
    get isEnableCurrentlyStudying(){
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
                name: 'StudentDetailsV2__c'
            },
            state: {
                bid : encodeURI(this.batchId),
                grd : encodeURI(this.grade),
                fem :encodeURI(this.facilatorEmail),
                sch :encodeURI(this.schoolId),
                acid :encodeURI(this.acid),
                typ : encodeURI(this.typ),
                lng : encodeURI(this.lng)
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

        finalObj['lng'] = this.lng ? this.lng : '';
        finalObj['typ'] = (this.typ == 'v2' || this.typ == 'Form V2') ?  'Form V2' : '';

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
                    this.toastWarningMsg(this.validations.studentDupe)
                }else if(result == 'barcode'){
                    this.toastWarningMsg(this.validations.bacodeGenerationError)
                }
                else if(result == 'saved'){
                    var msg = '';
                    msg = this.isEnglish ? 'Student Data is saved.' : 'छात्र डेटा सहेजा गया है.';

                    this.toastSuccessMsg(msg);
                    this[NavigationMixin.Navigate]({
                        type: 'comm__namedPage',
                        attributes: {
                            name: 'StudentDetailsV2__c'
                        },
                        state: {
                            bid : encodeURI(this.batchId),
                            grd : encodeURI(this.grade),
                            fem :encodeURI(this.facilatorEmail),
                            sch :encodeURI(this.schoolId),
                            acid :encodeURI(this.acid),
                            typ : encodeURI(this.typ),
                            lng : encodeURI(this.lng)
                        }
                    });
                }else if(result == 'batchFull'){
                    this.toastWarningMsg(this.validations.batchFull)
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
        this.doTransilation();
    }
}