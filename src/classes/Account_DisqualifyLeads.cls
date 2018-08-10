public without sharing class Account_DisqualifyLeads {
    public static void process(Set<Id> accountIds){
        
        List<Account> existing_acounts = [SELECT Name, RecordType.Name, LeadType__c , Type, (SELECT Id, Name, Bankrupcy__c, Debtor__c FROM Opportunities) FROM Account WHERE Id IN :accountIds];
        Map<String, Account> existing_account_map = new Map<String, Account>(); //[SELECT Id, Name, RecordType.Name, Type, (SELECT Id, Name, Bankrupcy__c, Debtor__c FROM Opportunities) FROM Account WHERE Name IN :account_name_map.values()];
        for(Account a : existing_acounts){
            existing_account_map.put(a.Name.toUpperCase(), a);
        }
        
        Set<String> disqualified_account_types = new Set<String>{'Bank', 'Competitor', 'Govt Agency','Debtor'};
            Map<Id, List<Lead>> lead_opportunity_match = new Map<Id, List<Lead>>();
        List<Lead> leads_to_disqualify = [SELECT Id, Name, 
                                          Bankruptcy__c, 
                                          Claimed_Total__c,
                                          LeadSource,
                                          Company,
                                          Debtor_Name__c,
                                          External_Claim_Number__c,
                                          Scheduled_Total__c,
                                          Status 
                                          FROM 
                                          Lead 
                                          WHERE 
                                          Company IN :existing_account_map.keySet()];
        system.debug('leads_to_disqualify.size(): ' + leads_to_disqualify.size());
        system.debug('leads_to_disqualify: ' + leads_to_disqualify);
        for(Lead l : leads_to_disqualify){
            system.debug('lead : ' + l);
            Account matching_account;
            if(existing_account_map.containsKey(l.Company.toUpperCase())){
                matching_account = existing_account_map.get(l.Company.toUpperCase());    
            }
            
            
            if(matching_account != null){
                //System.debug('matching_account.Type: ' + matching_account.Type);
                Boolean is_unqualified_account = (disqualified_account_types.contains(matching_account.Type) || disqualified_account_types.contains(matching_account.LeadType__c)) ;
                Boolean has_opportunity_match = false;
                
                system.debug('check opportunities');
                for(Opportunity o : matching_account.Opportunities){
                    //system.debug('o, looking for match' + o);
                    //system.debug('lead again: ' + l);
                    if(o.Bankrupcy__c == l.Bankruptcy__c ) {
                        system.debug('lead account matched: ' + l);
                        has_opportunity_match = true;
                        if(!lead_opportunity_match.containsKey(o.Id))lead_opportunity_match.put(o.Id, new List<Lead>());
                        lead_opportunity_match.get(o.Id).add(l);
                    }
                }
                
                if(has_opportunity_match || is_unqualified_account){
                    
                    l.Status = 'Unqualified';
                    l.Disqualify_Reason__c = (is_unqualified_account) ? 'Account Match':'Client';
                    l.Account_matched__c = matching_account.Id;
                }
            }
        }
        
        //system.debug('lead_opportunity_match: ' + lead_opportunity_match);
        /*
        for(Id oid : lead_opportunity_match.keyset()){
            system.debug('opportunity: ' + oid);
            for(Lead l : lead_opportunity_match.get(oid)){
                //system.debug('opportunity: ' + oid + ' has lead ' + l);
            }
        }
		*/
        update leads_to_disqualify;
        generate_opportunity_line_items(lead_opportunity_match);
    }
    
    private static void generate_opportunity_line_items(Map<Id, List<Lead>> lead_opportunites_map){
        Map<String, Id> product_names = new Map<String, Id>();
        product_names.put('Proof of claim', null);
        product_names.put('Scheduled Claim', null);
        
        Set<Id> product_ids = new Set<Id>();
        for(Product2 prod : [SELECT Id, Name FROM Product2 WHERE Name IN :product_names.keySet()]){
            product_ids.add(prod.Id);
        }
        
        Id stdPriceBook = UtilityClass.getStdPricebookId();
        
        List<PriceBookEntry> priceBookList = [SELECT Id, 
                                                Product2.Name 
                                              FROM 
                                                PriceBookEntry 
                                              WHERE 
                                                Product2Id IN :product_ids AND 
                                                PriceBook2Id = :stdPriceBook];
        /*
        for(PriceBookEntry pbe : priceBookList){
            product_names.put(pbe.Product2.Name, pbe.Id);
        }
        */
        system.debug(product_names);
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        for(Id oid : lead_opportunites_map.keyset()){
            for(Lead l : lead_opportunites_map.get(oid)){
                //system.debug('adding products to opportunity');
                //system.debug(oid + ' for lead ' + l);
                //for(String product_name : product_names.keySet()){
                for(PriceBookEntry pbe : priceBookList){
                    Double use_quantity = (pbe.Product2.Name == 'Proof of claim') ? l.Claimed_Total__c : l.Scheduled_Total__c ;
                    system.debug('use_quantity' + use_quantity);
                    OpportunityLineItem new_oli = new OpportunityLineItem();
                    new_oli.Debtor__c = l.Debtor_Name__c;
                    new_oli.Claim_ID__c = l.External_Claim_Number__c;
                    new_oli.Claim_Source__c = l.LeadSource;
                    new_oli.OpportunityId = oid;
                    //new_oli.Product2Id = priceBookList[0].Id;
                    new_oli.Product2Id = pbe.id; //product_names.get(product_name);
                    new_oli.Quantity = (use_quantity > 0.0 ) ? use_quantity : 1;
                    //new_oli.Total_Claimed_Amount__c  = l.Claimed_Total__c ;
                    //new_oli.TotalPrice =  (product_name == 'Proof of claim') ? l.Claimed_Total__c : l.Scheduled_Total__c ;
                    new_oli.TotalPrice =  (pbe.Product2.Name == 'Proof of claim') ? l.Claimed_Total__c : l.Scheduled_Total__c ;
                    //new_oli.TotalPrice = (use_quantity > 0.0 ) ? use_quantity : 1;
                    olis.add(new_oli);
                }
            }
        }
        
        if(olis.size() > 0 ) insert olis;
    }
}