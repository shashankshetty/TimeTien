jQuery ->
  $('#tasks_tab a:first').tab('show')

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
        sorter: false