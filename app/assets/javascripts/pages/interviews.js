// Posted interview navbar
$(function() {
  $('.nav a[href^="' + window.location.hash + '"]').tab('show');
});

$(document).ready(function() {
	$.extend( true, $.fn.dataTable.defaults, {
    "searching": false,
    "paging": false
	} );
    $('.dataTable').DataTable();
} );