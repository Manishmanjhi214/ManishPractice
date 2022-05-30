public with sharing class OpportunityTriggerHandler {
   public static void createOpportunityLineItem(List<Opportunity> newOpportunities) {
       List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
       List<PriceBookEntry> priceBookList = [SELECT Id, Product2Id, Product2.Id, Product2.Name FROM PriceBookEntry 
                                                WHERE Product2Id='01t5j000003SRSaAAO'  
                                                AND PriceBook2.isStandard=true LIMIT 1];
       for(Opportunity opp: newOpportunities){
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId=opp.Id;
        oli.Quantity = 1;
        Oli.TotalPrice = 100;
        oli.PricebookEntryId=priceBookList[0].Id ;
        oliList.add(oli);
       }
       insert oliList;
   }

   
}