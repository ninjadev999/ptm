# == Schema Information
#
# Table name: rating_caches
#
#  id             :bigint(8)        not null, primary key
#  avg            :float            not null
#  cacheable_type :string
#  dimension      :string
#  qty            :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  cacheable_id   :bigint(8)
#
# Indexes
#
#  index_rating_caches_on_cacheable_id_and_cacheable_type  (cacheable_id,cacheable_type)
#  index_rating_caches_on_cacheable_type_and_cacheable_id  (cacheable_type,cacheable_id)
#

class RatingCache < ActiveRecord::Base
  belongs_to :cacheable, :polymorphic => true
end
