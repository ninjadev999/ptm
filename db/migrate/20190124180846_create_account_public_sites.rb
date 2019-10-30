class CreateAccountPublicSites < ActiveRecord::Migration[5.2]
  def change
    create_table :account_public_sites do |t|
      t.integer :account_id
      t.integer :public_site_id
      t.string  :url
      t.timestamps

      t.references :account, foreign_key: true
      t.references :public_site, foreign_key: true
    end
  end
end
