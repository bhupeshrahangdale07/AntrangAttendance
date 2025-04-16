import { LightningElement,wire } from 'lwc';
import GRADE_FIELD from '@salesforce/schema/Batch__c.Grade__c';
import PREFERRED_LANG from '@salesforce/schema/Batch__c.Preferred_Language__c';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import BATCH_OBJECT from '@salesforce/schema/Batch__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveTheChunkFile from '@salesforce/apex/StudentOMRManagerController.saveTheChunkFile';
import processOMRSheet from '@salesforce/apex/StudentOMRManagerController.processOMRSheet';
import batchInfo from '@salesforce/apex/StudentOMRManagerController.getBatchInfo';
import picklistinfo from '@salesforce/apex/StudentOMRManagerController.getpicklists';
import getEamilPicklist from '@salesforce/apex/StudentOMRManagerController.getEamilPicklist';
import noDataInOMRSheet from '@salesforce/apex/StudentOMRManagerController.noDataInOMRSheet';
import { NavigationMixin } from 'lightning/navigation';

const MAX_FILE_SIZE = 4000000;
const CHUNK_SIZE = 1000000;

export default class StudentOMRManager extends NavigationMixin(LightningElement) {
    selectedOMRType = 'Baseline 1';
    selectedAction = '';
    gradeOptions = [];
    preferedLanguage = [];
    selectedSchool = '';
    selectedGrade = '';
    selectedPreLan = '';
    selectedFacilitor = '';
    selectedDonor = '';
    emailId = '';
    showBaseLineOptions = false;
    showFaciDono = false;
    batch = [];
    showbatch = false;
    selectedBatch = '';
    filename = '';
    isUploadLoading = false;
    filesUploaded = [];             //By Kandisa 05/07/2023 : Defination was missing 
    showGrade = false;              //By Kandisa 11/07/2023 : Added variable  
    selectedEmail = '';             //By Kandisa 21/07/2023 : Added variable
    showEmail = true;               //By Kandisa 21/07/2023 : Added variable  
    emailPicklist = [];             //By Kandisa 21/07/2023 : Added variable 
    
    get options() {
        return [
            { label: '-- None --', value: '' },
            { label: 'Baseline 1', value: 'Baseline 1' }/*,
            { label: 'Baseline 2', value: 'Baseline 2' }*/
        ];
    }

    get actionOptions() {
        return [
            { label: '-- None --', value: '' },
            { label: 'Create New Batch', value: 'Insert' },
            { label: 'Update Student of Existing Batch', value: 'Update' },
        ];
    }

    connectedCallback(){
        this.getEamilPicklistValues();          //By Kandisa 21/07/2023 : Added
        picklistinfo()
        .then(result => {
            this.gradeOptions = result.grade;
            this.preferedLanguage = result.lang;
        })
        .catch(error => {
            this.error = error;
            this.contacts = undefined;
        });
    }

    @wire( getObjectInfo, { objectApiName: BATCH_OBJECT } )
    objectInfo;


    @wire( getPicklistValues, { recordTypeId:  '$objectInfo.data.defaultRecordTypeId', fieldApiName: PREFERRED_LANG } )
    wiredData( { error, data } ) {
        if ( data ) {
            var gData = [{
                label: `-- None --`,
                value: ``
            }];
            data.values.forEach(g => {
                gData.push({label: g.label, value: g.value});
            });
            this.preferedLanguage = gData;
        } else if ( error ) {
            console.error( JSON.stringify( error ) );
        }
    }

    @wire( getPicklistValues, { recordTypeId:  '$objectInfo.data.defaultRecordTypeId', fieldApiName: GRADE_FIELD } )
    wiredData( { error, data } ) {
        if ( data ) {
            var gData = [{
                label: `-- None --`,
                value: ``
            }];
            data.values.forEach(g => {
                gData.push({label: g.label, value: g.value});
            });
            this.gradeOptions = gData;
        } else if ( error ) {
            console.error( JSON.stringify( error ) );
        }
    }

    getEamilPicklistValues(){
        getEamilPicklist().then(result => {
            //console.log('result : ' + JSON.stringify(result));
            //===========================================================//
            let arr = [{ label: '-- None --', value: '' }];
            for(let x = 0; x < result.length ; x++)
            {
                let obj = {
                    label : result[x],           
                    value : result[x]
                };
                arr.push(obj);
            }
            this.emailPicklist = arr;
            //===========================================================//
        }).catch(error => {
            let rxError = 'Error while getting email picklist values';

            if (Array.isArray(error.body)) {
                rxError = error.body.map(e => e.message).join(', ');
            } else if (typeof error.body.message === 'string') {
                rxError = error.body.message;
            }
            //console.log('Print error : ' + rxError);

            const event = new ShowToastEvent({
                title : 'OMR-Manager',
                message : rxError,
                variant : 'error'
            });
            this.dispatchEvent(event);
        });
    }

    handleOMRTypeChange(event){
        this.selectedFacilitor = '';
        this.selectedDonor = '';
        this.selectedSchool = '';
        this.selectedAction = '';
        this.selectedGrade = '';
        this.selectedBatch = '';
        this.selectedEmail = '';
        this.selectedOMRType = event.detail.value;
        if(this.selectedOMRType == 'Baseline 1'){
            //this.showBaseLineOptions = true;          //By Kandisa 05/07/2023 : Comment out 
            //By Kandisa 05/07/2023 : Will never enter this if condition
            // if(this.selectedAction == 'Insert'){
            //     this.showFaciDono = true;               
            // }
            this.showGrade = false;                     //By Kandisa 11/07/2023 : Added
            this.showEmail = true;                      //By Kandisa 21/07/2023 : Added
        } 
        else if(this.selectedOMRType == 'Baseline 2'){  //By Kandisa 21/07/2023 : Added
            this.showGrade = true;                      //By Kandisa 21/07/2023 : Added
            this.showEmail = false;                     //By Kandisa 21/07/2023 : Added
        }
        else 
        {
            //this.showBaseLineOptions = false;         //By Kandisa 05/07/2023 : Comment out
            this.showbatch = false;
            this.showFaciDono = false;
            this.showGrade = false;                      //By Kandisa 11/07/2023 : Added
            this.showEmail = false;                     //By Kandisa 21/07/2023 : Added
        }
    }

    //By Kandisa 21/07/2023 : This function added
    handleEmailPicklist(event) {
        this.selectedEmail = event.detail.value;
    }

    //By Kandisa 05/07/2023 : This function will never be called
    handleActionChange(event){
        this.selectedAction = event.detail.value;
        
        if(this.selectedAction == 'Insert'){
            this.showFaciDono = true;
            this.selectedFacilitor = '';
            this.selectedDonor = '';
            this.showbatch = false;
            this.selectedBatch = '';

        } else {
            this.showFaciDono = false;
            this.showbatch = true;
        }
    }

    handleGradeChange(event){
        this.selectedGrade = event.detail.value;
        if(this.selectedSchool != '' && this.selectedGrade != '' /*&& this.selectedAction == 'Update'*/){
            this.callbatchinfo();       //By Kandisa 05/07/2023 : This function will never be called because 'this.selectedSchool' always be blank
        } else {
            this.batch = [];
            this.showbatch = false;
        }
    }
    //By Kandisa 05/07/2023 : Below function will not be called since 'showBaseLineOptions' comment out in function 'handleOMRTypeChange'
    lookupRecord(event){

        this.selectedFacilitor = '';
        this.selectedDonor = '';
        this.selectedGrade = '';
        this.selectedBatch = '';

        var school = event.detail.selectedRecord;
        if(school){
            this.selectedSchool = school.Id;

            if(this.selectedSchool != '' && this.selectedGrade != '' && this.selectedAction == 'Update'){
                this.callbatchinfo();
            } else {
                this.batch = [];
                this.showbatch = false;
            }
        } else {
            this.selectedSchool = '';
            this.batch = [];
            this.showbatch = false;
        }
    }

    callbatchinfo(){
        batchInfo({ 
            schoolId: this.selectedSchool,
            selGrade: this.selectedGrade
        })
        .then(res => {
            this.batch = res.Batch;
            this.showbatch = true;
        })
        .catch(error => {
            console.error('Error: ', error);
        })
        .finally(()=>{
            
        })
    }

    handleBatchChange(event){
        this.selectedBatch = event.detail.value;
    }

    handleFacilitorChange(event){
        var facilitor = event.detail.selectedRecord;
        if(facilitor){
            this.selectedFacilitor = facilitor.Id;
        } else {
            this.selectedFacilitor = '';
        }
    }

    handleDonorChange(event){
        var donor = event.detail.selectedRecord;
        if(donor){
            this.selectedDonor = donor.Id;
        } else {
            this.selectedDonor = '';
        }
    }

    handleEmailChange(event){
        this.emailId = event.detail.value;
    }

    handlePreLangChange(event){
        this.selectedPreLan = event.detail.value;
    }

    handleFilesChange(event) {
        this.isUploadLoading = true;
        if((this.selectedOMRType == 'Baseline 1' && this.selectedEmail != ''/*&& this.selectedGrade != '' &&  
        this.selectedSchool != '' && this.selectedBatch != ''*/) ||     //By Kandisa 05/07/2023 : Remove 'this.selectedSchool' and 'this.selectedBatch'
        (this.selectedOMRType == 'Baseline 2' && this.selectedGrade != ''))
        {
            if(event.target.files.length > 0) {
                this.filesUploaded = event.target.files;
                this.filename = event.target.files[0].name;
            }   
            this.saveFile();
        } else {
            var errorMsg = '';
            //Process, Grade, Email Id, Action, School Fields Mandatory.
            if(this.selectedOMRType == ''){
                errorMsg = 'Process';
            }
            if(this.selectedOMRType == 'Baseline 2' && this.selectedGrade == ''){
                errorMsg += errorMsg ? ', Grade' : 'Grade';
            }
            if(this.selectedOMRType == 'Baseline 1' && this.selectedEmail == ''){
                errorMsg += errorMsg ? ', Email' : 'Email';
            }
            /*if(this.selectedAction == '' && this.selectedOMRType != 'Baseline 2' && this.selectedOMRType != ''){
                errorMsg += errorMsg ? ', Action' : 'Action';
            }*/
            //By Kandisa 05/07/2023 : Below condition comment out
            // if(this.selectedSchool == '' && this.selectedOMRType != 'Baseline 2' && this.selectedOMRType != ''){
            //     errorMsg += errorMsg ? ', School' : 'School';
            // }
            /*if(this.selectedAction == 'Insert' && this.selectedFacilitor == ''){
                errorMsg += errorMsg ? ', Facilitator' : 'Facilitator';
            }
            if(this.selectedAction == 'Insert' && this.selectedDonor == ''){
                errorMsg += errorMsg ? ', Donor' : 'Donor';
            }
            if(this.selectedAction == 'Insert' && this.selectedPreLan == ''){
                errorMsg += errorMsg ? ', Preferred Language' : 'Preferred Language';
            }*/
            //By Kandisa 05/07/2023 : Below condition comment out
            // if(this.selectedAction == 'Baseline 1' && this.selectedBatch == ''){
            //     errorMsg += errorMsg ? ', Batch' : 'Batch';
            // }
            if(errorMsg){
                errorMsg += ' Field Mandatory.';
            }

            this.dispatchEvent(new ShowToastEvent({
                title: 'Error!',
                message: errorMsg,
                variant: 'error'
            }));
            this.isUploadLoading = false;
            this.isModalOpen = false;
        }
    }

    saveFile(){
        var fileCon = this.filesUploaded[0];
        this.fileSize = this.formatBytes(fileCon.size, 2);
        if (fileCon.size > MAX_FILE_SIZE) {
            let message = 'File size cannot exceed ' + MAX_FILE_SIZE + ' bytes.\n' + 'Selected file size: ' + fileCon.size;
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: message,
                variant: 'error'
            }));
            return;
        }
        var reader = new FileReader();
        var self = this;
        reader.onload = function() {
            var fileContents = reader.result;
            var base64Mark = 'base64,';
            var dataStart = fileContents.indexOf(base64Mark) + base64Mark.length;
            fileContents = fileContents.substring(dataStart);
            self.upload(fileCon, fileContents);
        };
        reader.readAsDataURL(fileCon);
    }

    upload(file, fileContents){
        var fromPos = 0;
        var toPos = Math.min(fileContents.length, fromPos + CHUNK_SIZE);
        
        this.uploadChunk(file, fileContents, fromPos, toPos, ''); 
    }

    uploadChunk(file, fileContents, fromPos, toPos, attachId){
        var chunk = fileContents.substring(fromPos, toPos);
        
        saveTheChunkFile({ 
            fileName: file.name,
            base64Data: encodeURIComponent(chunk), 
            previousData: attachId
        })
        .then(result => {
            
            attachId = result;
            fromPos = toPos;
            toPos = Math.min(fileContents.length, fromPos + CHUNK_SIZE);    
            if (fromPos < toPos) {
                this.uploadChunk(file, fileContents, fromPos, toPos, attachId);  
            }else{
                this.processOMRFile(attachId,file.name);
            }
        })
        .catch(error => {
            console.error('Error: ', error);
        })
        .finally(()=>{
            
        })
    }

    processOMRFile(fileData,filename){
        processOMRSheet({ 
            fileData: fileData,
            fileName: filename,
            selectedSchool: this.selectedSchool,        //By Kandisa 05/07/2023 : Always be null           
            selectedFacilitor: this.selectedFacilitor,  //By Kandisa 05/07/2023 : Always be null
            selectedDonor: this.selectedDonor,          //By Kandisa 05/07/2023 : Always be null
            selectedGrade: this.selectedGrade,          
            selectedOMRType: this.selectedOMRType,
            selectedEmail: this.selectedEmail,
            selectedAction: this.selectedAction,        //By Kandisa 05/07/2023 : Always be null
            selectedBatchId: this.selectedBatch,        //By Kandisa 05/07/2023 : Always be null
            selectedPrefLang: this.selectedPreLan       //By Kandisa 05/07/2023 : Always be null
        })
        .then(result => {
            if(result == 'File is too large' || result == 'Please make sure data is available in the file.')
            {
                   noDataInOMRSheet({ selectedEmail: this.selectedEmail,
                                      errorMessage:result  
                    })
                    .then(res => {
                        console.log('result = ',result);
                        
                        if(res == 'Success'){
                            this.dispatchEvent(new ShowToastEvent({
                                title: 'Error!',
                                message: result,
                                variant: 'error'
                            }));
                            result = '';
                        }
                         
                    })
                    .catch(error => {
                        console.error(error);
                    }); 
               
            }
            else
            {
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success!',
                    message: 'File Upload Success! Check your email for any error record/s.',
                    variant: 'success'
                }));
            }

            var delayInMilliseconds = 3000; //3 second

            setTimeout(function() {
                this.isUploadLoading = false;
                this.isModalOpen = false;
                if(result){
                    window.open('/'+result,'_self')
                } else {
                    window.location.reload();
                }
            }, delayInMilliseconds);

        })
        .catch(error => {
            console.error('Error: ', error);
        })
        .finally(()=>{
            
        })
    }

    navigateToViewRecordPage(recordId){
        this[NavigationMixin.Navigate]({
            type:'standard__recordPage',
            attributes:{
                "recordId":recordId,
                "objectApiName":"Batch__c",
                "actionName": "view"
            }
        });
    }

    formatBytes(bytes,decimals) {
        if(bytes == 0) return '0 Bytes';
        var k = 1024,
            dm = decimals || 2,
            sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'],
            i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
    }
}