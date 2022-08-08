public with sharing class AccountTriggerHandler {
   public static void copyBillingAddress(List<Account> newAccounts) {
       for(Account acc: newAccounts){
           if(acc.BillingCity!=null || acc.BillingStreet!=null || acc.BillingState!=null || acc.BillingPostalCode!=null || acc.BillingCountry!=null){
               acc.ShippingCity = acc.BillingCity;
               acc.ShippingState = acc.BillingState;
               acc.ShippingPostalCode = acc.BillingPostalCode;
               acc.ShippingStreet = acc.BillingStreet;
               acc.ShippingCountry = acc.BillingCountry;
           }
       }
   }

   public static void createAndAssociateContact(List<Account> newAccounts) {
       List<Contact> contactsToBecreated = new List<Contact>();
       for (Account acc : newAccounts) {
           Contact con = new Contact(LastName =acc.Name , AccountId = acc.Id);
           contactsToBecreated.add(con);
       }
       insert contactsToBecreated;
   }

   public static void validateAccountNameUpdate(List<Account> accountsToUpdate, Map<Id,Account> oldAccountsMap) {
       for(Account acc: accountsToUpdate){
           if(acc.Name != oldAccountsMap.get(acc.Id).Name){
               acc.addError('Cant modify the Account name once Inserted');
           }
       }   
    }
    
   public static void updateContactMailAddress(List<Account> accountsToUpdate, Map<Id,Account> oldAccountsMap) {
       Set<Id> accIds = new Set<Id>();
        for(Account acc: accountsToUpdate){
            if(acc.BillingStreet != oldAccountsMap.get(acc.Id).BillingStreet){
                accIds.add(acc.Id);
            }
        }
        List<Account> accountsWithContacts = [SELECT Id, Name,BillingCity,BillingState,BillingStreet,BillingCountry,BillingPostalCode,
                                                            (Select Id,Name From contacts) FROM Account 
                                                            WHERE Id IN: accIds]  ;
        List<Contact> contactsToUpdate = new List<Contact> ();
        for(Account acc: accountsWithContacts){
            List<Contact> contactswithLoopedAccount = acc.Contacts;
            for(Contact con: contactswithLoopedAccount){
                con.MailingCity = acc.BillingCity;
                con.MailingCountry = acc.BillingCountry;
                con.MailingPostalCode = acc.BillingPostalCode;
                con.MailingState = acc.BillingState;
                con.MailingStreet = acc.BillingStreet;
                contactsToUpdate.add(con);
            }  
        }
        if(contactsToUpdate.size()>0){
            update contactsToUpdate;
        }
     }

     public static void validateDeletion(List<Account> accountsToBeDeleted) {
        for (Account acc : accountsToBeDeleted) {
            if(acc.Active__c == 'Yes'){
                acc.addError('Cannot delete an active account');
            }
        }
    }

    public static void updateMonthOldOppoertunities(List<Account> accounts) {
        List<Account> accountsWithOpp = [SELECT Id, Name, (Select Id, Name, StageName,CreatedDate FROM Opportunities 
                                            WHERE CreatedDate < LAST_N_DAYS:30) FROM Account];
        List<Opportunity> oldOppToUpdate = new List<Opportunity>();
        for(Account acc: accountsWithOpp){
            List<Opportunity> oppWithAcc = acc.Opportunities;
            if(oppWithAcc.size()>0){
                for(Opportunity opp : oppWithAcc){
                    if(opp.StageName != 'Closed Won'){
                            opp.StageName = 'Closed Lost';
                    }
                    oldOppToUpdate.add(opp);
                }
            } 
        }
        update oldOppToUpdate;
    }

    public static void createAccountAndContactClient(List<Account> newAccounts) {
        List<Contact> contactsToBecreated = new List<Contact>();
        for (Account acc : newAccounts) {
            Contact con = new Contact(LastName =acc.Name+'Contact' , AccountId = acc.Id);
            contactsToBecreated.add(con);
        }
        insert contactsToBecreated;
        List<Account> acctobeUpdated = new List<Account>();
        for(Contact con: contactsToBecreated){
            Account acc = [Select Id, Name, Client_Contact_lookup_to_Contact__c  FROM Account WHERE Id=: con.AccountId];
            acc.Client_Contact_lookup_to_Contact__c = con.Id;
            acctobeUpdated.add(acc);
        }
        update acctobeUpdated;
    }
    public static void sendEmailToAccountOnInsertion(List<Account> newAccounts) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(Account acc: newAccounts){
                // Step 1: Create a new Email
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           	     
			mail.setSenderDisplayName('System Administrator');
            mail.setUseSignature(false);
            mail.setBccSender(false);
            mail.setSaveAsActivity(false);

                
                // Step 2: Set list of people who should get the email
      List<User> sendTo = [SELECT Email FROM User WHERE Profile.Name = 'System Administrator'];
      List<String> tomail = new List<String>();
      for(User u:sendTo){
        tomail.add(u.Email);
      }
      mail.setToAddresses(tomail);
                // Step 3. Set email contents - you can use variables!
      mail.setSubject('Account has been created with name:'+ acc.Name);
      mail.setHtmlBody('<html><body>Hi, Account Has been created with '+ acc.Name+'</body> </html>');
                
             // Step 4. Add your email to the master list
      emails.add(mail);
                
        }
    Messaging.sendEmail(emails);
    }
    
    public static void updateOpportunityAmountOnAccount(List<Account> newAccounts) {
        Set<Id> accIdWithOpp = new Set<Id>();
        for(Account acc: newAccounts)
        {
            acc.Total_Opportunity_Amount__c =0;
            accIdWithOpp.add(acc.Id);
        }
        List<AggregateResult> results = [SELECT AccountId, Sum(Amount) TotalAmount FROM Opportunity
                                            WHERE AccountId IN:accIdWithOpp 
                                            Group By AccountId];
        Map<Id,Double> accMap = new Map<Id,Double>();
        List<Account> accountsToUpdate = new List<Account>();
        for(AggregateResult res: results){
            Id accountId = (Id) res.get('AccountId');
            Double totalAmount = (double) res.get('TotalAmount');
            accMap.put(accountId, totalAmount);
        }
        for(Account acc:newAccounts){
            if(accMap.containsKey(acc.Id)){
                acc.Total_Opportunity_Amount__c = accMap.get(acc.Id);
            }
        }
        if(accountsToUpdate.size()>0){
            update accountsToUpdate;
        }
    }

    public static void emailAlertOnAccountTypeChange(List<Account> newAccount,Map<Id,Account> mapOfAccount) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        Set<Id> accIds = new Set<Id>();
        for (Account acc : newAccount) {
            if(acc.Type != mapOfAccount.get(acc.Id).Type){
                    accIds.add(acc.Id);
            }
        }
        List<Contact> updatedAccountWithContacts = [SELECT Id,LastName, Email, Account.Name, AccountId FROM Contact
                                                    WHERE AccountId IN: accIds];
        if(updatedAccountWithContacts.size()>0){
        for(Contact con: updatedAccountWithContacts){
            if(con.Email != null){
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           	     
            mail.setSenderDisplayName('System Administrator');
            mail.setUseSignature(false);
            mail.setBccSender(false);
            mail.setSaveAsActivity(false);

            // Step 2: Set list of people who should get the email
            mail.ToAddresses= new String[] {con.Email};

            // Step 3. Set email contents - you can use variables!
            mail.setSubject(' Account Update Info');
            mail.setHtmlBody('<html><body>Hi, Your account information has been updated successfully with new Type '+'</body> </html>');

            // Step 4. Add your email to the master list
            emails.add(mail);
                }   
            }
        }
        if(emails.size()>0){
            Messaging.sendEmail(emails);
        }
    }
    public static void copyAssetsFromOpportunityLineItemsOnAccountUpdate(List<Account> newAccounts) {
        Set<Id> accIds = new Set<Id>();
        for(Account acc:newAccounts){
            accIds.add(acc.Id);
        }
        List<Opportunity> opportunityWithAccount = [SELECT Id, Name, AccountId ,(SELECT Id,Name,Product2Id, Opportunity.AccountId FROM OpportunityLineItems) FROM Opportunity
                                                    WHERE AccountId IN: accIds];
        List<Asset> newAssets = new List<Asset>();
        for(Opportunity opp: opportunityWithAccount){
            List<OpportunityLineItem> oppLineItems = opp.OpportunityLineItems;
            for(OpportunityLineItem oppLineItem: oppLineItems){
                Asset asset = new Asset(Name = oppLineItem.Name+'Asset', Product2Id = oppLineItem.Product2Id, AccountId = opp.AccountId);
                newAssets.add(asset);
            }
        }
        if(newAssets.size()>0){
            insert newAssets;
        }
    }
}