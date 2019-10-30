class CreateInvites < ActiveRecord::Migration[5.2]
  def change
    create_table :invites do |t|
      t.integer :inviter_account_id
      t.integer :interview_id
      t.string :name
      t.string :email
      t.string :confirmation_status, default: 'invited'
      t.timestamps
    end

    add_index :invites, :interview_id

  end
end
