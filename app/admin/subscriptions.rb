ActiveAdmin.register Subscription do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
	permit_params Subscription.attribute_names.except(:created_at, :update_at)

  index do
    selectable_column
    id_column
    column :user
    column :plan
		actions
  end

  show do |subscription|
    attributes_table do
      row :user
      row :plan
    end
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs do
	    f.input :user
	    f.input :plan_id, as: :select, collection: Plan.send(params[:scope].present? ? params[:scope] : :all).map{|u| [u.position.titleize, u.id]}
    end
    f.actions
  end

  controller do
    def new
      @subscription = Subscription.new(user_id: params[:user_id])
    end

    def create
      @subscription = Subscription.new(params.require(:subscription).permit!)
      if @subscription.send(:unique_plan_for_user_type)
        @subscription.save(validate: false)
        @subscription.send(:create_pro)
        redirect_to edit_admin_subscription_path(@subscription)
      else
        render :new
      end
    end
  end
end
