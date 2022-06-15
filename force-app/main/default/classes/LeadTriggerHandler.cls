public with sharing class LeadTriggerHandler {
   public static void createDuplicateLead(List<Lead> newLeads) {
       List<Lead> dupleads = new List<Lead>();

       for(Lead le: newLeads){
           Lead l= new Lead();
           l.LastName = 'Dup of ' + le.LastName;
           l.Company = le.Company;
           dupleads.add(l);
       }
       insert dupleads;
   }

   public static void sendEmailWithAttachedPDF(List<Lead> newLeads) {
    List<Messaging.SingleEmailMessage> emails =new List<Messaging.SingleEmailMessage>();
    for(Lead le: newLeads) {
        if(le.Email!=null) {
            // Step 1: Create a new Email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           	     
        mail.setSenderDisplayName('System Administrator');
        mail.setUseSignature(false);
        mail.setBccSender(false);
        mail.setSaveAsActivity(false);

            // Step 2: Set list of people who shoule get the email
        List<String> tomail = new List<String>();
                tomail.add(le.Email);
        mail.setToAddresses(tomail);

          // Step 3. Set email contents - you can use variables!
        mail.setSubject('Welcome');
        mail.setHtmlBody('<html><body>Hi, Please find the attached PDF.</body></html>');
        List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
        for (Attachment a : [select Name, Body, BodyLength from Attachment where ParentId = :le.Id])
        {
        
        Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
         efa.setContentType('application/pdf');
         efa.setFileName('pdffile.pdf');
           String body;
        
        body = '<html><h1 style=\"text-align:center;\">LeadInformation</h1><br/><br/><table align=\"center\"><tr><td>Name</td><td>' + le.Name + '</td></tr><tr><td>Age</td><td>' + le.Email + '</td></tr><tr><td>State</td><td>' + le.Company + '</td></tr><tr><td>City</td><td>' + le.Phone + '</td></tr></table></html>';
        System.debug('HTML is ' + body);
        
        efa.Body = Blob.toPDF(body);  

        fileAttachments.add(efa);
        }
        mail.setFileAttachments(fileAttachments);
       // Step 4. Add your email to the master list
        emails.add(mail);
        }
        Messaging.sendEmail(emails);
    }
   }
}