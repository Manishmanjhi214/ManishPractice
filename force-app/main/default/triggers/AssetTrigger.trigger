trigger AssetTrigger on Asset (after insert) {

    if(trigger.isAfter){
        if(trigger.isInsert){
            AssetTriggerHandler.insertAssetAlongWithOppAndOppLineItem(Trigger.new);
        }
    }
}