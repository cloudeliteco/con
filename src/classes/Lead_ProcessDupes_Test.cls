@isTest
private class Lead_ProcessDupes_Test {
    static testmethod void simple_test() {
        
        Id bank_rec_id = TestDataFactory.Account_Bankruptcy_RecordTypeId;
        Id debt_rec_id = TestDataFactory.Account_Debtor_RecordTypeId;
        
        
        Integer num_bankruptcies = 5;
        Integer num_debtors = 3;
        Integer num_companies = 4;
        Integer num_company_leads = 3;
        String company_name = 'Test Co.';
        String bank_name = 'Bankrupt Co.';
        String debt_name = 'Debtor ';
        
        List<Account> bankrupt_accounts = new List<Account>();
        for(Integer i = 0 ; i < num_bankruptcies; i++){        
            Account new_bankrupt_account = new Account();
            new_bankrupt_account.Name = bank_name + ' ' + i;
            new_bankrupt_account.RecordTypeId = bank_rec_id;
            bankrupt_accounts.add(new_bankrupt_account);
        }
        insert bankrupt_accounts;
        
        List<Account> debtor_accounts = new List<Account>();
        for(Account ba : bankrupt_accounts){
            for(Integer i = 0 ; i < num_debtors; i++){
                Account debtor_account = new Account();
                debtor_account.Name = debt_name + ' ' + i;
                debtor_account.ParentId = ba.Id;
                debtor_account.RecordTypeId = debt_rec_id;
                debtor_accounts.add(debtor_account);
            }
        }
        insert debtor_accounts;
        
        List<Lead> test_leads = new List<Lead>();
        for(Account a : debtor_accounts){
            // each debtor account should have a few companies making a few claims
            for(Integer i = 0; i < num_companies; i++){
                String use_company_name = company_name + ' ' + i;
                for(Integer c = 0 ; c < num_company_leads; c++){
                    
                    Lead new_lead = new Lead();
                    new_lead.Bankruptcy__c = a.ParentId;
                    new_lead.Company = use_company_name;
                    new_lead.Debtor_Name__c = a.Id;
                    new_lead.LastName = 'TestLastName';
                    new_lead.Priority_Allowed_Amount__c = (Math.random() * c) + (Math.random() * c) * 100;
                    
                    test_leads.add(new_lead);
                }
            }
        }
        insert test_leads;
        system.debug('test_leads size:');
        system.debug(test_leads.size());
        
        Test.startTest();
        Lead_ProcessDupes process_leads = new Lead_ProcessDupes();
        Id batchId = Database.executeBatch(process_leads);
        Test.stopTest();
        // after the testing stops, assert records were updated properly
        System.assertEquals(num_bankruptcies * num_debtors * num_companies * num_company_leads , [select count() from Lead where Status != 'New']);
        System.assertEquals(num_bankruptcies * num_debtors * num_companies, [select count() from Lead where Status = 'Qualified']);
    }
}