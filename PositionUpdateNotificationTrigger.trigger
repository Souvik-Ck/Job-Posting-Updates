
trigger PositionUpdateNotificationTrigger on Position_Update__e (after insert) {
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    
    for (Position_Update__e event : Trigger.new) {
        // Fetch applicants linked to the Position
        List<Candiate__c> applicants = [SELECT Email__c FROM Candiate__c WHERE position__c = :event.Position_Id__c];
        
        for (Candiate__c applicant : applicants) {
            if (String.isNotBlank(applicant.Email__c)) {
                // Create email notification
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { applicant.Email__c });
                email.setSubject('Update to Position You Applied For');
                email.setHtmlBody('Dear Applicant,<br><br>The following updates were made to the Position:<br>' +
                    event.Updated_Fields__c +
                    '<br><br>Thank you for your interest.<br>HR Team');
                emails.add(email);
            }
        }
    }

    // Send the emails
    if (!emails.isEmpty()) {
        Messaging.sendEmail(emails);
    }
}
