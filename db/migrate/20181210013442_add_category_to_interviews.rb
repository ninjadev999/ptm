class AddCategoryToInterviews < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :ideal_guest_desc, :text
    add_column :interviews, :ideal_listener_action, :text
    add_column :interviews, :category_id, :integer
  end
end
