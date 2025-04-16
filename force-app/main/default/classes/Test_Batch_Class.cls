public class Test_Batch_Class Implements Database.batchable<sObject> {
    
    public String query;
    public Map<id, Contact> MapCont = New Map<id,Contact>();
    public List<CA_Student_Data__c> List_CA_update = New List<CA_Student_Data__c>();
    public Set<Id> CA_Stud_Id = New Set<Id>();
    public Set<Id> newCASet = New Set<Id>();
    public List<CA_Student_Data__c> insetCAList = New List<CA_Student_Data__c>();
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        if(String.isBlank(query)) {
            query = 'Select Id, I_like_to_repair_mobiles__c, My_favourite_subject_in_school_college_i__c, I_enjoy_trying_to_gure_out_how_things__c, I_can_never_make_a_mistake_while_countin__c,I_am_good_at_calculating_how_much_to_pay__c' 
                + ' from OMR_Assessment__c '
                + ' where I_like_to_repair_mobiles__c != null';
        }
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Contact> conList) { 
        for(Contact c: conList) {
            MapCont.put(c.id,c);
        }
        
        //update CA_Stud
        for( CA_Student_Data__c s: [Select id,student__c,I_like_to_repair_mobiles__c
                                    From CA_Student_Data__c 
                                    Where student__c in: MapCont.keySet()] ){                                        
                                        if(MapCont.containsKey(s.student__c)) {                                            
                                            //s.I_like_to_repair_mobiles__c = MapCont.get(s.student__c).I_like_to_repair_mobiles__c;
                                            List_CA_update.add(s);
                                            CA_Stud_Id.add(s.student__c);
                                        }        	
                                    }        
        update List_CA_update;
        
        for(Id i: MapCont.keySet()) {
            if(!CA_Stud_Id.contains(i)) {
                newCASet.add(i);
            }
        }
        
        //insert CA_Stud
        for(Contact c: [Select Id
                        from Contact 
                        where Id In: newCASet]) {
                            CA_Student_Data__c ca = New CA_Student_Data__c();
                            ca.student__c = c.id;
                            ca.Aptitude_1__c = c.Aptitude_1__c;
                            insetCAList.add(ca);
                        }
        
        insert insetCAList;
    }
    
    public void finish(Database.BatchableContext BC){   
    }
}