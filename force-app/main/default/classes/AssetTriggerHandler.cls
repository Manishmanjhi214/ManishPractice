public with sharing class AssetTriggerHandler {
    public static void insertAssetAlongWithOppAndOppLineItem(List<Asset> newAssets) {
            Set<Id> AccIds = new Set<Id>();
        for(Asset ast: newAssets){
            if(ast.AccountId != null){
                AccIds.add(ast.AccountId);
            }
        }
        List<Asset> listOfAssets = [Select Id, Product2Id,AccountId,Name from Asset where AccountId in :AccIds];
        List<Opportunity> opps = new List<Opportunity>();
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        for(Asset ast:listOfAssets){
            Opportunity opp = new Opportunity();
            opp.Name = ast.Name + 'Opportunity';
            opp.AccountId= ast.AccountId;
            opp.CloseDate = Date.today();
            opp.StageName = 'Closed Won';
            opps.add(opp);
        }
        insert opps;
        
        for(Asset newAsset:listOfAssets){
            for(Opportunity opp: opps){
            OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.OpportunityId = opp.Id;
            oppLineItem.Product2Id = newAsset.Product2Id;
            oppLineItem.Quantity = 1;
            oppLineItem.UnitPrice = newAsset.Price;
            oppLineItem.TotalPrice =newAsset.Price;
            oppLineItem.PricebookEntryId= '01u5j000004AjsjAAC';
            oppLineItems.add(oppLineItem);
            }
        }
        insert oppLineItems;
    }
}
