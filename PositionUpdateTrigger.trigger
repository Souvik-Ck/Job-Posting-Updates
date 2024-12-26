
trigger PositionUpdateTrigger on position__c (after update) {
    List<Position_Update__e> platformEvents = new List<Position_Update__e>();
    
    for (position__c updatedPosition : Trigger.new) {
        position__c oldPosition = Trigger.oldMap.get(updatedPosition.Id);
        Map<String, String> changedFields = new Map<String, String>();
        
        // Detect changes in specific fields
        if (updatedPosition.Job_Description__c != oldPosition.Job_Description__c) {
            changedFields.put('Job Description', oldPosition.Job_Description__c + ' -> ' + updatedPosition.Job_Description__c);
        }
        if (updatedPosition.Skills_Required__c != oldPosition.Skills_Required__c) {
            changedFields.put('Required Skills', oldPosition.Skills_Required__c + ' -> ' + updatedPosition.Skills_Required__c);
        }
        if (updatedPosition.Hiring_Manager__c != oldPosition.Hiring_Manager__c) {
            changedFields.put('Hiring Manager', oldPosition.Hiring_Manager__c + ' -> ' + updatedPosition.Hiring_Manager__c);
        }
        
        // If there are changes, publish a Platform Event
        if (!changedFields.isEmpty()) {
            String updatedFieldsString = String.join(new List<String>(changedFields.keySet()), ', ');

            platformEvents.add(new Position_Update__e(
                Position_Id__c = updatedPosition.Id,
                Updated_Fields__c = updatedFieldsString,
                Changed_By__c = UserInfo.getUserName(),
                Change_Timestamp__c = System.now()
            ));
        }
    }

    // Publish the platform events
    if (!platformEvents.isEmpty()) {
        EventBus.publish(platformEvents);
    }
}
