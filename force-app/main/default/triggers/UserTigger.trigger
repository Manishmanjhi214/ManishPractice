trigger UserTigger on User (after update) {
if(trigger.isAfter){
    if(trigger.isUpdate){
        UserTriggerHandler.sendEmailToManagerOnUserUpdate(Trigger.new);
    }
}
}