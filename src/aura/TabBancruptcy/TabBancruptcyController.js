({
    init : function(component, event, helper) {
        var navEvent = $A.get("e.force:navigateToList"); 
        navEvent.setParams({ 
            "listViewId": '00B6A0000070O0bUAE',// 
            "listViewName": null,
            "scope": "Account" 
        });
        navEvent.fire();
    }
      
})