class AddFreeToInterview < ActiveRecord::Migration[5.2]
  def change
  	add_column :interviews, :free, :boolean, default: false
  end
end
