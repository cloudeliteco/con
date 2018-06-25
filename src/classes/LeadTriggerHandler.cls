public class LeadTriggerHandler extends TriggerHandler{
	public override void beforeInsert() {
        //disqualify_leads();
        //Id batchJobId = Database.executeBatch(new Lead_FindAccounts(), 100);
		Lead_MatchAccounts.process(Trigger.new);
    }

}