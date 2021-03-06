# == Schema Information
#
# Table name: account_public_sites
#
#  id             :bigint(8)        not null, primary key
#  url            :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  account_id     :bigint(8)
#  public_site_id :bigint(8)
#
# Indexes
#
#  index_account_public_sites_on_account_id      (account_id)
#  index_account_public_sites_on_public_site_id  (public_site_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (public_site_id => public_sites.id)
#

require 'test_helper'

class AccountPublicSiteTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
