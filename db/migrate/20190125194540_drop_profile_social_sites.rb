class DropProfileSocialSites < ActiveRecord::Migration[5.2]
  def change
    drop_table :profile_social_sites
  end
end
