$(document).ready(function() {

  $(".task_title").blur(function() {
    if (!$(this).val()) {
      $(this).addClass('example');
      $(this).val('[project] task title @worktype_1 @worktype_n');
    };
  });

  GetTasks();

});

$(".add_task.link a").live('click', function() {
  $(".add_task.link").hide();
  $(".add_task.form").show();
  $(".task_title").val('');
  $(".task_title").removeClass('example');
  $(".task_title").focus();
  return false;
});

$(".add_task.form a").live('click', function() {
  HideTaskForm();
  return false;
});

$(".task_title").live('click', function() {
    if ($(this).hasClass('example')) {
      $(this).val('');
      $(".task_title").removeClass('example');
    };
});

HideTaskForm = function () {
  $(".add_task.form").hide();
  $(".add_task.link").show();
  $("#messages").empty();
};

Check = function(project_name) {
  if (project_name == undefined) {
    return "";
  } else {
    return "["+ project_name +"]";
  };
};

ForCompleteTask = function(worktypes) {
  result = "";
  $.each(worktypes, function() {
    result += "@"+this.name+" ";
  });
  return result;
};

ForUncompleteTask = function(worktypes) {
  result = "";
  $.each(worktypes, function() {
    result += "<a href='' class='worktype' id='"+this.id+"'>"+"@"+this.name+"</a> ";
  });
  return result;
};

GetTasks = function () {
  complete_tasks = [];
  uncomplete_tasks = [];
  $.getJSON('/task', function(json) {
    $.each(json.tasks, function() {
      if (this.complete) { complete_tasks.push(this) }
      else { uncomplete_tasks.push(this) };
    });
    $("#list_complete").fillTemplate(complete_tasks);
    $("#list").fillTemplate(uncomplete_tasks);
    MakeActive();
  });
};

var total_time = 0, active_task_id = undefined;

Stop = function () {
  total_time += task_time;
  $().stopTime();
  $("*").stopTime();
  $(".active").removeClass('active');
  $("#stop").hide();
};

Start = function (active_task) {
  if (active_task.hasClass('worktype')) {
    title = active_task.parent().children("a:first").html() + active_task.html();
  } else {
    title = active_task.html();
  };
  $("#timer_display").everyTime("1s", function (time) {
    task_time = time;
    DrawTime(task_time, $(this));
    DrawTitle(task_time, $("title"), title);
  });
  $("#total_display").everyTime("1s", function (time) {
    time = total_time + time;
    DrawTime(time, $(this));
  });
  $("#timer").addClass('active');
  $(active_task).addClass('active');
  $("#stop").show();
  GetActiveTaskId();
  $.ajax({
    url: '/task/' + active_task_id,
    type: 'PUT',
    data: { 'time_entry[worktype_id]':worktype_id, authenticity_token:authenticity_token },
  });

  $().everyTime("60s", function () {
    $.ajax({
      url: '/task/' + active_task_id + '/ping',
      type: 'PUT',
      data: { authenticity_token:authenticity_token },
    });
  });
};

DrawTitle = function (time, element, title) {
  mins = parseInt(time / 60);
  secs = time % 60;
  if (secs > 9) { element.html("|"+ mins +"."+ secs +"|" + title) }
  else { element.html("|"+ mins +".0"+ secs +"|" + title) };
};

DrawTime = function (time, element) {
  mins = parseInt(time / 60);
  secs = time % 60;
  if (secs > 9) { element.html(mins +"<small>"+"."+ secs + "</small>") }
  else { element.html(mins +"<small>"+".0"+ secs + "</small>")};
  // TODO * label total
};

GetActiveTaskId = function () {
  active_task_id = $("#tasks_list a.active").parent().children(":first").attr("id");
  worktype_id = $("#tasks_list a.active").attr("id");
};

MakeActive = function () {
  if (active_task_id != undefined) {
    if (worktype_id == undefined) {
      element = $("input#"+active_task_id).next();
    } else {
      element = $("input#"+active_task_id).parent().children("a#"+worktype_id);
    };
    element.addClass('active');
  };
};

SendStatus = function () {
  $.ajax({
    url: '/task/' + active_task_id,
    type: 'PUT',
    data: { 'time_entry[status]':true, authenticity_token:authenticity_token },
  });
};

$("#tasks_list a").live('click', function() {
  GetActiveTaskId();
  if ($(this).hasClass('active')) { Stop(); SendStatus() }
  else {
    if (active_task_id != undefined) { Stop(); SendStatus(); Start($(this)) }
    else { Start($(this)) };
  };
  return false;
});

$("#stop").live('click', function() { GetActiveTaskId(); Stop(); SendStatus(); return false });

$(":checkbox").live('click', function() {
  GetActiveTaskId();
  clicked_task_id = $(this).attr('id');
  if (active_task_id != clicked_task_id) {
    $.ajax({
      url: '/task/' + clicked_task_id,
      type: 'PUT',
      data: { 'task[complete]':$(this).attr('checked'), authenticity_token:authenticity_token },
      success: function() {
        GetTasks();
      },
    });
  } else {
    Stop();
    $.ajax({
      url: '/task/' + clicked_task_id,
      type: 'PUT',
      data: { 'task[complete]':$(this).attr('checked'),
              'time_entry[status]':true,
              authenticity_token:authenticity_token },
      success: function() {
        GetTasks();
      },
    });
  };
});

$(".add_task.form form").submit(function() {
  GetActiveTaskId();
  $.ajax({
    url: '/task',
    type: 'POST',
    data: $(this).serialize(),
    success: function() {
      HideTaskForm();
      GetTasks();
    },
    error: function(html) {
      $("#messages").html(html.responseText);
    },
  });
  return false;
});
