public with sharing class DescribeUtils {
    Map<String, Schema.SObjectType> gd;

    public DescribeUtils() {
        this.gd = Schema.getGlobalDescribe();
    }

    public String getFieldLabelBySObjectAndFieldname(String sObjectName, String fieldName) {
        Schema.SObjectType sObjectType = gd.get(sObjectName);
        if (sObjectType == null) {
            return null;
        }
        Schema.SObjectField dfr = sObjectType.getDescribe().fields.getMap().get(fieldName);
        String s;
        if (dfr != null) {
            s = dfr.getDescribe().getLabel();
        }
        return s;
    }

}