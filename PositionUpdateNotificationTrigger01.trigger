trigger PositionUpdateNotificationTrigger on Position_Update__e (after insert) {
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
    String emailTemplateId = '00XdL000008xjsX';

    // Map position events to their IDs
    Map<Id, Position_Update__e> positionEventMap = new Map<Id, Position_Update__e>();
    for (Position_Update__e event : Trigger.new) {
        positionEventMap.put(event.Position_Id__c, event);
    }

    // Fetch job applications associated with the positions
    List<Job_Application__c> jobApplications = [
        SELECT Candidate__r.Id, Candidate__r.Email__c, Job_Applications__c
        FROM Job_Application__c
        WHERE Job_Applications__c IN :positionEventMap.keySet()
    ];

    System.debug('Job Applications: ' + jobApplications);

    // Create email messages
    for (Job_Application__c jobApp : jobApplications) {
        if (jobApp.Candidate__r != null && jobApp.Candidate__r.Email__c != null) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTemplateId(emailTemplateId);
            email.setTargetObjectId(jobApp.Candidate__r.Id); // Set the Candidate's Id as the target object for the email
            email.setSaveAsActivity(false); // Optional: Do not create a related activity for this email
            emails.add(email);
        } else {
            System.debug('Candidate Email not found for Job Application: ' + jobApp.Id);
        }
    }

    // Send all emails in bulk
    if (!emails.isEmpty()) {
        try {
            Messaging.sendEmail(emails);
            System.debug('Emails sent successfully.');
        } catch (Exception e) {
            System.debug('Email sending failed: ' + e.getMessage());
        }
    }

    System.debug('Total Emails Sent: ' + emails.size());
}
