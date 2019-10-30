ActiveAdmin.register PublicSite do

  filter :name

  index do
    selectable_column
    id_column
    column :name
    actions
  end

  form do |f|
    f.inputs :name
    f.actions
  end

  permit_params :name

end
