trigger OpportunityLineItemTrigger on OpportunityLineItem (after insert,after update,after delete) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            OpportunityLineItemTriggerHandler.updateProductListOnOpporutnity(Trigger.new);
        }
        if(Trigger.isUpdate){
            OpportunityLineItemTriggerHandler.updateProductListOnOpporutnity(Trigger.new);
        }
        if(Trigger.isDelete){
            OpportunityLineItemTriggerHandler.updateProductListOnOpporutnity(Trigger.old);
        }
    }
}