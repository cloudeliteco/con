global with sharing class LeadProcessLaunch {
	@AuraEnabled
    public static Boolean launchLeadProcess(){
        try{
            Id batchJobId = Database.executeBatch(new Lead_FindAccounts(), 100);
        } catch(Exception e){
            return false;
        }
        return true;
    }
}