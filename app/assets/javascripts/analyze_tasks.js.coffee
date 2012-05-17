jQuery ->
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