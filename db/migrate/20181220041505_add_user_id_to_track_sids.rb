class AddUserIdToTrackSids < ActiveRecord::Migration[5.2]
  def change
    remove_column :track_sids, :host_track
    remove_column :track_sids, :invite_id

    add_column :track_sids, :user_id, :integer

  end
end
