# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

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

$.fn.setSearchCriteriaPosition = () ->
  if ($(this).is(':hidden') and $(".info").text() == "")
    $("#main").setPositionRelativeToMe('.search_criteria', 100, -300)
    $(".search_criteria").css('padding-left', '100px')
    $(".search_criteria").css('padding-right', '100px')
  else
    $("#main").setPositionRelativeToMe('.search_criteria', 50, 95)
    $(".search_criteria").css('padding-left', '10px')
    $(".search_criteria").css('padding-right', '10px')

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
  $(".search_criteria").draggable()

  $('#task_results').setSearchCriteriaPosition()
  $('span[id^="over_the_limit"]').formatPerformanceColumn()

  if ($("#task_results").is(":visible"))
    $("#task_results").tablesorter
      widthFixed: false,
      sortList: [
        [0, 0]
      ],
      headers:
        3:
          sorter: false,
          4:
            sorter: false,
            5: sorter: false