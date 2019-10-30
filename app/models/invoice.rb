# frozen_string_literal: true
# == Schema Information
#
# Table name: invoices
#
#  id                :bigint(8)        not null, primary key
#  due_date          :datetime
#  issued_at         :datetime
#  number            :string
#  status            :integer
#  stripe_data       :jsonb
#  total_in_cents    :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :integer
#  stripe_invoice_id :string
#  user_id           :bigint(8)
#
# Indexes
#
#  index_invoices_on_account_id         (account_id)
#  index_invoices_on_number             (number)
#  index_invoices_on_status             (status)
#  index_invoices_on_stripe_invoice_id  (stripe_invoice_id)
#  index_invoices_on_user_id            (user_id)
#

class Invoice < ApplicationRecord
  enum status: { paid: 1, unpaid: 0, forgiven: 2 }

  # belongs_to :account
  belongs_to :user

  validates_uniqueness_of :stripe_invoice_id

  before_save do
    self.status =
      if stripe_data["forgiven"] == true
        :forgiven
      elsif stripe_data["paid"] == true
        :paid
      else
        :unpaid
      end
    self.issued_at = Time.at(stripe_data["date"])
    dd = stripe_data["due_date"] || stripe_data["date"]
    self.due_date = Time.at(dd)
    self.number ||= stripe_data["number"]
    self.total_in_cents = stripe_data["total"]
  end

  def pay
    as_stripe_invoice.pay
    update_attributes(status: :paid)
  rescue StandardError => e
    errors.add(:base, e.message)
    false
  end

  def payable?
    status == "unpaid"
  end

  def as_stripe_invoice
    @as_stripe_invoice ||= Stripe::Invoice.retrieve(stripe_invoice_id)
  end

  def self.create_from_stripe(stripe_id, _data = {})
    resource = Stripe::Invoice.retrieve(stripe_id)
    user = User.find_by_stripe_customer_id(resource.customer)
    record = find_or_initialize_by(user: user, stripe_invoice_id: stripe_id)
    record.stripe_data = resource.as_json
    record.save!
  end

  def self.update_from_stripe(stripe_id, _data = {})
    create_from_stripe(stripe_id)
  end
end
