# frozen_string_literal: true

# == Schema Information
#
# Table name: labels
#
#  id                        :bigint(8)        not null, primary key
#  label_url                 :string
#  tracking_number           :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  easypost_postage_label_id :string
#  from_address_id           :integer
#  order_id                  :integer
#  to_address_id             :integer
#
# Indexes
#
#  index_labels_on_easypost_postage_label_id  (easypost_postage_label_id)
#  index_labels_on_from_address_id            (from_address_id)
#  index_labels_on_order_id                   (order_id)
#  index_labels_on_to_address_id              (to_address_id)
#  index_labels_on_tracking_number            (tracking_number)
#


class Label < ApplicationRecord
  belongs_to :to_address, class_name: "Address"
  belongs_to :from_address, class_name: "Address"
  belongs_to :order

  validates_presence_of :tracking_number, :label_url, :easypost_postage_label_id
  validates_uniqueness_of :to_address, scope: [:order_id]

  before_validation :create_label!

  def cancel!
  end

private

  def create_label!
    shipment.buy(rate: shipment.lowest_rate)
    self.assign_attributes(
      tracking_number: shipment.tracker.tracking_code,
      label_url: shipment.postage_label.label_url,
      easypost_postage_label_id: shipment.postage_label.id
    )
  end

  def shipment
    @shipment ||= EasyPost::Shipment.create(
      to_address: to_address.as_easypost_address,
      from_address: from_address.as_easypost_address,
      parcel: order.unit.to_parcel,
      is_return: returning?
    )
  end

  def returning?
    from_address.easypost_address_id == Rails.application.warehouse_address.easypost_address_id
  end
end
