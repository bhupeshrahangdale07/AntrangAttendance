({
  objpageconstant: function (component, event, helper) {
    let langparam = helper.getParameterByName("lang");
    if (langparam == undefined || langparam == null) {
      langparam = "eng";
    }

    let pageConstant = {};
    if (langparam == "eng") {
      pageConstant.submitlabel = "Please click here before leaving this page!";
      pageConstant.submitbutton = "Submit";
      pageConstant.msg =
        "Good Job! You are one step closer to planning your career.";
    } else if (langparam == "hin") {
      pageConstant.submitlabel = "यहाँ पर क्लिक करे पेज छोड़ने से पहले!";
      pageConstant.submitbutton = "प्रस्तुत";
      pageConstant.msg =
        "बहुत बढ़िया! आप अपने करियर की योजना बनाने के एक कदम करीब हैं।";
    } else if (langparam == "mar") {
      pageConstant.submitlabel = "हे page सोडायच्या आधी कृपया येथे क्लिक करा!";
      pageConstant.submitbutton = "सबमिट करा";
      pageConstant.msg =
        "मस्त! आपण आपल्या करिअरच्या नियोजनाच्या अगदी जवळ एक पाऊल आहे.";
    }

    component.set("v.pageConstant", pageConstant);
  },
  objinit: function (component, event, helper) {
    let c = {};
    c.whohaveyoutalked = [];
    c.dob = "";
    c.mothereducation = "";
    c.fathereduction = "";

    c.day1gender = "";
    c.Interest1 = "";
    c.Interest2 = "";
    c.Interest3 = "";
    c.CurrentAspiration = "";

    c.Aptitude1 = "";
    c.Aptitude2 = "";
    c.Aptitude3 = "";
    c.Reality1 = "";
    c.Reality2 = "";
    c.Reality3 = "";
    c.Reality4 = "";
    c.Reality5 = "";
    c.Reality6 = "";
    c.Reality7 = "";
    c.Reality8 = "";

    c.PossibleCareers1 = "";
    c.PossibleCareers2 = "";
    c.PossibleCareers3 = "";
    c.Nextstep1 = "";
    c.Nextstep2 = "";
    c.Intenttostudy3 = "";

    c.Gender = "";
    c.GuardianAttendance = "";
    c.Iagreewiththerecommendation1 = "";
    c.Iagreewiththerecommendation2 = "";
    c.AbletouseIARtodisagreewithreco = "";
    c.ClearnextstepforReco1 = "";
    c.ClearnextstepforReco2 = "";
    c.isRecommendationReport = false;

    component.set("v.wrpcon", c);
  },

  onAttendanceDaySelected: function (component, event, helper) {
    helper.fnGetMappingTable(component, event, helper, 1);
  },

  fnGetMappingTable: function (component, event, helper, pagenumber) {
    let selectedDays = "";
    let paramday = component.get("v.pagenumberday");
    //let param = this.getParameterByName("page");
    let param = pagenumber;

    if (param) {
      component.set("v.pagenumber", parseInt(param));

      if (param == 1) {
        selectedDays = "Identifier";
      } else if (param == 2 && parseInt(paramday) == 1) {
        selectedDays = "Day-1";
      } else if (param == 2 && parseInt(paramday) == 2) {
        selectedDays = "Day-2";
        helper.fillpage2table(component, event, helper);
      } else if (param == 2 && parseInt(paramday) == 3) {
        selectedDays = "Day-3";
        //helper.fillpage2table(component, event, helper);
      }

      if (param > 1) {
        component.set("v.pagenumberday", parseInt(paramday));
      }
    }

    let langparam = this.getParameterByName("lang");
    if (langparam == undefined || langparam == null) {
      langparam = "eng";
    }

    let action = component.get("c.getMappingRecords");
    action.setParams({
      selectedDay: selectedDays,
      lang: langparam
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        let StudentFeedbackMapping = response.getReturnValue();

        let objui = {};
        objui.accountQName =
          "Type the first 4 letters of the student's school name, then wait for different school names appear, please select the school name from that list. DO NOT type the whole school name.";
        objui.contactQName =
          "Type the first 4 letters of the student's name, then wait for different names appear, please select the student name from that list. DO NOT type their whole name.";
        objui.batchQName =
          "Please choose the batch code shared by your Antarang Teacher";

        StudentFeedbackMapping.forEach((i) => {
          if (i.Object_API_Name__c == "Account" && i.Field_API__c == "Name") {
            objui.accountQName = i.Question_Label__c;
          }
          if (i.Object_API_Name__c == "Contact" && i.Field_API__c == "Name") {
            objui.contactQName = i.Question_Label__c;
          }
          if (i.Field_Label__c == "Title") {
            objui.titleQName = i.Question_Label__c;
          }

          /** Page 1 */
          if (i.Field_Label__c == "Birthdate") {
            objui.birthdateQName = i.Question_Label__c;
          }

          if (i.Field_Label__c == "Who have you talked about career plan") {
            objui.whohaveyoutalkedQName = i.Question_Label__c;
            objui.whohaveyoutalkeddata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Father Education") {
            objui.fathereducationQName = i.Question_Label__c;
            objui.fathereducationdata = this.findoptiondata(
              i.Picklist_Mappings__r,
              true
            );
          }

          if (i.Field_Label__c == "Mother Education") {
            objui.mothereducationQName = i.Question_Label__c;
            objui.mothereducationdata = this.findoptiondata(
              i.Picklist_Mappings__r,
              true
            );
          }
          /** End Page 1 */

          /** Day 1 */
          if (i.Field_Label__c == "Interest 1") {
            objui.Interest1QName = i.Question_Label__c;
            objui.Interest1ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Interest 2") {
            objui.Interest2QName = i.Question_Label__c;
            objui.Interest2ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Interest 3") {
            objui.Interest3QName = i.Question_Label__c;
            objui.Interest3ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Current Aspiration") {
            objui.CurrentAspirationQName = i.Question_Label__c;
            objui.CurrentAspirationndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              true
            );
          }
          /** End Day 1 */

          /** Day 2 */

          if (i.Field_Label__c == "Title1") {
            objui.titleQName1 = i.Question_Label__c;
          }

          if (i.Field_Label__c == "Aptitude 1") {
            objui.Aptitude1QName = i.Question_Label__c;
            objui.Aptitude1ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Aptitude 2") {
            objui.Aptitude2QName = i.Question_Label__c;
            objui.Aptitude2ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Aptitude 3") {
            objui.Aptitude3QName = i.Question_Label__c;
            objui.Aptitude3ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Title2") {
            objui.title2QName = i.Question_Label__c;
          }

          if (i.Field_Label__c == "Reality 1 Self 1") {
            objui.Reality1Self1QName = i.Question_Label__c;
            objui.Reality1Self1ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Reality 2 Self 2") {
            objui.Reality2Self2QName = i.Question_Label__c;
            objui.Reality2Self2ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Reality 3 Self 3") {
            objui.Reality3Self3QName = i.Question_Label__c;
            objui.Reality3Self3ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Reality 4 Self 4") {
            objui.Reality4Self4QName = i.Question_Label__c;
            objui.Reality4Self4ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Title3") {
            objui.title3QName = i.Question_Label__c;
          }

          if (i.Field_Label__c == "Reality 5 Family 1") {
            objui.Reality5Family1QName = i.Question_Label__c;
            objui.Reality5Family1ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Reality 6 Family 2") {
            objui.Reality6Family2QName = i.Question_Label__c;
            objui.Reality6Family2ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Reality 7 Family 3") {
            objui.Reality7Family3QName = i.Question_Label__c;
            objui.Reality7Family3ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Reality 8 Family 4") {
            objui.Reality8Family4QName = i.Question_Label__c;
            objui.Reality8Family4ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }
          /** End Day 2 */

          /** Day 3 */
          if (i.Field_Label__c == "Gender") {
            objui.GenderQName = i.Question_Label__c;
            objui.Genderdata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Guardian Attendance") {
            objui.GuardianAttendanceQName = i.Question_Label__c;
            objui.GuardianAttendancedata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "I agree with the recommendation 1") {
            objui.Iagreewiththerecommendation1QName = i.Question_Label__c;
            objui.Iagreewiththerecommendation1data = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "I agree with the recommendation 2") {
            objui.Iagreewiththerecommendation2QName = i.Question_Label__c;
            objui.Iagreewiththerecommendation2data = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Able to use IAR to dis/agree with reco") {
            objui.AbletouseIARtodisagreewithrecoQName = i.Question_Label__c;
            objui.AbletouseIARtodisagreewithrecodata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Clear next step for Reco 1") {
            objui.ClearnextstepforReco1QName = i.Question_Label__c;
            objui.ClearnextstepforReco1data = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Clear next step for Reco 2") {
            objui.ClearnextstepforReco2QName = i.Question_Label__c;
            objui.ClearnextstepforReco2data = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          /** End Day 3 */

          /** Day 5 */
          if (i.Field_Label__c == "Possible Careers 1") {
            objui.PossibleCareers1QName = i.Question_Label__c;
            objui.PossibleCareers1ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              true
            );
          }

          if (i.Field_Label__c == "Possible Careers 2") {
            objui.PossibleCareers2QName = i.Question_Label__c;
            objui.PossibleCareers2ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              true
            );
          }

          if (i.Field_Label__c == "Possible Careers 3") {
            objui.PossibleCareers3QName = i.Question_Label__c;
            objui.PossibleCareers3ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              true
            );
          }

          if (i.Field_Label__c == "Next step 1") {
            objui.Nextstep1QName = i.Question_Label__c;
            objui.Nextstep1ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Next step 2") {
            objui.Nextstep2QName = i.Question_Label__c;
            objui.Nextstep2ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Intent to study") {
            objui.Intenttostudy3QName = i.Question_Label__c;
            objui.Intenttostudy3ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }
          /** End Day 5 */
        });
        component.set("v.objUI", objui);
      } else if (state === "ERROR") {
        let errors = response.getError();
        let message = ""; // Default error message
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message += errors[0].message;
        }
        helper.showMessageToast(component, event, helper, message, "error");
      }
    });
    $A.enqueueAction(action);
  },

  checktraineremail: function (component, event, helper) {
    let email = component.get("v.traineremail");
    let action = component.get("c.checkEmailExist");
    action.setParams({
      stremail: email
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        let res = response.getReturnValue();
        if (res != undefined && res != null && res.Id != undefined) {
          component.set("v.pagenumber", 2);
          helper.fnGetMappingTable(component, event, helper, 2);
        } else {
          helper.showMessageToast(
            component,
            event,
            helper,
            "Matching trainer not found!",
            "warning"
          );
        }
      } else if (state === "ERROR") {
        let errors = response.getError();
        let message = ""; // Default error message
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message += errors[0].message;
        }
        helper.showMessageToast(component, event, helper, message, "error");
      }
    });
    $A.enqueueAction(action);
  },

  fillpage2table: function (component, event, helper) {
    let contactid = component.get("v.ContactId");
    let action = component.get("c.findDay1Data");
    action.setParams({
      contactid: contactid
    });
    action.setCallback(this, function (response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        let res = response.getReturnValue();

        component.set("v.objpage2", res.objcon);

        let objui = {};
        res.lstfeedback.forEach((i) => {
          if (i.Field_Label__c == "Reality 1 Self 1") {
            objui.Reality1Self1QName = i.Question_Label__c;
            objui.Reality1Self1ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Reality 2 Self 2") {
            objui.Reality2Self2QName = i.Question_Label__c;
            objui.Reality2Self2ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Reality 3 Self 3") {
            objui.Reality3Self3QName = i.Question_Label__c;
            objui.Reality3Self3ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Reality 4 Self 4") {
            objui.Reality4Self4QName = i.Question_Label__c;
            objui.Reality4Self4ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Title3") {
            objui.title3QName = i.Question_Label__c;
          }

          if (i.Field_Label__c == "Reality 5 Family 1") {
            objui.Reality5Family1QName = i.Question_Label__c;
            objui.Reality5Family1ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Reality 6 Family 2") {
            objui.Reality6Family2QName = i.Question_Label__c;
            objui.Reality6Family2ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Reality 7 Family 3") {
            objui.Reality7Family3QName = i.Question_Label__c;
            objui.Reality7Family3ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }

          if (i.Field_Label__c == "Reality 8 Family 4") {
            objui.Reality8Family4QName = i.Question_Label__c;
            objui.Reality8Family4ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
          }
        });

        component.set("v.objpage2UI", objui);
      } else if (state === "ERROR") {
        let errors = response.getError();
        let message = ""; // Default error message
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message += errors[0].message;
        }
        helper.showMessageToast(component, event, helper, message, "error");
      }
    });
    $A.enqueueAction(action);
  },

  findoptiondata: function (optionsdata, ischoose) {
    let options = [];
    if (ischoose) {
      options.push({
        label: "Choose one...",
        value: ""
      });
    }
    optionsdata.forEach((o) => {
      options.push({
        label: o.Form_value__c,
        value: o.SF_Value__c
      });
    });

    return options;
  },

  findRecommendationReport: function (component, event, helper) {
    let contactId = component.get("v.ContactId");
    let action = component.get("c.findcontactrecommendation");
    action.setParams({
      contactid: contactId
    });

    action.setCallback(this, function (response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        let isrecommend = response.getReturnValue();
        component.set("v.IsRecommendationReport", isrecommend);
      } else if (state === "ERROR") {
        let errors = response.getError();
        let message = ""; // Default error message
        // Retrieve the error message sent by the server
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message += errors[0].message;
        }
        helper.showMessageToast(component, event, helper, message, "error");
      }
    });
    $A.enqueueAction(action);
  },
      
    additionalcacall: function (component, event, helper) {
    console.log("additionalcacall3 ");    
    let contactId = component.get("v.ContactId");
    let action = component.get("c.additionalcacalltrue");
    action.setParams({
      contactid: contactId
    });

    action.setCallback(this, function (response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        let isattended = response.getReturnValue();
          if(!isattended){
            let daysArr = []; 
            daysArr.push({'label': 'Choose one...', 'value': ''});
            daysArr.push({'label': 'Additional CA Call 1 - Knowing yourself (Not attended students only)', 'value': 1});
            daysArr.push({'label': 'Additional Counselling Call (Attended students only)', 'value': 3});
            component.set("v.Days", daysArr);  
          }
        
      } else if (state === "ERROR") {
        let errors = response.getError();
        let message = ""; // Default error message
        // Retrieve the error message sent by the server
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message += errors[0].message;
        }
        helper.showMessageToast(component, event, helper, message, "error");
      }
    });
    $A.enqueueAction(action);
  },

  fnGetAccountbatches: function (component) {
    let accountId = component.get("v.AccountId");
    let action = component.get("c.getAccountBatches");
    action.setParams({
      AccountId: accountId
    });

    action.setCallback(this, function (response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        let batches = response.getReturnValue();
        if (batches) {
          component.set("v.AccountBatches", batches);
        }
      } else if (state === "ERROR") {
        let errors = response.getError();
        let message = ""; // Default error message
        // Retrieve the error message sent by the server
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message += errors[0].message;
        }
        helper.showMessageToast(component, event, helper, message, "error");
      }
    });
    $A.enqueueAction(action);
  },
  showMessageToast: function (component, event, helper, strmessage, strtype) {
    let toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      message: strmessage,
      type: strtype,
      duration: 4000
    });
    // toastEvent.setParams({
    //   message: strmessage,
    //   type: strtype,
    //   mode: "sticky"
    // });
    toastEvent.fire();
  },
  getParameterByName: function (name) {
    name = name.replace(/[\[\]]/g, "\\$&");
    let url = window.location.href;
    let regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)");
    let results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return "";
    return decodeURIComponent(results[2].replace(/\+/g, " "));
  },

  fnsavedata: function (component, event, helper) {
    let objcon = component.get("v.wrpcon");
    let accountid = component.get("v.AccountId");
    let contactid = component.get("v.ContactId");
    let batchid = component.get("v.selectedBatchId");

    let pagenumer = component.get("v.pagenumber");
    let daynumber = component.get("v.pagenumberday");

    let isrecommendreport = component.get("v.IsRecommendationReport");

    objcon.isRecommendationReport = isrecommendreport;
    objcon.accountid = accountid;
    objcon.contactid = contactid;
    objcon.batchid = batchid;
    objcon.pagenumber = pagenumer;
    objcon.daynumber = daynumber;

    var action = component.get("c.savecontact");
    action.setParams({ JSONWrapClass: JSON.stringify(objcon) });
    action.setCallback(this, function (response) {
      var state = response.getState();

      if (state == "SUCCESS") {
        $A.get("e.force:refreshView").fire();
        let objpagemsg = component.get("v.pageConstant");

        let message = objpagemsg.msg;

        if (pagenumer == 2 && daynumber == 1) {
          message = "See you in the Antarang CareerAware class tomorrow!";
        } else if (pagenumer == 2 && daynumber == 2) {
          message = "Congratulations! You made your first career plan!";
        }

        helper.showMessageToast(component, event, helper, message, "success");
      } else if (state === "ERROR") {
        let errors = response.getError();
        let message = "Unknown error"; // Default error message
        // Retrieve the error message sent by the server
        if (errors && Array.isArray(errors) && errors.length > 0) {
          message = errors[0].message;
        }
        helper.showMessageToast(component, event, helper, message, "error");
      }
    });
    $A.enqueueAction(action);
  }
});