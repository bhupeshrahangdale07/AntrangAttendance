public class PlanA_BIndustryUpdateClass implements Queueable {

    public Set<Id> contactId;
    
    public PlanA_BIndustryUpdateClass (Set<id> Conids){
    this.contactId=Conids;    
    }
    
    public void execute(QueueableContext context){
         List < Contact > contToBeUpdated = new List < Contact > ();
        for (Contact con: [Select Plan_A__c,Plan_B__c ,Plan_B_Industry__c ,Plan_A_Industry__c from Contact where id in: contactId]) {
            if (con.Plan_A__c == 'Flight attendant' || con.Plan_A__c == 'Ground Staff' || con.Plan_A__c == 'Pilot' ||
                con.Plan_A__c == 'Aeronautical Engineering')
                con.Plan_A_Industry__c = 'Aerospace and Aviation';
            else if (con.Plan_A__c == 'Fashion/Jewellery (design,styling,sales)' || con.Plan_A__c == 'Tailoring')
                con.Plan_A_Industry__c = 'Apparel';
            else if (con.Plan_A__c == 'Automobile Engineering' || con.Plan_A__c == 'Driving')
                con.Plan_A_Industry__c = 'Automobile';
            else if (con.Plan_A__c == 'Accounting' || con.Plan_A__c == 'Banking services (Sales, admin, marketing, customer service)' ||
                con.Plan_A__c == 'Financial services (Insurance, Equity, Stock broking, Investement,micro finance)')
                con.Plan_A_Industry__c = 'Banking and Finance';
            else if (con.Plan_A__c == 'Beauty Services' || con.Plan_A__c == 'Cosmetology' || con.Plan_A__c == 'Hair styling' ||
                con.Plan_A__c == 'Make Up' || con.Plan_A__c == 'Massage Services' || con.Plan_A__c == 'Mehendi Services')
                con.Plan_A_Industry__c = 'Beauty and Wellness';
            else if (con.Plan_A__c == 'Architect' || con.Plan_A__c == 'Building Survey' || con.Plan_A__c == 'Carpentery' ||
                con.Plan_A__c == 'Civil Engineering' || con.Plan_A__c == 'Draftsmanship' || con.Plan_A__c == 'Interior Design' ||
                con.Plan_A__c == 'Plumbing')
                con.Plan_A_Industry__c = 'Construction and Maintenance';
            else if (con.Plan_A__c == 'Fine Art (Painter, Sculptor, Graffitti Artist, Tattoo Artist)' || con.Plan_A__c == 'Graphic Design' ||
                con.Plan_A__c == 'Landscape Design' || con.Plan_A__c == 'Web Designing')
                con.Plan_A_Industry__c = 'Design';
            else if (con.Plan_A__c == 'Curriculum development' || con.Plan_A__c == 'School administration' ||
                con.Plan_A__c == 'Early Childhood/Primary Teaching' || con.Plan_A__c == 'Professor' || con.Plan_A__c == 'School Teaching' ||
                con.Plan_A__c == 'Private Teaching')
                con.Plan_A_Industry__c = 'Education and Training';
            else if (con.Plan_A__c == 'Electrical engineering' || con.Plan_A__c == 'Electrical repairs (includes electronics)' ||
                con.Plan_A__c == 'Mechanical engineering' || con.Plan_A__c == 'Mechanical repairs (Ac/Fridge/industrial/automobiles)')
                con.Plan_A_Industry__c = 'Electronic and Hardware';
            else if (con.Plan_A__c == 'Agriculturist' || con.Plan_A__c == 'Conservationist (Wildlife)' || con.Plan_A__c == 'Environmentalist' ||
                con.Plan_A__c == 'Horticulture' || con.Plan_A__c == 'Renewable energy' || con.Plan_A__c == 'Waste management')
                con.Plan_A_Industry__c = 'Environment and Agriculture';
            else if (con.Plan_A__c == 'Dentistry' || con.Plan_A__c == 'Doctor' || con.Plan_A__c == 'Medical technologies' ||
                con.Plan_A__c == 'Mental healthcare' || con.Plan_A__c == 'Nurse' || con.Plan_A__c == 'Optometry' ||
                con.Plan_A__c == 'Paramedical' || con.Plan_A__c == 'Pharmacy' || con.Plan_A__c == 'Physiotherapy' ||
                con.Plan_A__c == 'Veterinary')
                con.Plan_A_Industry__c = 'Healthcare';
            else if (con.Plan_A__c == 'Chemical engineering' || con.Plan_A__c == 'Company Secretary' || con.Plan_A__c == 'Customer Service' ||
                con.Plan_A__c == 'Data Entry' || con.Plan_A__c == 'Entrepreneurship' || con.Plan_A__c == 'Generic Sales/Business Development' ||
                con.Plan_A__c == 'Human Resources' || con.Plan_A__c == 'International Trades(Import/Export)' ||
                con.Plan_A__c == 'Logistics/Warehousing' || con.Plan_A__c == 'Marketing' || con.Plan_A__c == 'Office Administration' ||
                con.Plan_A__c == 'Data Analyst')
                con.Plan_A_Industry__c = 'Industry Agnostic';
            else if (con.Plan_A__c == 'Artificial Intelligence' || con.Plan_A__c == 'Computer engineering' || con.Plan_A__c == 'Cyber Security' ||
                con.Plan_A__c == 'Ethical Hacking' || con.Plan_A__c == 'Software Development (web/app)')
                con.Plan_A_Industry__c = 'Information Technology';
            else if (con.Plan_A__c == 'Lawyer')
                con.Plan_A_Industry__c = 'Judiciary';
            else if (con.Plan_A__c == 'Archaeologist' || con.Plan_A__c == 'Biotechnology' || con.Plan_A__c == 'Zoology')
                con.Plan_A_Industry__c = 'Life Science';
            else if (con.Plan_A__c == 'Welding')
                con.Plan_A_Industry__c = 'Manufacturing';
            else if (con.Plan_A__c == 'Acting/Modeling' || con.Plan_A__c == 'Advertising' || con.Plan_A__c == 'Animation' ||
                con.Plan_A__c == 'Communications/Digital Marketing' || con.Plan_A__c == 'Dance' || con.Plan_A__c == 'Event management' ||
                con.Plan_A__c == 'Film Making (Direction, Editing, Production and Scripting)' ||
                con.Plan_A__c == 'Journalism (Print, Broadcast, Radio, Online)' || con.Plan_A__c == 'Music' || con.Plan_A__c == 'Photography' ||
                con.Plan_A__c == 'Public Relations' || con.Plan_A__c == 'Singing' || con.Plan_A__c == 'Writing (Novel, Poetry, Film)')
                con.Plan_A_Industry__c = 'Media and Entertainment';
            else if (con.Plan_A__c == 'Civil services (IAS)' || con.Plan_A__c == 'Firefighter' || con.Plan_A__c == 'Government services' ||
                con.Plan_A__c == 'Politics' || con.Plan_A__c == 'Social sector services')
                con.Plan_A_Industry__c = 'Public Administration';
            else if (con.Plan_A__c == 'Airforce' || con.Plan_A__c == 'Armed services' || con.Plan_A__c == 'Naval services' ||
                con.Plan_A__c == 'Police services' || con.Plan_A__c == 'Private Security(Bodyguards,etc)')
                con.Plan_A_Industry__c = 'Public services';
            else if (con.Plan_A__c == 'Retail Sales')
                con.Plan_A_Industry__c = 'Retail';
            else if (con.Plan_A__c == 'Merchant Navy')
                con.Plan_A_Industry__c = 'Shipping';
            else if (con.Plan_A__c == 'Sports coaching' || con.Plan_A__c == 'Sports management' || con.Plan_A__c == 'Sports person' ||
                con.Plan_A__c == 'Nutrition and Diet' || con.Plan_A__c == 'Fitness Training')
                con.Plan_A_Industry__c = 'Sports and Fitness';
            else if (con.Plan_A__c == 'Hotel services (QSR, housekeeping, front office)' || con.Plan_A__c == 'Tour Guide' ||
                con.Plan_A__c == 'Travel Agent' || con.Plan_A__c == 'Chef (kitchen staff)')
                con.Plan_A_Industry__c = 'Tourism and Hospitality';
            else if (con.Plan_A__c == 'Facilities (housekeeping)' || con.Plan_A__c == 'Operations')
                con.Plan_A_Industry__c = 'Facility Management';
                
              //Plan a condition check   
              
                if (con.Plan_B__c == 'Flight attendant' || con.Plan_B__c == 'Ground Staff' || con.Plan_B__c == 'Pilot' ||
                con.Plan_B__c == 'Aeronautical Engineering')
                con.Plan_B_Industry__c = 'Aerospace and Aviation';
            else if (con.Plan_B__c == 'Fashion/Jewellery (design,styling,sales)' || con.Plan_B__c == 'Tailoring')
                con.Plan_B_Industry__c = 'Apparel';
            else if (con.Plan_B__c == 'Automobile Engineering' || con.Plan_B__c == 'Driving')
                con.Plan_B_Industry__c = 'Automobile';
            else if (con.Plan_B__c == 'Accounting' || con.Plan_B__c == 'Banking services (Sales, admin, marketing, customer service)' ||
                con.Plan_B__c == 'Financial services (Insurance, Equity, Stock broking, Investement,micro finance)')
                con.Plan_B_Industry__c = 'Banking and Finance';
            else if (con.Plan_B__c == 'Beauty Services' || con.Plan_B__c == 'Cosmetology' || con.Plan_B__c == 'Hair styling' ||
                con.Plan_B__c == 'Make Up' || con.Plan_B__c == 'Massage Services' || con.Plan_B__c == 'Mehendi Services')
                con.Plan_B_Industry__c = 'Beauty and Wellness';
            else if (con.Plan_B__c == 'Architect' || con.Plan_B__c == 'Building Survey' || con.Plan_B__c == 'Carpentery' ||
                con.Plan_B__c == 'Civil Engineering' || con.Plan_B__c == 'Draftsmanship' || con.Plan_B__c == 'Interior Design' ||
                con.Plan_B__c == 'Plumbing')
                con.Plan_B_Industry__c = 'Construction and Maintenance';
            else if (con.Plan_B__c == 'Fine Art (Painter, Sculptor, Graffitti Artist, Tattoo Artist)' || con.Plan_B__c == 'Graphic Design' ||
                con.Plan_B__c == 'Landscape Design' || con.Plan_B__c == 'Web Designing')
                con.Plan_B_Industry__c = 'Design';
            else if (con.Plan_B__c == 'Curriculum development' || con.Plan_B__c == 'School administration' ||
                con.Plan_B__c == 'Early Childhood/Primary Teaching' || con.Plan_B__c == 'Professor' || con.Plan_B__c == 'School Teaching' ||
                con.Plan_B__c == 'Private Teaching')
                con.Plan_B_Industry__c = 'Education and Training';
            else if (con.Plan_B__c == 'Electrical engineering' || con.Plan_B__c == 'Electrical repairs (includes electronics)' ||
                con.Plan_B__c == 'Mechanical engineering' || con.Plan_B__c == 'Mechanical repairs (Ac/Fridge/industrial/automobiles)')
                con.Plan_B_Industry__c = 'Electronic and Hardware';
            else if (con.Plan_B__c == 'Agriculturist' || con.Plan_B__c == 'Conservationist (Wildlife)' || con.Plan_B__c == 'Environmentalist' ||
                con.Plan_B__c == 'Horticulture' || con.Plan_B__c == 'Renewable energy' || con.Plan_B__c == 'Waste management')
                con.Plan_B_Industry__c = 'Environment and Agriculture';
            else if (con.Plan_B__c == 'Dentistry' || con.Plan_B__c == 'Doctor' || con.Plan_B__c == 'Medical technologies' ||
                con.Plan_B__c == 'Mental healthcare' || con.Plan_B__c == 'Nurse' || con.Plan_B__c == 'Optometry' ||
                con.Plan_B__c == 'Paramedical' || con.Plan_B__c == 'Pharmacy' || con.Plan_B__c == 'Physiotherapy' ||
                con.Plan_B__c == 'Veterinary')
                con.Plan_B_Industry__c = 'Healthcare';
            else if (con.Plan_B__c == 'Chemical engineering' || con.Plan_B__c == 'Company Secretary' || con.Plan_B__c == 'Customer Service' ||
                con.Plan_B__c == 'Data Entry' || con.Plan_B__c == 'Entrepreneurship' || con.Plan_B__c == 'Generic Sales/Business Development' ||
                con.Plan_B__c == 'Human Resources' || con.Plan_B__c == 'International Trades(Import/Export)' ||
                con.Plan_B__c == 'Logistics/Warehousing' || con.Plan_B__c == 'Marketing' || con.Plan_B__c == 'Office Administration' ||
                con.Plan_B__c == 'Data Analyst')
                con.Plan_B_Industry__c = 'Industry Agnostic';
            else if (con.Plan_B__c == 'Artificial Intelligence' || con.Plan_B__c == 'Computer engineering' || con.Plan_B__c == 'Cyber Security' ||
                con.Plan_B__c == 'Ethical Hacking' || con.Plan_B__c == 'Software Development (web/app)')
                con.Plan_B_Industry__c = 'Information Technology';
            else if (con.Plan_B__c == 'Lawyer')
                con.Plan_B_Industry__c = 'Judiciary';
            else if (con.Plan_B__c == 'Archaeologist' || con.Plan_B__c == 'Biotechnology' || con.Plan_B__c == 'Zoology')
                con.Plan_B_Industry__c = 'Life Science';
            else if (con.Plan_B__c == 'Welding')
                con.Plan_B_Industry__c = 'Manufacturing';
            else if (con.Plan_B__c == 'Acting/Modeling' || con.Plan_B__c == 'Advertising' || con.Plan_B__c == 'Animation' ||
                con.Plan_B__c == 'Communications/Digital Marketing' || con.Plan_B__c == 'Dance' || con.Plan_B__c == 'Event management' ||
                con.Plan_B__c == 'Film Making (Direction, Editing, Production and Scripting)' ||
                con.Plan_B__c == 'Journalism (Print, Broadcast, Radio, Online)' || con.Plan_B__c == 'Music' || con.Plan_B__c == 'Photography' ||
                con.Plan_B__c == 'Public Relations' || con.Plan_B__c == 'Singing' || con.Plan_B__c == 'Writing (Novel, Poetry, Film)')
                con.Plan_B_Industry__c = 'Media and Entertainment';
            else if (con.Plan_B__c == 'Civil services (IAS)' || con.Plan_B__c == 'Firefighter' || con.Plan_B__c == 'Government services' ||
                con.Plan_B__c == 'Politics' || con.Plan_B__c == 'Social sector services')
                con.Plan_B_Industry__c = 'Public Administration';
            else if (con.Plan_B__c == 'Airforce' || con.Plan_B__c == 'Armed services' || con.Plan_B__c == 'Naval services' ||
                con.Plan_B__c == 'Police services' || con.Plan_B__c == 'Private Security(Bodyguards,etc)')
                con.Plan_B_Industry__c = 'Public services';
            else if (con.Plan_B__c == 'Retail Sales')
                con.Plan_B_Industry__c = 'Retail';
            else if (con.Plan_B__c == 'Merchant Navy')
                con.Plan_B_Industry__c = 'Shipping';
            else if (con.Plan_B__c == 'Sports coaching' || con.Plan_B__c == 'Sports management' || con.Plan_B__c == 'Sports person' ||
                con.Plan_B__c == 'Nutrition and Diet' || con.Plan_B__c == 'Fitness Training')
                con.Plan_B_Industry__c = 'Sports and Fitness';
            else if (con.Plan_B__c == 'Hotel services (QSR, housekeeping, front office)' || con.Plan_B__c == 'Tour Guide' ||
                con.Plan_B__c == 'Travel Agent' || con.Plan_B__c == 'Chef (kitchen staff)')
                con.Plan_B_Industry__c = 'Tourism and Hospitality';
            else if (con.Plan_B__c == 'Facilities (housekeeping)' || con.Plan_B__c == 'Operations')
                con.Plan_B_Industry__c = 'Facility Management';  
    
            contToBeUpdated.add(con);
        }
    
        if (contToBeUpdated.size() > 0)
            update contToBeUpdated;
     }
     
   
}