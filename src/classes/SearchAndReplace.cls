global class SearchAndReplace implements Database.Batchable<sObject>{
    
    global final String Query;
    global final String Entity;
    global final String Field;
    global final String Value;
    
    global SearchAndReplace(String q, String e, String f, String v){
        
        Query=q; Entity=e; Field=f;Value=v;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(sobject s : scope){
            if(Value == 'True' || Value == 'False'){
                s.put(Field,Boolean.valueOf(Value));
            }else{
                s.put(Field,Value);
            }
             
        }
        update scope;
    }
    
    global void finish(Database.BatchableContext BC){
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          FROM AsyncApexJob WHERE Id =
                          :BC.getJobId()];
        // Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Lead Processing by Total ' + a.Status);
        mail.setPlainTextBody
            ('The batch Apex job processed ' + a.TotalJobItems +
             ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}