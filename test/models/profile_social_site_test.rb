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

require 'test_helper'

class ProfileSocialSiteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
