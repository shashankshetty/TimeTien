# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$.fn.formatPerformanceColumn = () ->
  $(this).each () ->
    performance = $(this).text()
    if (performance.indexOf("-") == 0)
      $(this).text(performance.substring(1, performance.length))
      $(this).css 'color', '#ff0000'
    else if (performance.indexOf("+") == 0)
      $(this).text(performance.substring(1, performance.length))
      $(this).css 'color', '#00CC00'

$.fn.deleteTask = () ->
  id = $(this).attr("id").split("_")[1]
  jQuery.post(
    '/delete_analyze_task/'
    {id: id}
  (message) ->
    if (message.status == "success")
      $("#li_" + id).css("border", "solid red 1px")
      $("#li_" + id).hide("blind", {direction: "vertical"}, 1000)
      $("#li_" + id).remove()
    $("#message").addClass(message.status)
    $("#message").text(message.text)
  )

jQuery ->
  $(".search_criteria").draggable()

  $('span[id^="over_the_limit"]').formatPerformanceColumn()
  $('.list_text').css 'color', '#131B3B'
  $("#search_group").multiselect({
  selectedList: 2
  })

  $("#search_group").change(() ->
    jQuery.post(
      '/get_group_tags/'
      {groups: $("#search_group").val()}
    (group_tags) ->
      $("#search_tag").multiselect('destroy')
      $("#search_tag").find('option').remove()
      $("#search_tag").append('<option value="' + group_tag.id + '">' + group_tag.name + '</option>') for group_tag in group_tags
      $("#search_tag").multiselect()
    )
  )
  $("#dialog-task").hide()

  $("#dialog-task").dialog({
  autoOpen: false,
  modal: true,
  buttons:
    {
    "OK": ()  ->
      $(this).dialog("close")
      id =  $("#dialog-task").data("linkId")
      $("#" + id).deleteTask()
    "Cancel": () ->
      $(this).dialog("close")
    }
  })

  $("a[id^='delete_']").each(() ->
    $(this).click(() ->
      $("#dialog-task").data("linkId", $(this).attr("id"))
      $("#dialog-task").dialog({ position: 'center' })
      $("#dialog-task").dialog("open")
    )
  )

  $(".current").wrapInner('<a href="#"></a>')