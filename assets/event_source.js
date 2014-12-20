var eventSource = new EventSource("/messages");

eventSource.addEventListener("message", function(messageEvent) {
  console.log(messageEvent.data);
});

eventSource.addEventListener("error", function() {
  console.log("onerror");
  console.log(arguments);
});
