
trigger PositionUpdateNotificationTrigger on Position_Update__e (after insert) {
    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    // Loop through each Position Update Event
    for (Position_Update__e event : Trigger.new) {
        // Query the Job Application records associated with the Position being updated
        List<Job_Application__c> jobApplications = [
            SELECT Candidate__r.Email__c 
            FROM Job_Application__c 
            WHERE Job_Applications__c = :event.Position_Id__c
        ];

        // Debugging: Check if job applications are being fetched
        System.debug('Job Applications: ' + jobApplications);

        // Loop through each Job Application and send an email to the associated Candidate
        for (Job_Application__c jobApp : jobApplications) {
            
            if (jobApp.Candidate__r != null && String.isNotBlank(jobApp.Candidate__r.Email__c)) {
                
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                
                email.setToAddresses(new String[] { jobApp.Candidate__r.Email__c });
                email.setSubject('Update to Position You Applied For');
                email.setHtmlBody('Dear Applicant,<br><br>The following updates were made to the Position:<br>' +
                    event.Updated_Fields__c + // Include updated fields from the platform event
                    '<br><br>Thank you for your interest.<br>HR Team');

                // Add email to the list
                emails.add(email);
            }
        }
    }

    if (!emails.isEmpty()) {
        Messaging.sendEmail(emails);
    }
}

