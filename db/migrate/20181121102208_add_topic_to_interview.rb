class AddTopicToInterview < ActiveRecord::Migration[5.2]
  def change
    add_reference :interviews, :topic, foreign_key: true
  end
end
