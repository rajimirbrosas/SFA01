trigger OpportunityLineItemAfterInsertUpdate on OpportunityLineItem (before insert, before update) {
    for(OpportunityLineItem opptyitem : Trigger.new){
        List<Opportunity> opptyList = [SELECT AccountId, Line_of_Business_LOB__c, LOB_Vertical__c, Quarter__c from Opportunity where Id = :opptyitem.OpportunityId];
        for(Opportunity oppty : opptyList){
            List<Sales_Target_Revenue__c> strList = [SELECT Id from Sales_Target_Revenue__c where Line_of_Business_LOB__c = :oppty.Line_of_Business_LOB__c AND Vertical_LOB__c = :oppty.LOB_Vertical__c AND Quarter__c = :oppty.Quarter__c AND Account_Name__c = :oppty.AccountId];
            for(Sales_Target_Revenue__c str : strList){
              opptyitem.Target_Revenue_Id_Account__c = str.Id;
              //update opptyitem;               
            }      
        }        
    }
}