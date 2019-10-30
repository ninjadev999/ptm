# frozen_string_literal: true

ActiveAdmin.register User do

  permit_params User.attribute_names.except(:update_at, :provider, :uid)

  scope :host, group: :role
  scope :guest, group: :role

  index do

    selectable_column
    id_column
    column :email
    column :full_name
    column :scheduled_interview_count
    column :past_interview_count
    column :created_at
    bool_column :guest
    bool_column :host
    list_column :expertise_list
    list_column :promotion_list
    list_column :topic_list
    column(:primary_industry) { |user| user.profile&.primary_industry }

  end

  show do |user|
    attributes_table do
      #We want to keep the existing columns
      [:id, :email, :first_name, :last_name, :confirmed_at, :bundle_itv_purchased, :single_itv_purchased, :created_at, :guest, :host].each do |column|
        row column
      end
      row :guest_subscription do
        if user.guest_subscription
          link_to "#{user.guest_subscription.plan.position&.titleize}", edit_admin_subscription_path(user.guest_subscription)
        else
          link_to 'Free', new_admin_subscription_path(user_id: user.id, scope: :guest)
        end
      end
      row :host_subscription do
        if user.host_subscription
          link_to "#{user.host_subscription.plan.position&.titleize}", edit_admin_subscription_path(user.host_subscription)
        else
          link_to 'Free', new_admin_subscription_path(user_id: user.id, scope: :host)
        end
      end
      row :login_as do
        link_to "#{user.full_name}", login_as_admin_user_path(user), :target => '_blank'
      end
      row :profile do
        link_to "#{user.full_name}", guest_path(user, view_only: true), :target => '_blank'
      end
    end
  end

  form do |f|
    f.inputs :email, :first_name, :last_name, :confirmed_at, :bundle_itv_purchased, :single_itv_purchased, :created_at, :guest, :host
    f.actions
  end

  # Allows admins to login as a user 
  member_action :login_as, :method => :get do
    user = User.find(params[:id])
    bypass_sign_in user
    redirect_to interviews_path 
  end

end
