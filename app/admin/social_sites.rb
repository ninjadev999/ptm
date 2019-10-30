ActiveAdmin.register SocialSite do

  filter :name

  index do
    selectable_column
    id_column
    column :name
    column :image_url
    actions
  end

  permit_params :name, :image_url

end
