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
    if (main_pos.top < (marker_pos.top+100))
      $("#main").css("height", (marker_pos.top + 200))


  $('span[id^="over_the_limit"]').formatPerformanceColumn()
  $('.list_text').css 'color', '#131B3B'

  $("#collapse").collapse('show')

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
        },
        radius: 1,
        label: {
          show: true,
          radius: 1,
          formatter: (label, series) ->
              return '<div style="font-size:8pt;text-align:center;padding:2px;color:white;">'+label+'<br/>'+Math.round(series.percent)+'%</div>';
          ,
          background: {
            opacity: 0.8
          }
        }
      },
      legend: {
          show: false
      }
    })
  )
