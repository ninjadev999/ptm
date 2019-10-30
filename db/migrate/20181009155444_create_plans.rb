class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.integer :amount_in_cents
      t.string :interval
      t.integer :interval_count
      t.string :nickname
      t.integer :trial_period_days
      t.string :stripe_plan_id

      t.timestamps
    end
    add_index :plans, :stripe_plan_id
  end
end
