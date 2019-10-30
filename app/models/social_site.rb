# == Schema Information
#
# Table name: social_sites
#
#  id         :bigint(8)        not null, primary key
#  image_url  :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SocialSite < ApplicationRecord
end
