import { LightningElement, track, wire } from 'lwc';
import OnTime_Icon from "@salesforce/resourceUrl/sessionIconOnTime";
import Reschedule_Icon from "@salesforce/resourceUrl/sessionIconReschedule";
import Lateschedule_Icon from "@salesforce/resourceUrl/sessionIconLateSchedule";
import { CurrentPageReference } from 'lightning/navigation';
import getPendingSessionData from '@salesforce/apex/SessionDetailController.getPendingSessionData';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getdynamicpicklistval from '@salesforce/apex/SessionDetailController.getdynamicpicklistval';
import getBatch from '@salesforce/apex/SessionDetailController.getBatch';
import sessionSignOut from '@salesforce/apex/SessionDetailController.sessionSignOut';
import getSchoolList from '@salesforce/apex/SessionDetailController.getSchoolList';
import lstsessionRecords from '@salesforce/apex/SessionDetailController.lstsessionRecords';
import sessionStudentData from '@salesforce/apex/SessionDetailController.getSessionStudent';
import saveLateSchedule from '@salesforce/apex/SessionDetailController.saveLateSchedule';
import saveStudentAttendance from '@salesforce/apex/SessionDetailController.saveStudentAttendance';
import FORM_FACTOR from "@salesforce/client/formFactor";

import { NavigationMixin } from "lightning/navigation";
let options = [
    { "label": "No School Found", "value": "" }
];

export default class SessionDetail extends NavigationMixin(LightningElement) {
    inactivityTimeout;
    indSessionId;
    indSessionLead;
    showIndividualStudent = false;
    OnTimeScheduleIcon = OnTime_Icon;
    reScheduleIcon = Reschedule_Icon;
    lateScheduleIcon = Lateschedule_Icon;
    @track activeChildSession = [];
    @track hasParentSessions = false;
    @track hasParentSessions = false;
    @track hasStudentSessions = false;
    @track hasFlexibleSessions = false;
    @track hasCounselingSessions = false;
    @track options = options;
    flagIndicatingDataHasBeenLoadedInVariables = false;
    grade;
    @track schoolId = '';
    @track isShowModal = true;
    facEmailId;
    showLoading = false;
    showLoadingModal = true;
    @track sessionList = [];
    @track editedStudent = false;
    @track optionsSessionLead;
    showPendingSession;

    batchOption = [];
    gradeOption = [];
    grade;
    batch;
    code;
    activeSectionsMessage = '';
    activeSections = ['flexibleSession', 'studentSession', 'parentSession', 'individualCounsellingSession'];
    showParentSessionStatus = false;
    showCounsellingSessionStatus = false;
    CounsellingSessionStatusValue = '';
    CounsellingSessionStatusClass = '';
    ParentSessionStatusValue = '';
    ParentSessionStatusClass = '';
    @track parentSessions = [];
    @track studentSessions = [];
    @track counselingSessions = [];
    @track flexibleSessions = [];
    @track indStudentData;
    isShowModalForLateSchedule = false;
    @track lateScheduleReasonOption;
    @track lateScheduleSessions;
    @track allSessions;
    @track reasonForLateSch = '';

    handleSessionLead(event) {
        this.editedStudent = true;
        const studentId = event.target.dataset.studentId;
        const selectedValue = event.detail.value;

        // Update the corresponding student's attendance in the array
        /*this.indStudentData = this.indStudentData.map(student => {
            if (student.studentId === studentId) {
                return { ...student, stdLead: selectedValue };
            }
            return student;
        });*/
        const isFilled = val => val !== null && val !== undefined && val !== '';
        this.indStudentData = this.indStudentData.map(student => {
            if (student.studentId === studentId) {
                student.stdLead = selectedValue;

                const lead = student.stdLead;
                const att = student.stdAttendance;
                const par = student.parentAttendance;

                /*const anySelected = (lead && lead !== '') || (att && att !== '') || (par && par !== '');
                if(anySelected === ''){
                    anySelected = false;
                }*/
                const anySelected = isFilled(lead && lead !== '') || isFilled(att && att !== '') || isFilled(par && par !== '');

                student.leadRequired = anySelected;
                student.stdAttendRequired = anySelected;
                student.parAttRequired = anySelected;
            }
            return student;
        });
    }
    handleParentAttendanceChange(event) {
        this.editedStudent = true;
        const studentId = event.target.dataset.studentId;
        const selectedValue = event.detail.value;

        // Update the corresponding student's attendance in the array
        /*this.indStudentData = this.indStudentData.map(student => {
            if (student.studentId === studentId) {
                return { ...student, parentAttendance: selectedValue };
            }
            return student;
        });*/
        const isFilled = val => val !== null && val !== undefined && val !== '';
        this.indStudentData = this.indStudentData.map(student => {
            if (student.studentId === studentId) {
                student.parentAttendance = selectedValue;

                const lead = student.stdLead;
                const att = student.stdAttendance;
                const par = student.parentAttendance;

                /*const anySelected = (lead && lead !== '') || (att && att !== '') || (par && par !== '');
                if(anySelected === ''){
                    anySelected = false;
                }*/
                const anySelected = isFilled(lead && lead !== '') || isFilled(att && att !== '') || isFilled(par && par !== '');

                student.leadRequired = anySelected;
                student.stdAttendRequired = anySelected;
                student.parAttRequired = anySelected;
            }
            return student;
        });
    }

    handleAttendanceChange(event) {
        this.editedStudent = true;
        const studentId = event.target.dataset.studentId;
        const selectedValue = event.detail.value;

        // Update the corresponding student's attendance in the array
        /*this.indStudentData = this.indStudentData.map(student => {
            if (student.studentId === studentId) {
                return { ...student, stdAttendance: selectedValue };
            }
            return student;
        });*/

        this.counselingSessions.forEach((sess) => {
            let pastTime = this.isExactMatch(sess.sessionDate, sess.startTime);
                    if (pastTime) {
                        this.indStudentData = this.indStudentData.map(student => {
                            if (student.studentId == studentId && student.sessionId == sess.id) {
                                return { ...student, stdCounselingDate: sess.sessionDate ,stdCounselingTime: sess.startTime};
                            }
                            return student;
                        });
                    }
        });
        

        const isFilled = val => val !== null && val !== undefined && val !== '';
        this.indStudentData = this.indStudentData.map(student => {
            if (student.studentId === studentId) {
                student.stdAttendance = selectedValue;

                const lead = student.stdLead;
                const att = student.stdAttendance;
                const par = student.parentAttendance;

                /*const anySelected = (lead && lead !== '') || (att && att !== '') || (par && par !== '');
                if(anySelected === ''){
                    anySelected = false;
                }*/
                const anySelected = isFilled(lead && lead !== '') || isFilled(att && att !== '') || isFilled(par && par !== '');
                student.leadRequired = anySelected;
                student.stdAttendRequired = anySelected;
                student.parAttRequired = anySelected;
            }
            return student;
        });
    }

    handleWrongBatch(event) {
        this.editedStudent = true;
        this.isWrongBatchChecked = event.target.checked;
        const studentIdValue = event.target.dataset.studentId;

         this.counselingSessions.forEach((sess) => {
            let pastTime = this.isExactMatch(sess.sessionDate, sess.startTime);
                    if (pastTime) {
                        this.indStudentData = this.indStudentData.map(student => {
                            if (student.studentId == studentIdValue && student.sessionId == sess.id) {
                                return { ...student, stdCounselingDate: sess.sessionDate ,stdCounselingTime: sess.startTime};
                            }
                            return student;
                        });
                    }
        });

        this.indStudentData = this.indStudentData.map(student => {
            if (student.studentId == studentIdValue) {
                return { ...student, stdWrongBatch: event.target.checked, stdAttendance: "", stdLead: "", parentAttendance: "" };
            }
            return student;
        });
        

    }

    onclickCancel(event) {
        this.isShowModalForLateSchedule = false;
        this.lateScheduleSessions.forEach(session => {
            session.reasonForLateSchedule = '';
            session.scheduleLate = false;
            session.editedDateTime = true;
            session.sessionDate = null;
            session.startTimeFormatted = null;
            session.startTime = null;
        });
        const lateScheduleSessionsIds = new Set(this.lateScheduleSessions.map(fs => fs.id));


        const updateLateScheduleReason = (sessions) => {
            sessions.forEach(session => {
                if (lateScheduleSessionsIds.has(session.id)) {
                    session.reasonForLateSchedule = '';
                    session.scheduleLate = false;
                    session.editedDateTime = true;
                    session.sessionDate = null;
                    session.startTimeFormatted = null;
                    session.startTime = null;
                }
            });
        };

        // Just call the function — no reassignment needed
        updateLateScheduleReason(this.flexibleSessions);
        updateLateScheduleReason(this.studentSessions);
        updateLateScheduleReason(this.parentSessions);
        updateLateScheduleReason(this.counselingSessions);
    }
    onclickOk(event) {
        // let sessionIdVal = event.target.dataset.id;
        // let reasonValue = this.template.querySelector('lightning-combobox[data-id = '+sessionIdVal+']').value;
        // console.log('reasonValue= '+reasonValue);
        const hasMissingReason = this.lateScheduleSessions.some(session => !session.reasonForLateSchedule);
        if (hasMissingReason) {
            this.showToastMessage('Please select a reason for all late scheduled sessions.', 'error');
        } else {
            this.showLoading = true;
            this.isShowModalForLateSchedule = false;
            this.saveLateScheduleFunc();
        }


    }

    saveLateScheduleFunc() {
        /*console.log(' this.flexibleSessions = ', this.flexibleSessions);
        const sessionsToUpdate = this.flexibleSessions.map(sess => {
            var scheduleCounter;
            if(sess.editedDateTime == true){
                scheduleCounter = sess.scheduleCounter+1;
            }else{
                scheduleCounter = sess.scheduleCounter;
            }
            console.log('scheduleCounter = ',scheduleCounter);
            return {
                Id: sess.id,
                Late_Schedule__c: sess.reasonForLateSchedule,
                Scheduling_Type__c: sess.scheduleLate ? 'Late Schedule' : (sess.scheduleOnTime ? 'On Time' : null),
                Session_Start_Time__c: sess.startTime,
                SessionDate__c:sess.sessionDate,
                Session_Status__c:'Scheduled',
                Rescheduled_Counter__c : scheduleCounter
            };
        });*/
        //let emptyField = [];
        const buildUpdatedSessions = (sessions) => {
            return sessions.map(sess => {
                if (!sess.isCounselingSession) {
                    let isReady = false;

                    if (sess.isStudentSession) {
                        isReady = sess.hmAttended !== '' && sess.sessionLead !== '' && sess.studentAttendance !== '';
                    } else if (sess.isParentSession) {
                        isReady = sess.hmAttended !== '' && sess.sessionLead !== '' && sess.studentAttendance !== '' && sess.parentAttendance !== '';
                    } else if (sess.isFlexibleSession) {
                        isReady = sess.studentAttendance !== '';
                    }

                    sess.paymentStatus = isReady ? 'Ready For Payment' : '';

                    // if (sess.isStudentSession) {
                    //     const filledCount = [sess.hmAttended, sess.sessionLead, sess.studentAttendance].filter(val =>  String(val).trim() !== '').length;

                    //     if (filledCount > 0 && filledCount < 3) {
                    //         emptyField.push(sess);
                    //     }
                    // } else if (sess.isParentSession) {
                    //    const filledCount = [sess.hmAttended, sess.sessionLead, sess.studentAttendance, sess.parentAttendance].filter(val =>  String(val).trim() !== '').length;

                    //     if (filledCount > 0 && filledCount < 4) {
                    //         emptyField.push(sess);
                    //     }
                    // }

                    let scheduleCounter = sess.editedDateTime === true ? (sess.scheduleCounter + 1) : sess.scheduleCounter;
                   
                    if ((sess.startTime == '' || sess.sessionDate == '') || (sess.startTime == null || sess.sessionDate == null)) {
                        return {
                            Id: sess.id,
                            Late_Schedule__c: sess.reasonForLateSchedule,
                            Scheduling_Type__c: '',
                            Session_Start_Time__c: sess.startTime,
                            SessionDate__c: sess.sessionDate,
                            Session_Status__c: 'Unscheduled',
                            Rescheduled_Counter__c: scheduleCounter
                        };
                    } else {
                        return {
                            Id: sess.id,
                            Late_Schedule__c: sess.reasonForLateSchedule,
                            Scheduling_Type__c: sess.scheduleLate ? 'Late Schedule' : 'On Time',
                            Session_Start_Time__c: sess.startTime,
                            SessionDate__c: sess.sessionDate,
                            Session_Status__c: sess.status,
                            Rescheduled_Counter__c: scheduleCounter,
                            HM_Attended__c: sess.hmAttended,
                            Session_Lead__c: sess.sessionLead,
                            Total_Student_Present__c: sess.studentAttendance,
                            Total_Parent_Present__c: sess.parentAttendance,
                            Payment_Status__c: sess.paymentStatus
                        };
                    }
                } else {
                    const count = this.indStudentData.filter(item => item.stdAttendance !== "" || item.stdWrongBatch == true).length;
                    if (count == this.indStudentData.length) {
                        sess.paymentStatus = 'Ready For Payment'
                        sess.status = 'Complete';
                    } else if (count > 0 && this.editedStudent == true) {
                        sess.sessionDate = '';
                        sess.startTime = '';
                        sess.status = 'Incomplete';
                    } else {
                        sess.status = 'Incomplete';
                    }
                    // let pastTime = this.isExactMatch(sess.sessionDate, sess.startTime);
                    // console.log('pastTime con- ' + pastTime);
                    // if (pastTime) {
                    //     this.indStudentData = this.indStudentData.map(student => {
                    //         if (student.studentId == sess.id) {
                    //             return { ...student, stdCounselingDate: sess.sessionDate ,stdCounselingTime: sess.startTime};
                    //         }
                    //         return student;
                    //     });
                    // }


                    let scheduleCounter = sess.editedDateTime === true ? (sess.scheduleCounter + 1) : sess.scheduleCounter;
                    if (sess.startTime == '' || sess.sessionDate == '') {
                        return {
                            Id: sess.id,
                            Late_Schedule__c: sess.reasonForLateSchedule,
                            Scheduling_Type__c: '',
                            Session_Start_Time__c: sess.startTime,
                            SessionDate__c: sess.sessionDate,
                            Session_Status__c: 'Incomplete',
                            Rescheduled_Counter__c: scheduleCounter
                        };
                    } else {
                    return {
                        Id: sess.id,
                        Late_Schedule__c: sess.reasonForLateSchedule,
                        Scheduling_Type__c: sess.scheduleLate ? 'Late Schedule' : 'On Time',
                        Session_Start_Time__c: sess.startTime,
                        SessionDate__c: sess.sessionDate,
                        Session_Status__c: sess.status,
                        Rescheduled_Counter__c: scheduleCounter,
                        HM_Attended__c: sess.hmAttended,
                        Session_Lead__c: sess.sessionLead,
                        Total_Student_Present__c: sess.studentAttendance,
                        Total_Parent_Present__c: sess.parentAttendance,
                        Payment_Status__c: sess.paymentStatus
                    };
                    }
                }

            });
        };

        const sessionsToUpdate = [
            ...buildUpdatedSessions(this.flexibleSessions),
            ...buildUpdatedSessions(this.counselingSessions),
            ...buildUpdatedSessions(this.parentSessions),
            ...buildUpdatedSessions(this.studentSessions)
        ];
        
        // if (emptyField.length > 0) {
        //     this.showToastMessage('Please fill all required fields', 'error');
        // } else {
            saveLateSchedule({ sessionList: sessionsToUpdate })
                .then((result) => {
                    if (result == true) {
                        this.saveStudentAttendanceFunc()

                    }
                    //this.showLoading = false;


                })
                .catch((Error) => {
                    this.showToastMessage(JSON.stringify(Error), 'error');
                    console.log('Error =' + Error);
                    console.log('Error= ' + JSON.stringify(Error));
                })
        //}
    }
    handleLateScheduleChange(event) {
        const sessionId = event.target.dataset.id; // Get the session ID
        const newReason = event.detail.value; // Get the new selected reason value
        this.reasonForLateSch = event.detail.value;
        // Update lateScheduleSessions by finding the session with the matching ID and updating its reason
        /*this.flexibleSessions = this.flexibleSessions.map(session => {
            if (session.id === sessionId) {
                // Return updated session with the new reason
                return { ...session, reasonForLateSchedule: newReason,scheduleLate: true };
            }else{
                return { ...session,scheduleOnTime: true };
            }
            return session; // Return other sessions unchanged
        });
        
        console.log('Updated flexibleSessions:', this.flexibleSessions);*/
        const updateLateScheduleReason = (sessions) => {
            return sessions.map(session => {
                if (session.id === sessionId) {
                    return { ...session, reasonForLateSchedule: newReason, scheduleLate: true };
                } else {
                    return { ...session, scheduleOnTime: true };
                }
            });
        };

        this.flexibleSessions = updateLateScheduleReason(this.flexibleSessions);
        this.counselingSessions = updateLateScheduleReason(this.counselingSessions);
        this.parentSessions = updateLateScheduleReason(this.parentSessions)
        this.studentSessions = updateLateScheduleReason(this.studentSessions)
        this.lateScheduleSessions = updateLateScheduleReason(this.lateScheduleSessions)
    }
    handleSave(event) {
        /*this.flexibleSessions.forEach(session => {
            if(session.editedDateTime === true){
                const sessionDate = session.sessionDate;
                const startTime = session.startTime;

                // Combine session date and time into a single Date object
                const sessionDateTime = new Date(`${sessionDate}T${startTime}`);

                // Get the current date and time
                const now = new Date();

                // Calculate the difference in milliseconds
                const diffInMs = sessionDateTime - now;

                // Convert milliseconds to hours
                const diffInHours = diffInMs / (1000 * 60 * 60);
                console.log('diffInHours = ',diffInHours);
                if (diffInHours < 24 && diffInHours > 0) {
                    session.lateSchedule = true;
                    // Show popup and keep reason
                    console.log("Less than 24 hrs");
                }else{
                    session.lateSchedule = false;
                }
            }
        });
        this.counselingSessions.forEach(session => {
            if(session.editedDateTime === true){
                const sessionDate = session.sessionDate;
                const startTime = session.startTime;

                // Combine session date and time into a single Date object
                const sessionDateTime = new Date(`${sessionDate}T${startTime}`);

                // Get the current date and time
                const now = new Date();

                // Calculate the difference in milliseconds
                const diffInMs = sessionDateTime - now;

                // Convert milliseconds to hours
                const diffInHours = diffInMs / (1000 * 60 * 60);
                console.log('diffInHours = ',diffInHours);
                if (diffInHours < 24 && diffInHours > 0) {
                    session.lateSchedule = true;
                    // Show popup and keep reason
                    console.log("Less than 24 hrs");
                }else{
                    session.lateSchedule = false;
                }
            }
        });*/
        this.showLoading = true;
        const isValid = this.validate();
        if (!isValid) {
            this.showToastMessage('Please fill all required fields','error');
            this.showLoading = false; // Hide loader if validation fails
            return;
        }
        this.showLoading = false; 
        let lateSchedule = [];
        let lessThanOneHr = [];
        const markLateScheduledSessions = (sessions) => {
            const now = new Date();
            sessions.forEach(session => {
                if (session.editedDateTime === true) {
                    const sessionDate = session.sessionDate;
                    let startTime = session.startTime;
                    // Handle undefined, null, or 0 startTime
                    if (startTime === undefined || startTime === null || startTime == 0) {
                        // Set default time to midnight (00:00:00) if no time is provided
                        startTime = '00:00:00';
                    }
                    // else {
                    //     // Convert numeric time to HH:MM:SS format if needed
                    //     // Assuming startTime is in milliseconds since midnight
                    //     const hours = Math.floor(startTime / (1000 * 60 * 60));
                    //     const minutes = Math.floor((startTime % (1000 * 60 * 60)) / (1000 * 60));
                    //     startTime = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:00`;
                    // }

                    // Combine session date and time into a single Date object
                    //const sessionDateTime = new Date(`${sessionDate}T${startTime}`);
                    const inputDateTime = this.createDateTime(sessionDate, startTime);
                    // Get the current date and time
                    const now = new Date();
                    // if (session.pastTime) {
                    //     session.status = 'Ready for Attendance';
                    // }
                    const diffHours = this.calTimeDiff(session.oldDatevalue, session.oldTime);
                    if (diffHours < 1 && diffHours > 0) {
                        lessThanOneHr.push(session);
                    }
                    // Calculate the difference in milliseconds
                    const diffInMs = inputDateTime - now;

                    // Convert milliseconds to hours
                    const diffInHours = diffInMs / (1000 * 60 * 60);
                    if ((sessionDate == '' && startTime == '') || (sessionDate == null && startTime == '00:00:00')) {
                        session.lateSchedule = false;
                    } else {
                        //diffInHrs in minus use same condition
                        if (diffInHours < 24 && diffInHours > 0) {
                            session.lateSchedule = true;
                            session.scheduleLate = true;
                            lateSchedule.push(session);
                        } else if (diffInHours < 0) {
                            session.lateSchedule = true;
                            session.scheduleLate = true;
                            lateSchedule.push(session);
                        } else {
                            session.lateSchedule = false;
                        }
                    }
                    if (session.oldDatevalue == '' && session.oldTime == '' && session.scheduleCounter == 0) {
                        session.editedDateTime = false;
                    }
                    if (!session.isCounselingSession) {
                        session.status = 'Scheduled';
                    }
                    

                } else if (session.flexiRFA) {
                    session.status = 'Ready for Attendance';
                } else if (session.studRFA) {
                    session.status = 'Ready for Attendance';
                } if (session.parentRFA) {
                    session.status = 'Ready for Attendance';
                } else {
                    if (session.indAttentLink == true) {
                        session.status = 'Ready for Attendance';
                    }

                }
                if (session.pastTime && session.attendanceSubmitted == false) {
                    session.status = 'Ready for Attendance';
                }
                if (session.isCounselingSession) {
                    //this.saveStudentAttendanceFunc(session.Id);

                }
            });
        };

        // Apply to both arrays
        markLateScheduledSessions(this.flexibleSessions);
        markLateScheduledSessions(this.studentSessions);
        markLateScheduledSessions(this.parentSessions);
        markLateScheduledSessions(this.counselingSessions);

        let stdValidTime;
        let prtValidTime;
        let preStdSessionError = false;
        let preParntSessionError = false;
        /*this.studentSessions.forEach((sess, index) => {
            if (index != 0 && sess.startTime != "") {
                const prevSession = this.studentSessions[index - 1];
                const isSameDay = sess.sessionDate === prevSession.sessionDate;
                if (isSameDay) {
                    const seessStartTime = this.convertTimeToMinutes(sess.startTime);
                    const prevSessionTime = this.convertTimeToMinutes(prevSession.startTime);
                    const timeDiffMinutes = seessStartTime - prevSessionTime;
                    console.log('timeDiffMinutes- ' + timeDiffMinutes);
                    if (timeDiffMinutes < 40) {
                        stdValidTime = false;
                        //this.showToastMessage('Time must be greater than 40 min of previous session', 'error');
                    } else {
                        stdValidTime = true;
                    }
                } else {
                    stdValidTime = true;
                }
                if (prevSession.status == 'Unscheduled') {
                    preSessionError = true;

                } else {
                    preSessionError = false;
                }

            }
            else {
                stdValidTime = true;
            }
        }
        );*/

        for (let i = 0; i < this.studentSessions.length; i++) {
            if (i != 0 && this.studentSessions[i].startTime != "") {
                const prevSession = this.studentSessions[i - 1];
                const isSameDay = this.studentSessions[i].sessionDate === prevSession.sessionDate;
                if (isSameDay) {
                    const seessStartTime = this.convertTimeToMinutes(this.studentSessions[i].startTime);
                    const prevSessionTime = this.convertTimeToMinutes(prevSession.startTime);
                    const timeDiffMinutes = seessStartTime - prevSessionTime;
                    if (timeDiffMinutes < 40) {
                        stdValidTime = false;
                        this.showToastMessage('Minimum gap of 40 minutes is required between sessions’ Start Times', 'error');
                        break;
                    } else {
                        stdValidTime = true;
                    }
                } else {
                    stdValidTime = true;
                }
                if (prevSession.startTime == "" || prevSession.startTime == undefined) {
                    this.studentSessions[i].status = 'Unscheduled';
                    preStdSessionError = true;
                    this.showToastMessage('Please schedule the previous session first.', 'error');
                    break;

                } else {
                    preStdSessionError = false;
                }

            } else {
                stdValidTime = true;
            }
            if(i != this.studentSessions.length-1 && this.studentSessions[i].startTime != ""){
                const nextSession = this.studentSessions[i + 1];

                const currentDateTime = this.parseDateTime(this.studentSessions[i].sessionDate, this.studentSessions[i].startTime);
                const nextDateTime = this.parseDateTime(nextSession.sessionDate, nextSession.startTime);
                 if (currentDateTime > nextDateTime) {
                    this.showToastMessage('Current session Date Time cannot be later than the next session’ Date Time', 'error');
                    return;
                }
                const diffMinutes = (nextDateTime - currentDateTime) / (1000 * 60);

                // 4. Check 40-minute gap
                if (diffMinutes < 40) {
                    this.showToastMessage('Minimum gap of 40 minutes is required between sessions’ Start Times', 'error');
                    return;
                }
                
            }
        }


        for (let i = 0; i < this.parentSessions.length; i++) {
            if (i != 0 && this.parentSessions[i].startTime != "") {
                const prevSession = this.parentSessions[i - 1];
                const isSameDay = this.parentSessions[i].sessionDate === prevSession.sessionDate;
                if (isSameDay) {
                    const seessStartTime = this.convertTimeToMinutes(this.parentSessions[i].startTime);
                    const prevSessionTime = this.convertTimeToMinutes(prevSession.startTime);
                    const timeDiffMinutes = seessStartTime - prevSessionTime;
                    if (timeDiffMinutes < 40) {
                        prtValidTime = false;
                        this.showToastMessage('Minimum gap of 40 minutes is required between sessions’ Start Times', 'error');
                        break;
                    } else {
                        prtValidTime = true;
                    }
                } else {
                    prtValidTime = true;
                }
                if (prevSession.startTime == "" || prevSession.startTime == undefined) {
                    this.parentSessions[i].status = 'Unscheduled';
                    preParntSessionError = true;
                    this.showToastMessage('Please schedule the previous session first.', 'error');
                    break;

                } else {
                    preParntSessionError = false;
                }
            } else {
                prtValidTime = true;
            }
        }
        /*    this.parentSessions.forEach((sess, index) => {
                if (index != 0 && sess.startTime != "") {
                    const prevSession = this.parentSessions[index - 1];
                    const isSameDay = sess.sessionDate === prevSession.sessionDate;
                    if (isSameDay) {
                        const seessStartTime = this.convertTimeToMinutes(sess.startTime);
                        const prevSessionTime = this.convertTimeToMinutes(prevSession.startTime);
                        const timeDiffMinutes = seessStartTime - prevSessionTime;
                        console.log('timeDiffMinutes- ' + timeDiffMinutes);
                        if (timeDiffMinutes < 40) {
                            prtValidTime = false;
                            //this.showToastMessage('Time must be greater than 40 min of previous session', 'error');
                        } else {
                            prtValidTime = true;
                        }
                    } else {
                        prtValidTime = true;
                    }
                    if (prevSession.status == 'Unscheduled') {
                        preSessionError = true;
                        return;
    
                    } else {
                        preSessionError = false;
                    }
                } else {
                    prtValidTime = true;
                }
            }
            );*/

        if (lessThanOneHr.length > 0) {
            this.showToastMessage('Sorry, it is too late to change session schedule. Please see rules in Form Instructions.', 'error');
        } else {
            if (!preStdSessionError && !preParntSessionError) {
                if (stdValidTime == true && prtValidTime == true) {
                    //this.lateScheduleSessions = this.flexibleSessions.filter(session => session.lateSchedule === true);
                    this.lateScheduleSessions = lateSchedule;
                    if (this.lateScheduleSessions.length > 0) {
                        this.getdynamicpicklistvalFunc('Session__c', 'Late_Schedule__c');
                        this.isShowModalForLateSchedule = true;
                    } else {
                        this.saveLateScheduleFunc();
                    }
                } else {
                    this.showToastMessage('Minimum gap of 40 minutes is required between sessions’ Start Times', 'error');
                }
            }
        }

    }
    saveStudentAttendanceFunc(sessionId) {
        const dataToSend = this.indStudentData;

        saveStudentAttendance({
            studentAttendanceList: JSON.stringify(dataToSend),
            saveAttendance: false,
            sessionId: sessionId,
            reason: ''
        })
            .then(result => {
                if (result) {
                    this.showToastMessage('Record updated successfully!', 'success');
                    location.reload();
                } else {
                    //this.showToastMessage('Error While Save','error');
                }
                //this.isShowModal = false;
                //this.showLoading = false;
                //this.backToLogin();
                //this.showLoading = false;

            }).catch(error => {
                this.showToastMessage(error.body.message, 'error');
                console.log(error.body.message);
                //this.showLoading = false;
            });
    }

    convertTimeToMinutes(timeInput) {
        if (typeof timeInput === 'number') {
            // Handle milliseconds (Salesforce time field format)
            return Math.floor(timeInput / (1000 * 60));
        } else {
            // Handle "HH:MM" string format
            const [hours, minutes] = timeInput.split(':').map(Number);
            return (hours * 60) + minutes;
        }
    }

    createDateTime(dateString, timeString) {
        // Handle different time formats (HH:mm, HH:mm:ss, milliseconds since midnight)
        let timeValue = timeString;

        if (typeof timeString === 'number') {
            // Convert milliseconds since midnight to HH:mm:ss
            const hours = Math.floor(timeString / (1000 * 60 * 60));
            const minutes = Math.floor((timeString % (1000 * 60 * 60)) / (1000 * 60));
            timeValue = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:00`;
        }

        return new Date(`${dateString}T${timeValue}`);
    }
    validate() {
        let isValid = true;

        this.template.querySelectorAll('lightning-input,lightning-combobox').forEach(input => {
            if (!input.checkValidity()) {
                input.reportValidity();
                isValid = false;
            }
        });

        return isValid;
    }
    changeDateTime(event) {

        const sessionId = event.target.dataset.sessionId;
        const selectedValue = event.detail.value;
        let selectedTimeValue = '';
            /*this.studentSessions = this.studentSessions.map(stdSession => {
                if (stdSession.id === sessionId) {
                    if(event.target.label === 'Start Time'){
                        if(selectedValue){
                            stdSession.dateRequired = true;
                        }else{
                            stdSession.dateRequired = false;
                            stdSession.startTimeRequired = false;
                        }
                    }else if(event.target.label === 'Date'){
                       if(selectedValue){
                            stdSession.startTimeRequired = true;
                        }else{
                            stdSession.dateRequired = false;
                            stdSession.startTimeRequired = false;
                        }
                    }
                }
                return stdSession;
            });*/
            /*const updateSessionFields = (sessions) => {
                return sessions.map(session => {
                    if (session.id === sessionId) {
                        if(event.target.label === 'Start Time'){
                            if(selectedValue){
                                session.dateRequired = true;
                            }else{
                                session.dateRequired = false;
                                session.startTimeRequired = false;
                            }
                        }else if(event.target.label === 'Date'){
                        if(selectedValue){
                                session.startTimeRequired = true;
                            }else{
                                session.dateRequired = false;
                                session.startTimeRequired = false;
                            }
                        }
                    }
                    return session;
                });
            };*/
            const isFilled = val => val !== null && val !== undefined && val !== '';

            const updateSessionFields = (sessions) => {
                return sessions.map(session => {
                    if (session.id === sessionId) {
                        const fieldLabel = event.target.label;
                        const selectedValue = event.detail.value;

                        if (fieldLabel === 'Start Time') {
                            session.startTime = selectedValue;
                        } else if (fieldLabel === 'Date') {
                            session.date = selectedValue;
                        }

                        const anySelected = isFilled(session.startTime) || isFilled(session.date);

                        session.startTimeRequired = anySelected;
                        session.dateRequired = anySelected;
                    }
                    return session;
                });
            };

            this.studentSessions = updateSessionFields(this.studentSessions);
            this.flexibleSessions = updateSessionFields(this.flexibleSessions);
            this.parentSessions = updateSessionFields(this.parentSessions);
            this.counselingSessions = updateSessionFields(this.counselingSessions);
            
        if (event.target.label === 'Start Time') {
            selectedTimeValue = event.detail.value;
        }
        if (event.target.label === 'Date' || event.target.label === 'Start Time') {
            const updateSessions = (sessions) => {
                return sessions.map(session => {
                    if (session.oldDatevalue === undefined) {
                        session.oldDatevalue = '';
                    }
                    if (session.oldTime === undefined) {
                        session.oldTime = '';
                    }

                    if (session.id == sessionId) {

                        if ((session.oldDatevalue !== selectedValue || session.oldTime !== selectedTimeValue)) {
                            if (event.target.label === 'Date') return { ...session, sessionDate: selectedValue, editedDateTime: true, scheduleLate: false, scheduleOnTime: false };
                            if (event.target.label === 'Start Time') return { ...session, startTime: selectedValue, editedDateTime: true, scheduleLate: false, scheduleOnTime: false };
                        } else {
                            if (event.target.label === 'Date') return { ...session, sessionDate: selectedValue, editedDateTime: false, scheduleLate: false, scheduleOnTime: false };
                            if (event.target.label === 'Start Time') return { ...session, startTime: selectedValue, editedDateTime: false, scheduleLate: false, scheduleOnTime: false };
                        }
                    }
                    return session;
                });
            };

            this.flexibleSessions = updateSessions(this.flexibleSessions);
            this.studentSessions = updateSessions(this.studentSessions);
            this.parentSessions = updateSessions(this.parentSessions);
            this.counselingSessions = updateSessions(this.counselingSessions);
        }

    }


    changeHmAttended(event) {
        const sessionId = event.target.dataset.sessionId;
        const selectedValue = event.detail.value;
        /*this.studentSessions = this.studentSessions.map(stdSession => {
            if (stdSession.id === sessionId) {
                if(selectedValue){
                    stdSession.leadRequired = true;
                    stdSession.stdAttendRequired = true;
                }else{
                    stdSession.hmRequired = false;
                    stdSession.leadRequired = false;
                    stdSession.stdAttendRequired = false;
                }
                 
            }
            return stdSession;
        });*/
        const isFilled = val => val !== null && val !== undefined && val !== '';
        const updateSessionFields = (sessions) => {
                return sessions.map(session => {
                    if (session.id === sessionId) {
                        const hm = selectedValue;
                        const lead = session.sessionLead;
                        const par = session.parentAttendance;
                        const att = session.studentAttendance;
                        const anySelected = isFilled(hm && hm !== '') || isFilled(lead && lead !== '') || isFilled(att && att !== '') || isFilled(par && par !== '');
                        session.hmRequired = anySelected;
                        session.leadRequired = anySelected;
                        session.stdAttendRequired = anySelected;
                        session.parAttendRequired = anySelected;
                        
                    }
                    return session;
                });
            };

            this.studentSessions = updateSessionFields(this.studentSessions);
            this.parentSessions = updateSessionFields(this.parentSessions);
        const updateSessions = (sessions) => {
            return sessions.map(session => {
                if (session.id == sessionId) {
                    return { ...session, hmAttended: selectedValue };
                }
                return session;
            });
        };

        this.flexibleSessions = updateSessions(this.flexibleSessions);
        this.studentSessions = updateSessions(this.studentSessions);
        this.parentSessions = updateSessions(this.parentSessions);
        this.counselingSessions = updateSessions(this.counselingSessions);
    }

    changeSessionLead(event) {
        const sessionId = event.target.dataset.sessionId;
        const selectedValue = event.detail.value;
        const isFilled = val => val !== null && val !== undefined && val !== '';
        const updateSessionFields = (sessions) => {
                return sessions.map(session => {
                    
                    if (session.id === sessionId) {
                        const hm = session.hmAttended;
                        const lead = selectedValue;
                        const par = session.parentAttendance;
                        const att = session.studentAttendance;
                        const anySelected = isFilled(hm && hm !== '') || isFilled(lead && lead !== '') || isFilled(att && att !== '') || isFilled(par && par !== '');
                        session.hmRequired = anySelected;
                        session.leadRequired = anySelected;
                        session.stdAttendRequired = anySelected;
                        session.parAttendRequired = anySelected;
                    }
                    return session;
                });
            };

            this.studentSessions = updateSessionFields(this.studentSessions);
            this.parentSessions = updateSessionFields(this.parentSessions);
        const updateSessions = (sessions) => {
            return sessions.map(session => {
                if (session.id == sessionId) {
                    return { ...session, sessionLead: selectedValue };
                }
                return session;
            });
        };

        this.flexibleSessions = updateSessions(this.flexibleSessions);
        this.studentSessions = updateSessions(this.studentSessions);
        this.parentSessions = updateSessions(this.parentSessions);
        this.counselingSessions = updateSessions(this.counselingSessions);
    }
    handleClassAttend(event) {
        const sessionId = event.target.dataset.sessionId;
        const selectedValue = event.detail.value;
        const isFilled = val => val !== null && val !== undefined && val !== '';
        const updateSessionFields = (sessions) => {
                return sessions.map(session => {
                    
                    if (session.id === sessionId) {
                        const hm = session.hmAttended;
                        const lead = session.sessionLead;
                        const par = session.parentAttendance;
                        const att = selectedValue;
                        const anySelected = isFilled(hm && hm !== '') || isFilled(lead && lead !== '') || isFilled(att && att !== '') || isFilled(par && par !== '');
                        session.hmRequired = anySelected;
                        session.leadRequired = anySelected;
                        session.stdAttendRequired = anySelected;
                        session.parAttendRequired = anySelected;
                        
                    }
                    return session;
                });
            };

            this.studentSessions = updateSessionFields(this.studentSessions);
            this.parentSessions = updateSessionFields(this.parentSessions);
        const updateSessions = (sessions) => {
            return sessions.map(session => {
                if (session.id == sessionId) {
                    return { ...session, studentAttendance: selectedValue };
                }
                return session;
            });
        };

        this.flexibleSessions = updateSessions(this.flexibleSessions);
        this.studentSessions = updateSessions(this.studentSessions);
        this.parentSessions = updateSessions(this.parentSessions);
        this.counselingSessions = updateSessions(this.counselingSessions);
    }
    handleParentAttend(event) {
        const sessionId = event.target.dataset.sessionId;
        const selectedValue = event.detail.value;
        const isFilled = val => val !== null && val !== undefined && val !== '';
        const updateSessionFields = (sessions) => {
                return sessions.map(session => {
                    
                    if (session.id === sessionId) {
                        const hm = session.hmAttended;
                        const lead = session.sessionLead;
                        const par = selectedValue;
                        const att = session.studentAttendance;
                        const anySelected = isFilled(hm && hm !== '') || isFilled(lead && lead !== '') || isFilled(att && att !== '') || isFilled(par && par !== '');
                        session.hmRequired = anySelected;
                        session.leadRequired = anySelected;
                        session.stdAttendRequired = anySelected;
                        session.parAttendRequired = anySelected;
                        
                    }
                    return session;
                });
            };

            this.studentSessions = updateSessionFields(this.studentSessions);
            this.parentSessions = updateSessionFields(this.parentSessions);
        const updateSessions = (sessions) => {
            return sessions.map(session => {
                if (session.id == sessionId) {
                    return { ...session, parentAttendance: selectedValue };
                }
                return session;
            });
        };

        this.flexibleSessions = updateSessions(this.flexibleSessions);
        this.studentSessions = updateSessions(this.studentSessions);
        this.parentSessions = updateSessions(this.parentSessions);
        this.counselingSessions = updateSessions(this.counselingSessions);
    }
    handleIndStdAttendanceChange(event) {
        this.editedStudent = true;
        const studentId = event.target.dataset.studentId;
        const selectedValue = event.detail.value;
        this.indStudentData = this.indStudentData.map(student => {
            if (student.studentId === studentId) {
                return { ...student, stdAttendance: selectedValue };
            }
            return student;
        });
    }
    handleIndParentAttenChange(event) {
        this.editedStudent = true;
        const studentId = event.target.dataset.studentId;
        const selectedValue = event.detail.value;
        this.indStudentData = this.indStudentData.map(student => {
            if (student.studentId === studentId) {
                return { ...student, parentAttendance: selectedValue };
            }
            return student;
        });
    }
    get attendanceOptions() {
        //const noneOption = [{ label: '--None--', value: '' }];
        //return noneOption.concat(
          return  this.attendancePicklist || [];
           // );
    }
    @track attendancePicklist;

    get allSectionNames() {
        return this.indStudentData.map(student => student.studentId);
    }
    async sessionStudentDataFunc() {
        await sessionStudentData({
            batchId: this.batch, facilitatorId: this.facEmailId, sessionID: this.indSessionId,
            selectedGrade: this.grade
        })
            .then((result) => {
                this.attendancePicklist = result.attendancepicklist;
                this.indStudentData = result.studentdata;

                if (this.indStudentData.length > 0) {
                    this.counselingSessions.forEach((sess) => {
                        this.indStudentData.forEach((student) => {
                            if (student.stdAttendance == undefined) {
                                student.stdAttendance = '';
                            }
                            if (student.stdAttendance != '' || student.stdWrongBatch == true) {
                                student.disableWrongBatch = true;
                                student.disableStudent = true;
                            } else if (sess.disableAttendance) {
                                student.disableWrongBatch = true;
                                student.disableStudent = true;
                            } else {
                                student.disableStudent = false;
                            }
                        });

                    });
                    this.showIndividualStudent = true;
                } else {
                    this.showIndividualStudent = false;
                }
                this.showLoading = false;

            })
            .catch((Error) => {
                console.log('Error =' + Error);
                console.log('Error= ' + JSON.stringify(Error));
            })
    }

    handleAttendanceClick(event) {
        event.preventDefault();
        let showError = false;
        const sessionId = event.currentTarget.dataset.sessionId;

        const session = this.studentSessions.find(item => item.id === sessionId);
        if (session) {
            showError = session.preSessIncomplete;
        } else {
            showError = false;
        }

        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'sesssionStudentAttendance__c'
            },
            state: {
                facilitorId: encodeURI(this.facEmailId),
                code: encodeURI(this.code),
                schoolId: encodeURI(this.schoolId),
                batch: encodeURI(this.batch),
                grade: encodeURI(this.grade),
                sessionId: encodeURI(sessionId),
                showError: encodeURI(showError)
            }
        };
        this[NavigationMixin.Navigate](pageReference);

    }
    handleParentAttendanceClick(event) {
        event.preventDefault();
        let showError = false;
        const sessionId = event.currentTarget.dataset.sessionId;
        const session = this.parentSessions.find(item => item.id === sessionId);
        if (session) {
            showError = session.preSessIncomplete;
        } else {
            showError = false;
        }

        let pageReference = {
            type: 'comm__namedPage',
            attributes: {
                name: 'SessionParentAttendance__c'
            },
            state: {
                facilitorId: encodeURI(this.facEmailId),
                code: encodeURI(this.code),
                schoolId: encodeURI(this.schoolId),
                batch: encodeURI(this.batch),
                grade: encodeURI(this.grade),
                sessionId: encodeURI(sessionId),
                showError: encodeURI(showError)
            }
        };
        this[NavigationMixin.Navigate](pageReference);
    }

    handleSectionToggleChild(event) {

    }
    handleSectionToggle(event) {
        const openSections = event.detail.openSections;
        this.showParentSessionStatus = !openSections.includes('parentSession');
        this.showCounsellingSessionStatus = !openSections.includes('individualCounsellingSession');
        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }
    back;
    showError;
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {

            const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
            this.code = rxCurrentPageReference.state.code ? decodeURI(rxCurrentPageReference.state.code) : null;
            this.facEmailId = rxCurrentPageReference.state.facilitorId ? decodeURI(rxCurrentPageReference.state.facilitorId) : null;
            this.schoolId = rxCurrentPageReference.state.schoolId ? decodeURI(rxCurrentPageReference.state.schoolId) : null;
            this.batch = rxCurrentPageReference.state.batch ? decodeURI(rxCurrentPageReference.state.batch) : null;
            this.grade = rxCurrentPageReference.state.grade ? decodeURI(rxCurrentPageReference.state.grade) : null;
            this.back = rxCurrentPageReference.state.back ? decodeURI(rxCurrentPageReference.state.back) : null;
            this.showError = rxCurrentPageReference.state.showError ? decodeURI(rxCurrentPageReference.state.showError) : null;

        }
    }
    backToLogin() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                name: 'SessionLogin__c'
            }
        });
    }
    handleSignOut(event) {
        this.showLoading = true;
        this.sessionSignOutFunc();
    }
    sessionSignOutFunc() {

        sessionSignOut({
            strEmail: this.facEmailId
        })
            .then(result => {
                if (result) {
                    this.showToastMessage('Sign Out Successfully', 'success');
                    window.name = '';
                }
                this.backToLogin();
                this.showLoading = false;

            }).catch(error => {
                this.showToastMessage(error.body.message, 'error');
                console.log(error.body.message);
            });
    }
    onClickPendingSession(event) {

        //this.showLoading = true;
        event.preventDefault(); // prevent navigation
        const hrefValue = event.currentTarget.getAttribute('href');
        const decodedHref = hrefValue.replace(/&amp;/g, '&');
        const params = new URLSearchParams(decodedHref);
        this.schoolId = params.get('sId');
        this.getSchoolListFunc();
        this.batch = params.get('bId');
        this.getSessionListFunc();
        this.grade = params.get('grade');
        this.getBatchFunc();
        this.hideModalBox();

    }
    getSchoolListFunc() {
        getSchoolList({ facilitorId: this.facEmailId }).
            then((data) => {

                if (data) {
                    var optionsLabel = data.map(acc => ({
                        label: acc.Name,
                        value: acc.Id
                    }));

                    this.options = [...optionsLabel];
                    this.flagIndicatingDataHasBeenLoadedInVariables = true;

                } else if (error) {
                    console.error('Error fetching accounts', error);
                }
            }).
            catch((error) => {

                this.showToastPopMessage(
                    `Something went wrong. Error - ${error}`,
                    "error"
                );

            });
    }
    handleSchoolChange(event) {
        this.schoolId = event.detail.recordId;
        this.grade = '';
        this.batch = '';

    }
    showModalBox() {
        this.isShowModal = true;
    }
    showToastMessage(message, variant) {
        const event = new ShowToastEvent({
            title: 'Session Detail',
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
    hideModalBox() {
        this.isShowModal = false;
        this.getSchoolListFunc();
    }
    connectedCallback() {
        this.startInactivityTimer();
        // Track user activity
        window.addEventListener('mousemove', this.resetTimer);
        window.addEventListener('keydown', this.resetTimer);
        window.addEventListener('click', this.resetTimer);
        window.addEventListener('scroll', this.resetTimer);
        window.addEventListener('touchstart', this.resetTimer);

        this.showLoading = true;
        if (window.innerWidth < 768) {
            this.activeSections = [];
            this.activeChildSession = [];
            this.showParentSessionStatus = true;
            this.showCounsellingSessionStatus = true;
        } else {
            this.activeSections = ['flexibleSession', 'studentSession', 'parentSession', 'individualCounsellingSession'];
            this.showParentSessionStatus = false;
            this.showCounsellingSessionStatus = false;
        }
        window.addEventListener("beforeunload", this.handleTabClose);
        if (this.code == window.name) {
            if (!this.code || !this.facEmailId) {

                this.showToastMessage('Error While Login', 'error');
                this.backToLogin();
            } else {
                this.showLoading = false;
                this.getPendingSessionFunc();
                this.getdynamicpicklistvalFunc('Batch__c', 'Grade__c');
                const url = new URL(window.location.href);
                url.searchParams.delete('showError');
                if (this.back === 'true') {
                    url.searchParams.delete('back');
                    window.history.replaceState({}, document.title, url.toString());
                    this.getBatchFunc();
                    this.hideModalBox();
                    this.getSessionListFunc();

                }

            }

        } else {

            this.showToastMessage('This form is already open in another tab!', 'error');
            this.backToLogin();
        }


    }
    disconnectedCallback() {
        window.removeEventListener('beforeunload', this.handleTabClose);

        this.clearInactivityTimer();

        // Remove listeners
        window.removeEventListener('mousemove', this.resetTimer);
        window.removeEventListener('keydown', this.resetTimer);
        window.removeEventListener('click', this.resetTimer);
        window.removeEventListener('scroll', this.resetTimer);
        window.removeEventListener('touchstart', this.resetTimer);
    }
    startInactivityTimer = () => {
        this.inactivityTimeout = setTimeout(() => {
            LightningAlert.open({
                message: 'It has been half an hour since the last update. Please refresh the form to continue, or log out.',
                theme: 'warning', // Options: 'default', 'shade', 'inverse', 'alt-inverse', 'success', 'info', 'warning', 'error'
                label: 'Session Inactive', // Title of the alert
                variant: 'header' // Style variant
            }).then(() => {
                // Action after clicking OK
                location.reload(); // or use logout: window.location.href = '/secur/logout.jsp';
            });
        }, 30 * 60 * 1000); // 30 minutes
    };

    resetTimer = () => {
        clearTimeout(this.inactivityTimeout);
        this.startInactivityTimer();
    };

    clearInactivityTimer = () => {
        clearTimeout(this.inactivityTimeout);
    };

    handleTabClose = (event) => {
        this.sessionSignOutFunc();
        /*const nextUrl = event.target?.document?.activeElement?.baseURI || document.activeElement?.baseURI;
        if (!nextUrl || !nextUrl.startsWith(this.baseUrl)) {
            this.sessionSignOut();
        }*/

    };
    onchangeGrade(event) {
        this.batch = '';
        this.grade = event.detail.value;
        this.getBatchFunc();
    }
    getBatchFunc() {
        getBatch({
            grade: this.grade,
            schoolId: this.schoolId,
            trainerId: this.facEmailId
        })
            .then(result => {

                if (result) {
                    this.batchOption = result;
                }

            }).catch(error => {
                this.showToastMessage(error.body.message, 'error');
                console.log(error.body.message);
            });
    }
    onchangeBatch(event) {
        this.batch = event.detail.value;
        this.parentSessions = [];
        this.studentSessions = [];
        this.flexibleSessions = [];
        this.counselingSessions = [];
        this.getSessionListFunc();
    }
    async getSessionListFunc() {
        lstsessionRecords({
            batchId: this.batch,
            loggedInTrainer: this.facEmailId
        })
            .then(result => {
                debugger
                const response = [...result]

                if (response) {
                    //this.checkPreviousSessionComplete();

                    response.forEach(session => {
                        session.startTimeFormatted = this.formatTimeToInput(session.startTime);
                        session.reasonForLateSchedule = '';
                        if (session.sessionDate == undefined) {
                            if(!session.isCounselingSession){
                                session.status = 'Unscheduled';
                                session.statusClassName = 'UnscheduledCls';
                            }
                            session.sessionDate = '';
                            session.oldDatevalue = '';
                        } else {
                            session.oldDatevalue = session.sessionDate;
                        }
                        if (session.startTime == undefined) {
                            session.startTime = '';
                            session.oldTime = '';
                        } else {
                            session.oldTime = session.startTime;
                        }
                        if (session.parentAttendance == 0) {
                            session.parentAttendance = '';
                        }
                        if (session.studentAttendance == 0) {
                            session.studentAttendance = '';
                        }




                        let greaterThanOneHr;
                        let pastTime = this.isExactMatch(session.oldDatevalue, session.startTimeFormatted);
                        const diffHours = this.calTimeDiff(session.oldDatevalue, session.startTimeFormatted);

                        if (diffHours > 1) {
                            greaterThanOneHr = true;
                        }
                        session.pastTime = pastTime;
                        //  const inputDateTime = this.parseDateTime(oldDate, oldTime);

                        //     // 2. Get current datetime
                        //         const now = new Date();

                        //     // 3. Calculate difference in milliseconds
                        //     const diffMs = inputDateTime - now;
                        //     const diffHours = Math.abs(diffMs) / (1000 * 60 * 60);


                        //session.disableStartTimeNDate = session.isAttendenceFound || session.isNotLoggedInTrainerSession;
                        if (session.facilitatorId === this.facEmailId) {
                            //session.disableStartTimeNDate = session.isAttendenceFound || session.isNotLoggedInTrainerSession;

                            if ((greaterThanOneHr == true && pastTime == false) && (session.oldDatevalue != '' && session.oldTime != '')) {
                                session.disableStartTimeNDate = false;
                            } else if (pastTime) {
                                //session.status = 'Ready for Attendance';
                                session.disableStartTimeNDate = true;
                            } else if (session.oldDatevalue == '' && session.oldTime == '') {
                                session.disableStartTimeNDate = false;

                            } else {
                                session.disableStartTimeNDate = true;
                            }
                            if (pastTime == true) {
                                //session.disableStartTimeNDate = true;
                                session.disableAttendance = false;
                            } else {
                                session.disableAttendance = true;
                                //session.disableStartTimeNDate = false;
                            }
                            if (session.disableStartTimeNDate) {
                                if (session.isFlexibleSession) {
                                    if (session.studentAttendance != '') {
                                        session.flexiRFA = false;
                                        session.indAttentLink = true;
                                        session.disableAttendance = true;
                                    } else {
                                        session.flexiRFA = true;
                                        session.indAttentLink = false;
                                        //session.disableAttendance = false;
                                    }
                                } else if (session.isStudentSession) {
                                    if (session.studentAttendance != '' && session.hmAttended != '' && session.sessionLead != '') {
                                        session.indAttentLink = true;
                                        session.disableAttendance = true;
                                        session.studRFA = false;
                                    } else {
                                        session.studRFA = true;
                                        session.indAttentLink = false;
                                        //session.disableAttendance = false;
                                    }

                                } if (session.isParentSession) {
                                    if (session.parentAttendance != '' && session.studentAttendance != '' && session.hmAttended != '' && session.sessionLead != '') {
                                        session.indAttentLink = true;
                                        session.disableAttendance = true;
                                        session.parentRFA = false;
                                    } else {
                                        session.parentRFA = true;
                                        session.indAttentLink = false;
                                        //session.disableAttendance = false;
                                    }
                                }
                            }
                            if (session.status == 'Complete') {
                                session.indAttentLink = false;
                            }
                            //session.disabled = false;
                            if (session.status == 'Scheduled' && pastTime == true) {
                                session.status = 'Ready for Attendance';
                                session.statusClassName = 'ReadyforAttendanceCls';
                            }
                        } else {
                            session.disableAttendance = true;
                            session.disableStartTimeNDate = true;
                            session.indAttentLink = false;
                            //session.disabled = true;
                        }
                        session.disabled = true;
                        if (session.isParentSession) {
                            this.parentSessions.push(session);
                        }
                        if (session.isStudentSession) {
                            this.studentSessions.push(session);
                        }
                        if (session.isCounselingSession) {
                            this.counselingSessions.push(session);
                        }
                        if (session.isFlexibleSession) {
                            this.flexibleSessions.push(session);
                        }
                    });
                    this.hasParentSessions = this.parentSessions && this.parentSessions.length > 0;
                    this.hasStudentSessions = this.studentSessions && this.studentSessions.length > 0;
                    this.hasFlexibleSessions = this.flexibleSessions && this.flexibleSessions.length > 0;
                    this.hasCounselingSessions = this.counselingSessions && this.counselingSessions.length > 0;
                    if (window.innerWidth < 768) {
                        this.activeChildSession = [];
                    } else {
                        this.activeChildSession = [
                            ...this.parentSessions.map(session => session.id),
                            ...this.studentSessions.map(session => session.id),
                            ...this.counselingSessions.map(session => session.id),
                            ...this.flexibleSessions.map(session => session.id)
                        ];



                    }
                    this.studentSessions.forEach((sess, index) => {
                        if (index != 0) {
                            const prevSession = this.studentSessions[index - 1];
                            if (prevSession.status == 'Complete' && sess.studRFA == false && sess.status != 'Complete') {
                                sess.preSessIncomplete = false;
                            }
                            else {
                                sess.preSessIncomplete = true;
                            }

                        }
                    }
                    );
                    this.parentSessions.forEach((sess, index) => {
                        if (index != 0) {
                            const prevSession = this.parentSessions[index - 1];

                            if (prevSession.status == 'Complete' && sess.parentRFA == false && sess.status != 'Complete') {
                                sess.preSessIncomplete = false;
                            }
                            else {
                                sess.preSessIncomplete = true;
                            }
                        }
                    }
                    );


                }
                if(this.counselingSessions[0]){
                    this.CounsellingSessionStatusValue = this.counselingSessions[0].status;
                    this.CounsellingSessionStatusClass = this.counselingSessions[0].statusClassName;

                    this.ParentSessionStatusValue = this.parentSessions[0].status;
                    this.ParentSessionStatusClass = this.parentSessions[0].statusClassName;

                    this.indSessionId = this.counselingSessions[0].id;
                    this.indSessionLead = this.counselingSessions[0].sessionLead;
                }
                this.getdynamicpicklistvalFunc('Session_Attendance__c', 'Session_Lead__c');
                //this.sessionStudentDataFunc();

                // this.counselingSessions.forEach((sess) => {
                //     this.indStudentData.forEach((student) =>{
                //         if(student.stdAttendance != ''){
                //             student.disableStudent = true;
                //         }else if(sess.disableAttendance){
                //             student.disableStudent = true;
                //         } else {
                //             student.disableStudent = false;
                //         }
                //     });

                //     });


                this.activeChildSession1 = [...this.activeChildSession];

            }).catch(error => {
                console.log(error);
                this.showToastMessage(error.body.message, 'error');
            });
    }
    /**
     * Check if oldDate + oldTime is within 1 hour of current datetime
     * @param {string} oldDate - Date in YYYY-MM-DD format
     * @param {string|number} oldTime - Time in HH:MM format or milliseconds since midnight
     * @returns {boolean} - True if within 1 hour (past or future)
     */
    calTimeDiff(oldDate, oldTime) {
        if (!oldDate || oldTime === undefined || oldTime === null) {
            return false;
        }

        try {
            // 1. Parse input datetime
            const inputDateTime = this.parseDateTime(oldDate, oldTime);

            // 2. Get current datetime
            const now = new Date();

            // 3. Calculate difference in milliseconds
            const diffMs = inputDateTime - now;

            const diffHours = Math.abs(diffMs) / (1000 * 60 * 60);

            // 4. returning the diff value
            return diffHours;

        } catch (error) {
            console.error('DateTime validation error:', error);
            return error;
        }
    }

    /**
     * Helper to create Date object from date + time inputs
     */
    parseDateTime(dateStr, timeInput) {
        let timeStr;

        if (typeof timeInput === 'number') {
            // Convert milliseconds to HH:MM
            const hours = Math.floor(timeInput / (1000 * 60 * 60));
            const mins = Math.floor((timeInput % (1000 * 60 * 60)) / (1000 * 60));
            timeStr = `${String(hours).padStart(2, '0')}:${String(mins).padStart(2, '0')}`;
        } else {
            timeStr = timeInput;
        }

        return new Date(`${dateStr}T${timeStr}`);
    }
    isExactMatch(inputDate, inputTime) {
        if (!inputDate || inputTime == null) return false;

        const now = new Date();
        const inputDateTime = new Date(`${inputDate}T${this.formatTime(inputTime)}`);
        return inputDateTime < new Date();

        return (
            inputDateTime.getFullYear() === now.getFullYear() &&
            inputDateTime.getMonth() === now.getMonth() &&
            inputDateTime.getDate() === now.getDate() &&
            inputDateTime.getHours() === now.getHours() &&
            inputDateTime.getMinutes() === now.getMinutes()
        );
    }

    // Helper to format time (supports "HH:MM" or milliseconds)
    formatTime(timeInput) {
        if (typeof timeInput === 'number') {
            const hours = Math.floor(timeInput / 3600000).toString().padStart(2, '0');
            const mins = Math.floor((timeInput % 3600000) / 60000).toString().padStart(2, '0');
            return `${hours}:${mins}`;
        }
        return timeInput; // Assume already in "HH:MM" format
    }

    @track activeChildSession1 = [];
    getdynamicpicklistvalFunc(objName, fldName) {
        getdynamicpicklistval({
            objectName: objName,
            fieldName: fldName
        })
            .then(result => {

                if (result) {
                    if (fldName === 'Grade__c')
                        this.gradeOption = result;
                    if (fldName === 'Late_Schedule__c') {
                        this.lateScheduleReasonOption = result;
                    }
                    if (fldName === 'Session_Lead__c') {
                        this.optionsSessionLead = result;
                        if(this.indSessionId){
                            this.sessionStudentDataFunc();
                        }
                    }
                }

            }).catch(error => {
                this.showToastMessage(error.body.message, 'error');
                console.log(error.body.message);
            });
    }
    getPendingSessionFunc() {
        getPendingSessionData({
            stremail: this.facEmailId
        })
            .then(result => {
                this.showLoadingModal = false;
                if (result) {
                    this.sessionList = Object.keys(result).map((key, index) => {
                        // Process batches into key-value pairs
                        let batches = Object.entries(result[key]).map(([batchKey, batchValue]) => {
                            return {
                                batchName: batchKey, // e.g., "Grade 9 - 27487"
                                batchDetails: batchValue // e.g., "sId=001C400000JISJEIA5&bId=a0oC4000000Uvk1IAC&grade=Grade 9"
                            };
                        });

                        return {
                            school: key,
                            batches: batches,
                            displayIndex: index + 1
                        };
                    });
                    this.showPendingSession = this.sessionList.length > 0;
                    //this.sessionStudentDataFunc();
                }

            }).catch(error => {
                this.showLoadingModal = false;
                this.showToastMessage(error.body.message, 'error');
                console.log(error.body.message);
            });
    }
    renderedCallback() {
        if (typeof window !== 'undefined') {
            const style = document.createElement('style');
            style.innerText = `.sessionAccordion h2.slds-accordion__summary-heading {
                color: #49445C;
                font-weight: bold;
                font-size: 18px;
            }
            .sessionAccordion svg.slds-button__icon.slds-button__icon_left.slds-icon.slds-icon-text-default.slds-icon_x-small{
                fill: #49445C;
                margin-right: 15px;
            }
            .sessionAccordion .slds-accordion__summary-heading .slds-button:focus {
                box-shadow: none;
            }.sessionAccordion lightning-accordion-section.slds-accordion__list-item {
                border: none;
            }.completeButton button.slds-button.slds-button_brand, .incompleteButton button.slds-button.slds-button_brand {
                width: 8%;
            }.saveButton button.slds-button.slds-button_brand {
                width: 7%;
                height: 38px;
                color: #fff;
            }.facNameInAccordion input{
                background-color: #F09F4D !important; text-align: center !important;
            }
            .sessionAccordion input{
                color: #49445C !important;
                border: 1px solid #49445C !important;
            }
            .sessionAccordion label.slds-form-element__label.slds-no-flex, .sessionAccordion label.slds-form-element__label {
                color: #49445C !important;
                margin-bottom: 20px;
            }.CompleteCls .slds-input, .CompleteCls button.slds-button.slds-button_brand{
                background-color:#92DB72 !important; text-align: center !important;
            }.ReadyforAttendanceCls .slds-input, .ReadyforAttendanceCls button.slds-button.slds-button_brand{
                background-color:#9ABBFF !important; text-align: center !important; overflow-wrap: break-word !important;
            }.ScheduledCls .slds-input, .ScheduledCls button.slds-button.slds-button_brand{
                background-color:#EEDA5E !important; text-align: center !important;
            }.UnscheduledCls .slds-input, .IncompleteCls .slds-input, .IncompleteCls button.slds-button.slds-button_brand, .UnscheduledCls button.slds-button.slds-button_brand{
                background-color:#E88775 !important; text-align: center !important;
            }button.slds-button.slds-button_brand {
                width: 12%;
                color: #000;
            }.pendingSessionModal .slds-modal__container{
                max-width: 60rem;
                min-width: 60rem;
            }.lateSchedulePopup .btnCancel button.slds-button.slds-button_brand {
                background-color: #1A1A1A;
                color: #fff;
            }.lateSchedulePopup .btnOk button.slds-button.slds-button_brand {
                background-color: #50A771;
                color: #fff;
            }.lateSchedulePopup .btnGrp button.slds-button.slds-button_brand {
                width: 20%;
            }
            @media (max-width: 767px) {
                lightning-button.completeButton button.slds-button.slds-button_brand, lightning-button.incompleteButton button.slds-button.slds-button_brand {
                    width: 30% !important;
                }
                lightning-button.saveButton button.slds-button.slds-button_brand {
                    width: 18%;
                    height: 35px;
                }
                button.slds-button.slds-button_brand{
                    width:50%;
                }
                .pendingSessionModal .slds-modal__container{
                    max-width: auto;
                    min-width: auto;
                }
                .ReadyforAttendanceCls .slds-input, .ReadyforAttendanceCls button.slds-button.slds-button_brand{
                    background-color:#9ABBFF !important; text-align: center !important; font-size: 10px !important; overflow-wrap: break-word !important;
                }
            }@media (max-width: 375px) {
                .classAttendanceLabel label.slds-form-element__label.slds-no-flex {
                    padding-bottom: 19px; 
                }
    
            }@media (max-width: 384px) {
                .classAttendanceLabel label.slds-form-element__label.slds-no-flex {
                    padding-bottom: 12px; 
                }`;
            this.template.querySelector('div').appendChild(style);
        }
    }
    isSessionOpen(sessionId) {
        if (Array.isArray(this.activeChildSession)) {
            return this.activeChildSession.includes(sessionId);
        } else {
            return this.activeChildSession === sessionId;
        }
    }
    formatTimeToInput(s) {
        if (s === 0) {
            // Default to 12:00 AM
            return '00:00 AM';
        }
        if (!s) return '';
        let time = new Date(s);
        let hours = time.getUTCHours();
        let minutes = time.getUTCMinutes();
        //let ampm = hours >= 12 ? 'PM' : 'AM';

        if (FORM_FACTOR === "Small") {
            // Mobile - 12-hour format with AM/PM
            //this.ampm = hours >= 12 ? 'PM' : 'AM';
            hours = hours % 12;
            hours = hours || 12; // Convert 0 to 12
            minutes = minutes < 10 ? '0' + minutes : minutes;
            return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}`;
        } else {
            // Desktop - 24-hour format
            hours = hours < 10 ? '0' + hours : hours;
            minutes = minutes < 10 ? '0' + minutes : minutes;
            return `${hours}:${minutes}`;
        }

    }

    handleSelectOption(event) {
        this.schoolId = event.detail;
        this.grade = '';
        this.batch = '';
    }

    value = '';

    get optionsHmAttended() {
        return [
            { label: '--None--', value: '' },
            { label: 'Yes', value: 'Yes' },
            { label: 'No', value: 'No' },
        ];
    }



}