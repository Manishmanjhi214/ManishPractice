public class ContactTriggerHandler {
    public static void sendEmailOnContactInsertion(List<Contact> newContacts){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate =[SELECT Id, Name, Subject, Body FROM EmailTemplate where Name =
                                      'Contact Email Template'];
        //Get templete id for set the templete.
        for(Contact myContact: newContacts){
            if (myContact.Email != null ) { 
            
                // Step 1: Create a new Email
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           	     
            mail.setTargetObjectId(myContact.id);
            mail.setWhatId(myContact.Id);
			mail.setSenderDisplayName('System Administrator');
            mail.setUseSignature(false);
            mail.setBccSender(false);
            mail.setSaveAsActivity(false);

                
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

    public static void preventInsertionOfDuplicateRecords(List<Contact> newContact) {
        String message='';
        Map<String,Contact> mapContactEmail = new Map<String,Contact>();
        Map<String,Object> mapContactPhone = new Map<String,Contact>();
       
        for(Contact con:newContact){
            mapContactEmail.put(con.Email, con);
            mapContactPhone.put(con.Phone, con);
        }

        List<Contact> existingContact = [Select Id, Email, Phone FROM Contact Where Email IN: mapContactEmail.keySet() 
        OR Phone IN:mapContactPhone.keySet()];
        if(existingContact.size()>0){
            for(Contact con: existingContact){
                if(con.Email != null){
                    if(mapContactEmail.get(con.Email)!= null){
                        message ='Enter new Email Error';
                    }
                }
                if(con.Phone != null){
                    if(mapContactPhone.get(con.Phone)!= null){
                        message = 'Enter new phone Error';
                    }
                }
           
            }
        }
        if(message!=''){
            newContact[0].addError(message);
            }
            
    }

    public static void preventUpdationOfDuplicateRecords(List<Contact> oldContact,Map<Id,Contact> mapOfContact) {
        String message= '';
        Map<String,Contact> mapContactEmail = new Map<String,Contact>();
        Map<String,Object> mapContactPhone = new Map<String,Contact>();
        for(Contact con: oldContact){
            if(con.Email != mapOfContact.get(con.Id).Email){
                mapContactEmail.put(con.Email, con);
            }
            if(con.Phone != mapOfContact.get(con.Id).Phone){
                mapContactPhone.put(con.Phone, con);
            }
        }   
        List<Contact> existingContact = [Select Id, Email, Phone FROM Contact Where Email IN: mapContactEmail.keySet() 
        OR Phone IN:mapContactPhone.keySet()];
        if(existingContact.size()>0){
            for(Contact con: existingContact){
                if(con.Email != null){
                    if(mapContactEmail.get(con.Email)!= null){
                        message ='Enter new Email Error';
                    }
                }
                if(con.Phone != null){
                    if(mapContactPhone.get(con.Phone)!= null){
                        message = 'Enter new phone Error';
                    }
                }
           
            }
        }
        if(message!=''){
            oldContact[0].addError(message);
        }
       
    }

}