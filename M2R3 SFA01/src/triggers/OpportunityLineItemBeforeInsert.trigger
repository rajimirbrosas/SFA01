trigger OpportunityLineItemBeforeInsert on OpportunityLineItem (before insert) {
    for(OpportunityLineItem opptyitem : Trigger.new){
        List<OpportunityLineItem> opptyitemList = [SELECT Id from OpportunityLineItem where OpportunityId = :opptyitem.OpportunityId];
        for(OpportunityLineItem rec : opptyitemList){
            opptyitem.addError('Cannot add Line Item. Opportunity can only have atmost 1 Line Item.');
            break;       
        }        
    }
}