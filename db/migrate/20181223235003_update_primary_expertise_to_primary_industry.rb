class UpdatePrimaryExpertiseToPrimaryIndustry < ActiveRecord::Migration[5.2]
  def change
  	rename_column :profiles, :primary_expertise, :primary_industry
  end
end
