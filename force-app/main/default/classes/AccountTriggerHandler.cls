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

}