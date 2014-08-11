@isTest(SeeAllData = true) 
private class HelloWorldTestClass { 
    static testMethod void myTestDynamicIds(){
        String sVertRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'LOB Vertical'].Id;
        String sLOBRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'LOB'].Id;
        String sAccRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Account'].Id;
        String sUserRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'User'].Id;
        String sProdRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Product'].Id;

        /*Decimal TargetRev = 0;
        List<Sales_Target_Revenue__c> strList = new List<Sales_Target_Revenue__c>();
        List<Sales_Target_Revenue__c> strUpdate = new List<Sales_Target_Revenue__c>();    
        strList = [SELECT Id, Target_Revenue__c from Sales_Target_Revenue__c where Line_of_Business_LOB__c = 'Government' and Quarter__c='Q1' and RecordTypeId = '012c00000004gqgAAA'];
        System.debug(strList);        
        for(Sales_Target_Revenue__c str : strList){
                  TargetRev = str.Target_Revenue__c - 100;        
                  str.Target_Revenue__c = TargetRev;
                  strUpdate.add(Str);               
        }   
        update strUpdate;
        */
         
        String sProdId = [SELECT Id FROM Product2 WHERE Name = 'Data - Metro-E - Metro-E'].Id;
        String sAccntId = [SELECT Id FROM Account WHERE Name = 'HOSPITAL BESAR KL'].Id;
        String sUserId = [SELECT Id FROM User WHERE Username = 'vkelliz@yahoo.com.sfa01'].Id;        
        
        List<Sales_Target_Revenue__c> strNewList = new List<Sales_Target_Revenue__c>();  
        Sales_Target_Revenue__c strNew = new Sales_Target_Revenue__c(RecordTypeId = sAccRecordTypeId,Line_of_Business_LOB__c='Government',Vertical_LOB__c='Defense',Quarter__c='Q4',Year__c='2014',Target_Revenue__c=100,Account_Name__c=sAccntId);
        strNewList.add(strnew);
          
        strNew = new Sales_Target_Revenue__c(RecordTypeId = sProdRecordTypeId,Line_of_Business_LOB__c='Government',Vertical_LOB__c='Defense',Quarter__c='Q4',Year__c='2014',Target_Revenue__c=100,Product__c=sProdId);
        strNewList.add(strnew);
        //System.assertEquals(TargetRev, strNew.Target_Revenue__c);
 
        strNew = new Sales_Target_Revenue__c(RecordTypeId = sUserRecordTypeId,Line_of_Business_LOB__c='Government',Vertical_LOB__c='Defense',Quarter__c='Q4',Year__c='2014',Target_Revenue__c=100,User__c=sUserId);
        strNewList.add(strnew);

        strNew = new Sales_Target_Revenue__c(RecordTypeId = sVertRecordTypeId,Line_of_Business_LOB__c='Government',Vertical_LOB__c='Financial Service Institution',Quarter__c='Q4',Year__c='2014',Target_Revenue__c=70000);
        strNewList.add(strnew);
        
        insert strNewList;
        
        strNew = [Select Id,Target_Revenue__c from Sales_Target_Revenue__c where RecordTypeId = :sLOBRecordTypeId and Line_of_Business_LOB__c='Government' and Quarter__c='Q3' and Year__c='2014'];
        strNewList.add(strnew);
        
        update strNewList;            
                     
                
        
    }
}