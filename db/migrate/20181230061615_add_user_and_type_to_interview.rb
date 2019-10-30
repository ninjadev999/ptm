class AddUserAndTypeToInterview < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :guest_id, :integer
    add_column :interviews, :type, :string

    Invite.update_all(account_id: nil)
    Interview.update_all(type: 'HostInterview')

    change_column_null :interviews, :type, false
    drop_table :applicants
  end
end
