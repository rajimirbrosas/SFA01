trigger SalesTargetRevenue on Sales_Target_Revenue__c (before insert, before update){
    for(Sales_Target_Revenue__c str : Trigger.new){
    
        String str_RecTypeId = str.RecordTypeId;    
        List<Sales_Target_Revenue__c> strList = new List<Sales_Target_Revenue__c>();
        String sRecordType = [SELECT Name FROM RecordType WHERE Id = :str_RecTypeId].Name;
        String sVertRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'LOB Vertical'].Id;
        String sLOBRecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'LOB'].Id;      
        AggregateResult[] groupedResults;
        Decimal dNewTarget = str.Target_Revenue__c;
        String str_Id =  str.Id;  
        String str_AccntName = str.Account_Name__c;
        String str_Year = str.Year__c;
        String str_Quarter = str.Quarter__c;    
        Decimal LOBTarget = 0;
        Decimal VerTarget = 0;        
                        
        if(sRecordType == 'Account'){         
            strList = [SELECT Name from Sales_Target_Revenue__c where Id <> :str_Id AND RecordTypeId = :str_RecTypeId AND Account_Name__c = :str_AccntName AND Year__c = :str_Year AND Quarter__c = :str_Quarter AND Vertical_LOB__c = :str.Vertical_LOB__c AND Line_of_Business_LOB__c = :str.Line_of_Business_LOB__c];
            groupedResults = [SELECT SUM(Target_Revenue__c) TotRev from Sales_Target_Revenue__c where Account_Name__c <> :str_AccntName  AND RecordTypeId = :str_RecTypeId AND Year__c = :str_Year AND Quarter__c = :str_Quarter AND Vertical_LOB__c = :str.Vertical_LOB__c AND Line_of_Business_LOB__c = :str.Line_of_Business_LOB__c]; 
        }else if (sRecordType == 'Product'){
            strList = [SELECT Name from Sales_Target_Revenue__c where Id <> :str_Id AND RecordTypeId = :str_RecTypeId AND Product__c = :str.Product__c AND Year__c = :str_Year AND Quarter__c = :str_Quarter AND Vertical_LOB__c = :str.Vertical_LOB__c AND Line_of_Business_LOB__c = :str.Line_of_Business_LOB__c];        
            groupedResults = [SELECT SUM(Target_Revenue__c) TotRev from Sales_Target_Revenue__c where Product__c <> :str.Product__c AND RecordTypeId = :str_RecTypeId AND Year__c = :str_Year AND Quarter__c = :str_Quarter AND Vertical_LOB__c = :str.Vertical_LOB__c AND Line_of_Business_LOB__c = :str.Line_of_Business_LOB__c];
        }
        else if (sRecordType == 'User'){
            strList = [SELECT Name from Sales_Target_Revenue__c where Id <> :str_Id AND RecordTypeId = :str_RecTypeId AND User__c = :str.User__c AND Year__c = :str_Year AND Quarter__c = :str_Quarter AND LOB_Vertical_Calc__c = :str.Vertical_LOB__c AND Line_of_Business_LOB_Calc__c = :str.Line_of_Business_LOB__c];
            groupedResults = [SELECT SUM(Target_Revenue__c) TotRev from Sales_Target_Revenue__c where User__c <> :str.User__c AND RecordTypeId = :str_RecTypeId AND Year__c = :str_Year AND Quarter__c = :str_Quarter AND Vertical_LOB__c = :str.Vertical_LOB__c AND Line_of_Business_LOB__c = :str.Line_of_Business_LOB__c];
        }
        else if (sRecordType == 'LOB Vertical'){
            strList = [SELECT Name from Sales_Target_Revenue__c where Id <> :str_Id AND RecordTypeId = :str_RecTypeId AND Vertical_LOB__c = :str.Vertical_LOB__c AND Year__c = :str_Year AND Quarter__c = :str_Quarter AND Line_of_Business_LOB__c = :str.Line_of_Business_LOB__c];
            groupedResults = [SELECT SUM(Target_Revenue__c) TotRev from Sales_Target_Revenue__c where Vertical_LOB__c <> :str.Vertical_LOB__c  AND RecordTypeId = :str_RecTypeId AND Year__c = :str_Year AND Quarter__c = :str_Quarter AND Line_of_Business_LOB__c = :str.Line_of_Business_LOB__c];
        }
        else if (sRecordType == 'LOB'){
            strList = [SELECT Name from Sales_Target_Revenue__c where Id <> :str_Id AND RecordTypeId = :str_RecTypeId AND Year__c = :str_Year AND Quarter__c = :str_Quarter AND Line_of_Business_LOB__c = :str.Line_of_Business_LOB__c];
            groupedResults = [SELECT SUM(Target_Revenue__c) TotRev from Sales_Target_Revenue__c where RecordTypeId = :sVertRecordTypeId AND Year__c = :str_Year AND Quarter__c = :str_Quarter AND Line_of_Business_LOB__c = :str.Line_of_Business_LOB__c];
        }            
        
        Decimal dSum = (Decimal)(groupedResults[0].get('TotRev'));
        if (dSum == null) dSum = 0;       
        
        if(sRecordType == 'LOB'){        
            if(dSum > dNewTarget)
               str.addError('The LOB Target Revenue cannot be less than the sum of all LOB Vertical Revenue, '+dSum+', for this quarter ' +str.Year__c+'-'+str.Quarter__c+' .');         
        }
        else if(sRecordType == 'LOB Vertical'){

            try{        
                LOBTarget = [Select Target_Revenue__c from Sales_Target_Revenue__c where RecordTypeId = :sLOBRecordTypeId AND Year__c = :str_Year AND Quarter__c = :str_Quarter AND Line_of_Business_LOB__c = :str.Line_of_Business_LOB__c].Target_Revenue__c;
            }
            catch(Exception e){        
                    str.addError('Please define first a target Revenue for the said Line of Business or LOB Vertical.');        
            }               
            
            dSum = dSum + dNewTarget;            
            if(dSum > LOBTarget)            
                str.addError('The sum of all LOB Vertical Target Revenue, '+dSum+', cannot be more than LOB Target Revenue, '+LOBTarget+', for this quarter ' +str.Year__c+'-'+str.Quarter__c+' .');        }
        else{
            try{        
               VerTarget = [Select Target_Revenue__c from Sales_Target_Revenue__c where RecordTypeId = :sVertRecordTypeId AND Vertical_LOB__c = :str.Vertical_LOB__c AND Year__c = :str_Year AND Quarter__c = :str_Quarter AND Line_of_Business_LOB__c = :str.Line_of_Business_LOB__c].Target_Revenue__c;
            }
            catch(Exception e){        
                    str.addError('Please define first a target Revenue for the said Line of Business or LOB Vertical.');        
            } 
        
            dSum = dSum + dNewTarget;        
            if(dSum > VerTarget)           
                str.addError('The sum of all '+sRecordType+' Target Revenue, '+dSum+', cannot be more than '+str.Line_of_Business_LOB__c+'-'+str.Vertical_LOB__c+' Vertical Target Revenue, '+VerTarget+' for this quarter ' +str.Year__c+'-'+str.Quarter__c+' .');
        }
                                                          
        for(Sales_Target_Revenue__c str1 : strList){
            str.addError('Duplicate Record '+str1.Name+ ' was found.');        
        }
        
        Date dStartDate;
        String sStartDate = '';
        String sYear = str.Year__c;
        String sQuarter =  str.Quarter__c;
        String sDate = '';      
         
        if(sQuarter == 'Q1'){
            sStartDate = sYear+'-'+'01-01';
            dStartDate = Date.valueof(sStartDate);
                        
        }    
        else if(sQuarter == 'Q2'){
            sStartDate = sYear+'-'+'04-01';        
            dStartDate = Date.valueof(sStartDate);
                        
        }            
        else if(sQuarter == 'Q3'){
            sStartDate = sYear+'-'+'07-01';        
            dStartDate = Date.valueof(sStartDate);
            
        }            
        else{
            sStartDate = sYear+'-'+'10-01';        
            dStartDate = Date.valueof(sStartDate);
                        
        }
         
        date dEndDate = [Select EndDate from Period where StartDate = :dStartDate and Type = 'Quarter'].EndDate;
                       
        List<Opportunity> opptyList = new List<Opportunity>();
        List<OpportunityLineItem> opptylineitemListtoUpdate = new List<OpportunityLineItem>();
        List<OpportunityLineItem> opptylineitemList = new List<OpportunityLineItem>();

        if(sRecordType == 'Account'){
            opptylineitemList = [SELECT Id from OpportunityLineItem where Account__c = :str_AccntName AND LOB__c = :str.Line_of_Business_LOB__c AND LOB_Vertical__c = :str.Vertical_LOB__c AND Quarter__c = :str_Quarter AND Year__c = :str_Year];
            for(OpportunityLineItem opptylineitem : opptylineitemList){               
              opptylineitem.Target_Revenue_Id_Account__c = str.Id;
              opptylineitemListtoUpdate.add(opptylineitem);               
            }
            update opptylineitemListtoUpdate;
        }
        else if(sRecordType == 'Product'){
            opptylineitemList = [SELECT Id from OpportunityLineItem where Account__c = :str.Product__c AND LOB__c = :str.Line_of_Business_LOB__c AND LOB_Vertical__c = :str.Vertical_LOB__c AND Quarter__c = :str_Quarter AND Year__c = :str_Year];
            for(OpportunityLineItem opptylineitem : opptylineitemList){               
              opptylineitem.Target_Revenue_Id_Product__c = str.Id;
              opptylineitemListtoUpdate.add(opptylineitem);               
            }
            update opptylineitemListtoUpdate;
        }
        else if(sRecordType == 'User'){
            opptylineitemList = [SELECT Id from OpportunityLineItem where Owner__c = :str.User__c AND Quarter__c = :str_Quarter AND Year__c = :str_Year];
            for(OpportunityLineItem opptylineitem : opptylineitemList){               
              opptylineitem.Target_Revenue_Id_User__c = str.Id;
              opptylineitemListtoUpdate.add(opptylineitem);               
            }
            update opptylineitemListtoUpdate;                   
        }
        else if(sRecordType == 'LOB Vertical'){
            opptylineitemList = [SELECT Id from OpportunityLineItem where LOB__c = :str.Line_of_Business_LOB__c AND LOB_Vertical__c = :str.Vertical_LOB__c AND Quarter__c = :str_Quarter AND Year__c = :str_Year];
            for(OpportunityLineItem opptylineitem : opptylineitemList){               
              opptylineitem.Target_Revenue_Id_LOB_Vertical__c = str.Id;
              opptylineitemListtoUpdate.add(opptylineitem);               
            }
            update opptylineitemListtoUpdate;                   
        }
        else if(sRecordType == 'LOB'){
            opptylineitemList = [SELECT Id from OpportunityLineItem where LOB__c = :str.Line_of_Business_LOB__c AND Quarter__c = :str_Quarter AND Year__c = :str_Year];
            for(OpportunityLineItem opptylineitem : opptylineitemList){               
              opptylineitem.Target_Revenue_Id_User__c = str.Id;
              opptylineitemListtoUpdate.add(opptylineitem);               
            }
            update opptylineitemListtoUpdate;                   
        }                    
    }
}