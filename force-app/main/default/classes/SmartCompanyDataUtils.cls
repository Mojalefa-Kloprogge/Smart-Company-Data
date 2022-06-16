public with sharing class SmartCompanyDataUtils {
        public static String getSObjectById(ID id) {
            return Id.getSObjectType().getDescribe().getName();
        }
}
