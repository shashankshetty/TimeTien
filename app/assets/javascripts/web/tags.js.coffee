jQuery ->
  $("#hours").setMask('99')
  $("#minutes").setMask('59')

  $("a[rel=popover]").popover()

  $("#tags").tablesorter
    widthFixed: false,
    sortList: [
      [0, 0]
    ],
    headers:
      2:
        sorter: false,
      3:
        sorter: false,
      4:
        sorter: false,
      5:
        sorter: false

