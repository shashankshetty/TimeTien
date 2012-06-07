showHideAddTag = () ->
  if($("#select_tag").val() == "[new_tag]")
    $("#add_tag").show()
  else
    $("#add_tag").hide()


$.fn.addTag = () ->
  $("#select_tag").bind 'change', ->
    showHideAddTag()

jQuery ->
  showHideAddTag()
  $("#select_tag").addTag()
  $('#tasks_tab a:first').tab('show')

  if ($(this).attr('title').trim() == 'TimeTien - task management')
      $(".title").find('span').remove();

  $("#ongoing_tasks > .tablesorter").tablesorter
    widthFixed: false,
    headers:
      1:
        sorter: false,
      2:
        sorter: false,
      3:
        sorter: false,
      4:
        sorter: false,
      5:
        sorter: false,

  $("#completed_tasks > .tablesorter").tablesorter
    widthFixed: false,
    headers:
      1:
        sorter: false,
      2:
        sorter: false,
      3:
        sorter: false,
      4:
        sorter: false,
      5:
        sorter: false