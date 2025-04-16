global class wrapOppResponse {
         public map<string,list<opptyList>> mapofopptyList;
         
         
        global class opptyList{
            public string opportunityid;
            public string status;
            public string error;
            public List < CreateOppAssignmentRESTApi.wrapOppAssignResponse > assignments;
        }    
    }