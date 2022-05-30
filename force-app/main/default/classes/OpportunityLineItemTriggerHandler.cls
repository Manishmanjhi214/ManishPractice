public with sharing class OpportunityLineItemTriggerHandler {
    public static void updateProductListOnOpporutnity(List<OpportunityLineItem> newOppLineItems) {
        Set<Id> oppWithLineItems =new Set<Id>();
        for(OpportunityLineItem oplt: newOppLineItems){
            oppWithLineItems.add(oplt.OpportunityId);
            }
        List<Opportunity> OppToUpdate = new List<Opportunity> ();
        List<Opportunity> oppWithProducts = [SELECT Id,List_of_Products__c,Name,(SELECT Name FROM OpportunityLineItems) FROM Opportunity 
                   WHERE Id IN: oppWithLineItems];
        
       for(Opportunity opp: oppWithProducts){
           Opportunity oppObj = new Opportunity();
           oppObj.Id = opp.id;
           String[] proName = new String[0];
           for(OpportunityLineItem item: opp.OpportunityLineItems){
               proName.add(item.Name);
           }
           oppObj.List_of_Products__c= String.join(proName, ';');
            OppToUpdate.add(oppObj);
        }
      if(OppToUpdate.size()>0){
          update OppToUpdate;
        }
      }
}