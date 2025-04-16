({    
    // retrieveStudentData : function(component, event, helper) {
    //     let selectedlanguage = 'eng';
    //     if(component.get("v.SelectedLanguage") != undefined && component.get("v.SelectedLanguage") != null &&
    //        component.get("v.SelectedLanguage") != ''){
    //         selectedlanguage = component.get("v.SelectedLanguage");
    //     }
		
    //     if(selectedlanguage == 'eng'){
    //         component.set("v.whatsppvalidationmsg","WhatsApp number is not valid. It should be in number format only.");
    //         component.set("v.contactupdatesuccessmsg","Your Contact has been updated Successfully!");
    //         component.set("v.contactupdateerrormsg","Your contact has been not updated, Please connect with your teacher if you have any question.");
            
    //         var genderOption = [
    //             {value: "Male", label: "Male"},
    //             {value: "Female", label: "Female"},
    //             {value: "Transgender", label: "Transgender"},
    //             {value: "Other", label: "Other"}
    //         ];            
    //         component.set("v.genderoptions",genderOption);
            
    //         var educationOption = [
    //             {value: "Did not attend school", label: "Did not attend school"},
    //             {value: "Below 10th Grade", label: "Below 10th Grade"},
    //             {value: "10th Pass", label: "10th Pass"},
    //             {value: "12th Pass", label: "12th Pass"},
    //             {value: "Graduate/Post Graduate", label: "Graduate/Post Graduate"},
    //             {value: "I do not know", label: "I do not know"}
    //         ];
    //         component.set("v.educationOptions",educationOption);
            
    //         var monthlyIncomeOption = [
    //             {value: "Below Rs 10,000 per month", label: "Below Rs 10,000 per month"},
    //             {value: "Rs 10,000-Rs 20,000 per month", label: "Rs 10,000-Rs 20,000 per month"},
    //             {value: "More than Rs 20,000 per month", label: "More than Rs 20,000 per month"},
    //             {value: "I do not know", label: "I do not know"}
    //         ];
    //         component.set("v.monthlyIncomeoptions",monthlyIncomeOption);
            
    //         var casteOption = [
    //             {value: "General", label: "General"},
    //             {value: "SC", label: "SC"},
    //             {value: "ST", label: "ST"},
    //             {value: "OBC", label: "OBC"},
    //             {value: "SEBC", label: "SEBC"},
    //             {value: "Nomadic Tribes", label: "Nomadic Tribes"},
    //             {value: "Others", label: "Others"}
    //         ];
    //         component.set("v.casteOptions",casteOption);
    //     }
    //     else if(selectedlanguage == 'hin'){
    //     	component.set("v.startknowingbtn","स्वयं को जान ना शुरू करें");
    //         component.set("v.studentinfoheader","छात्र की जानकारी");
    //         component.set("v.studentname","छात्र का पूरा नाम");
    //         component.set("v.contactnumber","संपर्क नंबर");
    //         component.set("v.whatsappnumber","व्हाट्स अप नंबर");
    //         component.set("v.birthdate","जन्म की तारीख");
    //         component.set("v.School","स्कूल");
    //         component.set("v.State","राज्य");
    //         component.set("v.City","शहर");
    //         component.set("v.Gender","लिंग ");
    //         component.set("v.fathereducation","पिता की शिक्षा");
    //         component.set("v.mothereducation","माता की शिक्षा");
    //         component.set("v.familyincome","औसत मासिक पारिवारिक आय");
    //         component.set("v.Category","श्रेणी");
    //         component.set("v.chooseone","एक विकल्प चुने");
    //         component.set("v.whatsppvalidationmsg","व्हाट्सएप नंबर मान्य नहीं है। यह केवल संख्या प्रारूप में होना चाहिए।");
    //         component.set("v.contactupdatesuccessmsg","आपकी संपर्कता जानकारी सफलतापूर्वक बदल दी गई है!");
    //         component.set("v.contactupdateerrormsg","आपका संपर्क अपडेट नहीं किया गया है, यदि आपका कोई प्रश्न है तो कृपया अपने शिक्षक से जुड़ें।");
    //         component.set("v.errortext","त्रुटि!");
    //         component.set("v.successtext","सफलता!");
            
    //         var genderOption = [
    //             {value: "Male", label: "पुरुष"},
    //             {value: "Female", label: "स्त्री"},
    //             {value: "Transgender", label: "ट्रांसजेंडर"},
    //             {value: "Other", label: "अन्य"}
    //         ];            
    //         component.set("v.genderoptions",genderOption);
            
    //         var educationOption = [
    //             {value: "Did not attend school", label: "स्कूल नहीं गए"},
    //             {value: "Below 10th Grade", label: "१० वीं कक्षा से कम"},
    //             {value: "10th Pass", label: "१०वीं पास"},
    //             {value: "12th Pass", label: "१२वीं पास"},
    //             {value: "Graduate/Post Graduate", label: "ग्रेजुएट/पोस्ट ग्रेजुएट"},
    //             {value: "I do not know", label: "मुझें नहीं पता"}
    //         ];
    //         component.set("v.educationOptions",educationOption);
            
    //         var monthlyIncomeOption = [
    //             {value: "Below Rs 10,000 per month", label: "10,000 रुपये प्रति माह से कम"},
    //             {value: "Rs 10,000-Rs 20,000 per month", label: "10,000 रुपये से 20,000 रुपये प्रति माह"},
    //             {value: "More than Rs 20,000 per month", label: "20,000 रुपये प्रति माह से अधिक"},
    //             {value: "I do not know", label: "मुझें नहीं पता"}
    //         ];
    //         component.set("v.monthlyIncomeoptions",monthlyIncomeOption);
            
    //         var casteOption = [
    //             {value: "General", label: "जेनरल"},
    //             {value: "SC", label: "अनुसूचित जाति/यससी"},
    //             {value: "ST", label: "अनुसूचित जनजाति/यसटी"},
    //             {value: "OBC", label: "अन्य पिछड़ा वर्ग/ओबीसी"},
    //             {value: "SEBC", label: "एसईबीसी"},
    //             {value: "Nomadic Tribes", label: "नोमाडिक ट्राइब्स"},
    //             {value: "Others", label: "अन्य"}
    //         ];
    //         component.set("v.casteOptions",casteOption);
    //     }
    //     else if(selectedlanguage == 'mar'){
    //     	component.set("v.startknowingbtn","स्वत: ला जाणून घेणे");
    //         component.set("v.studentinfoheader","विद्यार्थ्याची माहिती");
    //         component.set("v.studentname","विद्यार्थ्याचे संपूर्ण नाव");
    //         component.set("v.contactnumber","संपर्क क्रमांक");
    //         component.set("v.whatsappnumber","व्हॉट्सअ‍ॅप नंबर");
    //         component.set("v.birthdate","जन्म तारीख");
    //         component.set("v.School","शाळा");
    //         component.set("v.State","राज्य");
    //         component.set("v.City","शहर");
    //         component.set("v.Gender","लिंग");
    //         component.set("v.fathereducation","वडिलांचे शिक्षण");
    //         component.set("v.mothereducation","आईचे शिक्षण");
    //         component.set("v.familyincome","सरासरी मासिक कुटुंबाचे उत्पन्न");
    //         component.set("v.Category","वर्ग");
    //         component.set("v.chooseone","एक निवडा");
    //         component.set("v.whatsppvalidationmsg","व्हॉट्सअॅप नंबर वैध नाही. ते फक्त संख्या स्वरूपात असावे.");
    //         component.set("v.contactupdatesuccessmsg","आपल्या संपर्क क्रमांकामध्ये यशस्वीरित्या बदल झाला आहे!");
    //         component.set("v.contactupdateerrormsg","तुमचा संपर्क अद्ययावत केला गेला नाही, कृपया तुम्हाला काही प्रश्न असल्यास तुमच्या शिक्षकांशी संपर्क साधा.");
    //         component.set("v.errortext","त्रुटी!");
    //         component.set("v.successtext","यश!");
            
    //         var genderOption = [
    //             {value: "Male", label: "पुरुष"},
    //             {value: "Female", label: "स्त्री"},
    //             {value: "Transgender", label: "ट्रान्सजेंडर"},
    //             {value: "Other", label: "इतर"}
    //         ];            
    //         component.set("v.genderoptions",genderOption);
            
    //         var educationOption = [
    //             {value: "Did not attend school", label: "शाळेत गेलेले नाहीत"},
    //             {value: "Below 10th Grade", label: "दहावी खालील"},
    //             {value: "10th Pass", label: "दहावी पास"},
    //             {value: "12th Pass", label: "बारावी पास"},
    //             {value: "Graduate/Post Graduate", label: "पदवीधर / पदव्युत्तर"},
    //             {value: "I do not know", label: "मला माहित नाही"}
    //         ];
    //         component.set("v.educationOptions",educationOption);
            
    //         var monthlyIncomeOption = [
    //             {value: "Below Rs 10,000 per month", label: "दरमहा 10,000 रुपयांपेक्षा कमी"},
    //             {value: "Rs 10,000-Rs 20,000 per month", label: "10,000 ते 20,000 रुपये दरमहा"},
    //             {value: "More than Rs 20,000 per month", label: "दरमहा 20,000 रुपयांपेक्षा जास्त"},
    //             {value: "I do not know", label: "मला माहित नाही"}
    //         ];
    //         component.set("v.monthlyIncomeoptions",monthlyIncomeOption);
            
    //         var casteOption = [
    //             {value: "General", label: "खुला वर्ग"},
    //             {value: "SC", label: "अनुसूचित जाती"},
    //             {value: "ST", label: "अनुसूचित जमाती"},
    //             {value: "OBC", label: "इतर मागासवर्गीय"},
    //             {value: "SEBC", label: "सामाजिक आणि आर्थिकदृष्ट्या मागासलेल"},
    //             {value: "Nomadic Tribes", label: "भटक्या जमाती"},
    //             {value: "Others", label: "इतर"}
    //         ];
    //         component.set("v.casteOptions",casteOption);
    //     }
    //     else if(selectedlanguage == 'urd'){
    //     	component.set("v.startknowingbtn","اپنے آپ کو جاننا شروع کریں");
    //         component.set("v.studentinfoheader","طالب علم کی معلومات۔");
    //         component.set("v.studentname","طلباء کا پورا نام");
    //         component.set("v.contactnumber","رابطہ نمبر");
    //         component.set("v.whatsappnumber","واٹس ایپ نمبر");
    //         component.set("v.birthdate","پیدائش کی تاریخ");
    //         component.set("v.School","اسکول");
    //         component.set("v.State","ریاست");
    //         component.set("v.City","شہر");
    //         component.set("v.Gender","صنف");
    //         component.set("v.fathereducation","والد کی تعلیم");
    //         component.set("v.mothereducation","والدہ کی تعلیم");
    //         component.set("v.familyincome","اوسط گھر کی مہینے کی آمدنی");
    //         component.set("v.Category","قسم");
    //         component.set("v.chooseone","ایک کا انتخاب کریں");
    //         component.set("v.whatsppvalidationmsg","واٹس ایپ نمبر درست نہیں ہے۔ یہ صرف نمبر کی شکل میں ہونا چاہیے۔");
    //         component.set("v.contactupdatesuccessmsg","!آپ کا رابطہ کامیابی سے اپ ڈیٹ ہو گیا ہے");
    //         component.set("v.contactupdateerrormsg","آپ کا رابطہ اپ ڈیٹ نہیں ہوا ہے ، اگر آپ کو کوئی سوال ہے تو براہ کرم اپنے استاد سے رابطہ کریں۔");
    //         component.set("v.errortext","خرابی!");
    //         component.set("v.successtext","کامیابی!");
            
    //         var genderOption = [
    //             {value: "Male", label: "مرد"},
    //             {value: "Female", label: "خواتین"},
    //             {value: "Transgender", label: "ٹرانسجینڈر"},
    //             {value: "Other", label: "کچھ اور"}
    //         ];            
    //         component.set("v.genderoptions",genderOption);
            
    //         var educationOption = [
    //             {value: "Did not attend school", label: "اسکول نہیں گئے"},
    //             {value: "Below 10th Grade", label: "دسویں جماعت سے کم"},
    //             {value: "10th Pass", label: "دسویں پاس"},
    //             {value: "12th Pass", label: "بارویں پاس"},
    //             {value: "Graduate/Post Graduate", label: "گریجویٹ/پوسٹ گریجویٹ"},
    //             {value: "I do not know", label: "مجھے معلوم نہیں"}
    //         ];
    //         component.set("v.educationOptions",educationOption);
            
    //         var monthlyIncomeOption = [
    //             {value: "Below Rs 10,000 per month", label: "ماہانہ دس ہزار سے کم"},
    //             {value: "Rs 10,000-Rs 20,000 per month", label: "دس سے بیس ہزار روپے ماہانہ"},
    //             {value: "More than Rs 20,000 per month", label: "بیس ہزار روپے سے زیادہ ماہانہ"},
    //             {value: "I do not know", label: "مجھے معلوم نہیں"}
    //         ];
    //         component.set("v.monthlyIncomeoptions",monthlyIncomeOption);
            
    //         var casteOption = [
    //             {value: "General", label: "جنرل"},
    //             {value: "SC", label: "اس۔سی"},
    //             {value: "ST", label: "اس- ٹی"},
    //             {value: "OBC", label: "او- بی- سی"},
    //             {value: "SEBC", label: "اس - ای - بی- سی"},
    //             {value: "Nomadic Tribes", label: "نوماڈک ٹرائبیس"},
    //             {value: "Others", label: "کچھ اور"}
    //         ];
    //         component.set("v.casteOptions",casteOption);
    //     }
    //     var studentId = component.get("v.ContactId");
    //     if(studentId != undefined && studentId != null && studentId != ''){
    //         helper.showspinner(component);
    //         let action = component.get("c.fetchStudentData");
    //         action.setParams({
    //             contactId: studentId
    //         });
    //         action.setCallback(this, function(response){
    //             let state = response.getState();
                
    //             if(state === "SUCCESS"){
    //                 component.set("v.isMatchIdentity",false);
    //                 component.set("v.isShowPersonalDetail",true);
    //                 let result = response.getReturnValue();
                    
    //                 if(result != null && result != undefined){
    //                     component.set("v.Student",result)
    //                 }
    //             }else if (state === "ERROR") {
    //                 let errors = response.getError();
    //                 let errmsg = "";
    //                 if (errors.length > 0 && errors[0] && errors[0].message){
    //                     // To show other type of exceptions
    //                     errmsg += errors[0].message;
    //                 }
    //                 if (errors.length > 0 && errors[0] && errors[0].pageErrors){
    //                     // To show DML exceptions
    //                     errmsg += errors[0].pageErrors[0].message;
    //                 }
    //                 helper.showMessage(component, event, errmsg, "Error!", "error");
    //             }
    //             helper.hidespinner(component);
    //         });
    //         $A.enqueueAction(action);
    //     }
	// },
    
    showMessage: function (component, event, message, title, severity) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type":severity
        });
        toastEvent.fire();
    },    
    
    // handleSaveContact: function (component, event, helper) {
    //     var studentData = component.get("v.Student");        
    //     if(studentData != undefined && studentData != null && studentData != ''){
    //         helper.showspinner(component);
            
    //         let action = component.get("c.updateStudentData");
    //         action.setParams({
    //             contactDetail: studentData
    //         });
    //         action.setCallback(this, function(response){
    //             let state = response.getState();
                
    //             if(state === "SUCCESS"){
    //                 let result = response.getReturnValue();
    //                 if(result == 'success'){
    //                     helper.showMessage(component, event,component.get("v.contactupdatesuccessmsg"), component.get("v.successtext"), "success");
    //                     helper.handleStartExam(component, event, helper);
    //                 }else{
    //                 	helper.showMessage(component, event,component.get("v.contactupdateerrormsg"), component.get("v.errortext"), "error");
    //                 }
                    
    //             }else if (state === "ERROR") {
    //                 let errors = response.getError();
    //                 let errmsg = "";
    //                 if (errors.length > 0 && errors[0] && errors[0].message){
    //                     // To show other type of exceptions
    //                     errmsg += errors[0].message;
    //                 }
    //                 if (errors.length > 0 && errors[0] && errors[0].pageErrors){
    //                     // To show DML exceptions
    //                     errmsg += errors[0].pageErrors[0].message;
    //                 }
    //                 helper.showMessage(component, event, errmsg, "Error!", "error");
    //             }
    //             helper.hidespinner(component);
    //         });
    //         $A.enqueueAction(action);
    //     }
    // },
    handleStartExam : function (component, event, helper) {
        var studentId = component.get("v.ContactId");
        var language = 'English';
        if(component.get("v.SelectedLanguage") != undefined && component.get("v.SelectedLanguage") != null &&
          	component.get("v.SelectedLanguage") != ''){
            language = component.get("v.SelectedLanguage");
        }
        
		var address = window.location.origin+'/assessment/s/clone-transition-tracking-form?contactId='+studentId+'&lang='+language;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": address
        });                
        urlEvent.fire();        
    },
    //OMIT
    // isValid : function (component) {
    //     var allValid = component.find('fields').reduce(function (validSoFar, inputCmp) {
    //         inputCmp.focus();
    //         return validSoFar && inputCmp.checkValidity(); 
    //     }, true);
        
    //     return allValid;
    // },
    
    showHideSpinner : function(component) {
        var showValue = component.get('v.show');
        
        if(showValue) {
            var spinner = component.find("spinner");
        	$A.util.removeClass(spinner, "slds-hide");
        } else {
            var spinner = component.find("spinner");
        	$A.util.addClass(spinner, "slds-hide");
        }
    },

    showspinner: function(component) {
        component.set("v.show",true);        
    },

    hidespinner: function(component) {
        window.setTimeout(
            function() {
                component.set("v.show",false);
            }, 1000
        );        
    },

    // CUSTOMCODE : FOR Validating All Required Fields (2 Mthods)
    // isInputValid: function (component, event, message, title, severity){
    //     let isValid = true;
    //     let inputFields = component.find('copyByMangeshOfAutoCompleteInput');
    //     inputFields.forEach(inputField => {
    //         if(!inputField.isValidCmp) {
    //             // inputField.reportValidity();
    //             isValid = false;
    //         }
    //     });
    //     return isValid;
    // },

    // showMessage: function (component, event, message, title, severity) {
    //     var toastEvent = $A.get("e.force:showToast");
    //     toastEvent.setParams({
    //         "title": title,
    //         "message": message,
    //         "type":severity
    //     });
    //     toastEvent.fire();
    // }
    
})