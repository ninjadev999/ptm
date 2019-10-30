class AddBundleInterviewsPurchased < ActiveRecord::Migration[5.2]
  def change
  	rename_column :users, :interviews_available, :single_itv_purchased
  	add_column :users, :bundle_itv_purchased, :integer, default: 0, null: false
  end
end
