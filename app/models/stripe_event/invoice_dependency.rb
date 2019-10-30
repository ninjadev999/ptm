# frozen_string_literal: true

class StripeEvent
private

  def invoice_created
    Invoice.create_from_stripe(params["data"]["object"]["id"], params["data"]["object"])
  end

  def invoice_marked_uncollectible
    invoice_updated
  end

  def invoice_payment_failed
    invoice_updated
  end

  def invoice_payment_succeeded
    invoice_updated
  end

  def invoice_sent
    invoice_updated
  end

  def invoice_upcoming
  end

  def invoice_updated
    Invoice.update_from_stripe(params["data"]["object"]["id"], params["data"]["object"])
  end

  def invoiceitem_created
    invoice_updated
  end

  def invoiceitem_updated
    invoice_updated
  end

  def invoiceitem_deleted
    invoice_updated
  end
end
