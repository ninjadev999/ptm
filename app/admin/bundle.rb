# frozen_string_literal: true

ActiveAdmin.register Bundle do
  permit_params :name, :price_in_cents, :number_of_interviews, :status

  index do
    selectable_column
    id_column
    column :name
    column :price_in_cents
    column :number_of_interviews
    column :status
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :price_in_cents
      f.input :number_of_interviews
      f.input :status
    end
    f.actions
  end

end
