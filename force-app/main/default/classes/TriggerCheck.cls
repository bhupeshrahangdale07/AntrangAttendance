/* Created and updated batch number,created code for city,state,district and school.
Calculating number of students pending counselling, calculating the number of students in school.
Calculating number of students facilitated for every batch*/
global class TriggerCheck {
    global static boolean run = true;
    global static boolean contactRun = true;
    global static boolean schoolCheck = true;
    global static boolean batchCheck = true;
    global static boolean runOnce() {
        if (run) {
            run = false;
            return true;
        } 
        else {
            return run;
        }
    }  
    global static boolean runOnceContact() {
        if (contactRun) {
            contactRun = false;
            run = true;
            return true;
        } 
        else {
            return contactRun;
        }
    }
    
    public void createBatchNumber(Id id) {
        String batchNumber = '',state='',stateCode ='',districtCode='',cityCode = '',wardCode = '',schoolCode ='',batchCodeString ='',district,city,ward,school,batcheString,numberOfStudentPending;
        Integer batchCode,pending,facilitated=0,counselled=0,numberOfStudents = 0;
        List<Batch__c> batchData = new List<Batch__c>();
        List<Account> schoolData = new List<Account>();
        List<State_Govt_Body_Level__c> stateData = new List<State_Govt_Body_Level__c>();
        List<District_Master__c> districtData = new List<District_Master__c>();
        List<City_Master__c> cityData = new List<City_Master__c>();
        List<Ward_Master__c> wardData =  new List<Ward_Master__c>();
        List<Batch__c> batchList = new List<Batch__c>();
        List<Account> schoolData1 = new List<Account>();
        List<Batch__c> batchListNew = new List<Batch__c>();
        Batch__c batch;
        Account account;
        State_Govt_Body_Level__c stateGOV;
        District_Master__c districtMaster;
        City_Master__c cityMaster;
        Ward_Master__c wardMaster;
        Account school1;
        
        /* get school name from batch*/
        batchData = [select School_Name__c,Number_of_students_facilitated__c,Number_of_students_counselled__c from Batch__c where Batch__c.id=: + id ];
        batch = batchData.get(0);
        
        /* get School detail based on school name*/
        schoolData = [select State__c, City__c, Ward__c , District__c from Account where Account.Id=: + batch.School_Name__c];
        account=schoolData.get(0);
   
        /* count of batch from Batch__c*/
        batchList = [select School_Name__c from Batch__c Where School_Name__c =: batch.School_Name__c];
        if (batchList.size()>0){
            batchCode = batchList.size();
            batcheString = String.valueOf(batchCode);
            if (batcheString.length() == 1){
                batchCodeString += '0'+batcheString;
            } 
            else if (batcheString.length() == 2){
                batchCodeString += batcheString;
            } 
            else{
                batchCodeString += batcheString.substring(batcheString.length()-2, batcheString.length());} 
        }
        
        /* calculating Number of students pending counselling */
        
        if (batch.Number_of_students_facilitated__c != null){
            facilitated=Integer.valueOf(batch.Number_of_students_facilitated__c);
        }
        if (batch.Number_of_students_counselled__c != null){
            counselled=Integer.valueOf(batch.Number_of_students_counselled__c);
        }
        pending = facilitated - counselled;
        numberOfStudentPending=String.valueOf(pending);
        batch.Number_of_students_pending_counselling__c=numberOfStudentPending;
        update batch;
        
        /* Calculation for number of students in school*/
        
        schoolData1 = [select name, Number_of_students__c  from Account where Account.Id=: batch.School_Name__c];
        school1=schoolData1.get(0);
        batchListNew= [select name,Number_of_students_facilitated__c from Batch__c where Batch__c.School_Name__c=:  batch.School_Name__c ];
        
        for (Integer i=0;i < batchListNew.size();i++) {   
            Batch__c batchNew= batchListNew.get(i);
            if (batchNew.Number_of_students_facilitated__c != null){
                numberOfStudents = numberOfStudents + Integer.valueOf(batchNew.Number_of_students_facilitated__c);
            }
            else {
                numberOfStudents = numberOfStudents + 0; }
        }
        school1.Number_of_students__c= String.valueOf(numberOfStudents);
        update school1;
        
    }
    
    public  void calculateNumberOfBatches(Id id) {
        String donarName,trainerName;
        Integer count,countTrainer; 
        List<Batch__c> batchData = new List<Batch__c> ();
        List<Batch__c> batchList = new List<Batch__c> ();
        List<Batch__c> batchListTrainer = new List<Batch__c> ();
        List<Contact> trainerData = new List<Contact> ();
        List<Account> donarData = new List<Account> ();
        Batch__c batch;
        Account donar;
        Contact trainer;
        /* get Donar name   */
        batchData = [select Donor_Name__c,Trainer_Name__c from Batch__c where Batch__c.id=: + id];
        if (batchData.size()>0) {
            batch= batchData.get(0);
            donarName = batch.Donor_Name__c;
            trainerName = batch.Trainer_Name__c;
            
            /* get List of batches based on donar name*/
            batchList = [select id from Batch__c where Batch__c.Donor_Name__c=: + batch.Donor_Name__c];
            count = batchList.size();
            
            /* get List of batches based on Trainer name*/
            batchListTrainer = [select id from Batch__c where Batch__c.Trainer_Name__c=: + batch.Trainer_Name__c];
            countTrainer = batchListTrainer.size();
            
            
            /* get data of donar from account object*/
            if (donarName!=null) {
                donarData = [select id,Number_of_batches_allocated__c from Account where Account.id=: + donarName];
                donar= donarData.get(0);
                if (count == 0) {
                    donar.Number_of_batches_funded__c = 0;
                } 
                else {
                    donar.Number_of_batches_funded__c = count;}   
                if (donar.Number_of_batches_allocated__c ==null) {
                    donar.Number_of_batches_allocated__c = 0;
                }
                donar.Number_of_batches_pending__c = donar.Number_of_batches_allocated__c - count;
                update donar;
            }
            
            /* get data of Trainer from contact object*/    
            if (trainerName!=null) {
                trainerData = [select id,Number_Of_Batches__c from Contact where Contact.id=: + trainerName];
                trainer = trainerData.get(0);
                if (countTrainer == 0) {
                    trainer.Number_Of_Batches__c = 0;
                } 
                else {
                    trainer.Number_Of_Batches__c = countTrainer;}   
                if (trainer.Number_Of_Batches__c ==null) {
                    trainer.Number_Of_Batches__c = 0;
                }
                update trainer;
            } 
        }
    }
    
    public  void calculateNumberOfBatches(Id id,Id donorId) {
        Integer countold,count;
        String donorName;
        List<Batch__c> donarId = new List<Batch__c>();
        List<Account> donorDataNew = new List<Account>();
        List<Batch__c> batchListNew = new List<Batch__c>();
        List<Batch__c> batchData = new List<Batch__c>();
        List<Batch__c> batchList = new List<Batch__c>();
        List<Account> donorData = new List<Account>();
        Account donorNew;
        Batch__c batch;
        Account donor;
        
        if (donorId == null) {
            donarId = [select Donor_Name__c from Batch__c where Batch__c.id=: + id];
            donorId = donarId.get(0).Donor_Name__c;
        }
        
        donorDataNew = [select id,Number_of_batches_allocated__c,Number_of_batches_pending__c from Account where Account.id=: + donorId];
        donorNew = donorDataNew.get(0);
        // Added by Kandisa Tech 1Feb2018 - Fix error of Number Of Batches Pending to be blank.
        if(donorNew.Number_of_batches_pending__c  == null)
            donorNew.Number_of_batches_pending__c = 0;
        donorNew.Number_of_batches_pending__c =  donorNew.Number_of_batches_pending__c + 1;
        
        batchListNew = [select id from Batch__c where Batch__c.Donor_Name__c=: + donorId];
        countold = batchListNew.size();
        
        donorNew.Number_of_batches_funded__c = countold;
        update donorNew;
        
        /* get Donar name   */
        batchData = [select Donor_Name__c from Batch__c where Batch__c.id=: + id];
        if (batchData.size()>0) {
            batch = batchData.get(0);
            donorName = batch.Donor_Name__c;
            
            /* get List of batches based on donar name*/
            batchList = [select id from Batch__c where Batch__c.Donor_Name__c=: + batch.Donor_Name__c];
            count = batchList.size();
            
            /* get data of donar from account object*/
            if (donorName!=null) {
                donorData = [select id,Number_of_batches_allocated__c from Account where Account.id=: + donorName];
                donor = donorData.get(0);
                if (count == 0) {
                    donor.Number_of_batches_funded__c = 0;
                }
                else {
                    donor.Number_of_batches_funded__c = count;
                }
                donor.Number_of_batches_pending__c = donor.Number_of_batches_allocated__c - count;
                update donor;
            }
        }
    }

    public void updateNumberOfStudentFacilitated(Id id) {
        List<Contact> studentList = new List<Contact>();
        List<Contact> batchList = new List<Contact>();
        List<Batch__c> batchListNew =new List<Batch__c>();
        Contact student;
        Batch__c batch;
        
        /* getting student details based on id*/
        studentList = [select name,Batch_Code__c from Contact where Contact.Id=: + id];
        student = studentList.get(0);
        
        /* getting List of student based on batch id*/
        batchList = [select Batch_Code__c from Contact where Contact.Batch_Code__c=: student.Batch_Code__c];
        
        /* getting batch details  based on batch id*/
        batchListNew = [select Number_of_students_facilitated__c from Batch__c where Batch__c.Id =: student.Batch_Code__c ];
        batch=new Batch__c();
        
        /* calculating Number of students facilitated*/
        if (batchListNew.size() > 0){
            batch =batchListNew.get(0);
            batch.Number_of_students_facilitated__c = batchList.size();
            update batch;
        }
    }
    
    public void updateNumberOfStudentFacilitated(Id id,Id batchId) {
        /* when user change batch from student*/
        List<Contact> trainer = new List<Contact>();
        List<Batch__c> batchListNew1 = new List<Batch__c>();
        List<Contact> studentList = new List<Contact>();
        List<Contact> StudentbatchList = new List<Contact>();
        List<Batch__c> batchList = new List<Batch__c>();
        Batch__c batchNew;
        Contact student;
        Batch__c batch;
        
        /* checking whether the trainer is assigned or not */
        if (batchId == null) {
            trainer = [select Batch_Code__c from Contact where Contact.id=: + id];
            batchId = trainer.get(0).Batch_Code__c;
        }
        
        /* getting batch deatils based on batch id and calculate number of  students facilitated */
        batchListNew1 = [select Number_of_students_facilitated__c from Batch__c where Batch__c.Id =: + batchId ];
        batchNew =batchListNew1.get(0);
        if (batchNew.Number_of_students_facilitated__c!=null) {
            batchNew.Number_of_students_facilitated__c = batchNew.Number_of_students_facilitated__c - 1 ;
        }
        else {
            batchNew.Number_of_students_facilitated__c = 0; 
        }
        
        /* getting student details based on id*/
        studentList = [select name,Batch_Code__c from Contact where Contact.Id=: + id];
        student= studentList.get(0);
        
        /* getting list of contact based on batch id*/
        StudentbatchList = [select Batch_Code__c from Contact where Contact.Batch_Code__c=: student.Batch_Code__c];
        
        batchList = [select Number_of_students_facilitated__c from Batch__c where Batch__c.Id =: student.Batch_Code__c ];
        batch = batchList.get(0);
        batch.Number_of_students_facilitated__c = StudentbatchList.size();
        update batchNew;
        
        TriggerCheck.run=true;
        update batch;
    }
    
    public void calculateNumberOfStudent(Id id,Id schoolId) {
        /* when user change School from batch */
        Integer numberOfStudents = 0,numberOfStudentsNew = 0;
        List<Account> schoolData = new List<Account>();
        List<Batch__c> batchListNew = new List<Batch__c>();
        List<Account> schoolDataNew = new List<Account>();
        List<Batch__c> batchList =  new List<Batch__c>();
        Account school;
        Account schoolNew;
        
        schoolData = [select name, Number_of_students__c  from Account where Account.Id=: schoolId];
        school = schoolData.get(0);
        
        batchListNew= [select name,Number_of_students_facilitated__c from Batch__c where Batch__c.School_Name__c=:  schoolId];
        
        for (Integer i=0;i < batchListNew.size();i++) {   
            Batch__c batchNew= batchListNew.get(i);
            if (batchNew.Number_of_students_facilitated__c != null) {
                numberOfStudents = numberOfStudents + Integer.valueOf(batchNew.Number_of_students_facilitated__c);
            }
            else {
                numberOfStudents = numberOfStudents + 0; 
            }
        }
        
        school.Number_of_students__c= String.valueOf(numberOfStudents);
        update school;
        
        schoolDataNew = [select name, Number_of_students__c  from Account where Account.Id=: id];
        schoolNew=schoolDataNew.get(0);
        
        batchList = [select name,Number_of_students_facilitated__c from Batch__c where Batch__c.School_Name__c=:  id];
        
        for (Integer i=0;i < batchList.size();i++) {   
            Batch__c batchNew1= batchList.get(i);
            if (batchNew1.Number_of_students_facilitated__c != null) {
                numberOfStudentsNew = numberOfStudentsNew + Integer.valueOf(batchNew1.Number_of_students_facilitated__c);
            } 
            else {
                numberOfStudentsNew = numberOfStudentsNew + 0; 
            }
        }
        
        schoolNew.Number_of_students__c= String.valueOf(numberOfStudentsNew);
        update school;
        TriggerCheck.run=true;
        update schoolNew;
    }
    
    public void updateNumberOfStudent(Id id) {
        /* updating number of studnets facilitated in batch when user change batch in student*/
        List<Contact> studentList = new List<Contact>(); 
        List<Batch__c> batchListNew = new List<Batch__c>();
        List<Batch__c> updateBatch = new List<Batch__c>();
        Map<Id,Decimal> mapOfBatch = new Map<Id,Decimal>();
        Contact student;
        Batch__c batch;
        List<id> batchIds = new List<Id>();
        studentList = [select name,Batch_Code__c,G10_Batch_Code__c,G11_Batch_Code__c,G12_Batch_Code__c from Contact where Id=: id];
            batchIds.add(studentList[0].Batch_Code__c);
            batchIds.add(studentList[0].G10_Batch_Code__c);
            batchIds.add(studentList[0].G11_Batch_Code__c);
            batchIds.add(studentList[0].G12_Batch_Code__c);
        
        If(!batchIds.isEmpty() && batchIds.Size() > 0){
            batchListNew = [select Number_of_students_facilitated__c,(select Id,Attendance__c from Contacts__r where Id=: id),(select Id,Attendance__c from Contacts1__r where Id=: id),(select Id,Attendance__c from Contacts2__r where Id=: id),
                            (select Id,Attendance__c from Contacts3__r where Id=: id) from Batch__c where Id in: batchIds];
            
            if(!batchListNew.isEmpty() && batchListNew.size() > 0){
                for(Batch__c bt: batchListNew){
                    //bt.Number_of_students_facilitated__c = bt.Number_of_students_facilitated__c-1;
                    Integer newNumberOfFecilatedStudent = 0;
                    for (Contact c : bt.Contacts__r) {
                        newNumberOfFecilatedStudent++;
                    }
                    for (Contact c : bt.Contacts1__r) {
                        newNumberOfFecilatedStudent++;
                    }
                    for (Contact c : bt.Contacts2__r) {
                        newNumberOfFecilatedStudent++;
                    }
                    for (Contact c : bt.Contacts3__r) {
                        newNumberOfFecilatedStudent++;
                    }
                    system.debug('newNumberOfFecilatedStudent ::' +newNumberOfFecilatedStudent);
                    bt.Number_of_students_facilitated__c = bt.Number_of_students_facilitated__c-newNumberOfFecilatedStudent;
                    updateBatch.add(bt);
                }
            }
            if(!updateBatch.isEmpty() && updateBatch.size() > 0){
                update updateBatch;
            }
        }
       /** student =studentList.get(0);
        if(student.Batch_Code__c !=null){
        batchList = [select Batch_Code__c from Contact where Contact.Batch_Code__c=: student.Batch_Code__c];
        batchListNew = [select Number_of_students_facilitated__c from Batch__c where Batch__c.Id =: student.Batch_Code__c ];
        batch = batchListNew.get(0);
        batch.Number_of_students_facilitated__c = batchList.size()-1;
        update batch;
        }**/
    }
    
    public void updateDonor(Id id) {
        /* updating number of batches allocated in donor after changing batch*/
        List<Account> donarData =new List<Account>();
        Account donar;
        donarData = [select id,Number_of_batches_allocated__c,Number_of_batches_funded__c from Account where Account.id=: + id];
        donar= donarData.get(0);
        if (donar.Number_of_batches_funded__c != null) {
            if (donar.Number_of_batches_allocated__c ==null) {
                donar.Number_of_batches_allocated__c=0;
            }
            donar.Number_of_batches_pending__c = donar.Number_of_batches_allocated__c - donar.Number_of_batches_funded__c ;
            update donar;  
        }
    }
    
    public  void setVariable(Boolean s) {
        run = s;
    }
    
    public  void setVariableCon(Boolean s) {
        contactRun = s;
    }
}