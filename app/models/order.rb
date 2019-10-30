# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id                :bigint(8)        not null, primary key
#  aasm_state        :string
#  canceled_at       :datetime
#  company           :string
#  email             :string
#  interview_at      :date
#  name              :string
#  token             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  account_id        :integer
#  address_id        :integer
#  credit_card_id    :integer
#  interviewee_id    :integer
#  return_label_id   :integer
#  shipping_label_id :integer
#  unit_id           :integer
#  user_id           :integer
#
# Indexes
#
#  index_orders_on_aasm_state         (aasm_state)
#  index_orders_on_account_id         (account_id)
#  index_orders_on_address_id         (address_id)
#  index_orders_on_email              (email)
#  index_orders_on_interviewee_id     (interviewee_id)
#  index_orders_on_return_label_id    (return_label_id)
#  index_orders_on_shipping_label_id  (shipping_label_id)
#  index_orders_on_token              (token)
#  index_orders_on_unit_id            (unit_id)
#  index_orders_on_user_id            (user_id)
#


class Order < ApplicationRecord
  include AASM

  aasm do
    state :pending, initial: true
    state :confirmed
    state :processing
    state :packaging
    state :shipping
    state :shipped, after: :notify_user!
    state :delivered
    state :returning
    state :received
    state :completed
    state :canceled

    event :confirm do
      transitions from: :pending, to: :confirmed
    end

    event :process do
      transitions from: :confirmed, to: :processing
    end

    event :package do
      transitions from: :processing, to: :packaging, guard: :unit_assigned?
    end

    event :packaged do
      transitions from: :packaging, to: :shipping, guard: :labels_generated?
    end

    event :ship do
      transitions from: :shipping, to: :shipped
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end

    event :returner do
      transitions from: :delivered, to: :returning
    end

    event :receive do
      transitions from: :returning, to: :received
    end

    event :complete, after_commit: :unassign_unit! do
      transitions from: :received, to: :completed
    end
  end

  belongs_to :account
  belongs_to :user
  belongs_to :unit, optional: true
  belongs_to :interviewee, class_name: "User", optional: true
  belongs_to :shipping_label, class_name: "Label", optional: true
  belongs_to :return_label, class_name: "Label", optional: true
  belongs_to :address, inverse_of: :orders, optional: true

  validate :assignable_unit?

  accepts_nested_attributes_for :address
  validates_presence_of :interview_at, allow_blank: true

  def interview_at=(val)
    write_attribute(:interview_at, DateTime.strptime(val, "%m/%d/%Y")) rescue super
  end

  def finalize=(val)
    if val == "1"
      assign_attributes(aasm_state: "confirmed")
    end
  end

  before_create do
    self.token ||= SecureRandom.hex
  end

  def cancelable?
    editable? && persisted?
  end

  def editable?
    ["pending", "confirmed", "processing", "packaging", "shipping"].include?(aasm_state)
  end

  def steps
    @steps ||= OrderStepper.new(self)
  end

  def canceled?
    canceled_at.present?
  end

  def cancel
    kill_labels!
    update_attributes(canceled_at: DateTime.now, aasm_state: "canceled", unit_id: nil)
  end

  def kill_labels!
    shipping_label.cancel! if shipping_label
    return_label.cancel! if return_label
  end

  def generate_labels!
    generate_shipping_label!
    generate_return_label!
  end

  def generate_shipping_label!
    return true if shipping_label.present?
    label = Label.new(
      to_address_id: address.id,
      from_address_id: Rails.application.warehouse_address.id,
      order: self
    )
    if label.save
      self.update_column(:shipping_label_id, label.id)
    else
      self.errors.add(:base, "Return label error")
      return false
    end
  end

  def generate_return_label!
    return true if return_label.present?
    label = Label.new(from_address_id: address.id, to_address_id: Rails.application.warehouse_address.id, order: self)
    if label.save
      self.update_column(:return_label_id, label.id)
    else
      self.errors.add(:base, "Return label error")
      false
    end
  end

  def unit_assigned?
    unit.present?
  end

  def assignable_unit?
    return true if unit.nil?
    real_unit = Unit.find(unit_id)
    unless real_unit.assignable_to?(self)
      self.errors.add(:unit_id, "is already assigned to an order")
    end
  end

private

  def labels_generated?
    shipping_label.present? && return_label.present?
  end

  def unassign_unit!
    update_column(:unit_id, nil)
  end

  def notify_user!
    false
  end
end
