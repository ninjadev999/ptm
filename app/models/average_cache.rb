# == Schema Information
#
# Table name: average_caches
#
#  id            :bigint(8)        not null, primary key
#  avg           :float            not null
#  rateable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rateable_id   :bigint(8)
#  rater_id      :bigint(8)
#
# Indexes
#
#  index_average_caches_on_rateable_type_and_rateable_id  (rateable_type,rateable_id)
#  index_average_caches_on_rater_id                       (rater_id)
#

class AverageCache < ActiveRecord::Base
  belongs_to :rater, :class_name => "Account"
  belongs_to :rater, :class_name => "Profile"
  belongs_to :rateable, :polymorphic => true
end
