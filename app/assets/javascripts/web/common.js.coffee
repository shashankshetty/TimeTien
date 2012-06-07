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