class CreateRecordings < ActiveRecord::Migration[5.2]
  def change
    create_table :recordings do |t|
      t.string :twilio_sid
      t.integer :interview_id
      t.jsonb :twilio_data
      t.integer :size_in_bytes
      t.integer :duration_in_seconds

      t.timestamps
    end
    add_index :recordings, :twilio_sid
    add_index :recordings, :interview_id
  end
end
