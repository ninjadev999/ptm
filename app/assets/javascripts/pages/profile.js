// Gem: rails-jquery-autocomplete/lib/assets/javascripts/autocomplete-rails-uncompressed.js
$(document).ready(function(){
  function split( val ) {
    return val.split( ',' );
  }
  function extractLast( term ) {
    return split( term ).pop().replace(/^\s+/,"");
  }

  $('input[data-autocomplete]:not([multiple])').each(function(){
    var e = this;
    $(this).autocomplete({
      source: function( request, response ) {
        var firedFrom = this.element[0];
        var params = {term: extractLast( request.term )};
        if (jQuery(e).attr('data-autocomplete-fields')) {
            jQuery.each(jQuery.parseJSON(jQuery(e).attr('data-autocomplete-fields')), function(field, selector) {
            params[field] = jQuery(selector).val();
          });
        }
        jQuery.getJSON( jQuery(e).attr('data-autocomplete'), params, function() {
          jQuery(arguments[0]).each(function(i, el) {
            var obj = {};
            obj[i] = el;
            jQuery(e).data(obj);
          });
          response.apply(null, arguments);
        });
      }
    });
  });

  $('input[data-autocomplete][multiple]').each(function(){
    var e = this;
    var maxTags = $(this).data('maxTags');
    if (maxTags == null) {
      maxTags = 50;
    }
    var onlyAvailableTags = $(this).data('onlyAvailableTags');
    var availableTags = $(this).val().split(', ');
    $(this).tagit({
      allowSpaces: true,
      tagLimit: maxTags,
      placeholderText: 'Type here',
      autocomplete: {
        source: function( request, response ) {
          var firedFrom = this.element[0];
          var params = {term: extractLast( request.term )};
          if (jQuery(e).attr('data-autocomplete-fields')) {
              jQuery.each(jQuery.parseJSON(jQuery(e).attr('data-autocomplete-fields')), function(field, selector) {
              params[field] = jQuery(selector).val();
            });
          }
          jQuery.getJSON( jQuery(e).attr('data-autocomplete'), params, function() {
            availableTags = [];
            jQuery(arguments[0]).each(function(i, el) {
              var obj = {};
              obj[i] = el;
              availableTags.push(el.value);
              jQuery(e).data(obj);
            });
            response.apply(null, arguments);
          });
        }
      },
      beforeTagAdded: function(event, ui) {
        if (onlyAvailableTags && $.inArray(ui.tagLabel, availableTags)==-1)
          return false;
      }
    });
  });

  $(".ui-widget-content.ui-autocomplete-input").each(function(){
    var $input = $(this);
    var placeholder = $input.attr('placeholder');
    if (placeholder == null) {
      placeholder = '';
    }
    $input.attr('size', Math.max(2, placeholder.length));
    $input.keyup(function(event) {
      var length = $(event.target).val() == '' ? placeholder.length : $(event.target).val().length;
      $(event.target).attr('size', Math.max(2, length));
    });
  });
});