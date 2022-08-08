@isTest
public with sharing class OpportunityTriggerHandlerTest {
    @isTest
   private static void emailAlertOnOpportunityStageChangeTest() {
            List<Opportunity> opportunity = new List<Opportunity>();
            Contact con = new Contact(LastName = 'Testcon1',Email ='nanurehan20@gmail.com');
            insert con;
            Account acc= New Account(Name='TestOpportunity',Client_Contact_lookup_to_Contact__c = con.Id);
            insert acc;
            for(Integer i=0;i<50;i++){
                Opportunity opp = new Opportunity(Name = 'Testopp'+i,StageName = 'Prospecting',CloseDate = Date.today(),AccountId =acc.Id,ContactId =con.Id);
                opportunity.add(opp);
                }
            insert opportunity;
        Test.startTest();
        for(Opportunity opp:opportunity){
            opp.StageName = 'Qualification';
            }
        update opportunity;
        Integer emailInvocations = Limits.getEmailInvocations();
        Test.stopTest();
   system.assertEquals(1, emailInvocations, 'An email should be sent');
   }  
}
