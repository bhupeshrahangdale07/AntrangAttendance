global class CareerAwareScheduler{
    global void JobScheduling (){
        StudentIARPInformation studentIARPInfo = new StudentIARPInformation();
        IARPRecommendation iarpRecomm= new IARPRecommendation();
        string strSeconds = '0';
        string strHours = '0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23';
        string strDay_of_month = '*';
        string strMonth = '*';
        string strDay_of_week = '?';
        for (Integer i=0;i<60;i=i+5){
            string strMinutes = String.valueOf(i);
            String sch = strSeconds + ' ' + strMinutes + ' ' + strHours + ' ' + strDay_of_month + ' ' + strMonth + ' ' + strDay_of_week;
            
            if (Math.mod(i, 10)==0){
                String name= 'IARP'+' Min '+strMinutes;
                System.schedule(name, sch, studentIARPInfo);
            }
            else
            {
                String name1= 'Recomm'+' Min '+strMinutes;
                System.schedule(name1, sch, iarpRecomm);
            }
        }
        
    }

}