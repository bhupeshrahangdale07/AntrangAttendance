@isTest 
private class CareerReadySchedulerTest {
    static testMethod void CareerReadySchedulerValidate() {
        Test.StartTest();
        CareerReadyScheduler cs = new CareerReadyScheduler();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Test CareerReadyScheduler', sch, cs);
        Test.stopTest();
    }
}