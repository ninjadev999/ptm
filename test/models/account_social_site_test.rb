# == Schema Information
#
# Table name: account_social_sites
#
#  id             :bigint(8)        not null, primary key
#  url            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :bigint(8)
#  social_site_id :bigint(8)
#
# Indexes
#
#  index_account_social_sites_on_account_id      (account_id)
#  index_account_social_sites_on_social_site_id  (social_site_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (social_site_id => social_sites.id)
#

require 'test_helper'

class AccountSocialSiteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
