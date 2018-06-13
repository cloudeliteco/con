public class Account_TriggerHandler extends TriggerHandler{
	public override void afterInsert() {
        disqualify_leads();
    }
    
    private void disqualify_leads(){
        Set<String> account_names = new Set<String>();
        for(Account a : (List<Account>) Trigger.newMap.values()){
            system.debug('account : ' + a);
            account_names.add(a.Name);
        }
        
        List<Lead> leads_to_disqualify = [SELECT Id, Name, Status FROM Lead WHERE Company IN :account_names];
        for(Lead l : leads_to_disqualify){
            l.Status = 'Disqualified';
        }
        update leads_to_disqualify;
    }
}