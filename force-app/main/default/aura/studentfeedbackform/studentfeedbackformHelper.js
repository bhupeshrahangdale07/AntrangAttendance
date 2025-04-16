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
      pageConstant.page2start1 =
        'We learnt about the first 3 steps (Interest, Aptitude and Reality) of choosing our career. <div class="slds-text-heading_medium slds-m-top_small"> <b>If you were present , select your Interest, Aptitude and Reality. If you were absent, read the explanation and mark your interest aptitude and reality.</b></div>';
    } else if (langparam == "hin") {
      pageConstant.submitlabel = "यहाँ पर क्लिक करे पेज छोड़ने से पहले!";
      pageConstant.submitbutton = "प्रस्तुत";
      pageConstant.msg =
        "बहुत बढ़िया! आप अपने करियर की योजना बनाने के एक कदम करीब हैं।";
      pageConstant.page2start1 =
        'हमने अपना करियर चुनने के पहले 3 चरणों (रुचि, योग्यता और वास्तविकता) के बारे में सीखा।  <div class="slds-text-heading_medium slds-m-top_small"> <b> यदि आप मौजूद थे, तो अपनी रुचि, योग्यता और वास्तविकता का चयन करें।  यदि आप अनुपस्थित थे, तो स्पष्टीकरण पढ़ें और अपनी रुचि योग्यता और वास्तविकता को चिह्नित करें।</b></div>';
    } else if (langparam == "mar") {
      pageConstant.submitlabel = "हे page सोडायच्या आधी कृपया येथे क्लिक करा!";
      pageConstant.submitbutton = "सबमिट करा";
      pageConstant.msg =
        "मस्त! आपण आपल्या करिअरच्या नियोजनाच्या अगदी जवळ एक पाऊल आहे.";
      pageConstant.page2start1 =
        'आपण आपले करिअर निवडण्याच्या पहिल्या 3 टप्प्यांबद्दल (आवड, योग्यता आणि वास्तव) शिकलो. <div class="slds-text-heading_medium slds-m-top_small"> <b> आपण उपस्थित असल्यास आपली आवड, योग्यता आणि वास्तव निवडा.  आपण अनुपस्थित असल्यास, स्पष्टीकरण वाचा आणि आपली रुची, योग्यता आणि वास्तविकता चिन्हांकित करा.</b></div>';
    }

    this.fillpage2days(component, event, helper, langparam);

    component.set("v.pageConstant", pageConstant);
  },
  objinit: function (component, event, helper) {
    let c = {};
    c.whohaveyoutalked = [];
    c.dob = "";
    c.mothereducation = "";
    c.fathereduction = "";

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
    component.set("v.wrpcon", c);
  },

  onAttendanceDaySelected: function (component, event, helper) {
    helper.fnGetMappingTable(component, event, helper);
  },

  fillpage2days: function (component, event, helper, lang) {
    let lstdays = [];
    if (lang == "eng") {
      lstdays = [
        { label: "Choose one...", value: "" },
        { label: "Form 1 - Knowing yourself", value: 1 },
        { label: "Form 2 - Making a career plan", value: 2 }
      ];
    } else if (lang == "hin") {
      lstdays = [
        { label: "Choose one...", value: "" },
        { label: "फॉर्म 1 - खुद को जानना", value: 1 },
        { label: "फॉर्म 2 - करियर प्लान बनाना", value: 2 }
      ];
    } else if (lang == "mar") {
      lstdays = [
        { label: "Choose one...", value: "" },
        { label: "फॉर्म 1 - स्वत: ला जाणून घेणे", value: 1 },
        { label: "फॉर्म 2 - करिअरची योजना बनविणे", value: 2 }
      ];
    }
    component.set("v.Days", lstdays);
  },

  fnGetMappingTable: function (component, event, helper) {
    let selectedDays = "";
    let paramday = component.get("v.pagenumberday");
    let param = this.getParameterByName("page");
    if (param) {
      component.set("v.pagenumber", parseInt(param));

      if (param == 1) {
        selectedDays = "Identifier";
      } else if (param == 2 && parseInt(paramday) == 1) {
        selectedDays = "Day-1";
      } else if (param == 2 && parseInt(paramday) == 2) {
        selectedDays = "Day-2";
        helper.fillpage2table(component, event, helper);
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

        if (langparam == "eng") {
          objui.accountQName =
            "Type the first 4 letters of your school name, then wait for different school names appear, please select your school name from that list. DO NOT type the whole school name.";
          objui.contactQName =
            "Type the first 4 letters of your name, then wait for different names appear, please select your name from that list. DO NOT type your whole name.";
          objui.batchQName =
            "Please choose the batch code shared by your Antarang Teacher";
          objui.formQName =
            "Please select the form you are filling today. Ask the Antarang Teacher if you are not sure.";
        } else if (langparam == "hin") {
          objui.accountQName =
            "अपने स्कूल के नाम के पहले 4 अक्षरों को टाइप करें, फिर अलग-अलग स्कूल नामों के लिए प्रतीक्षा करें, कृपया उस सूची से अपने स्कूल का नाम चुनें। पूरे स्कूल का नाम न लिखें।";
          objui.contactQName =
            "अपने नाम के पहले 4 अक्षर टाइप करें, फिर विभिन्न नामों के प्रकट होने की प्रतीक्षा करें, कृपया उस सूची से अपना नाम चुनें। अपना पूरा नाम न लिखें।";
          objui.batchQName =
            "कृपया अपने अंतरंग शिक्षक द्वारा भेजा गया बैच कोड चुनें";
          objui.formQName =
            "आज आप जिस फॉर्म को भर रहे हैं, उसका चयन करें।  अगर आप निश्चित नाही हो तो अंतरंग शिक्षक से पूछें।";
        } else if (langparam == "mar") {
          objui.accountQName =
            "आपल्या शाळेच्या नावाची पहिली 4 अक्षरे टाइप करा, त्यानंतर वेगवेगळ्या शाळेची नावे दिसण्यासाठी प्रतीक्षा करा, कृपया त्या सूचीमधून आपल्या शाळेचे नाव निवडा. संपूर्ण शाळेचे नाव टाइप करू नका.";
          objui.contactQName =
            "आपल्या नावाची प्रथम 4 अक्षरे टाइप करा, नंतर भिन्न नावे दिसण्यासाठी प्रतीक्षा करा, कृपया त्या सूचीमधून आपले नाव निवडा. आपले संपूर्ण नाव टाइप करू नका.";
          objui.batchQName =
            "कृपया आपल्या अंतरंग शिक्षकांनी  सांगितलेला बॅच कोड निवडा";
          objui.formQName =
            "कृपया आपण आज भरत असलेला फॉर्म निवडा.  जर आपल्याला खात्री नसेल तर अंतरंग शिक्षकास विचारा.";
        }

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

  fillpage2table: function (component, event, helper) {
    let langparam = helper.getParameterByName("lang");
    if (langparam == undefined || langparam == null) {
      langparam = "eng";
    }

    let objaboutu = {};
    if (langparam == "eng") {
      objaboutu.aboutu = "About you";
      objaboutu.yourinterestcode = "Your Interest Code";
      objaboutu.youraptitudecode = "Your Aptitude Code";
      objaboutu.yourrealities = "Your Realities";
      objaboutu.careers =
        "Careers that match your interest, aptitude and reality";
    } else if (langparam == "hin") {
      objaboutu.aboutu = "आपके बारे में";
      objaboutu.yourinterestcode = "आपकी रुचि कोड";
      objaboutu.youraptitudecode = "आपका योग्यता कोड";
      objaboutu.yourrealities = "आपकी वास्तविकताएँ";
      objaboutu.careers =
        "करियर जो आपकी रुचि, योग्यता और वास्तविकता से मेल खाते हैं";
    } else if (langparam == "mar") {
      objaboutu.aboutu = "आपल्याबद्दल";
      objaboutu.yourinterestcode = "आपला रुचि कोड";
      objaboutu.youraptitudecode = "आपला योग्यता कोड";
      objaboutu.yourrealities = "आपल्या वास्तविकता";
      objaboutu.careers = "आपली रुचि, योग्यता आणि वास्तविकता जुळणारे करिअर";
    }
    component.set("v.objpage2tableUI", objaboutu);

    let contactid = component.get("v.ContactId");
    let action = component.get("c.findDay1Data");
    action.setParams({
      contactid: contactid,
      lang: langparam
    });

    action.setCallback(this, function (response) {
      let state = response.getState();
      if (state === "SUCCESS") {
        var res = response.getReturnValue();

        component.set("v.objpage2", res.objcon);

        var objaboutuvalue = component.get("v.objpage2tableUI");

        let objui = {};
        res.lstfeedback.forEach((i) => {
          if (i.Field_Label__c == "Interest 1") {
            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Interest_1__c) {
                objaboutuvalue.interest1 = o.Form_value__c;
              }
            });
          }

          if (i.Field_Label__c == "Interest 2") {
            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Interest_2__c) {
                objaboutuvalue.interest2 = o.Form_value__c;
              }
            });
          }

          if (i.Field_Label__c == "Interest 3") {
            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Interest_3__c) {
                objaboutuvalue.interest3 = o.Form_value__c;
              }
            });
          }

          if (i.Field_Label__c == "Aptitude 1") {
            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Aptitude_1__c) {
                objaboutuvalue.aptitude1 = o.Form_value__c;
              }
            });
          }

          if (i.Field_Label__c == "Aptitude 2") {
            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Aptitude_2__c) {
                objaboutuvalue.aptitude2 = o.Form_value__c;
              }
            });
          }

          if (i.Field_Label__c == "Aptitude 3") {
            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Aptitude_3__c) {
                objaboutuvalue.aptitude3 = o.Form_value__c;
              }
            });
          }

          if (i.Field_Label__c == "Reality 1 Self 1") {
            objui.Reality1Self1QName = i.Question_Label__c;
            objui.Reality1Self1ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );

            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Reality1Self__c) {
                objaboutuvalue.reality1 = o.Form_value__c;
              }
            });
          }

          if (i.Field_Label__c == "Reality 2 Self 2") {
            objui.Reality2Self2QName = i.Question_Label__c;
            objui.Reality2Self2ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Reality2Self__c) {
                objaboutuvalue.reality2 = o.Form_value__c;
              }
            });
          }

          if (i.Field_Label__c == "Reality 3 Self 3") {
            objui.Reality3Self3QName = i.Question_Label__c;
            objui.Reality3Self3ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Reality3Self__c) {
                objaboutuvalue.reality3 = o.Form_value__c;
              }
            });
          }

          if (i.Field_Label__c == "Reality 4 Self 4") {
            objui.Reality4Self4QName = i.Question_Label__c;
            objui.Reality4Self4ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Reality4Self__c) {
                objaboutuvalue.reality4 = o.Form_value__c;
              }
            });
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
            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Reality1Family__c) {
                objaboutuvalue.realityfamily1 = o.Form_value__c;
              }
            });
          }

          if (i.Field_Label__c == "Reality 6 Family 2") {
            objui.Reality6Family2QName = i.Question_Label__c;
            objui.Reality6Family2ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Reality2Family__c) {
                objaboutuvalue.realityfamily2 = o.Form_value__c;
              }
            });
          }

          if (i.Field_Label__c == "Reality 7 Family 3") {
            objui.Reality7Family3QName = i.Question_Label__c;
            objui.Reality7Family3ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Reality3Family__c) {
                objaboutuvalue.realityfamily3 = o.Form_value__c;
              }
            });
          }

          if (i.Field_Label__c == "Reality 8 Family 4") {
            objui.Reality8Family4QName = i.Question_Label__c;
            objui.Reality8Family4ndata = this.findoptiondata(
              i.Picklist_Mappings__r,
              false
            );
            i.Picklist_Mappings__r.forEach((o) => {
              if (o.SF_Value__c == res.objcon.Reality4Family__c) {
                objaboutuvalue.realityfamily4 = o.Form_value__c;
              }
            });
          }
        });

        res.lstallrecommendation.forEach((i) => {
          if (i.Field_API__c == "Current_Aspiration__c") {
            let careearval = res.objcon.All_Recommendation__c;
            if (
              careearval != undefined &&
              careearval != null &&
              careearval != ""
            ) {
              let arrcareearval = res.objcon.All_Recommendation__c.split(",");
              arrcareearval.forEach((c) => {
                let cval = c.trim();
                i.Picklist_Mappings__r.forEach((o) => {
                  if (o.SF_Value__c == cval) {
                    if (objaboutuvalue.careersvalue) {
                      objaboutuvalue.careersvalue += ", " + o.Form_value__c;
                    } else {
                      objaboutuvalue.careersvalue = o.Form_value__c;
                    }
                  }
                });
              });
            }
          }
        });

        component.set("v.objpage2UI", objui);
        component.set("v.objpage2tableUI", objaboutuvalue);
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

        let langparam = helper.getParameterByName("lang");
        if (langparam == undefined || langparam == null) {
          langparam = "eng";
        }

        if (pagenumer == 2 && daynumber == 1) {
          if (langparam == "eng") {
            message = "See you in the Antarang CareerAware class tomorrow!";
          } else if (langparam == "hin") {
            message = "कल अंतरंग के CareerAware क्लास में मिलते हैं!";
          } else if (langparam == "mar") {
            message = "उद्याच्या अंतरंग CareerAware वर्गात भेटू!";
          }
        } else if (pagenumer == 2 && daynumber == 2) {
          if (langparam == "eng") {
            message = "Congratulations! You made your first career plan!";
          } else if (langparam == "hin") {
            message = "बधाई! आपने अपना पहला करियर प्लान बनाया!";
          } else if (langparam == "mar") {
            message = "अभिनंदन! आपण आपली करिअरची पहिली योजना बनविली!";
          }
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