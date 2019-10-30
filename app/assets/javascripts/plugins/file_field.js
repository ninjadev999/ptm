jQuery(document).ready(function($) {
	$('input[type="file"]').change(function() {
		var s = $(this).val();
		console.warn(s);
		console.warn($(this).parent().find('input + label > span'));
		$(this).parent().find('input + label > span').text(s.replace(/^.*[\\\/]/, ''));
	});
});