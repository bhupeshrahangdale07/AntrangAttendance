public class Contact_ReasonForUnavailability {

    Public Static Map<String, String> MAP_SF_PICKLIST_VALUES {
        get {
            if(MAP_SF_PICKLIST_VALUES == null || MAP_SF_PICKLIST_VALUES.size() <= 0){
                
                MAP_SF_PICKLIST_VALUES = new MAP<String, String>();
                MAP_SF_PICKLIST_VALUES.put('Currently does not have time due to education','busy because of school/college');
                MAP_SF_PICKLIST_VALUES.put('Currently does not have time due to reason other than education','busy');
                MAP_SF_PICKLIST_VALUES.put('Currently unwilling to work','don\'t want to work right now');
                MAP_SF_PICKLIST_VALUES.put('Currently working not AF','working somewhere else / working in a job (not given by Antarang)');
                MAP_SF_PICKLIST_VALUES.put('Migrated','not living in Mumbai');
                MAP_SF_PICKLIST_VALUES.put('Not allowed to work','not allowed to work');
                MAP_SF_PICKLIST_VALUES.put('Not allowed to work due to marriage','not allowed to work because of marriage');
            }
            return MAP_SF_PICKLIST_VALUES; 
        }
        set {}
    }
    
    Public Static Map<String, String> MAP_EXTERNAL_SYSTEM_VALUES {
        get {
            if(MAP_EXTERNAL_SYSTEM_VALUES == null || MAP_EXTERNAL_SYSTEM_VALUES.size() <= 0){
                
                MAP_EXTERNAL_SYSTEM_VALUES = new MAP<String, String>();
                MAP_EXTERNAL_SYSTEM_VALUES.put('busy because of school/college','Currently does not have time due to education');
                MAP_EXTERNAL_SYSTEM_VALUES.put('busy','Currently does not have time due to reason other than education');
                MAP_EXTERNAL_SYSTEM_VALUES.put('don\'t want to work right now','Currently unwilling to work');
                MAP_EXTERNAL_SYSTEM_VALUES.put('working somewhere else / working in a job (not given by Antarang)','Currently working not AF');
                MAP_EXTERNAL_SYSTEM_VALUES.put('not living in Mumbai','Migrated');
                MAP_EXTERNAL_SYSTEM_VALUES.put('not allowed to work','Not allowed to work');
                MAP_EXTERNAL_SYSTEM_VALUES.put('not allowed to work because of marriage','Not allowed to work due to marriage');
            }
            return MAP_EXTERNAL_SYSTEM_VALUES; 
        }
        set {}
    }
}