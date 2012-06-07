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
      $("#li_" + id).hide("blind", {direction: "vertical"}, 500)
      $("#li_" + id).remove()
    $("#message").addClass(message.status)
    $("#message").text(message.text)
  )

get_data = () ->
  labels = $("#names").val().split('##')
  total_time = $("#total").val().split('##')

  graph_data = []
  length = labels.length-1
  for i in [0..length]
    graph_data.push({
    label: labels[i],
    data: parseFloat(total_time[i])
    })
  return graph_data

jQuery ->
  $(".draggable").draggable()

  if ($(this).attr('title').trim().indexOf('Search') > 0 || $(this).attr('title').trim().indexOf('Analyze') > 0)
    $("#main").css("width","85%")
    marker_pos = $("#marker").offset()
    main_pos = $(".main-footer").offset()
    if (main_pos.top < marker_pos.top)
      $("#main").css("height",marker_pos.top)


  $('span[id^="over_the_limit"]').formatPerformanceColumn()
  $('.list_text').css 'color', '#131B3B'
  $("#search_project").multiselect({
  selectedList: 2
  })

  $("#search_project").change(() ->
    jQuery.post(
      '/get_project_tags/'
      {projects: $("#search_project").val()}
    (project_tags) ->
      $("#search_tag").multiselect('destroy')
      $("#search_tag").find('option').remove()
      $("#search_tag").append('<option value="' + project_tag.id + '">' + project_tag.name + '</option>') for project_tag in project_tags
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

  $('#chart-modal').modal('hide')
  $('#chart-modal').on('show', () ->
    data = get_data()
    $.plot($("#chart"), data, {
      series: {
        pie: {
            show: true
        }
      },
      legend: {
          show: false
      }
    })
  )