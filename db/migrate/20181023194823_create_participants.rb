class CreateParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :participants do |t|
      t.integer :interview_id
      t.integer :user_id
      t.boolean :guest
      t.string :twilio_sid

      t.timestamps
    end
    add_index :participants, :interview_id
    add_index :participants, :user_id
    add_index :participants, :twilio_sid
  end
end
