public with sharing class Utils {
    public static Map<String, List<sObject>> groupRecordsByField(List<sObject> recordsToBeGrouped, String groupByField) {
        Map<String, List<sObject>> recordsByFieldName = new Map<String, List<sObject>>();

        for (sObject listElem : recordsToBeGrouped) {
            String fieldValue = String.valueOf(listElem.get(groupByField));
            if (!recordsByFieldName.containsKey(fieldValue)) {
                recordsByFieldName.put(fieldValue, new List<sObject>());
            } 
            recordsByFieldName.get(fieldValue).add(listElem);
        }
        
        return recordsByFieldName;
    }

    public static  Map<String, Set<String>> groupRecordsAndGetSobjectFieldValue(List<sObject> recordsToBeGrouped, String groupByField, String fieldFromSobject) {
        Map<String, Set<String>> result = new Map<String, Set<String>>();
        for(sObject listElem : recordsToBeGrouped) {
            String fieldValueFromSobject = String.valueOf(listElem.get(fieldFromSobject));

            if (!result.containsKey(groupByField)) {
                result.put(groupByField, new Set<String>());
            } 
            result.get(groupByField).add(fieldValueFromSobject);
        }
        return result;
    }

    public static Set<String> getFieldValueFromSobjectList(List<sObject> dataList, String fieldApiName) {
        Set<String> result = new Set<String>();

        for(sObject listElem : dataList) {
            if(listElem.get(fieldApiName) != null) {
                result.add(String.valueOf(listElem.get(fieldApiName)));    
            }
        }
        return result;
    }

}






// Create Utils class. (reuse it in trigger homework)
// method: groupRecordsByField(); input parameters - List<sObject> recordsToBeGrouped, String groupByField; return type - Map<String, List<sObject>>; NOTES. Use sObject.get() method.
// method: groupRecordsAndGetSobjectFieldValue(); input parameters - List<sObject> recordsToBeGrouped, String groupByField; String fieldFromSobject; return type - Map<String, Set<String>>; NOTES. Method is similar to groupRecordsByField() and use almost the same logic. - Optional
// method getFieldValueFromSobjectList(); input parameters - List<sObject> dataList, String fieldApiName; return type - Set<String>; NOTES. fieldApiName - API name of the sobject field. Use sObject.get(fieldApiName) to get value. Cast it to String if it is not empty.