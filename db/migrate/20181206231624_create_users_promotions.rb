class CreateUsersPromotions < ActiveRecord::Migration[5.2]
  def change
    create_table :users_promotions do |t|
      t.references :user, foreign_key: true
      t.references :promotion, foreign_key: true
    end
  end
end
