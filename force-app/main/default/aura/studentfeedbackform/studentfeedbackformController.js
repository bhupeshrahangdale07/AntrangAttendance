({
  doInit: function (component, event, helper) {
    helper.objpageconstant(component, event, helper);

    helper.objinit(component, event, helper);
    let objui = {};
    objui.accountQName = "School";
    objui.contactQName = "Student Name";
    objui.batchQName = "Choose your batch";
    component.set("v.objUI", objui);

    let beforetenYearFromNow = new Date();
    beforetenYearFromNow.setFullYear(beforetenYearFromNow.getFullYear() - 10);
    let formatdate = $A.localizationService.formatDate(
      beforetenYearFromNow,
      "yyyy-MM-dd"
    );
    component.set("v.maxdate", formatdate);

    helper.onAttendanceDaySelected(component, event, helper);
  },

  pagenumber: function (component, event, helper) {
    helper.objinit(component, event, helper);
    helper.fnGetMappingTable(component, event, helper);
  },

  onwrpEventUpdate: function (component, event, helper) {
    console.log("--- onwrpEventUpdate: ");

    let sObject = event.getParam("sObject");

    if (sObject == "Account") {
      let accountId = event.getParam("AccountId");
      console.log("AccountId: " + accountId);
      component.set("v.AccountId", accountId);
      component.set(
        "v.StudentWhareClause",
        " AND Batch_Code__r.School_Name__c = '" +
          accountId +
          "' AND day_only(Batch_Code__r.Date_of_facilitation_starting__c) >= 2020-05-01 ORDER BY NAME"
      );
    }

    let contactId;
    if (sObject == "Contact") {
      //debugger;
      contactId = event.getParam("ContactId");
      console.log("contactId: " + contactId);
      component.set("v.ContactId", contactId);
    }

    if (contactId) {
      helper.fnGetAccountbatches(component);
    }
  },

  onBatchNumberSelect: function (component, event, helper) {
    let batchId = component.get("v.selectedBatchId");
    console.log("Selected Batch Id: " + batchId);
    component.set("v.StudentIdentified", true);
  },

  savedata: function (component, event, helper) {
    let checkdatavalidate = component.find("datavalidate");
    let validExpense = false;
    if (checkdatavalidate) {
      validExpense = component
        .find("datavalidate")
        .reduce(function (validSoFar, inputCmp) {
          // Displays error messages for invalid fields
          inputCmp.showHelpMessageIfInvalid();
          return validSoFar && inputCmp.get("v.validity").valid;
        }, true);
    }
    let objwrpcon = component.get("v.wrpcon");
    let beforetenYearFromNow = new Date();
    beforetenYearFromNow.setFullYear(beforetenYearFromNow.getFullYear() - 10);

    let accountid = component.get("v.AccountId");
    let contactid = component.get("v.ContactId");
    let batchid = component.get("v.selectedBatchId");
    let pagenumberday = component.get("v.pagenumberday");
    let objui = component.get("v.objUI");

    let pgnumber = component.get("v.pagenumber");

    if (accountid == undefined || accountid == null || accountid == "") {
      helper.showMessageToast(
        component,
        event,
        helper,
        "Please fill " + objui.accountQName.toLowerCase() + ".",
        "error"
      );
    } else if (contactid == undefined || contactid == null || contactid == "") {
      helper.showMessageToast(
        component,
        event,
        helper,
        "Please fill " + objui.contactQName.toLowerCase() + ".",
        "error"
      );
    } else if (
      objwrpcon.dob != undefined &&
      objwrpcon.dob != null &&
      Date.parse(objwrpcon.dob) > beforetenYearFromNow.getTime()
    ) {
      helper.showMessageToast(
        component,
        event,
        helper,
        "Please click the calendar and choose your correct birthday!",
        "error"
      );
    } else if (
      (batchid == undefined || batchid == null || batchid == "") &&
      pgnumber > 1
    ) {
      helper.showMessageToast(
        component,
        event,
        helper,
        "Please fill " + objui.batchQName.toLowerCase() + ".",
        "error"
      );
    } else if (
      (pagenumberday == undefined ||
        pagenumberday == null ||
        pagenumberday == "") &&
      pgnumber > 1
    ) {
      helper.showMessageToast(
        component,
        event,
        helper,
        "Please choose your days!",
        "error"
      );
    } else if (validExpense) {
      helper.fnsavedata(component, event, helper);
    } else {
      helper.showMessageToast(
        component,
        event,
        helper,
        "Please fill all required fields.",
        "error"
      );
    }
  },

  checkIsbatchinfuture: function (component, event, helper) {
    let lst = component.get("v.AccountBatches");
    let objselectedbatchid = component.get("v.selectedBatchId");
    let isbatchinfuture = false;

    lst.forEach((a) => {
      if (objselectedbatchid == a.Id) {
        let today = new Date().getTime();
        let dt = Date.parse(a.Facilitation_Start_Date__c);
        if (today < dt) {
          isbatchinfuture = true;
        }
      }
    });

    if (isbatchinfuture) {
      helper.showMessageToast(
        component,
        event,
        helper,
        "Your CareerAware program will be starting soon. If your program has already started please ask your Antarang teacher for the correct batchcode and mark it carefully.",
        "error"
      );
    }

    component.set("v.issubmitdisabled", isbatchinfuture);
  },

  showSpinner: function (component, event, helper) {
    // make Spinner attribute true for display loading spinner
    component.set("v.Spinner", true);
  },

  // this function automatic call by aura:doneWaiting event
  hideSpinner: function (component, event, helper) {
    // make Spinner attribute to false for hide loading spinner
    component.set("v.Spinner", false);
  }
});