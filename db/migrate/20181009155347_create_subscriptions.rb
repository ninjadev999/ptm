class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.integer :account_id
      t.string :stripe_subscription_id
      t.integer :plan_id
      t.string :status
      t.datetime :trial_start
      t.datetime :trial_end
      t.datetime :current_period_end
      t.datetime :canceled_at

      t.timestamps
    end
    add_index :subscriptions, :account_id
    add_index :subscriptions, :stripe_subscription_id
    add_index :subscriptions, :plan_id
    add_index :subscriptions, :status
  end
end
