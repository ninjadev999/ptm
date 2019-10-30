class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.string :easypost_address_id
      t.string :name
      t.string :street1
      t.string :street2
      t.string :street3
      t.string :city
      t.string :state
      t.string :zip
      t.string :country
      t.string :phone
      t.string :nickname

      t.timestamps
    end
    add_index :addresses, :user_id
    add_index :addresses, :easypost_address_id
  end
end
