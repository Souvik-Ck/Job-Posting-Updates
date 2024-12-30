/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger PositionUpdateTrigger on position__c (after update) {
    PositionUpdateTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
}
