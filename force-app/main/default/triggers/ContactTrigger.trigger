trigger ContactTrigger on Contact (before insert) {
    switch on trigger.operationType{
        when BEFORE_INSERT{
            ContactTriggerHandler.Before_Insert(Trigger.new);
        }
    }
}