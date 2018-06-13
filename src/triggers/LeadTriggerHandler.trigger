trigger LeadTriggerHandler on Lead (after insert, after update, after delete, after undelete, before insert, before update, before delete) {
new LeadTriggerHandler().run();

}