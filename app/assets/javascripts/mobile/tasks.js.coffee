$.fn.addTag = () ->
  $("#select_tag").bind 'change', ->
    if($("#select_tag").val() == "[new_tag]")
      $("#add_tag").show()
    else
      $("#add_tag").hide()

jQuery(document).live('pagecreate', (event) ->
  $("#add_tag").hide()
  $("#select_tag").addTag()
)