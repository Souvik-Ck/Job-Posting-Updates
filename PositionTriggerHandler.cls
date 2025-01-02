/**
 * @description       : 
 * @author            : Souvik Sen
 * @group             : 
 * @last modified on  : 01-02-2025
 * @last modified by  : Souvik Sen
**/
public class PositionTriggerHandler {
    /**
     * @description Handles after-update logic for the Position__c object.
     * @param newPositions List of new Position__c records.
     * @param oldPositions Map of old Position__c records (Id to record).
     */
    public static void handleAfterUpdate(List<Position__c> newPositions, Map<Id, Position__c> oldPositions) {
        List<Position_Update__e> platformEvents = new List<Position_Update__e>();
        
        for (Position__c updatedPosition : newPositions) {
            Position__c oldPosition = oldPositions.get(updatedPosition.Id);
            Map<String, String> changedFields = new Map<String, String>();

            // Detect changes in specific fields
            if (updatedPosition.Job_Description__c != oldPosition.Job_Description__c) {
                changedFields.put(AssignmentsConstants.JOB_DESC, oldPosition.Job_Description__c + ' -> ' + updatedPosition.Job_Description__c);
            }
            if (updatedPosition.Skills_Required__c != oldPosition.Skills_Required__c) {
                changedFields.put(AssignmentsConstants.REQUIRED_SKILLS, oldPosition.Skills_Required__c + ' -> ' + updatedPosition.Skills_Required__c);
            }
            if (updatedPosition.Hiring_Manager__c != oldPosition.Hiring_Manager__c) {
                changedFields.put(AssignmentsConstants.HIRING_MANAGER, oldPosition.Hiring_Manager__c + ' -> ' + updatedPosition.Hiring_Manager__c);
            }

            // If there are changes, publish a Platform Event
            if (!changedFields.isEmpty()) {
                String updatedFieldsString = String.join(new List<String>(changedFields.keySet()), ', ');

                platformEvents.add(new Position_Update__e(
                    Position_Id__c = updatedPosition.Id,
                    Updated_Fields__c = updatedFieldsString,
                    Updated_By__c = UserInfo.getUserId(),
                    Updated_Date_Time__c = System.now()
                ));
            }
        }

        // Publish the platform events
        if (!platformEvents.isEmpty()) {
            EventBus.publish(platformEvents);
        }
    }
}
