class CreateStripEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :strip_events do |t|
      t.string :stripe_event_id
      t.string :kind
      t.text :error

      t.timestamps
    end
    add_index :strip_events, :stripe_event_id
    add_index :strip_events, :kind
  end
end
