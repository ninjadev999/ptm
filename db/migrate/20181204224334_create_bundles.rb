class CreateBundles < ActiveRecord::Migration[5.2]
  def change
    create_table :bundles do |t|
      t.string :name
      t.integer :price_in_cents
      t.integer :number_of_interviews
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
