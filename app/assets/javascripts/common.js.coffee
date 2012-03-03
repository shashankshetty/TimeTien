# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $(".groups").hide()
  $("#manage_groups").click((event) ->
    event.stopPropagation()
    left = $(this).position().left - $(this).outerWidth() + 89
    top = $(this).position().top - ($(document).scrollTop() - ($("#menu").outerHeight()) - 5)
    $(".groups").css('top': top, 'left': left)
    $(".groups").show("blind")
  )

  $("html").click(() ->
    $(".groups").hide()
  )