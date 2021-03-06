class AddOwnerToCreditCards < ActiveRecord::Migration[5.2]
  def change
    add_column :credit_cards, :owner_id, :integer
    add_column :credit_cards, :owner_type, :string
    add_index :credit_cards, [:owner_id, :owner_type]
    CreditCard.all.each do |credit_card|
      credit_card.update_attributes(:owner_id => credit_card.account_id, owner_type: 'Account')
    end
  end
end
