var inSeason = function(date){
  return date.getMonth() >= 3 && date.getMonth() <= 9;
};

var thursday = function(date){
  return date.getMonth() >= 4 && date.getMonth() <= 7 && date.getDay() === 4;
};

var nthSaturday = function(date, n){
  return date.getDay() === 6 && (date.getDate() > (7 * (n - 1))) && (date.getDate() <= (7 * (n)));
};

var sailingDay = function(date){
  return inSeason(date) && (date.getDay() === 0 || // Every Sunday
    nthSaturday(date, 2) || nthSaturday(date, 4) || // Odd Saturdays
    thursday(date)); // sailing thursday
};

$( ".datepicker" ).datepicker({
  beforeShowDay: function(date){
    return [sailingDay(date), "", ""];
  },
  firstDay: 1
});