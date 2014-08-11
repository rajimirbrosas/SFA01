trigger OpportunityOwnerCheck on Opportunity (after insert) {
     
        try{
        for (Opportunity a : trigger.new) {
        
      

      
           if (Opportunity.OwnerId <> Account.OwnerId  ){
        

            // create the new approval request to submit
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Submitted for approval. Please approve.');
            req.setObjectId(a.id);
            // submit the approval request for processing
            Approval.ProcessResult result = Approval.process(req);
            // display if the reqeust was successful
            System.debug('Submitted for approval successfully: '+result.isSuccess());
           
                    
                }
         
  }  }catch(System.DMLException e) { }


}