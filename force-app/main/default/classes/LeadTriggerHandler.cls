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
}