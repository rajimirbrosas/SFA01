public with sharing class TestQueryController {
    List<Account> myOCR;

    public List<Account> getAccounts() {
        if (myOCR == null) {
            myOCR = [SELECT Name,
               OwnerId FROM Account ];
        }
        return myOCR;
    }
}