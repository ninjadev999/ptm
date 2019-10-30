
$(document).ready(function(){

  // Handle form submission.
  var form = document.getElementById('purchase-addon-seats-form');
  form.addEventListener('submit', function(event) {
    event.preventDefault();
    $("#purchase-seats-button").attr("disabled", true);

    if (confirm("Are you sure? Your card on file will be charged the amount selected.")) {

      var addon_seats_count = $("input:radio.radio-addon-seats:checked").val();
      if (addon_seats_count == 0) {
        $("#addon-form-error-message").html("No addon seat option selected. Please select one or two addon seats as needed for interviewing additional guests.");
        $("#form-errors").show();
        $("#purchase-seats-button").attr("disabled", false);
      } else {
        $("#form-errors").hide();
        var form = document.getElementById('purchase-addon-seats-form');
        form.submit();
      }

    } else {
      $("#purchase-seats-button").attr("disabled", false);
    }

  });

  $('.addon-seats-selection').unbind('click').bind('click', function(e) {
    var ele = $(e.target);
    $('.addon-seats-selection').removeClass('addon-seats-selected');
    ele.closest('.addon-seats-selection').addClass('addon-seats-selected');
  });

});
