class AddTwilioDataToInterviews < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :twilio_data, :jsonb, default: {}
    add_column :interviews, :duration_in_seconds, :integer
    add_column :interviews, :size_in_bytes, :integer
  end
end
