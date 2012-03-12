# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

addTag = () ->
  $("#add_tag").hide()
  $("#select_tag").bind 'change', ->
    if($("#select_tag").val() == "[new_tag]")
      $("#add_tag").show()
    else
      $("#add_tag").hide()

jQuery ->
  addTag()

  $("#tabs").tabs()
  $("#tabs").removeClass("ui-widget-content")

  $(".group_invites").draggable()
  $("#main").setPositionRelativeToMe('.group_invites', 530, -800)

  for element in $("#tabs").children()
    $(element).removeClass("ui-tabs-panel ui-widget-content")

  $("#ongoing_tasks > .tablesorter").tablesorter
    widthFixed: false,
    sortList: [
      [1, 0]
    ],
    headers:
      2:
        sorter: false,
        3:
          sorter: false,
          4: sorter: false

  $("#completed_tasks > .tablesorter").tablesorter
    widthFixed: false,
    sortForce: [
      [1, 0]
    ],
    headers:
      3:
        sorter: false,
        4: sorter: false