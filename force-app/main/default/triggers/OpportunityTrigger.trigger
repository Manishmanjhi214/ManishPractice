trigger OpportunityTrigger on Opportunity (after insert ,after update) {
if(Trigger.isAfter){
    if(Trigger.isInsert){
        OpportunityTriggerHandler.createOpportunityLineItem(Trigger.new);
    }
    
}
}