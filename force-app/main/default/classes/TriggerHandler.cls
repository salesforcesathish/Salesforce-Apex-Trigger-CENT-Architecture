/*
 * @Author: Sathish SFDC
 * 
 * Purpose: 
 * TriggerHandler helps to control the overall execution of Trigger.
 * 1. Skip the trigger if configured to skip in Metadata or programmatically
 * 2. Dispatch controls to the corresponding handler methods
 */ 
public virtual class TriggerHandler {

    public void run() {
        // Skip the trigger if configured to skip in Metadata or programmatically
        if(skipExecution()) {
            return;
        }

        // Dispatch controls to the corresponding handler methods
        this.getRecordSelector();

        if(Trigger.isBefore) {
            if(Trigger.isInsert) {
                this.onBeforeInsert();
            }
            else if(Trigger.isUpdate) {
                this.onBeforeUpdate();
            }
            else if(Trigger.isDelete) {
                this.onBeforeDelete();
            }
        }
        else if(Trigger.isAfter) {
            if(Trigger.isInsert) {
                this.onAfterInsert();
            }
            else if(Trigger.isUpdate) {
                this.onAfterUpdate();
            }
            else if(Trigger.isDelete) {
                this.onAfterDelete();
            }
        }
    }

    // Validate and decides whether trigger should continue to run or not
    private Boolean skipExecution() {
        if(!Trigger.isExecuting) {
            throw new NotATriggerContextException('TriggerHandler called outside of the Trigger context.');
        }

        if(ApexExecutionController.getSkipAllTriggers()) {
            return true;
        }

        // Check whether the skip is enabled for the current object
        String sObjectName = (Trigger.isDelete ? String.valueOf(Trigger.old[0].getSObjectType()) : String.valueOf(Trigger.new[0].getSObjectType()));
        if(ApexExecutionController.checkSkipExecution(sObjectName)) {
            return true;
        }
        return false;
    }

    // Virtual empty methods for all possible events
    protected virtual void getRecordSelector() {}
    protected virtual void onBeforeInsert() {}
    protected virtual void onBeforeUpdate() {}
    protected virtual void onBeforeDelete() {}
    protected virtual void onAfterInsert() {}
    protected virtual void onAfterUpdate() {}
    protected virtual void onAfterDelete() {}

    // Custom Exceptions
    public class NotATriggerContextException extends Exception {}
}