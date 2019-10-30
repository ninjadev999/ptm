class CreateSocialSites < ActiveRecord::Migration[5.2]
  def change
    create_table :social_sites do |t|
      t.string :name
      t.string :image_url

      t.timestamps
    end

    SocialSite.create(name: 'Facebook', image_url: 'icons/socials/facebook.svg')
    SocialSite.create(name: 'Linkedin', image_url: 'icons/socials/linkedin.svg')
    SocialSite.create(name: 'Twitter', image_url: 'icons/socials/twitter.svg')
    SocialSite.create(name: 'Pinterest', image_url: 'icons/socials/pinterest.svg')
    SocialSite.create(name: 'Tumblr', image_url: 'icons/socials/tumblr.svg')
  end
end
