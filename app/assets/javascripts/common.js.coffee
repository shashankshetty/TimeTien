# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$.fn.showProfile = (text) ->
  initial_text = $(this).text()
  $(this).mouseover(() ->
    $(this).text(text)
  )
  $(this).mouseout(() ->
    $(this).text(initial_text)
  )

$.fn.removeColumn = (column) ->
  column = 1 if (!column)
  $('tr td:nth-child(' + column + '), tr th:nth-child(' + column + ')', this).remove()
  return this

$.fn.setPositionRelativeToMe = (element, topOffset, leftOffset) ->
  pos = $(this).position()
  width = $(element).width()
  $(element).css({
  position: "absolute",
  top: pos.top + topOffset + "px",
  left: (pos.left - width - leftOffset) + "px"
  })

jQuery ->
  $(".groups").hide()
  $(".group_invites").hide()

  $("#manage_groups").click((event) ->
    $(".group_invites").hide()
    event.stopPropagation()
    left = $(this).position().left - $(this).outerWidth() + 73
    top = $(this).position().top - ($(document).scrollTop() - ($("#menu").outerHeight()) - 5)
    $(".groups").css('top': top, 'left': left)
    $(".groups").show("blind")
  )

  $("#group_invites").click((event) ->
    $(".groups").hide()
    event.stopPropagation()
    left = $(this).position().left - $(this).outerWidth() + 93
    top = $(this).position().top - ($(document).scrollTop() - ($("#menu").outerHeight()) - 5)
    $(".group_invites").css('top': top, 'left': left)
    $(".group_invites").show("blind")
  )

  $("html").click(() ->
    $(".groups").hide()
    $(".group_invites").hide()
  )

  $("#user_settings").showProfile("change user settings")

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

  $('table').hide() if $('table > tbody > tr').length == 0