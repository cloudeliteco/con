public class Lead_MatchAccounts {
    public static void process(List<Lead> new_leads){
        Map<String, List<Lead>> company_dupes_in_batch = new Map<String, List<Lead>>();
        for(Lead l : new_leads){
            String use_company_name = l.Company.toUpperCase();
            if(!company_dupes_in_batch.containsKey(use_company_name)) company_dupes_in_batch.put(use_company_name, new List<Lead>());
            company_dupes_in_batch.get(use_company_name).add(l);
        }
        
        List<Account> existing_acounts = [SELECT Name, RecordType.Name, Type, (SELECT Id, Name, Bankrupcy__c FROM Opportunities) FROM Account WHERE Name IN :company_dupes_in_batch.keyset()];
        Set<String> existing_acount_names = new Set<String>();
        Map<String, Account> existing_acount_names_map = new Map<String, Account>();
        for(Account a : existing_acounts){
            existing_acount_names.add(a.Name.toUpperCase());
            existing_acount_names_map.put(a.Name.toUpperCase(), a);
        }
        
        Set<String> disqualified_account_types = new Set<String>{'Bank', 'Competitor', 'Govt Agency'};
        for(Lead l : new_leads){
            if(existing_acount_names_map.containsKey(l.Company.toUpperCase())){
                Account a = existing_acount_names_map.get(l.Company.toUpperCase());
                Boolean invalid_type = disqualified_account_types.contains(a.Type); // will match the type
                Boolean has_opportunity_match = false;
                for(Opportunity o : a.Opportunities){
                    if(o.Bankrupcy__c == l.Bankruptcy__c ) has_opportunity_match = true;
                }
                if(has_opportunity_match || invalid_type){
                    l.Has_Matching_Account__c = true;
                    l.Status = 'Unqualified';
                    l.Disqualify_Reason__c = (invalid_type) ? 'Account' : 'Client';
                    l.Account_matched__c = a.Id;
                }
            }
        }
    }
}