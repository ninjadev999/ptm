# Class used to handle one-off charges like for guest seat addons,
#  hardware, transcriptions, etc.
class StripeAddonCharger
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  APPROVED_CODE = 'approved_by_network'
  DECLINED_CODE = 'declined_by_network'

  def initialize(user, interview, credit_card, options = {})
    @user = user
    @interview = interview
    @addon_seats = options[:addon_seats] || 0
    @add_hardware = options[:add_hardware] || false
    @add_transcription = options[:add_transcription] || false
    @options = options
    @charge = nil
    @card_error_message = nil
    @credit_card = credit_card
  end

  # Order total in cents
  def order_total
    total = 0
    total += (ADDON_SEAT_PRICE * @addon_seats)
    if @add_hardware
      total += HARDWARE_ADDON_PRICE
    end
    if @add_transcription
      total += TRANSCRIPTION_PRICE
    end
    total
  end

  def order_total_in_dollars
    Bundle.to_dollars(order_total)
  end

  def order_description
    descriptors = []
    if @addon_seats > 0
      descriptors << pluralize(@addon_seats, 'Additional Addon Seat')
    end
    if @add_hardware
      descriptors << "Remote Studio hardware option"
    end
    if @add_transcription
      descriptors << "Audio transcription option"
    end
    descriptors.to_sentence
  end

  def success?
    return false if @card_error_message.present?
    @charge.outcome.network_status == APPROVED_CODE
  end

  def declined_explanation
    return nil if success?
    return @card_error_message if !@card_error_message.blank?
    reason = "An unknown error caused your transaction to be declined or unprocessed. Please contact us if you believe this to be in error."
    if @charge.outcome.reason == 'expired_card'
      reason = "Your card was declined because it is expired."
    elsif @charge.outcome.reason == 'not_sent_to_network'
      reason = "Your transaction could not be sent to the payment network at this time."
    elsif @charge.outcome.reason == 'card_not_supported'
      reason = "Your card does not support this type of purchase."
    elsif @charge.outcome.reason == 'currency_not_supported'
      reason = "Your card does not support the specified currency (USD)."
    end
    reason
  end

  def info
    @charge
  end

  def charge!
    begin
      @charge = Stripe::Charge.create({
          amount: order_total,
          currency: 'usd',
          customer: @user.stripe_customer_id,
          description: order_description,
          source: @credit_card.stripe_card_id
      })
      puts "\n#{@charge.inspect}\n"
    rescue Stripe::CardError => e
      @card_error_message = e.message
    rescue => e
      @card_error_message = "An unknown error occurred: #{e}"
    end
  end

end