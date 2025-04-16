public class OMRObjectsDuplicateAssesmentScheduler implements Schedulable{
    
    public string objectApiName;
    
    public OMRObjectsDuplicateAssesmentScheduler(string objectApiName){
        this.objectApiName = objectApiName;
    }
    
    public void execute(SchedulableContext sc) 
    {
        OMRObjectsDuplicateAssesmentBatch obj = new OMRObjectsDuplicateAssesmentBatch(objectApiName);
        Database.executeBatch(obj);    
    }

}