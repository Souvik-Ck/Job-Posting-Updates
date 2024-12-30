/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 12-30-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class PositionUpdateNotificationHandler {

    public static void handleAfterInsert(List<Position_Update__e> events) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        for (Position_Update__e event : events) {
            List<Job_Application__c> jobApplications = [
                SELECT Candidate__r.Email__c 
                FROM Job_Application__c 
                WHERE Job_Applications__c = :event.Position_Id__c
            ];

            for (Job_Application__c jobApp : jobApplications) {
                if (jobApp.Candidate__r != null && String.isNotBlank(jobApp.Candidate__r.Email__c)) {
                    Messaging.SingleEmailMessage email = createEmail(jobApp.Candidate__r.Email__c, event);
                    emails.add(email);
                } else {
                    System.debug('No email found for job application: ' + jobApp.Id);
                }
            }
        }

        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
            System.debug('Emails sent successfully: ' + emails.size());
        } else {
            System.debug('No emails to send.');
        }
    }

    private static Messaging.SingleEmailMessage createEmail(String recipientEmail, Position_Update__e event) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        email.setToAddresses(new String[] { recipientEmail });
        email.setSubject('Update to Position You Applied For');
        email.setHtmlBody('Dear Applicant,<br><br>The following updates were made to the Position:<br>' +
            event.Updated_Fields__c +
            '<br><br>Thank you for your interest.<br>HR Team');

        return email;
    }
}
