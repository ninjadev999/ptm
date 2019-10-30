class RenameTable < ActiveRecord::Migration[5.2]
  def change
    remove_index :strip_events, :stripe_event_id
    remove_index :strip_events, :kind
    rename_table :strip_events, :stripe_events
    add_index :stripe_events, :stripe_event_id
    add_index :stripe_events, :kind
  end
end
