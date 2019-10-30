# frozen_string_literal: true

class CreditCardsController < BaseController

  layout 'app'

  def index
    @credit_cards = current_user.credit_cards.all
    @recent_charges = Stripe::Charge.list(limit: 10, customer: current_user.stripe_customer_id)
  end

  def create
    @credit_card = current_user.credit_cards.new(credit_card_params)
    if @credit_card.save
      redirect_to credit_cards_path, notice: "Successfully added credit card."
    else
      redirect_to credit_cards_path, alert: "Issue adding your credit card: #{@credit_card.errors[:token][0]}"
    end
  end

  def destroy
    card = current_user.credit_cards.find_by(id: params[:id])
    if card
      if card.destroy
        return redirect_to credit_cards_path, notice: "Successfully removed credit card."
      else
        return redirect_to credit_cards_path, alert: "Couldn't remove that card for some reason."
      end
    end
    redirect_to credit_cards_path, notice: "Card not found."
  end

private

  def credit_card_params
    params.require(:credit_card).permit(:token)
  end
end
