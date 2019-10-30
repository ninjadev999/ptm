$(document).ready(function(){

  // console.log("checkout.js loaded ...");

  // Create an instance of Elements.
  var elements = stripe.elements();

  // Custom styling can be passed to options when creating an Element.
  // (Note that this demo uses a wider set of styles than the guide below.)
  var style = {
    base: {
      color: '#32325d',
      lineHeight: '18px',
      fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
      fontSmoothing: 'antialiased',
      fontSize: '16px',
      '::placeholder': {
        color: '#aab7c4'
      }
    },
    invalid: {
      color: '#fa755a',
      iconColor: '#fa755a'
    }
  };

  // Create an instance of the card Element.
  var card = elements.create('card', {style: style});

  // Add an instance of the card Element into the `card-element` <div>.
  card.mount('#card-element');

  // Handle real-time validation errors from the card Element.
  card.addEventListener('change', function(event) {
    var displayError = document.getElementById('card-errors');
    if (event.error) {
      displayError.textContent = event.error.message;
    } else {
      displayError.textContent = '';
    }
  });

  // Handle form submission.
  var form = document.getElementById('payment-form');
  form.addEventListener('submit', function(event) {
    event.preventDefault();
    if ($(".cc-radio:checked").length > 0) {
      document.getElementById('payment-form').submit();
    } else {
      stripe.createToken(card).then(function(result) {
        if (result.error) {
          // Inform the user if there was an error.
          var errorElement = document.getElementById('card-errors');
          errorElement.textContent = result.error.message;
        } else {
          // Send the token to your server.
          stripeTokenHandler(result.token);
        }
      });  
    }
  });
});

// Submit the form with the token ID.
function stripeTokenHandler(token) {
  // Insert the token ID into the form so it gets submitted to the server
  var form = document.getElementById('payment-form');
  var hiddenInput = document.createElement('input');
  hiddenInput.setAttribute('type', 'hidden');
  hiddenInput.setAttribute('name', 'stripeToken');
  hiddenInput.setAttribute('value', token.id);
  form.appendChild(hiddenInput);

  // Submit the form
  form.submit();
}

// Called when a new bundle/pack selection is made
function updateCart() {

  if (window.XHR_ACTIVE) { return; }

  var bundle_id = $("input:radio.radio-bundle:checked").val();
  //var addon_seats = $("input:radio.radio-addon-seats:checked").val();

  window.XHR_ACTIVE = true;

  var jqxhr = $.getJSON( "/checkout/total?bundle_id=" + bundle_id, function(data) {
    //console.log( "/checkout/total response: success" );
    //console.log(data);
    $("#bundle-name").html(data.name);
    $("#bundle-price").html(data.bundle_price_formatted);
    $("#order-total").html(data.total_formatted);
    window.XHR_ACTIVE = false;
  })
    .fail(function() {
      alert("There was a problem updating your cart. Please check your connection and try again momentarily.");
      window.XHR_ACTIVE = false;
    });
}

$(document).ready(function(){

  var XHR_ACTIVE = false;

  $( ".cc-radio" ).change(function() {
    $('#card-collection').hide();

    // Prevent Stripe event error handling from propagating
    // window.addEventListener("submit", function (event) {
    //   event.stopPropagation();
    // }, true);

  });

  $( "#deselect-card" ).click(function() {
    $('.cc-radio').prop('checked', false);
    // Easiest way to re-bind Stripe click handlers for now after they
    //  have been disabled from a card selection.
    // location.reload();
    $('#card-collection').show();
  });

  $('.bundle-selection').unbind('click').bind('click', function(e) {
    var ele = $(e.target);
    $('.bundle-selection').removeClass('bundle-selected');
    ele.closest('.bundle-selection').addClass('bundle-selected');
    // Need to add a slight delay to the updateCart function call
    //  otherwise it executes before the correct radio button is selected
    setTimeout(function(){ updateCart(); }, 300);
  });

});
