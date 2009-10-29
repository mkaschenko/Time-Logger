$(document).ready(function() {

  $(".add_task.link a").click(function() {
    $(".add_task.link").hide();
    $(".add_task.form").show();
    $(".task_title").val('');
    // $(".task_title").removeClass('example');
    $(".task_title").focus();
    return false;
  });

  $(".add_task.form a").click(function() {
    HideTaskForm();
    return false;
  });

  $(".task_title").blur(function() {
    // if (!$(this).val()) {
      // $(this).addClass('example');
      // $(this).val('[project] task title @work type 1 @work type n');
    // };
  });

  $(".task_title").click(function() {
    // if ($(this).hasClass('example')) {
    //   $(this).val('');
    //   $(".task_title").removeClass('example');
    // };
  });

});

HideTaskForm = function () {
  $(".add_task.form").hide();
  $(".add_task.link").show();
  $("#messages").empty();
};

var total_time = 0, task_time = 0; active_task_id = 0;

Stop = function () {
  total_time += task_time;
  $("*").stopTime();
  $(".active").removeClass('active');
  $("#stop").hide();
};

Start = function (active_task) {
  $("#timer_display").everyTime("1s", function (time) { 
    task_time = time;
    DrawTime(task_time, $(this));
    DrawTitle(task_time, $("title"));
  });
  $("#total_display").everyTime("1s", function (time) {
    time = total_time + time;
    DrawTime(time, $(this));
  });
  $("#timer").addClass('active');
  $(active_task).addClass('active');
  $("#stop").show();
};

DrawTitle = function (time, title) {
  mins = parseInt(time / 60);
  secs = time % 60;
  if (secs > 9) { title.html("|"+ mins +"."+ secs +"|" + $("a.active").html()) } 
  else { title.html("|"+ mins +".0"+ secs +"|" + $("a.active").html()) };
};

DrawTime = function (time, element) {
  mins = parseInt(time / 60);
  secs = time % 60;
  if (secs > 9) { element.html(mins +"<small>"+"."+ secs + "</small>") } 
  else { element.html(mins +"<small>"+".0"+ secs + "</small>")};
  // TODO * label total
};

GetActiveTaskId = function () {
  active_task_id = $("#tasks_list a.active").prev().attr('id');
};

SendSpentTime = function () {
  $.ajax({
    url: '/task/' + active_task_id,
    type: 'PUT',
    dataType: 'script',
    data: { 'task[spent_time]':task_time, authenticity_token:authenticity_token },
  });
};

$("#tasks_list a").live('click', function() {
  GetActiveTaskId();
  if ($(this).hasClass('active')) { Stop(); SendSpentTime(); }
  else {
    if (active_task_id != undefined) {
      Stop();
      old_active_task_id = active_task_id;
      old_task_time = task_time;
      Start($(this));
      GetActiveTaskId();
      $.ajax({
        url: '/task/' + old_active_task_id,
        type: 'PUT',
        dataType: 'script',
        data: { 'task[spent_time]':old_task_time, authenticity_token:authenticity_token, active_task_id:active_task_id },
      });
    } else { Start($(this)) };
  };
  return false;
});

$("#stop").live('click', function() { GetActiveTaskId(); Stop(); SendSpentTime(); return false });

$(":checkbox").live('click', function() {
  GetActiveTaskId();
  if (active_task_id != $(this).attr('id')) {
    $.ajax({
      url: '/task/' + $(this).attr('id'),
      type: 'PUT',
      dataType: 'script',
      data: { 'task[complete]':$(this).attr('checked'), authenticity_token:authenticity_token, active_task_id:active_task_id },
    });
  } else {
    Stop();
    $.ajax({
      url: '/task/' + $(this).attr('id'),
      type: 'PUT',
      dataType: 'script',
      data: { 'task[complete]':$(this).attr('checked'), 'task[spent_time]':task_time, authenticity_token:authenticity_token, active_task_id:active_task_id },
    });
  };
});

$(".add_task.form form").submit(function() {
  // GetActiveTaskId();
  $.ajax({
    url: '/task',
    type: 'POST',
    dataType: 'html',
    // data: ( $(this).serialize() + '&active_task_id = '+active_task_id),
    data: $(this).serialize(),

    success: function() {
      HideTaskForm();
    },

    error: function(html) {
      $("#messages").html(html.responseText);
    },

  });
  return false;
});
