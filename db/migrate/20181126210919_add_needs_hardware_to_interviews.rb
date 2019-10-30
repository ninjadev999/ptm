class AddNeedsHardwareToInterviews < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :needs_hardware, :boolean, default: false
    Interview.update_all(needs_hardware: false)
  end
end
