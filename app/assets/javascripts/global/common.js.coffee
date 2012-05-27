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

  $("#manage_projects").click((event) ->
    $(".project_invites").hide()
    event.stopPropagation()
    left = $(this).position().left - $(this).outerWidth() + 73
    top = $(this).position().top - ($(document).scrollTop() - ($("#menu").outerHeight()) - 5)
    $(".projects").css('top': top, 'left': left)
    $(".projects").show("blind")
  )

  $("#project_invites").click((event) ->
    $(".projects").hide()
    event.stopPropagation()
    left = $(this).position().left - $(this).outerWidth() + 93
    top = $(this).position().top - ($(document).scrollTop() - ($("#menu").outerHeight()) - 5)
    $(".project_invites").css('top': top, 'left': left)
    $(".project_invites").show("blind")
  )

  $("#user_settings").changeTextOnHover("change user settings")

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

  $(".multiselect").multiselect({
  selectedList: 2
  }).multiselectfilter()

  $("input[name^='multiselect_']").each(() ->
    $(this).addClass("multiselect-item")
  )

  $('table').hide() if $('table > tbody > tr').length == 0

  $('.carousel').carousel({
  interval: 5000,
  pause: "hover"
  })