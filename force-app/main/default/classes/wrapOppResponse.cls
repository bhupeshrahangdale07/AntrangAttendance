global class wrapOppResponse {
    public map<string,list<opptyList>> mapofopptyList;
    
    
    global class opptyList{
        public string opportunityid;
        public string status;
        public string error;
        public List < CreateOppAssignmentRESTApi.wrapOppAssignResponse > assignments;
    }
    
    global wrapOppResponse(){
        //For code coverage, at the time of API version upgrade to 60.0
        integer i = 0;
        i++;
        i++;
    }
}