/**
 * Created by JJ93 on 23.09.2020.
 */

trigger LeadTrigger on Lead (before insert, before update, before delete, after insert,
        after update, after delete, after undelete) {

    LeadTriggerHandler handler = new LeadTriggerHandler();
    if (Trigger.isInsert && Trigger.isBefore) {
        handler.beforeInsert(Trigger.new);
    } else if (Trigger.isInsert && Trigger.isAfter) {
        handler.afterInsert(Trigger.new);
    } else if (Trigger.isUpdate && Trigger.isBefore) {
        handler.beforeUpdate(Trigger.oldMap, Trigger.newMap);
    } else if (Trigger.isUpdate && Trigger.isAfter) {
        if (LeadTriggerHandler.IS_FIRST_TRIGGER_RUN == true) {
            LeadTriggerHandler.IS_FIRST_TRIGGER_RUN = false;
            handler.afterUpdate(Trigger.oldMap, Trigger.newMap);
        }
    } else if (Trigger.isDelete && Trigger.isBefore) {
        handler.beforeDelete(Trigger.old, Trigger.oldMap);
    } else if (Trigger.isDelete && Trigger.isAfter) {
        handler.afterDelete(Trigger.old, Trigger.oldMap);
    } else if (Trigger.isUndelete && Trigger.isAfter) {
        handler.afterUndelete(Trigger.new);
    }

}