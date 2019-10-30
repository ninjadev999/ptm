class CreateAccountSocialSites < ActiveRecord::Migration[5.2]
  def change
    create_table :account_social_sites do |t|
      t.integer :account_id
      t.integer :social_site_id
      t.string  :url
      t.timestamps

      t.references :account, foreign_key: true
      t.references :social_site, foreign_key: true
    end
  end
end
