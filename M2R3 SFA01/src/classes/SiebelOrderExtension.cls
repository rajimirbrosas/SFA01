public class SiebelOrderExtension{

private final Siebel_Order__c sbo;

public SiebelOrderExtension(ApexPages.StandardController controller) {
this.sbo = (Siebel_Order__c)controller.getRecord();
}
public Pagereference save() {
        try {
            insert this.sbo;
            return new pagereference('/' + ApexPages.currentPage().getParameters().get('retURL') );
        } catch (System.DMLException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }
 }