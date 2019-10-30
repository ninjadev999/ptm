class CreateProfileSocialSitesAgain < ActiveRecord::Migration[5.2]
  def change
    create_table :profile_social_sites do |t|
      t.integer :profile_id
      t.integer :social_site_id
      t.string  :url
      t.timestamps

      t.references :profile, foreign_key: true
      t.references :social_site, foreign_key: true
    end
  end
end
