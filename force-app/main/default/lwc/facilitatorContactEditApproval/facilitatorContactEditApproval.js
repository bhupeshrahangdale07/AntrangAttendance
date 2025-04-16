import { LightningElement, track, wire } from 'lwc';
import getAcademicYear from '@salesforce/apex/FacilitatorContactEditApprovalController.getAcademicYear';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
//import GENDER from '@salesforce/schema/Contact.Gender__C';
//import CURRENTLY_STUDYING_IN from '@salesforce/schema/Contact.Currently_Studying_In__c';

//import getRecordTypeId from '@salesforce/apex/FacilitatorContactEditApprovalController.getRecordTypeId';
import getContact from '@salesforce/apex/FacilitatorContactEditApprovalController.fetchContact';
import createTempContact from '@salesforce/apex/FacilitatorContactEditApprovalController.createTempContact';
import checkEmailExist from '@salesforce/apex/FacilitatorContactEditApprovalController.checkEmailExist';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';



import CONTACT_OBJECT from '@salesforce/schema/Contact';

export default class FacilitatorContactEditApproval extends LightningElement {
    @track AcademicYear;
    startPage = true;
    contactEditPage;
    @track traineremail;
    @track Barcode ='';
    @track record = {};
    @track disableSubmit = true;
    isLoading = false;
    formData={};

    @track todaysDate = new Date().toJSON();

    @track genderOptions = [{'label':'--None--', 'value':''},
                            {'label':'Male', 'value':'Male'},
                            {'label':'Female', 'value':'Female'},
                            {'label':'Others', 'value':'Others'},
                            {'label':'Transgender', 'value':'Transgender'},
                            {'label':'*', 'value':'*'}];

    @track CurrentlyStudyingInOptions = [];

    @track Gndr = [];
    @track CSI = [];

    @track grade9 = false;
    @track grade10 = false;
    @track grade11 = false;

    @track grade9Batch = '';
    @track grade10Batch = '';
    @track grade11Batch = '';

    
    @track SchoolName='';
    BatchNumber = '';
    BatchName = '';
    BatchGrade = '';

    recordTypeId;

 /*   @wire(getRecordTypeId)
    wiredpropertyrecordTypeId({ error, data }) {
        if (data) {
            this.recordTypeId = data;
            console.log('Academic year : '+data);
            //this.error = undefined;
        } else if (error) {
            console.log('Error : '+error);
        }
    }

    @wire(getPicklistValuesByRecordType, { objectApiName: CONTACT_OBJECT, recordTypeId: this.recordTypeId })
    propertyOrFunction


        
    
     @wire(getRecordTypeId)
        wiredpropertyrecordTypeId({ error, data }) {
            if (data) {
                this.recordTypeId = data;
                alert();
                console.log('re id  : '+data);
                //this.error = undefined;
            } else if (error) {
                console.log('Error : '+error);
            }
        }

        @wire( getPicklistValues, { recordTypeId: '$recordTypeId', fieldApiName: 'Grade__c' } )
        wiredData( { error, data } ) {
            if ( data ) {
                var gData = [{
                    label: `-- None --`,
                    value: ``
                }];
                data.values.forEach(g => {
                    gData.push({label: g.label, value: g.value});
                });
                this.CSI = gData;
                console.log('Grd : '+gData);
            } else if ( error ) {
                console.error(  error  );
            }
        }

        @wire( getPicklistValues, { recordTypeId: this.recordTypeId, fieldApiName: 'Currently_Studying_In__c' } )
        wiredData1( { error, data } ) {
            if ( data ) {
                var gData = [{
                    label: `-- None --`,
                    value: ``
                }];
                data.values.forEach(g => {
                    gData.push({label: g.label, value: g.value});
                });
                this.CSI = gData;
                console.log('CSI : '+gData);
            } else if ( error ) {
                console.error( error  );
            }
        }
    



    @wire( getObjectInfo, { objectApiName: CONTACT_OBJECT } )
    objectInfo({error,data}){
        if(data){
            console.log('pickvals : '+data.recordTypeInfos);
        }
    }


    @wire( getPicklistValues, { recordTypeId: this.recordTypeId, fieldApiName: 'Gender__c' } )
    wiredData( { error, data } ) {
        if ( data ) {
            var gData = [{
                label: `-- None --`,
                value: ``
            }];
            data.values.forEach(g => {
                gData.push({label: g.label, value: g.value});
            });
            this.Gndr = gData;
            console.log('Gndr : '+gData);
        } else if ( error ) {
            console.error( JSON.stringify( error ) );
        }
    }

    @wire( getPicklistValues, { recordTypeId: this.recordTypeId, fieldApiName: 'Currently_Studying_In__c' } )
    wiredData1( { error, data } ) {
        if ( data ) {
            var gData = [{
                label: `-- None --`,
                value: ``
            }];
            data.values.forEach(g => {
                gData.push({label: g.label, value: g.value});
            });
            this.CSI = gData;
            console.log('CSI : '+gData);
        } else if ( error ) {
            console.error( JSON.stringify( error ) );
        }
    }
*/
    @wire(getAcademicYear)
    wiredproperty({ error, data }) {
        if (data) {
            this.AcademicYear = data;
            console.log('Academic year : '+data);
            //this.error = undefined;
        } else if (error) {
            console.log('Error : '+error);
        }
    }

    handleTrainerEmail(event){
        this.traineremail = event.target.value;
    }

    checkemail(event){
        this.isLoading = true;
        let stremail = this.traineremail;
        let validExpense = true;
        if (stremail == undefined || stremail == null || stremail == "") {
            validExpense = false;
            const event = new ShowToastEvent({
                variant: 'error',
                title: 'ERROR !',
                message: "Enter trainer's email address!",
            });
            this.dispatchEvent(event);
        }
        
        if (validExpense) {
            this.checktraineremail(event);
        }
        this.isLoading = false;
    }

    checktraineremail(event){
        checkEmailExist({stremail:this.traineremail})
        .then(res => {
            if(res === 'Not Valid'){
                const event = new ShowToastEvent({
                    variant: 'warning',
                    message: 'Matching trainer not found!!',
                });
                this.dispatchEvent(event);
            }
            if(res === 'Valid'){
                this.startPage = false;
                this.contactEditPage = true;
                this.formData.SubmitterEmail = this.traineremail;
            }
        })
        .catch(error => {
            console.log(error);
        })

    }

    handleBarcode(event){
        this.Barcode =  event.target.value;
    }

     handleG9WhatsAppFeild(event){
        if(this.record.G9_Whatsapp_Number__c != event.target.value){
            this.disableSubmit = false;
            this.formData.G9_Whatsapp_Number = event.target.value;
        }
     }
     handleG10WhatsAppFeild(event){
        if(this.record.G10_Whatsapp_Number__c != event.target.value){
            this.disableSubmit = false;
            this.formData.G10_Whatsapp_Number = event.target.value;
        }
     }
     handleG11WhatsAppFeild(event){
        if(this.record.G11_Whatsapp_Number__c != event.target.value){
            this.disableSubmit = false;
            this.formData.G11_Whatsapp_Number = event.target.value;
        }
     }

     handleG9AlternateNo(event){
        if(this.record.G9_Alternate_Mobile_No__c != event.target.value){
            this.disableSubmit = false;
            this.formData.G9_Alternate_Mobile_No = event.target.value;
        }
     }
     handleG10AlternateNo(event){
        if(this.record.G10_Alternate_Mobile_No__c != event.target.value){
            this.disableSubmit = false;
            this.formData.G10_Alternate_Mobile_No = event.target.value;
        }
     }
     handleG11AlternateNo(event){
         
        if(this.record.G11_Alternate_Mobile_No__c != event.target.value){
            this.disableSubmit = false;
            this.formData.G11_Alternate_Mobile_No = event.target.value;
        }
     }

    getContactWithBarcode(event){
        this.isLoading = true;
        //alert(this.trainerEmail);
        let str1email = this.traineremail;
        let barcodeVal = this.Barcode;
        //alert(str1email);
        if(this.isInputValid('.validateBarcode')){
            getContact({ Barcode:this.Barcode, stremail:str1email})
            .then(result =>{

                if(result.Status.Status == 'error'){
                    const event = new ShowToastEvent({
                        variant: 'error',
                        message: result.Status.Message,
                    });
                    this.dispatchEvent(event);
                    this.record.Id = null;
                }else{

                    if(result.Gender__c){
                        //this.genderOptions = result.Gender__c;
                    }
                    if(result.Currently_Studying_In__c){
                        this.CurrentlyStudyingInOptions = result.Currently_Studying_In__c;
                    }

                    if(result.Contact && Object.keys(result.Contact).length === 0 && Object.getPrototypeOf(result.Contact) === Object.prototype){
                        const event = new ShowToastEvent({
                            variant: 'error',
                            title: 'Barcode/UID does not exist',
                            //message: 'i.e. Student will belong to only 1 Batch of current academic year!',
                        });
                        this.dispatchEvent(event);
                    }else if(result.Contact.Approval_Status__c == 'Pending'){
                        const event = new ShowToastEvent({
                            variant: 'error',
                            title: 'ERROR !',
                            message: 'Submitted Approval is still Pending!',
                        });
                        this.record.Id = null;
                        this.dispatchEvent(event);
                    }else{
                        this.formData.UID = barcodeVal;
                        this.record = result.Contact;
                        var str = result.Contact.Current_Academic_Batch__c;
                        var arr = str.split(';')
                        this.BatchNumber = arr[1];
                        this.BatchName =  arr[2];
                        this.BatchGrade =  arr[0];

                        if(arr[0] == 'Grade 9' ){
                            //this.grade9Batch = result.Contact.Batch_Code__c;
                            this.formData.Current_Grade = 9;
                            this.SchoolName = result.Contact.Batch_Code__r.School_Name__r.Name;
                                this.grade9 = true;
                                this.grade10 = false;
                                this.grade11 = false;
                        }else if(arr[0] == 'Grade 10' ){
                            //this.grade10Batch = result.Contact.G10_Batch_Code__c;
                            this.formData.Current_Grade = 10;
                            this.SchoolName = result.Contact.G10_Batch_Code__r.School_Name__r.Name;
                                this.grade9 = false;
                                this.grade10 = true;
                                this.grade11 = false;
                        }else if(arr[0] == 'Grade 11' ){
                            //this.grade11Batch = result.Contact.G11_Batch_Code__c;
                            this.formData.Current_Grade = 11;
                            this.SchoolName = result.Contact.G11_Batch_Code__r.School_Name__r.Name;
                                this.grade9 = false;
                                this.grade10 = false;
                                this.grade11 = true;
                        }

                        /*
                        if(result.Contact.Grade_9_Barcode__c ){
                            if(result.Contact.Grade_9_Barcode__c == this.Barcode ){
                                this.grade9Batch = result.Contact.Batch_Code__c;
                                this.grade9 = true;
                                this.grade10 = false;
                                this.grade11 = false;
                            }
                        }
                        if(result.Contact.Grade_10_Barcode__c){
                            if(result.Contact.Grade_10_Barcode__c == this.Barcode ){
                                this.grade10Batch = result.Contact.G10_Batch_Code__c;
                                this.grade10 = true;
                                this.grade9 = false;
                                this.grade11 = false;
                            }
                        }
                        if(result.Contact.Grade_11_Barcode__c){
                            if(result.Contact.Grade_11_Barcode__c == this.Barcode ){
                                this.grade11Batch = result.Contact.G11_Batch_Code__c;
                                this.grade11 = true;
                                this.grade09 = false;
                                this.grade10 = false;
                            }
                        }
                        */
                        /*
                        if(result.Contact.Batch_Code__c ){
                            if(result.Contact.Batch_Code__r.Academic_Year__c == this.AcademicYear ){
                                //this.grade9Batch = result.Contact.Batch_Code__c;
                                //alert(result.Contact.Batch_Code__r.School_Name__r.Name);
                                this.SchoolName = result.Contact.Batch_Code__r.School_Name__r.Name;
                                this.grade9 = true;
                                this.grade10 = false;
                                this.grade11 = false;
                            }
                        }
                        if(result.Contact.G10_Batch_Code__c){
                            if(result.Contact.G10_Batch_Code__r.Academic_Year__c == this.AcademicYear ){
                                //this.grade10Batch = result.Contact.G10_Batch_Code__c;
                                this.SchoolName = result.Contact.G10_Batch_Code__r.School_Name__r.Name;
                                this.grade10 = true;
                                this.grade9 = false;
                                this.grade11 = false;
                            }
                        }
                        if(result.Contact.G11_Batch_Code__c){
                            if(result.Contact.G11_Batch_Code__r.Academic_Year__c == this.AcademicYear ){
                                //this.grade11Batch = result.Contact.G11_Batch_Code__c;
                                this.SchoolName = result.Contact.G11_Batch_Code__r.School_Name__r.Name;
                                this.grade11 = true;
                                this.grade09 = false;
                                this.grade10 = false;
                            }
                        }
                        */
                    }
            }
            
        })
        .catch(error =>{

            console.log('error : ',error);
            if(error.body.message == 'List has no rows for assignment to SObject'){
                 const event = new ShowToastEvent({
                    variant: 'error',
                    title: 'Barcode/UID does not exist',
                    //message: 'i.e. Student will belong to only 1 Batch of current academic year!',
                });
                this.record.Id = null;
                this.dispatchEvent(event);
            }


        });
        }
        
        this.isLoading = false;
 
    }

    isInputValid(inp) {
        let isValid = true;
        let inputFields = this.template.querySelectorAll(inp);
        inputFields.forEach(inputField => {
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
            }
           // this.contact[inputField.name] = inputField.value;
        });
        return isValid;
    }

    async handleSubmit(event){
        //event.preventDefault();       // stop the form from submitting

        if(this.isInputValid('.validate')){
            this.isLoading = true;
            this.formData.Id = this.record.Id;
            //this.formData.UID = this.Barcode;
            if(this.formData.FirstName == undefined ){this.formData.FirstName = this.record.FirstName;}
            if(this.formData.LastName == undefined ){this.formData.LastName = this.record.LastName;}
            if(this.formData.Gender == undefined ){this.formData.Gender = this.record.Gender__c;}
            if(this.formData.Birthdate == undefined ){this.formData.Birthdate = this.record.Birthdate;}
            //if(this.formData.MobilePhone == undefined ){this.formData.MobilePhone = this.record.MobilePhone;}
            if(this.formData.CurrentlyStudyingIn == undefined ){this.formData.CurrentlyStudyingIn = this.record.Currently_Studying_In__c;}

            if(this.formData.Current_Grade == 9 ){
                if(this.formData.Batch_Code == undefined ){this.formData.Batch_Code = this.record.Batch_Code__c;}
                if(this.formData.G9_Whatsapp_Number == undefined ){this.formData.G9_Whatsapp_Number = this.record.G9_Whatsapp_Number__c;}
                if(this.formData.G9_Alternate_Mobile_No == undefined ){this.formData.G9_Alternate_Mobile_No = this.record.G9_Alternate_Mobile_No__c;}
            }
            if(this.formData.Current_Grade == 10 ){
                if(this.formData.G10_Batch_Code == undefined ){this.formData.G10_Batch_Code = this.record.G10_Batch_Code__c;}
                if(this.formData.G10_Whatsapp_Number == undefined ){this.formData.G10_Whatsapp_Number = this.record.G10_Whatsapp_Number__c;}
                if(this.formData.G10_Alternate_Mobile_No == undefined ){this.formData.G10_Alternate_Mobile_No = this.record.G10_Alternate_Mobile_No__c;}
            }
            if(this.formData.Current_Grade == 11 ){
                if(this.formData.G11_Batch_Code == undefined ){this.formData.G11_Batch_Code = this.record.G11_Batch_Code__c;}
                if(this.formData.G11_Whatsapp_Number == undefined ){this.formData.G11_Whatsapp_Number = this.record.G11_Whatsapp_Number__c;}
                if(this.formData.G11_Alternate_Mobile_No == undefined ){this.formData.G11_Alternate_Mobile_No = this.record.G11_Alternate_Mobile_No__c;}
            }

            if(this.record.FirstName == undefined && this.formData.FirstName != this.record.FirstName){
                this.record.FirstName = '';
            }
            /*
            if(this.record.MobilePhone == undefined && this.formData.MobilePhone != this.record.MobilePhone ){
                this.record.MobilePhone = '';
            }
            */

            if(this.record.G9_Alternate_Mobile_No__c == undefined && this.record.G9_Alternate_Mobile_No__c != this.formData.G9_Alternate_Mobile_No){
                this.record.G9_Alternate_Mobile_No__c = '';
            }
            if(this.record.G10_Alternate_Mobile_No__c == undefined && this.record.G10_Alternate_Mobile_No__c != this.formData.G10_Alternate_Mobile_No){
                this.record.G10_Alternate_Mobile_No__c = '';
            }
            if(this.record.G11_Alternate_Mobile_No__c == undefined && this.record.G11_Alternate_Mobile_No__c != this.formData.G11_Alternate_Mobile_No){
                this.record.G10_Alternate_Mobile_No__c = '';
            }


            if(this.formData.FirstName != this.record.FirstName || 
                this.formData.LastName != this.record.LastName || 
                this.formData.Gender != this.record.Gender__c || 
                this.formData.Birthdate != this.record.Birthdate || 
                //this.formData.MobilePhone != this.record.MobilePhone || 
                this.formData.CurrentlyStudyingIn != this.record.Currently_Studying_In__c ||

               // this.formData.Batch_Code!= this.record.Batch_Code__c || 
                this.formData.G9_Whatsapp_Number != this.record.G9_Whatsapp_Number__c || 
                this.formData.G9_Alternate_Mobile_No != this.record.G9_Alternate_Mobile_No__c || 

                //this.formData.G10_Batch_Code != this.record.G10_Batch_Code__c || 
                this.formData.G10_Whatsapp_Number != this.record.G10_Whatsapp_Number__c || 
                this.formData.G10_Alternate_Mobile_No != this.record.G10_Alternate_Mobile_No__c || 

                //this.formData.G11_Batch_Code != this.record.G11_Batch_Code__c || 
                this.formData.G11_Whatsapp_Number != this.record.G11_Whatsapp_Number__c || 
                this.formData.G11_Alternate_Mobile_No != this.record.G11_Alternate_Mobile_No__c  

            ){
                //if(this.grade9 = true){this.formData.Current_Grade = 9;}else if(this.grade10 = true){this.formData.Current_Grade = 10;}else if(this.grade11 = true){this.formData.Current_Grade = 11;}

                await createTempContact({formData:this.formData, trainerEmail:this.traineremail})
                .then(res =>{
                    if(res == 'Success'){
                        window.location.reload();
                    }
                    if(res == 'error'){
                        const event = new ShowToastEvent({
                            variant: 'error',
                            title: 'ERROR !',
                            message: 'Submitted Approval is still Pending!',
                        });
                        this.dispatchEvent(event);
                    }
                })
                
            }else{
                const event = new ShowToastEvent({
                    variant: 'info',
                    message: 'No changes made!',
                });
                this.dispatchEvent(event);
            }
        }
        this.isLoading = false;
        //this.template.querySelector('lightning-record-edit-form').submit(fields);
     }

     handleSucess(event){
        const updatedRecord = event.detail.id;
        console.log('onsuccess: ', updatedRecord);
     }
     handleFeild(event){
        
     }


     handleFirstName(event){
        if(this.record.FirstName != event.target.value){
            this.disableSubmit = false;
            this.formData.FirstName = event.target.value;
        }else{
            this.formData.FirstName = this.record.FirstName;
        }
     }
     handleLastName(event){
        if(this.record.LastName != event.target.value){
            this.disableSubmit = false;
            this.formData.LastName = event.target.value;
        }else{
            this.formData.LastName = this.record.LastName;
        }
     }
     handleGender(event){
        if(this.record.Gender__c != event.target.value){
            this.disableSubmit = false;
            this.formData.Gender = event.target.value;
        }else{
            this.formData.Gender = this.record.Gender;
        }
        
     }
     handleBirthdate(event){
        if(this.record.Birthdate != event.target.value){
            this.disableSubmit = false;
            this.formData.Birthdate = event.target.value;
        }else{
            this.formData.Birthdate = this.record.Birthdate;
        }
     }

     /*
     handleMobilePhone(event){
        if(this.record.MobilePhone != event.target.value){
            this.disableSubmit = false;
            this.formData.MobilePhone = event.target.value;
        }else{
            this.formData.MobilePhone = this.record.MobilePhone;
        }
     }
     */

     handleCurrentlyStudyingIn(event){
        if(this.record.Currently_Studying_In__c != event.target.value){
            this.disableSubmit = false;
            this.formData.CurrentlyStudyingIn = event.target.value;
        }else{
            this.formData.CurrentlyStudyingIn = this.record.Currently_Studying_In__c;
        }
     }

     handleBatch(event){

        if(this.grade9){
            this.formData.Batch_Code = event.detail.selectedRecord.Id;
        }

        if(this.grade10){
            this.formData.G10_Batch_Code = event.detail.selectedRecord.Id;
        }
        if(this.grade11){
            this.formData.G10_Batch_Code = event.detail.selectedRecord.Id;
        }
        console.log('batch Id',event.detail.selectedRecord.Id);
    }
}