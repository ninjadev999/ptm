# == Schema Information
#
# Table name: overall_averages
#
#  id            :bigint(8)        not null, primary key
#  overall_avg   :float            not null
#  rateable_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rateable_id   :bigint(8)
#
# Indexes
#
#  index_overall_averages_on_rateable_type_and_rateable_id  (rateable_type,rateable_id)
#

class OverallAverage < ActiveRecord::Base
  belongs_to :rateable, :polymorphic => true
end

