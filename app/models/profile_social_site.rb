# == Schema Information
#
# Table name: profile_social_sites
#
#  id             :bigint(8)        not null, primary key
#  url            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  profile_id     :bigint(8)
#  social_site_id :bigint(8)
#
# Indexes
#
#  index_profile_social_sites_on_profile_id      (profile_id)
#  index_profile_social_sites_on_social_site_id  (social_site_id)
#
# Foreign Keys
#
#  fk_rails_...  (profile_id => profiles.id)
#  fk_rails_...  (social_site_id => social_sites.id)
#

class ProfileSocialSite < ApplicationRecord
  belongs_to :profile, inverse_of: :profile_social_sites
  belongs_to :social_site

  def name
    social_site.name
  end

  def profile_name
    profile.user.full_name
  end
end
