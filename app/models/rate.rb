# == Schema Information
#
# Table name: rates
#
#  id            :bigint(8)        not null, primary key
#  dimension     :string
#  rateable_type :string
#  stars         :float            not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rateable_id   :bigint(8)
#  rater_id      :bigint(8)
#
# Indexes
#
#  index_rates_on_rateable_id_and_rateable_type  (rateable_id,rateable_type)
#  index_rates_on_rateable_type_and_rateable_id  (rateable_type,rateable_id)
#  index_rates_on_rater_id                       (rater_id)
#

class Rate < ActiveRecord::Base
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true

  #attr_accessible :rate, :dimension

end
