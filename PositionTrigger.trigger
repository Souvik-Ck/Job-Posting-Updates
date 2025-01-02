/**
 * @description       : Trigger to publish platform events when Position__c is updated.
 * @created by        : Souvik Sen
 * @last modified on  : 01-02-2025
**/
trigger PositionTrigger on Position__c (after update) {
    PositionTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
    
}

