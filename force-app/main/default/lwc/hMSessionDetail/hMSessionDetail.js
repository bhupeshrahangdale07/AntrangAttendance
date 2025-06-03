import { LightningElement, wire, track } from 'lwc';
import OnTime_Icon from "@salesforce/resourceUrl/sessionIconOnTime";
import Reschedule_Icon from "@salesforce/resourceUrl/sessionIconReschedule";
import Lateschedule_Icon from "@salesforce/resourceUrl/sessionIconLateSchedule";
import sessionSignOut from '@salesforce/apex/SessionDetailController.sessionSignOut';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LightningAlert from 'lightning/alert';
import { NavigationMixin } from 'lightning/navigation';
import LightningConfirm from 'lightning/confirm';
import getSchoolList from '@salesforce/apex/HMSessionDetailController.getSchoolList';
import getPendingSessionData from '@salesforce/apex/HMSessionDetailController.getPendingSessionData';
import lstsessionRecords from '@salesforce/apex/HMSessionDetailController.lstsessionRecords';
import getdynamicpicklistval from '@salesforce/apex/SessionDetailController.getdynamicpicklistval';
import FORM_FACTOR from "@salesforce/client/formFactor";
import saveLateSchedule from '@salesforce/apex/HMSessionDetailController.saveLateSchedule';
let options = [
    { "label": "No School Found", "value": "" }
];
export default class HMSessionDetail extends NavigationMixin(LightningElement) {
    hasHMSessions;
    isShowModalForLateSchedule = false;
    OnTimeScheduleIcon = OnTime_Icon;
    reScheduleIcon = Reschedule_Icon;
    lateScheduleIcon = Lateschedule_Icon;
    hmSessions;
    showPendingSession;
    showLoadingModal = true;
    @track isShowModal = true;
    showLoading = false;
    inactivityTimeout;
    code;
    facEmailId;
    flagIndicatingDataHasBeenLoadedInVariables = false;
    schoolId;
    @track sessionList;
    @track activeChildSession = [];
    @track optionsSessionLead;
    @track optionsHmAttended;
    @track lateScheduleSessions = [];
    @track lateScheduleReasonOption;

    async saveLateScheduleFunc() {
        this.showLoading = true;
        let allSessionCompleted = false;
        const buildUpdatedSessions = (sessions) => {
            return sessions.map(sess => {
                //if (!sess.isCounselingSession) {
                    if (sess.oldDatevalue == '' && sess.oldTime == '' && sess.scheduleCounter == 0) {
                        sess.editedDateTime = false;
                    }
                let scheduleCounter = sess.editedDateTime === true ? (sess.scheduleCounter + 1) : sess.scheduleCounter;
                console.log('scheduleCounter = ', scheduleCounter);
                if ((sess.startTime == '' || sess.sessionDate == '') || (sess.startTime == null || sess.sessionDate == null)) {
                    return {
                        Id: sess.id,
                        Late_Scedule__c: sess.reasonForLateSchedule,
                        Scheduling_Type__c: '',
                        Start_Time__c: sess.startTime,
                        Date__c: sess.sessionDate,
                        Session_Status__c: 'Unscheduled',
                        Rescheduled_counter__c: scheduleCounter
                    };
                } else {
                    //const count = this.hmSessions.filter(item => item.status == 'Complete').length;
                    // if(count == this.hmSessions.length){
                    //     sess.sessionCompleted = true;
                    // }else {
                    //     sess.sessionCompleted = false;
                    // }
                    if (sess.sessionLead != '' && sess.hmAttended != '' && sess.isEdited == true) {
                        sess.status = 'Complete';
                    }
                    return {
                        Id: sess.id,
                        Late_Scedule__c: sess.reasonForLateSchedule,
                        Scheduling_Type__c: sess.scheduleLate ? 'Late Schedule' : 'On Time',
                        Start_Time__c: sess.startTime,
                        Date__c: sess.sessionDate,
                        Session_Status__c: sess.status,
                        Rescheduled_counter__c: scheduleCounter,
                        HM_Attended__c: sess.hmAttended,
                        Session_Lead__c: sess.sessionLead
                    };
                }
                //}

            });
        };
        const sessionsToUpdate = [
            ...buildUpdatedSessions(this.hmSessions)
        ];
        const count = this.hmSessions.filter(item => item.status == 'Complete').length;
                     if(count == this.hmSessions.length){
                         allSessionCompleted = true;
                     }else{
                        allSessionCompleted = false;
                     }
            saveLateSchedule({ sessionList: sessionsToUpdate, allSessCompleted:  allSessionCompleted, schoolId: this.schoolId})
                .then((result) => {
                    if (result == true) {
                        this.showToastMessage('Record updated successfully!', 'success');
                        location.reload();

                    }
                    //this.showLoading = false;

                })
                .catch((Error) => {
                    this.showToastMessage(JSON.stringify(Error), 'error');
                    console.log('Error =' + Error);
                    console.log('Error= ' + JSON.stringify(Error));
                })
       

    }
    async handleSave() {
        if(this.schoolId == '' || this.schoolId == null || this.schoolId == undefined){
            this.showToastMessage('Please enter the school.', 'error');
            return;
        }
        console.log('HM Session =', JSON.stringify(this.hmSessions))
        this.showLoading = true;
        const isValid = this.validate();
        if (!isValid) {
            this.showToastMessage('Please fill all required fields', 'error');
            this.showLoading = false; // Hide loader if validation fails
            return;
        }
        this.showLoading = false;
        let lateSchedule = [];
        let lessThanOneHr = [];
        const markLateScheduledSessions = async (sessions) => {
            const now = new Date();
            sessions.forEach(session => {
                if (session.editedDateTime === true) {
                    const sessionDate = session.sessionDate;
                    let startTime = session.startTime;
                    if (startTime === undefined || startTime === null || startTime == 0) {
                        startTime = '00:00:00';
                    }

                    const inputDateTime = this.createDateTime(sessionDate, startTime);
                    const now = new Date();

                    if (inputDateTime < now) {
                        session.pastTime = true;
                    } else {
                        session.pastTime = false;
                    }
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
                    // if (session.oldDatevalue == '' && session.oldTime == '' && session.scheduleCounter == 0) {
                    //     session.editedDateTime = false;
                    // }
                    session.status = 'Scheduled';
                    session.statusClassName = 'ScheduledCls'
                }
            });
        };
        markLateScheduledSessions(this.hmSessions);

        for (let i = 0; i < this.hmSessions.length; i++) {

            if(this.hmSessions[i].editedDateTime == true){
                const diffHours = this.calTimeDiff(this.hmSessions[i].oldDatevalue, this.hmSessions[i].oldTime);
                    if (diffHours < 1 && diffHours > 0) {
                        this.showToastMessage('Sorry, it is too late to change session schedule. Please see rules in Form Instructions.', 'error');
                        return;
                    }
            }
            
            if (i != 0 && this.hmSessions[i].startTime != "") {
                const prevSession = this.hmSessions[i - 1];
                if ((prevSession.startTime == "" || prevSession.startTime == undefined) && this.hmSessions[i].startTime != null ) {
                    this.showToastMessage('Please schedule the previous session first.', 'error');
                    return;
                }
                const seessStartTime = this.createDateTime(this.hmSessions[i].sessionDate, this.hmSessions[i].startTime);
                const prevSessionTime = this.createDateTime(prevSession.sessionDate, prevSession.startTime);
                const timeDiffHr = Math.abs(seessStartTime - prevSessionTime) / (1000 * 60 * 60);
                console.log('timeDiffHr- ' + timeDiffHr);
                if (timeDiffHr < 24) {
                    this.showToastMessage('Minimum gap of 24 hours is required between Check-ins', 'error');
                    return;
                }
                if (prevSession.status != 'Complete' && this.hmSessions[i].pastTime == true) {
                    this.showToastMessage('Previous session’s attendance is incomplete. Please complete to proceed.', 'error');
                    return;
                }
            }

            if (i != this.hmSessions.length - 1 && this.hmSessions[i].startTime != "") {
                const nextSession = this.hmSessions[i + 1];

                const currentDateTime = this.createDateTime(this.hmSessions[i].sessionDate, this.hmSessions[i].startTime);
                const nextDateTime = this.createDateTime(nextSession.sessionDate, nextSession.startTime);
                const diffMinutes = Math.abs(nextDateTime - currentDateTime) / (1000 * 60 * 60);

                // 4. Check 24-hours gap
                if (diffMinutes < 24) {
                    this.showToastMessage('Minimum gap of 24 hours is required between Check-ins', 'error');
                    return;
                }
                if (currentDateTime > nextDateTime) {
                    this.showToastMessage('Check Date/Time - Sessions to be taken in the right order', 'error');
                    return;
                }

            }

        }
        const count = this.hmSessions.filter(item => item.sessionLead != '' && item.hmAttended != '' && item.isEdited == true && item.disableAttendance == false).length;
        if (count > 0) {
            const result = await LightningConfirm.open({
                message: 'Please make sure that the fields are correctly filled, as they cannot be changed after you click OK.',
                variant: 'header',
                label: 'Please Confirm',
                theme: 'success'
            });
            if (result) {
                this.lateScheduleSessions = lateSchedule;
                console.log(' this.lateScheduleSessions- ' + JSON.stringify(this.lateScheduleSessions));
                if (this.lateScheduleSessions.length > 0) {
                    this.getdynamicpicklistvalFunc('HM_Session__c', 'Late_Scedule__c');
                    this.isShowModalForLateSchedule = true;
                } else {
                    this.saveLateScheduleFunc();
                }
            }
        } else {
            this.lateScheduleSessions = lateSchedule;
            console.log(' this.lateScheduleSessions- ' + JSON.stringify(this.lateScheduleSessions));
            if (this.lateScheduleSessions.length > 0) {
                const result = await LightningConfirm.open({
                    message: 'You are scheduling this session late. Ideal scheduling should be done 24hrs in advance. Are you sure you want to proceed?',
                    variant: 'header',
                    label: 'Please Confirm',
                    theme: 'success'
                });
                if (result) {
                    this.getdynamicpicklistvalFunc('HM_Session__c', 'Late_Scedule__c');
                    this.isShowModalForLateSchedule = true;
                }
            } else {
                this.saveLateScheduleFunc();
            }
        }
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
                session.status = 'Unscheduled';
                session.statusClassName = 'UnscheduledCls';
                session.startTimeRequired = false;
                session.dateRequired = false;

            });
            const lateScheduleSessionsIds = new Set(this.lateScheduleSessions.map(fs => fs.id));
            const updateLateScheduleReason = (sessions) => {
                sessions.forEach(session => {
                    if (lateScheduleSessionsIds.has(session.id)) {
                        session.reasonForLateSchedule = null;
                        session.scheduleLate = false;
                        session.editedDateTime = true;
                        session.sessionDate = null;
                        session.startTimeFormatted = null;
                        session.startTime = '';
                        session.status = 'Unscheduled';
                        session.statusClassName = 'UnscheduledCls';
                        session.startTimeRequired = false;
                        session.dateRequired = false;
                    }
                });
            };
            updateLateScheduleReason(this.hmSessions);
        }
        handleLateScheduleChange(event) {
            const sessionId = event.target.dataset.id; // Get the session ID
            const newReason = event.detail.value; // Get the new selected reason value
            this.reasonForLateSch = event.detail.value;
            const updateLateScheduleReason = (sessions) => {
                return sessions.map(session => {
                    if (session.id === sessionId) {
                        return { ...session, reasonForLateSchedule: newReason, scheduleLate: true };
                    } else {
                        return { ...session, scheduleOnTime: true };
                    }
                });
            };

            this.hmSessions = updateLateScheduleReason(this.hmSessions);
            this.lateScheduleSessions = updateLateScheduleReason(this.lateScheduleSessions)
        }
        onclickOk(event) {
            const hasMissingReason = this.lateScheduleSessions.some(session => !session.reasonForLateSchedule);
            if (hasMissingReason) {
                this.showToastMessage('Please select a reason for all late scheduled sessions.', 'error');
            } else {
                this.showLoading = true;
                this.isShowModalForLateSchedule = false;
                this.saveLateScheduleFunc();
            }
        }
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
        changeSessionLead(event) {
            const sessionId = event.target.dataset.sessionId;
            const selectedValue = event.detail.value;
            const isFilled = val => val !== null && val !== undefined && val !== '';
            const updateSessionFields = (sessions) => {
                return sessions.map(session => {
                    if (session.id === sessionId) {
                        const hm = session.hmAttended;
                        const lead = selectedValue;
                        const anySelected = isFilled(hm && hm !== '') || isFilled(lead && lead !== '');
                        session.hmRequired = anySelected;
                        session.leadRequired = anySelected;
                        session.sessionLead = selectedValue;
                        session.isEdited = true;

                    }
                    return session;
                });
            };
            this.hmSessions = updateSessionFields(this.hmSessions);
        }

        changeHmAttended(event) {
            const sessionId = event.target.dataset.sessionId;
            const selectedValue = event.detail.value;
            const isFilled = val => val !== null && val !== undefined && val !== '';
            const updateSessionFields = (sessions) => {
                return sessions.map(session => {
                    if (session.id === sessionId) {
                        const hm = selectedValue;
                        const lead = session.sessionLead;
                        const anySelected = isFilled(hm && hm !== '') || isFilled(lead && lead !== '');
                        session.hmRequired = anySelected;
                        session.leadRequired = anySelected;
                        session.hmAttended = selectedValue;
                        session.isEdited = true;
                    }
                    return session;
                });
            };
            this.hmSessions = updateSessionFields(this.hmSessions);
        }
        changeDateTime(event) {
            const sessionId = event.target.dataset.sessionId;
            const selectedValue = event.detail.value;
            let selectedTimeValue = '';
            let formatedTimeVal = '';
            const isFilled = val => val !== null || val !== undefined || val !== '';
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

                        const anySelected = isFilled(session.startTime && selectedValue !== null) || isFilled(session.date && selectedValue !== null);

                        session.startTimeRequired = anySelected;
                        session.dateRequired = anySelected;
                    }
                    return session;
                });
            };

            this.hmSessions = updateSessionFields(this.hmSessions);

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
                            if(selectedValue == null || selectedValue == ''){
                                session.startTimeRequired = false;
                                session.dateRequired = false;
                            }

                            if ((session.oldDatevalue !== selectedValue || session.oldTime !== selectedTimeValue)) {
                                formatedTimeVal = this.formatTimeToInput(selectedTimeValue);
                                if (event.target.label === 'Date') return { ...session, sessionDate: selectedValue,startTimeFormatted: formatedTimeVal, editedDateTime: true, scheduleLate: false, scheduleOnTime: false };
                                if (event.target.label === 'Start Time') return { ...session, startTime: selectedValue, editedDateTime: true, scheduleLate: false, scheduleOnTime: false };
                            } else {
                                if (event.target.label === 'Date') return { ...session, sessionDate: selectedValue, editedDateTime: false, scheduleLate: false, scheduleOnTime: false };
                                if (event.target.label === 'Start Time') return { ...session, startTime: selectedValue, editedDateTime: false, scheduleLate: false, scheduleOnTime: false };
                            }
                        }
                        return session;
                    });
                };

                this.hmSessions = updateSessions(this.hmSessions);
            }

        }

        getdynamicpicklistvalFunc(objName, fldName) {
            getdynamicpicklistval({
                objectName: objName,
                fieldName: fldName
            })
                .then(result => {
                    if (result) {
                        if (fldName === 'Session_Lead__c') {
                            this.optionsSessionLead = result;
                        }
                        if (fldName === 'HM_Attended__c') {
                            this.optionsHmAttended = result;
                        }
                        if (fldName === 'Late_Scedule__c') {
                            this.lateScheduleReasonOption = result;
                        }
                    }

                }).catch(error => {
                    this.showToastMessage(error.body.message, 'error');
                    console.log(error.body.message);
                });
        }
        formatTimeToInput(s) {
            if (s === 0) {
                return '00:00';
            }
            if (!s) return '';

            let time = new Date(s);
            let hours = time.getUTCHours();
            let minutes = time.getUTCMinutes();

            // Ensure two-digit formatting
            hours = hours < 10 ? '0' + hours : hours;
            minutes = minutes < 10 ? '0' + minutes : minutes;

            return `${hours}:${minutes}`;

        }
    async getSessionListFunc() {
            lstsessionRecords({
                schoolId: this.schoolId,
                loggedInTrainer: this.facEmailId
            })
                .then(result => {
                    console.log('result = ', JSON.stringify(result));
                    this.hmSessions = result;
                    this.hmSessions.forEach((session, index) => {
                        session.startTimeFormatted = this.formatTimeToInput(session.startTime);
                        session.reasonForLateSchedule = '';
                        if (session.sessionDate == undefined) {
                            if (!session.isCounselingSession) {
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
                        const prevSession = this.hmSessions[index - 1];
                        let greaterThanOneHr;
                        let pastTime = this.isExactMatch(session.oldDatevalue, session.startTimeFormatted);
                        const diffHours = this.calTimeDiff(session.oldDatevalue, session.startTimeFormatted);
                        session.pastTime = pastTime;
                        if (diffHours > 1) {
                            greaterThanOneHr = true;
                        }

                        if (session.facilitatorId === this.facEmailId) {

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
                                if (index != 0) {
                                    if (prevSession.status == 'Complete') {
                                        session.disableAttendance = false;
                                    } else {
                                        session.disableAttendance = true;
                                    }
                                } else {
                                    session.disableAttendance = false;
                                }
                                //session.disableStartTimeNDate = true;

                            } else {
                                session.disableAttendance = true;
                                //session.disableStartTimeNDate = false;
                            }

                            if (session.status == 'Scheduled' && pastTime == true) {
                                session.status = 'Ready for Attendance';
                                session.statusClassName = 'ReadyforAttendanceCls';
                            }
                            if (session.disableStartTimeNDate) {
                                if (session.hmAttended != '' && session.sessionLead != '') {
                                    session.isRFA = false;
                                    session.disableAttendance = true;
                                } else {
                                    session.isRFA = true;
                                }
                            }


                        } else {
                            session.disableStartTimeNDate = true;
                            session.disableAttendance = true;
                        }
                    });
                    console.log('this.hmSessions = ', JSON.stringify(this.hmSessions));
                    this.hasHMSessions = this.hmSessions && this.hmSessions.length > 0;
                    if (window.innerWidth < 768) {
                        this.activeChildSession = [];
                    } else {
                        this.activeChildSession = [
                            ...this.hmSessions.map(session => session.id)
                        ];
                    }
                }).catch(error => {
                    console.log(error);
                    this.showToastMessage(error.body.message, 'error');
                });
        }

        isExactMatch(inputDate, inputTime) {
            if (!inputDate || inputTime == null) return false;

            const now = new Date();
            const inputDateTime = new Date(`${inputDate}T${this.formatTime(inputTime)}`);
            return inputDateTime < new Date();

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

        onClickPendingSession(event) {

            //this.showLoading = true;
            event.preventDefault(); // prevent navigation
            const hrefValue = event.currentTarget.getAttribute('href');
            const decodedHref = hrefValue.replace(/&amp;/g, '&');
            const params = new URLSearchParams(decodedHref);
            this.schoolId = params.get('sId');
            this.getSchoolListFunc();
            this.getSessionListFunc();
            /*this.batch = params.get('bId');
            this.getSessionListFunc();
            this.grade = params.get('grade');
            this.getBatchFunc();*/
            this.hideModalBox();

        }

        getPendingSessionFunc() {
            getPendingSessionData({
                stremail: this.facEmailId
            })
                .then(result => {
                    this.showLoadingModal = false;
                    if (result) {
                        console.log('result = ', result);
                        this.sessionList = Object.entries(result).map(([key, value], index) => {
                            return {
                                key,
                                value,
                                index: index + 1
                            };
                        });
                        this.showPendingSession = this.sessionList.length > 0;
                        //this.sessionStudentDataFunc();
                    }

                }).catch(error => {
                    console.log(error.body.message);
                    this.showLoadingModal = false;
                    this.showToastMessage(error.body.message, 'error');

                });
        }

        showModalBox() {
            this.isShowModal = true;
        }
        hideModalBox() {
            this.isShowModal = false;
            this.getSchoolListFunc();
        }

        handleSelectOption(event) {
            this.schoolId = event.detail;
            this.getSessionListFunc();

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

        connectedCallback() {
            //Inactivity code start
            this.startInactivityTimer();
            window.addEventListener('mousemove', this.resetTimer);
            window.addEventListener('keydown', this.resetTimer);
            window.addEventListener('click', this.resetTimer);
            window.addEventListener('scroll', this.resetTimer);
            window.addEventListener('touchstart', this.resetTimer);
            //Inactivity code end

            //onclose tab
            window.addEventListener("beforeunload", this.handleTabClose);

            if (this.code == window.name) {
                if (!this.code || !this.facEmailId) {

                    this.showToastMessage('Error While Login', 'error');
                    this.backToLogin();
                } else {
                    this.getdynamicpicklistvalFunc('HM_Session__c', 'HM_Attended__c');
                    this.getdynamicpicklistvalFunc('HM_Session__c', 'Session_Lead__c');
                    this.getPendingSessionFunc();
                }
            } else {

                this.showToastMessage('This form is already open in another tab!', 'error');
                this.backToLogin();
            }
        }
        handleTabClose = (event) => {
            this.sessionSignOutFunc();

        };
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

        //Inactivity code start
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
        //inactivity code end

        @wire(CurrentPageReference)
        getStateParameters(currentPageReference) {
            if (currentPageReference) {

                const rxCurrentPageReference = JSON.parse(JSON.stringify(currentPageReference));
                this.code = rxCurrentPageReference.state.code ? decodeURI(rxCurrentPageReference.state.code) : null;
                this.facEmailId = rxCurrentPageReference.state.facilitorId ? decodeURI(rxCurrentPageReference.state.facilitorId) : null;
                /*this.schoolId = rxCurrentPageReference.state.schoolId ? decodeURI(rxCurrentPageReference.state.schoolId) : null;
                this.batch = rxCurrentPageReference.state.batch ? decodeURI(rxCurrentPageReference.state.batch) : null;
                this.grade = rxCurrentPageReference.state.grade ? decodeURI(rxCurrentPageReference.state.grade) : null;
                this.back = rxCurrentPageReference.state.back ? decodeURI(rxCurrentPageReference.state.back) : null;
                this.showError = rxCurrentPageReference.state.showError ? decodeURI(rxCurrentPageReference.state.showError) : null;*/

            }
        }
        showToastMessage(message, variant) {
            const event = new ShowToastEvent({
                title: 'HM Session',
                message: message,
                variant: variant
            });
            this.dispatchEvent(event);
        }
        renderedCallback() {
            if (typeof window !== 'undefined') {
                const style = document.createElement('style');
                style.innerText = `.saveButton button.slds-button.slds-button_brand {
                width: 7%;
                height: 38px;
                color: #fff;
            }.lateSchedulePopup .btnCancel button.slds-button.slds-button_brand {
                background-color: #1A1A1A;
                color: #fff;
            }.lateSchedulePopup .btnOk button.slds-button.slds-button_brand {
                background-color: #50A771;
                color: #fff;
            }.lateSchedulePopup .btnGrp button.slds-button.slds-button_brand {
                width: 20%;
            }.CompleteCls .slds-input, .CompleteCls button.slds-button.slds-button_brand{
                background-color:#92DB72 !important; text-align: center !important;
            }.ReadyforAttendanceCls .slds-input, .ReadyforAttendanceCls button.slds-button.slds-button_brand{
                background-color:#9ABBFF !important; text-align: center !important; overflow-wrap: break-word !important;
            }.ScheduledCls .slds-input, .ScheduledCls button.slds-button.slds-button_brand{
                background-color:#EEDA5E !important; text-align: center !important;
            }.UnscheduledCls .slds-input, .IncompleteCls .slds-input, .IncompleteCls button.slds-button.slds-button_brand, .UnscheduledCls button.slds-button.slds-button_brand{
                background-color:#E88775 !important; text-align: center !important;
            }.sessionAccordion h2.slds-accordion__summary-heading {
                color: #49445C;
                font-weight: bold;
                font-size: 18px;
            }button.slds-button.slds-button_brand {
                width: 12%;
                color: #000;
            }section.slds-modal.fix-slds-modal.slds-modal_prompt.slds-fade-in-open button.slds-button.slds-button_brand {
                width: auto;
            }section.slds-modal.fix-slds-modal.slds-modal_prompt.slds-fade-in-open button.slds-button.slds-button_brand {
                width: auto;
            }
            .sessionAccordion svg.slds-button__icon.slds-button__icon_left.slds-icon.slds-icon-text-default.slds-icon_x-small{
                fill: #49445C;
                margin-right: 15px;
            }
            .sessionAccordion .slds-accordion__summary-heading .slds-button:focus {
                box-shadow: none;
            }.sessionAccordion lightning-accordion-section.slds-accordion__list-item {
                border: none;
            }.sessionAccordion input{
                color: #49445C !important;
                border: 1px solid #49445C !important;
            }
            .sessionAccordion label.slds-form-element__label.slds-no-flex, .sessionAccordion label.slds-form-element__label {
                color: #49445C !important;
                margin-bottom: 20px;
            }
            .pendingSessionModal .slds-modal__container{
                max-width: 60rem;
                min-width: 60rem;
            }
            .main-menu-button button.slds-button.slds-button_neutral {
                --slds-c-button-color-background: #49445C; 
                --slds-c-button-text-color: white;
                --slds-c-button-radius-border: 5px;
                font-weight: 400 !important;
                font-size: 13px;
                padding: 0 1rem;
                display: inline-flex;
                align-items: center;
            }
            .main-menu-button button.slds-button.slds-button_neutral:hover {
                color: #fff;
            }.slds-modal__footer.slds-theme_default button.slds-button.slds-button_brand {
                background-color: green;
                color: #fff;
            }
            .main-menu-button button.slds-button.slds-button_neutral::before {
                content: '←';
                color: white;
                margin-right: 8px;
                font-size: 18px;
            }@media (max-width: 767px) {
                .main-menu-button button.slds-button.slds-button_neutral::before {
                    position: relative;
                    bottom: 3px;
                }
                .pendingSessionModal .slds-modal__container{
                    max-width: auto;
                    min-width: auto;
                }lightning-button.saveButton button.slds-button.slds-button_brand {
                    width: 18%;
                    height: 35px;
                }button.slds-button.slds-button_brand{
                    width:50%;
                }
            }
            `;
                this.template.querySelector('div').appendChild(style);
            }
        }
        handleClickMainMenu(event){
            let pageReference = {
                type: 'comm__namedPage',
                attributes: {
                    name: 'SessionMainMenu__c'
                },
                state: {
                    facilitorId: encodeURI(this.facEmailId),
                    code: encodeURI(this.code)
                }
            };
            this[NavigationMixin.Navigate](pageReference);
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
        backToLogin() {
            this[NavigationMixin.Navigate]({
                type: 'comm__namedPage',
                attributes: {
                    name: 'SessionLogin__c'
                }
            });
        }
    }