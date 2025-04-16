public class updateContactOtherPhoneForCounseling implements Database.Batchable<sObject> {
    
    List<Contact> conLST = new List<Contact>();
    
    public updateContactOtherPhoneForCounseling(List<Contact> conLST){
        this.conLST = conLST;
    }
    
    public Iterable<sObject> start(Database.BatchableContext BC){
        return conLST;
    }
    
    public void execute(Database.BatchableContext BC, List<Contact> scope){
        update scope;
    }
    
    public void finish(Database.BatchableContext BC){
    }
    
}