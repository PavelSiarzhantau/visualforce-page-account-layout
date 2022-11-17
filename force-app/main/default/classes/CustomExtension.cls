public with sharing class CustomExtension {

    private Apexpages.StandardController stdController;
    private Account acc;
    public Integer sizeOfRecorsPerPage{get;set;}
    public Integer numberOfRecords{get;set;}
    public List<SelectOption> paginationSizeOptions{get;set;}
    public String accountId{get;set;}

    public String defaultRecordType{get;set;}
    public Boolean isMaster{get;set;}

    public CustomExtension(ApexPages.StandardController stdController) {
        this.sizeOfRecorsPerPage = 50;
        this.accountId = Apexpages.currentPage().getParameters().get('id');
        this.stdController = stdController;
        acc = (Account) stdController.getRecord();
        paginationSizeOptions = new List<SelectOption>();
        paginationSizeOptions.add(new SelectOption('5','5'));
        paginationSizeOptions.add(new SelectOption('10','10'));
        paginationSizeOptions.add(new SelectOption('20','20'));
        paginationSizeOptions.add(new SelectOption('50','50'));
        paginationSizeOptions.add(new SelectOption('100','100'));
        getActiveRecordType();
    }

    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {                
                setCon = new ApexPages.StandardSetController(getListOfContacts());
                setCon.setPageSize(sizeOfRecorsPerPage);  
                numberOfRecords = setCon.getResultSize();   
            }         
            return setCon;
        }
        set;
    }
    private  List<Contact> getListOfContacts(){
        return [SELECT Id,
                       FirstName,
                       LastName,
                       Email,
                       Contact.Account.Name
                FROM Contact
                WHERE AccountId =: acc.Id
                WITH SECURITY_ENFORCED
               ];
    }
    public List<Contact> getContacts(){
       return setCon.getRecords();                                                                                                                                                
    }
    public Pagereference refreshPageSize(){
       setCon.setPageSize(sizeOfRecorsPerPage);
       return null;
    }
    private void getActiveRecordType(){
        for(RecordTypeInfo info : Opportunity.SObjectType.getDescribe().getRecordTypeInfos()){
            if(info.isDefaultRecordTypeMapping()){
                defaultRecordType = info.getName();
            }
        }
    }
}
