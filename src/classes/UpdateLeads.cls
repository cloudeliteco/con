global class UpdateLeads implements Database.Batchable<sObject>{

    global final String Query;
    global UpdateLeads(String q){
        Query=q;    
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC,List<lead> scope){
        for(lead c : scope ) {
            
                c.lastname = c.lastname;
        }
        update scope;
    }

    global void finish(Database.BatchableContext BC){}

    //UpdateLeads.mask();
    global static void mask() {
        String query = 'select id, lastname, lastname from lead where lastname = null';
        UpdateLeads updateBatch = new UpdateLeads(query);
        Id BatchProcessId = Database.ExecuteBatch(updateBatch);
    }

}