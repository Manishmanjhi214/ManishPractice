trigger OpportunityTrigger on Opportunity (after insert ,after update) {
if(Trigger.isAfter){
    if(Trigger.isInsert){
        OpportunityTriggerHandler.createOpportunityLineItem(Trigger.new);
    }
    if(Trigger.isUpdate){
        //Method working but not of single org with all triggers due to conflict/dependency issue
        /*OpportunityTriggerHandler.updateAssociatedAccountClientContact(Trigger.new);
        OpportunityTriggerHandler.updateAccountMultiSelectValue(Trigger.new);*/
    }
    
}
}