trigger LeadProcessTriggerHandler on Lead_Processor__c (after insert, after update, after delete, after undelete, before insert, before update, before delete) {
    new LeadProcessorTriggerHandler().run();
}