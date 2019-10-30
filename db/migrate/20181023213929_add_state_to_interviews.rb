class AddStateToInterviews < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :state, :integer, default: 0
    add_index :interviews, :state
  end
end
