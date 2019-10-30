class RemoveParticipantTables < ActiveRecord::Migration[5.2]

  def up
    drop_table :participant_topics
    drop_table :participants
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

end
