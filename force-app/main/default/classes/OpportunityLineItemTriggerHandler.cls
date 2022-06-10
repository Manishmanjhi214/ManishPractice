public with sharing class OpportunityLineItemTriggerHandler {
    public static void updateProductListOnOpporutnity(List<OpportunityLineItem> newOppLineItems) {
        Set<Id> oppWithLineItems =new Set<Id>();
        for(OpportunityLineItem oplt: newOppLineItems){
            oppWithLineItems.add(oplt.OpportunityId);
            }
        List<Opportunity> OppToUpdate = new List<Opportunity> ();
        List<Opportunity> oppWithProducts = [SELECT Id,List_of_Products__c,Name,(SELECT Name FROM OpportunityLineItems) FROM Opportunity 
                   WHERE Id IN: oppWithLineItems];
        
       for(Opportunity opp: oppWithProducts){
           Opportunity oppObj = new Opportunity();
           oppObj.Id = opp.id;
           String[] proName = new String[0];
           for(OpportunityLineItem item: opp.OpportunityLineItems){
               proName.add(item.Name);
           }
           oppObj.List_of_Products__c= String.join(proName, ';');
            OppToUpdate.add(oppObj);
        }
      if(OppToUpdate.size()>0){
          update OppToUpdate;
        }
      }

      /*public static void sendMailToContactOnOpportunityLineItem(List<OpportunityLineItem> newOppLineItems) {
        Set<Id> oppWithLineItems =new Set<Id>();
        Set<Id> contactIds = new Set<Id>();
        for(OpportunityLineItem oplt: newOppLineItems){
            oppWithLineItems.add(oplt.OpportunityId);
            }
        List<Opportunity> OppToUpdate = new List<Opportunity> ();
        List<Opportunity> oppWithAccounts = [SELECT Id, AccountId, ContactId,Account.Client_Contact_lookup_to_Contact__c ,(SELECT Name FROM OpportunityLineItems) FROM Opportunity WHERE Id IN: oppWithLineItems];
        for(Opportunity opp: oppWithAccounts){
            if(opp.AccountId!= null){
                if(opp.Account.Client_Contact_lookup_to_Contact__c != null){
                    contactIds.add(opp.Account.Client_Contact_lookup_to_Contact__c);
                }
            }
        }
        List<Contact> existingCon = [Select Id,Email FROM Contact WHERE Id IN: contactIds];
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        EmailTemplate emailTemplate =[SELECT Id, Name, Subject, Body FROM EmailTemplate where Name =
        'ContactClientFromOpportunity'];
        for(Account acc: newAccounts){
                // Step 1: Create a new Email
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           	     
			mail.setSenderDisplayName('System Administrator');
            mail.setUseSignature(false);
            mail.setBccSender(false);
            mail.setSaveAsActivity(false);

                
            // Step 2: Set list of people who should get the email
      List<String> tomail = new List<String>();
      for(Contact c:existingCon){
        tomail.add(c.Email);
      }
      mail.setToAddresses(tomail);
                // Step 3. Set email contents - you can use variables!
      mail.setSubject('Opportunity'+ acc.Name);
      mail.setHtmlBody('<html><body>Hi, Account Has been created</body> '+acc+' </html>');
                
             // Step 4. Add your email to the master list
      emails.add(mail);
                
        }
    Messaging.sendEmail(emails); Total_sales_quantities__c
       
      }*/

      public static void updateProductQuantityOnAccount(List<OpportunityLineItem> newOppLineItems) {
        Set<Id> oppWithLineItems =new Set<Id>();
        for(OpportunityLineItem oplt: newOppLineItems){
            oppWithLineItems.add(oplt.OpportunityId);
            }
        List<Account> accToUpdate = new List<Account> ();
        List<Opportunity> oppWithProducts = [SELECT Id,Account.Total_sales_quantities__c ,Name,(SELECT Name FROM OpportunityLineItems) FROM Opportunity 
                   WHERE Id IN: oppWithLineItems];
        
       for(Opportunity opp: oppWithProducts){
           if(opp.AccountId != null){
           Account accObj = new Account();
           accObj.Id = opp.AccountId;
           Integer proNumber = 0;
           for(OpportunityLineItem item: opp.OpportunityLineItems){
               proNumber++;
             }
           accObj.Total_sales_quantities__c= proNumber;
           accToUpdate.add(accObj);
            }
        }
      if(accToUpdate.size()>0){
          update accToUpdate;
        }
      }

      public static void deleteOpportunityOnLineItemDeletion(List<OpportunityLineItem> oldLineItems) {
        Set<Id> oppWithOli = new Set<Id>();
        for(OpportunityLineItem oli: oldLineItems){
          oppWithOli.add(oli.OpportunityId);
        }
        List<Opportunity> oppWithLineItem = [Select Id ,Name FROM Opportunity WHERE Id IN: oppWithOli];
        List<Opportunity> oppToDelete = new List<Opportunity>();
        for(Opportunity opp:oppWithLineItem){
          oppToDelete.add(opp);
        }
        delete oppToDelete;
      }
      
}