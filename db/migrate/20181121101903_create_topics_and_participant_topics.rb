class CreateTopicsAndParticipantTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.name
    end
    create_table :participant_topics do |t|
      t.references :participants
      t.references :topics
    end
  end
end
