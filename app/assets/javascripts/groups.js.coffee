# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#group_user_tokens").tokenInput("/groups/show.json", {
  crossDomain: false,
  preventDuplicates: true,
  prePopulate: $("#group_user_tokens").data("pre"),
  onAdd: (item) ->
    $("#group_admins").append($("<option></option>").attr("value", item.id).text(item.name))
    $("#group_admins").multiselect("refresh")
  onDelete: (item) ->
    $("#group_admins option[value='" + item.id + "']").remove()
    $("#group_admins").multiselect("refresh")
  })

  $("#groups").tablesorter
    widthFixed: false,
    sortList: [
      [0, 0]
    ],
    headers: 2: sorter: false