class CreatePublicSites < ActiveRecord::Migration[5.2]
  def change
    create_table :public_sites do |t|
      t.string :name
      t.string :image_url

      t.timestamps
    end

    %w{ Libsyn PodBean BuzzSprout Blubrry SoundCloud PodOmatic Spreaker Itunes }.each do |e|
      PublicSite.create(name: e)
    end
  end
end
