class AddPostingToInterview < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :posting, :boolean, null: false, default: false
  end
end
