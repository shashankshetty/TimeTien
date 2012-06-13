jQuery ->
  $("#search_project").chosen().change(() ->
    jQuery.post(
      '/get_project_tags/'
      {projects: $("#search_project").val()}
    (project_tags) ->
      if $('#search_tag').val() != null
        selected_tags = $('#search_tag').val().toString().split(',')
      $("#search_tag").find('option').remove()
      for project_tag in project_tags
        selected = ""
        if selected_tags != undefined
          for selected_tag in selected_tags
            selected = "selected" if project_tag.id.toString() == selected_tag
        $("#search_tag").append('<option ' + selected + ' value="' + project_tag.id + '">' + project_tag.name + '</option>')
      $("#search_tag").trigger("liszt:updated")
    ))

