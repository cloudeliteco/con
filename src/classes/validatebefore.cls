global with sharing class validatebefore{
    webService static String validate(){
        id batchprocessid=Database.executeBatch(new lead_FindAccounts(), 100);
        return batchprocessid;
    }
}