global class DeduplicateLeads implements Schedulable {
    global void execute(SchedulableContext ctx) {
          set<string> Lastname = new set<string>();
		  list<Lead> Leads = [Select Id, Lastname, Allowed_Total__c, status from Lead where isconverted = false AND Lastname != null order by Allowed_Total__c desc limit 10000];
		  
		  list<Lead> leadsToUpdate = new list<Lead>();
		  for(Lead l : leads){
			if(!Lastname.add(l.Lastname)){
				l.status = 'Unqualified';
				leadsToUpdate.add(l);
			}
		  }
		  
		  if(leadsToUpdate.size() > 0)
		  update leadsToUpdate;
    }
}