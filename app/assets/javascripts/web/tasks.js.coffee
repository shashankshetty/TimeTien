$.fn.showHideAddTag = () ->
  if($(this).val() == "[new_tag]")
    $("#add_tag").show()
  else
    $("#add_tag").hide()


$.fn.addTag = () ->
  $(this).bind 'change', ->
    $(this).showHideAddTag()

$.fn.selectTaskTypeWithTimes = () ->
  if $(this).is(":checked")
    $(".wnt").hide()
    $(".wt").show()

$.fn.selectTaskTypeWithoutTimes = () ->
  if $(this).is(":checked")
    $(".wnt").show()
    $(".wt").hide()

jQuery ->
  $("#select_tag").showHideAddTag()
  $("#select_tag").addTag()
  $("#tag_id").showHideAddTag()
  $("#tag_id").addTag()

  $('#tasks_tab a:first').tab('show')

  $("#task_type_wt").selectTaskTypeWithTimes()
  $("#task_type_wt").click(() ->
     $(this).selectTaskTypeWithTimes()
  )
  $("#task_type_wnt").selectTaskTypeWithoutTimes()
  $("#task_type_wnt").click(() ->
    $(this).selectTaskTypeWithoutTimes()
  )

  $(".cb-enable").click(() ->
    parent = $(this).parents('.switch')
    $('.cb-disable',parent).removeClass('selected')
    $(this).addClass('selected')
  )
  $(".cb-disable").click(() ->
    parent = $(this).parents('.switch')
    $('.cb-enable',parent).removeClass('selected')
    $(this).addClass('selected')
  )

  if ($(this).attr('title').trim() == 'TimeTien - task management')
    $(".title").find('span').remove()

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
        sorter: false

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