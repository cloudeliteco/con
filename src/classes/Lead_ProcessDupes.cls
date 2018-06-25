global class Lead_ProcessDupes implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = 'SELECT Id, Name, Company, Allowed_Total__c FROM Lead WHERE Status != \'Unqualified\' ORDER BY Company, Allowed_Total__c DESC';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> scope){
        // get unique company names an add to list of leads
        Map<String, List<Lead>> company_dupes_in_batch = new Map<String, List<Lead>>();
        for(Lead l : scope){
            String use_company_name = l.Company.toUpperCase();
            if(!company_dupes_in_batch.containsKey(use_company_name)) company_dupes_in_batch.put(use_company_name, new List<Lead>());
            company_dupes_in_batch.get(use_company_name).add(l);
        }
        
        // make suer we got all the leads we want to work with
        Set<String> companys_not_to_update = new Set<String>();
        AggregateResult[] company_dupes_in_total = [SELECT Company, COUNT(ID) Total FROM Lead WHERE Company IN :company_dupes_in_batch.keyset() AND Status != 'Unqualified' GROUP BY Company];
        for (AggregateResult ar : company_dupes_in_total)  {
            String company = (String) ar.get('Company');
            String use_company_name = company.toUpperCase();
            //System.debug('Company ' + ar.get('Company') + ' has ' + ar.get('Total') + ' total and ' + company_dupes_in_batch.get(company) + ' in batch');
            if(ar.get('Total') != company_dupes_in_batch.get(use_company_name).size()){
                system.debug('*** BATCH DOES NOT HAVE ALL COMPANY LEAD RECORDS ***');
                //System.debug('Company ' + ar.get('Company') + ' has ' + ar.get('Total') + ' total and ' + company_dupes_in_batch.get(use_company_name).size() + ' in batch');
                companys_not_to_update.add(use_company_name);
                //break;
            }
        }
        List<Lead> leads_to_update = new List<Lead>();
        for(String company : company_dupes_in_batch.keyset()){
            if(!companys_not_to_update.contains(company)){
                Lead top_lead = null;
                for(Lead cur_lead : company_dupes_in_batch.get(company)){
                    if(top_lead == null || cur_lead.Allowed_Total__c > top_lead.Allowed_Total__c) top_lead = cur_lead;
                }
                
                for(Lead cur_lead : company_dupes_in_batch.get(company)){
                    //if(cur_lead.Id != top_lead.Id) {
                    //    cur_lead.Status = 'Unqualified';
                    //}
                    cur_lead.Status = (cur_lead.Id == top_lead.Id) ? 'Qualified' : 'Unqualified';
                    cur_lead.Processed_for_Total__c = true;
                    leads_to_update.add(cur_lead);
                }
            }
        }
        if(leads_to_update.size() > 0 ) update leads_to_update;
    }
    
	global void finish(Database.BatchableContext BC){
    }
}