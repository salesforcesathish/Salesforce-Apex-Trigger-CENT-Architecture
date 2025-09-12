/*
 * @Author: Sathish SFDC
 * 
 * Purpose: 
 *  -- Enforces methods to be defined in the inherited record selector classes.
 *  -- Classes which are implementing this interface should define the methods 
 * selectRecords(List<sObject>, Map<Id, sObject>) and getRelatedRecords(List<sObject>).
 */
public interface RecordSelector {
    void selectRecords(List<sObject> lstNewRecords, Map<Id, sObject> mapOldRecords);
    void getRelatedRecords();
}