angular
.module("ChatApp.Filters", [])
.filter("parseDate", function(){
  return function(dateStr) {
    return new Date(dateStr);
  };
});
