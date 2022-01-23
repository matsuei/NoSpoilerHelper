browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("Received request: ", request);
    if (request.type != null) {
        browser.runtime.sendNativeMessage("application.id", {message: "Hello from background page"}, function(response) {
            if (response) {
                const obj = JSON.parse(response);
                if (obj.type) {
                    sendResponse(obj);
                }
                
            }
            
        });
        
    }
    return true;
});

