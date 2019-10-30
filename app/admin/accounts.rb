# frozen_string_literal: true

ActiveAdmin.register Account, as: "Podcast" do
  permit_params :name, :max_units

  index do
    selectable_column
    id_column
    column :admin
    column :name
    column :scheduled_interview_count
    column :past_interview_count
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :max_units
    end
    f.actions
  end
end
