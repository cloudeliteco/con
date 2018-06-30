({
	doInit : function(component, event, helper) {
		var action = component.get("c.launchLeadProcess");
        action.setCallback(this, function(response){
            syste.debug('response was...');
            system.debug(response.getReturnValue());
            alert(response.getReturnValue());
            //component.set("v.similarProperties", response.getReturnValue());
        });
        $A.enqueueAction(action);
	}
})