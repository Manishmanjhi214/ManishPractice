trigger AccountTrigger on Account (before insert,after insert,before update ,after update, before delete) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            AccountTriggerHandler.copyBillingAddress(Trigger.new);
        }
        if(trigger.isUpdate){
            AccountTriggerHandler.validateAccountNameUpdate(Trigger.new,Trigger.oldMap);
            AccountTriggerHandler.updateMonthOldOppoertunities(Trigger.new);
        }
        if(trigger.isDelete){
            AccountTriggerHandler.validateDeletion(Trigger.old);
        }
    }
    if(trigger.isAfter){
        if(Trigger.isInsert){
            AccountTriggerHandler.createAndAssociateContact(Trigger.new);
            AccountTriggerHandler.createAccountAndContactClient(Trigger.new);
            AccountTriggerHandler.sendEmailToAccountOnInsertion(Trigger.new);
        }
        if(trigger.isUpdate){
            AccountTriggerHandler.updateContactMailAddress(Trigger.new,Trigger.oldMap);
        }
    }

}