trigger AccountTriggerHandler on Account (after insert, after update, after delete, after undelete, before insert, before update, before delete) {
    new Account_TriggerHandler().run();
}