**
* @description       :
* @author            : Souvik Sen
* @group             :
* @last modified on  : 12-31-2024
* @last modified by  : Souvik Sen
**/
trigger PositionUpdateEventTrigger on Position_Update__e (after insert) {
    List<Position_Update__e> logs = new List<Position_Update__e>();
    
    try {
        Set<Id> positionIds = new Set<Id>();
        for (Position_Update__e event : Trigger.new) {
            positionIds.add(event.Position_Id__c);
            
            // Create log entry
            logs.add(new Position_Update_Log__c(
                position__c = event.Position_Id__c,
                Updated_Fields__c = event.Updated_Fields__c,
                Created_By__c = event.Updated_By__c,
                Updated_Date_Time__c = event.Updated_Date_Time__c
            ));
        }
        
        // Insert logs
        if (!logs.isEmpty()) {
            Database.insert(logs, AccessLevel.SYSTEM_MODE);
        }
        
    } catch (Exception e) {
        System.debug('Error in final processing: ' + e.getMessage());
        System.debug('Stack trace: ' + e.getStackTraceString());
    }
}
