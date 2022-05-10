public class ContactTriggerHandler {
    public static void Before_Insert(List<Contact> newContacts){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate =[SELECT Id, Name, Subject, Body FROM EmailTemplate where Name =
                                      'Contact Email Template'];
        //Get templete id for set the templete.
        for(Contact myContact: newContacts){
            if (myContact.Email != null && myContact.FirstName != null) { 
            
                // Step 1: Create a new Email
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           	     
            mail.setTargetObjectId(myContact.id);
			mail.setWhatId(myContact.Id);
                
                // Step 2: Set list of people who should get the email
      List<String> sendTo = new List<String>();
      sendTo.add(myContact.Email);
      mail.setToAddresses(sendTo);
                
                // Step 3. Set email contents - you can use variables!
      mail.setSubject(emailTemplate.Subject);
      mail.setHtmlBody(emailTemplate.Body);
                
             // Step 4. Add your email to the master list
      mails.add(mail);
                
            }
        }
        // Step 5: Send all emails in the master list
        Messaging.sendEmail(mails);
    }
}