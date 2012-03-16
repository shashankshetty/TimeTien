# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
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