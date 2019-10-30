class AddReadAheadToInterview < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :read_ahead, :text
  end
end
