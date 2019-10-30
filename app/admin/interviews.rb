ActiveAdmin.register Interview do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  scope :hosted, group: :role
  scope :posting, group: :role
  scope :solicited, group: :role

  scope :upcoming, group: :active
  scope :past, group: :active

  scope :free, group: :free

  index do

    selectable_column
    id_column
    column :name
    column('Posted By') {|e| e.user }
    column('Show'){|e| e.account}
    column :starts_at
    tag_column :state

  end

end
