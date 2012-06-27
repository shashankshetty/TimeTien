jQuery ->
  if($(".alert").text() != "")
    $("#user_display_name").css("border-color", "red")
    $("#user_time_zone").css("border-color", "red")
    message = $(".alert").text()
    index = message.indexOf(". ")
    $(".alert").html(message.substr(0, index) + '<div style="color:red">' + message.substr(index + 2) + '</div>') if (index > 0)

  if ($(this).attr('title').trim() == 'TimeTien -')
    $(".title").remove();

  $(window).load(() ->
    $('#slider').nivoSlider({
      pauseTime: 5000
    })
  )

  $("#login-modal").modal('hide')

  if ($(this).attr('title').trim().indexOf('forgot your password?') > 0 ||
  $(this).attr('title').trim().indexOf('registration') > 0 ||
  $(this).attr('title').trim().indexOf('about') > 0 ||
  $(this).attr('title').trim().indexOf('privacy policy') > 0)
    $("#login").hide()