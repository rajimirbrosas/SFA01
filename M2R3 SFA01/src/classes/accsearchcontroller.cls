public class accsearchcontroller { 
    public accsearchcontroller(ApexPages.StandardSetController controller) {

    }

 
   public list <account> acc {get;set;}  
   public string searchstring {get;set;}  
   public accsearchcontroller(ApexPages.StandardController controller) {  
   }  
   
   
   
   public void search(){  
     string searchquery='select name,ownerid,segment_code__c,Identification_Number__c  from account where name like \'%'+searchstring+'%\' Limit 50';  
     acc= Database.query(searchquery);  
   }  
   public void clear(){  
   acc.clear();  
   }
   
   // returns the page number of the current page set
     
 }