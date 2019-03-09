window.preferred_duty_dates = [];
window.excluded_duty_dates = [];

function toggleWeek(element, date){
  var el = $(element)
  var week_el = el.siblings().addBack();

  var dates = $.map($(week_el), function(element){return $(element).data('date')}).join();
  if(el.hasClass('good')){
    excludeDuty(week_el, dates)
  } else if(el.hasClass('bad')){
    clearDuty(week_el, dates);
  } else {
    includeDuty(week_el, dates);
  }
}

function daysForWeek(week_el){
  var matching_days = $();
  for(var i = 0; i < week_el.length; i++){
    matching_days = matching_days.add($('.fc-day[data-date=' + $(week_el[i]).data('date') + ']'));
  }
  return matching_days;
}

function includeDuty(week_el, dates){
  daysForWeek(week_el).addClass('good');

  var el = $('#renewal_preferential_dates');
  window.preferred_duty_dates.unshift(dates);
  window.excluded_duty_dates = window.excluded_duty_dates.filter(function(d){ return d != dates; });
}

function excludeDuty(week_el, dates){
  daysForWeek(week_el).removeClass('good').addClass('bad');
  window.excluded_duty_dates.unshift(dates);
  window.preferred_duty_dates = window.preferred_duty_dates.filter(function(d){ return d != dates; });
}

function clearDuty(week_el, dates){
  daysForWeek(week_el).removeClass('bad');
  window.preferred_duty_dates = window.preferred_duty_dates.filter(function(d){ return d != dates; });
  window.excluded_duty_dates = window.excluded_duty_dates.filter(function(d){ return d != dates; });
}

function resetDutySelections(event){
  event.preventDefault();
  $('.good, .bad').removeClass('good bad');
  window.excluded_duty_dates = [];
  window.preferred_duty_dates = [];
}

function sectionCallback(a, b, c){
  setTimeout(inputCalendars, 0);
}

function displayCalendars(events){
  if($('.duties-calendar').length == 0){
    return;
  }

  var options = {
    eventSources: events,
    header: {left: 'title', center: '', right: ''},
    titleFormat: 'MMMM',
    fixedWeekCount: false,
    hiddenDays: [ 1, 2, 3, 5 ], // hide Mondays, Wednesdays, and Fridays
    firstDay: 1,
    dayClick: function(date) {
    },
    dayRender: function(date, cell) {
      if(date.day() == 6){ // Saturday
        if(date.date() <= 7 || date.date() > 14){ // Not 2nd Saturday
          disableDate(cell);
        }
      }
      if(date.day() == 4){ // thursday
        if(date.month() < 4 || date.month() > 7){
          disableDate(cell);
        }
      }
    }
  }

  function disableDate(cell){
    var header = $('[data-date=' + cell.data('date') +']')
    header.addClass('fc-disabled');
  }

  $('#april').fullCalendar($.extend({defaultDate: "2019-04-01"}, options));
  $('#may').fullCalendar($.extend({defaultDate: "2019-05-01"}, options));
  $('#june').fullCalendar($.extend({defaultDate: "2019-06-01"}, options));
  $('#july').fullCalendar($.extend({defaultDate: "2019-07-01"}, options));
  $('#august').fullCalendar($.extend({defaultDate: "2019-08-01"}, options));
  $('#september').fullCalendar($.extend({defaultDate: "2019-09-01"}, options));
  $('#october').fullCalendar($.extend({defaultDate: "2019-10-01"}, options));

}

function inputCalendars(){
  if($('section.active a[href="#panel5"]').length == 0){
    return;
  }

  var options = {
    // defaultDate: "2017-04-01",
    header: {left: 'title', center: '', right: ''},
    titleFormat: 'MMMM',
    fixedWeekCount: false,
    hiddenDays: [ 1, 2, 3, 5 ], // hide Mondays, Wednesdays, and Fridays
    firstDay: 1,
    dayClick: function(date) {
      toggleWeek(this, date);
    },
    dayRender: function(date, cell) {
      if(date.day() == 6){ // Saturday
        if(date.date() <= 7 || date.date() > 14){ // Not 2nd Saturday
          disableDate(cell);
        }
      }
      if(date.day() == 4){ // thursday
        if(date.month() < 4 || date.month() > 7){
          disableDate(cell);
        }
      }
    }
  };

  function disableDate(cell){
    var header = $('[data-date=' + cell.data('date') +']')
    header.addClass('fc-disabled');
  }

	$('#april').fullCalendar($.extend({defaultDate: "2019-04-01"}, options));
	$('#may').fullCalendar($.extend({defaultDate: "2019-05-01"}, options));
	$('#june').fullCalendar($.extend({defaultDate: "2019-06-01"}, options));
	$('#july').fullCalendar($.extend({defaultDate: "2019-07-01"}, options));
	$('#august').fullCalendar($.extend({defaultDate: "2019-08-01"}, options));
	$('#september').fullCalendar($.extend({defaultDate: "2019-09-01"}, options));
	$('#october').fullCalendar($.extend({defaultDate: "2019-10-01"}, options));

  // $('#april').fullCalendar('render');
  // $('#may').fullCalendar('render');
  // $('#june').fullCalendar('render');
  // $('#july').fullCalendar('render');
  // $('#august').fullCalendar('render');
  // $('#september').fullCalendar('render');
  // $('#october').fullCalendar('render');
};


$(document).ready(function() {

  // page is now ready, initialize the calendar...
  Foundation.libs.section.settings.callback = sectionCallback;


  // $('#duties-tab').on('click', function (event, tab) {
  // $('#tabs').on('toggled', function (event, tab) {

  $('#reset-button').on('click', resetDutySelections);
});
