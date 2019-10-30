class CreateUsersTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :users_topics do |t|
      t.references :user, foreign_key: true
      t.references :topic, foreign_key: true
    end
  end
end
