@RestResource(urlMapping='/Accounts/*')
global with sharing class AccountsCSV {
  @HttpGet
  global static String doGet() {
    // Retrieve the accounts data
    List<Account> accounts = [
      SELECT
        Name,
        Phone,
        Website,
        Industry,
        AnnualRevenue,
        NumberOfEmployees,
        BillingStreet,
        BillingCity,
        BillingState,
        BillingPostalCode
      FROM Account
    ];
    // Create the CSV file
    String csvFile = createCSV(accounts);

    // Create a new "Attachment" record to store the CSV file
    Attachment attachment = new Attachment();
    attachment.Body = Blob.valueOf(csvFile);
    attachment.Name = 'Accounts.csv';
    attachment.ContentType = 'application/csv';
    attachment.ParentId = UserInfo.getUserId(); // or any other record Id that you want to relate this attachment to
    insert attachment;
    //Return the attachment id
    return attachment.Id;
  }
  private static String createCSV(List<Account> accounts) {
    String csv = 'Name,Phone,Website,Industry,AnnualRevenue,NumberOfEmployees,BillingStreet,BillingCity,BillingState,BillingPostalCode\n';
    for (Account a : accounts) {
      csv += '"' + a.Name + '",';
      csv += '"' + a.Phone + '",';
      csv += '"' + a.Website + '",';
      csv += '"' + a.Industry + '",';
      csv += '"' + a.AnnualRevenue + '",';
      csv += '"' + a.NumberOfEmployees + '",';
      csv += '"' + a.BillingStreet + '",';
      csv += '"' + a.BillingCity + '",';
      csv += '"' + a.BillingState + '",';
      csv += '"' + a.BillingPostalCode + '"\n';
    }
    return csv;
  }
}
