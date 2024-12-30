/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger PositionUpdateNotificationTrigger on Position_Update__e (after insert) {
    PositionUpdateNotificationHandler.handleAfterInsert(Trigger.new);
}

