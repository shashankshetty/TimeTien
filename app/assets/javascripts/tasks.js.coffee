# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$.fn.removeColumn = (column) ->
  column = 1 if (!column)
  $('tr td:nth-child(' + column + '), tr th:nth-child(' + column + ')', this).remove()
  return this

addTag = () ->
  $("#add_tag").hide()
  $("#select_tag").bind 'change', ->
    if($("#select_tag").val() == "[new_tag]")
      $("#add_tag").show()
    else
      $("#add_tag").hide()

$.fn.setPositionRelativeToMe = (element, topOffset, leftOffset) ->
  pos = $(this).position()
  width = $(element).width()
  $(element).css({
  position: "absolute",
  top: pos.top + topOffset + "px",
  left: (pos.left - width - leftOffset) + "px"
  })

$.fn.setSearchCriteriaPosition = () ->
  if ($(this).is(':hidden') and $(".info").text() == "")
    $("#main").setPositionRelativeToMe('.search_criteria', 100, -300)
    $(".search_criteria").css('padding-left', '100px')
    $(".search_criteria").css('padding-right', '100px')
  else
    $("#main").setPositionRelativeToMe('.search_criteria', 50, 150)

$.fn.formatPerformanceColumn = () ->
  $(this).each () ->
    performance = $(this).text()
    if (performance.indexOf("-") == 0)
      $(this).text(performance.substring(1, performance.length))
      $(this).css 'color', '#ff0000'
    else if (performance.indexOf("+") == 0)
      $(this).text(performance.substring(1, performance.length))
      $(this).css 'color', '#00CC00'

jQuery ->
  $(".datetime").datetimepicker(
    {
    ampm: true,
    dateFormat: 'd-M-yy',
    showOn: "button",
    buttonImage: "/assets/calendar.gif",
    buttonImageOnly: true
    }
  )
  $('table').hide() if $('table > tbody > tr').length == 0

  addTag()

  # change link text color
  $(".delete, .edit, .stop").each () ->
    $(this).css('color', '#000000')

  $(".search_criteria").draggable()

  $("#tabs").tabs()
  $("#tabs").removeClass("ui-widget-content")

  $('#task_results').setSearchCriteriaPosition()
  $('span[id^="over_the_limit"]').formatPerformanceColumn()

  for element in $("#tabs").children()
    $(element).removeClass("ui-tabs-panel ui-widget-content")

  $("#ongoing_tasks > .tablesorter").tablesorter
    widthFixed: false,
    sortList: [[1, 0]],
    headers:
      2:
        sorter: false,
      3:
        sorter: false,
      4:
        sorter: false

  $("#completed_tasks > .tablesorter").tablesorter
    widthFixed: false,
    sortList: [[1, 0]],
    headers:
      3:
        sorter: false,
      4:
        sorter: false

  $("#task_results").tablesorter
    widthFixed: false,
    sortList: [[0, 0]],
    headers:
      3:
        sorter: false,
      4:
        sorter: false,
      5:
        sorter: false