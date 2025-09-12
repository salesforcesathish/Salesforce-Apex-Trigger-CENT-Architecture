/*
 * @Author: Sathish SFDC
 * 
 * Purpose: 
 * StaticFactory helps to maintain the static data which can be reused instead of fetching the data for each request.
 */ 
public class StaticFactory {
    
    // Introduced the custom metadata to skip the user for trigger execution
	private static map<String, ApexExecutionController__mdt> mapAEC = new Map<String, ApexExecutionController__mdt>();
	public static map<String, ApexExecutionController__mdt> getApexExecutionController() {
		if (mapAEC.isEmpty()) {
			for (ApexExecutionController__mdt mdtAEC : [SELECT Id, MasterLabel, DeveloperName, Skip_for_All_Users__c, Users_to_Skip__c FROM ApexExecutionController__mdt]) {
				mapAEC.put(mdtAEC.MasterLabel, mdtAEC);
			}
		}
		return mapAEC;
	}

    // Fetch and return the custom metadata for the given name
	public static ApexExecutionController__mdt getApexExecutionController(String strName) {
		return getApexExecutionController().get(strName);
	}
}