public with sharing class MyLeadController {
    @AuraEnabled
    public static List<Lead> findLeads (Id recordId) {
        Lead clead = [SELECT Bankruptcy__c,Company FROM Lead WHERE Id=:recordId];
        String leadBankruptcy = clead.Bankruptcy__c;
 		String Company = clead.Company;
        List<Lead> similarLeads = getSimilarLeads(recordId, Company, leadBankruptcy);
        return similarLeads;
    }
    private static List<Lead> getSimilarLeads (Id recordId, String Company, String leadBankruptcy) {
    
    return [
            SELECT Id, status, Scheduled_Total__c, LeadSource, Claimed_Total__c , External_Claim_Number__c, company, Bankruptcy__c, Debtor_Name__c 
            FROM Lead WHERE Id != :recordId AND Company =:Company AND Bankruptcy__c =:leadBankruptcy
        ];
    }
}