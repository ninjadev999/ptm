class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.integer :to_address_id
      t.integer :from_address_id
      t.string :tracking_number
      t.string :label_url
      t.string :easypost_postage_label_id

      t.timestamps
    end
    add_index :labels, :to_address_id
    add_index :labels, :from_address_id
    add_index :labels, :tracking_number
    add_index :labels, :easypost_postage_label_id
  end
end
