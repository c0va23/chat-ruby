angular
.module("ChatApp.Controllers", [])
.controller("NewMessage", function($scope, $http, $log){

  $scope.cleanMessage = function(){
    $scope.newMessage = {text: ""};
  };

  $scope.send = function() {
    $log.debug($scope.newMessage);

    $http.post("/messages", $scope.newMessage);

    $scope.cleanMessage();
  };
})
.controller("Messages", function($scope, $log){
  $scope.messages = [];

  var eventSource = new EventSource("/messages");

  eventSource.addEventListener("message", function(messageEvent) {
    var message = angular.fromJson(messageEvent.data);
    $scope.messages.push(message);
    $scope.$apply("messages");
  });

  eventSource.addEventListener("error", function() {
    $log.error(arguments);
  });
});
