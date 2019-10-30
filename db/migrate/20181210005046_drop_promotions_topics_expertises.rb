class DropPromotionsTopicsExpertises < ActiveRecord::Migration[5.2]
  def change
  	drop_table :users_promotions
  	drop_table :promotions

  	drop_table :users_topics
  	remove_column :interviews, :topic_id
  	drop_table :topics

  	drop_table :expertises
  	remove_column :profiles, :primary_expertise_id
  	add_column :profiles, :primary_expertise, :string
  end
end
