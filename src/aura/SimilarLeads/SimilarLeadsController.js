({
    doInit : function(component, event, helper) {
        var action = component.get("c.findLeads");
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var similarLeads = response.getReturnValue();
            component.set("v.similarLeads", similarLeads);
        });
        $A.enqueueAction(action);
    }
})