browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log("Received request: ", request);

    if (request.greeting === "ping")
        sendResponse({ farewell: "pong" });
});
