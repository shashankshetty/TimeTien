showHideAddTag = () ->
  if($("#select_tag").val() == "[new_tag]")
    $("#add_tag").show()
  else
    $("#add_tag").hide()


$.fn.addTag = () ->
  $("#select_tag").bind 'change', ->
    showHideAddTag()

$.fn.selectTaskTypeWithTimes = () ->
  if $(this).is(":checked")
    $("#task_date").attr("disabled", true)
    $("#time_spent_hours").attr("disabled", true)
    $("#time_spent_minutes").attr("disabled", true)
    $("#start_time").attr("disabled", false)
    $("#end_time").attr("disabled", false)
    $("#time_out_hours").attr("disabled", false)
    $("#time_out_minutes").attr("disabled", false)

$.fn.selectTaskTypeWithoutTimes = () ->
  if $(this).is(":checked")
    $("#start_time").attr("disabled", true)
    $("#end_time").attr("disabled", true)
    $("#time_out_hours").attr("disabled", true)
    $("#time_out_minutes").attr("disabled", true)
    $("#task_date").attr("disabled", false)
    $("#time_spent_hours").attr("disabled", false)
    $("#time_spent_minutes").attr("disabled", false)

jQuery ->
  showHideAddTag()
  $("#select_tag").addTag()
  $('#tasks_tab a:first').tab('show')

  $("#task_type_wt").selectTaskTypeWithTimes()
  $("#task_type_wt").click(() ->
     $(this).selectTaskTypeWithTimes()

  )
  $("#task_type_wnt").selectTaskTypeWithoutTimes()
  $("#task_type_wnt").click(() ->
    $(this).selectTaskTypeWithoutTimes()
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