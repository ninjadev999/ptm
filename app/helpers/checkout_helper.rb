# frozen_string_literal: true

module CheckoutHelper

  def checkout_needs_stripe?(interview)
    return true if interview.nil?
    !interview.free
  end

  def checkout_button_string(interview)
    checkout_needs_stripe?(interview) ? 'Complete MY Purchase' : 'Finalize Interview Creation'
  end

end
