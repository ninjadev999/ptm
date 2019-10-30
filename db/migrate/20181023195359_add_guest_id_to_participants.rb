class AddGuestIdToParticipants < ActiveRecord::Migration[5.2]
  def change
    add_column :participants, :guest_id, :string
    add_index :participants, :guest_id
  end
end
