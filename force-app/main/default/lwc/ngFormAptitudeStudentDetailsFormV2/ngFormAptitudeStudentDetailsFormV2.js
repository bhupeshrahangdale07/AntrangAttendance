import { LightningElement,track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import searchStudentRecords from '@salesforce/apex/ApptitudeController.searchStudentRecords';
import getBatchCodeName from '@salesforce/apex/BaselineController.getBatchCodeName';
import saveData from '@salesforce/apex/ApptitudeController.saveData';
import getRecordApt from '@salesforce/apex/ApptitudeController.getRecordApt';
import getStudentName from '@salesforce/apex/ApptitudeController.getStudentName';
import getApptitudeRecord from '@salesforce/apex/ApptitudeController.getApptitudeRecord';

export default class NgFormAptitudeStudentDetailsFormV2 extends NavigationMixin(LightningElement) {
    title = '';
    errorTitle = '';
    successTitle = '';
    successMsg = '';
    showForm = true;
    selectedBatchId = '';
    selectedGrade = '';
    logedInFacilitatorEmail = '';
    seletedSchoolName = '';
    selectedSchoolAccountId = '';
    selectedBatchCode='';
    studentSearchComponentLabel = 'Type the first 4 letters of the student name and wait for the drop down to select the student'
    studentName = '';
    @track showStudentList = false;
    @track studentDisplay = [];
    @track studentSearchResult = '';
    studentSearchText = '';
    submittedStudentMapKeys = [];
    saveFlag = false;
    selectedBatchNumber='';
    studentName='';

    aptitude1Value='';
    aptitude2Value='';
    aptitude3Value='';
    showLoading = true;
    isShowModal=false;
    submitBtnHandler(event){
        //TODO: Show Toast Message
        console.log(this.aptitude1Value);
        if(this.aptitude1Value === '' || this.aptitude2Value == '' || this.aptitude3Value == '' || this.aptitude1Value === undefined || this.aptitude2Value === undefined || this.aptitude3Value === undefined){
            this.showToastPopMessage(this.errorTitle,'Please fill all the mandatory(*) fields','error');
        }else{
            this.saveFlag = true;
            //this.saveData();
            getApptitudeRecord({
                studentId : this.rxStudentId,
                grade : this.selectedGrade,
                batchId : this.selectedBatchId,
            })
            .then(result => {
                this.showLoading = false;
                if(result === 'found'){
                    if(this.isEnglish){
                        const event = new ShowToastEvent({
                            title :'Error!',
                            message : 'Student data already submitted',
                            variant : 'error'
                        });
                        this.dispatchEvent(event);
                        //this.showToastPopMessage('Error!','Student data already submitted','error')
                    }else{
                        const event = new ShowToastEvent({
                            title :'गलती!',
                            message : 'छात्र का डेटा पहले ही जमा किया जा चुका है',
                            variant : 'error'
                        });
                        this.dispatchEvent(event);
                        //this.showToastPopMessage('गलती!','छात्र का डेटा पहले ही जमा किया जा चुका है','success');
                    }
                    this.backBtnNavigationHelper();
                }else{
                    if(this.selectedBatchId && this.selectedGrade){
                        this.saveData();
                    }
                }
            }).catch(error => {
                console.log(error);
                
                this.showLoading = false;
                let rxError;
                if(this.isEnglish){
                    this.errorTitle = 'योग्यता आंकड़ा';
                    this.rxError = 'Error while receiving student records';
                }else{
                    this.errorTitle = 'योग्यता आंकड़ा';
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
            
        } 
    }
    connectedCallback(){
        this.showLoading = false;
    }
    /*onclickBack(event){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'Apptitude_Details__c'
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
    renderedCallback(){
        if(this.studentDisplay.length > 0)this.showStudentList = true;
        else
        {
            this.showStudentList = false;
        }

        this.flag = 'renderedCallback';
    }*/
    getRecordAptFun(){
        console.log('this.rxStudentId =',this.rxStudentId);
        getRecordApt({
            studentId : this.rxStudentId
        }).then(result => {
            console.log('result = '+result);
            if(result){
                this.showForm = true;
                this.showLoading = false;
                this.aptitude1Value = result.Aptitude_1__c;
                this.aptitude2Value = result.Aptitude_2__c;
                this.aptitude3Value = result.Aptitude_3__c;
                this.studentName = result.Student__r.Name;
                setTimeout(() => {
                    this.checkHandler('lightning-input.Aptitude1',this.aptitude1Value);
                    this.checkHandler('lightning-input.Aptitude2',this.aptitude2Value);
                    this.checkHandler('lightning-input.Aptitude3',this.aptitude3Value);
                }, 1000);
            }
        }).catch(error => {
            this.showForm = true;
            this.showLoading = false;
            console.log('error123=', error);
            //this.showToastPopMessage('Error!',error,'error')

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
    aptitudeHandler(event){
        let aptitudeName = event.target.name;
        if(aptitudeName === 'Aptitude1'){
            let isChecked = this.checkHandler('lightning-input.Aptitude1',event.target.dataset.value);
            if(isChecked)this.aptitude1Value = event.target.dataset.value;
        }
        else if(aptitudeName === 'Aptitude2'){
            let isChecked = this.checkHandler('lightning-input.Aptitude2',event.target.dataset.value);
            if(isChecked)this.aptitude2Value = event.target.dataset.value;
        }
        else if(aptitudeName === 'Aptitude3'){
            let isChecked = this.checkHandler('lightning-input.Aptitude3',event.target.dataset.value);
            if(isChecked)this.aptitude3Value = event.target.dataset.value;
        }
        console.log('this.aptitude1Value',this.aptitude1Value);
        //clearTimeout(this.timeoutId);
        //this.timeoutId = setTimeout(this.saveData.bind(this,false), 5000); 
    }
    saveData(){
        var formType = '';
        if(this.typ == 'v2'){
            formType = 'Form V2';
        }else if(this.typ == 'v1'){
            formType = 'Form V1';
        }else{
            formType = '';
        }

        saveData({
            studentId : this.rxStudentId,
            apt1 : this.aptitude1Value,
            apt2 : this.aptitude2Value,
            apt3 : this.aptitude3Value,
            saveFlag : this.saveFlag,
            grade : this.selectedGrade,
            typ : formType, 
            lng : this.lng
        }).then(result => {
           console.log('res = ',result);
           this.showToastPopMessage(this.successTitle,this.successMsg,'success');
            //this.backBtnNavigationHelper();
            setTimeout(() => {
                this.backBtnNavigationHelper();
            }, 500);
        }).catch(error => {
            console.log('error=', error);
            this.showToastPopMessage(this.errorTitle,error,'error')
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
            this.typ = decodeURI(currentPageReference.state.typ);
            this.lng = decodeURI(currentPageReference.state.lng);
            this.isEnglish = (this.lng == 'English') ? true : false;
            this.rxBatch = this.selectedBatchId;
            this.rxGrade = this.selectedGrade;
            this.rxStudentId = decodeURI(currentPageReference.state.studentId);
            this.getRecordAptFun();
            if(this.selectedBatchId){
                getBatchCodeName({
                    batchId : this.selectedBatchId
                }).then(result => {
                    this.selectedBatchCode = result.Name;
                    this.selectedBatchNumber = result.Batch_Number__c;
                    // this.schoolName = result.School_Name__r.Name;        
                }).catch(error => {
                    console.log('error 123 = ', error);
                    this.showToastPopMessage(this.errorTitle,error,'error')
                });
            }
            if(this.rxStudentId){
                getStudentName({
                    stuId : this.rxStudentId
                }).then(result => {
                    if(result){
                        this.studentName = result.Name;
                    }
                }).catch(error => {
                    this.showLoading = false;
                    console.log('getStudentName error: ', error);
                });
            }
            if(this.isEnglish){
                this.title = 'Aptitude';
                this.errorTitle = 'Error';
                this.successMsg ='Aptitude - Student data has been saved';
                this.successTitle = 'Success'
            }else{
                this.title = 'योग्यता';
                this.errorTitle = 'गलती!';
                this.successMsg ='छात्र डेटा सहेजा गया है';
                this.successTitle = 'Success'
            }
       }
    }
    handleInputChangeStudent(event) {
        this.studentSearchText = event.detail.value;
        if (this.delayTimeOut05) {
            window.clearTimeout(this.delayTimeOut05);
        }

        this.delayTimeOut05 = setTimeout(() => {
            this.searchStudent();
        }, 1000);

        this.flag = 'handleInputChangeStudent';

    }

    searchStudent(){
        do{
            if(this.selectedBatchCode === undefined)
            {
                this.showToastPopMessage(this.errorTitle,'A batch is required to search for student','error');
                break;
            }

            if(!this.studentSearchText)
            {
                //this.studentSearchResult = 'Please enter text here';
                this.studentDisplay = [];
                this.submittedStudentMapKeys = [];
                break;
            }
            else if(this.studentSearchText.length < 2) 
            {
                this.studentSearchResult = 'Enter atleast 4 characters of Student Name';
                this.studentDisplay = [];
                this.submittedStudentMapKeys = [];
                break;
            }

            searchStudentRecords({
                searchText : this.studentSearchText,
                batchId : this.selectedBatchId,
                grade : this.selectedGrade
            }).then(result => {
                const responseWrapper = JSON.parse(JSON.stringify(result));
                if(responseWrapper.gradeStudentList !== undefined)
                {
                    this.studentSearchResult = 'Students(' + responseWrapper.batchTotalStudents + ')';
                    this.studentDisplay = responseWrapper.gradeStudentList;
                }

                if(responseWrapper.submittedStudentMap !== undefined)
                {
                    this.submittedStudentMapKeys = Object.keys(responseWrapper.submittedStudentMap);
                }
                this.flag = 'searchStudent';
    
            }).catch(error => {
                let rxError = 'Error while searching student';
    
                if (Array.isArray(error.body)) {
                    rxError = error.body.map(e => e.message).join(', ');
                } else if (typeof error.body.message === 'string') {
                    rxError = error.body.message;
                }
                //console.log('Print error : ' + rxError);
                this.showToastPopMessage(this.errorTitle,rxError,'error')
              
            });

        }while(false);
    }

    /*handleClick(event){
        this.showLoading = true;
        let selectedStudent = event.currentTarget.dataset.id;
        do{
            if(this.submittedStudentMapKeys.length > 0 &&
                 this.submittedStudentMapKeys.includes(selectedStudent))
            {
                this.showLoading = false;
                let errorString = ' You have already filled the data for this student. If you think this is a mistake fill the support form';
                this.showToastPopMessage('Error!',errorString,'error');
                break;
            }

            this.rxStudentId = selectedStudent;

            for(let key in this.studentDisplay)
            {
                if(this.studentDisplay[key].Id === this.rxStudentId)
                {
                    this.studentName = this.studentDisplay[key].Name;
                }
            }

            if(this.rxStudentId !== undefined && this.rxStudentId !== null)
            {
                this.getRecordAptFun();
                this.studentPresent = true;
            }
        }while(false);

        this.flag = 'handleClick';
    }*/

    //Button Handler Functionalities :
    backBtnHandler(){
        this.isShowModal=true;
    }
    yesBackBtnHandler(){
        this.backBtnNavigationHelper();
    }
    noBackBtnHandler(){
        this.isShowModal=false;
    }
    

    backBtnNavigationHelper(event){
        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'aptitude_assessment_V2__c'
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
    }

    showToastPopMessage(title,messageParam,variantParam){
        const evt = new ShowToastEvent({
            title: title,
            message:messageParam,
            variant: variantParam,
        });
        this.dispatchEvent(evt);
    }

    get aptitudeOptions() {
        return [
            { label: 'Spatial', value: 'Spatial' },
            { label: 'Numerical', value: 'Numerical' },
            { label: 'Mechanical', value: 'Mechanical' },
            { label: 'Abstract', value: 'Abstract' },
            { label: 'Verbal', value: 'Verbal' },
            { label: 'Creative', value: 'Creative' },
            { label: 'Multiple answers selected', value: '*' },
            { label: 'No Answer', value: 'NoAnswer' }
        ];
        // return [
        //     { label: 'Spatial Ability (Shapes)', value: 'Spatial' },
        //     { label: 'Numerical Ability (Numbers)', value: 'Numerical' },
        //     { label: 'Mechanical Ability (Machines)', value: 'Mechanical' },
        //     { label: 'Abstract Ability (Patterns)', value: 'Abstract' },
        //     { label: 'Verbal Ability (Words)', value: 'Verbal' },
        //     { label: 'Creative Ability (Designs)', value: 'Creative' },
        //     { label: 'Multiple answers selected', value: '*' },
        //     { label: 'No Answer', value: 'NoAnswer' }
        // ];
    }
}