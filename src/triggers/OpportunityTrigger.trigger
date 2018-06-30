trigger OpportunityTrigger on Opportunity (after insert, after update, after delete, after undelete, before insert, before update, before delete) {
   new Opportunity_TriggerHandler().run();
}