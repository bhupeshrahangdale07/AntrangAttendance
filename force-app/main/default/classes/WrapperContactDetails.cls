/*
    wrapper class is used to contact detail
*/
public class WrapperContactDetails {
        public String grade{set;get;}
        public String batchNumber{set;get;}
        public String schoolName{set;get;}
        public String trainerName{set;get;}
        public String interest1{set;get;}
        public String interest2{set;get;}
        public String aptitude1{set;get;}
        public String aptitude2{set;get;}
        public String personality1{set;get;}
        public String personality2{set;get;}
        public String personality3{set;get;}
        public String personality4{set;get;}
        public String personality5{set;get;}
        public String personality6{set;get;}
        public String personality7{set;get;}
        public String personality8{set;get;}
        public String reality1{set;get;}
        public String reality2{set;get;}
        public String reality3{set;get;}
        public String reality4{set;get;}
        public String reality5{set;get;}
        public String reality6{set;get;}
        public String reality7{set;get;}
        public String reality8{set;get;}
        Public String profession1{set;get;}
        Public String profession2{set;get;}
        Public String commaSepratedList{set;get;}
        public Contact objcontact {get; set;}
        public Boolean professionshowContent1 { get; set; }
        public Boolean professionshowContent2 { get; set; }
        
        public WrapperContactDetails (){
            grade = '';
            batchNumber = '';
            schoolName = '';
            trainerName = '';
            interest1 = '';
            interest2 = '';
            aptitude1 = '';
            aptitude2 = '';
            personality1 = '';
            personality2 = '';
            personality3 = '';
            personality4 = '';
            personality5 = '';
            personality6 = '';
            personality7 = '';
            personality8 = '';
            reality1 = '';
            reality2 = '';
            reality3 = '';
            reality4 = '';
            reality5 = '';
            reality6 = '';
            reality7 = '';
            reality8 = '';
            profession1 = '';
            profession2 = '';
            commaSepratedList = '';
            objcontact = new Contact();
            professionshowContent1 = false;
            professionshowContent2 = false;
        }
    }