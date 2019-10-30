class CreateApplicants < ActiveRecord::Migration[5.2]
  def change
    create_table :applicants do |t|
    	t.references :guest, index: true, foreign_key: { to_table: :users }
    	t.references :interview, index: true, foreign_key: true
    	t.references :invite	
    	t.text :message

    	t.timestamps
    end
  end
end
