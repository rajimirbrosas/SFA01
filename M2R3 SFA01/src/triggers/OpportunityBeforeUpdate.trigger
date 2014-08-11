trigger OpportunityBeforeUpdate on Opportunity (before update) {
    String sNewStage = '';
    String sOldStage = '';
    Double dNewProb = 0;
    Double dOldProb = 0;    
    for(Opportunity oppty : Trigger.new){
        sNewStage = oppty.StageName;
        dNewProb = oppty.Probability;      
        if (sNewStage == 'Closed Sales'){    
            List<Siebel_Order__c> opptyList = [SELECT Id from Siebel_Order__c where OpportunityId__c = :oppty.Id and Status__c <> 'Complete'];
            for(Siebel_Order__c rec : opptyList){
                oppty.addError('Opportunity cannot be closed when there is still Open Siebel Order.');
                break;       
            }
        }
        
        for (Opportunity oldoppty : Trigger.old){
            dOldProb = oldoppty.Probability;
            sOldStage = oldoppty.StageName; 
            if(dNewProb == dOldProb && dNewProb == 100){
                if(sNewStage=='LOA' && (sOldStage=='Infra Issues'||sOldStage=='Order Placed'||sOldStage=='Closed Sale')){
                  oppty.addError('Opportunity stage cannot be set to backward value.');  
                }else if(sNewStage=='Infra Issues' && (sOldStage=='Order Placed'||sOldStage=='Closed Sale')){
                  oppty.addError('Opportunity stage cannot be set to backward value.');
                }else if(sNewStage=='Order Placed' && sOldStage=='Closed Sale'){
                  oppty.addError('Opportunity stage cannot be set to backward value.');  
                }
            }
            else if(dNewProb < dOldProb && dNewProb > 0){
                oppty.addError('Opportunity stage cannot be set to backward value.');
            }
            
            if(sOldStage=='Closed Sale'||sOldStage=='Dropped'){
                oppty.addError('Opportunity cannot be updated when in end state.');
            }        
        }       
    }    
}