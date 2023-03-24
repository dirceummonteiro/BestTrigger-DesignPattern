public with sharing class LUX_EmailMessageHandler extends Evmd.TriggerHandler{
    public override void beforeInsert() {
        LUX_EmailMessageBO.getInstance().verifyTask(trigger.new);
    }
}
