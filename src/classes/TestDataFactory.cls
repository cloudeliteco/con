@isTest
public class TestDataFactory {
    public static Account createAccountWCompanyName(String companyName){
        Account a = new Account();
        a.Name = companyName;
        // if new account requirements, add here
        insert a;
        return a;
    }
    
    public static List<Account> createMultipleAccounts(Integer numOfAccts){
        List<Account> accounts = new List<Account>();
        for(Integer i = 0 ; i < numOfAccts; i++){
            Account a = createAccountWCompanyName('Test Account ' + i);
            accounts.add(a);
        }
        return accounts;
    }
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
        insert new_leads;
        return new_leads;
    }

}