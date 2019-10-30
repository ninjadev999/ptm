class CreateInterviews < ActiveRecord::Migration[5.2]
  def change
    create_table :interviews do |t|
      t.integer :account_id
      t.integer :user_id
      t.string :twilio_sid
      t.string :code
      t.date :starts_at
      t.string :name

      t.timestamps
    end
    add_index :interviews, :account_id
    add_index :interviews, :user_id
    add_index :interviews, :twilio_sid, unique: true
    add_index :interviews, :code, unique: true
  end
end
