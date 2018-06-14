public class Account_TriggerHandler extends TriggerHandler{
    public override void afterInsert() {
        disqualify_leads();
    }
    
    private void disqualify_leads(){
        Set<String> account_names = new Set<String>();
        Map<String, Id> account_name_map = new Map<String, Id>();
        for(Account a : (List<Account>) Trigger.newMap.values()){
            system.debug('account : ' + a);
            account_names.add(a.Name.toUpperCase());
            account_name_map.put(a.Name.toUpperCase(), a.Id);
        }
        
        List<Lead> leads_to_disqualify = [SELECT Id, Name, Company, Status FROM Lead WHERE Company IN :account_name_map.keySet()];
        for(Lead l : leads_to_disqualify){
            l.Status = 'Disqualified';
            l.Disqualify_Reason__c = 'Account Match';
            if(account_name_map.containsKey(l.Company.toUpperCase())) l.Account_matched__c = account_name_map.get(l.Company.toUpperCase());
        }
        update leads_to_disqualify;
    }
}