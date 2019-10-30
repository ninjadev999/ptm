# == Schema Information
#
# Table name: public_sites
#
#  id         :bigint(8)        not null, primary key
#  image_url  :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PublicSite < ApplicationRecord
  has_many :account_public_sites
  has_many :accounts, through: :account_public_sites, dependent: :destroy
end
