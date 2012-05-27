jQuery ->
  $("#project_user_tokens").tokenInput("/get_project_users.json", {
  crossDomain: false,
  preventDuplicates: true,
  prePopulate: $("#project_user_tokens").data("pre"),
  onAdd: (item) ->
    $("#project_admins").append($("<option></option>").attr("value", item.id).text(item.name))
    $("#project_admins").multiselect("refresh")
  onDelete: (item) ->
    $("#project_admins option[value='" + item.id + "']").remove()
    $("#project_admins").multiselect("refresh")
  })

  $("#project_tag_tokens").tokenInput("/get_tags.json", {
  crossDomain: false,
  preventDuplicates: true,
  prePopulate: $("#project_tag_tokens").data("pre")
  })

  $("#projects").tablesorter
    widthFixed: false,
    sortList: [
      [0, 0]
    ],
    headers:
      1:
        sorter: false
      2:
        sorter: false
      3:
        sorter: false