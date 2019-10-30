class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :twilio_sid
      t.string :name
      t.integer :user_id
      t.string :status

      t.timestamps
    end
    add_index :rooms, :twilio_sid
    add_index :rooms, :user_id
    add_index :rooms, :status
  end
end
