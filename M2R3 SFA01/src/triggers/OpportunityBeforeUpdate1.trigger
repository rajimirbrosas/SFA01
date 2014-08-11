trigger OpportunityBeforeUpdate1 on Opportunity (before update) {
    for(Opportunity oppty : Trigger.new){
        String sYear = string.valueof(oppty.CloseDate.Year());
        String sRecordType = '';    
        List<OpportunityLineItem> opptylineitemListtoUpdate = new List<OpportunityLineItem>();
        List<OpportunityLineItem> opptylineitemList = [SELECT Id , Target_Revenue_Id_Account__c, Target_Revenue_Id_Product__c, Target_Revenue_Id_User__c, PricebookEntry.Product2.Id from OpportunityLineItem where OpportunityId = :oppty.Id];
        
        for(OpportunityLineItem opptylineitem : opptylineitemList){
            List<Sales_Target_Revenue__c> strList = [SELECT RecordTypeId, Id from  Sales_Target_Revenue__c where ((Line_of_Business_LOB_Calc__c = :oppty.Line_of_Business_LOB__c AND LOB_Vertical_Calc__c = :oppty.LOB_Vertical__c AND (Product__c = :opptylineitem.PricebookEntry.Product2.Id OR Account_Name__c = :oppty.AccountId OR User__c = :oppty.OwnerId)) OR (Line_of_Business_LOB_Calc__c = :oppty.Line_of_Business_LOB__c AND RecordType.DeveloperName = 'LOB') OR (LOB_Vertical_Calc__c = :oppty.LOB_Vertical__c AND Line_of_Business_LOB_Calc__c = :oppty.Line_of_Business_LOB__c AND RecordType.DeveloperName = 'LOB Vertical')) AND Quarter__c = :oppty.Quarter__c  AND Year__c = :sYear];
            for(Sales_Target_Revenue__c str : strList){
                sRecordType = [Select Name from RecordType where Id = :str.RecordTypeId].Name;     
                if(sRecordType == 'Product')
                    opptylineitem.Target_Revenue_Id_Product__c = str.Id;
                else if(sRecordType == 'Account')
                    opptylineitem.Target_Revenue_Id_Account__c = str.Id;
                else if(sRecordType == 'User')
                    opptylineitem.Target_Revenue_Id_User__c = str.Id;
                else if(sRecordType == 'LOB Vertical')
                    opptylineitem.Target_Revenue_Id_LOB_Vertical__c = str.Id;
                else if(sRecordType == 'LOB')
                    opptylineitem.Target_Revenue_Id_LOB__c = str.Id;
            }
            opptylineitemListtoUpdate.add(opptylineitem);
        }       
        
        if (opptylineitemListtoUpdate != null)
            update opptylineitemListtoUpdate;        
    }
}