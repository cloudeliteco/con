global class MarkLeads implements Database.Batchable<sObject>{

    global final String Query;
    global MarkLeads(String q){
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

    //MarkLeads.mask();
    global static void mask() {
        String query = 'select id, lastname, status from lead where lastname = null';
        MarkLeads updateBatch = new MarkLeads(query);
        Id BatchProcessId = Database.ExecuteBatch(updateBatch);
    }

}