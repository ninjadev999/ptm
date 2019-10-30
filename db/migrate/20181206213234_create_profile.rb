class CreateProfile < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.text :bio
      t.integer :primary_expertise_id
      t.references :user, foreign_key: true
    end
  end
end
