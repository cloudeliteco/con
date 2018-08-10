@isTest
private class Account_TriggerHandler_Test {
    static testmethod void test_simple_lead_conversion(){
        
        Product2 prod1 = new Product2(Name = 'Proof of claim', IsActive = true, ProductCode = 'POC');
        insert prod1;
        Product2 prod2 = new Product2(Name = 'Scheduled Claim', IsActive = true, ProductCode = 'SC');
        insert prod2;
        
        List<Product2> products = [SELECT Id, Name FROM Product2];
        System.assertEquals(2, products.size());
        
        //Id pricebookId = TestDataFactory.getStdPricebookId(); // Test.getStandardPricebookId();
        Id pricebookId = UtilityClass.getStdPricebookId(); // Test.getStandardPricebookId();
        system.debug('standard priccebook id: ' + pricebookId);
        
        PricebookEntry standardPrice1 = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = prod1.Id,
            UnitPrice = 1, 
            IsActive = true);
        insert standardPrice1;
        PricebookEntry standardPrice2 = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = prod2.Id,
            UnitPrice = 1, 
            IsActive = true);
        insert standardPrice2;
        
        List<PriceBookEntry> priceBookList = [SELECT Id, 
                                                Product2.Name 
                                              FROM 
                                                PriceBookEntry
                                              WHERE 
                                                Pricebook2Id = :pricebookId];
        System.assertEquals(2, priceBookList.size());
        
        Account bankruptcy = New Account(Name = 'Test Account');
        insert bankruptcy;
        
        Account debtor = New Account(Name = 'Test Debtor');
        debtor.RecordTypeId = TestDataFactory.Account_Debtor_RecordTypeId;
        insert debtor;
        
        Integer numOfLeads = 3;
        String nameOfCompany = 'Test Co';
        List<Lead> test_leads = TestDataFactory.createLeadsWCompanyName(numOfLeads, nameOfCompany);
        for(Lead l : test_leads){
            l.Type__c = 'Competitor';
            l.Bankruptcy__c = bankruptcy.Id;
            l.Debtor_Name__c = debtor.Id;
        }
        insert test_leads;
        
        List<Lead> convertedLeadList1 = [SELECT Id, Company, Status, Account_matched__c FROM Lead];
        System.assertEquals(numOfLeads, convertedLeadList1.size());
        
        test.StartTest();
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(test_leads[0].Id);
        LeadStatus convertStatus = [Select Id, MasterLabel from LeadStatus where IsConverted=true limit 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
                        test.stopTest();
        
        List<Lead> convertedLeadList = [SELECT Id, Company, Status, Account_matched__c FROM Lead WHERE Status = 'Unqualified'];
        System.assertEquals(numOfLeads - 1, convertedLeadList.size());


        
        List<OpportunityLineItem> olis = [SELECT Id, Product2.Name FROM OpportunityLineItem];
        System.assertEquals(numOfLeads * 2, olis.size());
        

        
    }
    

}