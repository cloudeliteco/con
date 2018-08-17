trigger CreateAssetonClosedWon on Opportunity (after insert, after update) {
     for(Opportunity o: trigger.new){ 
      if(o.Iswon == true && o.HasOpportunityLineItem == true){
         String opptyId = o.Id;
         OpportunityLineItem[] OLI = [Select UnitPrice, Debtor__c, Claim_ID__c, Quantity, TotalPrice, PricebookEntry.Product2Id, PricebookEntry.Product2.Name, Description, Converted_to_Asset__c  
                                      From OpportunityLineItem 
                                      where OpportunityId = :opptyId  and Converted_to_Asset__c = false];
         Asset[] ast = new Asset[]{};
         Asset a = new Asset();
         for(OpportunityLineItem ol: OLI){
            a = new Asset();
        a.AccountId = o.AccountId;
            a.Product2Id = ol.PricebookEntry.Product2Id;
            a.Purchase_Amount__c = ol.TotalPrice;
            a.Quantity = ol.Quantity;
            a.Debtor__c = ol.Debtor__c;
            a.Purchased_price__c  =  ol.UnitPrice;
            a.SerialNumber = ol.Claim_ID__c;
            a.PurchaseDate = o.CloseDate;
            a.Status = 'Purchased';
            a.Description = ol.Description;
            a.Name = ol.PricebookEntry.Product2.Name;
            a.Opportunity__c = opptyId;
            ast.add(a);
            ol.Converted_to_Asset__c = true;
       }
      update OLI; 
      insert ast;
     }
    }
}