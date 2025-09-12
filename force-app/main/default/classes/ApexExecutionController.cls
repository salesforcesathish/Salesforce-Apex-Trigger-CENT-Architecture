/*
 * @Author: Sathish SFDC
 * 
 * Purpose: 
 * ApexExecutionController help control the execution of the Apex Class or Trigger logic. With the help of this class, 
 * you have the ability to control the execution at object level or method level or block level.
 * 
 * Usages: 
 * 1. To skip all triggers, use the following code:
 * 		ApexExecutionController.setSkipAllTriggers(true);
 * 2. To enable/disable the Skip, use the following code:
 *      For specific trigger:
 * 		--- ApexExecutionController.addSkip('AccountTrigger');
 *      --- ApexExecutionController.removeSkip('AccountTrigger');
 *      For All triggers:
 *      --- ApexExecutionController.removeAllSkip();
 * 3. To check whether the specific trigger needs to be skipped or not
 *    	ApexExecutionController.checkSkipExecution('AccountTrigger') { return; }
 */
public class ApexExecutionController {

    // Skip all triggers
    private static Boolean bolSkipAllTriggers = false;
    public static void setSkipAllTriggers(Boolean bolSkip) {
		bolSkipAllTriggers = bolSkip;
    }
    public static Boolean getSkipAllTriggers() {
		return bolSkipAllTriggers;
    }
    
    // To enable/disable the skip ONLY specific triggers programmatically
    public static set<String> setProgrammaticSkip = new set<String>();
    public static void addSkip(String strReference) {
    	setProgrammaticSkip.add(strReference);
    }
    public static void removeSkip(String strReference) {
    	setProgrammaticSkip.remove(strReference);
    }
    public static void removeAllSkip() {
    	setProgrammaticSkip = new set<String>();
    }

    // To check whether the specific trigger needs to be skipped or not
    public static Boolean checkSkipExecution(String strReference) {
		Boolean bolSkipExecution = false;

		// Check whether skip is enabled programmatically
		if(setProgrammaticSkip.contains(strReference)) {
			bolSkipExecution = true;
		}
		else {
			// Check whether skip is enabled from ApexExecutionController__mdt custom metadata
			ApexExecutionController__mdt mdtExecutionController = StaticFactory.getApexExecutionController(strReference);

			if(mdtExecutionController != null && (mdtExecutionController.Skip_for_All_Users__c == true || 
			    (mdtExecutionController.Users_to_Skip__c != null && mdtExecutionController.Users_to_Skip__c.contains(userInfo.getUserId().substring(0, 15))))) {
				bolSkipExecution = true;
			}
		}
		return bolSkipExecution;
    }
    
	// Programmatically skip execution based on recursion counter
	private static map<String, Integer> mapRecursionCounter = new map<String, Integer>();
	public static void resetRecursionCounter(String strReference) {
		mapRecursionCounter.remove(strReference);
	}
	public static void resetAllRecursionCounters() {
		mapRecursionCounter = new map<String, Integer>();
	}    
}