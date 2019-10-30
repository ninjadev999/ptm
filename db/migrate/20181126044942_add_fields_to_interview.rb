class AddFieldsToInterview < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :read_ahead_opened_at, :datetime
    add_column :interviews, :completed_at, :datetime
    add_column :interviews, :accepted_at, :datetime
  end
end
