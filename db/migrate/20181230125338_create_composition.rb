class CreateComposition < ActiveRecord::Migration[5.2]
  def change
    create_table :compositions do |t|
      t.integer :interview_id
      t.jsonb :twilio_data
      t.timestamps
    end
  end
end
