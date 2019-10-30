//= require action_cable
//= require rails-ujs
//= require activestorage

//= require jquery
//= require jquery_ujs
//= require jquery-ui/widgets/autocomplete
//= require tagit

//= require bootstrap.bundle.min.js
//= require in-view.min.js
//= require sticky-kit.min.js
//= require themed.js
//= require moment.min.js
//= require tempusdominus-bootstrap-4.min.js
//= require jquery.fancybox.min.js
//= require local-time
//= require volume-meter

//= require jquery.raty
//= require ratyrate
//= require_tree ./plugins
//= require_tree ./pages

//= require track_sid.js
//= require interview_prep.js
//= require audiovisual_check.js

$(document).ready(function(){
    $('[data-toggle="tooltip"]').tooltip()

    $("tr[data-link]").on('click', function() {
        window.location = $(this).data("link")
    })

    $('.datetimepicker').each(function(){
      $(this).datetimepicker({
        format: 'YYYY-MM-DDTHH:mmAZZ',
        inline: true,
        sideBySide: true,
        date: moment($(this).val()),
        buttons: {
          showToday: true
        }
      })
    });

    $("form.no-enter-form").on("keypress", function (e) {
        if (e.keyCode == 13) {
            return false;
        }
    });
});
