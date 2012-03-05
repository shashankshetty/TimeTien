# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#hours").setMask('99')
  $("#minutes").setMask('59')

  $('a.title').cluetip({splitTitle: '|'});

  $("#tags").tablesorter
    widthFixed: false,
    sortList: [
      [0, 0]
    ],
    headers:
      4:
        sorter: false,
        5: sorter: false

