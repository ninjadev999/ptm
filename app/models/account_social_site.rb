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

class AccountSocialSite < ApplicationRecord
  belongs_to :account, inverse_of: :account_social_sites
  belongs_to :social_site

  def name
    social_site.name
  end

  def account_name
    account.name
  end

end
