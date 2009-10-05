$(document).ready(function() {

  $(".add_task.link a").click(function() {
    $(".add_task.link").hide();
    $(".add_task.form").show();
    $(".task_title").val('');
    $(".task_title").removeClass('example');
    $(".task_title").focus();
  });

  $(".add_task.form a").click(function() {
    $(".add_task.form").hide();
    $(".add_task.link").show();
    $(".inputError").hide();
  });

  $(".task_title").blur(function() {
    if (!$(this).val()) {
      $(this).addClass('example');
      $(this).val('Подсказка'); // TODO Изменить значение val
    };
  });

  $(".task_title").click(function() {
    if ($(this).hasClass('example')) {
      $(this).val('');
      $(".task_title").removeClass('example');
    };
  });

});