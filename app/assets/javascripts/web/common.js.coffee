$.fn.changeTextOnHover = (text) ->
  initial_text = $(this).text()
  $(this).mouseover(() ->
    $(this).text(text)
  )
  $(this).mouseout(() ->
    $(this).text(initial_text)
  )

jQuery ->
  $(".projects").hide()
  $(".project_invites").hide()
  $(".dropdown-toggle").dropdown()
  $(".chzn-select").chosen()

  $(".datetime").datetimepicker(
    {
    ampm: true,
    dateFormat: 'm/d/yy',
    timeFormat: 'h:mm tt'
    showOn: "button",
    buttonImage: "/assets/calendar.gif",
    buttonImageOnly: true
    }
  )

  $(".date").datepicker(
    {
    ampm: true,
    dateFormat: 'm/d/yy',
    showOn: "button",
    buttonImage: "/assets/calendar.gif",
    buttonImageOnly: true
    }
  )

  $('table').hide() if $('table > tbody > tr').length == 0

  $(".btn-font").css("color", "#ffffff")

  $('#about_tab a:first').tab('show')