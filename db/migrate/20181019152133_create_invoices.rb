class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.integer :account_id
      t.string :stripe_invoice_id
      t.jsonb :stripe_data
      t.datetime :issued_at
      t.datetime :due_date
      t.integer :status
      t.string :number
      t.integer :total_in_cents

      t.timestamps
    end
    add_index :invoices, :account_id
    add_index :invoices, :stripe_invoice_id
    add_index :invoices, :status
    add_index :invoices, :number
  end
end
