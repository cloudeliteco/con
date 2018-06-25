public class Account_TriggerHandler extends TriggerHandler{
    public override void afterInsert() {
        disqualify_leads();
    }
    
    private void disqualify_leads(){
        
        Map<String, Id> account_name_map = new Map<String, Id>();
        for(Account a : (List<Account>) Trigger.newMap.values()){
            system.debug('account : ' + a);
            account_name_map.put(a.Name.toUpperCase(), a.Id);
        }
        
        List<Account> existing_acounts = [SELECT Name, RecordType.Name, LeadType__c , Type, (SELECT Id, Name, Bankrupcy__c, Debtor__c FROM Opportunities) FROM Account WHERE Name IN :account_name_map.keySet()];
        Map<String, Account> existing_account_map = new Map<String, Account>(); //[SELECT Id, Name, RecordType.Name, Type, (SELECT Id, Name, Bankrupcy__c, Debtor__c FROM Opportunities) FROM Account WHERE Name IN :account_name_map.values()];
        for(Account a : existing_acounts){
            existing_account_map.put(a.Name.toUpperCase(), a);
        }
        
        Set<String> disqualified_account_types = new Set<String>{'Bank', 'Competitor', 'Govt Agency'};
            
        List<Lead> leads_to_disqualify = [SELECT Id, Name, Company, Status FROM Lead WHERE Company IN :account_name_map.keySet()];
        for(Lead l : leads_to_disqualify){
            system.debug('lead : ' + l);
            Account matching_account;
            if(existing_account_map.containsKey(l.Company.toUpperCase())){
            	matching_account = existing_account_map.get(l.Company.toUpperCase());    
            }
            
            if(matching_account != null){
                System.debug('matching_account.Type: ' + matching_account.Type);
                Boolean is_unqualified_account = (disqualified_account_types.contains(matching_account.Type) || disqualified_account_types.contains(matching_account.LeadType__c)) ;
                Boolean has_opportunity_match = false;
                
                for(Opportunity o : matching_account.Opportunities){
                    if(o.Bankrupcy__c == l.Bankruptcy__c  && o.Debtor__c == l.Debtor_Name__c ) has_opportunity_match = true;
                }
                
                if(has_opportunity_match || is_unqualified_account){
                    l.Status = 'Unqualified';
                    l.Disqualify_Reason__c = 'Account Match';
                    l.Account_matched__c = matching_account.Id;
                }
            }
        }
        update leads_to_disqualify;
    }
}