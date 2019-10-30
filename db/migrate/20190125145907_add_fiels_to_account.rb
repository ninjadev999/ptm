class AddFielsToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :downloads_per_episode, :bigint
    add_column :accounts, :social_media_followers, :bigint
  end
end
