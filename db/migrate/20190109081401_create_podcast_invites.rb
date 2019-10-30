class CreatePodcastInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :podcast_invites do |t|
      t.belongs_to :account
      t.belongs_to :user
      t.integer :host_id
      t.string :name
      t.string :email
      t.string :confirmation_status, default: 'invited'
      t.integer :status, default: 10
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :code

      t.timestamps
    end
  end
end
