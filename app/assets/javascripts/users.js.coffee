# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  if($(".alert").text() != "")
    $("#user_display_name").css("border-color", "red")
    $("#user_time_zone").css("border-color", "red")
    message = $(".alert").text()
    index = message.indexOf(". ")
    $(".alert").html(message.substr(0, index) + '<div style="color:red">' + message.substr(index + 2) + '</div>') if (index > 0)