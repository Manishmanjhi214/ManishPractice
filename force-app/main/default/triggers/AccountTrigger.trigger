trigger AccountTrigger on Account (before insert,after insert,before update ,after update, before delete) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            AccountTriggerHandler.copyBillingAddress(Trigger.new);
        }
        if(trigger.isUpdate){
            AccountTriggerHandler.validateAccountNameUpdate(Trigger.new,Trigger.oldMap);
        }
        if(trigger.isDelete){
            AccountTriggerHandler.validateDeletion(Trigger.old);
        }
    }
    if(trigger.isAfter){
        if(Trigger.isInsert){
            AccountTriggerHandler.createAndAssociateContact(Trigger.new);
        }
        if(trigger.isUpdate){
            AccountTriggerHandler.updateContactMailAddress(Trigger.new,Trigger.oldMap);
        }
    }

}