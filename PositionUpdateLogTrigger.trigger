trigger PositionUpdateLogTrigger on Position_Update__e (after insert) {
    List<Position_Update_Log__c> logs = new List<Position_Update_Log__c>();
    
    for (Position_Update__e event : Trigger.new) {
        logs.add(new Position_Update_Log__c(
            position__c = event.Position_Id__c,
            Updated_Fields__c = event.Updated_Fields__c,
            Changed_By__c = event.Changed_By__c,
            Change_Timestamp__c = event.Change_Timestamp__c
        ));
    }

    // Insert log records
    if (!logs.isEmpty()) {
        insert logs;
    }
}
