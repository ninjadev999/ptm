class RemoveColumnOnCreditCards < ActiveRecord::Migration[5.2]
  def change
    remove_column :credit_cards, :account_id
  end
end
