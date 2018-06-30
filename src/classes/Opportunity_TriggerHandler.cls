public class Opportunity_TriggerHandler extends TriggerHandler{
    public override void afterInsert() {
        disqualify_leads();
    }
    
    private void disqualify_leads(){
        
		Set<Id> account_ids = new Set<Id>();
        for(Opportunity o : (List<Opportunity>) Trigger.newMap.values()){
            if(!account_ids.contains(o.AccountId)) account_ids.add(o.AccountId);
        }
        
        Account_DisqualifyLeads.process(account_ids);

    }
}