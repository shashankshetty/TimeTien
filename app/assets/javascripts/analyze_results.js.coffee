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

jQuery ->
  $(".search_criteria").draggable()

  $("#main").setPositionRelativeToMe('.search_criteria', 50, 95)
  $(".search_criteria").css('padding-left', '10px')
  $(".search_criteria").css('padding-right', '10px')

  $('span[id^="over_the_limit"]').formatPerformanceColumn()
  $('.list_text').css 'color', '#131B3B'
  $("#search_group").multiselect({
  header: false
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

  $("a[id^='delete_']").each(() ->
    $(this).click(() ->
      id = $(this).attr("id").split("_")[1]
      jQuery.post(
        '/delete_analyze_task/'
        {id: id}
      (message) ->
        if (message.status == "success")
          $("#li_" + id).remove()
        $("#message").addClass(message.status)
        $("#message").text(message.text)
      )
    )
  )