class AddInterviewsAvailableToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :interviews_available, :integer, default: 0
    User.update_all(interviews_available: 0)

    add_column :interviews, :addon_seats, :integer, default: 0
    Interview.update_all(addon_seats: 0)
  end
end
