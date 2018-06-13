public class LeadTriggerHandler extends TriggerHandler{
	public override void afterInsert() {
        //disqualify_leads();
        Id batchJobId = Database.executeBatch(new Lead_FindAccounts(), 100);

    }

}