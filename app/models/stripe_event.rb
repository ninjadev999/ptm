# frozen_string_literal: true

# == Schema Information
#
# Table name: stripe_events
#
#  id              :bigint(8)        not null, primary key
#  error           :text
#  kind            :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  stripe_event_id :string
#
# Indexes
#
#  index_stripe_events_on_kind             (kind)
#  index_stripe_events_on_stripe_event_id  (stripe_event_id)
#


class StripeEvent < ApplicationRecord
  require_dependency 'stripe_event/customer_dependency'
  require_dependency 'stripe_event/customer_subscription_dependency'
  require_dependency 'stripe_event/invoice_dependency'
  require_dependency 'stripe_event/plan_dependency'
  require_dependency 'stripe_event/charge_dependency'

  attribute :params, default: {}

  def self.execute(params)
    record = StripeEvent.new(stripe_event_id: params["id"])
    record.kind = params["type"]
    record.params = params.as_json
    begin
      record.execute!
    rescue StandardError => e
      record.update_attributes(error: e.message)
      Rails.logger.error "[Stripe] Event ##{record.id} failed #{e.message}"
    end
  end

  def as_stripe_event
    @as_stripe_event ||= Stripe::Event.retrieve(stripe_event_id)
  end

  def execute!
    self.params = as_stripe_event.as_json if params.empty?
    process
  end

  def process
    send(kind.tr(".", "_"))
  end
end
