trigger ContactTrigger on Contact (after insert,before insert, before update,after update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            ContactTriggerHandler.preventInsertionOfDuplicateRecords(Trigger.new);
        }
        if (trigger.isUpdate) {
            ContactTriggerHandler.preventUpdationOfDuplicateRecords(Trigger.new,Trigger.oldMap);
        }
    }
    if(trigger.isAfter){
        if(trigger.isInsert){
            ContactTriggerHandler.sendEmailOnContactInsertion(Trigger.new);
        }
         if(trigger.isUpdate){
            ContactTriggerHandler.updateOpportunityAmountOnContactUpdate(Trigger.new,Trigger.oldMap);
        }
    }
    
    }