@isTest
public with sharing class AccountTriggerHandlerTest {
   @isTest 
   private static void copyBillingAddressTest() {
       List<Account> accs = new List<Account>();
       for(Integer i=0;i<20;i++){
           Account ac= new Account(Name= 'Test'+i ,BillingCity = 'BillCity'+i,BillingStreet='BillStr'+i,BillingState='BillState'+i,BillingPostalCode='789456'+i,BillingCountry='BillCon'+i);
           accs.add(ac);
       }
       insert accs;
       
       List<Account> acc =[Select Id,Name,ShippingCity,ShippingState,ShippingPostalCode,ShippingStreet,ShippingCountry FROM Account];
       for(Account a:acc){
           for(Integer i=0;i<20;i++){
           if(a.Name == 'Test'+i){
               System.assertEquals('BillCity'+i,a.ShippingCity);
               System.assertEquals('BillStr'+i,a.ShippingStreet);
               System.assertEquals('BillState'+i,a.ShippingState);
               System.assertEquals('789456'+i,a.ShippingPostalCode);
               System.assertEquals('BillCon'+i,a.ShippingCountry);
               
           }
        }
       }
   }
   @isTest
   private static void createAndAssociateContactTest() {
    List<Account> accs = new List<Account>();
    for(Integer i=0;i<20;i++){
        Account ac= new Account(Name= 'Test'+i);
        accs.add(ac);
    }
    insert accs;
    
    List<Contact> con =[Select Id,LastName,AccountId FROM Contact];
    List<Account> acc= [Select Id,Name FROM Account];
    for(Account a:acc){
    for(Contact c:con){
        for(Integer i=0;i<20;i++){
            if(c.LastName == 'Test'+i && a.Name == 'Test'+i){
                System.assertEquals(c.AccountId,a.Id);
                System.assertEquals(c.LastName, a.Name);
            }     
        }
     }
    }
    }
}
