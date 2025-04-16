public class OMRObjectHistoricUpdateScheduler implements Schedulable{

    public string objectName = Label.OMR_object_Api_Name ; 
    
    public void execute(SchedulableContext sc) 
    {
        OMRObjectHistoricUpdate obj = new OMRObjectHistoricUpdate(objectName);
        Database.executeBatch(obj);    
    }

}