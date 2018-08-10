@isTest
public class TestDataFactory {
    
    
    public static Id Account_Bankruptcy_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bankruptcy').getRecordTypeId();        
    public static Id Account_Debtor_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Debtors').getRecordTypeId();
    
    
    
    public static List<account> createBankruptcyClaim(String companyName, String bankruptName, String debtorName){
        Account claimAccount = createAccountWCompanyName(companyName);
        List<Account> bankruptAccounts = createBankruptcyCompanies(bankruptName, debtorName);
        Account bankruptAccount = bankruptAccounts[0]; //createAccountWCompanyName(bankruptName);
        Account debtorAccount = bankruptAccounts[1]; //createAccountWCompanyName(debtorName);
        
        Opportunity bankruptClaim = new Opportunity();
        bankruptClaim.AccountId = claimAccount.Id;
        bankruptClaim.Bankrupcy__c = bankruptAccount.Id;
        bankruptClaim.CloseDate = System.today().addDays(7);
        bankruptClaim.Debtor__c = debtorAccount.Id;
        bankruptClaim.Name = 'Test Opp';
        bankruptClaim.StageName = 'New';
        
        insert bankruptClaim;
        
        List<Account> new_accounts = new List<Account>();
        new_accounts.add(claimAccount);
        new_accounts.add(bankruptAccount);
        new_accounts.add(debtorAccount);
        
        return new_accounts;    
    }
    
    public static List<Account> createBankruptcyCompanies(String bankruptName, String debtorName){
        Account bankruptAccount = createAccountWCompanyName(bankruptName);
        Account debtorAccount = createAccountWCompanyName(debtorName);
        debtorAccount.ParentId = bankruptAccount.Id;
        debtorAccount.RecordTypeId = Account_Debtor_RecordTypeId;
        update debtorAccount;
        List<Account> bankruptAccounts = new List<Account>();
        bankruptAccounts.add(bankruptAccount);
        bankruptAccounts.add(debtorAccount);
        return bankruptAccounts;
    }
    public static Account createAccountWCompanyName(String companyName){
        Account a = new Account();
        a.Name = companyName;
        // if new account requirements, add here
        insert a;
        return a;
    }
    /*
public static List<Account> createMultipleAccounts(Integer numOfAccts){
List<Account> accounts = new List<Account>();
for(Integer i = 0 ; i < numOfAccts; i++){
Account a = createAccountWCompanyName('Test Account ' + i);
accounts.add(a);
}
return accounts;
}
*/
    public static List<Lead> createLeadsWCompanyName(Integer numOfLeads, String companyName){
        List<Lead> new_leads = new List<Lead>();
        for (integer i = 0 ; i < numOfLeads; i++){
            Lead new_lead = new Lead();
            new_lead.Company = companyName;
            new_lead.FirstName = 'Test';
            new_lead.LastName = 'Testlast_' + i;
            new_lead.Status = 'New';
            new_leads.add(new_lead);
        }
        //insert new_leads;
        return new_leads;
    }
    
}