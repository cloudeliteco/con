@isTest
private class Lead_MatchAccounts_Test {
	static testmethod void test_simple_lead_run(){
        
        String nameOfCompany = 'Test Co';
        String bankruptCompany = 'Circuit City';
        String debtorCompany = 'Circuit City Properties';
        
        List<Account> accounts = TestDataFactory.createBankruptcyClaim(nameOfCompany, bankruptCompany, debtorCompany);
        
        Lead test_lead = new Lead();
        test_lead.Company = nameOfCompany;
        test_lead.Bankruptcy__c = accounts[1].Id;
        test_lead.Debtor_Name__c = accounts[2].Id;
        test_lead.LastName = 'Testing';
        
        test.startTest();
        insert test_lead;
        test.stopTest();
        system.assertEquals(3, [SELECT Id FROM Account].size());
        system.assertEquals(1, [SELECT Id FROM Lead WHERE Status = 'Unqualified'].size());
    }

	static testmethod void test_simple_nomatch(){
        
        String nameOfCompany = 'Test Co';
        String bankruptCompany = 'Circuit City';
        String debtorCompany = 'Circuit City Properties';
        
        List<Account> accounts = TestDataFactory.createBankruptcyClaim(nameOfCompany, bankruptCompany, debtorCompany);
		
		// now insert a second debtor company for circuit city, but without an opportunity / claim
		Account otherDebtor = new Account();
        otherDebtor.Name = 'Other Circuit City Debtor';
        otherDebtor.ParentId = accounts[1].Id; // = circuit city
        otherDebtor.RecordTypeId = TestDataFactory.Account_Debtor_RecordTypeId;
        insert otherDebtor;
        
        Lead test_lead = new Lead();
        test_lead.Company = nameOfCompany; // same lead company name
        test_lead.Bankruptcy__c = accounts[1].Id; // same bankruptcy name
        test_lead.Debtor_Name__c = otherDebtor.Id; // new debtor account
        test_lead.LastName = 'Testing';
        
        test.startTest();
        insert test_lead;
        test.stopTest();
        system.assertEquals(4, [SELECT Id FROM Account].size());
        system.assertEquals(0, [SELECT Id FROM Lead WHERE Status = 'Unqualified'].size());
    }    
	static testmethod void test_simple_competitor_types(){
        String nameOfCompany = 'Test Co';
        Integer numOfLeads = 3;
    	Account a = TestDataFactory.createAccountWCompanyName(nameOfCompany);
        a.Type = 'Competitor';
        update a;
        
        List<Lead> test_leads = TestDataFactory.createLeadsWCompanyName(numOfLeads, nameOfCompany);
        
        test.startTest();
        insert test_leads;
        test.stopTest();
        system.assertEquals(1, [SELECT Id FROM Account].size());
        system.assertEquals(numOfLeads, [SELECT Id FROM Lead WHERE Status = 'Unqualified'].size());
        
	}
}