class StoreAudioVideoTrackSids < ActiveRecord::Migration[5.2]
  def change
    create_table :track_sids do |t|
      t.integer :interview_id
      t.boolean :host_track, boolean: false
      t.integer :invite_id
      t.string :track_sid
      t.integer :track_type, default: 0
      t.timestamps
    end
    add_index :track_sids, :track_sid
  end
end
