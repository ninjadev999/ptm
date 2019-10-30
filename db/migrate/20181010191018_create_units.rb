class CreateUnits < ActiveRecord::Migration[5.2]
  def change
    create_table :units do |t|
      t.string :make
      t.string :model
      t.string :serial

      t.timestamps
    end
  end
end
