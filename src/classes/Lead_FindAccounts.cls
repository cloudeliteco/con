global class Lead_FindAccounts implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name, Company FROM Lead WHERE Processed_for_Account_Dupe__c = false ORDER BY Company';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> scope){

        //List<Lead> leads_to_update = new List<Lead>();
        Map<String, List<Lead>> company_dupes_in_batch = new Map<String, List<Lead>>();
        for(Lead l : scope){
            String use_company_name = l.Company.toUpperCase();
            if(!company_dupes_in_batch.containsKey(use_company_name)) company_dupes_in_batch.put(use_company_name, new List<Lead>());
            company_dupes_in_batch.get(use_company_name).add(l);
        }
        
        
        List<Account> existing_acounts = [SELECT Name, RecordType.Name FROM Account WHERE Name IN :company_dupes_in_batch.keyset()];
        Set<String> existing_acount_names = new Set<String>();
        
        for(Account a : existing_acounts){
            existing_acount_names.add(a.Name.toUpperCase());
            /*
            if(company_dupes_in_batch.containsKey(a.Name.toUpperCase())){
                for(Lead l : company_dupes_in_batch.get(a.Name.toUpperCase())){
                    l.Has_Matching_Account__c = true;
                    leads_to_update.add(l);
                }
            }
			*/
        }
        
        for(Lead l : scope){
            l.Processed_for_Account_Dupe__c = true;
            if(existing_acount_names.contains(l.Company.toUpperCase())){
                l.Has_Matching_Account__c = true;
                l.Status = 'Unqualified';
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
        if(!Test.isRunningTest()) Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       
    }
}